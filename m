From: Amir Goldstein <amir73il@gmail.com>
Subject: Re: [PATCH] ovl: Improving syncfs efficiency
Date: Wed, 10 Jan 2018 10:47:25 +0200
Message-ID: <CAOQ4uxi-5+HR0tPymUiY=pEnCZUGtisowb7E1D8iGE+BU-xsKA@mail.gmail.com>
References: <1515400885-16622-1-git-send-email-cgxu519@icloud.com>
 <CAOQ4uxgxv=7tj97Krui2XBxiVh8-xjuxqSoq+KSxYYKwXGNQaw@mail.gmail.com>
 <4EF426AE-BBAC-4447-8CE7-E05974CDBEA8@icloud.com> <CAOQ4uxiPieowMizdymk0AfCZRhF3M3vSdWVuDSVMJXPYBMUAnA@mail.gmail.com>
 <D4D8C27A-0C87-40D0-B582-B90F60E2CE81@icloud.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-unionfs-owner@vger.kernel.org>
Received: from mail-yw0-f176.google.com ([209.85.161.176]:39792 "EHLO
        mail-yw0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752986AbeAJIr0 (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Wed, 10 Jan 2018 03:47:26 -0500
Received: by mail-yw0-f176.google.com with SMTP id q26so6738559ywa.6
        for <linux-unionfs@vger.kernel.org>; Wed, 10 Jan 2018 00:47:26 -0800 (PST)
In-Reply-To: <D4D8C27A-0C87-40D0-B582-B90F60E2CE81@icloud.com>
Sender: linux-unionfs-owner@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org
To: Chengguang Xu <cgxu519@icloud.com>
Cc: Miklos Szeredi <miklos@szeredi.hu>, overlayfs <linux-unionfs@vger.kernel.org>

On Wed, Jan 10, 2018 at 3:45 AM, Chengguang Xu <cgxu519@icloud.com> wrote:
>
>> =E5=9C=A8 2018=E5=B9=B41=E6=9C=889=E6=97=A5=EF=BC=8C=E4=B8=8B=E5=8D=889:=
29=EF=BC=8CAmir Goldstein <amir73il@gmail.com> =E5=86=99=E9=81=93=EF=BC=9A
>>
>> On Tue, Jan 9, 2018 at 2:07 PM, Chengguang Xu <cgxu519@icloud.com> wrote=
:
>>>>
>>>> =E5=9C=A8 2018=E5=B9=B41=E6=9C=888=E6=97=A5=EF=BC=8C=E4=B8=8B=E5=8D=88=
8:10=EF=BC=8CAmir Goldstein <amir73il@gmail.com> =E5=86=99=E9=81=93=EF=BC=
=9A
>>>>
>>>> On Mon, Jan 8, 2018 at 10:41 AM, Chengguang Xu <cgxu519@icloud.com> wr=
ote:
>>>>> Currently syncfs(2) call on overlayfs just simply call sync_filesyste=
m()
>>>>> on upper_sb to synchronize whole dirty inodes in upper filesystem
>>>>> regardless of the overlay ownership of the inode. It has obvious
>>>>> shortcomings as below.
>>>>>
>>>>> (1) Performance
>>>>> Synchronization is probably heavy in most cases, especially when uppe=
r
>>>>> filesystem is not dedicated to target overlayfs.
>>>>>
>>>>> (2) Interference
>>>>> Unplanned synchronization will probably impact IO performance of the
>>>>> processes which use other overlayfs on same upper filesystem or direc=
tly
>>>>> use upper filesystem.
>>>>>
>>>>> This patch iterates overlay inodes to only sync target dirty inodes i=
n
>>>>> upper filesystem and wait on temporary waiting list to avoid waiting =
on
>>>>> inodes that have started writeback afterwards. By doing this,
>>>>> it is able to reduce cost of synchronization and will not seriously i=
mpact
>>>>> IO performance of irrelative processes.
>>>>
>>>> This looks like a very good improvement!
>>>>
>>>>>
>>>>> Signed-off-by: Chengguang Xu <cgxu519@icloud.com>
>>>>> ---
>>>>> fs/overlayfs/ovl_entry.h |   4 ++
>>>>> fs/overlayfs/super.c     | 101 ++++++++++++++++++++++++++++++++++++++=
+++++++--
>>>>> 2 files changed, 102 insertions(+), 3 deletions(-)
>>>>>
>>>>> diff --git a/fs/overlayfs/ovl_entry.h b/fs/overlayfs/ovl_entry.h
>>>>> index 9d0bc03..e92c425 100644
>>>>> --- a/fs/overlayfs/ovl_entry.h
>>>>> +++ b/fs/overlayfs/ovl_entry.h
>>>>> @@ -52,6 +52,8 @@ struct ovl_fs {
>>>>>       /* Did we take the inuse lock? */
>>>>>       bool upperdir_locked;
>>>>>       bool workdir_locked;
>>>>> +       /* ovl inode sync list lock */
>>>>> +       spinlock_t  ovl_sync_list_lock;
>>>>> };
>>>>>
>>>>> /* private information held for every overlayfs dentry */
>>>>> @@ -80,6 +82,8 @@ struct ovl_inode {
>>>>>
>>>>>       /* synchronize copy up and more */
>>>>>       struct mutex lock;
>>>>> +       /* ovl inode sync list */
>>>>> +       struct list_head sync_list;
>>>>> };
>>>>>
>>>>> static inline struct ovl_inode *OVL_I(struct inode *inode)
>>>>> diff --git a/fs/overlayfs/super.c b/fs/overlayfs/super.c
>>>>> index 76440fe..17f1406 100644
>>>>> --- a/fs/overlayfs/super.c
>>>>> +++ b/fs/overlayfs/super.c
>>>>> @@ -17,6 +17,8 @@
>>>>> #include <linux/statfs.h>
>>>>> #include <linux/seq_file.h>
>>>>> #include <linux/posix_acl_xattr.h>
>>>>> +#include <linux/writeback.h>
>>>>> +#include <linux/blkdev.h>
>>>>> #include "overlayfs.h"
>>>>>
>>>>> MODULE_AUTHOR("Miklos Szeredi <miklos@szeredi.hu>");
>>>>> @@ -195,6 +197,7 @@ static struct inode *ovl_alloc_inode(struct super=
_block *sb)
>>>>>       oi->__upperdentry =3D NULL;
>>>>>       oi->lower =3D NULL;
>>>>>       mutex_init(&oi->lock);
>>>>> +       INIT_LIST_HEAD(&oi->sync_list);
>>>>>
>>>>>       return &oi->vfs_inode;
>>>>> }
>>>>> @@ -252,6 +255,96 @@ static void ovl_put_super(struct super_block *sb=
)
>>>>>       ovl_free_fs(ofs);
>>>>> }
>>>>>
>>>>> +/**
>>>>> + * ovl_sync_filesystem
>>>>> + * @sb: The overlayfs super block
>>>>> + *
>>>>> + * Sync underlying dirty inodes in upper filesystem and wait for com=
pletion.
>>>>> + * Use temporary wait list to avoid waiting on inodes that have star=
ted
>>>>> + * writeback after this point.
>>>>> + */
>>>>> +static int ovl_sync_filesystem(struct super_block *sb)
>>>>> +{
>>>>> +       struct ovl_fs *ofs =3D sb->s_fs_info;
>>>>> +       struct super_block *upper_sb =3D ofs->upper_mnt->mnt_sb;
>>>>> +       struct ovl_inode *oi, *oi_next;
>>>>> +       struct inode *inode, *i_next;
>>>>> +       struct inode *upper_inode;
>>>>> +       struct blk_plug plug;
>>>>> +       LIST_HEAD(ovl_sync_list);
>>>>> +
>>>>> +       struct writeback_control wbc =3D {
>>>>> +               .sync_mode              =3D WB_SYNC_ALL,
>>>>
>>>> Shouldn't this be WB_SYNC_NONE? We are explicitly waiting
>>>> inodes on the list afterwards=E2=80=A6
>>>
>>> IIUC, when wait =3D=3D 1 should use WB_SYNC_ALL mode.
>>
>> Well, yes, but for a different reason.
>> According to documentation of write_cache_pages()
>> WB_SYNC_ALL should be used for data integrity sync, which
>> is the case of syncfs, to start write also on pages that are already
>> under io, but WB_SYNC_ALL *also* implies waiting on all pages
>> after starting io and that is not needed in this case, because you call
>> filemap_fdatawait_keep_errors() later. Nevermind. WB_SYNC_ALL
>> is the right value to use here AFAICT.
>
> If you look carefully inside __writeback_single_inode(), there is a condi=
tion
> to check whether this writeback caused by reason =E2=80=9Cfor_sync" or no=
t, and if it is
> then skip wait because it has a separate, external IO completion path and=
 sync_fs
> for guaranteeing inode metadata is written back correctly.
>
>

I see.

I was confused by this code in write_cache_pages():

                        if (PageWriteback(page)) {
                                if (wbc->sync_mode !=3D WB_SYNC_NONE)
                                        wait_on_page_writeback(page);

I thought it meant that if sync_mode =3D=3D WB_SYNC_ALL, then waiting
on IO completion inside write_cache_pages(), but it means waiting
for a previous IO submission to complete before re-submitting IO.


>>
>>>
>>>
>>>>
>>>>> +               .for_sync               =3D 1,
>>>>> +               .range_start            =3D 0,
>>>>> +               .range_end              =3D LLONG_MAX,
>>>>> +               .nr_to_write            =3D LONG_MAX,
>>>>> +       };
>>>>> +
>>>>> +       blk_start_plug(&plug);
>>>>> +       spin_lock(&sb->s_inode_list_lock);
>>>>> +       list_for_each_entry_safe(inode, i_next, &sb->s_inodes, i_sb_l=
ist) {
>>>>> +               upper_inode =3D ovl_inode_upper(inode);
>>>>> +               if (!upper_inode)
>>>>> +                       continue;
>>>>> +
>>>>> +               spin_lock(&upper_inode->i_lock);
>>>>> +               if (upper_inode->i_state & (I_NEW | I_FREEING | I_WIL=
L_FREE) ||
>>>>> +                       list_empty(&upper_inode->i_io_list)) {
>>>>> +                       spin_unlock(&upper_inode->i_lock);
>>>>> +                       continue;
>>>>> +               }
>>>>> +               spin_unlock(&upper_inode->i_lock);
>>>>> +
>>>>> +               if (!igrab(inode))
>>>>> +                       continue;
>>>>> +
>>>>> +               if (!igrab(upper_inode)) {
>>>>> +                       iput(inode);
>>>>> +                       continue;
>>>>> +               }
>>>>> +               spin_unlock(&sb->s_inode_list_lock);
>>>>> +
>>>>> +               sync_inode(upper_inode, &wbc);
[...]
>>>>> +               spin_lock(&ofs->ovl_sync_list_lock);
>>>>> +               if (list_empty(&OVL_I(inode)->sync_list))
>>>>> +                       list_add(&OVL_I(inode)->sync_list, &ovl_sync_=
list);
>>>>> +               else {
>>>>> +                       iput(upper_inode);
>>>>> +                       iput(inode);
>>>>> +               }
>>>>> +               spin_unlock(&ofs->ovl_sync_list_lock);
>>>>> +
>>>>> +               if (need_resched()) {
>>>>> +                       blk_finish_plug(&plug);
>>>>> +                       cond_resched();
>>>>> +                       blk_start_plug(&plug);
>>>>> +               }
>>>>> +               spin_lock(&sb->s_inode_list_lock);
>>>>> +       }
>>>>> +       spin_unlock(&sb->s_inode_list_lock);
>>>>> +       blk_finish_plug(&plug);
>>>>> +
>>>>> +       mutex_lock(&upper_sb->s_sync_lock);
>>>>
>>>> I suppose mutex_lock_interruptible() is in order.
>>>
>>> I can=E2=80=99t see benefit for it, and considering interruption by sig=
nal
>>> I=E2=80=99ll replace temporary waiting list using sb->s_inodes list.
>>>
>>
>> If you use mutex_lock_interruptible() at least then the 2nd user calling
>> syncfs can interrupt the wait while 1st user is syncing.
>
> Current syncfs for other filesystems does not behave like this,
> so I want to keep consistency with others.
>

Makes sense.

Thanks,
Amir.
