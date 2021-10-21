Return-Path: <linux-unionfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 181D9C433F5
	for <linux-unionfs@archiver.kernel.org>; Thu, 21 Oct 2021 07:09:38 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id EEF1461183
	for <linux-unionfs@archiver.kernel.org>; Thu, 21 Oct 2021 07:09:37 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230453AbhJUHLw (ORCPT
        <rfc822;linux-unionfs@archiver.kernel.org>);
        Thu, 21 Oct 2021 03:11:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50414 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230308AbhJUHLv (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Thu, 21 Oct 2021 03:11:51 -0400
Received: from mail-io1-xd2f.google.com (mail-io1-xd2f.google.com [IPv6:2607:f8b0:4864:20::d2f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 253BDC06161C
        for <linux-unionfs@vger.kernel.org>; Thu, 21 Oct 2021 00:09:36 -0700 (PDT)
Received: by mail-io1-xd2f.google.com with SMTP id s17so27619763ioa.13
        for <linux-unionfs@vger.kernel.org>; Thu, 21 Oct 2021 00:09:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=7bq8SGGPoJO96iQnoLdrqxTohKs+VxYaq0tvaq8akZc=;
        b=cUgslAE/CkhP86drOINl/Fp7qYuJp98xPYj/7LYqyoli0c6mmpuygV2DuNEL0WbcoX
         DKMldaJbdJY4i61LS0IIDGFm2mMjiEGYn+ns4FPy+Ro9f+enC3KAzOseFZYLGDWvyabE
         RAKWULnwMzQ8ECCPbhtXtQXFMx+nl+saJiLsld/8K6MTdlrBSshR3+W1+BsKGMdbe5iJ
         zvsiUVnvltu51MiEy86clpYA/OubOkOd4dohssGbOnuKJxtyQUiBTXcuQSrKryo6/NqC
         b9cLOmNBh5/EEQlUfqY+zkD9oUV9A4P3/DZMqDaoPzxM9xFbPV+Zm7z77bJqVA9jW+bp
         BuNg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=7bq8SGGPoJO96iQnoLdrqxTohKs+VxYaq0tvaq8akZc=;
        b=6MMfHWxm7j3Iq6rRmGct+eRYSbtgCSE0G5N7+bKDJgf2YaulPD5IbW3TUsKTBGB1cO
         mY7guDSLiB9VJFPs/PMe39PYXRLBmp4wfTalQT8oAmKmWuHfkpO7pJmxOOgkvdRE9ZHg
         KCd+LlxkX1efHOShQLSblE8ZHRN0wo/dOel0+4AIryysETo4rGjUpqnNGCpIRL9yL3pc
         LPFnukQqvCPKWAgHdfmuYs0vsMuuke0EWjJoVFgYiO9RndqpHE6EKKfJEQcakHF9/pU4
         WiFSu0Co8l8YEXt9/aNVPl+cS3nxijYIfwE6KdbJKMa/k5iPtdT3b7OAfEiEI1jdyKZh
         TqbA==
X-Gm-Message-State: AOAM532XBN76dUbUmtIYg8rjqTAMI/EFr1pf78hBOKi7fFLNUUUVmlnt
        NewQ0O3ABkC1vTNtrTl6E87Q7J8O/766LiUY0x7SZWxwtdY=
X-Google-Smtp-Source: ABdhPJySUur4CHqwpJUulfWEwU4Mg+nmJ0etN1iZcKmJIMIo4aRVUqxX4EPGy5G9gcnFnuLZpavVivCpzFON8w4p6hI=
X-Received: by 2002:a02:270c:: with SMTP id g12mr2676416jaa.75.1634800175555;
 Thu, 21 Oct 2021 00:09:35 -0700 (PDT)
MIME-Version: 1.0
References: <CADmzSSjy+bzPUus3xO2zT_USEKZYJ7WBOCbOiF+ro3EDoipXqg@mail.gmail.com>
In-Reply-To: <CADmzSSjy+bzPUus3xO2zT_USEKZYJ7WBOCbOiF+ro3EDoipXqg@mail.gmail.com>
From:   Amir Goldstein <amir73il@gmail.com>
Date:   Thu, 21 Oct 2021 10:09:24 +0300
Message-ID: <CAOQ4uxgN50djKrqE4FYhC0pNpHdp5HDyQcSQX4+dHqOYp_NY6A@mail.gmail.com>
Subject: Re: nfs server serving ... wrong mount?
To:     Carl Karsten <carl@nextdayvideo.com>
Cc:     overlayfs <linux-unionfs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-unionfs.vger.kernel.org>
X-Mailing-List: linux-unionfs@vger.kernel.org

On Thu, Oct 21, 2021 at 12:51 AM Carl Karsten <carl@nextdayvideo.com> wrote:
>
> I have 2 overlayfs monts.
>
> I can nfs export one or the other fine, but not both at the same time,
> the client gets the wrong files.

Hi Carl,

Thanks for the daily overlayfs riddles ;-)

This is not an overlayfs issue. It's nfs exports configuration issue.
Please read the documentation of fsid export option.
Disk filesystems have uuid so they don't need explicit identification.
Overlayfs does not have a stable UUID.

>
> server hosthame negk bullseye ext4
> client twist ubuntu
>
> juser@negk:~$ cat /etc/exports
> # /srv/nfs/rpi/buster/boot/merged *(ro,sync,no_subtree_check,no_root_squash)
> /srv/nfs/rpi/buster/root/merged *(ro,sync,no_subtree_check,no_root_squash)

In this case, "root" is auto assigned fsid 1

>
> juser@negk:~$ ls /srv/nfs/rpi/buster/boot/merged
> bcm2708-rpi-b.dtb       bcm2710-rpi-3-b-plus.dtb  fixup4cd.dat
> kernel7.img       start4.elf
> (snip)
>
> juser@negk:~$ ls /srv/nfs/rpi/buster/root/merged
> bin  boot  dev  etc  home  lib  lost+found  media  mnt  opt  proc
> root  run  sbin  srv  sys  tmp  usr  var
>
> carl@twist:~/mnt$ sudo mount -t nfs negk:/srv/nfs/rpi/buster/root/merged nfs
> carl@twist:~/mnt$ ls nfs
> bin  boot  dev  etc  home  lib  lost+found  media  mnt  opt  proc
> root  run  sbin  srv  sys  tmp  usr  var
> carl@twist:~/mnt$ sudo umount nfs
>
> # enable root in negk exports...

I think you meant enable "boot"
and is that case "boot" gets assigned fsid 1 and "root" gets reassigned fsid 2

>
> carl@twist:~/mnt$ sudo mount -t nfs negk:/srv/nfs/rpi/buster/root/merged nfs
> carl@twist:~/mnt$ ls nfs
> bcm2708-rpi-b.dtb       bcm2710-rpi-3-b-plus.dtb  fixup4cd.dat
> kernel7.img       start4.elf
> (snip)
>

It is a bit surprising to me that you get the wrong export after a clean mount,
but it doesn't change the core configuration issue.

Perhaps nfs client has some fsid cache or you have a deferred umount in
the system of negk:/srv/nfs/rpi/buster/root/merged (e.g. due to spawned mount
ns or something) and then the "new" nfs mount uses the old resolved fsid 1.

In any case, when exporting more than one non-disk filesystem, you should
use explicit fsid.

Thanks,
Amir.
