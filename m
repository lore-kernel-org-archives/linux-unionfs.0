From: "zhangyi (F)" <yi.zhang@huawei.com>
Subject: Re: [PATCH v2 01/18] overlay: implement fsck utility
Date: Fri, 15 Dec 2017 17:13:42 +0800
Message-ID: <589bb0c5-5c70-6b33-c265-206ca2a621ed@huawei.com>
References: <20171214064747.20999-1-yi.zhang@huawei.com>
 <20171214064747.20999-2-yi.zhang@huawei.com>
 <CAJfpegvCDyD3Zmc-h5hzkYRGC-cAn4myub3fwvqEVhRNse=yaw@mail.gmail.com>
 <75c3288d-a2d5-d476-17a9-06b56f187152@huawei.com>
 <CAOQ4uxhbZdcf88bKMN-UpZ+vLg4ckvP2qk644aoxO6k5iFApcA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-unionfs-owner@vger.kernel.org>
Received: from szxga07-in.huawei.com ([45.249.212.35]:46166 "EHLO huawei.com"
        rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org with ESMTP
        id S1754988AbdLOJOK (ORCPT <rfc822;linux-unionfs@vger.kernel.org>);
        Fri, 15 Dec 2017 04:14:10 -0500
In-Reply-To: <CAOQ4uxhbZdcf88bKMN-UpZ+vLg4ckvP2qk644aoxO6k5iFApcA@mail.gmail.com>
Sender: linux-unionfs-owner@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org
To: Amir Goldstein <amir73il@gmail.com>
Cc: Miklos Szeredi <miklos@szeredi.hu>, "linux-unionfs@vger.kernel.org" <linux-unionfs@vger.kernel.org>, fstests <fstests@vger.kernel.org>, Eryu Guan <eguan@redhat.com>, "Darrick J. Wong" <darrick.wong@oracle.com>, Miao Xie <miaoxie@huawei.com>

On 2017/12/15 15:45, Amir Goldstein Wrote:
> On Fri, Dec 15, 2017 at 5:35 AM, zhangyi (F) <yi.zhang@huawei.com> wrote:
>> On 2017/12/14 22:13, Miklos Szeredi Wrote:
> [...]
> 
>>>
>>>>
>>>> Opaque directories
>>>> ------------------
>>>>
>>>> An opaque directory is a directory with "trusted.overlay.opaque" xattr
>>>> valued "y". There are two legal situations of making opaque directory: 1)
>>>> create directory over whiteout 2) creat directory in merged directory. If an
>>>> opaque directory is found, corresponding matching name in lower layers might
>>>> exist or parent directory might merged, If not, the opaque xattr will be
>>>> treated as invalid and remove.
>>>
>>> Current version of overlay fs doesn't bother with removing opaque
>>> attribute.  So not sure fsck.overlay should care.  Or at least is
>>> should be an optional thing and not worth warning about, since it's
>>> perfectly normal.
>>>
>> Indeed, we can introduce '-f' option to handle this (e2fsck(8)):
>>
>>   -f     Force checking even if the file system seems clean.
>>
> 
> Hmm, I would not use -f for that, because it means something completely
> different in e2fsck.
> ext4 has a "clean" super block flag, which is set on clean unmount.
> -f means to run even if "clean" flag is set.
> Please reserve -f for that future use case.
> What Miklos is saying, and I agree with him, is that fsck.overlay should be
> resolve inconsistencies rather then cleanup leftovers that don't bother anyone.
> 
Yes, it seems that check opaque is useless, we should more take care of what will
lead to inconsistencies, will remove this check.

> BTW, you should also add a check for "impure" xattr.
> There are clear rules about when "impure" should be set - when a pure dir has
> entries with "origin" or "redirect" entries inside it - those rule
> were NOT honored
> since introduction of "redirect" and they were even not fully honored sine
> introduction of "origin" ("ovl: mark parent impure on ovl_link()" was
> added later)
> 
> Missing "impure" will cause wrong d_ino in readdir of impure dir.
> 
This is listed in my todo list, will realize this check soon.

> [...]
> 
>>>
>>>> 2) The origin directory should be redirected only once in one layer,
>>>> which mean there is only one redirect xattr point to this origin directory in
>>>> the specified layer.
>>>> 3) A whiteout or an opaque directory with the same name to origin should
>>>> exist in the same directory as the redirect directory.
>>>>
>>>> If not, 1) The redirect xattr is invalid and need to remove 2) One of
>>>> the redirect xattr is redundant but not sure which one is, ask user 3)
>>>> Create a whiteout device or set opaque xattr to an existing directory if the
>>>> parent directory was meregd or remove xattr if not.
>>>
>>> Hmm, in this case also should ask the user, as it's not clear that the
>>> "new" copy resulting from removal of whiteout on upper is the wanted
>>> one or the "old" renamed copy.
>>>
>> Thanks for point this out, do you mean the newly created directory over whiteout
>> between old renamed directory? If so, Amir have already pointed out in the first
>> iteration and I handled it in current version. Please see:
>>
>> https://www.spinics.net/lists/linux-unionfs/msg03268.html
>>
>> Now, fsck will also check dir's redirect xattr for this case, it will add opaque
>> xattr only when parent is merged and not redirected.
>>
> 
> I think what Miklos meant is what I wrote in comment to test 203.
> User needs to be asked which dir should be the merge dir and not
> assume that the redirected dir is the correct answer.
> 
Understand, will fix it.

Thanks,
Yi.
