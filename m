From: Chengguang Xu <cgxu519@icloud.com>
Subject: Re: [PATCH v5] ovl: Improving syncfs efficiency
Date: Fri, 19 Jan 2018 10:19:55 +0800
Message-ID: <96114D99-8050-41B5-85E5-A3BCF3DDCDE9@icloud.com>
References: <1516258412-122012-1-git-send-email-cgxu519@icloud.com>
 <20180118120551.y4hsjfdscwfkwxsb@quack2.suse.cz>
Mime-Version: 1.0 (Mac OS X Mail 11.2 \(3445.5.20\))
Content-Type: text/plain; charset=gb2312
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-unionfs-owner@vger.kernel.org>
Received: from pv33p36im-asmtp001.me.com ([17.142.213.62]:23921 "EHLO
        pv33p36im-asmtp001.me.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752855AbeASCUE (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Thu, 18 Jan 2018 21:20:04 -0500
Received: from process-dkim-sign-daemon.pv33p36im-asmtp001.me.com by
 pv33p36im-asmtp001.me.com
 (Oracle Communications Messaging Server 8.0.1.2.20170607 64bit (built Jun  7
 2017)) id <0P2S00P006DR6A00@pv33p36im-asmtp001.me.com> for
 linux-unionfs@vger.kernel.org; Fri, 19 Jan 2018 02:20:03 +0000 (GMT)
In-reply-to: <20180118120551.y4hsjfdscwfkwxsb@quack2.suse.cz>
Sender: linux-unionfs-owner@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org
To: Jan Kara <jack@suse.cz>
Cc: miklos@szeredi.hu, amir73il@gmail.com, linux-unionfs@vger.kernel.org

>=20
> =D4=DA 2018=C4=EA1=D4=C218=C8=D5=A3=AC=CF=C2=CE=E78:05=A3=ACJan Kara =
<jack@suse.cz> =D0=B4=B5=C0=A3=BA
>=20
> On Thu 18-01-18 14:53:32, Chengguang Xu wrote:
>> Currently syncfs(2) call on overlayfs just simply call =
sync_filesystem()
>> on upper_sb to synchronize whole dirty inodes in upper filesystem
>> regardless of the overlay ownership of the inode. In the use case of
>> container, when multiple containers using the same underlying upper
>> filesystem, it has some shortcomings as below.
>>=20
>> (1) Performance
>> Synchronization is probably heavy because it actually syncs =
unnecessary
>> inodes for target overlayfs.
>>=20
>> (2) Interference
>> Unplanned synchronization will probably impact IO performance of
>> unrelated container processes on the other overlayfs.
>>=20
>> This patch iterates upper inode list in overlayfs to only sync target
>> dirty inodes and wait for completion. By doing this, It is able to =
reduce
>> cost of synchronization and will not seriously impact IO performance =
of
>> unrelated processes. In special case, when having very few dirty =
inodes
>> and a lot of clean upper inodes in overlayfs, then iteration may =
waste
>> time so that synchronization is slower than before, but we think the
>> potential for performance improvement far surpass the potential for
>> performance regression in most cases.
>>=20
>> Signed-off-by: Chengguang Xu <cgxu519@icloud.com>
>> ---
>> Changes since v4:
>> - Add syncing operation and deleting from upper_inodes list
>> during ovl inode destruction.
>> - Export symbol of inode_wait_for_writeback() for waiting
>> writeback on ovl inode.
>> - Reuse I_SYNC flag to avoid race conditions between syncfs
>> and drop_inode.
>>=20
>> Changes since v3:
>> - Introduce upper_inode list to organize ovl indoe which has upper =
inode.
>> - Avoid iput operation inside spin lock.
>> - Change list iteration method for safety.
>> - Reuse inode->i_wb_list and sb->s_inodes_wb to save memory.
>> - Modify commit log and add more comments to the code.
>>=20
>> Changes since v2:
>> - Decoupling with syncfs of upper fs by taking sb->s_sync_lock of
>> overlayfs.
>> - Factoring out sync operation to different helpers for easy =
understanding.
>>=20
>> Changes since v1:
>> - If upper filesystem is readonly mode then skip synchronization.
>> - Introduce global wait list to replace temporary wait list for
>> concurrent synchronization.
>>=20
>> fs/fs-writeback.c        |   1 +
>> fs/overlayfs/overlayfs.h |   1 +
>> fs/overlayfs/ovl_entry.h |   5 +
>> fs/overlayfs/super.c     | 270 =
++++++++++++++++++++++++++++++++++++++++++++---
>> fs/overlayfs/util.c      |  23 +++-
>> 5 files changed, 283 insertions(+), 17 deletions(-)
>>=20
>> diff --git a/fs/fs-writeback.c b/fs/fs-writeback.c
>> index cea4836..8c58664 100644
>> --- a/fs/fs-writeback.c
>> +++ b/fs/fs-writeback.c
>> @@ -1215,6 +1215,7 @@ void inode_wait_for_writeback(struct inode =
*inode)
>> 	__inode_wait_for_writeback(inode);
>> 	spin_unlock(&inode->i_lock);
>> }
>> +EXPORT_SYMBOL(inode_wait_for_writeback);
>>=20
>> /*
>> * Sleep until I_SYNC is cleared. This function must be called with =
i_lock
>> diff --git a/fs/overlayfs/overlayfs.h b/fs/overlayfs/overlayfs.h
>> index b489099..2b65b6a 100644
>> --- a/fs/overlayfs/overlayfs.h
>> +++ b/fs/overlayfs/overlayfs.h
>> @@ -241,6 +241,7 @@ int ovl_check_setxattr(struct dentry *dentry, =
struct dentry *upperdentry,
>> int ovl_nlink_start(struct dentry *dentry, bool *locked);
>> void ovl_nlink_end(struct dentry *dentry, bool locked);
>> int ovl_lock_rename_workdir(struct dentry *workdir, struct dentry =
*upperdir);
>> +void ovl_detach_upper_inodes_list(struct inode *inode);
>>=20
>> static inline bool ovl_is_impuredir(struct dentry *dentry)
>> {
>> diff --git a/fs/overlayfs/ovl_entry.h b/fs/overlayfs/ovl_entry.h
>> index 9d0bc03..53909ba 100644
>> --- a/fs/overlayfs/ovl_entry.h
>> +++ b/fs/overlayfs/ovl_entry.h
>> @@ -52,6 +52,9 @@ struct ovl_fs {
>> 	/* Did we take the inuse lock? */
>> 	bool upperdir_locked;
>> 	bool workdir_locked;
>> +	/* upper inode list and lock */
>> +	spinlock_t upper_inodes_lock;
>> +	struct list_head upper_inodes;
>> };
>>=20
>> /* private information held for every overlayfs dentry */
>> @@ -80,6 +83,8 @@ struct ovl_inode {
>>=20
>> 	/* synchronize copy up and more */
>> 	struct mutex lock;
>> +	/* upper inodes list */
>> +	struct list_head upper_inodes_list;
>> };
>>=20
>> static inline struct ovl_inode *OVL_I(struct inode *inode)
>> diff --git a/fs/overlayfs/super.c b/fs/overlayfs/super.c
>> index 76440fe..2026acf 100644
>> --- a/fs/overlayfs/super.c
>> +++ b/fs/overlayfs/super.c
>> @@ -17,6 +17,8 @@
>> #include <linux/statfs.h>
>> #include <linux/seq_file.h>
>> #include <linux/posix_acl_xattr.h>
>> +#include <linux/writeback.h>
>> +#include <linux/blkdev.h>
>> #include "overlayfs.h"
>>=20
>> MODULE_AUTHOR("Miklos Szeredi <miklos@szeredi.hu>");
>> @@ -195,6 +197,7 @@ static struct inode *ovl_alloc_inode(struct =
super_block *sb)
>> 	oi->__upperdentry =3D NULL;
>> 	oi->lower =3D NULL;
>> 	mutex_init(&oi->lock);
>> +	INIT_LIST_HEAD(&oi->upper_inodes_list);
>>=20
>> 	return &oi->vfs_inode;
>> }
>> @@ -252,34 +255,228 @@ static void ovl_put_super(struct super_block =
*sb)
>> 	ovl_free_fs(ofs);
>> }
>>=20
>> -/* Sync real dirty inodes in upper filesystem (if it exists) */
>> -static int ovl_sync_fs(struct super_block *sb, int wait)
>> +/**
>> + * ovl_sync_single_inode
>> + * @sb: The overlayfs inode
>> + * @detach: Detach from upper inode list when setting true
>> + *
>> + * Sync and wait for ovl inode which is in the dropping process.
>> + */
>> +static void ovl_sync_single_inode(struct inode *inode, bool detach)
>> +{
>> +	struct inode *upper_inode =3D ovl_inode_upper(inode);
>> +
>> +	struct writeback_control wbc =3D {
>> +		.sync_mode		=3D WB_SYNC_ALL,
>> +		.range_start		=3D 0,
>> +		.range_end		=3D LLONG_MAX,
>> +		.nr_to_write		=3D LONG_MAX,
>> +	};
>> +
>> +	if (!list_empty(&upper_inode->i_io_list))
>> +		sync_inode(upper_inode, &wbc);
>> +	else if (!list_empty(&upper_inode->i_wb_list))
>> +		filemap_fdatawait_keep_errors(upper_inode->i_mapping);
>> +
>> +	if (detach)
>> +		ovl_detach_upper_inodes_list(inode);
>> +}
>> +/**
>> + * ovl_sync_inodes
>> + * @sb: The overlayfs super block
>> + *
>> + * upper_inodes list is used for organizing ovl inode which has =
upper inode,
>> + * by iterating the list to looking for and syncing dirty upper =
inode.
>> + *
>> + * When starting syncing inode, we add the inode to wait list =
explicitly,
>> + * in order to save memory we reuse inode->i_wb_list and =
sb->s_inodes_wb,
>> + * so those fields have slightly differnt meanings in overlayfs.
>> + */
>> +static void ovl_sync_inodes(struct super_block *sb)
>> {
>> 	struct ovl_fs *ofs =3D sb->s_fs_info;
>> -	struct super_block *upper_sb;
>> -	int ret;
>> +	struct ovl_inode *oi;
>> +	struct inode *inode, *iput_inode =3D NULL;
>> +	struct inode *upper_inode;
>> +	struct blk_plug plug;
>> +
>> +	struct writeback_control wbc_for_sync =3D {
>> +		.sync_mode		=3D WB_SYNC_ALL,
>> +		.for_sync		=3D 1,
>> +		.range_start		=3D 0,
>> +		.range_end		=3D LLONG_MAX,
>> +		.nr_to_write		=3D LONG_MAX,
>> +	};
>> +
>> +	blk_start_plug(&plug);
>> +	spin_lock(&ofs->upper_inodes_lock);
>> +	list_for_each_entry(oi, &ofs->upper_inodes, upper_inodes_list) {
>> +		inode =3D &oi->vfs_inode;
>> +		spin_lock(&inode->i_lock);
>> +
>> +		if (inode->i_state & I_NEW) {
>> +			spin_unlock(&inode->i_lock);
>> +			continue;
>> +		}
>>=20
>> -	if (!ofs->upper_mnt)
>> -		return 0;
>> +		/*
>> +		 * When i_count is 0 ovl inode is in the process of =
destruction,
>> +		 * so wait at once after syncing instead of adding inode =
to the
>> +		 * waiting list.
>> +		 */
>> +		if (!atomic_read(&inode->i_count)) {
>> +			upper_inode =3D ovl_inode_upper(inode);
>> +			if (inode->i_state & I_SYNC) {
>> +				spin_unlock(&inode->i_lock);
>> +				igrab(upper_inode);
>> +				spin_unlock(&ofs->upper_inodes_lock);
>> +				inode_wait_for_writeback(upper_inode);
>> +				=
filemap_fdatawait_keep_errors(upper_inode->i_mapping);
>> +				iput(upper_inode);
>> +				goto next;
>> +			}
>> +
>> +			/*
>> +			 * Reuse I_SYNC flag to avoid race conditions =
with the
>> +			 * sync operation in ovl_drop_inode.
>> +			 */
>> +			inode->i_state |=3D I_SYNC;
>> +			spin_unlock(&inode->i_lock);
>> +			spin_unlock(&ofs->upper_inodes_lock);
>> +
>> +			ovl_sync_single_inode(inode, false);
>> +
>> +			spin_lock(&inode->i_lock);
>> +			inode->i_state &=3D ~I_SYNC;
>> +			spin_unlock(&inode->i_lock);
>> +			goto next;
>> +		}
>=20
> IMHO this is just too hairy, you cannot e.g. igrab() inode with zero
> refcount and I just don't see how this does not end up causing use =
after
> free issues. I'd just delete this code, skip I_FREEING and I_WILL_FREE
> inodes here and rely on ->evict properly writing the inode as needed =
(more
> on that below).
>> +
>> +		ihold(inode);
>> +		upper_inode =3D ovl_inode_upper(inode);
>> +		spin_unlock(&inode->i_lock);
>> +		spin_unlock(&ofs->upper_inodes_lock);
>> +
>> +		if (iput_inode)
>> +			iput(iput_inode);
>> +
>> +		if (list_empty(&upper_inode->i_io_list)) {
>> +			if (list_empty(&upper_inode->i_wb_list)) {
>=20
> To make this more readable, please change this to:
>=20
> 		if (!(upper_inode->i_state & I_DIRTY_ALL)) {
> 			if (!mapping_tagged(upper_inode->i_mapping,
> 					    PAGECACHE_TAG_DIRTY)) {
> 				...
> 			}
> 		}
>=20
>> +				iput_inode =3D inode;
>> +				goto next;
>> +			}
>> +		} else {
>> +			sync_inode(upper_inode, &wbc_for_sync);
>> +		}
>> +
>> +		/*
>> +		 * When ovl inode is not in sb->s_inodes_wb list,
>> +		 * hold referece until finishing waiting on the inode.
>> +		 */
>> +		spin_lock(&sb->s_inode_wblist_lock);
>> +		if (list_empty(&inode->i_wb_list)) {
>> +			list_add_tail(&inode->i_wb_list, =
&sb->s_inodes_wb);
>> +			iput_inode =3D NULL;
>> +		} else {
>> +			iput_inode =3D inode;
>> +		}
>> +		spin_unlock(&sb->s_inode_wblist_lock);
>> +
>> +next:
>> +		if (need_resched()) {
>> +			blk_finish_plug(&plug);
>> +			cond_resched();
>> +			blk_start_plug(&plug);
>> +		}
>> +		spin_lock(&ofs->upper_inodes_lock);
>> +	}
>> +	spin_unlock(&ofs->upper_inodes_lock);
>> +	blk_finish_plug(&plug);
>> +
>> +	if (iput_inode)
>> +		iput(iput_inode);
>> +}
>> +
>> +static void ovl_wait_inodes(struct super_block *sb)
>> +{
>> +	LIST_HEAD(sync_list);
>> +	struct inode *inode;
>> +	struct inode *upper_inode;
>> +
>> +	/*
>> +	 * ovl inode in sb->s_inodes_wb list has already got inode =
reference,
>> +	 * this will avoid silent droping during waiting on it.
>> +	 * Splice the sync wait list onto a temporary list to avoid =
waiting on
>> +	 * inodes that have started writeback after this point.
>> +	 */
>> +	mutex_lock(&sb->s_sync_lock);
>> +	spin_lock(&sb->s_inode_wblist_lock);
>> +	list_splice_init(&sb->s_inodes_wb, &sync_list);
>> +	spin_unlock(&sb->s_inode_wblist_lock);
>> +
>> +	while (!list_empty(&sync_list)) {
>> +		inode =3D list_first_entry(&sync_list, struct inode, =
i_wb_list);
>> +		list_del_init(&inode->i_wb_list);
>=20
> I think this is racy. ovl_sync_inodes() can be looking at and =
manipulating
> ->i_wb_list while ovl_wait_inodes() works with it. So I think you need =
to
> hold sb->s_inode_wblist_lock until you remove inode from the =
i_wb_list.

There is a condition to check whether inode->i_wb_list is empty or not=20=

before ovl_sync_inodes() manipulates ->i_wb_list.=20
I think this check can avoid race, am i missing something?


Thanks,
Chengguang.=
