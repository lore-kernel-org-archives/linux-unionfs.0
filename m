From: Amir Goldstein <amir73il@gmail.com>
Subject: Re: [PATCH] ovl: create all new directories opaque
Date: Mon, 21 Nov 2016 15:45:43 +0200
Message-ID: <CAOQ4uxi0CiKBQNqNypomsFgXjKZCS=04W=Q34gKuV5geTJ-bVA@mail.gmail.com>
References: <1479733445-15795-1-git-send-email-amir73il@gmail.com> <CAJfpegsSfst1_9GgJvar0xVOnVLHdE=cMvTa0MhtdbbteYaxZA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-unionfs-owner@vger.kernel.org>
Received: from mail-wm0-f52.google.com ([74.125.82.52]:38537 "EHLO
        mail-wm0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753297AbcKUNpp (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Mon, 21 Nov 2016 08:45:45 -0500
Received: by mail-wm0-f52.google.com with SMTP id f82so145854767wmf.1
        for <linux-unionfs@vger.kernel.org>; Mon, 21 Nov 2016 05:45:44 -0800 (PST)
In-Reply-To: <CAJfpegsSfst1_9GgJvar0xVOnVLHdE=cMvTa0MhtdbbteYaxZA@mail.gmail.com>
Sender: linux-unionfs-owner@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: "linux-unionfs@vger.kernel.org" <linux-unionfs@vger.kernel.org>

On Mon, Nov 21, 2016 at 3:38 PM, Miklos Szeredi <miklos@szeredi.hu> wrote:
> On Mon, Nov 21, 2016 at 2:04 PM, Amir Goldstein <amir73il@gmail.com> wrote:
>> There is really no good reason why not to make all
>> directories opaque from birth.
>>
>> The benefit of making directiories opaque on creation
>> is that lookups can stop short when they reach the
>> original created directory.
>>
>> The best case is overlay with N layers, performing
>> lookup for first level directory, which exists only in upper.
>> In that case, there will be only one lookup instead of N.
>
> That's true for directories created in a merged dir.  Directories
> created in an opaque dir get no such advantage and creating the xattr
> will consume space and time.
>
> So this should at least be conditional on the state of the parent.
>

Will do.
But do you at least agree to unconditionally set dir opaque on rename?
There is really very little point is finding out if lower_is_positive()

Amir.
