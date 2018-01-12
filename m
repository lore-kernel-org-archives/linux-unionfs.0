From: Chengguang Xu <cgxu519@icloud.com>
Subject: Re: [PATCH v3] ovl: Improving syncfs efficiency
Date: Fri, 12 Jan 2018 15:13:26 +0800
Message-ID: <D0F99186-0AF6-46F8-9280-3D8B4A848E9D@icloud.com>
References: <1515635335-8848-1-git-send-email-cgxu519@icloud.com>
 <CAOQ4uxhM0Cp3eBU2OfsDY9x1vMnBjMLw9qV-eK1g+yDi2erwiw@mail.gmail.com>
 <20180111100742.exdlnmnrpejeqbds@quack2.suse.cz>
Mime-Version: 1.0 (Mac OS X Mail 11.2 \(3445.5.20\))
Content-Type: text/plain; charset=gb2312
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-unionfs-owner@vger.kernel.org>
Received: from pv33p36im-asmtp001.me.com ([17.142.213.62]:53949 "EHLO
        pv33p36im-asmtp001.me.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754384AbeALHNd (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Fri, 12 Jan 2018 02:13:33 -0500
Received: from process-dkim-sign-daemon.pv33p36im-asmtp001.me.com by
 pv33p36im-asmtp001.me.com
 (Oracle Communications Messaging Server 8.0.1.2.20170607 64bit (built Jun  7
 2017)) id <0P2F00C00L740S00@pv33p36im-asmtp001.me.com> for
 linux-unionfs@vger.kernel.org; Fri, 12 Jan 2018 07:13:32 +0000 (GMT)
In-reply-to: <20180111100742.exdlnmnrpejeqbds@quack2.suse.cz>
Sender: linux-unionfs-owner@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org
To: Jan Kara <jack@suse.cz>, Amir Goldstein <amir73il@gmail.com>
Cc: Miklos Szeredi <miklos@szeredi.hu>, overlayfs <linux-unionfs@vger.kernel.org>

>=20
> =D4=DA 2018=C4=EA1=D4=C211=C8=D5=A3=AC=CF=C2=CE=E76:07=A3=ACJan Kara =
<jack@suse.cz> =D0=B4=B5=C0=A3=BA
>=20
> On Thu 11-01-18 05:30:33, Amir Goldstein wrote:
>> [CC: Jan Kara]
>>=20
>> On Thu, Jan 11, 2018 at 3:48 AM, Chengguang Xu <cgxu519@icloud.com> =
wrote:
>>> Currently syncfs(2) call on overlayfs just simply call =
sync_filesystem()
>>> on upper_sb to synchronize whole dirty inodes in upper filesystem
>>> regardless of the overlay ownership of the inode. It has obvious
>>> shortcomings as below.
>>>=20
>>> (1) Performance
>>> Synchronization is probably heavy in most cases, especially when =
upper
>>> filesystem is not dedicated to target overlayfs.
>>>=20
>>> (2) Interference
>>> Unplanned synchronization will probably impact IO performance of the
>>> processes which use other overlayfs on same upper filesystem or =
directly
>>> use upper filesystem.
>>>=20
>>> This patch iterates overlay inodes to only sync target dirty inodes =
in
>>> upper filesystem. By doing this, It is able to reduce cost of =
synchronization
>>> and will not seriously impact IO performance of irrelative =
processes.
>>>=20
>>> Signed-off-by: Chengguang Xu <cgxu519@icloud.com>
>>=20
>> Looks good.
>>=20
>> Reviewed-by: Amir Goldstein <amir73il@gmail.com>
>>=20
>> Jan,
>>=20
>> Would you mind taking a quick look at this?
>>=20
>> Overlayfs inodes have no dirty mapping, only the underlying upper =
inodes
>> do, so sync_inodes_sb() is not enough for overlay syncfs().
>>=20
>> This code creates the list of upper inodes to sync, syncs them and =
then
>> calls the underlying upper fs sync_fs().
>>=20
>> Does this look reasonable?
>=20
> If I understand the original changelog, this is a performance =
motivated
> change. As such it should have a some measurements accompanied with it =
to
> justify the change. I.e., how much does this help? What is the exact =
setup
> where this matters? Do users really care?
>=20
> More technical comments inline.
>=20
>>> @@ -80,6 +83,8 @@ struct ovl_inode {
>>>=20
>>>        /* synchronize copy up and more */
>>>        struct mutex lock;
>>> +       /* ovl inode sync list */
>>> +       struct list_head sync_list;
>>> };
>=20
> Additional overhead of 16-bytes per inode - not a huge deal since this =
is
> overlay specific but it's something to keep in mind. Could not we =
reuse
> i_io_list of the overlay inode instead?

Hi Jan,

Thanks for your review and comments.=20
Actually I thought i_io_list in my very first version, however, it =
implies
that inode is connected to proper bdi_writeback but overlay does not =
have,
so it might be incompatible in some contexts(for example, evict).=20
Maybe we can reuse i_wb_list instead.


>=20
>>> diff --git a/fs/overlayfs/super.c b/fs/overlayfs/super.c
>>> index 76440fe..947bb83 100644
>>> --- a/fs/overlayfs/super.c
>>> +++ b/fs/overlayfs/super.c
> ...
>>> +static void ovl_sync_inodes(struct super_block *sb)
>>> +{
>>> +       struct ovl_fs *ofs =3D sb->s_fs_info;
>>> +       struct inode *inode, *i_next;
>>> +       struct inode *upper_inode;
>>> +       struct blk_plug plug;
>>> +
>>> +       struct writeback_control wbc =3D {
>>> +               .sync_mode              =3D WB_SYNC_ALL,
>>> +               .for_sync               =3D 1,
>>> +               .range_start            =3D 0,
>>> +               .range_end              =3D LLONG_MAX,
>>> +               .nr_to_write            =3D LONG_MAX,
>>> +       };
>>> +
>>> +       blk_start_plug(&plug);
>>> +       spin_lock(&sb->s_inode_list_lock);
>>> +       list_for_each_entry_safe(inode, i_next, &sb->s_inodes, =
i_sb_list) {
>=20
> Why a _safe iteration variant here? If you hope it allows you to =
safely
> resume iteration after dropping sb->s_inode_list_lock, you are wrong
> because i_next inode can be removed from the list once you drop that =
lock
> as well.  You need to be more careful when iterating inodes. See how =
e.g.
> fs/notify/fsnotify.c:fsnotify_unmount_inodes() plays tricks with =
always
> keeping one inode reference to be able to resume iteration of the =
inode
> list.
>=20
> Another issue is that this will iterate all inodes on the overlayfs =
list.
> Both clean and dirty ones (well, those where underlying upper inode is
> dirty). When there are only a few underlying dirty inodes, this may be
> considerably slower than the original behavior. So this needs an
> explanation in the changelog why the use case you care about is more
> important than the use case this regresses. You might think that this =
will
> only add an iteration of an in memory list, but on large machines, =
this
> list may have millions of entries so it's iteration is not exactly =
fast.
>=20
>>> +               upper_inode =3D ovl_inode_upper(inode);
>>> +               if (!upper_inode)
>>> +                       continue;
>>> +
>>> +               spin_lock(&upper_inode->i_lock);
>>> +               if (upper_inode->i_state & (I_NEW | I_FREEING | =
I_WILL_FREE) ||
>>> +                       list_empty(&upper_inode->i_io_list)) {
>>> +                       spin_unlock(&upper_inode->i_lock);
>>> +                       continue;
>>> +               }
>>> +               spin_unlock(&upper_inode->i_lock);
>>> +
>>> +               if (!igrab(inode))
>>> +                       continue;
>>> +
>>> +               if (!igrab(upper_inode)) {
>>> +                       iput(inode);
>=20
> iput() under a spinlock? Not good, that always needs a very good
> explanation why this cannot be the last reference to drop. Preferably =
avoid
> this altogether.

Hi Amir,

I reckon upper inode won't be deleted before overlay inode=A3=ACso we =
can just
hold reference of overlay inode here, am i right?



Thanks,
Chengguang.
