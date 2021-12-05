Return-Path: <linux-unionfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6FE4DC433EF
	for <linux-unionfs@archiver.kernel.org>; Sun,  5 Dec 2021 01:05:00 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230374AbhLEBIZ (ORCPT
        <rfc822;linux-unionfs@archiver.kernel.org>);
        Sat, 4 Dec 2021 20:08:25 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59980 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230366AbhLEBIZ (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Sat, 4 Dec 2021 20:08:25 -0500
Received: from mail-ua1-x92f.google.com (mail-ua1-x92f.google.com [IPv6:2607:f8b0:4864:20::92f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 57FABC061751
        for <linux-unionfs@vger.kernel.org>; Sat,  4 Dec 2021 17:04:59 -0800 (PST)
Received: by mail-ua1-x92f.google.com with SMTP id p37so12691204uae.8
        for <linux-unionfs@vger.kernel.org>; Sat, 04 Dec 2021 17:04:59 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=nextdayvideo-com.20210112.gappssmtp.com; s=20210112;
        h=mime-version:from:date:message-id:subject:to;
        bh=EYdnZbnIy1VPczM342y+rnduJv21k/ckZq/30GcRhGY=;
        b=kqNiqcLXMTo6A5GD4wOJjawyB58++ZolLbJwIgsNa3hl9L4jk/oeuWx6jl6gp8kRwa
         E8N34F5S3Q0chZ8hyixPP5KQBiAL0EEMzIF/TAlTvMGJcatPXEqH/2WcJdbDBjqWMzvA
         ocWqkhO3WA6SQoaivrIhnEgAZdlYN5VWxstJMi5vQ2wlNnKz8/B8nCyBUdRCJt3lnYV0
         k2qjiZulKmN4x6+avQMYdugWXfcTIZjzgqaA+hIbWkCp0yC73KpkgJIXkwOCumPXug3S
         fdPkUts1pCx55lcYwY5mftGd9PdSM1HeFVIT1yTEDCUDjxEu+m0ZshL8zbeep/s3XfQn
         pWog==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:from:date:message-id:subject:to;
        bh=EYdnZbnIy1VPczM342y+rnduJv21k/ckZq/30GcRhGY=;
        b=WEwk0kADMKlJi4+l+j2S27ggvPScv3vjPmuGw8aQDfcee/FA0uJjpd9ayom7NCpmzG
         wWOFCphDYOJ7LlWWCB66NbbIY9kKow54BF8NkNEMxbhK9xe85ZKKWHCXNEt9NDliD4WS
         6g9DY0hoseV1tjzm6QiCVBBDag7dC8pa8PvZZXYxDkmBJyhKlt8Jot2RLfaMQx1/Q5L6
         vG2uxF2TA78XetaCtRerBaDYZzz1TPsEfy6a7qukLqsUJUGHeOo0LiMtbnEBIoLGloZa
         DginIE8jo5l+21WBOrUB4QPQarSqzMsm+q9V6P5yYluhIiTzbquJZRc/OtPe0DjfbqC3
         XKmg==
X-Gm-Message-State: AOAM533brE3YUmqxJ43UFTup9K3NghcNj6W0etsBB7J3IpGYV/MkEDEG
        MkDBH5AlyhPglBdXlFcuNEH/YNwMKluCYTpMgU7pLTOqetk=
X-Google-Smtp-Source: ABdhPJwpXUHXeo8f43/IhAQBhccPaNlhQHX8c1gjz102+rBEgXxiaBgYc4tZ4hmPR8iJ99ydJCJ4YoG7uBBWyoZtTsg=
X-Received: by 2002:a05:6102:6c9:: with SMTP id m9mr29019735vsg.32.1638666298062;
 Sat, 04 Dec 2021 17:04:58 -0800 (PST)
MIME-Version: 1.0
From:   Carl Karsten <carl@nextdayvideo.com>
Date:   Sat, 4 Dec 2021 17:04:31 -0800
Message-ID: <CADmzSSjKoiYn7moEVFDV2p+x2BuTnWBLMBtdPQYsqQOttcgN1A@mail.gmail.com>
Subject: failed to verify upper - halts boot
To:     overlayfs <linux-unionfs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-unionfs.vger.kernel.org>
X-Mailing-List: linux-unionfs@vger.kernel.org

I powercyced my box, I'm assuming I did a sudo poweroff or halt or
something, but maybe not.

It got stuck, (enter rescue mode, root account disabled, hit enter to
enter rescue mode... )  so I killed power.

I edited fstab, changed auto to noauto, booted.

overlay   /srv/nfs/rpi/bullseye/boot/merged    overlay
noauto,defaults,ro,lowerdir=/srv/nfs/rpi/bullseye/boot/updates:/srv/nfs/rpi/bullseye/boot/setup:/srv/nfs/rpi/bullseye/boot/base,upperdir=/srv/nfs/rpi/bullseye/boot/play,workdir=/srv/nfs/rpi/bullseye/boot/work,nfs_export=on
   0   0

# mount /srv/nfs/rpi/bullseye/boot/merged
mount: /srv/nfs/rpi/bullseye/boot/merged: mount(2) system call failed:
Stale file handle.

dmesg shows:

[   45.941350] overlayfs: failed to verify upper (boot/play,
ino=379405, err=-116)
[   45.941369] overlayfs: failed to verify index dir 'upper' xattr
[   45.941379] overlayfs: try deleting index dir or mounting with '-o
index=off' to disable inodes index.

It is a bit concerning that I need to consider a power cycle may
require local console use.  I plan on managing this remotely.  For now
I'll leave it noauto and remotely mount when needed.  so this isn't a
critical blocker to me.

What would happen:  errors=remount-ro

errors={continue|remount-ro|panic}
    Define the behavior  when  an  error  is  encountered.  The
default is set in the filesystem superblock,  ...     and can be
changed using tune2fs(8).

In normal operation I want the mount ro anyway.
continue unmounted is also an option.  which would be better than
noauto if I am assured it won't get stuck at boot.

-- 
Carl K
