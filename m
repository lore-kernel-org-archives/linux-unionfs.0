From: Amir Goldstein <amir73il@gmail.com>
Subject: Re: [RFC][PATCH 4/4] ovl: allow concurrent copy up data of different files
Date: Sun, 20 Nov 2016 10:27:19 +0200
Message-ID: <CAOQ4uxgQ2yq8EKVVvDJ27XRTMdb75ywdXbx_1dSjFSaPZ_nnpA@mail.gmail.com>
References: <1478979364-10355-1-git-send-email-amir73il@gmail.com>
 <1478979364-10355-5-git-send-email-amir73il@gmail.com> <20161115155643.GA25389@redhat.com>
 <CAOQ4uxgfAu=XXOx34dPDCNEJEKN1L=t3H2PsUdGupfWcc64CVA@mail.gmail.com>
 <20161115215737.GD25389@redhat.com> <CAOQ4uxjJ5b72Lh-CEgsj5rRoW5=c5Vtw65KXVDQedjTzoG0OJw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-fsdevel-owner@vger.kernel.org>
In-Reply-To: <CAOQ4uxjJ5b72Lh-CEgsj5rRoW5=c5Vtw65KXVDQedjTzoG0OJw@mail.gmail.com>
Sender: linux-fsdevel-owner@vger.kernel.org
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: Konstantin Khlebnikov <koct9i@gmail.com>, Al Viro <viro@zeniv.linux.org.uk>, linux-unionfs@vger.kernel.org, linux-fsdevel <linux-fsdevel@vger.kernel.org>, Vivek Goyal <vgoyal@redhat.com>
List-Id: linux-unionfs@vger.kernel.org

