From: Amir Goldstein <amir73il@gmail.com>
Subject: Re: [PATCH 10/10] ovl: follow decoded origin file handle of merge dir
Date: Wed, 26 Jul 2017 22:06:56 +0300
Message-ID: <CAOQ4uxi6qyRiJQvTu4nHM+0nNtbiLnLyBn8azW+AooOb_Xvg_g@mail.gmail.com>
References: <1499777923-29410-1-git-send-email-amir73il@gmail.com>
 <1499777923-29410-11-git-send-email-amir73il@gmail.com> <CAJfpegtk9RiN6cwKXRHoh9i+_tOgYyW+PFkrwEXvit_J9Pm3cw@mail.gmail.com>
 <CAOQ4uxhVCw4BBoNw5O46_yh_TChDy6tp_ahKHnjdui3oVON8iA@mail.gmail.com>
 <CAJfpegvK8iNJWbM_hbCMGOKey5AOAhP6wtPAOwc2a6ACQf_RXw@mail.gmail.com>
 <CAOQ4uxgBuka1Sz4k5BDWuOxB-p8AH1Vr17pi3bn7xFo57AimZA@mail.gmail.com>
 <CAJfpeguaYyBhaz3GG27i4-gP-CQ+RoqYttYCzP9HkykxdE_W7w@mail.gmail.com>
 <CAOQ4uxhuGZjepSaAkaJQ1BjL-ePVtfBrwio=5E5WFAaM+fpOgA@mail.gmail.com>
 <CAJfpeguuF4bnOM6ThK3x7kcjd6hQ3TWiZSOyRDA5u9vKhOWJ6A@mail.gmail.com>
 <CAOQ4uxjk4e1yEvaprnQW+rQVgUGY4EcVuFxtdV5-NHHnd7Yy-g@mail.gmail.com>
 <CAJfpeguk7J+-rKTjXqX2-VnErAoXv3jiW83syaA14tpZxOY0Eg@mail.gmail.com>
 <CAOQ4uxibj+od+RiwZ2zAJXwaudy4g7xDaVVng-eU3OhX4OJjHw@mail.gmail.com>
 <CAJfpegsuZOaCAb8VzDx3qxG_cA2j8qavMS4K=V-QkrNEBb8TYQ@mail.gmail.com>
 <CAJfpegtY=5RA+Cz4MgajmOkr+He0gYfw=hd19k+k_cnAzHT+QQ@mail.gmail.com> <CAJfpegswQgcJViBe3v6fEM43ibL=uFZLc9NfcGb+GiF6HNkQcA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-unionfs-owner@vger.kernel.org>
Received: from mail-yw0-f174.google.com ([209.85.161.174]:34242 "EHLO
        mail-yw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751625AbdGZTG6 (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Wed, 26 Jul 2017 15:06:58 -0400
Received: by mail-yw0-f174.google.com with SMTP id i6so59714214ywb.1
        for <linux-unionfs@vger.kernel.org>; Wed, 26 Jul 2017 12:06:57 -0700 (PDT)
In-Reply-To: <CAJfpegswQgcJViBe3v6fEM43ibL=uFZLc9NfcGb+GiF6HNkQcA@mail.gmail.com>
Sender: linux-unionfs-owner@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: "linux-unionfs@vger.kernel.org" <linux-unionfs@vger.kernel.org>

On Wed, Jul 26, 2017 at 11:54 AM, Miklos Szeredi <miklos@szeredi.hu> wrote:
> On Wed, Jul 26, 2017 at 10:51 AM, Miklos Szeredi <miklos@szeredi.hu> wrote:
>> On Wed, Jul 26, 2017 at 10:47 AM, Miklos Szeredi <miklos@szeredi.hu> wrote:
>>
>>> Aren't we allowed to update the stale index?
>>
>> The answer is no, of course (otherwise client would get success for
>> something it should get error for).  Eeturning ESTALE is the right
>> thing to do.
>
> Can encode an overlay-generation in the handle.  That would allow us
> to have a stale index as well as a new one for the same underlying
> origin.
>

Yes, we can do that.

We will never have two different index generations on-disk at the same time.
A new generation index always obsoletes an old index generation
(index name does not include the generation).

Verifying index/origin consistency should happen no later than at encode time,
but it really doesn't cost much to verify that at merge dir lookup time.
If index/origin is not consistent with merge dir upper/lower, need to replace it
with a newer generation consistent index and need to update origin xattr.
I would think that it also makes sense to verify index->upper->origin->index
consistency on mount, as we anyway should check that index->upper reference
is not stale.

But I must wonder: does carrying this extra complexity for index generation
really worth the effort of not changing behavior of modified lower dir
(when user opts-in for the change with index=on)?
Do you think there are users out there depending on the current behavior
in a setup that does NOT involve copying layers??

Anyway, another not-really-a-reason I am wondering if we can avoid
index generation is that I was going to use struct ovl_fh for both on-disk
(origin xattr and index name) and for on-wire (NFS), so I'm still resisting
the idea to diverge the structs...

Thanks,
Amir.
