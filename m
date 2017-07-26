From: Miklos Szeredi <miklos@szeredi.hu>
Subject: Re: [PATCH 10/10] ovl: follow decoded origin file handle of merge dir
Date: Wed, 26 Jul 2017 10:47:03 +0200
Message-ID: <CAJfpegsuZOaCAb8VzDx3qxG_cA2j8qavMS4K=V-QkrNEBb8TYQ@mail.gmail.com>
References: <1499777923-29410-1-git-send-email-amir73il@gmail.com>
 <1499777923-29410-11-git-send-email-amir73il@gmail.com> <CAJfpegtk9RiN6cwKXRHoh9i+_tOgYyW+PFkrwEXvit_J9Pm3cw@mail.gmail.com>
 <CAOQ4uxhVCw4BBoNw5O46_yh_TChDy6tp_ahKHnjdui3oVON8iA@mail.gmail.com>
 <CAJfpegvK8iNJWbM_hbCMGOKey5AOAhP6wtPAOwc2a6ACQf_RXw@mail.gmail.com>
 <CAOQ4uxgBuka1Sz4k5BDWuOxB-p8AH1Vr17pi3bn7xFo57AimZA@mail.gmail.com>
 <CAJfpeguaYyBhaz3GG27i4-gP-CQ+RoqYttYCzP9HkykxdE_W7w@mail.gmail.com>
 <CAOQ4uxhuGZjepSaAkaJQ1BjL-ePVtfBrwio=5E5WFAaM+fpOgA@mail.gmail.com>
 <CAJfpeguuF4bnOM6ThK3x7kcjd6hQ3TWiZSOyRDA5u9vKhOWJ6A@mail.gmail.com>
 <CAOQ4uxjk4e1yEvaprnQW+rQVgUGY4EcVuFxtdV5-NHHnd7Yy-g@mail.gmail.com>
 <CAJfpeguk7J+-rKTjXqX2-VnErAoXv3jiW83syaA14tpZxOY0Eg@mail.gmail.com> <CAOQ4uxibj+od+RiwZ2zAJXwaudy4g7xDaVVng-eU3OhX4OJjHw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-unionfs-owner@vger.kernel.org>
Received: from mail-oi0-f50.google.com ([209.85.218.50]:33748 "EHLO
        mail-oi0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750813AbdGZIrE (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Wed, 26 Jul 2017 04:47:04 -0400
Received: by mail-oi0-f50.google.com with SMTP id a9so73798715oih.0
        for <linux-unionfs@vger.kernel.org>; Wed, 26 Jul 2017 01:47:04 -0700 (PDT)
In-Reply-To: <CAOQ4uxibj+od+RiwZ2zAJXwaudy4g7xDaVVng-eU3OhX4OJjHw@mail.gmail.com>
Sender: linux-unionfs-owner@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org
To: Amir Goldstein <amir73il@gmail.com>
Cc: "linux-unionfs@vger.kernel.org" <linux-unionfs@vger.kernel.org>

On Wed, Jul 26, 2017 at 12:19 AM, Amir Goldstein <amir73il@gmail.com> wrote:

>> Wait, copy-up creates index, no?
>
> That's what I thought at first, but then realized we only *need* to
> index renamed and unlinked upper objects for NFS export.
> My concern w.r.t. indexing on copy up was that performance of index
> create and lookup can degrade for large index dir, so better index
> only what we need in order to be able to decode.

Guessing that there won't be many merge dirs in most situations, so
this won't be an issue.

> But if copy up creates index then behavior of (d) can be well defined.
> B.t.w my current NFS export WIP does index on copy up.

Lets keep it that way for the first version.

>>> Bottom line is that splitting follow origin to a new mount flag for
>>> snapshot is fine by me. Do you intend to preserve the behavior change
>>> of NOT following unverified lower dir?  Without this change ESTALE
>>> error could become persistent.
>>
>> I don't get it.
>
> Right. That involves some more lower renames. Imagine 2 merged dirs A
> and B both decoded by origin. Then the 2 lower dirs swapped. Now
> decode of A yields an inconsistent index so return ESTALE. But lookup
> of A will follow to unverified lower B and encode of that dentry will
> be same as encode of B before the swap, so we are bound to always get
> ESTALE after encode/decode. I suppose there are other ways out of this
> loop hole besides not following unverified lower. I just don't see
> them right now.

Aren't we allowed to update the stale index?

Thanks,
Miklos