On Wed, Nov 16, 2016 at 7:27 AM, Amir Goldstein <amir73il@gmail.com> wrote:
> On Tue, Nov 15, 2016 at 11:57 PM, Vivek Goyal <vgoyal@redhat.com> wrote:
>> On Tue, Nov 15, 2016 at 09:20:32PM +0200, Amir Goldstein wrote:
>>> On Tue, Nov 15, 2016 at 5:56 PM, Vivek Goyal <vgoyal@redhat.com> wrote:
>>> > On Sat, Nov 12, 2016 at 09:36:04PM +0200, Amir Goldstein wrote:
>>> >> Currently, all copy operations are serialized by taking the
>>> >> lock_rename(workdir, upperdir) locks for the entire copy up
>>> >> operation, including the data copy up.
>>> >>
>>> >> Copying up data may take a long time with large files and
>>> >> holding s_vfs_rename_mutex during that time blocks all
>>> >> rename and copy up operations on the entire underlying fs.
>>> >>
>>> >> This change addresses this problem by changing the copy up
>>> >> locking scheme for different types of files as follows.
>>> >>
>>> >> Directories:
>>> >>   <maybe> inode_lock(ovl_inode)
>>> >
>>> > Hi Amir,
>>> >
>>> > What does <maybe> mean here? Is it optional?
>>> >
>>>
>>>
>>> It means that some execution paths inode_lock(ovl_inode) is taken (e.g. rmdir()
>>> of overlay dir) and in some execution paths it is not taken (e.g. when
>>> copying up
>>> the victim inodes' parents).
>>>
>>> What I have not explain properly is that my change does not add any new
>>> inode_lock(ovl_inode) calls for directories and special files - it is taken in
>>> VFS before getting to overlay code.
>>> I listed the inode_lock(ovl_inode) in the locking scheme of directories and
>>> special files to show that is safe (locking order wise) to take the same lock
>>> inside overlay code, for regular files on open.
>>>
>>
>> Ok, got it. Only in case of regular files (non-zero size), we have added
>> the inode_lock(ovl_inode) and that's required because we will be dropping
>> lock_rename() locks temporarily for data copy and want to make sure
>> another thread does not trigger a parallel copy up of same file.
>>
>
> Well, to put it more accurately:
>
> Only in case of regular files open for write and truncate(), we have added
> the inode_lock(ovl_inode).
> The inode_lock(ovl_inode) is required for open for write (no O_TRUNC)
> of regular files (non-zero size), because we will be dropping
> lock_rename() locks temporarily for data copy and want to make sure
> another thread does not trigger a parallel copy up of same file.
>
> So we are taking inode_lock(ovl_inode) for truncate() and open of
> zero sized files for no other reason then keeping the code simpler
> and being able to declare unconditionally above ovl_copy_up{,_open}():
> /* Called with dentry->d_inode lock held */
>
>>> >>     lock_rename(workdir, upperdir)
>>> >>       copy up dir to workdir
>>> >>       move dir to upperdir
>>> >>
>>> >> Special and zero size files:
>>> >>   inode_lock(ovl_inode)
>>> >>     lock_rename(workdir, upperdir)
>>> >>       copy up file to workdir (no data)
>>> >>       move file to upperdir
>>> >>
>>> >
>>> > If we are copying up directories and special and zero file under
>>> > lock_rename() and don't drop it during the whole operation, then
>>> > why do we need to take ovl_inode lock.
>>> >
>>>
>>> So we really don't take it, but for all the call sites of ovl_copy_up()
>>> except for the ovl_d_real() for regular files open, the ovl_inode lock is
>>> already taken in VFS.
>>>
>>> > IOW, current code seems to be just doing lock_rename(workdir, upperdir)
>>> > for the copy up operation. But now this new code also requires
>>> > inode_lock(ovl_inode) and I am trying to understand why.
>>> >
>>>
>>> So inode_lock(ovl_inode) is now taken ALSO in the only path it was not
>>> already taken until now. And the reason that we take it is so we can release
>>> lock_rename() for the duration of copy up data.
>>>
>>> Hope I was able to clarify myself.
>>>
>>> Amir.
>>>


Ping.

Miklos,

Did you get a chance to look at this?
Unless there are any objections, would you mind queuing this up for 4.10?

Thanks,
Amir.



>>> >
>>> >> Regular files with data:
>>> >>   inode_lock(ovl_inode)
>>> >>     lock_rename(workdir, upperdir)
>>> >>       copy up file to workdir (no data)
>>> >>     unlock_rename(workdir, upperdir)
>>> >>       copy data to file in workdir
>>> >>     lock_rename(workdir, upperdir)
>>> >>       move file to upperdir
>>> >>
>>> >> Signed-off-by: Amir Goldstein <amir73il@gmail.com>
>>> >> ---
>>> >>  fs/overlayfs/copy_up.c | 70 +++++++++++++++++++++++++++++++++++++++++++++++---
>>> >>  fs/overlayfs/inode.c   |  3 +++
>>> >>  2 files changed, 69 insertions(+), 4 deletions(-)
>>> >>
>>> >> diff --git a/fs/overlayfs/copy_up.c b/fs/overlayfs/copy_up.c
>>> >> index a16127b..1b9705e 100644
>>> >> --- a/fs/overlayfs/copy_up.c
>>> >> +++ b/fs/overlayfs/copy_up.c
>>> >> @@ -230,6 +230,44 @@ int ovl_set_attr(struct dentry *upperdentry, struct kstat *stat)
>>> >>       return err;
>>> >>  }
>>> >>
>>> >> +/*
>>> >> + * Called with dentry->d_inode lock held only for the last (leaf) copy up
>>> >> + * from __ovl_copy_up(), so it is NOT held when called for ancestor
>>> >> + * directory from __ovl_copy_up()
>>> >> + *
>>> >> + * Called with lock_rename(workdir, upperdir) locks held.
>>> >> + *
>>> >> + * lock_rename() locks remain locked throughout the copy up
>>> >> + * of non regular files and zero sized regular files.
>>> >> + *
>>> >> + * lock_rename() locks are released during ovl_copy_up_data()
>>> >> + * of non zero sized regular files. During this time, the overlay
>>> >> + * dentry->d_inode lock is still held to avoid concurrent
>>> >> + * copy up of files with data.
>>> >> + *
>>> >> + * Maybe a better description of this locking scheme:
>>> >> + *
>>> >> + * Directories:
>>> >> + *   <maybe> inode_lock(ovl_inode)
>>> >> + *     lock_rename(workdir, upperdir)
>>> >> + *       copy up dir to workdir
>>> >> + *       move dir to upperdir
>>> >> + *
>>> >> + * Special and zero size files:
>>> >> + *   inode_lock(ovl_inode)
>>> >> + *     lock_rename(workdir, upperdir)
>>> >> + *       copy up file to workdir (no data)
>>> >> + *       move file to upperdir
>>> >> + *
>>> >> + * Regular files with data:
>>> >> + *  inode_lock(ovl_inode)
>>> >> + *    lock_rename(workdir, upperdir)
>>> >> + *      copy up file to workdir (no data)
>>> >> + *    unlock_rename(workdir, upperdir)
>>> >> + *      copy data to file in workdir
>>> >> + *    lock_rename(workdir, upperdir)
>>> >> + *      move file to upperdir
>>> >> + */
>>> >>  static int ovl_copy_up_locked(struct dentry *workdir, struct dentry *upperdir,
>>> >>                             struct dentry *dentry, struct path *lowerpath,
>>> >>                             struct kstat *stat, const char *link)
>>> >> @@ -274,16 +312,39 @@ static int ovl_copy_up_locked(struct dentry *workdir, struct dentry *upperdir,
>>> >>       if (err)
>>> >>               goto out2;
>>> >>
>>> >> -     if (S_ISREG(stat->mode)) {
>>> >> +     if (S_ISREG(stat->mode) && stat->size > 0) {
>>> >>               struct path upperpath;
>>> >>
>>> >>               ovl_path_upper(dentry, &upperpath);
>>> >>               BUG_ON(upperpath.dentry != NULL);
>>> >>               upperpath.dentry = newdentry;
>>> >>
>>> >> +             /*
>>> >> +              * Release rename locks, because copy data may take a long time,
>>> >> +              * and holding s_vfs_rename_mutex will block all rename and
>>> >> +              * copy up operations on the entire underlying fs.
>>> >> +              * We still hold the overlay inode lock to avoid concurrent
>>> >> +              * copy up of this file.
>>> >> +              */
>>> >> +             unlock_rename(workdir, upperdir);
>>> >> +
>>> >>               err = ovl_copy_up_data(lowerpath, &upperpath, stat->size);
>>> >> +
>>> >> +             /*
>>> >> +              * Re-aquire rename locks, before moving copied file into place.
>>> >> +              */
>>> >> +             if (unlikely(lock_rename(workdir, upperdir) != NULL)) {
>>> >> +                     pr_err("overlayfs: failed to re-aquire lock_rename\n");
>>> >> +                     err = -EIO;
>>> >> +             }
>>> >> +
>>> >>               if (err)
>>> >>                       goto out_cleanup;
>>> >> +
>>> >> +             if (WARN_ON(ovl_dentry_is_upper(dentry))) {
>>> >> +                     /* Raced with another copy-up? This shouldn't happen */
>>> >> +                     goto out_cleanup;
>>> >> +             }
>>> >>       }
>>> >>
>>> >>       err = ovl_copy_xattr(lowerpath->dentry, newdentry);
>>> >> @@ -366,15 +427,14 @@ static int ovl_copy_up_one(struct dentry *parent, struct dentry *dentry,
>>> >>                       return PTR_ERR(link);
>>> >>       }
>>> >>
>>> >> -     err = -EIO;
>>> >> -     if (lock_rename(workdir, upperdir) != NULL) {
>>> >> +     if (unlikely(lock_rename(workdir, upperdir) != NULL)) {
>>> >>               pr_err("overlayfs: failed to lock workdir+upperdir\n");
>>> >> +             err = -EIO;
>>> >>               goto out_unlock;
>>> >>       }
>>> >>
>>> >>       if (ovl_dentry_is_upper(dentry)) {
>>> >>               /* Raced with another copy-up?  Nothing to do, then... */
>>> >> -             err = 0;
>>> >>               goto out_unlock;
>>> >>       }
>>> >>
>>> >> @@ -433,11 +493,13 @@ static int __ovl_copy_up(struct dentry *dentry, int flags)
>>> >>       return err;
>>> >>  }
>>> >>
>>> >> +/* Called with dentry->d_inode lock held */
>>> >>  int ovl_copy_up(struct dentry *dentry)
>>> >>  {
>>> >>       return __ovl_copy_up(dentry, 0);
>>> >>  }
>>> >>
>>> >> +/* Called with dentry->d_inode lock held */
>>> >>  int ovl_copy_up_open(struct dentry *dentry, int flags)
>>> >>  {
>>> >>       return __ovl_copy_up(dentry, flags);
>>> >> diff --git a/fs/overlayfs/inode.c b/fs/overlayfs/inode.c
>>> >> index 7abae00..532b0d5 100644
>>> >> --- a/fs/overlayfs/inode.c
>>> >> +++ b/fs/overlayfs/inode.c
>>> >> @@ -251,11 +251,14 @@ int ovl_open_maybe_copy_up(struct dentry *dentry, unsigned int file_flags)
>>> >>
>>> >>       type = ovl_path_real(dentry, &realpath);
>>> >>       if (ovl_open_need_copy_up(file_flags, type, realpath.dentry)) {
>>> >> +             /* Take the overlay inode lock to avoid concurrent copy-up */
>>> >> +             inode_lock(dentry->d_inode);
>>> >>               err = ovl_want_write(dentry);
>>> >>               if (!err) {
>>> >>                       err = ovl_copy_up_open(dentry, file_flags);
>>> >>                       ovl_drop_write(dentry);
>>> >>               }
>>> >> +             inode_unlock(dentry->d_inode);
>>> >>       }
>>> >>
>>> >>       return err;
>>> >> --
>>> >> 2.7.4
>>> >>
>>> >> --
>>> >> To unsubscribe from this list: send the line "unsubscribe linux-unionfs" in
>>> >> the body of a message to majordomo@vger.kernel.org
>>> >> More majordomo info at  http://vger.kernel.org/majordomo-info.html
