Return-Path: <linux-unionfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 73AF2C433F5
	for <linux-unionfs@archiver.kernel.org>; Thu, 28 Oct 2021 22:47:23 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 5BC7560F38
	for <linux-unionfs@archiver.kernel.org>; Thu, 28 Oct 2021 22:47:23 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231463AbhJ1Wtu (ORCPT
        <rfc822;linux-unionfs@archiver.kernel.org>);
        Thu, 28 Oct 2021 18:49:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32858 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231460AbhJ1Wtt (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Thu, 28 Oct 2021 18:49:49 -0400
Received: from mail-io1-xd2d.google.com (mail-io1-xd2d.google.com [IPv6:2607:f8b0:4864:20::d2d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 14FB4C061570
        for <linux-unionfs@vger.kernel.org>; Thu, 28 Oct 2021 15:47:22 -0700 (PDT)
Received: by mail-io1-xd2d.google.com with SMTP id n67so10192756iod.9
        for <linux-unionfs@vger.kernel.org>; Thu, 28 Oct 2021 15:47:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=1YfG2A9boFAUzfjzJsK4lcex5Mgr5YSrdYuQGdPQraA=;
        b=VtiX7Xb1EymMsOmiE/Yq4nThofda+udGgHs5pSYheKLm6Q8uLGERYKZAfRoVcmNuNn
         JZImmjxxfbC4/VC+nx9FafwCeAOwrWT9gdcZOsfMRx6wxn3uVhEG7q5wBFLmQz8a+RPI
         l8iG0YPmjinntwUdZAPZRSCHhc0rpuDmfeK+nAJid8ns6XfFTWgEkSXeU8zjVtUai+km
         JtvRnBzy0pAv29tL51sHCDLOZ4dTZjym8Xne+I+BGi/cY9vXlBVv3pju8P0cdowYCLK6
         I3JxAV726fxNEZ/R45Ss6dMNYFqImKnet/lTCewPwUPSmwcXyj/mu04gJWMmXQRdcgDN
         FOVg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=1YfG2A9boFAUzfjzJsK4lcex5Mgr5YSrdYuQGdPQraA=;
        b=VfnP0U9vBWINi98Lc3YwJgV7BUT+jIuRwp933Zp6owvoV+ZPYcErpcf3HlcoYS26BR
         7SQ6eVWwLvO3PG+M8XWooPbqIk4kBFGRN4epmC9nZuVtlmTPrF8Cgfb9racfrjhKx+H/
         TZU0tDLDQef82V/+o7SZoEvDdunB9whE8mzWmLmTZXZrne7jAaVqq9phZaMsJHXtqTW4
         ka23ocF8R2d1aTWlZk1XilaOUPornv8SzT9osj3IPPlGkKbDc2911q4FjJnVM79uKN0o
         k9G2HNmbOKLpVVYtDt0PFNJIxXwU7K56Bks255+DYQGxJEAPRpdR4LKogAQvgHAtZ6ph
         Tffg==
X-Gm-Message-State: AOAM532REa3fvS6CJwNdb2oD/T8pCB47Es6P48As4qtWnWqcHn30whc2
        o0GQ6HLyIdhPwhNTnbINKpLmLf9K+6ZsmQjn3GudebaICrc=
X-Google-Smtp-Source: ABdhPJw3kt9FMSFsUuLgCNJvkh8pSXFVCAzqEEJNkSrrC84z3hj+mCXVXt6yOR4zmnuwHHmCFWm0fOzcGuLIeoWV+O4=
X-Received: by 2002:a5d:804a:: with SMTP id b10mr3125195ior.197.1635461241177;
 Thu, 28 Oct 2021 15:47:21 -0700 (PDT)
MIME-Version: 1.0
References: <CADmzSSgiJ8jS5Ss-P+7_vXowM_TVNhwySE=QHwDhjG0Uj0Xr1g@mail.gmail.com>
 <CAOQ4uxiRthg8vMiFwNUW=V3HZhGyufgqFWBsBTh_SXVyXDO1jA@mail.gmail.com>
 <CADmzSSheLbJTJxfS6xF5jV4dauRZkt7OY7v9oPkpjQmnHpx_9Q@mail.gmail.com>
 <CAOQ4uxghLQCLf6O9Q1GdgPsB1-OeessRCAtdehnOsa89RpxuWQ@mail.gmail.com> <CADmzSSjQN0=ymETAavgKWBgOsTFpZAkL-WKk+SZum8quHsu2NQ@mail.gmail.com>
In-Reply-To: <CADmzSSjQN0=ymETAavgKWBgOsTFpZAkL-WKk+SZum8quHsu2NQ@mail.gmail.com>
From:   Amir Goldstein <amir73il@gmail.com>
Date:   Fri, 29 Oct 2021 01:47:10 +0300
Message-ID: <CAOQ4uxgf2Q72ovpdGJrKpPQx86+MAzqc8bMz8dKhBLXPgDY5cQ@mail.gmail.com>
Subject: Re: nfs_export Stale file handle
To:     Carl Karsten <carl@nextdayvideo.com>
Cc:     overlayfs <linux-unionfs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-unionfs.vger.kernel.org>
X-Mailing-List: linux-unionfs@vger.kernel.org

On Thu, Oct 28, 2021 at 9:44 PM Carl Karsten <carl@nextdayvideo.com> wrote:
>
>  bumping into this again, and now I have more stable .. thing.
>
> my stack of dirs:
> base - copy of files from raspios-buster-armhf-lite.img
> setup - config files my setup adds
> updates - apt update/upgrade
> play - random things I am testing
>
> work - overlayfs working dir
> merged - overlayfs mount point
>
> I cp files in base and setup,
> mount base setup updates play on mounted
> write some files into mounted
>
> Now I want to undo:
> rm play work merged
> mkdir play work merged
> mount...
> error Stale file handle.

You are not allowed to re-create lower dir when using nfs_expoprt.
If you re-create/replace/rearrange any of the lower dirs, you need
to also re-create the upperdir.

>
> juser@negk:~$ sudo ./test.sh
> + rm -rf /srv/nfs/rpi/buster/boot/play /srv/nfs/rpi/buster/boot/work
> /srv/nfs/rpi/buster/boot/merged
> + mkdir /srv/nfs/rpi/buster/boot/play /srv/nfs/rpi/buster/boot/work
> /srv/nfs/rpi/buster/boot/merged
> + mount -t overlay overlay -o
> nfs_export=on,lowerdir=/srv/nfs/rpi/buster/boot/base:/srv/nfs/rpi/buster/boot/setup,upperdir=/srv/nfs/rpi/buster/boot/updates,workdir=/srv/nfs/rpi/buster/boot/work

is ../boot/base/ supposed to be the uppermost lower layer.
It's name and you description above sounds like it should be the
bottom most layer,
but you stacked ../boot/setup below it.

> /srv/nfs/rpi/buster/boot/merged
> mount: /srv/nfs/rpi/buster/boot/merged: mount(2) system call failed:
> Stale file handle.
> [ 1602.271239] overlayfs: failed to verify origin (boot/base,
> ino=4194652, err=-116)
> [ 1602.271244] overlayfs: failed to verify upper root origin
>

translation: boot/base is not the directory that used to be right below
boot/updates. I guess you meant boot/setup to be on top of  boot/base?

Thanks,
Amir.
