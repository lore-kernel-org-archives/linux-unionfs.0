Return-Path: <linux-unionfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4B8B5C433F5
	for <linux-unionfs@archiver.kernel.org>; Tue,  7 Dec 2021 05:55:14 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231682AbhLGF6n (ORCPT
        <rfc822;linux-unionfs@archiver.kernel.org>);
        Tue, 7 Dec 2021 00:58:43 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36318 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230394AbhLGF6m (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Tue, 7 Dec 2021 00:58:42 -0500
Received: from mail-il1-x12e.google.com (mail-il1-x12e.google.com [IPv6:2607:f8b0:4864:20::12e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 032FAC061746
        for <linux-unionfs@vger.kernel.org>; Mon,  6 Dec 2021 21:55:13 -0800 (PST)
Received: by mail-il1-x12e.google.com with SMTP id j21so12623613ila.5
        for <linux-unionfs@vger.kernel.org>; Mon, 06 Dec 2021 21:55:12 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=b27WC7hZZPFKWuIpP5nM3lJXK33e7hylCrl2s0eKPdg=;
        b=nAQPdvdv6NK93F1KsL+ZAEdtgeqYdrI1q11dPHNQ1JhObP/q/q6FFHzCoSAy1DCSjZ
         Ptx5vlYkkG6MEXd6bB9Ns5PXNTcbB0xm5x8Ia2FQ1D5K7Bvpk7LtAn06l6rWbmJegnJb
         QAYzrH5u0Y73oZb5NuMVED2hBbGQTSM7quCnfyC2MbSKkz0LFb0nJfRCMlgLOyLxWlCT
         70NpTtAuKA5K58QF09ttZNTp/871oZAj4ldKOMXgxKGHQt6mxDksnjFwuEnCX2fzv2Qw
         cOWCzwyTFH1Mtzx0jTXKWen1D9B6VUxEsKfikmadf04iH8U88Eolol8ualK4oDSHPNjV
         So/w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=b27WC7hZZPFKWuIpP5nM3lJXK33e7hylCrl2s0eKPdg=;
        b=uyWIiYYm1rXkRb/bEe2QpbXhKgoVvTnd/3xLrzGkAiqQeIIqz5yb8cb5gn3Q0Z8zOL
         2q1sAE+VJMwB2LXKtledKqsfWURe+k1K2PNWWq6rdADCOdrIi2YA/dSY4tYr54ivdb0E
         r6mnKOsErgxl1qG4UKMN1mVHhtxeeswJ+3G4SpNNSkzneB3kIjl2eC61inmTmzRqaUXi
         +opUt2JeGG+pSbzSoJFOssHMukNLX8FjWaDJQAvxGKNhTibE67iCNCVKTvRnK11qmR81
         e2VFkNxRea7B+c9l6681cUQsmtx5Nu+bl6hKKpgU9qbRAsycuS0Bcxe7i+AXWuSFHMxt
         wY+w==
X-Gm-Message-State: AOAM5319vZbCyeh4gNJtjuustfo8KiDOuOEXE+JOOrmUKdDIl6n/zMWe
        3z23088uDAlbXbmUA/jneUdMTdGkDd5H7zku54B1mB1IxMg=
X-Google-Smtp-Source: ABdhPJxpoOmbyFPFYTg90JK6C+6TbK7oqDeKZRjHjYRLOV3pKyzgTDfhFZCVLH70dNN7mACpZgryH1asjiEK/B24z+k=
X-Received: by 2002:a05:6e02:1748:: with SMTP id y8mr18512538ill.107.1638856512328;
 Mon, 06 Dec 2021 21:55:12 -0800 (PST)
MIME-Version: 1.0
References: <CADmzSSjKoiYn7moEVFDV2p+x2BuTnWBLMBtdPQYsqQOttcgN1A@mail.gmail.com>
In-Reply-To: <CADmzSSjKoiYn7moEVFDV2p+x2BuTnWBLMBtdPQYsqQOttcgN1A@mail.gmail.com>
From:   Amir Goldstein <amir73il@gmail.com>
Date:   Tue, 7 Dec 2021 07:55:01 +0200
Message-ID: <CAOQ4uxgb4cGHS9ZU-LfJAzSnmFDQmZgEBwHHA-J+G520gVsCyg@mail.gmail.com>
Subject: Re: failed to verify upper - halts boot
To:     Carl Karsten <carl@nextdayvideo.com>
Cc:     overlayfs <linux-unionfs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-unionfs.vger.kernel.org>
X-Mailing-List: linux-unionfs@vger.kernel.org

On Tue, Dec 7, 2021 at 4:38 AM Carl Karsten <carl@nextdayvideo.com> wrote:
>
> I powercyced my box, I'm assuming I did a sudo poweroff or halt or
> something, but maybe not.
>
> It got stuck, (enter rescue mode, root account disabled, hit enter to
> enter rescue mode... )  so I killed power.
>
> I edited fstab, changed auto to noauto, booted.
>
> overlay   /srv/nfs/rpi/bullseye/boot/merged    overlay
> noauto,defaults,ro,lowerdir=/srv/nfs/rpi/bullseye/boot/updates:/srv/nfs/rpi/bullseye/boot/setup:/srv/nfs/rpi/bullseye/boot/base,upperdir=/srv/nfs/rpi/bullseye/boot/play,workdir=/srv/nfs/rpi/bullseye/boot/work,nfs_export=on
>    0   0
>
> # mount /srv/nfs/rpi/bullseye/boot/merged
> mount: /srv/nfs/rpi/bullseye/boot/merged: mount(2) system call failed:
> Stale file handle.
>
> dmesg shows:
>
> [   45.941350] overlayfs: failed to verify upper (boot/play,
> ino=379405, err=-116)
> [   45.941369] overlayfs: failed to verify index dir 'upper' xattr
> [   45.941379] overlayfs: try deleting index dir or mounting with '-o
> index=off' to disable inodes index.
>

Did you by any change re-create boot/play dir without re-creating
boot/work dir? because that is what that message means.
I doubt it has to do with the power cycle.

> It is a bit concerning that I need to consider a power cycle may
> require local console use.  I plan on managing this remotely.  For now
> I'll leave it noauto and remotely mount when needed.  so this isn't a
> critical blocker to me.
>
> What would happen:  errors=remount-ro
>
> errors={continue|remount-ro|panic}
>     Define the behavior  when  an  error  is  encountered.  The
> default is set in the filesystem superblock,  ...     and can be
> changed using tune2fs(8).
>

This looks like a quote from the man page section about ext2 mount options.
Those are not options supported for overlayfs.

Anyway, with that error, as the kernel log says, you could have mounted
overlayfs ro with -o index=off and we could have added a mount option
to fallback to ro mount with index=off, but that means no nfs_export,
so not sure if that is what you wanted.

Thanks,
Amir.
