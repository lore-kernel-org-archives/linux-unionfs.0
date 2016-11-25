From: Amir Goldstein <amir73il@gmail.com>
Subject: Re: [PATCH 4/7] ovl: add infrastructure for intercepting file ops
Date: Fri, 25 Nov 2016 07:22:17 +0200
Message-ID: <CAOQ4uxgC9D-eJ4y8sVMkQ4SkcopkqmN3mk0W-d1Vmsv7BEcnEg@mail.gmail.com>
References: <1479984944-1017-1-git-send-email-mszeredi@redhat.com>
 <1479984944-1017-6-git-send-email-mszeredi@redhat.com> <CAOQ4uxhcT8ihDkz4fEHAUN85=o-sP--POe8Hpq84dGZ+9ar3dw@mail.gmail.com>
 <CAJfpegto3K+G3wZ-atebMW_3ZwZ5fiA3r2F14DwTXwuaSu7sww@mail.gmail.com>
 <CAOQ4uxh9-s6+0Si+k+=wcz0TvQ5gAMHM_rwxFrnwWytj=hz+_A@mail.gmail.com>
 <CAJfpegvihASTC+uSjXruokVT-sfqegh_h1-w_dB9bLGZCMUvnQ@mail.gmail.com> <CAOQ4uxgQSqq_MLbYnx2F___DiKra2YTU21zV2BKUrXHLoKLqtA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-unionfs-owner@vger.kernel.org>
Received: from mail-wm0-f67.google.com ([74.125.82.67]:35492 "EHLO
        mail-wm0-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750995AbcKYFWx (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Fri, 25 Nov 2016 00:22:53 -0500
In-Reply-To: <CAOQ4uxgQSqq_MLbYnx2F___DiKra2YTU21zV2BKUrXHLoKLqtA@mail.gmail.com>
Sender: linux-unionfs-owner@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: Miklos Szeredi <mszeredi@redhat.com>, "linux-unionfs@vger.kernel.org" <linux-unionfs@vger.kernel.org>, linux-fsdevel <linux-fsdevel@vger.kernel.org>, linux-kernel <linux-kernel@vger.kernel.org>

On Thu, Nov 24, 2016 at 4:08 PM, Amir Goldstein <amir73il@gmail.com> wrote:
> On Thu, Nov 24, 2016 at 3:51 PM, Miklos Szeredi <miklos@szeredi.hu> wrote:
>> On Thu, Nov 24, 2016 at 2:12 PM, Amir Goldstein <amir73il@gmail.com> wrote:
>>> On Thu, Nov 24, 2016 at 2:03 PM, Miklos Szeredi <miklos@szeredi.hu> wrote:
>>>> On Thu, Nov 24, 2016 at 12:52 PM, Amir Goldstein <amir73il@gmail.com> wrote:
>>>>> On Thu, Nov 24, 2016 at 12:55 PM, Miklos Szeredi <mszeredi@redhat.com> wrote:
>>>>
>>>>>> +               /*
>>>>>> +                * These should be intercepted, but they are very unlikely to be
>>>>>> +                * a problem in practice.  Leave them alone for now.
>>>>>
>>>>> It could also be handled in vfs helpers.
>>>>> Since these ops all start with establishing that src and dest are on
>>>>> the same sb,
>>>>> then the cost of copy up of src is the cost of clone_file_range from
>>>>> lower to upper,
>>>>> so it is probably worth to copy up src and leave those fops alone.
>>>>>
>>>>>> +                */
>>>>>> +               ofop->fops.copy_file_range = orig->copy_file_range;
>>>>>> +               ofop->fops.clone_file_range = orig->clone_file_range;
>>>>>> +               ofop->fops.dedupe_file_range = orig->dedupe_file_range;
>>>>
>>>> Not sure I understand.  Why should we copy up src?  Copy up is the
>>>> problem not the solution.
>>>>
>>>
>>> Maybe the idea is ill conceived, but the reasoning is:
>>> To avoid the corner case of cloning from a stale lower src,
>>> call d_real() in vfs helpers to always copy up src before cloning from it
>>> and pass the correct file onwards.
>>
>> Which correct file?  src is still the wrong one after calling d_real.
>> We need to clone-open src, just like we do in ovl_read_iter to get the
>> correct file.  But then what's the use of copying it up beforehand?
>>
>> We could move the whole logic into the vfs, but I don't really see the point.
>>

Here is a relevant use case (creating several clones),
although not directly related to ro/rw inconsistency, which
justified putting the logic in vfs.

X is a file in lower
lower is different fs then upper
upper supports clone/dedup/copy_range

for i in `seq 1 100`; do cp --reflink=auto X X${i}; done

With current code the src and destination files are on the same
mount (test in  ioctl_file_clone), but not on the same sb (test in
vfs_clone_file_range), so cp will fall back to 100 expensive data copies.

*If* instead we d_real() and clone-open src in start of vfs_clone_file_range
*after* verifying the dest file ops support clone, then we will get only one
expensive copy up and 100 cheap clones, so its a big win.

And for the case of src and dst inodes already on the same sb, we can
skip d_real() to avoid possible unneeded copy up, although a clone up
is going to be cheap anyway.

The so called worst case is that this was a one time clone (to X1),
but the cost in this case is not huge - 1 data copy up of X and 1 clone
X->X1 instead of just 1 data copy X->X1, so the difference is negligible.

Now it's true that this is heuristic, but arguably a good one.

Amir.
