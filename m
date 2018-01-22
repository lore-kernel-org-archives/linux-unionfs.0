From: Chengguang Xu <cgxu519@icloud.com>
Subject: Re: [PATCH v6] ovl: Improving syncfs efficiency
Date: Mon, 22 Jan 2018 20:05:28 +0800
Message-ID: <767E3A51-A82D-4C41-A2B3-F639253B786C@icloud.com>
References: <1516614465-134755-1-git-send-email-cgxu519@icloud.com>
 <CAOQ4uxio56Lg+yNPxVNP4gN7jv5P01h9Y-PARH_forC3cmnv7w@mail.gmail.com>
Mime-Version: 1.0 (Mac OS X Mail 11.2 \(3445.5.20\))
Content-Type: text/plain; charset=gb2312
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-unionfs-owner@vger.kernel.org>
Received: from pv33p36im-asmtp002.me.com ([17.142.213.63]:17735 "EHLO
        pv33p36im-asmtp002.me.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750890AbeAVMFm (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Mon, 22 Jan 2018 07:05:42 -0500
Received: from process-dkim-sign-daemon.pv33p36im-asmtp002.me.com by
 pv33p36im-asmtp002.me.com
 (Oracle Communications Messaging Server 8.0.1.2.20170607 64bit (built Jun  7
 2017)) id <0P2Y00400H8L2X00@pv33p36im-asmtp002.me.com> for
 linux-unionfs@vger.kernel.org; Mon, 22 Jan 2018 12:05:41 +0000 (GMT)
In-reply-to: <CAOQ4uxio56Lg+yNPxVNP4gN7jv5P01h9Y-PARH_forC3cmnv7w@mail.gmail.com>
Sender: linux-unionfs-owner@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org
To: Amir Goldstein <amir73il@gmail.com>
Cc: Miklos Szeredi <miklos@szeredi.hu>, Jan Kara <jack@suse.cz>, overlayfs <linux-unionfs@vger.kernel.org>

>=20
> =D4=DA 2018=C4=EA1=D4=C222=C8=D5=A3=AC=CF=C2=CE=E77:27=A3=ACAmir =
Goldstein <amir73il@gmail.com> =D0=B4=B5=C0=A3=BA
>=20
> On Mon, Jan 22, 2018 at 11:47 AM, Chengguang Xu <cgxu519@icloud.com> =
wrote:
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
>> Changes since v5:
>> - Move sync related functions to new file sync.c.
>> - Introduce OVL_EVICT_PENDING flag to avoid race conditions.
>> - If ovl indoe flag is I_WILL_FREE or I_FREEING then syncfs
>=20
> typo 'indo' and in comment below as well.
>=20
>> will wait until OVL_EVICT_PENDING to be cleared.
>> - Move inode sync operation into evict_inode from drop_inode.
>> - Call upper_sb->sync_fs with no-wait after sync dirty upper
>> inodes.
>> - Hold s_inode_wblist_lock until deleting item from list.
>> - Remove write_inode fuction because no more used.
>>=20
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
>> fs/overlayfs/Makefile    |   2 +-
>> fs/overlayfs/overlayfs.h |   8 ++
>> fs/overlayfs/ovl_entry.h |   5 +
>> fs/overlayfs/super.c     |  44 +++-----
>> fs/overlayfs/sync.c      | 256 =
+++++++++++++++++++++++++++++++++++++++++++++++
>> fs/overlayfs/util.c      |  23 ++++-
>> 6 files changed, 305 insertions(+), 33 deletions(-)
>> create mode 100644 fs/overlayfs/sync.c
>>=20
>> diff --git a/fs/overlayfs/Makefile b/fs/overlayfs/Makefile
>> index 99373bb..6e92c0e 100644
>> --- a/fs/overlayfs/Makefile
>> +++ b/fs/overlayfs/Makefile
>> @@ -4,4 +4,4 @@
>>=20
>> obj-$(CONFIG_OVERLAY_FS) +=3D overlay.o
>>=20
>> -overlay-objs :=3D super.o namei.o util.o inode.o dir.o readdir.o =
copy_up.o
>> +overlay-objs :=3D super.o namei.o util.o inode.o dir.o readdir.o =
copy_up.o sync.o
>> diff --git a/fs/overlayfs/overlayfs.h b/fs/overlayfs/overlayfs.h
>> index b489099..c6a9ecd 100644
>> --- a/fs/overlayfs/overlayfs.h
>> +++ b/fs/overlayfs/overlayfs.h
>> @@ -34,6 +34,8 @@ enum ovl_flag {
>>        /* Non-merge dir that may contain whiteout entries */
>>        OVL_WHITEOUTS,
>>        OVL_INDEX,
>> +       /* Set when ovl inode is about to be freed */
>> +       OVL_EVICT_PENDING,
>> };
>>=20
>> /*
>> @@ -241,6 +243,7 @@ int ovl_check_setxattr(struct dentry *dentry, =
struct dentry *upperdentry,
>> int ovl_nlink_start(struct dentry *dentry, bool *locked);
>> void ovl_nlink_end(struct dentry *dentry, bool locked);
>> int ovl_lock_rename_workdir(struct dentry *workdir, struct dentry =
*upperdir);
>> +void ovl_detach_upper_inodes_list(struct inode *inode);
>>=20
>> static inline bool ovl_is_impuredir(struct dentry *dentry)
>> {
>> @@ -322,3 +325,8 @@ int ovl_create_real(struct inode *dir, struct =
dentry *newdentry,
>> int ovl_copy_xattr(struct dentry *old, struct dentry *new);
>> int ovl_set_attr(struct dentry *upper, struct kstat *stat);
>> struct ovl_fh *ovl_encode_fh(struct dentry *lower, bool is_upper);
>> +
>> +/* sync.c */
>> +int ovl_write_inode(struct inode *inode, struct writeback_control =
*wbc);
>=20
> leftover
>=20
>> +void ovl_evict_inode(struct inode *inode);
>> +int ovl_sync_fs(struct super_block *sb, int wait);
>> diff --git a/fs/overlayfs/ovl_entry.h b/fs/overlayfs/ovl_entry.h
>> index 9d0bc03..53909ba 100644
>> --- a/fs/overlayfs/ovl_entry.h
>> +++ b/fs/overlayfs/ovl_entry.h
>> @@ -52,6 +52,9 @@ struct ovl_fs {
>>        /* Did we take the inuse lock? */
>>        bool upperdir_locked;
>>        bool workdir_locked;
>> +       /* upper inode list and lock */
>> +       spinlock_t upper_inodes_lock;
>> +       struct list_head upper_inodes;
>> };
>>=20
>> /* private information held for every overlayfs dentry */
>> @@ -80,6 +83,8 @@ struct ovl_inode {
>>=20
>>        /* synchronize copy up and more */
>>        struct mutex lock;
>> +       /* upper inodes list */
>> +       struct list_head upper_inodes_list;
>> };
>>=20
>> static inline struct ovl_inode *OVL_I(struct inode *inode)
>> diff --git a/fs/overlayfs/super.c b/fs/overlayfs/super.c
>> index 76440fe..9315155 100644
>> --- a/fs/overlayfs/super.c
>> +++ b/fs/overlayfs/super.c
>> @@ -195,6 +195,7 @@ static struct inode *ovl_alloc_inode(struct =
super_block *sb)
>>        oi->__upperdentry =3D NULL;
>>        oi->lower =3D NULL;
>>        mutex_init(&oi->lock);
>> +       INIT_LIST_HEAD(&oi->upper_inodes_list);
>>=20
>>        return &oi->vfs_inode;
>> }
>> @@ -252,36 +253,6 @@ static void ovl_put_super(struct super_block =
*sb)
>>        ovl_free_fs(ofs);
>> }
>>=20
>> -/* Sync real dirty inodes in upper filesystem (if it exists) */
>> -static int ovl_sync_fs(struct super_block *sb, int wait)
>> -{
>> -       struct ovl_fs *ofs =3D sb->s_fs_info;
>> -       struct super_block *upper_sb;
>> -       int ret;
>> -
>> -       if (!ofs->upper_mnt)
>> -               return 0;
>> -
>> -       /*
>> -        * If this is a sync(2) call or an emergency sync, all the =
super blocks
>> -        * will be iterated, including upper_sb, so no need to do =
anything.
>> -        *
>> -        * If this is a syncfs(2) call, then we do need to call
>> -        * sync_filesystem() on upper_sb, but enough if we do it when =
being
>> -        * called with wait =3D=3D 1.
>> -        */
>> -       if (!wait)
>> -               return 0;
>> -
>> -       upper_sb =3D ofs->upper_mnt->mnt_sb;
>> -
>> -       down_read(&upper_sb->s_umount);
>> -       ret =3D sync_filesystem(upper_sb);
>> -       up_read(&upper_sb->s_umount);
>> -
>> -       return ret;
>> -}
>> -
>> /**
>>  * ovl_statfs
>>  * @sb: The overlayfs super block
>> @@ -354,10 +325,18 @@ static int ovl_remount(struct super_block *sb, =
int *flags, char *data)
>>        return 0;
>> }
>>=20
>> +static int ovl_drop_inode(struct inode *inode)
>> +{
>> +       if (ovl_inode_upper(inode))
>> +               ovl_set_flag(OVL_EVICT_PENDING, inode);
>> +       return 1;
>> +}
>> +
>> static const struct super_operations ovl_super_operations =3D {
>>        .alloc_inode    =3D ovl_alloc_inode,
>>        .destroy_inode  =3D ovl_destroy_inode,
>> -       .drop_inode     =3D generic_delete_inode,
>> +       .drop_inode     =3D ovl_drop_inode,
>> +       .evict_inode    =3D ovl_evict_inode,
>>        .put_super      =3D ovl_put_super,
>>        .sync_fs        =3D ovl_sync_fs,
>>        .statfs         =3D ovl_statfs,
>> @@ -1202,6 +1181,9 @@ static int ovl_fill_super(struct super_block =
*sb, void *data, int silent)
>>        if (!ofs)
>>                goto out;
>>=20
>> +       spin_lock_init(&ofs->upper_inodes_lock);
>> +       INIT_LIST_HEAD(&ofs->upper_inodes);
>> +
>>        ofs->creator_cred =3D cred =3D prepare_creds();
>>        if (!cred)
>>                goto out_err;
>> diff --git a/fs/overlayfs/sync.c b/fs/overlayfs/sync.c
>> new file mode 100644
>> index 0000000..e239b0a
>> --- /dev/null
>> +++ b/fs/overlayfs/sync.c
>> @@ -0,0 +1,256 @@
>> +/*
>> + * Copyright (C) 2018 Meili Inc.
>> + * Author Chengguang Xu <cgxu519@icloud.com>
>> + *
>> + * This program is free software; you can redistribute it and/or =
modify it
>> + * under the terms of the GNU General Public License version 2 as =
published by
>> + * the Free Software Foundation.
>> + */
>> +
>> +#include <linux/fs.h>
>> +#include <linux/xattr.h>
>> +#include <linux/mount.h>
>> +#include <linux/writeback.h>
>> +#include <linux/blkdev.h>
>> +#include "overlayfs.h"
>> +
>> +void ovl_evict_inode(struct inode *inode)
>> +{
>> +       if (ovl_inode_upper(inode)) {
>> +               write_inode_now(ovl_inode_upper(inode), 1);
>> +               ovl_detach_upper_inodes_list(inode);
>> +
>> +               /*
>> +                * ovl_sync_inodes() may wait until
>> +                * flag OVL_EVICT_PENDING to be cleared.
>> +                */
>> +               spin_lock(&inode->i_lock);
>> +               ovl_clear_flag(OVL_EVICT_PENDING, inode);
>> +               /* See also atomic_bitops.txt */
>> +               smp_mb__after_atomic();
>> +               wake_up_bit(&OVL_I(inode)->flags, OVL_EVICT_PENDING);
>> +               spin_unlock(&inode->i_lock);
>> +               clear_inode(inode);
>> +       }
>> +}
>> +
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
>> +{
>> +       struct ovl_fs *ofs =3D sb->s_fs_info;
>> +       struct ovl_inode *oi, *oi_prev;
>> +       struct inode *inode, *iput_inode =3D NULL;
>> +       struct inode *upper_inode;
>> +       struct blk_plug plug;
>> +
>> +       struct writeback_control wbc_for_sync =3D {
>> +               .sync_mode              =3D WB_SYNC_ALL,
>> +               .for_sync               =3D 1,
>> +               .range_start            =3D 0,
>> +               .range_end              =3D LLONG_MAX,
>> +               .nr_to_write            =3D LONG_MAX,
>> +       };
>> +
>> +       blk_start_plug(&plug);
>> +       spin_lock(&ofs->upper_inodes_lock);
>> +       list_for_each_entry(oi, &ofs->upper_inodes, =
upper_inodes_list) {
>> +               inode =3D &oi->vfs_inode;
>> +               spin_lock(&inode->i_lock);
>> +
>> +               if (inode->i_state & I_NEW) {
>> +                       spin_unlock(&inode->i_lock);
>> +                       continue;
>> +               }
>> +
>> +               /*
>> +                * If ovl indoe state is I_WILL_FREE or I_FREEING,
>> +                * sync operation will be done in the =
ovl_evict_inode(),
>> +                * so wait here until OVL_EVICT_PENDING flag to be =
cleared.
>> +                */
>> +               if (inode->i_state & (I_WILL_FREE | I_FREEING)) {
>> +                       oi_prev =3D =
list_entry(oi->upper_inodes_list.prev,
>> +                                       struct ovl_inode, =
upper_inodes_list);
>> +
>> +                       if (ovl_test_flag(OVL_EVICT_PENDING, inode)) =
{
>> +                               DEFINE_WAIT_BIT(wait, &oi->flags, =
OVL_EVICT_PENDING);
>> +                               wait_queue_head_t *wqh;
>> +                               bool sleep;
>> +
>> +                               wqh =3D bit_waitqueue(&oi->flags, =
OVL_EVICT_PENDING);
>> +                               prepare_to_wait(wqh, &wait.wq_entry, =
TASK_UNINTERRUPTIBLE);
>> +                               sleep =3D =
ovl_test_flag(OVL_EVICT_PENDING, inode);
>> +                               spin_unlock(&inode->i_lock);
>> +                               spin_unlock(&ofs->upper_inodes_lock);
>> +                               if (sleep)
>> +                                       schedule();
>> +                               finish_wait(wqh, &wait.wq_entry);
>=20
> Please move all this to helper ovl_wait_evict_pending()
>=20
>=20
>=20
>> +                               /* We need to do this as 'inode' can =
be freed by now */
>=20
> Could oi_prev have been freed or removed from upper_inodes list?
> I don't see why not.
> You could try to continue iteration from iput_inode if it is not NULL,
> but what if it is NULL?

When iterating the list we either get reference or wait until the item =
gets deleted,
so I think there is no chance let previous inode becomes NULL.


> Maybe instead of iput_inode =3D NULL when adding to inodes_wb list
> get another reference to inode and always store iput_inode =3D inode
> to use as prev in this case?

Maybe it=A1=AFs better than current, but I think it=A1=AFs more complex =
to understand
the behavior, so please let me wait for more comments for the approach.


>=20
> It would be good if you wrote the "life cycle" of ovl_inode in a
> header comment to
> this file because it has become non-trivial to follow.
> An explicit mention of locking order is also very good to have in
> header comment.
>=20
>=20

Let me add in next version.

Talking about life cycle of ovl_inode, currently I only mark =
OVL_EVICT_EXPENDING
for ovl_inode which has upper inode, is it acceptable?=20

Thanks,
Chengguang.
