From: Chengguang Xu <cgxu519@icloud.com>
Subject: Re: [PATCH] ovl: Improving syncfs efficiency
Date: Wed, 10 Jan 2018 09:45:49 +0800
Message-ID: <D4D8C27A-0C87-40D0-B582-B90F60E2CE81@icloud.com>
References: <1515400885-16622-1-git-send-email-cgxu519@icloud.com>
 <CAOQ4uxgxv=7tj97Krui2XBxiVh8-xjuxqSoq+KSxYYKwXGNQaw@mail.gmail.com>
 <4EF426AE-BBAC-4447-8CE7-E05974CDBEA8@icloud.com>
 <CAOQ4uxiPieowMizdymk0AfCZRhF3M3vSdWVuDSVMJXPYBMUAnA@mail.gmail.com>
Mime-Version: 1.0 (Mac OS X Mail 11.2 \(3445.5.20\))
Content-Type: text/plain; charset=gb2312
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-unionfs-owner@vger.kernel.org>
Received: from pv33p36im-asmtp001.me.com ([17.142.213.62]:60288 "EHLO
        pv33p36im-asmtp001.me.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932122AbeAJBqB (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Tue, 9 Jan 2018 20:46:01 -0500
Received: from process-dkim-sign-daemon.pv33p36im-asmtp001.me.com by
 pv33p36im-asmtp001.me.com
 (Oracle Communications Messaging Server 8.0.1.2.20170607 64bit (built Jun  7
 2017)) id <0P2B00E00GRS5500@pv33p36im-asmtp001.me.com> for
 linux-unionfs@vger.kernel.org; Wed, 10 Jan 2018 01:46:00 +0000 (GMT)
In-reply-to: <CAOQ4uxiPieowMizdymk0AfCZRhF3M3vSdWVuDSVMJXPYBMUAnA@mail.gmail.com>
Sender: linux-unionfs-owner@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org
To: Amir Goldstein <amir73il@gmail.com>
Cc: Miklos Szeredi <miklos@szeredi.hu>, overlayfs <linux-unionfs@vger.kernel.org>


> =D4=DA 2018=C4=EA1=D4=C29=C8=D5=A3=AC=CF=C2=CE=E79:29=A3=ACAmir =
Goldstein <amir73il@gmail.com> =D0=B4=B5=C0=A3=BA
>=20
> On Tue, Jan 9, 2018 at 2:07 PM, Chengguang Xu <cgxu519@icloud.com> =
wrote:
>>>=20
>>> =D4=DA 2018=C4=EA1=D4=C28=C8=D5=A3=AC=CF=C2=CE=E78:10=A3=ACAmir =
Goldstein <amir73il@gmail.com> =D0=B4=B5=C0=A3=BA
>>>=20
>>> On Mon, Jan 8, 2018 at 10:41 AM, Chengguang Xu <cgxu519@icloud.com> =
wrote:
>>>> Currently syncfs(2) call on overlayfs just simply call =
sync_filesystem()
>>>> on upper_sb to synchronize whole dirty inodes in upper filesystem
>>>> regardless of the overlay ownership of the inode. It has obvious
>>>> shortcomings as below.
>>>>=20
>>>> (1) Performance
>>>> Synchronization is probably heavy in most cases, especially when =
upper
>>>> filesystem is not dedicated to target overlayfs.
>>>>=20
>>>> (2) Interference
>>>> Unplanned synchronization will probably impact IO performance of =
the
>>>> processes which use other overlayfs on same upper filesystem or =
directly
>>>> use upper filesystem.
>>>>=20
>>>> This patch iterates overlay inodes to only sync target dirty inodes =
in
>>>> upper filesystem and wait on temporary waiting list to avoid =
waiting on
>>>> inodes that have started writeback afterwards. By doing this,
>>>> it is able to reduce cost of synchronization and will not seriously =
impact
>>>> IO performance of irrelative processes.
>>>=20
>>> This looks like a very good improvement!
>>>=20
>>>>=20
>>>> Signed-off-by: Chengguang Xu <cgxu519@icloud.com>
>>>> ---
>>>> fs/overlayfs/ovl_entry.h |   4 ++
>>>> fs/overlayfs/super.c     | 101 =
+++++++++++++++++++++++++++++++++++++++++++++--
>>>> 2 files changed, 102 insertions(+), 3 deletions(-)
>>>>=20
>>>> diff --git a/fs/overlayfs/ovl_entry.h b/fs/overlayfs/ovl_entry.h
>>>> index 9d0bc03..e92c425 100644
>>>> --- a/fs/overlayfs/ovl_entry.h
>>>> +++ b/fs/overlayfs/ovl_entry.h
>>>> @@ -52,6 +52,8 @@ struct ovl_fs {
>>>>       /* Did we take the inuse lock? */
>>>>       bool upperdir_locked;
>>>>       bool workdir_locked;
>>>> +       /* ovl inode sync list lock */
>>>> +       spinlock_t  ovl_sync_list_lock;
>>>> };
>>>>=20
>>>> /* private information held for every overlayfs dentry */
>>>> @@ -80,6 +82,8 @@ struct ovl_inode {
>>>>=20
>>>>       /* synchronize copy up and more */
>>>>       struct mutex lock;
>>>> +       /* ovl inode sync list */
>>>> +       struct list_head sync_list;
>>>> };
>>>>=20
>>>> static inline struct ovl_inode *OVL_I(struct inode *inode)
>>>> diff --git a/fs/overlayfs/super.c b/fs/overlayfs/super.c
>>>> index 76440fe..17f1406 100644
>>>> --- a/fs/overlayfs/super.c
>>>> +++ b/fs/overlayfs/super.c
>>>> @@ -17,6 +17,8 @@
>>>> #include <linux/statfs.h>
>>>> #include <linux/seq_file.h>
>>>> #include <linux/posix_acl_xattr.h>
>>>> +#include <linux/writeback.h>
>>>> +#include <linux/blkdev.h>
>>>> #include "overlayfs.h"
>>>>=20
>>>> MODULE_AUTHOR("Miklos Szeredi <miklos@szeredi.hu>");
>>>> @@ -195,6 +197,7 @@ static struct inode *ovl_alloc_inode(struct =
super_block *sb)
>>>>       oi->__upperdentry =3D NULL;
>>>>       oi->lower =3D NULL;
>>>>       mutex_init(&oi->lock);
>>>> +       INIT_LIST_HEAD(&oi->sync_list);
>>>>=20
>>>>       return &oi->vfs_inode;
>>>> }
>>>> @@ -252,6 +255,96 @@ static void ovl_put_super(struct super_block =
*sb)
>>>>       ovl_free_fs(ofs);
>>>> }
>>>>=20
>>>> +/**
>>>> + * ovl_sync_filesystem
>>>> + * @sb: The overlayfs super block
>>>> + *
>>>> + * Sync underlying dirty inodes in upper filesystem and wait for =
completion.
>>>> + * Use temporary wait list to avoid waiting on inodes that have =
started
>>>> + * writeback after this point.
>>>> + */
>>>> +static int ovl_sync_filesystem(struct super_block *sb)
>>>> +{
>>>> +       struct ovl_fs *ofs =3D sb->s_fs_info;
>>>> +       struct super_block *upper_sb =3D ofs->upper_mnt->mnt_sb;
>>>> +       struct ovl_inode *oi, *oi_next;
>>>> +       struct inode *inode, *i_next;
>>>> +       struct inode *upper_inode;
>>>> +       struct blk_plug plug;
>>>> +       LIST_HEAD(ovl_sync_list);
>>>> +
>>>> +       struct writeback_control wbc =3D {
>>>> +               .sync_mode              =3D WB_SYNC_ALL,
>>>=20
>>> Shouldn't this be WB_SYNC_NONE? We are explicitly waiting
>>> inodes on the list afterwards=A1=AD
>>=20
>> IIUC, when wait =3D=3D 1 should use WB_SYNC_ALL mode.
>=20
> Well, yes, but for a different reason.
> According to documentation of write_cache_pages()
> WB_SYNC_ALL should be used for data integrity sync, which
> is the case of syncfs, to start write also on pages that are already
> under io, but WB_SYNC_ALL *also* implies waiting on all pages
> after starting io and that is not needed in this case, because you =
call
> filemap_fdatawait_keep_errors() later. Nevermind. WB_SYNC_ALL
> is the right value to use here AFAICT.

If you look carefully inside __writeback_single_inode(), there is a =
condition
to check whether this writeback caused by reason =A1=B0for_sync" or not, =
and if it is
then skip wait because it has a separate, external IO completion path =
and sync_fs
for guaranteeing inode metadata is written back correctly.


>=20
>>=20
>>=20
>>>=20
>>>> +               .for_sync               =3D 1,
>>>> +               .range_start            =3D 0,
>>>> +               .range_end              =3D LLONG_MAX,
>>>> +               .nr_to_write            =3D LONG_MAX,
>>>> +       };
>>>> +
>>>> +       blk_start_plug(&plug);
>>>> +       spin_lock(&sb->s_inode_list_lock);
>>>> +       list_for_each_entry_safe(inode, i_next, &sb->s_inodes, =
i_sb_list) {
>>>> +               upper_inode =3D ovl_inode_upper(inode);
>>>> +               if (!upper_inode)
>>>> +                       continue;
>>>> +
>>>> +               spin_lock(&upper_inode->i_lock);
>>>> +               if (upper_inode->i_state & (I_NEW | I_FREEING | =
I_WILL_FREE) ||
>>>> +                       list_empty(&upper_inode->i_io_list)) {
>>>> +                       spin_unlock(&upper_inode->i_lock);
>>>> +                       continue;
>>>> +               }
>>>> +               spin_unlock(&upper_inode->i_lock);
>>>> +
>>>> +               if (!igrab(inode))
>>>> +                       continue;
>>>> +
>>>> +               if (!igrab(upper_inode)) {
>>>> +                       iput(inode);
>>>> +                       continue;
>>>> +               }
>>>> +               spin_unlock(&sb->s_inode_list_lock);
>>>> +
>>>> +               sync_inode(upper_inode, &wbc);
>>>=20
>>> Maybe allowed to call sync_inode() under s_inode_list_lock
>>> if using WB_SYNC_NONE???
>>=20
>> I think if hold s_inode_list_lock long time, it will probably affect
>> inode allocation/destruction because every inode needs to be in/out
>> sb->s_inodes list.
>>=20
>>=20
>=20
> Considering that we must use WB_SYNC_ALL, my comment here
> is irrelevant.
>=20
>>> Do we not need to check return value from sync_inode()?
>>=20
>> I have no idea what extra work can we do for error case,
>> __sync_filesytem() itself does not check return code seriously.
>>=20
>>=20
>>> I bet it could be EROFS if upper fs was remounted readonly
>>> and we did not check for that before starting to sync=A1=AD
>>=20
>> I=A1=AFm curious is there a real use case like this?
>> Anyway, let=A1=AFs add check for safety.
>>=20
>>>=20
>>>> +               spin_lock(&ofs->ovl_sync_list_lock);
>>>> +               if (list_empty(&OVL_I(inode)->sync_list))
>>>> +                       list_add(&OVL_I(inode)->sync_list, =
&ovl_sync_list);
>>>> +               else {
>>>> +                       iput(upper_inode);
>>>> +                       iput(inode);
>>>> +               }
>>>> +               spin_unlock(&ofs->ovl_sync_list_lock);
>>>> +
>>>> +               if (need_resched()) {
>>>> +                       blk_finish_plug(&plug);
>>>> +                       cond_resched();
>>>> +                       blk_start_plug(&plug);
>>>> +               }
>>>> +               spin_lock(&sb->s_inode_list_lock);
>>>> +       }
>>>> +       spin_unlock(&sb->s_inode_list_lock);
>>>> +       blk_finish_plug(&plug);
>>>> +
>>>> +       mutex_lock(&upper_sb->s_sync_lock);
>>>=20
>>> I suppose mutex_lock_interruptible() is in order.
>>=20
>> I can=A1=AFt see benefit for it, and considering interruption by =
signal
>> I=A1=AFll replace temporary waiting list using sb->s_inodes list.
>>=20
>=20
> If you use mutex_lock_interruptible() at least then the 2nd user =
calling
> syncfs can interrupt the wait while 1st user is syncing.

Current syncfs for other filesystems does not behave like this,
so I want to keep consistency with others.

Thanks,
Chengguang.
