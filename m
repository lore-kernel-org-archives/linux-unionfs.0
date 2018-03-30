Return-Path: <jlayton@kernel.org>
Message-ID: <1522417239.4339.21.camel@kernel.org>
Subject: Re: [RFC PATCH 1/2] fs/locks: add flock_setlk to help set flock
From: Jeff Layton <jlayton@kernel.org>
Date: Fri, 30 Mar 2018 09:40:39 -0400
In-Reply-To: <CAOQ4uxgqPrjtw9k2BGNESPRrP=ohLQbHVMrMcoodY0ghOJAWQQ@mail.gmail.com>
References: <20180329090845.39911-1-yangerkun@huawei.com>
	 <1522406769.4339.6.camel@kernel.org>
	 <CAOQ4uxgqPrjtw9k2BGNESPRrP=ohLQbHVMrMcoodY0ghOJAWQQ@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
To: Amir Goldstein <amir73il@gmail.com>
Cc: yangerkun <yangerkun@huawei.com>, Miklos Szeredi <miklos@szeredi.hu>, overlayfs <linux-unionfs@vger.kernel.org>, "zhangyi (F)" <yi.zhang@huawei.com>, Miao Xie <miaoxie@huawei.com>
List-ID: <linux-unionfs@vger.kernel.org>

On Fri, 2018-03-30 at 14:25 +0300, Amir Goldstein wrote:
> On Fri, Mar 30, 2018 at 1:46 PM, Jeff Layton <jlayton@kernel.org> wrote:
> > On Thu, 2018-03-29 at 17:08 +0800, yangerkun wrote:
> > > Split sys_flock(), add flock_setlk() routine to help kernel set
> > > flock easily.
> > > 
> > > Signed-off-by: yangerkun <yangerkun@huawei.com>
> > > ---
> > >  fs/locks.c         | 29 +++++++++++++++++------------
> > >  include/linux/fs.h |  1 +
> > >  2 files changed, 18 insertions(+), 12 deletions(-)
> > > 
> > > diff --git a/fs/locks.c b/fs/locks.c
> > > index d6ff4be..aeef6cf 100644
> > > --- a/fs/locks.c
> > > +++ b/fs/locks.c
> > > @@ -1974,6 +1974,22 @@ int locks_lock_inode_wait(struct inode *inode, struct file_lock *fl)
> > >  }
> > >  EXPORT_SYMBOL(locks_lock_inode_wait);
> > > 
> > > +int flock_setlk(struct file *filp, struct file_lock *lock)
> > > +{
> > > +     int err;
> > > +
> > > +     err = security_file_lock(filp, lock->fl_type);
> > > +     if (err)
> > > +             return err;
> > > +
> > > +     if (filp->f_op->flock && is_remote_lock(filp))
> > > +             return filp->f_op->flock(filp,
> > > +                                     (lock->fl_flags & FL_SLEEP) ? F_SETLKW : F_SETLK,
> > > +                                     lock);
> > > +     else
> > > +             return locks_lock_file_wait(filp, lock);
> > > +}
> > > +
> > >  /**
> > >   *   sys_flock: - flock() system call.
> > >   *   @fd: the file descriptor to lock.
> > > @@ -2019,18 +2035,7 @@ int locks_lock_inode_wait(struct inode *inode, struct file_lock *fl)
> > >       if (can_sleep)
> > >               lock->fl_flags |= FL_SLEEP;
> > > 
> > > -     error = security_file_lock(f.file, lock->fl_type);
> > > -     if (error)
> > > -             goto out_free;
> > > -
> > > -     if (f.file->f_op->flock && is_remote_lock(f.file))
> > > -             error = f.file->f_op->flock(f.file,
> > > -                                       (can_sleep) ? F_SETLKW : F_SETLK,
> > > -                                       lock);
> > > -     else
> > > -             error = locks_lock_file_wait(f.file, lock);
> > > -
> > > - out_free:
> > > +     error = flock_setlk(f.file, lock);
> > >       locks_free_lock(lock);
> > > 
> > >   out_putf:
> > > diff --git a/include/linux/fs.h b/include/linux/fs.h
> > > index 2a81556..3dab90c 100644
> > > --- a/include/linux/fs.h
> > > +++ b/include/linux/fs.h
> > > @@ -1090,6 +1090,7 @@ extern int fcntl_setlk64(unsigned int, struct file *, unsigned int,
> > >  extern int vfs_lock_file(struct file *, unsigned int, struct file_lock *, struct file_lock *);
> > >  extern int vfs_cancel_lock(struct file *filp, struct file_lock *fl);
> > >  extern int locks_lock_inode_wait(struct inode *inode, struct file_lock *fl);
> > > +extern int flock_setlk(struct file *filp, struct file_lock *fl);
> > >  extern int __break_lease(struct inode *inode, unsigned int flags, unsigned int type);
> > >  extern void lease_get_mtime(struct inode *, struct timespec *time);
> > >  extern int generic_setlease(struct file *, long, struct file_lock **, void **priv);
> > 
> > Looks reasonable, but I'm not sure I understand the overall rationale
> > for wanting to do this: What problem are you trying to fix?
> 
> For blockdev filesystems, the usermode tools open the blockdev with
> O_EXCL to prevent mutual access to blockdev by usermode tools
> and kernel mount. This is a (non POSIX?) feature for blockdev described in
> man open(2).
> 
> We would like to have the same useful feature to mutually exclude
> access to overlay layers by fsck.overaly and overlayfs mount.
> 
> I had initially suggested to interpret the (undefined) behavior of
> O_EXCL without O_CREATE for directories similar to that of a blockdev.
> Overlayfs already introduces an inode flag I_OVL_INUSE to mutually
> exclude mounting several overlay with the same upper dir.
> open of directory with O_EXCL could test and set I_OVL_INUSE.
> 
> Then someone suggested to use file locks instead.
> This patch is an RFC for that implementation.
> I am yet uncertain if using file locks for this purpose is a good use of
> proven technology or a mismatch to the requirements.
> What do you think?
> 
> The way that flock is implemented on NFS server side (as well as CIFS)
> is not a big issue IMO. We mostly want to serialize access to those
> directories by tools and overlay mount on the client machine if layer
> are on NFS.
> 

Ok, got it -- thanks.

File locking seems like a better fit than trying to hack new
interpretations on O_EXCL.

My concern with flock locks would be NFS emulates them with POSIX locks.
Thus, flock locks set on a NFS client won't conflict with ones set on
the NFS server. You might also want to consider OFD locks instead (see
fcntl(2), section on Open file description locks).

They have flock-like ownership semantics but may be less problematic if
you need to deal with situations where you (e.g.) have NFS clients using
overlay directories and want tasks on the NFS server to lock them before
altering them.

Cheers,
-- 
Jeff Layton <jlayton@kernel.org>
