From: Chengguang Xu <cgxu519@icloud.com>
Subject: Re: [PATCH v6] ovl: Improving syncfs efficiency
Date: Tue, 23 Jan 2018 16:12:05 +0800
Message-ID: <A181CC06-AE90-48D4-8589-987D9F217D0A@icloud.com>
References: <1516614465-134755-1-git-send-email-cgxu519@icloud.com>
 <CAOQ4uxio56Lg+yNPxVNP4gN7jv5P01h9Y-PARH_forC3cmnv7w@mail.gmail.com>
 <767E3A51-A82D-4C41-A2B3-F639253B786C@icloud.com>
 <CAOQ4uxgY+bzOPBqgzYvsCUp5beOcNDXzBTGABwo+1=sHq+4RBw@mail.gmail.com>
 <BF7CEBBF-1582-4C0E-AA89-65A6DC7D07B1@icloud.com>
 <CAOQ4uxg5hHyEokv=ybFmvJMhGNJVD=pCKOEEAAhpP26HhythUg@mail.gmail.com>
 <0F6919E0-2872-4CEA-8762-509956BE2BBC@icloud.com>
 <CAOQ4uxgigN5uF8NttpA=98PnMb+VxnxACVkbv9x3qi2Z1AgE8A@mail.gmail.com>
