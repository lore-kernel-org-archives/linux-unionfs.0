From: Miklos Szeredi <miklos@szeredi.hu>
Subject: Re: [PATCH] ovl: create all new directories opaque
Date: Mon, 21 Nov 2016 15:00:55 +0100
Message-ID: <CAJfpegs--UYZrZG4KM8uigs5nL-Q_jD3+ssvQMRRSOK4HPWpsw@mail.gmail.com>
References: <1479733445-15795-1-git-send-email-amir73il@gmail.com>
 <CAJfpegsSfst1_9GgJvar0xVOnVLHdE=cMvTa0MhtdbbteYaxZA@mail.gmail.com> <CAOQ4uxi0CiKBQNqNypomsFgXjKZCS=04W=Q34gKuV5geTJ-bVA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-unionfs-owner@vger.kernel.org>
Received: from mail-oi0-f45.google.com ([209.85.218.45]:33208 "EHLO
        mail-oi0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754179AbcKUOA5 (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Mon, 21 Nov 2016 09:00:57 -0500
Received: by mail-oi0-f45.google.com with SMTP id w63so18922003oiw.0
        for <linux-unionfs@vger.kernel.org>; Mon, 21 Nov 2016 06:00:56 -0800 (PST)
In-Reply-To: <CAOQ4uxi0CiKBQNqNypomsFgXjKZCS=04W=Q34gKuV5geTJ-bVA@mail.gmail.com>
Sender: linux-unionfs-owner@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org
To: Amir Goldstein <amir73il@gmail.com>
Cc: "linux-unionfs@vger.kernel.org" <linux-unionfs@vger.kernel.org>

On Mon, Nov 21, 2016 at 2:45 PM, Amir Goldstein <amir73il@gmail.com> wrote:
> On Mon, Nov 21, 2016 at 3:38 PM, Miklos Szeredi <miklos@szeredi.hu> wrote:
>> On Mon, Nov 21, 2016 at 2:04 PM, Amir Goldstein <amir73il@gmail.com> wrote:
>>> There is really no good reason why not to make all
>>> directories opaque from birth.
>>>
>>> The benefit of making directiories opaque on creation
>>> is that lookups can stop short when they reach the
>>> original created directory.
>>>
>>> The best case is overlay with N layers, performing
>>> lookup for first level directory, which exists only in upper.
>>> In that case, there will be only one lookup instead of N.
>>
>> That's true for directories created in a merged dir.  Directories
>> created in an opaque dir get no such advantage and creating the xattr
>> will consume space and time.
>>
>> So this should at least be conditional on the state of the parent.
>>
>
> Will do.
> But do you at least agree to unconditionally set dir opaque on rename?
> There is really very little point is finding out if lower_is_positive()

Again:  if dest parent is opaque, there's no need to set opaque on
moved dir.  Otherwise (if dest parent is merged) it does make sense to
set opaque, regardless of whether it covers anything or not.

Thanks,
Miklos
