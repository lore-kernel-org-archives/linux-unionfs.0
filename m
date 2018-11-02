From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: [RFC PATCH 6/6] shiftfs: support nested shiftfs mounts
Date: Fri, 02 Nov 2018 09:57:29 -0700
Message-ID: <1541177849.2872.12.camel@HansenPartnership.com>
References: <20181101214856.4563-1-seth.forshee@canonical.com>
         <20181101214856.4563-7-seth.forshee@canonical.com>
         <CAOQ4uxhkH+0tchHkrgvBZGYzeLD2fGGgtkKstt3JmhPDaGW_dg@mail.gmail.com>
         <20181102124400.GB29262@ubuntu-xps13>
         <CAOQ4uxhbgzYzdRBwbDNBKgjjmM3M=hya5-LJhiKmxxZxOo=2CQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <CAOQ4uxhbgzYzdRBwbDNBKgjjmM3M=hya5-LJhiKmxxZxOo=2CQ@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Amir Goldstein <amir73il@gmail.com>, Seth Forshee <seth.forshee@canonical.com>
Cc: linux-fsdevel <linux-fsdevel@vger.kernel.org>, linux-kernel <linux-kernel@vger.kernel.org>, Linux Containers <containers@lists.linux-foundation.org>, overlayfs <linux-unionfs@vger.kernel.org>
List-Id: linux-unionfs@vger.kernel.org

On Fri, 2018-11-02 at 15:16 +0200, Amir Goldstein wrote:
> On Fri, Nov 2, 2018 at 2:44 PM Seth Forshee <seth.forshee@canonical.c
> om> wrote:
> > 
> > On Fri, Nov 02, 2018 at 12:02:45PM +0200, Amir Goldstein wrote:
> > > On Thu, Nov 1, 2018 at 11:49 PM Seth Forshee <seth.forshee@canoni
> > > cal.com> wrote:
> > > > 
> > > > shiftfs mounts cannot be nested for two reasons -- global
> > > > CAP_SYS_ADMIN is required to set up a mark mount, and a single
> > > > functional shiftfs mount meets the filesystem stacking depth
> > > > limit.
> > > > 
> > > > The CAP_SYS_ADMIN requirement can be relaxed. All of the kernel
> > > > ids in a mount must be within that mount's s_user_ns, so all
> > > > that
> > > > is needed is CAP_SYS_ADMIN within that s_user_ns.
> > > > 
> > > > The stack depth issue can be worked around with a couple of
> > > > adjustments. First, a mark mount doesn't really need to count
> > > > against the stacking depth as it doesn't contribute to the call
> > > > stack depth during filesystem operations. Therefore the mount
> > > > over the mark mount only needs to count as one more than the
> > > > lower filesystems stack depth.
> > > 
> > > That's true, but it also highlights the point that the "mark" sb
> > > is
> > > completely unneeded and it really is just a nice little hack.
> > > All the information it really stores is a lower mount reference,
> > > a lower root dentry and a declarative statement "I am
> > > shiftable!".
> > 
> > Seems I should have saved some of the things I said in my previous
> > response for this one. As you no doubt gleaned from that email, I
> > agree
> > with this.
> > 
> > > Come to think about it, "container shiftable" really isn't that
> > > different from
> > > NFS export with "no_root_squash" and auto mounted USB drive.
> > > I mean the shifting itself is different of course, but the
> > > declaration, not so much.
> > > If I am allowing sudoers on another machine to mess with root
> > > owned
> > > files visible
> > > on my machine, I am pretty much have the same issues as container
> > > admins
> > > accessing root owned files on my init_user_ns filesystem. In all
> > > those cases,
> > > I'd better not be executing suid binaries from the untrusted
> > > "external" source.
> > > 
> > > Instead of mounting a dummy filesystem to make the declaration,
> > > you could
> > > get the same thing with:
> > >    mount(path, path, "none", MS_BIND | MS_EXTERN | MS_NOEXEC)
> > > and all you need to do is add MS_EXTERN (MS_SHIFTABLE
> > > MS_UNTRUSTED
> > > or whatnot)  constant to uapi and manage to come up good man page
> > > description.
> > > 
> > > Then users could actually mount a filesystem in init_user_ns
> > > MS_EXTERN and
> > > avoid the extra bind mount step (for a full filesystem tree
> > > export).
> > > Declaring a mounted image MS_EXTERN has merits on its own even
> > > without
> > > containers and shitfs, for example with pluggable storage. Other
> > > LSMs could make
> > > good use of that declaration.
> > 
> > I'm missing how we figure out the target user ns in this scheme. We
> > need
> > a context with privileges towards the source path's s_user_ns to
> > say
> > it's okay to shift ids for the files under the source path, and
> > then we
> > need a target user ns for the id shifts. Currently the target is
> > current_user_ns when the final shiftfs mount is created.
> > 
> > So, how do we determine the target s_user_ns in your scheme?
> > 
> 
> Unless I am completely misunderstanding shiftfs, I think we are
> saying the same thing. You said you wish to get rid of the "mark" fs
> and that you had a POC of implementing the "mark" using xattr.

I've got one of these too ... it works nicely.

> I'm just saying another option to implement the mark is using a super
> block flag and you get the target s_user_ns from mnt_sb.

This works a lot less well because the entire mount becomes shiftable,
not just a subtree, which is suboptimal for the unprivileged use case. 
The idea for getting around this was the one Ted mentioned of attaching
properties to the vfsmount structure (he'd like to use this for case
insensitive name comparisons in subtrees), but that requires
rethreading quite a few vfs calls to take a struct path instead of a
struct dentry.

James