Mime-Version: 1.0 (Mac OS X Mail 11.2 \(3445.5.20\))
Content-Type: text/plain; charset=gb2312
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-unionfs-owner@vger.kernel.org>
Received: from pv33p36im-asmtp001.me.com ([17.142.213.62]:56532 "EHLO
        pv33p36im-asmtp001.me.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750907AbeAWIMU (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Tue, 23 Jan 2018 03:12:20 -0500
Received: from process-dkim-sign-daemon.pv33p36im-asmtp001.me.com by
 pv33p36im-asmtp001.me.com
 (Oracle Communications Messaging Server 8.0.1.2.20170607 64bit (built Jun  7
 2017)) id <0P300030011MKP00@pv33p36im-asmtp001.me.com> for
 linux-unionfs@vger.kernel.org; Tue, 23 Jan 2018 08:12:19 +0000 (GMT)
In-reply-to: <CAOQ4uxgigN5uF8NttpA=98PnMb+VxnxACVkbv9x3qi2Z1AgE8A@mail.gmail.com>
Sender: linux-unionfs-owner@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org
To: Amir Goldstein <amir73il@gmail.com>
Cc: Miklos Szeredi <miklos@szeredi.hu>, Jan Kara <jack@suse.cz>, overlayfs <linux-unionfs@vger.kernel.org>

>=20
> =D4=DA 2018=C4=EA1=D4=C223=C8=D5=A3=AC=CF=C2=CE=E72:39=A3=ACAmir =
Goldstein <amir73il@gmail.com> =D0=B4=B5=C0=A3=BA
>=20
> On Tue, Jan 23, 2018 at 2:24 AM, Chengguang Xu <cgxu519@icloud.com> =
wrote:
>>>=20
>>> =D4=DA 2018=C4=EA1=D4=C223=C8=D5=A3=AC=C9=CF=CE=E72:45=A3=ACAmir =
Goldstein <amir73il@gmail.com> =D0=B4=B5=C0=A3=BA
>>>=20
>>> On Mon, Jan 22, 2018 at 6:00 PM, Chengguang Xu <cgxu519@icloud.com> =
wrote:
>>>>=20
>>>>> =D4=DA 2018=C4=EA1=D4=C222=C8=D5=A3=AC=CF=C2=CE=E78:58=A3=ACAmir =
Goldstein <amir73il@gmail.com> =D0=B4=B5=C0=A3=BA
>>>>>=20
>>>>> On Mon, Jan 22, 2018 at 2:05 PM, Chengguang Xu =
<cgxu519@icloud.com> wrote:
>>>>>>>=20
>>>>>>> =D4=DA 2018=C4=EA1=D4=C222=C8=D5=A3=AC=CF=C2=CE=E77:27=A3=ACAmir =
Goldstein <amir73il@gmail.com> =D0=B4=B5=C0=A3=BA
>>>>>>>=20
>>>>>>> On Mon, Jan 22, 2018 at 11:47 AM, Chengguang Xu =
<cgxu519@icloud.com> wrote:
>>>>>>>> Currently syncfs(2) call on overlayfs just simply call =
sync_filesystem()
>>>>>>>> on upper_sb to synchronize whole dirty inodes in upper =
filesystem
>>>>>>>> regardless of the overlay ownership of the inode. In the use =
case of
>>>>>>>> container, when multiple containers using the same underlying =
upper
>>>>>>>> filesystem, it has some shortcomings as below.
>>>>>>>>=20
>>>>>>>> (1) Performance
>>>>>>>> Synchronization is probably heavy because it actually syncs =
unnecessary
>>>>>>>> inodes for target overlayfs.
>>>>>>>>=20
>>>>>>>> (2) Interference
>>>>>>>> Unplanned synchronization will probably impact IO performance =
of
>>>>>>>> unrelated container processes on the other overlayfs.
>>>>>>>>=20
>>>>>>>> This patch iterates upper inode list in overlayfs to only sync =
target
>>>>>>>> dirty inodes and wait for completion. By doing this, It is able =
to reduce
>>>>>>>> cost of synchronization and will not seriously impact IO =
performance of
>>>>>>>> unrelated processes. In special case, when having very few =
dirty inodes
>>>>>>>> and a lot of clean upper inodes in overlayfs, then iteration =
may waste
>>>>>>>> time so that synchronization is slower than before, but we =
think the
>>>>>>>> potential for performance improvement far surpass the potential =
for
>>>>>>>> performance regression in most cases.
>>>>>>>>=20
>>>>>>>> Signed-off-by: Chengguang Xu <cgxu519@icloud.com>
>>>>>>>> ---
>>>>>>>> Changes since v5:
>>>>>>>> - Move sync related functions to new file sync.c.
>>>>>>>> - Introduce OVL_EVICT_PENDING flag to avoid race conditions.
>>>>>>>> - If ovl indoe flag is I_WILL_FREE or I_FREEING then syncfs
>>>>>>>> will wait until OVL_EVICT_PENDING to be cleared.
>>>>>>>> - Move inode sync operation into evict_inode from drop_inode.
>>>>>>>> - Call upper_sb->sync_fs with no-wait after sync dirty upper
>>>>>>>> inodes.
>>>>>>>> - Hold s_inode_wblist_lock until deleting item from list.
>>>>>>>> - Remove write_inode fuction because no more used.
>>>>>>>>=20
>>> [...]
>>>>>>>=20
>>>>>>>=20
>>>>>>>=20
>>>>>>>> +                               /* We need to do this as =
'inode' can be freed by now */
>>>>>>>=20
>>>>>>> Could oi_prev have been freed or removed from upper_inodes list?
>>>>>>> I don't see why not.
>>>>>>> You could try to continue iteration from iput_inode if it is not =
NULL,
>>>>>>> but what if it is NULL?
>>>>>>=20
>>>>>> When iterating the list we either get reference or wait until the =
item gets deleted,
>>>>>> so I think there is no chance let previous inode becomes NULL.
>>>>>>=20
>>>>>=20
>>>>> Maybe I am missing something.
>>>>> When iterating the upper_inodes list you get a reference on =
current (oi)
>>>>> and maybe have a reference on previous via iput_inode.
>>>>> previous may have a reference from wb_list, but that reference can =
be lost
>>>>> while we are not holding the wblist lock. No?
>>>>=20
>>>> The reference of previous inode can be lost if the inode is not our =
target,
>>>> but it must be happened after iput(iput_inode), before this will be =
safe.
>>>>=20
>>>=20
>>> I was talking about the case where iput_inode is NULL.
>>=20
>> If iput_inode is NULL previous inode will not put reference until =
finishing wait,
>> so this case is safer than iput_inode having value. Meanwhile if =
inode has reference,
>> it won=A1=AFt get deleted from list.
>>=20
>=20
> Everything you write may be true, but when writing "list" and "lock" =
and
> not specifying which "list" and which "lock" the explanation is not =
clear.
>=20
> If inode has reference it won't get deleted from upper_inodes list,
> but it can be deleted from  s_inodes_wb list once wait for io is =
completed
> and then loose the last reference and get deleted from upper_inodes =
list.
>=20
> As far as I can tell, ovl_sync_inodes() and ovl_wait_inodes() are not
> synchronized by any exclusive lock, so when you let go of all the
> ovl_wait_inodes() locks for finish_wait(), you have no guaranty on any
> of the inodes on upper_inodes anymore, and specifically no guaranty
> that oi_prev is alive.

I=A1=AFm guessing you must be worrying about one syncfs(A) is waiting =
the IO to
be completed on inode 100, at the same time another syncfs(B) is =
iterating
inode 200 which is next of inode 100 in the upper_inodes list. Right?

In this case, second syncfs(B) will get another refcount of inode 100 in
ovl_sync_inodes() so even ater decreasing refcount of inode 100 in=20
ovl_wait_inodes() for syncfs(A), inode 100 is still safe to use in
the ovl_sync_inodes() for syncfs(B).=20


>=20
> As far as I can tell, your suggestion to synchronize both =
ovl_sync_inodes()
> and ovl_wait_inodes() with sb->s_sync_lock will take care of that =
problem.
> Since in current implementation both functions are called with wait =3D=3D=
 1
> anyway, I don't see any problem with synchronizing the two functions. =
do you?
>=20

I did some basic tests(heavy untar && concurrent syncfs) to verify my =
proposal,=20
and up to now seems there is no problem, but I want to say my proposal =
is
not mainly for addressing synchronizing problem between =
ovl_sync_inodes()
and ovl_wait_inodes(), I just want the code looks simple and easy to =
understand.


> In any case, if you do agree with my analysis and add sb->s_sync_lock
> to ovl_wait_inodes(), please document the reasons that make the =
upper_inode
> in ovl_wait_inodes() iteration safe, because I don't think they are as
> trivial as
> you make them sound.

I think if we modify to my proposal, then the code will be easy enough =
to understand,
so there will be no much doubt for safety of list iterating.


Thanks,
Chengguang.
