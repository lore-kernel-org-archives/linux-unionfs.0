From: Amir Goldstein <amir73il@gmail.com>
Subject: Re: [PATCH v2] ovl: create directories inside merged parent opaque
Date: Wed, 30 Nov 2016 14:58:21 +0200
Message-ID: <CAOQ4uxg=jxigmh--+VprmQGeORftvc6uMhXz1cK7mtE7FrD=7Q@mail.gmail.com>
References: <CAJfpegs--UYZrZG4KM8uigs5nL-Q_jD3+ssvQMRRSOK4HPWpsw@mail.gmail.com>
 <1479747454-2273-1-git-send-email-amir73il@gmail.com> <CAJfpegtG8z1AN8SXQG3e=dXCMwa58AdL8pyOYnffE-85X04+Dw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-unionfs-owner@vger.kernel.org>
Received: from mail-wm0-f54.google.com ([74.125.82.54]:36626 "EHLO
        mail-wm0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750749AbcK3M6Y (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Wed, 30 Nov 2016 07:58:24 -0500
Received: by mail-wm0-f54.google.com with SMTP id g23so268819858wme.1
        for <linux-unionfs@vger.kernel.org>; Wed, 30 Nov 2016 04:58:23 -0800 (PST)
In-Reply-To: <CAJfpegtG8z1AN8SXQG3e=dXCMwa58AdL8pyOYnffE-85X04+Dw@mail.gmail.com>
Sender: linux-unionfs-owner@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: "linux-unionfs@vger.kernel.org" <linux-unionfs@vger.kernel.org>

On Wed, Nov 30, 2016 at 1:09 PM, Miklos Szeredi <miklos@szeredi.hu> wrote:
> On Mon, Nov 21, 2016 at 5:57 PM, Amir Goldstein <amir73il@gmail.com> wrote:
>> The benefit of making directories opaque on creation
>> is that lookups can stop short when they reach the
>> original created directory, instead of continue lookup
>> the entire depth of parent directory stack.
>>
>> The best case is overlay with N layers, performing
>> lookup for first level directory, which exists only in upper.
>> In that case, there will be only one lookup instead of N.
>
> I split this up, changed it around a bit and pushed the result to
> overlayfs-next.
>

Nice cleanup. FYI, you left me as sole S-O-B on the change.
Anyway, it passed my tests.

In case you are still interested, I rebase concurrent copy up
on top of overlay-rorw and pushed to branch #concurrent_copyup
on my github, with slightly improved commit message.
But I guess this merge window is crowded enough already and
I personally much rather see rorw merged than concurrent copy up.

Thanks,
Amir.
