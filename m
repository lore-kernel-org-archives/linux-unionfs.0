Return-Path: <linux-unionfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 88EE0C433F5
	for <linux-unionfs@archiver.kernel.org>; Wed, 20 Oct 2021 05:42:53 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 658DB60E8F
	for <linux-unionfs@archiver.kernel.org>; Wed, 20 Oct 2021 05:42:53 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229789AbhJTFpG (ORCPT
        <rfc822;linux-unionfs@archiver.kernel.org>);
        Wed, 20 Oct 2021 01:45:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44028 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229591AbhJTFpF (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Wed, 20 Oct 2021 01:45:05 -0400
Received: from mail-il1-x132.google.com (mail-il1-x132.google.com [IPv6:2607:f8b0:4864:20::132])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 31BE9C06161C
        for <linux-unionfs@vger.kernel.org>; Tue, 19 Oct 2021 22:42:52 -0700 (PDT)
Received: by mail-il1-x132.google.com with SMTP id k3so20847491ilu.2
        for <linux-unionfs@vger.kernel.org>; Tue, 19 Oct 2021 22:42:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=i+t77wdJuZz05RkoODFSPR8I15UGiUs4OtKYSaFMW94=;
        b=ac7tZIQ+JfPw/h/t5JzgTG4+m6tOagVZNBq7lQ7V/3ls7IOhMvNSkZoIVffC2J3L0O
         vqqr5fJphC22c7RzgbsJ8UtAjAKXMpt5yfIBhlbBLZv8TiETRVh4eFQfIpDVkxwxSLtB
         WzpsuvBtSJiDShj1t1Po96XPf3D2o3KwmNndwrdQWXZU7a/Et4zD7uwE/7v53MKLgJlT
         yQLDvNQR+N4Ttl2yO3wDytM6OiXVYp7l2QY84NMiHdobYk8YbhOuZZMQHyeokM6Nhx58
         8gylcrq3yXXALknu9CtvJhmOqpgQLpamqCiZJ/TeBosQQPGSgp4EITy2D/cQKB6RUaAX
         /+dw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=i+t77wdJuZz05RkoODFSPR8I15UGiUs4OtKYSaFMW94=;
        b=uq5VG89vTjDcaqw02I/Mg2yMC/9kvhACuJJuUBviGAhs7lPyjABVNccDjVe+wllHPv
         axVHxzeVBpHYFFyRQLa/kLx4FyfZv82bqO60Oo7y8cQw/7kKJZQGg5pEggLbqJIz0WIz
         Bj7EniAQrYfr0Z47dgaL7hcsHM/0cJG/rPyh2VwArnWimDyUZNr7PGxT3iJJ+DXJ1xJE
         roPw//NKw45BRH/zUJc/GHgFqPVytbm5Hv7D/yNWGDwAY/Ory5JEY5hsnHzbrnFTar+e
         ms8I9P2Hi/xmRk9FJOEyZuE7Wl+R+Pzx/W7553qmbmTM7RxGUPlgVTjLCl9LhLQc3Kxq
         gOVA==
X-Gm-Message-State: AOAM532cy2TDlfWOK1PLQS5hVW/ydzU83hDLccTALZZy2kD/w7i2xUWS
        uZvHCpZ7/rSzObyn5mzlkeMAB4q9cg9ZsTw76K8GLVIif6c=
X-Google-Smtp-Source: ABdhPJzeiBrb07MW1PUT3gp8MaWX+GBthz5GTtv6RU6uOcqNXW5F29gNA109YvaYzaGoQG9u6x9l/knLtIlpAiTJ108=
X-Received: by 2002:a92:c083:: with SMTP id h3mr1082347ile.107.1634708571520;
 Tue, 19 Oct 2021 22:42:51 -0700 (PDT)
MIME-Version: 1.0
References: <CADmzSSgiJ8jS5Ss-P+7_vXowM_TVNhwySE=QHwDhjG0Uj0Xr1g@mail.gmail.com>
In-Reply-To: <CADmzSSgiJ8jS5Ss-P+7_vXowM_TVNhwySE=QHwDhjG0Uj0Xr1g@mail.gmail.com>
From:   Amir Goldstein <amir73il@gmail.com>
Date:   Wed, 20 Oct 2021 08:42:40 +0300
Message-ID: <CAOQ4uxiRthg8vMiFwNUW=V3HZhGyufgqFWBsBTh_SXVyXDO1jA@mail.gmail.com>
Subject: Re: nfs_export Stale file handle
To:     Carl Karsten <carl@nextdayvideo.com>
Cc:     overlayfs <linux-unionfs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <linux-unionfs.vger.kernel.org>
X-Mailing-List: linux-unionfs@vger.kernel.org

On Tue, Oct 19, 2021 at 10:49 PM Carl Karsten <carl@nextdayvideo.com> wrote=
:
>
> I am sure this worked once, then I rebooted and now something ....

Are you saying it is a regression? From which kernel?

>
> root@negk:/srv/nfs/rpi/root# mount -v -t overlay -o nfs_export=3Don
> overlay -olowerdir=3Dimg,upperdir=3Dupper,workdir=3Dwork merged
> mount: /srv/nfs/rpi/root/merged: mount(2) system call failed: Stale file =
handle.
>

What are lower and upper?
cat /proc/self/mountinfo please
If you happen to be using squashfs for lower fs, there were a bunch
of changes and fixes in recent kernels.

> # this works:
> root@negk:/srv/nfs/rpi/root# mount -v -t overlay -o nfs_export=3Doff
> overlay -olowerdir=3Dimg,upperdir=3Dupper,workdir=3Dwork merged
> mount: overlay mounted on /srv/nfs/rpi/root/merged.
> root@negk:/srv/nfs/rpi/root# umount merged
>
> # syslog:
>
> [   80.317697] overlayfs: failed to verify origin (root/img,
> ino=3D2374476, err=3D-116)
> [   80.317703] overlayfs: failed to verify upper root origin
>
> # no help:
> systemctl disable nfs-server.service
> reboot
> root@negk:/srv/nfs/rpi/root# systemctl status nfs-server.service
> =E2=97=8F nfs-server.service - NFS server and services
>      Loaded: loaded (/lib/systemd/system/nfs-server.service; disabled;
> vendor preset: enabled)
>      Active: inactive (dead)
>

The error has nothing to do with NFS.
The staleness is that of the root/img directory.
Overlayfs believes that someone has replaced the original
root/img directory with another directory on the same name
but a different file handle.

Did you re-create the lower image filesystem/subtree?
See Documentation clarification commit
13c6ad0f45fd ("ovl: document lower modification caveats")

Thanks,
Amir.
