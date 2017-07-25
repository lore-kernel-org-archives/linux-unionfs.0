From: Amir Goldstein <amir73il@gmail.com>
Subject: Re: [PATCH 10/10] ovl: follow decoded origin file handle of merge dir
Date: Tue, 25 Jul 2017 17:30:47 +0300
Message-ID: <CAOQ4uxjk4e1yEvaprnQW+rQVgUGY4EcVuFxtdV5-NHHnd7Yy-g@mail.gmail.com>
References: <1499777923-29410-1-git-send-email-amir73il@gmail.com>
 <1499777923-29410-11-git-send-email-amir73il@gmail.com> <CAJfpegtk9RiN6cwKXRHoh9i+_tOgYyW+PFkrwEXvit_J9Pm3cw@mail.gmail.com>
 <CAOQ4uxhVCw4BBoNw5O46_yh_TChDy6tp_ahKHnjdui3oVON8iA@mail.gmail.com>
 <CAJfpegvK8iNJWbM_hbCMGOKey5AOAhP6wtPAOwc2a6ACQf_RXw@mail.gmail.com>
 <CAOQ4uxgBuka1Sz4k5BDWuOxB-p8AH1Vr17pi3bn7xFo57AimZA@mail.gmail.com>
 <CAJfpeguaYyBhaz3GG27i4-gP-CQ+RoqYttYCzP9HkykxdE_W7w@mail.gmail.com>
 <CAOQ4uxhuGZjepSaAkaJQ1BjL-ePVtfBrwio=5E5WFAaM+fpOgA@mail.gmail.com> <CAJfpeguuF4bnOM6ThK3x7kcjd6hQ3TWiZSOyRDA5u9vKhOWJ6A@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-unionfs-owner@vger.kernel.org>
Received: from mail-yw0-f195.google.com ([209.85.161.195]:32814 "EHLO
        mail-yw0-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751980AbdGYOat (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Tue, 25 Jul 2017 10:30:49 -0400
Received: by mail-yw0-f195.google.com with SMTP id u207so3051629ywc.0
        for <linux-unionfs@vger.kernel.org>; Tue, 25 Jul 2017 07:30:49 -0700 (PDT)
In-Reply-To: <CAJfpeguuF4bnOM6ThK3x7kcjd6hQ3TWiZSOyRDA5u9vKhOWJ6A@mail.gmail.com>
Sender: linux-unionfs-owner@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: "linux-unionfs@vger.kernel.org" <linux-unionfs@vger.kernel.org>

On Tue, Jul 25, 2017 at 2:33 PM, Miklos Szeredi <miklos@szeredi.hu> wrote:
> On Mon, Jul 24, 2017 at 2:14 PM, Amir Goldstein <amir73il@gmail.com> wrote:
>> On Mon, Jul 24, 2017 at 11:48 AM, Miklos Szeredi <miklos@szeredi.hu> wrote:
>>> On Fri, Jul 14, 2017 at 12:58 PM, Amir Goldstein <amir73il@gmail.com> wrote:
>>>
>>>> If you don't want to bundle index=on with NFS export, then no rush to merge
>>>> these patches now. The added benefit on patch 9 (retroactive marking merge
>>>> dir with origin for not exposing whiteouts) is relevant to a patch that is not
>>>> going to land in v4.13 anyway. right?
>>>
>>> Right.
>>>
>>> Can we maybe postpone the verification until fh decode time?
>>
>> Not sure I follow.
>> Failure to verify lower dir can result in merge dir not being merged or being
>> merged with a different lower dir (followed by fh).
>>
>> The question is which inode we choose to encode in case lower dir cannot be
>> verified: the unverified lower inode, the stored origin inode or the
>> upper inode.
>>
>> Are you suggesting that "normal" lookup will merge the unverified lower dir
>> and then a pair of encode/decode will result in another dentry?
>> or are you suggesting to return ESTALE in that case?
>> If latter, then that error we be permanent? encode/decode will alway end up
>> with ESTALE??
>
> Putting a bit more thought into this...
>
> I think we have several different cases
>
>  a) offline move of lower dir, no active NFS export
>
>  b) online move of lower dir, no active NFS export
>
>  c) offline move of lower dir, active NFS export
>
>  d) online move of lower dir, active NFS export
>
>  e) offline move of lower dir, snapshotfs
>
>  f) online move of lower dir, snapshotfs
>
> The behavior of (a) is well defined: we do not follow origin of
> directories for merging.  It might make sense to introduce a variant
> that does follow origin, but I'm not sure I see the usefulness.
>
> The behavior of (b) is undefined, it might make sense to add an
> ovl_d_revalidate() and make that case behave like (a)
>
> For first version we can say that (c) and (d) are both undefined.  I
> think the logical behavior would be to return ESTALE when we detect
> such an inconsistency (not sure how expensive that would be) and then
> the lookup would end up with the updated lower.
>

I understand. This sounds reasonable. The hard part about making
behavior of (d) defined is that we cannot tell if a lower dir that was
encoded has not been copied up or was copied up and then lower has
moved.
The cost of indexing merge dir on copy up or on decode is too high imo.
So actually, following decoded origin of merge dir doesn't make decode
behavior 100% defined, just more likely to return a consistent
dentry..

Bottom line is that splitting follow origin to a new mount flag for
snapshot is fine by me. Do you intend to preserve the behavior change
of NOT following unverified lower dir?  Without this change ESTALE
error could become persistent.
