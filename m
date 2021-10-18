Return-Path: <linux-unionfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D3D95C433EF
	for <linux-unionfs@archiver.kernel.org>; Mon, 18 Oct 2021 18:46:16 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id AD51E61263
	for <linux-unionfs@archiver.kernel.org>; Mon, 18 Oct 2021 18:46:16 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229924AbhJRSs1 (ORCPT
        <rfc822;linux-unionfs@archiver.kernel.org>);
        Mon, 18 Oct 2021 14:48:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52258 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229696AbhJRSs1 (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Mon, 18 Oct 2021 14:48:27 -0400
Received: from mail-ua1-x92f.google.com (mail-ua1-x92f.google.com [IPv6:2607:f8b0:4864:20::92f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 936A0C06161C
        for <linux-unionfs@vger.kernel.org>; Mon, 18 Oct 2021 11:46:15 -0700 (PDT)
Received: by mail-ua1-x92f.google.com with SMTP id h4so6445666uaw.1
        for <linux-unionfs@vger.kernel.org>; Mon, 18 Oct 2021 11:46:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=nextdayvideo-com.20210112.gappssmtp.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to;
        bh=win0v/vyjE4JRAIBrl0wA6VeszEztmbY0qIt6kpFTCI=;
        b=2arAprmrjC9lbZway1CkDwSthqZSQbWGVkyJLkn4rklx9/rKiTXFXXSz+kIGT24m0r
         +7YYorT4JTEtZvDGdC5HdH7ciuGRBUVZCK7Dp9yvKg5Kc+TKYaEIGlV5vog1PjZ+W5te
         HcE4veAwMeveTsuC5D65mwYMcAEUCrLOBtsclHS7gtpY9KeUjz1VS3RviHDKC1PJO9/e
         I8R01Rflf3EgGlk6cUxfMuPvYldvKorlx6QeML9mVm1EOpTbdrMcxjTTDWX2jIucPo1B
         deJ7R/KImyc6B7hIv7Iah0SpzKQsU87PiCRAUqcyR2OdzHaq9akpGg26r3vCVbsA2AN7
         yHtA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to;
        bh=win0v/vyjE4JRAIBrl0wA6VeszEztmbY0qIt6kpFTCI=;
        b=H4Mye+QlFXOVLByLrikYs3Cu4MlBJPK4aM5hDwXkaGzj9p2//ItpMv/VxgDOGSRrcv
         kO3D/lyMEjMSpKl7WDPh8XX4iNy24thDmoVsFXxfiVwJSfz9vdbTDYEORqi0d7zppyCV
         tFPXrdK3pZjrBuMED2Sx1j/e5gn22BmN6v23BQQfRwEUa1Pn+sJBWomnLNpWG80+8YGm
         T3cMa2DOTGRjtZ7wpaSeMY1bjxLcnD9n/J0+6QLl+2wwiuCJXzl0FqH6ZjOygwmxmwe6
         GVtL68jF6vq7xdiyE8NZcs4dMzKKGiE2wDXq7EnhanVyo2kJCBzTX8ReuiQqtXi/vLXv
         ZOsA==
X-Gm-Message-State: AOAM531lT5OezwSVS0WG5fAWBu6/njN8YYxp6pyf5p4yZ8aMniTxpx/N
        diI+G46s+6S7dvE7+xkSOtdAMXRUZPCxN1e8gvKykU/AzbM=
X-Google-Smtp-Source: ABdhPJzXHoSRuaxdjf3rRTkUpzq9Ueja94DUxkYuwRQc9mlhfEKFuqbvkvlivZcb0+P/DUsW1O0L03kCDYRn0a4pTs8=
X-Received: by 2002:ab0:76c9:: with SMTP id w9mr27030006uaq.125.1634582773580;
 Mon, 18 Oct 2021 11:46:13 -0700 (PDT)
MIME-Version: 1.0
References: <CADmzSSgquwg49GfMNSxi6KRcvq2nxPhwtiH311D+Ux_VTuE+fA@mail.gmail.com>
In-Reply-To: <CADmzSSgquwg49GfMNSxi6KRcvq2nxPhwtiH311D+Ux_VTuE+fA@mail.gmail.com>
From:   Carl Karsten <carl@nextdayvideo.com>
Date:   Mon, 18 Oct 2021 13:45:46 -0500
Message-ID: <CADmzSSgZqrBCavL=NmO1_YPCHP7DfG9hLnN4gNBXZXyJTo8XiQ@mail.gmail.com>
Subject: Re: sd .img partition loop support
To:     linux-unionfs@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-unionfs.vger.kernel.org>
X-Mailing-List: linux-unionfs@vger.kernel.org

I'm trying to overlay an empty upper dir onto a fat/loop/img fs and getting:

juser@negk:~/boot$ sudo mount -o ro /dev/mapper/loop0p1 img
juser@negk:~/boot$ sudo mount -t overlay overlay
-olowerdir=img,upperdir=upper,workdir=work merged
mount: /home/juser/boot/merged: wrong fs type, bad option, bad superblock
on overlay, missing codepage or helper program, or other error.

[ 2449.670177] overlayfs: filesystem on 'lower' not supported

code to replicate:

mkdir boot
cd boot
mkdir img  lower  upper work merged

wget http://downloads.raspberrypi.org/raspios_lite_armhf/images/raspios_lite_armhf-2020-05-28/2020-05-27-raspios-buster-lite-armhf.zip
unzip 2020-05-27-raspios-buster-lite-armhf.zip

sudo kpartx -av 2020-05-27-raspios-buster-lite-armhf.img
sudo mount /dev/mapper/loop0p1 img

# this errors:
sudo mount -t overlay overlay -olowerdir=img,upperdir=upper,workdir=work
merged

# this does not
cp img/* lower/
sudo mount -t overlay overlay -olowerdir=lower,upperdir=upper,workdir=work
merged

https://github.com/CarlFK/pici/blob/main/test1.sh

The goal is to netboot a pi using the files from the .img with a few
changes, the root kernel parameter needs to be changed from local storage
to nfs:
# tftp/cmdline.txt
root=/dev/nfs nfsroot=10.21.0.1:/srv/nfs/rpi/root,vers=4.1,proto=tcp rw
ip=dhcp rootwait elevator=deadline consoleblank=0

I can copy all the files from the .img into a dir,  but I am thinking I
should be able to overlay a dir on top to manage the changes.

If you want to see my netboot pi server setup
https://github.com/CarlFK/pici/blob/main/setup.md

--
Carl K
