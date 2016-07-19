From: Jeff Layton <jlayton@poochiereds.net>
Subject: Re: [RFC PATCH] locks: fix file locking on overlayfs
Date: Tue, 19 Jul 2016 14:01:51 -0400
Message-ID: <1468951311.7655.20.camel@poochiereds.net>
References: <1468931264-25837-1-git-send-email-mszeredi@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-unionfs-owner@vger.kernel.org>
Received: from mail-qt0-f194.google.com ([209.85.216.194]:36244 "EHLO
	mail-qt0-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753022AbcGSSBz (ORCPT
	<rfc822;linux-unionfs@vger.kernel.org>);
	Tue, 19 Jul 2016 14:01:55 -0400
Received: by mail-qt0-f194.google.com with SMTP id u25so1143280qtb.3
        for <linux-unionfs@vger.kernel.org>; Tue, 19 Jul 2016 11:01:55 -0700 (PDT)
In-Reply-To: <1468931264-25837-1-git-send-email-mszeredi@redhat.com>
Sender: linux-unionfs-owner@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org
To: Miklos Szeredi <mszeredi@redhat.com>, "J. Bruce Fields" <bfields@fieldses.org>, Al Viro <viro@zeniv.linux.org.uk>
Cc: linux-unionfs@vger.kernel.org, linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org

On Tue, 2016-07-19 at 14:27 +0200, Miklos Szeredi wrote:
> This patch allows flock, posix locks, ofd locks and leases to work
> correctly on overlayfs.
>=20
> Instead of using the underlying inode for storing lock context use th=
e
> overlay inode.=C2=A0=C2=A0This allows locks to be persistent across c=
opy-up.
>=20
> This is done by introducing locks_inode() helper and using it instead=
 of
> file_inode() to get the inode in locking code.=C2=A0=C2=A0For non-ove=
rlayfs the two
> are equivalent, except for an extra pointer dereference in locks_inod=
e().
>=20
> Since lock operations are in "struct file_operations" we must also ma=
ke
> sure not to call underlying filesystem's lock operations.=C2=A0=C2=A0=
Introcude a
> super block flag MS_NOREMOTELOCK to this effect.
>=20
> Finally for correct operation of leases i_writecount too needs to be
> modified on the overlay inode.
>=20
> > Signed-off-by: Miklos Szeredi <mszeredi@redhat.com>
> ---
> =C2=A0fs/file_table.c=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0|=C2=A0=C2=A02 +-
> =C2=A0fs/locks.c=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0| 50 +++++++++++++++++++++++++++---------=
-------------
> =C2=A0fs/namespace.c=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0|=C2=A0=C2=A02 +-
> =C2=A0fs/open.c=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0|=C2=A0=C2=A09 +++++----
> =C2=A0fs/overlayfs/super.c=C2=A0=C2=A0=C2=A0=C2=A0|=C2=A0=C2=A02 +-
> =C2=A0include/linux/fs.h=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0| 20 ++++=
++++++++++++----
> =C2=A0include/uapi/linux/fs.h |=C2=A0=C2=A01 +
> =C2=A0kernel/fork.c=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0|=C2=A0=C2=A02 +-
> =C2=A0mm/mmap.c=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0|=C2=A0=C2=A04 ++--
> =C2=A09 files changed, 56 insertions(+), 36 deletions(-)
>=20
> diff --git a/fs/file_table.c b/fs/file_table.c
> index ad17e05ebf95..bb59284c220c 100644
> --- a/fs/file_table.c
> +++ b/fs/file_table.c
> @@ -216,7 +216,7 @@ static void __fput(struct file *file)
> > =C2=A0	if ((file->f_mode & (FMODE_READ | FMODE_WRITE)) =3D=3D FMODE=
_READ)
> > =C2=A0		i_readcount_dec(inode);
> > =C2=A0	if (file->f_mode & FMODE_WRITER) {
> > -		put_write_access(inode);
> > +		put_write_access(locks_inode(file));
> > =C2=A0		__mnt_drop_write(mnt);
> > =C2=A0	}
> > =C2=A0	file->f_path.dentry =3D NULL;
> diff --git a/fs/locks.c b/fs/locks.c
> index ee1b15f6fc13..c1656cff53ee 100644
> --- a/fs/locks.c
> +++ b/fs/locks.c
> @@ -139,6 +139,11 @@
> > =C2=A0#define IS_LEASE(fl)	(fl->fl_flags & (FL_LEASE|FL_DELEG|FL_LA=
YOUT))
> > =C2=A0#define IS_OFDLCK(fl)	(fl->fl_flags & FL_OFDLCK)
> =C2=A0
> +static inline bool is_remote_lock(struct file *filp)
> +{
> > +	return likely(!(filp->f_path.dentry->d_sb->s_flags & MS_NOREMOTEL=
OCK));
> +}
> +
> =C2=A0static bool lease_breaking(struct file_lock *fl)
> =C2=A0{
> > =C2=A0	return fl->fl_flags & (FL_UNLOCK_PENDING | FL_DOWNGRADE_PEND=
ING);
> @@ -791,7 +796,7 @@ posix_test_lock(struct file *filp, struct file_lo=
ck *fl)
> =C2=A0{
> > =C2=A0	struct file_lock *cfl;
> > =C2=A0	struct file_lock_context *ctx;
> > -	struct inode *inode =3D file_inode(filp);
> > +	struct inode *inode =3D locks_inode(filp);
> =C2=A0
> > =C2=A0	ctx =3D smp_load_acquire(&inode->i_flctx);
> > =C2=A0	if (!ctx || list_empty_careful(&ctx->flc_posix)) {
> @@ -1192,7 +1197,7 @@ static int posix_lock_inode(struct inode *inode=
, struct file_lock *request,
> =C2=A0int posix_lock_file(struct file *filp, struct file_lock *fl,
> > =C2=A0			struct file_lock *conflock)
> =C2=A0{
> > -	return posix_lock_inode(file_inode(filp), fl, conflock);
> > +	return posix_lock_inode(locks_inode(filp), fl, conflock);
> =C2=A0}
> =C2=A0EXPORT_SYMBOL(posix_lock_file);
> =C2=A0
> @@ -1232,7 +1237,7 @@ static int posix_lock_inode_wait(struct inode *=
inode, struct file_lock *fl)
> =C2=A0int locks_mandatory_locked(struct file *file)
> =C2=A0{
> > =C2=A0	int ret;
> > -	struct inode *inode =3D file_inode(file);
> > +	struct inode *inode =3D locks_inode(file);
> > =C2=A0	struct file_lock_context *ctx;
> > =C2=A0	struct file_lock *fl;
> =C2=A0
> @@ -1572,7 +1577,7 @@ EXPORT_SYMBOL(lease_get_mtime);
> =C2=A0int fcntl_getlease(struct file *filp)
> =C2=A0{
> > =C2=A0	struct file_lock *fl;
> > -	struct inode *inode =3D file_inode(filp);
> > +	struct inode *inode =3D locks_inode(filp);
> > =C2=A0	struct file_lock_context *ctx;
> > =C2=A0	int type =3D F_UNLCK;
> > =C2=A0	LIST_HEAD(dispose);
> @@ -1580,7 +1585,7 @@ int fcntl_getlease(struct file *filp)
> > =C2=A0	ctx =3D smp_load_acquire(&inode->i_flctx);
> > =C2=A0	if (ctx && !list_empty_careful(&ctx->flc_lease)) {
> > =C2=A0		spin_lock(&ctx->flc_lock);
> > -		time_out_leases(file_inode(filp), &dispose);
> > +		time_out_leases(inode, &dispose);
> > =C2=A0		list_for_each_entry(fl, &ctx->flc_lease, fl_list) {
> > =C2=A0			if (fl->fl_file !=3D filp)
> > =C2=A0				continue;
> @@ -1628,7 +1633,7 @@ generic_add_lease(struct file *filp, long arg, =
struct file_lock **flp, void **pr
> =C2=A0{
> > =C2=A0	struct file_lock *fl, *my_fl =3D NULL, *lease;
> > =C2=A0	struct dentry *dentry =3D filp->f_path.dentry;
> > -	struct inode *inode =3D file_inode(filp);
> > +	struct inode *inode =3D dentry->d_inode;
> > =C2=A0	struct file_lock_context *ctx;
> > =C2=A0	bool is_deleg =3D (*flp)->fl_flags & FL_DELEG;
> > =C2=A0	int error;
> @@ -1742,7 +1747,7 @@ static int generic_delete_lease(struct file *fi=
lp, void *owner)
> =C2=A0{
> > =C2=A0	int error =3D -EAGAIN;
> > =C2=A0	struct file_lock *fl, *victim =3D NULL;
> > -	struct inode *inode =3D file_inode(filp);
> > +	struct inode *inode =3D locks_inode(filp);
> > =C2=A0	struct file_lock_context *ctx;
> > =C2=A0	LIST_HEAD(dispose);
> =C2=A0
> @@ -1782,7 +1787,7 @@ static int generic_delete_lease(struct file *fi=
lp, void *owner)
> =C2=A0int generic_setlease(struct file *filp, long arg, struct file_l=
ock **flp,
> > =C2=A0			void **priv)
> =C2=A0{
> > -	struct inode *inode =3D file_inode(filp);
> > +	struct inode *inode =3D locks_inode(filp);
> > =C2=A0	int error;
> =C2=A0
> > =C2=A0	if ((!uid_eq(current_fsuid(), inode->i_uid)) && !capable(CAP=
_LEASE))
> @@ -1830,7 +1835,7 @@ EXPORT_SYMBOL(generic_setlease);
> =C2=A0int
> =C2=A0vfs_setlease(struct file *filp, long arg, struct file_lock **le=
ase, void **priv)
> =C2=A0{
> > -	if (filp->f_op->setlease)
> > +	if (filp->f_op->setlease && is_remote_lock(filp))
> > =C2=A0		return filp->f_op->setlease(filp, arg, lease, priv);
> > =C2=A0	else
> > =C2=A0		return generic_setlease(filp, arg, lease, priv);
> @@ -1979,7 +1984,7 @@ SYSCALL_DEFINE2(flock, unsigned int, fd, unsign=
ed int, cmd)
> > =C2=A0	if (error)
> > =C2=A0		goto out_free;
> =C2=A0
> > -	if (f.file->f_op->flock)
> > +	if (f.file->f_op->flock && is_remote_lock(f.file))
> > =C2=A0		error =3D f.file->f_op->flock(f.file,
> > =C2=A0					=C2=A0=C2=A0(can_sleep) ? F_SETLKW : F_SETLK,
> > =C2=A0					=C2=A0=C2=A0lock);
> @@ -2005,7 +2010,7 @@ SYSCALL_DEFINE2(flock, unsigned int, fd, unsign=
ed int, cmd)
> =C2=A0 */
> =C2=A0int vfs_test_lock(struct file *filp, struct file_lock *fl)
> =C2=A0{
> > -	if (filp->f_op->lock)
> > +	if (filp->f_op->lock && is_remote_lock(filp))
> > =C2=A0		return filp->f_op->lock(filp, F_GETLK, fl);
> > =C2=A0	posix_test_lock(filp, fl);
> > =C2=A0	return 0;
> @@ -2129,7 +2134,7 @@ out:
> =C2=A0 */
> =C2=A0int vfs_lock_file(struct file *filp, unsigned int cmd, struct f=
ile_lock *fl, struct file_lock *conf)
> =C2=A0{
> > -	if (filp->f_op->lock)
> > +	if (filp->f_op->lock && is_remote_lock(filp))
> > =C2=A0		return filp->f_op->lock(filp, cmd, fl);
> > =C2=A0	else
> > =C2=A0		return posix_lock_file(filp, fl, conf);
> @@ -2191,7 +2196,7 @@ int fcntl_setlk(unsigned int fd, struct file *f=
ilp, unsigned int cmd,
> > =C2=A0	if (file_lock =3D=3D NULL)
> > =C2=A0		return -ENOLCK;
> =C2=A0
> > -	inode =3D file_inode(filp);
> > +	inode =3D locks_inode(filp);
> =C2=A0
> > =C2=A0	/*
> > =C2=A0	=C2=A0* This might block, so we do it before checking the in=
ode.
> @@ -2343,7 +2348,7 @@ int fcntl_setlk64(unsigned int fd, struct file =
*filp, unsigned int cmd,
> > =C2=A0	if (copy_from_user(&flock, l, sizeof(flock)))
> > =C2=A0		goto out;
> =C2=A0
> > -	inode =3D file_inode(filp);
> > +	inode =3D locks_inode(filp);
> =C2=A0
> > =C2=A0	/* Don't allow mandatory locks on files that may be memory m=
apped
> > =C2=A0	=C2=A0* and shared.
> @@ -2426,6 +2431,7 @@ out:
> =C2=A0void locks_remove_posix(struct file *filp, fl_owner_t owner)
> =C2=A0{
> > =C2=A0	int error;
> > +	struct inode *inode =3D locks_inode(filp);
> > =C2=A0	struct file_lock lock;
> > =C2=A0	struct file_lock_context *ctx;
> =C2=A0
> @@ -2434,7 +2440,7 @@ void locks_remove_posix(struct file *filp, fl_o=
wner_t owner)
> > =C2=A0	=C2=A0* posix_lock_file().=C2=A0=C2=A0Another process could =
be setting a lock on this
> > =C2=A0	=C2=A0* file at the same time, but we wouldn't remove that l=
ock anyway.
> > =C2=A0	=C2=A0*/
> > -	ctx =3D=C2=A0=C2=A0smp_load_acquire(&file_inode(filp)->i_flctx);
> > +	ctx =3D=C2=A0=C2=A0smp_load_acquire(&inode->i_flctx);
> > =C2=A0	if (!ctx || list_empty(&ctx->flc_posix))
> > =C2=A0		return;
> =C2=A0
> @@ -2452,7 +2458,7 @@ void locks_remove_posix(struct file *filp, fl_o=
wner_t owner)
> =C2=A0
> > =C2=A0	if (lock.fl_ops && lock.fl_ops->fl_release_private)
> > =C2=A0		lock.fl_ops->fl_release_private(&lock);
> > -	trace_locks_remove_posix(file_inode(filp), &lock, error);
> > +	trace_locks_remove_posix(inode, &lock, error);
> =C2=A0}
> =C2=A0
> =C2=A0EXPORT_SYMBOL(locks_remove_posix);
> @@ -2469,12 +2475,12 @@ locks_remove_flock(struct file *filp, struct =
file_lock_context *flctx)
> > =C2=A0		.fl_type =3D F_UNLCK,
> > =C2=A0		.fl_end =3D OFFSET_MAX,
> > =C2=A0	};
> > -	struct inode *inode =3D file_inode(filp);
> > +	struct inode *inode =3D locks_inode(filp);
> =C2=A0
> > =C2=A0	if (list_empty(&flctx->flc_flock))
> > =C2=A0		return;
> =C2=A0
> > -	if (filp->f_op->flock)
> > +	if (filp->f_op->flock && is_remote_lock(filp))
> > =C2=A0		filp->f_op->flock(filp, F_SETLKW, &fl);
> > =C2=A0	else
> > =C2=A0		flock_lock_inode(inode, &fl);
> @@ -2508,7 +2514,7 @@ void locks_remove_file(struct file *filp)
> =C2=A0{
> > =C2=A0	struct file_lock_context *ctx;
> =C2=A0
> > -	ctx =3D smp_load_acquire(&file_inode(filp)->i_flctx);
> > +	ctx =3D smp_load_acquire(&locks_inode(filp)->i_flctx);
> > =C2=A0	if (!ctx)
> > =C2=A0		return;
> =C2=A0
> @@ -2552,7 +2558,7 @@ EXPORT_SYMBOL(posix_unblock_lock);
> =C2=A0 */
> =C2=A0int vfs_cancel_lock(struct file *filp, struct file_lock *fl)
> =C2=A0{
> > -	if (filp->f_op->lock)
> > +	if (filp->f_op->lock && is_remote_lock(filp))
> > =C2=A0		return filp->f_op->lock(filp, F_CANCELLK, fl);
> > =C2=A0	return 0;
> =C2=A0}
> @@ -2580,7 +2586,7 @@ static void lock_get_status(struct seq_file *f,=
 struct file_lock *fl,
> > =C2=A0		fl_pid =3D fl->fl_pid;
> =C2=A0
> > =C2=A0	if (fl->fl_file !=3D NULL)
> > -		inode =3D file_inode(fl->fl_file);
> > +		inode =3D locks_inode(fl->fl_file);
> =C2=A0
> > =C2=A0	seq_printf(f, "%lld:%s ", id, pfx);
> > =C2=A0	if (IS_POSIX(fl)) {
> @@ -2682,7 +2688,7 @@ static void __show_fd_locks(struct seq_file *f,
> =C2=A0void show_fd_locks(struct seq_file *f,
> > =C2=A0		=C2=A0=C2=A0struct file *filp, struct files_struct *files)
> =C2=A0{
> > -	struct inode *inode =3D file_inode(filp);
> > +	struct inode *inode =3D locks_inode(filp);
> > =C2=A0	struct file_lock_context *ctx;
> > =C2=A0	int id =3D 0;
> =C2=A0
> diff --git a/fs/namespace.c b/fs/namespace.c
> index 419f746d851d..05daf3f98d86 100644
> --- a/fs/namespace.c
> +++ b/fs/namespace.c
> @@ -2722,7 +2722,7 @@ long do_mount(const char *dev_name, const char =
__user *dir_name,
> =C2=A0
> > =C2=A0	flags &=3D ~(MS_NOSUID | MS_NOEXEC | MS_NODEV | MS_ACTIVE | =
MS_BORN |
> > =C2=A0		=C2=A0=C2=A0=C2=A0MS_NOATIME | MS_NODIRATIME | MS_RELATIME|=
 MS_KERNMOUNT |
> > -		=C2=A0=C2=A0=C2=A0MS_STRICTATIME);
> > +		=C2=A0=C2=A0=C2=A0MS_STRICTATIME | MS_NOREMOTELOCK);
> =C2=A0
> > =C2=A0	if (flags & MS_REMOUNT)
> > =C2=A0		retval =3D do_remount(&path, flags & ~MS_REMOUNT, mnt_flags=
,
> diff --git a/fs/open.c b/fs/open.c
> index bf66cf1a9f5c..48f38e33e95b 100644
> --- a/fs/open.c
> +++ b/fs/open.c
> @@ -685,6 +685,7 @@ static int do_dentry_open(struct file *f,
> > =C2=A0			=C2=A0=C2=A0const struct cred *cred)
> =C2=A0{
> > =C2=A0	static const struct file_operations empty_fops =3D {};
> > +	struct inode *lkinode =3D locks_inode(f);
> > =C2=A0	int error;
> =C2=A0
> > =C2=A0	f->f_mode =3D OPEN_FMODE(f->f_flags) | FMODE_LSEEK |
> @@ -701,12 +702,12 @@ static int do_dentry_open(struct file *f,
> > =C2=A0	}
> =C2=A0
> > =C2=A0	if (f->f_mode & FMODE_WRITE && !special_file(inode->i_mode))=
 {
> > -		error =3D get_write_access(inode);
> > +		error =3D get_write_access(lkinode);
> > =C2=A0		if (unlikely(error))
> > =C2=A0			goto cleanup_file;
> > =C2=A0		error =3D __mnt_want_write(f->f_path.mnt);
> > =C2=A0		if (unlikely(error)) {
> > -			put_write_access(inode);
> > +			put_write_access(lkinode);
> > =C2=A0			goto cleanup_file;
> > =C2=A0		}
> > =C2=A0		f->f_mode |=3D FMODE_WRITER;
> @@ -726,7 +727,7 @@ static int do_dentry_open(struct file *f,
> > =C2=A0	if (error)
> > =C2=A0		goto cleanup_all;
> =C2=A0
> > -	error =3D break_lease(inode, f->f_flags);
> > +	error =3D break_lease(lkinode, f->f_flags);
> > =C2=A0	if (error)
> > =C2=A0		goto cleanup_all;
> =C2=A0
> @@ -755,7 +756,7 @@ static int do_dentry_open(struct file *f,
> =C2=A0cleanup_all:
> > =C2=A0	fops_put(f->f_op);
> > =C2=A0	if (f->f_mode & FMODE_WRITER) {
> > -		put_write_access(inode);
> > +		put_write_access(lkinode);
> > =C2=A0		__mnt_drop_write(f->f_path.mnt);
> > =C2=A0	}
> =C2=A0cleanup_file:
> diff --git a/fs/overlayfs/super.c b/fs/overlayfs/super.c
> index ed4aa34211a6..4c91d9ed4689 100644
> --- a/fs/overlayfs/super.c
> +++ b/fs/overlayfs/super.c
> @@ -1280,7 +1280,7 @@ static int ovl_fill_super(struct super_block *s=
b, void *data, int silent)
> > =C2=A0		sb->s_xattr =3D ovl_xattr_noacl_handlers;
> > =C2=A0	sb->s_root =3D root_dentry;
> > =C2=A0	sb->s_fs_info =3D ufs;
> > -	sb->s_flags |=3D MS_POSIXACL;
> > +	sb->s_flags |=3D MS_POSIXACL | MS_NOREMOTELOCK;
> =C2=A0
> > =C2=A0	return 0;
> =C2=A0
> diff --git a/include/linux/fs.h b/include/linux/fs.h
> index bacc0733663c..be919d18fa6a 100644
> --- a/include/linux/fs.h
> +++ b/include/linux/fs.h
> @@ -1090,6 +1090,18 @@ struct file_lock_context {
> =C2=A0
> =C2=A0extern void send_sigio(struct fown_struct *fown, int fd, int ba=
nd);
> =C2=A0
> +/*
> + * Return the inode to use for locking
> + *
> + * For overlayfs this should be the overlay inode, not the real inod=
e returned
> + * by file_inode().=C2=A0=C2=A0For any other fs file_inode(filp) and=
 locks_inode(filp) are
> + * equal.
> + */
> +static inline struct inode *locks_inode(const struct file *f)
> +{
> > +	return f->f_path.dentry->d_inode;
> +}
> +
> =C2=A0#ifdef CONFIG_FILE_LOCKING
> =C2=A0extern int fcntl_getlk(struct file *, unsigned int, struct floc=
k __user *);
> =C2=A0extern int fcntl_setlk(unsigned int, struct file *, unsigned in=
t,
> @@ -1277,7 +1289,7 @@ static inline struct dentry *file_dentry(const =
struct file *file)
> =C2=A0
> =C2=A0static inline int locks_lock_file_wait(struct file *filp, struc=
t file_lock *fl)
> =C2=A0{
> > -	return locks_lock_inode_wait(file_inode(filp), fl);
> > +	return locks_lock_inode_wait(locks_inode(filp), fl);
> =C2=A0}
> =C2=A0
> =C2=A0struct fasync_struct {
> @@ -2132,7 +2144,7 @@ static inline int mandatory_lock(struct inode *=
ino)
> =C2=A0
> =C2=A0static inline int locks_verify_locked(struct file *file)
> =C2=A0{
> > -	if (mandatory_lock(file_inode(file)))
> > +	if (mandatory_lock(locks_inode(file)))
> > =C2=A0		return locks_mandatory_locked(file);
> > =C2=A0	return 0;
> =C2=A0}
> @@ -2584,7 +2596,7 @@ static inline int get_write_access(struct inode=
 *inode)
> =C2=A0}
> =C2=A0static inline int deny_write_access(struct file *file)
> =C2=A0{
> > -	struct inode *inode =3D file_inode(file);
> > +	struct inode *inode =3D locks_inode(file);
> > =C2=A0	return atomic_dec_unless_positive(&inode->i_writecount) ? 0 =
: -ETXTBSY;
> =C2=A0}
> =C2=A0static inline void put_write_access(struct inode * inode)
> @@ -2594,7 +2606,7 @@ static inline void put_write_access(struct inod=
e * inode)
> =C2=A0static inline void allow_write_access(struct file *file)
> =C2=A0{
> > =C2=A0	if (file)
> > -		atomic_inc(&file_inode(file)->i_writecount);
> > +		atomic_inc(&locks_inode(file)->i_writecount);
> =C2=A0}
> =C2=A0static inline bool inode_is_open_for_write(const struct inode *=
inode)
> =C2=A0{
> diff --git a/include/uapi/linux/fs.h b/include/uapi/linux/fs.h
> index 3b00f7c8943f..2473272169f2 100644
> --- a/include/uapi/linux/fs.h
> +++ b/include/uapi/linux/fs.h
> @@ -132,6 +132,7 @@ struct inodes_stat_t {
> > =C2=A0#define MS_LAZYTIME	(1<<25) /* Update the on-disk [acm]times =
lazily */
> =C2=A0
> =C2=A0/* These sb flags are internal to the kernel */
> > +#define MS_NOREMOTELOCK	(1<<27)
> > =C2=A0#define MS_NOSEC	(1<<28)
> > =C2=A0#define MS_BORN		(1<<29)
> > =C2=A0#define MS_ACTIVE	(1<<30)
> diff --git a/kernel/fork.c b/kernel/fork.c
> index 4a7ec0c6c88c..104d687f63f1 100644
> --- a/kernel/fork.c
> +++ b/kernel/fork.c
> @@ -476,7 +476,7 @@ static int dup_mmap(struct mm_struct *mm, struct =
mm_struct *oldmm)
> > =C2=A0		tmp->vm_userfaultfd_ctx =3D NULL_VM_UFFD_CTX;
> > =C2=A0		file =3D tmp->vm_file;
> > =C2=A0		if (file) {
> > -			struct inode *inode =3D file_inode(file);
> > +			struct inode *inode =3D locks_inode(file);
> > =C2=A0			struct address_space *mapping =3D file->f_mapping;
> =C2=A0
> > > =C2=A0			get_file(file);
> > diff --git a/mm/mmap.c b/mm/mmap.c
> index de2c1769cc68..a023caff19d5 100644
> --- a/mm/mmap.c
> +++ b/mm/mmap.c
> @@ -126,7 +126,7 @@ static void __remove_shared_vm_struct(struct vm_a=
rea_struct *vma,
> > =C2=A0		struct file *file, struct address_space *mapping)
> =C2=A0{
> > =C2=A0	if (vma->vm_flags & VM_DENYWRITE)
> > -		atomic_inc(&file_inode(file)->i_writecount);
> > +		atomic_inc(&locks_inode(file)->i_writecount);
> > =C2=A0	if (vma->vm_flags & VM_SHARED)
> > =C2=A0		mapping_unmap_writable(mapping);
> > =C2=A0

Not sure about this bit with the i_writecount, as it's used for other
things besides file locking. Could this cause problems when accessing
the writable layer while the overlay is active? ISTR that the openwrt
backup instructions have you do exactly that when overlayfs is used.

Other than that, this looks pretty reasonable to me.

> > @@ -537,7 +537,7 @@ static void __vma_link_file(struct vm_area_stru=
ct *vma)
> > =C2=A0		struct address_space *mapping =3D file->f_mapping;
> =C2=A0
> > =C2=A0		if (vma->vm_flags & VM_DENYWRITE)
> > -			atomic_dec(&file_inode(file)->i_writecount);
> > +			atomic_dec(&locks_inode(file)->i_writecount);
> > =C2=A0		if (vma->vm_flags & VM_SHARED)
> > =C2=A0			atomic_inc(&mapping->i_mmap_writable);
> =C2=A0


--=20
Jeff Layton <jlayton@poochiereds.net>
