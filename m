Return-Path: <linux-unionfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BC25AC433F5
	for <linux-unionfs@archiver.kernel.org>; Tue, 19 Oct 2021 19:48:42 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 8F284610FC
	for <linux-unionfs@archiver.kernel.org>; Tue, 19 Oct 2021 19:48:42 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231738AbhJSTuy (ORCPT
        <rfc822;linux-unionfs@archiver.kernel.org>);
        Tue, 19 Oct 2021 15:50:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53746 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230432AbhJSTux (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Tue, 19 Oct 2021 15:50:53 -0400
Received: from mail-vk1-xa30.google.com (mail-vk1-xa30.google.com [IPv6:2607:f8b0:4864:20::a30])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 84A72C06161C
        for <linux-unionfs@vger.kernel.org>; Tue, 19 Oct 2021 12:48:40 -0700 (PDT)
Received: by mail-vk1-xa30.google.com with SMTP id m199so10947155vka.6
        for <linux-unionfs@vger.kernel.org>; Tue, 19 Oct 2021 12:48:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=nextdayvideo-com.20210112.gappssmtp.com; s=20210112;
        h=mime-version:from:date:message-id:subject:to
         :content-transfer-encoding;
        bh=FdEHpN/ft3e9ijf/BzbEMNp6Ma15KW9UnxN0XcHxNZQ=;
        b=Qx9NEY5qcABfiLqz1HdkfHJqwOC8tgnm9cSHvmis1CJWB1dO0/t2wwxUAJZz+vJqfM
         kwCFnazmp9RjVpm1F+XbAfGc4geQ2Rx19shWh0pso8qPsW8/o/KnB6TBFTt8EjKx7FCF
         RGymmuKnzKAMOzbN8Vh/JHfryrUSmAd2CBrqPWcKZ7FzDGMM5zB/dAs2jPU82RaZqYCS
         tXWgoy2VDR4HyP88BH4OowuUf//GaPe9DASeSUjdIfrbInmqpp6UkEWCUPBFohVpwM7L
         0qel3kB0Ic3kxmdDzYXHumKu8G3Wtt/UwxaV0k1nPO5v7SDob/vB4RIDhPNbuuP3+GKf
         x8OQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:from:date:message-id:subject:to
         :content-transfer-encoding;
        bh=FdEHpN/ft3e9ijf/BzbEMNp6Ma15KW9UnxN0XcHxNZQ=;
        b=OmYmyIdqVILyBwpjn62RLqs2d+Ia4Gz96e3gOmCf4HtD75rzuZj8/D1lB15CqN9IvM
         YA7KAjDiYTiQzztZDPaq+EM0r+DTqKWUohCUItYYhIZP6OrEdSh1pYK9zwvV4w5BMSxc
         grkdz7oQ1frwd4ILQtR1KtNi+xcWg1/wSGueYeeH0bmO7PHVCz6f6r/cyOFl+8FU4CdF
         7eXmEBgHHnQWf9SzucfrZnueuhc2pfmgh0wH/p6hH2lQpkhhK/aCurhR8qRY0qS4UW1x
         s7hwsVspM0Grkd39p2bpMzi8uckEVHQIA/LmZlVyoIZ2EHjx5BR5yWO4BBeWFPbWR4KU
         +A8Q==
X-Gm-Message-State: AOAM532CXf0C38h00pMunZ0lM3VmxVnT1FbTfP2eKxhIduITplQRhWV0
        0rGnq/hco6begEAOQVG+r+H6azvPB0B3kt9dn5vsosSrygs=
X-Google-Smtp-Source: ABdhPJxG8aLOOIhwtR/k4WwA1JSvFGqSGFZv2E0ayECRqfBnDGjqEpMjH0bGKSysR4BrYBK1t/k9QAGYo3aBW5OAfNg=
X-Received: by 2002:a1f:f241:: with SMTP id q62mr15023322vkh.12.1634672919269;
 Tue, 19 Oct 2021 12:48:39 -0700 (PDT)
MIME-Version: 1.0
From:   Carl Karsten <carl@nextdayvideo.com>
Date:   Tue, 19 Oct 2021 14:48:12 -0500
Message-ID: <CADmzSSgiJ8jS5Ss-P+7_vXowM_TVNhwySE=QHwDhjG0Uj0Xr1g@mail.gmail.com>
Subject: nfs_export Stale file handle
To:     overlayfs <linux-unionfs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <linux-unionfs.vger.kernel.org>
X-Mailing-List: linux-unionfs@vger.kernel.org

I am sure this worked once, then I rebooted and now something ....

root@negk:/srv/nfs/rpi/root# mount -v -t overlay -o nfs_export=3Don
overlay -olowerdir=3Dimg,upperdir=3Dupper,workdir=3Dwork merged
mount: /srv/nfs/rpi/root/merged: mount(2) system call failed: Stale file ha=
ndle.

# this works:
root@negk:/srv/nfs/rpi/root# mount -v -t overlay -o nfs_export=3Doff
overlay -olowerdir=3Dimg,upperdir=3Dupper,workdir=3Dwork merged
mount: overlay mounted on /srv/nfs/rpi/root/merged.
root@negk:/srv/nfs/rpi/root# umount merged

# syslog:

[   80.317697] overlayfs: failed to verify origin (root/img,
ino=3D2374476, err=3D-116)
[   80.317703] overlayfs: failed to verify upper root origin

# no help:
systemctl disable nfs-server.service
reboot
root@negk:/srv/nfs/rpi/root# systemctl status nfs-server.service
=E2=97=8F nfs-server.service - NFS server and services
     Loaded: loaded (/lib/systemd/system/nfs-server.service; disabled;
vendor preset: enabled)
     Active: inactive (dead)





--=20
Carl K
