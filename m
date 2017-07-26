From: Miklos Szeredi <miklos@szeredi.hu>
Subject: Re: [PATCH 10/10] ovl: follow decoded origin file handle of merge dir
Date: Wed, 26 Jul 2017 10:54:19 +0200
Message-ID: <CAJfpegswQgcJViBe3v6fEM43ibL=uFZLc9NfcGb+GiF6HNkQcA@mail.gmail.com>
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
 <CAJfpegsuZOaCAb8VzDx3qxG_cA2j8qavMS4K=V-QkrNEBb8TYQ@mail.gmail.com> <CAJfpegtY=5RA+Cz4MgajmOkr+He0gYfw=hd19k+k_cnAzHT+QQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-unionfs-owner@vger.kernel.org>
Received: from mail-oi0-f52.google.com ([209.85.218.52]:34869 "EHLO
        mail-oi0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751023AbdGZIyU (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Wed, 26 Jul 2017 04:54:20 -0400
Received: by mail-oi0-f52.google.com with SMTP id e124so114153463oig.2
        for <linux-unionfs@vger.kernel.org>; Wed, 26 Jul 2017 01:54:20 -0700 (PDT)
In-Reply-To: <CAJfpegtY=5RA+Cz4MgajmOkr+He0gYfw=hd19k+k_cnAzHT+QQ@mail.gmail.com>
Sender: linux-unionfs-owner@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org
To: Amir Goldstein <amir73il@gmail.com>
Cc: "linux-unionfs@vger.kernel.org" <linux-unionfs@vger.kernel.org>

On Wed, Jul 26, 2017 at 10:51 AM, Miklos Szeredi <miklos@szeredi.hu> wrote:
> On Wed, Jul 26, 2017 at 10:47 AM, Miklos Szeredi <miklos@szeredi.hu> wrote:
>
>> Aren't we allowed to update the stale index?
>
> The answer is no, of course (otherwise client would get success for
> something it should get error for).  Eeturning ESTALE is the right
> thing to do.

Can encode an overlay-generation in the handle.  That would allow us
to have a stale index as well as a new one for the same underlying
origin.

Thanks,
Miklos
