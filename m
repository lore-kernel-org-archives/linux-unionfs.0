From: Amir Goldstein <amir73il@gmail.com>
Subject: Re: [WIP][RFC] questions about overlay index dir design
Date: Thu, 18 May 2017 17:15:02 +0300
Message-ID: <CAOQ4uxgM6iJEnm8kLhHV6_cmjqN02hhPP20iuZ4eRwaK7+KV=Q@mail.gmail.com>
References: <CAOQ4uxgTG5JhmAb2hQF0ZoyFAfdOCSPDcScNL=8y7xJ1sXiHJg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-unionfs-owner@vger.kernel.org>
Received: from mail-oi0-f49.google.com ([209.85.218.49]:34409 "EHLO
        mail-oi0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1755519AbdEROPE (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Thu, 18 May 2017 10:15:04 -0400
Received: by mail-oi0-f49.google.com with SMTP id b204so55533487oii.1
        for <linux-unionfs@vger.kernel.org>; Thu, 18 May 2017 07:15:03 -0700 (PDT)
In-Reply-To: <CAOQ4uxgTG5JhmAb2hQF0ZoyFAfdOCSPDcScNL=8y7xJ1sXiHJg@mail.gmail.com>
Sender: linux-unionfs-owner@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: "open list:OVERLAY FILESYSTEM" <linux-unionfs@vger.kernel.org>

On Thu, May 18, 2017 at 2:08 AM, Amir Goldstein <amir73il@gmail.com> wrote:

>
> The other thing I wanted to ask and it doesn't require you looking at
> any code is how to handle backward compat of mount behavior when
> workdir is reused for mount with a different upperdir.
>
> The use case may seem odd, but I already ran into it with unionmount
> testsuite ./run --ov=1 and with xfstest overlay/014.
> Maybe those are the only examples in the world, but maybe not...
>
> The problem is that if workdir/index contains hardlinks to a past upper
> which has been rotated to lower, bad things can happen on copy up.
> What I did so far is to store origin fh of upper root in index dir.
> Mount forces read-only if index dir origin does not match upper root dir.
>
> So with current WIP the behavior is that ./run --ov=1 fails after
> rotating upper:
>
> overlayfs: failed to verify origin dir (ino=19025, ret=-116) - were
> layers copied?
> overlayfs: failed to create directory /upper/work/index (errno: 17);
> mounting read-only
>  ./run --rename /mnt/a/no_foo104 /mnt/a/no_foo105
> /mnt/a/no_foo104: Unexpected error: Read-only file system
>
> It's easy to fix the testsuite, but it is doing something that was legal before
> (provide the same workdir option with different upperdir options) and now
> it fails.
>
> The alternative is to blow away the index dir and recreate it when mounting
> with an unverified upperdir. This will work fine for the testsuite, but not for
> the obscure users out there using the same workdir to mount with few different
> upperdir (not at the same time) - do we care?
>
> I guess the best is to blow away index dir unless user explicitly opted-in
> to not blow it away, e.g. by using mount option indexdir= in place of workdir=
> (mutually excl.).
>

Actually, it may make sense to have -o verify_lower control this behavior.
Specifying -o verify_lower clearly states the intention of the user to mount
overlay layers that were not copied, therefore it makes sense to fail rw mount.

OTHO, with this wider meaning, I no longer like the name 'verify_lower',
for 2 reasons:
1. It is only used to verify directories
2. It is now also used to verify upper root dir

So how about 'verify_dir'/'verify_fh'/'verify_origin'?
