From: Miklos Szeredi <miklos@szeredi.hu>
Subject: Re: [PATCH 10/10] ovl: follow decoded origin file handle of merge dir
Date: Tue, 25 Jul 2017 13:33:28 +0200
Message-ID: <CAJfpeguuF4bnOM6ThK3x7kcjd6hQ3TWiZSOyRDA5u9vKhOWJ6A@mail.gmail.com>
References: <1499777923-29410-1-git-send-email-amir73il@gmail.com>
 <1499777923-29410-11-git-send-email-amir73il@gmail.com> <CAJfpegtk9RiN6cwKXRHoh9i+_tOgYyW+PFkrwEXvit_J9Pm3cw@mail.gmail.com>
 <CAOQ4uxhVCw4BBoNw5O46_yh_TChDy6tp_ahKHnjdui3oVON8iA@mail.gmail.com>
 <CAJfpegvK8iNJWbM_hbCMGOKey5AOAhP6wtPAOwc2a6ACQf_RXw@mail.gmail.com>
 <CAOQ4uxgBuka1Sz4k5BDWuOxB-p8AH1Vr17pi3bn7xFo57AimZA@mail.gmail.com>
 <CAJfpeguaYyBhaz3GG27i4-gP-CQ+RoqYttYCzP9HkykxdE_W7w@mail.gmail.com> <CAOQ4uxhuGZjepSaAkaJQ1BjL-ePVtfBrwio=5E5WFAaM+fpOgA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-unionfs-owner@vger.kernel.org>
Received: from mail-oi0-f67.google.com ([209.85.218.67]:35405 "EHLO
        mail-oi0-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750851AbdGYLd3 (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Tue, 25 Jul 2017 07:33:29 -0400
Received: by mail-oi0-f67.google.com with SMTP id q70so6441600oic.2
        for <linux-unionfs@vger.kernel.org>; Tue, 25 Jul 2017 04:33:29 -0700 (PDT)
In-Reply-To: <CAOQ4uxhuGZjepSaAkaJQ1BjL-ePVtfBrwio=5E5WFAaM+fpOgA@mail.gmail.com>
Sender: linux-unionfs-owner@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org
To: Amir Goldstein <amir73il@gmail.com>
Cc: "linux-unionfs@vger.kernel.org" <linux-unionfs@vger.kernel.org>

On Mon, Jul 24, 2017 at 2:14 PM, Amir Goldstein <amir73il@gmail.com> wrote:
> On Mon, Jul 24, 2017 at 11:48 AM, Miklos Szeredi <miklos@szeredi.hu> wrote:
>> On Fri, Jul 14, 2017 at 12:58 PM, Amir Goldstein <amir73il@gmail.com> wrote:
>>
>>> If you don't want to bundle index=on with NFS export, then no rush to merge
>>> these patches now. The added benefit on patch 9 (retroactive marking merge
>>> dir with origin for not exposing whiteouts) is relevant to a patch that is not
>>> going to land in v4.13 anyway. right?
>>
>> Right.
>>
>> Can we maybe postpone the verification until fh decode time?
>
> Not sure I follow.
> Failure to verify lower dir can result in merge dir not being merged or being
> merged with a different lower dir (followed by fh).
>
> The question is which inode we choose to encode in case lower dir cannot be
> verified: the unverified lower inode, the stored origin inode or the
> upper inode.
>
> Are you suggesting that "normal" lookup will merge the unverified lower dir
> and then a pair of encode/decode will result in another dentry?
> or are you suggesting to return ESTALE in that case?
> If latter, then that error we be permanent? encode/decode will alway end up
> with ESTALE??

Putting a bit more thought into this...

I think we have several different cases

 a) offline move of lower dir, no active NFS export

 b) online move of lower dir, no active NFS export

 c) offline move of lower dir, active NFS export

 d) online move of lower dir, active NFS export

 e) offline move of lower dir, snapshotfs

 f) online move of lower dir, snapshotfs

The behavior of (a) is well defined: we do not follow origin of
directories for merging.  It might make sense to introduce a variant
that does follow origin, but I'm not sure I see the usefulness.

The behavior of (b) is undefined, it might make sense to add an
ovl_d_revalidate() and make that case behave like (a)

For first version we can say that (c) and (d) are both undefined.  I
think the logical behavior would be to return ESTALE when we detect
such an inconsistency (not sure how expensive that would be) and then
the lookup would end up with the updated lower.

For (f) we obviously need to follow the origin dir and I guess we
don't care about (e).

To summarize, only snapshotfs and maybe some other special application
of overlay would need the directory following behavior.   For NFS
export we can just do whatever is simplest in the unverified case for
now.

Thanks,
Miklos
