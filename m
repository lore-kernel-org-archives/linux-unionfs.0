From: Seth Forshee <seth.forshee@canonical.com>
Subject: Re: [RFC PATCH 6/6] shiftfs: support nested shiftfs mounts
Date: Fri, 2 Nov 2018 07:44:00 -0500
Message-ID: <20181102124400.GB29262@ubuntu-xps13>
References: <20181101214856.4563-1-seth.forshee@canonical.com>
 <20181101214856.4563-7-seth.forshee@canonical.com>
 <CAOQ4uxhkH+0tchHkrgvBZGYzeLD2fGGgtkKstt3JmhPDaGW_dg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <CAOQ4uxhkH+0tchHkrgvBZGYzeLD2fGGgtkKstt3JmhPDaGW_dg@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Amir Goldstein <amir73il@gmail.com>
Cc: linux-fsdevel <linux-fsdevel@vger.kernel.org>, linux-kernel <linux-kernel@vger.kernel.org>, Linux Containers <containers@lists.linux-foundation.org>, James Bottomley <James.Bottomley@hansenpartnership.com>, overlayfs <linux-unionfs@vger.kernel.org>
List-Id: linux-unionfs@vger.kernel.org

On Fri, Nov 02, 2018 at 12:02:45PM +0200, Amir Goldstein wrote:
> On Thu, Nov 1, 2018 at 11:49 PM Seth Forshee <seth.forshee@canonical.com> wrote:
> >
> > shiftfs mounts cannot be nested for two reasons -- global
> > CAP_SYS_ADMIN is required to set up a mark mount, and a single
> > functional shiftfs mount meets the filesystem stacking depth
> > limit.
> >
> > The CAP_SYS_ADMIN requirement can be relaxed. All of the kernel
> > ids in a mount must be within that mount's s_user_ns, so all that
> > is needed is CAP_SYS_ADMIN within that s_user_ns.
> >
> > The stack depth issue can be worked around with a couple of
> > adjustments. First, a mark mount doesn't really need to count
> > against the stacking depth as it doesn't contribute to the call
> > stack depth during filesystem operations. Therefore the mount
> > over the mark mount only needs to count as one more than the
> > lower filesystems stack depth.
> 
> That's true, but it also highlights the point that the "mark" sb is
> completely unneeded and it really is just a nice little hack.
> All the information it really stores is a lower mount reference,
> a lower root dentry and a declarative statement "I am shiftable!".

Seems I should have saved some of the things I said in my previous
response for this one. As you no doubt gleaned from that email, I agree
with this.

> Come to think about it, "container shiftable" really isn't that different from
> NFS export with "no_root_squash" and auto mounted USB drive.
> I mean the shifting itself is different of course, but the
> declaration, not so much.
> If I am allowing sudoers on another machine to mess with root owned
> files visible
> on my machine, I am pretty much have the same issues as container admins
> accessing root owned files on my init_user_ns filesystem. In all those cases,
> I'd better not be executing suid binaries from the untrusted "external" source.
> 
> Instead of mounting a dummy filesystem to make the declaration, you could
> get the same thing with:
>    mount(path, path, "none", MS_BIND | MS_EXTERN | MS_NOEXEC)
> and all you need to do is add MS_EXTERN (MS_SHIFTABLE MS_UNTRUSTED
> or whatnot)  constant to uapi and manage to come up good man page description.
> 
> Then users could actually mount a filesystem in init_user_ns MS_EXTERN and
> avoid the extra bind mount step (for a full filesystem tree export).
> Declaring a mounted image MS_EXTERN has merits on its own even without
> containers and shitfs, for example with pluggable storage. Other LSMs could make
> good use of that declaration.

I'm missing how we figure out the target user ns in this scheme. We need
a context with privileges towards the source path's s_user_ns to say
it's okay to shift ids for the files under the source path, and then we
need a target user ns for the id shifts. Currently the target is
current_user_ns when the final shiftfs mount is created.

