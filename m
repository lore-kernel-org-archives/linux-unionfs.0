From: Amir Goldstein <amir73il@gmail.com>
Subject: Re: [PATCH v6] ovl: Improving syncfs efficiency
Date: Tue, 23 Jan 2018 11:00:02 +0200
Message-ID: <CAOQ4uxjrADQm-otTPdyFbe7w115SS6z3b336MDkDAYa4aoriKA@mail.gmail.com>
References: <1516614465-134755-1-git-send-email-cgxu519@icloud.com>
 <CAOQ4uxio56Lg+yNPxVNP4gN7jv5P01h9Y-PARH_forC3cmnv7w@mail.gmail.com>
 <767E3A51-A82D-4C41-A2B3-F639253B786C@icloud.com> <CAOQ4uxgY+bzOPBqgzYvsCUp5beOcNDXzBTGABwo+1=sHq+4RBw@mail.gmail.com>
 <BF7CEBBF-1582-4C0E-AA89-65A6DC7D07B1@icloud.com> <CAOQ4uxg5hHyEokv=ybFmvJMhGNJVD=pCKOEEAAhpP26HhythUg@mail.gmail.com>
 <0F6919E0-2872-4CEA-8762-509956BE2BBC@icloud.com> <CAOQ4uxgigN5uF8NttpA=98PnMb+VxnxACVkbv9x3qi2Z1AgE8A@mail.gmail.com>
 <A181CC06-AE90-48D4-8589-987D9F217D0A@icloud.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-unionfs-owner@vger.kernel.org>
