From: Amir Goldstein <amir73il@gmail.com>
Subject: Re: [PATCH v6] ovl: Improving syncfs efficiency
Date: Mon, 22 Jan 2018 20:45:06 +0200
Message-ID: <CAOQ4uxg5hHyEokv=ybFmvJMhGNJVD=pCKOEEAAhpP26HhythUg@mail.gmail.com>
References: <1516614465-134755-1-git-send-email-cgxu519@icloud.com>
 <CAOQ4uxio56Lg+yNPxVNP4gN7jv5P01h9Y-PARH_forC3cmnv7w@mail.gmail.com>
 <767E3A51-A82D-4C41-A2B3-F639253B786C@icloud.com> <CAOQ4uxgY+bzOPBqgzYvsCUp5beOcNDXzBTGABwo+1=sHq+4RBw@mail.gmail.com>
 <BF7CEBBF-1582-4C0E-AA89-65A6DC7D07B1@icloud.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-unionfs-owner@vger.kernel.org>
Received: from mail-yw0-f178.google.com ([209.85.161.178]:43556 "EHLO
        mail-yw0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751113AbeAVSpH (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Mon, 22 Jan 2018 13:45:07 -0500
Received: by mail-yw0-f178.google.com with SMTP id x190so3578668ywd.10
        for <linux-unionfs@vger.kernel.org>; Mon, 22 Jan 2018 10:45:07 -0800 (PST)
In-Reply-To: <BF7CEBBF-1582-4C0E-AA89-65A6DC7D07B1@icloud.com>
Sender: linux-unionfs-owner@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org
To: Chengguang Xu <cgxu519@icloud.com>
Cc: Miklos Szeredi <miklos@szeredi.hu>, Jan Kara <jack@suse.cz>, overlayfs <linux-unionfs@vger.kernel.org>

On Mon, Jan 22, 2018 at 6:00 PM, Chengguang Xu <cgxu519@icloud.com> wrote:
>
>> =E5=9C=A8 2018=E5=B9=B41=E6=9C=8822=E6=97=A5=EF=BC=8C=E4=B8=8B=E5=8D=888=
:58=EF=BC=8CAmir Goldstein <amir73il@gmail.com> =E5=86=99=E9=81=93=EF=BC=9A
>>
>> On Mon, Jan 22, 2018 at 2:05 PM, Chengguang Xu <cgxu519@icloud.com> wrot=
e:
>>>>
>>>> =E5=9C=A8 2018=E5=B9=B41=E6=9C=8822=E6=97=A5=EF=BC=8C=E4=B8=8B=E5=8D=
=887:27=EF=BC=8CAmir Goldstein <amir73il@gmail.com> =E5=86=99=E9=81=93=EF=
=BC=9A
>>>>
>>>> On Mon, Jan 22, 2018 at 11:47 AM, Chengguang Xu <cgxu519@icloud.com> w=
rote:
>>>>> Currently syncfs(2) call on overlayfs just simply call sync_filesyste=
m()
>>>>> on upper_sb to synchronize whole dirty inodes in upper filesystem
>>>>> regardless of the overlay ownership of the inode. In the use case of
>>>>> container, when multiple containers using the same underlying upper
>>>>> filesystem, it has some shortcomings as below.
>>>>>
>>>>> (1) Performance
>>>>> Synchronization is probably heavy because it actually syncs unnecessa=
ry
>>>>> inodes for target overlayfs.
>>>>>
>>>>> (2) Interference
>>>>> Unplanned synchronization will probably impact IO performance of
>>>>> unrelated container processes on the other overlayfs.
>>>>>
>>>>> This patch iterates upper inode list in overlayfs to only sync target
>>>>> dirty inodes and wait for completion. By doing this, It is able to re=
duce
>>>>> cost of synchronization and will not seriously impact IO performance =
of
>>>>> unrelated processes. In special case, when having very few dirty inod=
es
>>>>> and a lot of clean upper inodes in overlayfs, then iteration may wast=
e
>>>>> time so that synchronization is slower than before, but we think the
>>>>> potential for performance improvement far surpass the potential for
>>>>> performance regression in most cases.
>>>>>
>>>>> Signed-off-by: Chengguang Xu <cgxu519@icloud.com>
>>>>> ---
>>>>> Changes since v5:
>>>>> - Move sync related functions to new file sync.c.
>>>>> - Introduce OVL_EVICT_PENDING flag to avoid race conditions.
>>>>> - If ovl indoe flag is I_WILL_FREE or I_FREEING then syncfs
>>>>> will wait until OVL_EVICT_PENDING to be cleared.
>>>>> - Move inode sync operation into evict_inode from drop_inode.
>>>>> - Call upper_sb->sync_fs with no-wait after sync dirty upper
>>>>> inodes.
>>>>> - Hold s_inode_wblist_lock until deleting item from list.
>>>>> - Remove write_inode fuction because no more used.
>>>>>
[...]
>>>>
>>>>
>>>>
>>>>> +                               /* We need to do this as 'inode' can =
be freed by now */
>>>>
>>>> Could oi_prev have been freed or removed from upper_inodes list?
>>>> I don't see why not.
>>>> You could try to continue iteration from iput_inode if it is not NULL,
>>>> but what if it is NULL?
>>>
>>> When iterating the list we either get reference or wait until the item =
gets deleted,
>>> so I think there is no chance let previous inode becomes NULL.
>>>
>>
>> Maybe I am missing something.
>> When iterating the upper_inodes list you get a reference on current (oi)
>> and maybe have a reference on previous via iput_inode.
>> previous may have a reference from wb_list, but that reference can be lo=
st
>> while we are not holding the wblist lock. No?
>
> The reference of previous inode can be lost if the inode is not our targe=
t,
> but it must be happened after iput(iput_inode), before this will be safe.
>

I was talking about the case where iput_inode is NULL.

> When deleting item from list we take lock to protect from concurrent oper=
ations,
> so if we have already got list lock, it will be safe to touch items in th=
e list.
>

But we have let go of the list lock.

>>
>>>
>>>> Maybe instead of iput_inode =3D NULL when adding to inodes_wb list
>>>> get another reference to inode and always store iput_inode =3D inode
>>>> to use as prev in this case?
>>>
>>> Maybe it=E2=80=99s better than current, but I think it=E2=80=99s more c=
omplex to understand
>>> the behavior, so please let me wait for more comments for the approach.
>>>
>>
>> Sure, let's wait for other comments, but I can't say I understand what i=
s
>> complex to understand about change that I propose. If anything it is sim=
pler
>> to understand, especially if you rename iput_inode to prev_inode:
>>
>> +               /*
>> +                * If ovl inode is not in sb->s_inodes_wb list, add to t=
he
>> +                * list and increment inode reference until IO to be
>> completed on
>> +                * the inode.
>> +                */
>> +               spin_lock(&sb->s_inode_wblist_lock);
>> +               if (list_empty(&inode->i_wb_list)) {
>> +                       list_add_tail(&inode->i_wb_list, &sb->s_inodes_w=
b);
>> +                       ihold(inode);
>> +               }
>> +               iput_inode =3D inode;
>
>
> Actually, I forgot to compare whether the previous item is the list head =
or not,
> so I think there is a problem when deleting very first item in the list,
> even we use iput_inode here, we can=E2=80=99t get rid of list operation b=
ecause of that.
> if you think the code should be more readable, how about modify like belo=
w?
>
> 1. take sb->s_sync_lock mutex lock
> 2. splice to local temp list
> 3. get first entry every time to operate
> 4. put into sb->s_inode_wblist again one by one
>
> I think there is no much concurrent syncfs running at the same time.

This could work. Need to see it.

>
>
>>
>>>
>>>>
>>>> It would be good if you wrote the "life cycle" of ovl_inode in a
>>>> header comment to
>>>> this file because it has become non-trivial to follow.
>>>> An explicit mention of locking order is also very good to have in
>>>> header comment.
>>>>
>>>>
>>>
>>> Let me add in next version.
>>>
>>> Talking about life cycle of ovl_inode, currently I only mark OVL_EVICT_=
EXPENDING
>>> for ovl_inode which has upper inode, is it acceptable?
>>>
>>
>> Until your change, ovl_inode life cycle was 'generic' when refcount
>> dropped to 0.
>> Now, inode can be in OVL_EVICT_PENDING state, it can be waiting for sync
>> on or off upper_inodes list. I'm just saying it would be nice to
>> document all the
>> possible states of an ovl_inode during eviction and document all the loc=
king
>> and refcount guaranties in one place to see that we did not miss anythin=
g.
>>
>> The volume of this documentation is entirely up to you.
>> I think it will be good for you as well to tell the whole story from
>> start to end
>> and verify there are no holes in the plot.
>
>
> I did not mean only write above asking to the document, I=E2=80=99m just =
asking option for OVL_EVICT_PEDING flag.

If you meant the flag name or using a flag in general, that seems good to m=
e.

> Currently the flag cycle of ovl indoe split into different cycles by havi=
ng upper inode or not.
>
> 1. having upper inode
> (allocation) -> new -> none -> OVL_EVICT_PENDING|I_FREEING -> I_FREEING|I=
_CLEAR -> (destruction)
>

That's good, if there are other conditions that guaranty that state
transitions are not racy
like list locks concurrent sync lock and elevated reflink you should
mention them.

Cheers,
Amir.
