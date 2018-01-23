From: Chengguang Xu <cgxu519@icloud.com>
Subject: Re: [PATCH v6] ovl: Improving syncfs efficiency
Date: Tue, 23 Jan 2018 08:24:17 +0800
Message-ID: <0F6919E0-2872-4CEA-8762-509956BE2BBC@icloud.com>
References: <1516614465-134755-1-git-send-email-cgxu519@icloud.com>
 <CAOQ4uxio56Lg+yNPxVNP4gN7jv5P01h9Y-PARH_forC3cmnv7w@mail.gmail.com>
 <767E3A51-A82D-4C41-A2B3-F639253B786C@icloud.com>
 <CAOQ4uxgY+bzOPBqgzYvsCUp5beOcNDXzBTGABwo+1=sHq+4RBw@mail.gmail.com>
 <BF7CEBBF-1582-4C0E-AA89-65A6DC7D07B1@icloud.com>
 <CAOQ4uxg5hHyEokv=ybFmvJMhGNJVD=pCKOEEAAhpP26HhythUg@mail.gmail.com>
Mime-Version: 1.0 (Mac OS X Mail 11.2 \(3445.5.20\))
Content-Type: text/plain; charset=gb2312
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-unionfs-owner@vger.kernel.org>
Received: from pv33p36im-asmtp002.me.com ([17.142.213.63]:39921 "EHLO
        pv33p36im-asmtp002.me.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751128AbeAWAY0 (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Mon, 22 Jan 2018 19:24:26 -0500
Received: from process-dkim-sign-daemon.pv33p36im-asmtp002.me.com by
 pv33p36im-asmtp002.me.com
 (Oracle Communications Messaging Server 8.0.1.2.20170607 64bit (built Jun  7
 2017)) id <0P2Z00L00FP26R00@pv33p36im-asmtp002.me.com> for
 linux-unionfs@vger.kernel.org; Tue, 23 Jan 2018 00:24:25 +0000 (GMT)
In-reply-to: <CAOQ4uxg5hHyEokv=ybFmvJMhGNJVD=pCKOEEAAhpP26HhythUg@mail.gmail.com>
Sender: linux-unionfs-owner@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org
To: Amir Goldstein <amir73il@gmail.com>
Cc: Miklos Szeredi <miklos@szeredi.hu>, Jan Kara <jack@suse.cz>, overlayfs <linux-unionfs@vger.kernel.org>

>=20
> =D4=DA 2018=C4=EA1=D4=C223=C8=D5=A3=AC=C9=CF=CE=E72:45=A3=ACAmir =
Goldstein <amir73il@gmail.com> =D0=B4=B5=C0=A3=BA
>=20
> On Mon, Jan 22, 2018 at 6:00 PM, Chengguang Xu <cgxu519@icloud.com> =
wrote:
>>=20
>>> =D4=DA 2018=C4=EA1=D4=C222=C8=D5=A3=AC=CF=C2=CE=E78:58=A3=ACAmir =
Goldstein <amir73il@gmail.com> =D0=B4=B5=C0=A3=BA
>>>=20
>>> On Mon, Jan 22, 2018 at 2:05 PM, Chengguang Xu <cgxu519@icloud.com> =
wrote:
>>>>>=20
>>>>> =D4=DA 2018=C4=EA1=D4=C222=C8=D5=A3=AC=CF=C2=CE=E77:27=A3=ACAmir =
Goldstein <amir73il@gmail.com> =D0=B4=B5=C0=A3=BA
>>>>>=20
>>>>> On Mon, Jan 22, 2018 at 11:47 AM, Chengguang Xu =
<cgxu519@icloud.com> wrote:
>>>>>> Currently syncfs(2) call on overlayfs just simply call =
sync_filesystem()
>>>>>> on upper_sb to synchronize whole dirty inodes in upper filesystem
>>>>>> regardless of the overlay ownership of the inode. In the use case =
of
>>>>>> container, when multiple containers using the same underlying =
upper
>>>>>> filesystem, it has some shortcomings as below.
>>>>>>=20
>>>>>> (1) Performance
>>>>>> Synchronization is probably heavy because it actually syncs =
unnecessary
>>>>>> inodes for target overlayfs.
>>>>>>=20
>>>>>> (2) Interference
>>>>>> Unplanned synchronization will probably impact IO performance of
>>>>>> unrelated container processes on the other overlayfs.
>>>>>>=20
>>>>>> This patch iterates upper inode list in overlayfs to only sync =
target
>>>>>> dirty inodes and wait for completion. By doing this, It is able =
to reduce
>>>>>> cost of synchronization and will not seriously impact IO =
performance of
>>>>>> unrelated processes. In special case, when having very few dirty =
inodes
>>>>>> and a lot of clean upper inodes in overlayfs, then iteration may =
waste
>>>>>> time so that synchronization is slower than before, but we think =
the
>>>>>> potential for performance improvement far surpass the potential =
for
>>>>>> performance regression in most cases.
>>>>>>=20
>>>>>> Signed-off-by: Chengguang Xu <cgxu519@icloud.com>
>>>>>> ---
>>>>>> Changes since v5:
>>>>>> - Move sync related functions to new file sync.c.
>>>>>> - Introduce OVL_EVICT_PENDING flag to avoid race conditions.
>>>>>> - If ovl indoe flag is I_WILL_FREE or I_FREEING then syncfs
>>>>>> will wait until OVL_EVICT_PENDING to be cleared.
>>>>>> - Move inode sync operation into evict_inode from drop_inode.
>>>>>> - Call upper_sb->sync_fs with no-wait after sync dirty upper
>>>>>> inodes.
>>>>>> - Hold s_inode_wblist_lock until deleting item from list.
>>>>>> - Remove write_inode fuction because no more used.
>>>>>>=20
> [...]
>>>>>=20
>>>>>=20
>>>>>=20
>>>>>> +                               /* We need to do this as 'inode' =
can be freed by now */
>>>>>=20
>>>>> Could oi_prev have been freed or removed from upper_inodes list?
>>>>> I don't see why not.
>>>>> You could try to continue iteration from iput_inode if it is not =
NULL,
>>>>> but what if it is NULL?
>>>>=20
>>>> When iterating the list we either get reference or wait until the =
item gets deleted,
>>>> so I think there is no chance let previous inode becomes NULL.
>>>>=20
>>>=20
>>> Maybe I am missing something.
>>> When iterating the upper_inodes list you get a reference on current =
(oi)
>>> and maybe have a reference on previous via iput_inode.
>>> previous may have a reference from wb_list, but that reference can =
be lost
>>> while we are not holding the wblist lock. No?
>>=20
>> The reference of previous inode can be lost if the inode is not our =
target,
>> but it must be happened after iput(iput_inode), before this will be =
safe.
>>=20
>=20
> I was talking about the case where iput_inode is NULL.

If iput_inode is NULL previous inode will not put reference until =
finishing wait,
so this case is safer than iput_inode having value. Meanwhile if inode =
has reference,
it won=A1=AFt get deleted from list.


>=20
>> When deleting item from list we take lock to protect from concurrent =
operations,
>> so if we have already got list lock, it will be safe to touch items =
in the list.
>>=20
>=20
> But we have let go of the list lock.

I don=A1=AFt know what do you worry about, could you be more specific?

Thanks,
Chengguang.
