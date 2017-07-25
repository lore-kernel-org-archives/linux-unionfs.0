From: Amir Goldstein <amir73il@gmail.com>
Subject: Re: [PATCH 10/10] ovl: follow decoded origin file handle of merge dir
Date: Wed, 26 Jul 2017 01:19:21 +0300
Message-ID: <CAOQ4uxibj+od+RiwZ2zAJXwaudy4g7xDaVVng-eU3OhX4OJjHw@mail.gmail.com>
References: <1499777923-29410-1-git-send-email-amir73il@gmail.com>
 <1499777923-29410-11-git-send-email-amir73il@gmail.com> <CAJfpegtk9RiN6cwKXRHoh9i+_tOgYyW+PFkrwEXvit_J9Pm3cw@mail.gmail.com>
 <CAOQ4uxhVCw4BBoNw5O46_yh_TChDy6tp_ahKHnjdui3oVON8iA@mail.gmail.com>
 <CAJfpegvK8iNJWbM_hbCMGOKey5AOAhP6wtPAOwc2a6ACQf_RXw@mail.gmail.com>
 <CAOQ4uxgBuka1Sz4k5BDWuOxB-p8AH1Vr17pi3bn7xFo57AimZA@mail.gmail.com>
 <CAJfpeguaYyBhaz3GG27i4-gP-CQ+RoqYttYCzP9HkykxdE_W7w@mail.gmail.com>
 <CAOQ4uxhuGZjepSaAkaJQ1BjL-ePVtfBrwio=5E5WFAaM+fpOgA@mail.gmail.com>
 <CAJfpeguuF4bnOM6ThK3x7kcjd6hQ3TWiZSOyRDA5u9vKhOWJ6A@mail.gmail.com>
 <CAOQ4uxjk4e1yEvaprnQW+rQVgUGY4EcVuFxtdV5-NHHnd7Yy-g@mail.gmail.com> <CAJfpeguk7J+-rKTjXqX2-VnErAoXv3jiW83syaA14tpZxOY0Eg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-unionfs-owner@vger.kernel.org>
Received: from mail-yw0-f193.google.com ([209.85.161.193]:34811 "EHLO
        mail-yw0-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750972AbdGYWTW (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Tue, 25 Jul 2017 18:19:22 -0400
Received: by mail-yw0-f193.google.com with SMTP id t139so1438864ywg.1
        for <linux-unionfs@vger.kernel.org>; Tue, 25 Jul 2017 15:19:22 -0700 (PDT)
In-Reply-To: <CAJfpeguk7J+-rKTjXqX2-VnErAoXv3jiW83syaA14tpZxOY0Eg@mail.gmail.com>
Sender: linux-unionfs-owner@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: "linux-unionfs@vger.kernel.org" <linux-unionfs@vger.kernel.org>

On Tue, Jul 25, 2017 at 6:16 PM, Miklos Szeredi <miklos@szeredi.hu> wrote:
> On Tue, Jul 25, 2017 at 4:30 PM, Amir Goldstein <amir73il@gmail.com> wrote:
>> On Tue, Jul 25, 2017 at 2:33 PM, Miklos Szeredi <miklos@szeredi.hu> wrote:
>>> On Mon, Jul 24, 2017 at 2:14 PM, Amir Goldstein <amir73il@gmail.com> wrote:
>>>> On Mon, Jul 24, 2017 at 11:48 AM, Miklos Szeredi <miklos@szeredi.hu> wrote:
>>>>> On Fri, Jul 14, 2017 at 12:58 PM, Amir Goldstein <amir73il@gmail.com> wrote:
>>>>>
>>>>>> If you don't want to bundle index=on with NFS export, then no rush to merge
>>>>>> these patches now. The added benefit on patch 9 (retroactive marking merge
>>>>>> dir with origin for not exposing whiteouts) is relevant to a patch that is not
>>>>>> going to land in v4.13 anyway. right?
>>>>>
>>>>> Right.
>>>>>
>>>>> Can we maybe postpone the verification until fh decode time?
>>>>
>>>> Not sure I follow.
>>>> Failure to verify lower dir can result in merge dir not being merged or being
>>>> merged with a different lower dir (followed by fh).
>>>>
>>>> The question is which inode we choose to encode in case lower dir cannot be
>>>> verified: the unverified lower inode, the stored origin inode or the
>>>> upper inode.
>>>>
>>>> Are you suggesting that "normal" lookup will merge the unverified lower dir
>>>> and then a pair of encode/decode will result in another dentry?
>>>> or are you suggesting to return ESTALE in that case?
>>>> If latter, then that error we be permanent? encode/decode will alway end up
>>>> with ESTALE??
>>>
>>> Putting a bit more thought into this...
>>>
>>> I think we have several different cases
>>>
>>>  a) offline move of lower dir, no active NFS export
>>>
>>>  b) online move of lower dir, no active NFS export
>>>
>>>  c) offline move of lower dir, active NFS export
>>>
>>>  d) online move of lower dir, active NFS export
>>>
>>>  e) offline move of lower dir, snapshotfs
>>>
>>>  f) online move of lower dir, snapshotfs
>>>
>>> The behavior of (a) is well defined: we do not follow origin of
>>> directories for merging.  It might make sense to introduce a variant
>>> that does follow origin, but I'm not sure I see the usefulness.
>>>
>>> The behavior of (b) is undefined, it might make sense to add an
>>> ovl_d_revalidate() and make that case behave like (a)
>>>
>>> For first version we can say that (c) and (d) are both undefined.  I
>>> think the logical behavior would be to return ESTALE when we detect
>>> such an inconsistency (not sure how expensive that would be) and then
>>> the lookup would end up with the updated lower.
>>>
>>
>> I understand. This sounds reasonable. The hard part about making
>> behavior of (d) defined is that we cannot tell if a lower dir that was
>> encoded has not been copied up or was copied up and then lower has
>> moved.
>
> Wait, copy-up creates index, no?

That's what I thought at first, but then realized we only *need* to
index renamed and unlinked upper objects for NFS export.
My concern w.r.t. indexing on copy up was that performance of index
create and lookup can degrade for large index dir, so better index
only what we need in order to be able to decode.
But if copy up creates index then behavior of (d) can be well defined.
B.t.w my current NFS export WIP does index on copy up.

>
>> Bottom line is that splitting follow origin to a new mount flag for
>> snapshot is fine by me. Do you intend to preserve the behavior change
>> of NOT following unverified lower dir?  Without this change ESTALE
>> error could become persistent.
>
> I don't get it.

Right. That involves some more lower renames. Imagine 2 merged dirs A
and B both decoded by origin. Then the 2 lower dirs swapped. Now
decode of A yields an inconsistent index so return ESTALE. But lookup
of A will follow to unverified lower B and encode of that dentry will
be same as encode of B before the swap, so we are bound to always get
ESTALE after encode/decode. I suppose there are other ways out of this
loop hole besides not following unverified lower. I just don't see
them right now.

Amir.