So, how do we determine the target s_user_ns in your scheme?

> 
> >
> > Second, when the lower mount is shiftfs we can just skip down to
> > that mount's lower filesystem and shift ids relative to that.
> > There is no reason to shift ids twice, and the lower path has
> > already been marked safe for id shifting by a user privileged
> > towards all ids in that mount's user ns.
> >
> > Signed-off-by: Seth Forshee <seth.forshee@canonical.com>
> > ---
> >  fs/shiftfs.c | 68 +++++++++++++++++++++++++++++++++++-----------------
> >  1 file changed, 46 insertions(+), 22 deletions(-)
> >
> > diff --git a/fs/shiftfs.c b/fs/shiftfs.c
> > index b19af7b2fe75..008ace2842b9 100644
> > --- a/fs/shiftfs.c
> > +++ b/fs/shiftfs.c
> > @@ -930,7 +930,7 @@ static int shiftfs_fill_super(struct super_block *sb, void *raw_data,
> >         struct shiftfs_data *data = raw_data;
> >         char *name = kstrdup(data->path, GFP_KERNEL);
> >         int err = -ENOMEM;
> > -       struct shiftfs_super_info *ssi = NULL;
> > +       struct shiftfs_super_info *ssi = NULL, *mp_ssi;
> >         struct path path;
> >         struct dentry *dentry;
> >
> > @@ -946,11 +946,7 @@ static int shiftfs_fill_super(struct super_block *sb, void *raw_data,
> >         if (err)
> >                 goto out;
> >
> > -       /* to mark a mount point, must be real root */
> > -       if (ssi->mark && !capable(CAP_SYS_ADMIN))
> > -               goto out;
> > -
> > -       /* else to mount a mark, must be userns admin */
> > +       /* to mount a mark, must be userns admin */
> >         if (!ssi->mark && !ns_capable(current_user_ns(), CAP_SYS_ADMIN))
> >                 goto out;
> 
> Isn't this check performed by vfs anyway? i.e. in mount_nodev() -> sget()

Yeah, I noticed that too. I left it in for the moment to emphasize the
change I was making, but it can be removed.

> 
> >
> > @@ -962,41 +958,66 @@ static int shiftfs_fill_super(struct super_block *sb, void *raw_data,
> >
> >         if (!S_ISDIR(path.dentry->d_inode->i_mode)) {
> >                 err = -ENOTDIR;
> > -               goto out_put;
> > -       }
> > -
> > -       sb->s_stack_depth = path.dentry->d_sb->s_stack_depth + 1;
> > -       if (sb->s_stack_depth > FILESYSTEM_MAX_STACK_DEPTH) {
> > -               printk(KERN_ERR "shiftfs: maximum stacking depth exceeded\n");
> > -               err = -EINVAL;
> > -               goto out_put;
> > +               goto out_put_path;
> >         }
> >
> >         if (ssi->mark) {
> > +               struct super_block *lower_sb = path.mnt->mnt_sb;
> > +
> > +               /* to mark a mount point, must root wrt lower s_user_ns */
> > +               if (!ns_capable(lower_sb->s_user_ns, CAP_SYS_ADMIN))
> > +                       goto out_put_path;
> > +
> > +
> >                 /*
> >                  * this part is visible unshifted, so make sure no
> >                  * executables that could be used to give suid
> >                  * privileges
> >                  */
> >                 sb->s_iflags = SB_I_NOEXEC;
> 
> As commented on cover letter, why allow access to any files besides root at all?
> In fact, the only justification for a dummy sb (instead of bind mount with
> MS_EXTERN flag) would be in order to override inode operations with noop ops
> to prevent access to unshifted files from within container.

Summarizing my response to the other message, if the mark mount is kept
(and I would prefer that it isn't kept) that seems reasonable to me.

Thanks,
Seth