Received: from mail-yb0-f169.google.com ([209.85.213.169]:45491 "EHLO
        mail-yb0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750946AbeAWJAD (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Tue, 23 Jan 2018 04:00:03 -0500
Received: by mail-yb0-f169.google.com with SMTP id k127so4612522ybc.12
        for <linux-unionfs@vger.kernel.org>; Tue, 23 Jan 2018 01:00:03 -0800 (PST)
In-Reply-To: <A181CC06-AE90-48D4-8589-987D9F217D0A@icloud.com>
Sender: linux-unionfs-owner@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org
To: Chengguang Xu <cgxu519@icloud.com>
Cc: Miklos Szeredi <miklos@szeredi.hu>, Jan Kara <jack@suse.cz>, overlayfs <linux-unionfs@vger.kernel.org>

On Tue, Jan 23, 2018 at 10:12 AM, Chengguang Xu <cgxu519@icloud.com> wrote:
>>
>> =E5=9C=A8 2018=E5=B9=B41=E6=9C=8823=E6=97=A5=EF=BC=8C=E4=B8=8B=E5=8D=882=
:39=EF=BC=8CAmir Goldstein <amir73il@gmail.com> =E5=86=99=E9=81=93=EF=BC=9A
>>
>> On Tue, Jan 23, 2018 at 2:24 AM, Chengguang Xu <cgxu519@icloud.com> wrot=
e:
>>>>
>>>> =E5=9C=A8 2018=E5=B9=B41=E6=9C=8823=E6=97=A5=EF=BC=8C=E4=B8=8A=E5=8D=
=882:45=EF=BC=8CAmir Goldstein <amir73il@gmail.com> =E5=86=99=E9=81=93=EF=
=BC=9A
>>>>
>>>> On Mon, Jan 22, 2018 at 6:00 PM, Chengguang Xu <cgxu519@icloud.com> wr=
ote:
>>>>>
>>>>>> =E5=9C=A8 2018=E5=B9=B41=E6=9C=8822=E6=97=A5=EF=BC=8C=E4=B8=8B=E5=8D=
=888:58=EF=BC=8CAmir Goldstein <amir73il@gmail.com> =E5=86=99=E9=81=93=EF=
=BC=9A
>>>>>>
>>>>>> On Mon, Jan 22, 2018 at 2:05 PM, Chengguang Xu <cgxu519@icloud.com> =
wrote:
>>>>>>>>
>>>>>>>> =E5=9C=A8 2018=E5=B9=B41=E6=9C=8822=E6=97=A5=EF=BC=8C=E4=B8=8B=E5=
=8D=887:27=EF=BC=8CAmir Goldstein <amir73il@gmail.com> =E5=86=99=E9=81=93=
=EF=BC=9A
>>>>>>>>
>>>>>>>> On Mon, Jan 22, 2018 at 11:47 AM, Chengguang Xu <cgxu519@icloud.co=
m> wrote:
>>>>>>>>> Currently syncfs(2) call on overlayfs just simply call sync_files=
ystem()
>>>>>>>>> on upper_sb to synchronize whole dirty inodes in upper filesystem
>>>>>>>>> regardless of the overlay ownership of the inode. In the use case=
 of
>>>>>>>>> container, when multiple containers using the same underlying upp=
er
>>>>>>>>> filesystem, it has some shortcomings as below.
>>>>>>>>>
>>>>>>>>> (1) Performance
>>>>>>>>> Synchronization is probably heavy because it actually syncs unnec=
essary
>>>>>>>>> inodes for target overlayfs.
>>>>>>>>>
>>>>>>>>> (2) Interference
>>>>>>>>> Unplanned synchronization will probably impact IO performance of
>>>>>>>>> unrelated container processes on the other overlayfs.
>>>>>>>>>
>>>>>>>>> This patch iterates upper inode list in overlayfs to only sync ta=
rget
>>>>>>>>> dirty inodes and wait for completion. By doing this, It is able t=
o reduce
>>>>>>>>> cost of synchronization and will not seriously impact IO performa=
nce of
>>>>>>>>> unrelated processes. In special case, when having very few dirty =
inodes
>>>>>>>>> and a lot of clean upper inodes in overlayfs, then iteration may =
waste
>>>>>>>>> time so that synchronization is slower than before, but we think =
the
>>>>>>>>> potential for performance improvement far surpass the potential f=
or
>>>>>>>>> performance regression in most cases.
>>>>>>>>>
>>>>>>>>> Signed-off-by: Chengguang Xu <cgxu519@icloud.com>
>>>>>>>>> ---
>>>>>>>>> Changes since v5:
>>>>>>>>> - Move sync related functions to new file sync.c.
>>>>>>>>> - Introduce OVL_EVICT_PENDING flag to avoid race conditions.
>>>>>>>>> - If ovl indoe flag is I_WILL_FREE or I_FREEING then syncfs
>>>>>>>>> will wait until OVL_EVICT_PENDING to be cleared.
>>>>>>>>> - Move inode sync operation into evict_inode from drop_inode.
>>>>>>>>> - Call upper_sb->sync_fs with no-wait after sync dirty upper
>>>>>>>>> inodes.
>>>>>>>>> - Hold s_inode_wblist_lock until deleting item from list.
>>>>>>>>> - Remove write_inode fuction because no more used.
>>>>>>>>>
>>>> [...]
>>>>>>>>
>>>>>>>>
>>>>>>>>
>>>>>>>>> +                               /* We need to do this as 'inode' =
can be freed by now */
>>>>>>>>
>>>>>>>> Could oi_prev have been freed or removed from upper_inodes list?
>>>>>>>> I don't see why not.
>>>>>>>> You could try to continue iteration from iput_inode if it is not N=
ULL,
>>>>>>>> but what if it is NULL?
>>>>>>>
>>>>>>> When iterating the list we either get reference or wait until the i=
tem gets deleted,
>>>>>>> so I think there is no chance let previous inode becomes NULL.
>>>>>>>
>>>>>>
>>>>>> Maybe I am missing something.
>>>>>> When iterating the upper_inodes list you get a reference on current =
(oi)
>>>>>> and maybe have a reference on previous via iput_inode.
>>>>>> previous may have a reference from wb_list, but that reference can b=
e lost
>>>>>> while we are not holding the wblist lock. No?
>>>>>
>>>>> The reference of previous inode can be lost if the inode is not our t=
arget,
>>>>> but it must be happened after iput(iput_inode), before this will be s=
afe.
>>>>>
>>>>
>>>> I was talking about the case where iput_inode is NULL.
>>>
>>> If iput_inode is NULL previous inode will not put reference until finis=
hing wait,
>>> so this case is safer than iput_inode having value. Meanwhile if inode =
has reference,
>>> it won=E2=80=99t get deleted from list.
>>>
>>
>> Everything you write may be true, but when writing "list" and "lock" and
>> not specifying which "list" and which "lock" the explanation is not clea=
r.
>>
>> If inode has reference it won't get deleted from upper_inodes list,
>> but it can be deleted from  s_inodes_wb list once wait for io is complet=
ed
>> and then loose the last reference and get deleted from upper_inodes list=
.
>>
>> As far as I can tell, ovl_sync_inodes() and ovl_wait_inodes() are not
>> synchronized by any exclusive lock, so when you let go of all the
>> ovl_wait_inodes() locks for finish_wait(), you have no guaranty on any
>> of the inodes on upper_inodes anymore, and specifically no guaranty
>> that oi_prev is alive.
>
> I=E2=80=99m guessing you must be worrying about one syncfs(A) is waiting =
the IO to
> be completed on inode 100, at the same time another syncfs(B) is iteratin=
g
> inode 200 which is next of inode 100 in the upper_inodes list. Right?

Not exactly. inode 100 can be put on wb_list by syncfs(B) without holding
a reference in iput_inode. Then syncfs(C) can start, see that inode 100 is
already on wb_list and don't see inode 200 on upper list at all. syncfs(C) =
will
call ovl_wait_inodes() which will drop the reference on inode 100 and then
evict of inode 100 can start and complete while syncfs(B) is still waiting =
on
EVICT_PENDING of inode 200. When wait for inode 200 in finished inode
100 is already gone.
This is a complex situation and I can't really say if it is possible or if
something will prevent it, but the best way to avoid it is to have clear
semantics, so we won't need to have this discussion at all.

>
> In this case, second syncfs(B) will get another refcount of inode 100 in
> ovl_sync_inodes() so even ater decreasing refcount of inode 100 in
> ovl_wait_inodes() for syncfs(A), inode 100 is still safe to use in
> the ovl_sync_inodes() for syncfs(B).
>
>
>>
>> As far as I can tell, your suggestion to synchronize both ovl_sync_inode=
s()
>> and ovl_wait_inodes() with sb->s_sync_lock will take care of that proble=
m.
>> Since in current implementation both functions are called with wait =3D=
=3D 1
>> anyway, I don't see any problem with synchronizing the two functions. do=
 you?
>>
>
> I did some basic tests(heavy untar && concurrent syncfs) to verify my pro=
posal,
> and up to now seems there is no problem, but I want to say my proposal is
> not mainly for addressing synchronizing problem between ovl_sync_inodes()
> and ovl_wait_inodes(), I just want the code looks simple and easy to unde=
rstand.
>
>
>> In any case, if you do agree with my analysis and add sb->s_sync_lock
>> to ovl_wait_inodes(), please document the reasons that make the upper_in=
ode
>> in ovl_wait_inodes() iteration safe, because I don't think they are as
>> trivial as
>> you make them sound.
>
> I think if we modify to my proposal, then the code will be easy enough to=
 understand,
> so there will be no much doubt for safety of list iterating.
>

I'm not sure if you are new to kernel development, but understandable code
is not less important then correct code. You are not really writing to
the compiler
you are writing for reviewers and future developers that can make subtle ch=
anges
to your code. If the semantics are not perfectly clear, then even if
your code is
correct now it could be easily broken by future developer.

So yes, your proposal sounds good in that regard.

Cheers,
Amir.
