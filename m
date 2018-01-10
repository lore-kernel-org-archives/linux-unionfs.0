From: Chengguang Xu <cgxu519@icloud.com>
Subject: Re: [PATCH v2] ovl: Improving syncfs efficiency
Date: Wed, 10 Jan 2018 22:18:23 +0800
Message-ID: <06EB0CEE-9822-49FB-9793-28D615A0AD83@icloud.com>
References: <1515587531-33474-1-git-send-email-cgxu519@icloud.com>
 <CAOQ4uxjnDMTf+uBja5-F4nSm2BYmpfK8nOfR1hhYMo7VC02vQg@mail.gmail.com>
Mime-Version: 1.0 (Mac OS X Mail 11.2 \(3445.5.20\))
Content-Type: text/plain; charset=gb2312
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-unionfs-owner@vger.kernel.org>
Received: from pv33p36im-asmtp001.me.com ([17.142.213.62]:33467 "EHLO
        pv33p36im-asmtp001.me.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1755310AbeAJOSc (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Wed, 10 Jan 2018 09:18:32 -0500
Received: from process-dkim-sign-daemon.pv33p36im-asmtp001.me.com by
 pv33p36im-asmtp001.me.com
 (Oracle Communications Messaging Server 8.0.1.2.20170607 64bit (built Jun  7
 2017)) id <0P2C00200FOA3200@pv33p36im-asmtp001.me.com> for
 linux-unionfs@vger.kernel.org; Wed, 10 Jan 2018 14:18:32 +0000 (GMT)
In-reply-to: <CAOQ4uxjnDMTf+uBja5-F4nSm2BYmpfK8nOfR1hhYMo7VC02vQg@mail.gmail.com>
Sender: linux-unionfs-owner@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org
To: Amir Goldstein <amir73il@gmail.com>
Cc: Miklos Szeredi <miklos@szeredi.hu>, overlayfs <linux-unionfs@vger.kernel.org>

=D4=DA 2018=C4=EA1=D4=C210=C8=D5=A3=AC=CF=C2=CE=E79:16=A3=ACAmir =
Goldstein <amir73il@gmail.com> =D0=B4=B5=C0=A3=BA
>=20
> On Wed, Jan 10, 2018 at 2:32 PM, Chengguang Xu <cgxu519@icloud.com> =
wrote:
>> Currently syncfs(2) call on overlayfs just simply call =
sync_filesystem()
>> on upper_sb to synchronize whole dirty inodes in upper filesystem
>> regardless of the overlay ownership of the inode. It has obvious
>> shortcomings as below.
>>=20
>> (1) Performance
>> Synchronization is probably heavy in most cases, especially when =
upper
>> filesystem is not dedicated to target overlayfs.
>>=20
>> (2) Interference
>> Unplanned synchronization will probably impact IO performance of the
>> processes which use other overlayfs on same upper filesystem or =
directly
>> use upper filesystem.
>>=20
>> This patch iterates overlay inodes to only sync target dirty inodes =
in
>> upper filesystem. By doing this, It is able to reduce cost of =
synchronization
>> and will not seriously impact IO performance of irrelative processes.
>>=20
>> Signed-off-by: Chengguang Xu <cgxu519@icloud.com>
>> ---
>> Changes since v1:
>> - If upper filesystem is readonly mode then skip synchronization.
>> - Introduce global wait list to replace temporary wait list for
>> concurrent synchronization.
>>=20
>=20
> Looks ok. A few more suggestions below.
>=20
>> fs/overlayfs/ovl_entry.h |   5 +++
>> fs/overlayfs/super.c     | 105 =
+++++++++++++++++++++++++++++++++++++++++++++--
>> 2 files changed, 107 insertions(+), 3 deletions(-)
>>=20
>> diff --git a/fs/overlayfs/ovl_entry.h b/fs/overlayfs/ovl_entry.h
>> index 9d0bc03..ff935da 100644
>> --- a/fs/overlayfs/ovl_entry.h
>> +++ b/fs/overlayfs/ovl_entry.h
>> @@ -52,6 +52,9 @@ struct ovl_fs {
>>        /* Did we take the inuse lock? */
>>        bool upperdir_locked;
>>        bool workdir_locked;
>> +       /* ovl inode sync list and lock */
>> +       spinlock_t  ovl_sync_list_lock;
>> +       struct list_head ovl_sync_list;
>> };
>>=20
>> /* private information held for every overlayfs dentry */
>> @@ -80,6 +83,8 @@ struct ovl_inode {
>>=20
>>        /* synchronize copy up and more */
>>        struct mutex lock;
>> +       /* ovl inode sync list */
>> +       struct list_head sync_list;
>> };
>>=20
>> static inline struct ovl_inode *OVL_I(struct inode *inode)
>> diff --git a/fs/overlayfs/super.c b/fs/overlayfs/super.c
>> index 76440fe..c7b788b 100644
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
>> +       INIT_LIST_HEAD(&oi->sync_list);
>>=20
>>        return &oi->vfs_inode;
>> }
>> @@ -252,6 +255,97 @@ static void ovl_put_super(struct super_block =
*sb)
>>        ovl_free_fs(ofs);
>> }
>>=20
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
>> +       struct ovl_inode *oi, *oi_next;
>> +       struct inode *inode, *i_next;
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
>> +       spin_lock(&sb->s_inode_list_lock);
>> +       list_for_each_entry_safe(inode, i_next, &sb->s_inodes, =
i_sb_list) {
>> +               upper_inode =3D ovl_inode_upper(inode);
>> +               if (!upper_inode)
>> +                       continue;
>> +
>> +               spin_lock(&upper_inode->i_lock);
>> +               if (upper_inode->i_state & (I_NEW | I_FREEING | =
I_WILL_FREE) ||
>> +                       list_empty(&upper_inode->i_io_list)) {
>> +                       spin_unlock(&upper_inode->i_lock);
>> +                       continue;
>> +               }
>> +               spin_unlock(&upper_inode->i_lock);
>> +
>> +               if (!igrab(inode))
>> +                       continue;
>> +
>> +               if (!igrab(upper_inode)) {
>> +                       iput(inode);
>> +                       continue;
>> +               }
>> +               spin_unlock(&sb->s_inode_list_lock);
>> +
>> +               sync_inode(upper_inode, &wbc);
>> +               spin_lock(&ofs->ovl_sync_list_lock);
>> +               if (list_empty(&OVL_I(inode)->sync_list))
>> +                       list_add(&OVL_I(inode)->sync_list, =
&ofs->ovl_sync_list);
>> +               else {
>> +                       iput(upper_inode);
>> +                       iput(inode);
>> +               }
>> +               spin_unlock(&ofs->ovl_sync_list_lock);
>> +
>> +               if (need_resched()) {
>> +                       blk_finish_plug(&plug);
>> +                       cond_resched();
>> +                       blk_start_plug(&plug);
>> +               }
>> +               spin_lock(&sb->s_inode_list_lock);
>> +       }
>> +       spin_unlock(&sb->s_inode_list_lock);
>> +       blk_finish_plug(&plug);
>> +
>=20
> You may want to consider factoring out helpers ovl_sync_inodes()
> and maybe also ovl_writeback_inodes()  ovl_wait_inodes(),
> so the code in nicer and resembles generic helper structure.

hmmm=A3=ACyou mean imitating VFS structure? :-)

>=20
>> +       mutex_lock(&upper_sb->s_sync_lock);
>=20
> So it makes some sense to use upper_sb sync lock
> to synchronize with callers of sync(2)/syncfs(2) on the upper fs,
> but that could result syncfs() on overlay to take much longer if
> there is a syncfs() on upper fs in progress.

I have two proposals for this.

A.
After changing wait list to global, I think waiting without=20
upper_sb->s_sync_lock is still safe, so we can avoid coupling
with syncfs of upper filesystem and I prefer this.

B.
If you are worried about solution A, then we can introduce a mutex_lock
inside overlayfs for serializing concurrent sync waiting operations.

>=20
> If you think of ovl_sync_filesystem() as a selective fsync() iterator,
> then it might make more sense to synchronize overlayfs syncfs()
> callers with overlay sb sync lock.

IIRC, fsync doing sync & wait one by one in good order, and maybe it =
also
calls metadata sync after that. So I think it=A1=AFs not so efficient =
way to
sync fs and may cause write amplification, and finally it needs opening =
file.

Thanks,
Chengguang.
