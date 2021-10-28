Return-Path: <linux-unionfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 98E92C433EF
	for <linux-unionfs@archiver.kernel.org>; Thu, 28 Oct 2021 23:10:06 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 6205760F56
	for <linux-unionfs@archiver.kernel.org>; Thu, 28 Oct 2021 23:10:06 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231162AbhJ1XMb (ORCPT
        <rfc822;linux-unionfs@archiver.kernel.org>);
        Thu, 28 Oct 2021 19:12:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37962 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230455AbhJ1XMb (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Thu, 28 Oct 2021 19:12:31 -0400
Received: from mail-ua1-x92c.google.com (mail-ua1-x92c.google.com [IPv6:2607:f8b0:4864:20::92c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 87C98C061570
        for <linux-unionfs@vger.kernel.org>; Thu, 28 Oct 2021 16:10:03 -0700 (PDT)
Received: by mail-ua1-x92c.google.com with SMTP id f4so14688687uad.4
        for <linux-unionfs@vger.kernel.org>; Thu, 28 Oct 2021 16:10:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=nextdayvideo-com.20210112.gappssmtp.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=GMEXefhaeoeGEbsF7SVVceUYvJggWTXXqx9JzAiWoN0=;
        b=1u5yq0kBWuBZT7U/dSClpJep3sOe2TMUxt4/nNACZmDX+81f3Ob7aj8Qhb1MzEsJhN
         kOnGRze9Xml2XblrKCOvVdH9aFIdRqw1V601rgA5AeM25+9qyc1rVNilwPq295w2pXLK
         8THx3FxCFKbwTLBvfdqJThEbkLDrJZ2xdHRW5ZCI7s9Iqw/tuZ8tMyrOEK7KJ4iwoxHa
         CKRmC4HaZZeB+/+L4aFwgeHBWYwfKvcT+b4uUxOL6wKF8Ve4/5o2l58aQUvl3zK5/Efo
         viaM6/ud4tKDRWG6w12H/M91gkufsUFzghXZM4gpn16KsJadY/3x9z/uLGDnqlwR9oai
         3P6g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=GMEXefhaeoeGEbsF7SVVceUYvJggWTXXqx9JzAiWoN0=;
        b=uro1jq625a/AjFr0CTeth08844QeluLHn3eE+vtqdz0VpUlPqhwc7jfRzvxsqlAAnn
         YUKwjKFNgotzJiHoFEtyS22O/zgTdB8Qy6ZeXfft4UozsAEctgRJLjqrqhJowoYKbXu8
         YeU9DHcqUckpBsRwzQynlQqKxWhTumKxhCzyHVychUJF5aGeMR1tpywd1nFkWtN2mLx0
         YbKCmFa6eors94eN5AEMUGLikugG5sUO2J63Oovl90hvrRD7pwZQzNJ6fEm+PTYlLD9D
         TppbhJuzzz0TrepRKTdh6CGsXkiT8knIvCeOOtSdeFThhqn9jXWtkWusQ27CSwpH6xDX
         Kxmg==
X-Gm-Message-State: AOAM533cCqfejbXVCPQbhkPLNYUIW8BEiV2OJHkabeDjYrx3m0PiegB1
        qkfvsGGMVz8O1SghUAWGFUKU1cFzQW/Kk8cXPF/OhjwQzyI=
X-Google-Smtp-Source: ABdhPJyn0AhO+k1TDoHN5FFCWn7li/LdVLD4bBAl82So+f9KDMfZWizsC8YV9yuCBERJjeOw5pt8TmisV/VLlIR7Y+Q=
X-Received: by 2002:ab0:4811:: with SMTP id b17mr8425365uad.40.1635462602363;
 Thu, 28 Oct 2021 16:10:02 -0700 (PDT)
MIME-Version: 1.0
References: <CADmzSSgiJ8jS5Ss-P+7_vXowM_TVNhwySE=QHwDhjG0Uj0Xr1g@mail.gmail.com>
 <CAOQ4uxiRthg8vMiFwNUW=V3HZhGyufgqFWBsBTh_SXVyXDO1jA@mail.gmail.com>
 <CADmzSSheLbJTJxfS6xF5jV4dauRZkt7OY7v9oPkpjQmnHpx_9Q@mail.gmail.com>
 <CAOQ4uxghLQCLf6O9Q1GdgPsB1-OeessRCAtdehnOsa89RpxuWQ@mail.gmail.com>
 <CADmzSSjQN0=ymETAavgKWBgOsTFpZAkL-WKk+SZum8quHsu2NQ@mail.gmail.com> <CAOQ4uxgf2Q72ovpdGJrKpPQx86+MAzqc8bMz8dKhBLXPgDY5cQ@mail.gmail.com>
In-Reply-To: <CAOQ4uxgf2Q72ovpdGJrKpPQx86+MAzqc8bMz8dKhBLXPgDY5cQ@mail.gmail.com>
From:   Carl Karsten <carl@nextdayvideo.com>
Date:   Thu, 28 Oct 2021 18:09:35 -0500
Message-ID: <CADmzSSjxOXsx-ykRL2gokyoTq13wG3qAmjMW+6sSBS29vAd4KQ@mail.gmail.com>
Subject: Re: nfs_export Stale file handle
To:     Amir Goldstein <amir73il@gmail.com>
Cc:     overlayfs <linux-unionfs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-unionfs.vger.kernel.org>
X-Mailing-List: linux-unionfs@vger.kernel.org

On Thu, Oct 28, 2021 at 5:47 PM Amir Goldstein <amir73il@gmail.com> wrote:
>
> On Thu, Oct 28, 2021 at 9:44 PM Carl Karsten <carl@nextdayvideo.com> wrote:
> >
> >  bumping into this again, and now I have more stable .. thing.
> >
> > my stack of dirs:
> > base - copy of files from raspios-buster-armhf-lite.img
> > setup - config files my setup adds
> > updates - apt update/upgrade
> > play - random things I am testing
> >
> > work - overlayfs working dir
> > merged - overlayfs mount point
> >
> > I cp files in base and setup,
> > mount base setup updates play on mounted
> > write some files into mounted
> >
> > Now I want to undo:
> > rm play work merged
> > mkdir play work merged
> > mount...
> > error Stale file handle.
>
> You are not allowed to re-create lower dir when using nfs_expoprt.
> If you re-create/replace/rearrange any of the lower dirs, you need
> to also re-create the upperdir.
>
> >
> > juser@negk:~$ sudo ./test.sh
> > + rm -rf /srv/nfs/rpi/buster/boot/play /srv/nfs/rpi/buster/boot/work
> > /srv/nfs/rpi/buster/boot/merged
> > + mkdir /srv/nfs/rpi/buster/boot/play /srv/nfs/rpi/buster/boot/work
> > /srv/nfs/rpi/buster/boot/merged
> > + mount -t overlay overlay -o
> > nfs_export=on,lowerdir=/srv/nfs/rpi/buster/boot/base:/srv/nfs/rpi/buster/boot/setup,upperdir=/srv/nfs/rpi/buster/boot/updates,workdir=/srv/nfs/rpi/buster/boot/work
>
> is ../boot/base/ supposed to be the uppermost lower layer.
> It's name and you description above sounds like it should be the
> bottom most layer,
> but you stacked ../boot/setup below it.
>
> > /srv/nfs/rpi/buster/boot/merged
> > mount: /srv/nfs/rpi/buster/boot/merged: mount(2) system call failed:
> > Stale file handle.
> > [ 1602.271239] overlayfs: failed to verify origin (boot/base,
> > ino=4194652, err=-116)
> > [ 1602.271244] overlayfs: failed to verify upper root origin
> >
>
> translation: boot/base is not the directory that used to be right below
> boot/updates. I guess you meant boot/setup to be on top of  boot/base?
>

whoops.

> Thanks,
> Amir.

no no, thank you ;)


-- 
Carl K
