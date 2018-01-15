From: Chengguang Xu <cgxu519@icloud.com>
Subject: Re: [PATCH v4] ovl: Improving syncfs efficiency
Date: Mon, 15 Jan 2018 20:19:46 +0800
Message-ID: <164E0FA4-DB91-4CC5-9408-E8F53D9652E7@icloud.com>
References: <1516001594-226478-1-git-send-email-cgxu519@icloud.com>
 <CAOQ4uxiHGS_t8JK+a25-Co55BdqhxASt6sTaf2rzJ0XWSdbjbQ@mail.gmail.com>
Mime-Version: 1.0 (Mac OS X Mail 11.2 \(3445.5.20\))
Content-Type: text/plain; charset=gb2312
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-unionfs-owner@vger.kernel.org>
Received: from pv33p36im-asmtp002.me.com ([17.142.213.63]:62404 "EHLO
        pv33p36im-asmtp002.me.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753074AbeAOMUE (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Mon, 15 Jan 2018 07:20:04 -0500
Received: from process-dkim-sign-daemon.pv33p36im-asmtp002.me.com by
 pv33p36im-asmtp002.me.com
 (Oracle Communications Messaging Server 8.0.1.2.20170607 64bit (built Jun  7
 2017)) id <0P2L00J00J6HK300@pv33p36im-asmtp002.me.com> for
 linux-unionfs@vger.kernel.org; Mon, 15 Jan 2018 12:19:57 +0000 (GMT)
In-reply-to: <CAOQ4uxiHGS_t8JK+a25-Co55BdqhxASt6sTaf2rzJ0XWSdbjbQ@mail.gmail.com>
Sender: linux-unionfs-owner@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org
To: Amir Goldstein <amir73il@gmail.com>
Cc: Jan Kara <jack@suse.cz>, Miklos Szeredi <miklos@szeredi.hu>, overlayfs <linux-unionfs@vger.kernel.org>

>=20
> =D4=DA 2018=C4=EA1=D4=C215=C8=D5=A3=AC=CF=C2=CE=E77:30=A3=ACAmir =
Goldstein <amir73il@gmail.com> =D0=B4=B5=C0=A3=BA
>=20
> On Mon, Jan 15, 2018 at 9:33 AM, Chengguang Xu <cgxu519@icloud.com> =
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
>> irrelative container processes on the other overlayfs.
>=20
> s/irrelative/unrelated
>=20
>>=20
>> This patch iterates upper inode list in overlayfs to only sync target
>> dirty inodes and wait for completion. By doing this, It is able to =
reduce
>> cost of synchronization and will not seriously impact IO performance =
of
>> irrelative processes. In special case, when having very few dirty =
inodes
>=20
> unrelated processes
>=20
>> and a lot of clean upper inodes in overlayfs, then iteration may =
waste
>> time so that synchronization is slower than before, but we think the
>> potential for performance improvement far surpass the potential for
>> performance regression in most cases.
>>=20
>> Signed-off-by: Chengguang Xu <cgxu519@icloud.com>
>=20
> Beyond Miklos's comment on removing inodes from list, a few more
> comments and nits below.
>=20
>> ---
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
>> fs/overlayfs/ovl_entry.h |   5 ++
>> fs/overlayfs/super.c     | 167 =
++++++++++++++++++++++++++++++++++++++++++++++-
>> fs/overlayfs/util.c      |  13 +++-
>> 3 files changed, 181 insertions(+), 4 deletions(-)
>>=20
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
>> index 76440fe..39fb331 100644
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
>>        oi->__upperdentry =3D NULL;
>>        oi->lower =3D NULL;
>>        mutex_init(&oi->lock);
>> +       INIT_LIST_HEAD(&oi->upper_inodes_list);
>>=20
>>        return &oi->vfs_inode;
>> }
>> @@ -252,6 +255,159 @@ static void ovl_put_super(struct super_block =
*sb)
>>        ovl_free_fs(ofs);
>> }
>>=20
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
>> +       struct ovl_inode *oi;
>> +       struct inode *inode, *iput_inode =3D NULL;
>> +       struct inode *upper_inode;
>> +       struct blk_plug plug;
>> +
>> +       struct writeback_control wbc =3D {
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
>> +
>> +               spin_lock(&inode->i_lock);
>> +               if (inode->i_state & (I_NEW | I_FREEING | =
I_WILL_FREE)) {
>> +                       spin_unlock(&inode->i_lock);
>> +                       continue;
>> +               }
>> +
>> +               if (!atomic_read(&inode->i_count)) {
>> +                       spin_unlock(&inode->i_lock);
>> +                       continue;
>> +               }
>> +
>> +               ihold(inode);
>> +               upper_inode =3D ovl_inode_upper(inode);
>> +               spin_unlock(&inode->i_lock);
>> +
>> +               spin_lock(&upper_inode->i_lock);
>> +               if (!(upper_inode->i_state & I_DIRTY_ALL)) {
>> +                       iput_inode =3D inode;
>> +                       spin_unlock(&upper_inode->i_lock);
>> +                       continue;
>=20
> continue may not get to do anything with iput_inode before
> assigning the next non dirty inode to iput_inode.
> Didn't you mean to call iput(iput_inode) sooner?
>=20
>> +               }
>> +               spin_unlock(&upper_inode->i_lock);
>> +               spin_unlock(&ofs->upper_inodes_lock);
>> +
>> +               if (iput_inode)
>> +                       iput(iput_inode);
>> +
>> +               sync_inode(upper_inode, &wbc);
>> +
>> +               spin_lock(&sb->s_inode_wblist_lock);
>> +               if (list_empty(&inode->i_wb_list)) {
>> +                       list_add_tail(&inode->i_wb_list, =
&sb->s_inodes_wb);
>> +               /*
>> +                * Hold referece of ovl inode
>> +                * until finishing waiting on the inode.
>> +                */
>=20
> Wrong indentation and I think you should move this comment outside
> if case and drop the {}, in any case if you have {} in if you should =
also
> have {} in else.
>=20
>> +                       iput_inode =3D NULL;
>> +               } else
>> +                       iput_inode =3D inode;
>> +               spin_unlock(&sb->s_inode_wblist_lock);
>> +
>> +               if (need_resched()) {
>> +                       blk_finish_plug(&plug);
>> +                       cond_resched();
>> +                       blk_start_plug(&plug);
>> +               }
>> +
>> +               spin_lock(&ofs->upper_inodes_lock);
>> +       }
>> +       spin_unlock(&ofs->upper_inodes_lock);
>> +       blk_finish_plug(&plug);
>> +
>> +       if (iput_inode)
>> +               iput(iput_inode);
>> +}
>> +
>> +static void ovl_wait_inodes(struct super_block *sb)
>> +{
>> +       LIST_HEAD(sync_list);
>> +       struct inode *inode;
>> +       struct inode *upper_inode;
>> +
>> +       mutex_lock(&sb->s_sync_lock);
>> +       /*
>> +        * Splice the sync wait list onto a temporary list to avoid =
waiting on
>> +        * inodes that have started writeback after this point.
>> +        */
>> +       spin_lock(&sb->s_inode_wblist_lock);
>> +       list_splice_init(&sb->s_inodes_wb, &sync_list);
>> +       spin_unlock(&sb->s_inode_wblist_lock);
>> +
>> +       while (!list_empty(&sync_list)) {
>> +               inode =3D list_first_entry(&sync_list, struct inode, =
i_wb_list);
>> +               list_del_init(&inode->i_wb_list);
>> +
>> +               spin_lock(&inode->i_lock);
>> +               if (inode->i_state & (I_NEW | I_FREEING | =
I_WILL_FREE)) {
>> +                       spin_unlock(&inode->i_lock);
>> +                       iput(inode);
>> +                       continue;
>> +               }
>> +
>> +               upper_inode =3D ovl_inode_upper(inode);
>> +               spin_unlock(&inode->i_lock);
>> +
>> +               if (!mapping_tagged(upper_inode->i_mapping,
>> +                               PAGECACHE_TAG_WRITEBACK)) {
>> +                       iput(inode);
>> +                       continue;
>> +               }
>> +
>> +               =
filemap_fdatawait_keep_errors(upper_inode->i_mapping);
>> +
>> +               if (need_resched())
>> +                       cond_resched();
>> +
>> +               iput(inode);
>> +       }
>> +       mutex_unlock(&sb->s_sync_lock);
>> +}
>> +
>> +/**
>> + * ovl_sync_filesystem
>> + * @sb: The overlayfs super block
>> + *
>> + * Sync underlying dirty inodes in upper filesystem and wait for =
completion.
>> + */
>> +static int ovl_sync_filesystem(struct super_block *sb)
>> +{
>> +       struct ovl_fs *ofs =3D sb->s_fs_info;
>> +       struct super_block *upper_sb =3D ofs->upper_mnt->mnt_sb;
>> +
>> +       ovl_sync_inodes(sb);
>> +       ovl_wait_inodes(sb);
>> +
>> +       if (upper_sb->s_op->sync_fs)
>> +               upper_sb->s_op->sync_fs(upper_sb, 1);
>> +
>> +       return sync_blockdev(upper_sb->s_bdev);
>> +}
>> +
>> /* Sync real dirty inodes in upper filesystem (if it exists) */
>> static int ovl_sync_fs(struct super_block *sb, int wait)
>> {
>> @@ -266,17 +422,19 @@ static int ovl_sync_fs(struct super_block *sb, =
int wait)
>>         * If this is a sync(2) call or an emergency sync, all the =
super blocks
>>         * will be iterated, including upper_sb, so no need to do =
anything.
>>         *
>> -        * If this is a syncfs(2) call, then we do need to call
>> -        * sync_filesystem() on upper_sb, but enough if we do it when =
being
>> +        * If this is a syncfs(2) call, then we do need to call =
sync_inode()
>> +        * on underlying dirty upper_inode, but enough if we do it =
when being
>>         * called with wait =3D=3D 1.
>>         */
>>        if (!wait)
>>                return 0;
>>=20
>>        upper_sb =3D ofs->upper_mnt->mnt_sb;
>> +       if (sb_rdonly(upper_sb))
>> +               return 0;
>>=20
>>        down_read(&upper_sb->s_umount);
>> -       ret =3D sync_filesystem(upper_sb);
>> +       ret =3D ovl_sync_filesystem(sb);
>>        up_read(&upper_sb->s_umount);
>=20
> The boundaries between ovl_sync_fs() and ovl_sync_filesystem() are now =
very
> strange.. taking upper_sb s_umount  lock outside and passing in sb =
etc.
> I am not sure that ovl_sync/wait_inodes() should be called under =
upper_sb
> s_umount lock at all. Remember we are already holding sb s_umount =
lock.
> I suggest, now that ovl_sync/wait_inodes() have been factored out, to =
squash
> ovl_sync_filesystem() back into ovl_sync_fs() and hold the s_umount =
lock
> only around s_op->sync_fs() and sync_blockdev().

=46rom the comment in sync_filesystem, s_umount is used for against the =
filesystem going
from r/o to r/w or vice versa. so I think it is necessary and should =
move readonly
check inside ovl_sync_filesystem() to get the protection.

Thanks,
Chengguang.
