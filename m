Return-Path: <linux-unionfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 85220C433F5
	for <linux-unionfs@archiver.kernel.org>; Tue,  7 Dec 2021 21:17:39 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232444AbhLGVVI (ORCPT
        <rfc822;linux-unionfs@archiver.kernel.org>);
        Tue, 7 Dec 2021 16:21:08 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59178 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231451AbhLGVVG (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Tue, 7 Dec 2021 16:21:06 -0500
Received: from mail-ua1-x934.google.com (mail-ua1-x934.google.com [IPv6:2607:f8b0:4864:20::934])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 58F58C061574
        for <linux-unionfs@vger.kernel.org>; Tue,  7 Dec 2021 13:17:35 -0800 (PST)
Received: by mail-ua1-x934.google.com with SMTP id 30so951714uag.13
        for <linux-unionfs@vger.kernel.org>; Tue, 07 Dec 2021 13:17:35 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=nextdayvideo-com.20210112.gappssmtp.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=8R+cPIrMKRdgy3DBw0MX9qZkmsFQ0RqY8v2mLXLo238=;
        b=PAXBKIwfdWjKAdkT8hrDg+OkG31svWqgxN9ISYfgF1q0vJdsg7Za1b+sqMhY3qJk2d
         fSI+WTnc1PEMY8ihiF9081OXtEP9I4RZT5xdRlCYD4WxF1yPB9GxZKSKDKZdD9GCutSS
         85C0xgF33quXjkZ+a428hnr8IintYDoVi9eRLlbmJeHEWiVNtk9IhZs85lOhnJeB5YJP
         5z41e6MPMeWZMuSYOVpxWSd9rA6eWodlirPA8tlJf0rSungC/WlrY6/LPDLJ0uxFdWvr
         uUvRMfDZrFWuQ4BEnpjypXl77Y341jTnlMU1TFV1Mwh6LtJiWBehbVidXYbFJOmmo99V
         cCCA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=8R+cPIrMKRdgy3DBw0MX9qZkmsFQ0RqY8v2mLXLo238=;
        b=RiZsbklTlFg1bWxqV2VZXQ2MAxEzEfz/8eO4xbT+L2LHluaoBi058ApojUUOmPNAPn
         8bkKTuHj68jV4jDALf3E7jVghCVAbz2r2oZ5tDdsjFzVcokNU7kkhoS+aTH54F+ezS7T
         NDgp3oUgTdIgN5uUjuThKmR3f/TZEameDdK+25N6jMQoG95/hOTDKcEQEVPIuwQuze+H
         +84E7r0VtmaXcEwx9hBW0Ce8P3FO/rGzTSkH2VRtrUFba8+0m/XU51FWClmz0ruAKVD7
         Fg9GrByqYwiOUeN9Zp4LHbwHj7da2jDc52uQIHR/gP8o8iOkTLBxEIE7VvOXXTjd181E
         HKSg==
X-Gm-Message-State: AOAM530B8ztKfzSJaeV9e8lD+sWAcntVvXh0eMSeJVy8B3gfJP/eXmqN
        zIfpXsndGG/GWMl4d5kn2L8hxXH49Scy6zPQP3c=
X-Google-Smtp-Source: ABdhPJybpnSYc5LE3EOsQpkkuu5J2c6vPqaR63uBXtLmNHzNQMVk280+mLQI0RWSaJgOnTOadDvzuOhOJla9KxkUvMg=
X-Received: by 2002:ab0:2041:: with SMTP id g1mr2209962ual.131.1638911854403;
 Tue, 07 Dec 2021 13:17:34 -0800 (PST)
MIME-Version: 1.0
References: <CADmzSSjKoiYn7moEVFDV2p+x2BuTnWBLMBtdPQYsqQOttcgN1A@mail.gmail.com>
 <CAOQ4uxgb4cGHS9ZU-LfJAzSnmFDQmZgEBwHHA-J+G520gVsCyg@mail.gmail.com>
In-Reply-To: <CAOQ4uxgb4cGHS9ZU-LfJAzSnmFDQmZgEBwHHA-J+G520gVsCyg@mail.gmail.com>
From:   Carl Karsten <carl@nextdayvideo.com>
Date:   Tue, 7 Dec 2021 13:17:07 -0800
Message-ID: <CADmzSSj2F77Z0Ufp-O7xQzPW=_BbUW3h3OCn7uhNUnS-tz8tCw@mail.gmail.com>
Subject: Re: failed to verify upper - halts boot
To:     Amir Goldstein <amir73il@gmail.com>
Cc:     overlayfs <linux-unionfs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-unionfs.vger.kernel.org>
X-Mailing-List: linux-unionfs@vger.kernel.org

On Mon, Dec 6, 2021 at 9:55 PM Amir Goldstein <amir73il@gmail.com> wrote:
>
> On Tue, Dec 7, 2021 at 4:38 AM Carl Karsten <carl@nextdayvideo.com> wrote:
> >
> > I powercyced my box, I'm assuming I did a sudo poweroff or halt or
> > something, but maybe not.
> >
> > It got stuck, (enter rescue mode, root account disabled, hit enter to
> > enter rescue mode... )  so I killed power.
> >
> > I edited fstab, changed auto to noauto, booted.
> >
> > overlay   /srv/nfs/rpi/bullseye/boot/merged    overlay
> > noauto,defaults,ro,lowerdir=/srv/nfs/rpi/bullseye/boot/updates:/srv/nfs/rpi/bullseye/boot/setup:/srv/nfs/rpi/bullseye/boot/base,upperdir=/srv/nfs/rpi/bullseye/boot/play,workdir=/srv/nfs/rpi/bullseye/boot/work,nfs_export=on
> >    0   0
> >
> > # mount /srv/nfs/rpi/bullseye/boot/merged
> > mount: /srv/nfs/rpi/bullseye/boot/merged: mount(2) system call failed:
> > Stale file handle.
> >
> > dmesg shows:
> >
> > [   45.941350] overlayfs: failed to verify upper (boot/play,
> > ino=379405, err=-116)
> > [   45.941369] overlayfs: failed to verify index dir 'upper' xattr
> > [   45.941379] overlayfs: try deleting index dir or mounting with '-o
> > index=off' to disable inodes index.
> >
>
> Did you by any change re-create boot/play dir without re-creating
> boot/work dir? because that is what that message means.
> I doubt it has to do with the power cycle.

Maybe.

would that include:
mount: lower=base,setup upper= updates
unmount
mount: lower=base,setup,updates upper=play
?

That might have happened.

>
> > It is a bit concerning that I need to consider a power cycle may
> > require local console use.  I plan on managing this remotely.  For now
> > I'll leave it noauto and remotely mount when needed.  so this isn't a
> > critical blocker to me.
> >
> > What would happen:  errors=remount-ro
> >
> > errors={continue|remount-ro|panic}
> >     Define the behavior  when  an  error  is  encountered.  The
> > default is set in the filesystem superblock,  ...     and can be
> > changed using tune2fs(8).
> >
>
> This looks like a quote from the man page section about ext2 mount options.
> Those are not options supported for overlayfs.
>
> Anyway, with that error, as the kernel log says, you could have mounted
> overlayfs ro with -o index=off and we could have added a mount option
> to fallback to ro mount with index=off, but that means no nfs_export,
> so not sure if that is what you wanted.

That would be an improvement, as would errors=continue.

Either of these would let a healthy system come up and be usable, and
errors would let the system come up (finish booting) but the
nfs/overlay part needs attention.

Currently I have noauto so any reboot requires attention.
If I set auto, an error will cause the boot to stop and I don't have a
way to fix it remotely. I don't want to risk that, so noauto.

I think I would prefer errors=continue as It would be more obvious
that the overlayfs mount has issues.

>
> Thanks,
> Amir.



-- 
Carl K
