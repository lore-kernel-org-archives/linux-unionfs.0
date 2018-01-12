From: Amir Goldstein <amir73il@gmail.com>
Subject: Re: [PATCH v3] ovl: Improving syncfs efficiency
Date: Fri, 12 Jan 2018 15:01:24 +0200
Message-ID: <CAOQ4uxhuqS322Eisz10We+Lf1neBY3UHVW0CCxY46NMcSLkgMQ@mail.gmail.com>
References: <1515635335-8848-1-git-send-email-cgxu519@icloud.com>
 <CAOQ4uxhM0Cp3eBU2OfsDY9x1vMnBjMLw9qV-eK1g+yDi2erwiw@mail.gmail.com>
 <20180111100742.exdlnmnrpejeqbds@quack2.suse.cz> <D0F99186-0AF6-46F8-9280-3D8B4A848E9D@icloud.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-unionfs-owner@vger.kernel.org>
Received: from mail-yw0-f193.google.com ([209.85.161.193]:45370 "EHLO
        mail-yw0-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932797AbeALNB2 (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Fri, 12 Jan 2018 08:01:28 -0500
Received: by mail-yw0-f193.google.com with SMTP id m19so2448219ywh.12
        for <linux-unionfs@vger.kernel.org>; Fri, 12 Jan 2018 05:01:28 -0800 (PST)
In-Reply-To: <D0F99186-0AF6-46F8-9280-3D8B4A848E9D@icloud.com>
Sender: linux-unionfs-owner@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org
To: Chengguang Xu <cgxu519@icloud.com>
Cc: Jan Kara <jack@suse.cz>, Miklos Szeredi <miklos@szeredi.hu>, overlayfs <linux-unionfs@vger.kernel.org>

On Fri, Jan 12, 2018 at 9:13 AM, Chengguang Xu <cgxu519@icloud.com> wrote:
>>
>> =E5=9C=A8 2018=E5=B9=B41=E6=9C=8811=E6=97=A5=EF=BC=8C=E4=B8=8B=E5=8D=886=
:07=EF=BC=8CJan Kara <jack@suse.cz> =E5=86=99=E9=81=93=EF=BC=9A
>>
>> On Thu 11-01-18 05:30:33, Amir Goldstein wrote:
>>> [CC: Jan Kara]
>>>
>>> On Thu, Jan 11, 2018 at 3:48 AM, Chengguang Xu <cgxu519@icloud.com> wro=
te:
>>>> Currently syncfs(2) call on overlayfs just simply call sync_filesystem=
()
>>>> on upper_sb to synchronize whole dirty inodes in upper filesystem
>>>> regardless of the overlay ownership of the inode. It has obvious
>>>> shortcomings as below.
>>>>
>>>> (1) Performance
>>>> Synchronization is probably heavy in most cases, especially when upper
>>>> filesystem is not dedicated to target overlayfs.
>>>>
>>>> (2) Interference
>>>> Unplanned synchronization will probably impact IO performance of the
>>>> processes which use other overlayfs on same upper filesystem or direct=
ly
>>>> use upper filesystem.
>>>>
>>>> This patch iterates overlay inodes to only sync target dirty inodes in
>>>> upper filesystem. By doing this, It is able to reduce cost of synchron=
ization
>>>> and will not seriously impact IO performance of irrelative processes.
>>>>
>>>> Signed-off-by: Chengguang Xu <cgxu519@icloud.com>
>>>
>>> Looks good.
>>>
>>> Reviewed-by: Amir Goldstein <amir73il@gmail.com>
>>>
>>> Jan,
>>>
>>> Would you mind taking a quick look at this?
>>>
>>> Overlayfs inodes have no dirty mapping, only the underlying upper inode=
s
>>> do, so sync_inodes_sb() is not enough for overlay syncfs().
>>>
>>> This code creates the list of upper inodes to sync, syncs them and then
>>> calls the underlying upper fs sync_fs().
>>>
>>> Does this look reasonable?
>>
>> If I understand the original changelog, this is a performance motivated
>> change. As such it should have a some measurements accompanied with it t=
o
>> justify the change. I.e., how much does this help? What is the exact set=
up
>> where this matters? Do users really care?
>>
>> More technical comments inline.
>>
>>>> @@ -80,6 +83,8 @@ struct ovl_inode {
>>>>
>>>>        /* synchronize copy up and more */
>>>>        struct mutex lock;
>>>> +       /* ovl inode sync list */
>>>> +       struct list_head sync_list;
>>>> };
>>
>> Additional overhead of 16-bytes per inode - not a huge deal since this i=
s
>> overlay specific but it's something to keep in mind. Could not we reuse
>> i_io_list of the overlay inode instead?
>
> Hi Jan,
>
> Thanks for your review and comments.
> Actually I thought i_io_list in my very first version, however, it implie=
s
> that inode is connected to proper bdi_writeback but overlay does not have=
,
> so it might be incompatible in some contexts(for example, evict).
> Maybe we can reuse i_wb_list instead.
>
>
>>
>>>> diff --git a/fs/overlayfs/super.c b/fs/overlayfs/super.c
>>>> index 76440fe..947bb83 100644
>>>> --- a/fs/overlayfs/super.c
>>>> +++ b/fs/overlayfs/super.c
>> ...
>>>> +static void ovl_sync_inodes(struct super_block *sb)
>>>> +{
>>>> +       struct ovl_fs *ofs =3D sb->s_fs_info;
>>>> +       struct inode *inode, *i_next;
>>>> +       struct inode *upper_inode;
>>>> +       struct blk_plug plug;
>>>> +
>>>> +       struct writeback_control wbc =3D {
>>>> +               .sync_mode              =3D WB_SYNC_ALL,
>>>> +               .for_sync               =3D 1,
>>>> +               .range_start            =3D 0,
>>>> +               .range_end              =3D LLONG_MAX,
>>>> +               .nr_to_write            =3D LONG_MAX,
>>>> +       };
>>>> +
>>>> +       blk_start_plug(&plug);
>>>> +       spin_lock(&sb->s_inode_list_lock);
>>>> +       list_for_each_entry_safe(inode, i_next, &sb->s_inodes, i_sb_li=
st) {
>>
>> Why a _safe iteration variant here? If you hope it allows you to safely
>> resume iteration after dropping sb->s_inode_list_lock, you are wrong
>> because i_next inode can be removed from the list once you drop that loc=
k
>> as well.  You need to be more careful when iterating inodes. See how e.g=
.
>> fs/notify/fsnotify.c:fsnotify_unmount_inodes() plays tricks with always
>> keeping one inode reference to be able to resume iteration of the inode
>> list.
>>
>> Another issue is that this will iterate all inodes on the overlayfs list=
.
>> Both clean and dirty ones (well, those where underlying upper inode is
>> dirty). When there are only a few underlying dirty inodes, this may be
>> considerably slower than the original behavior. So this needs an
>> explanation in the changelog why the use case you care about is more
>> important than the use case this regresses. You might think that this wi=
ll
>> only add an iteration of an in memory list, but on large machines, this
>> list may have millions of entries so it's iteration is not exactly fast.
>>
>>>> +               upper_inode =3D ovl_inode_upper(inode);
>>>> +               if (!upper_inode)
>>>> +                       continue;
>>>> +
>>>> +               spin_lock(&upper_inode->i_lock);
>>>> +               if (upper_inode->i_state & (I_NEW | I_FREEING | I_WILL=
_FREE) ||
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
>>
>> iput() under a spinlock? Not good, that always needs a very good
>> explanation why this cannot be the last reference to drop. Preferably av=
oid
>> this altogether.
>
> Hi Amir,
>
> I reckon upper inode won't be deleted before overlay inode=EF=BC=8Cso we =
can just
> hold reference of overlay inode here, am i right?
>

You are right that overlay inode holds a reference to upper inode, so you
don't need to grab upper_inode.
However, I think you may need to grab overlay inode reference before trying=
 to
dereferecnce ovl_inode_upper(inode), so you are back to square one, having =
to
iput(inode) if (!upper_inode).
I'm afraid I don't know enough to propose a solution.
I suggest you start with Jan's suggestion to look at fsnotify_unmount_inode=
s().

Thanks,
Amir.
