Return-Path: <linux-unionfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F2B79C433F5
	for <linux-unionfs@archiver.kernel.org>; Tue, 19 Oct 2021 06:53:46 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id D643D61177
	for <linux-unionfs@archiver.kernel.org>; Tue, 19 Oct 2021 06:53:46 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229695AbhJSGz6 (ORCPT
        <rfc822;linux-unionfs@archiver.kernel.org>);
        Tue, 19 Oct 2021 02:55:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44084 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229755AbhJSGz5 (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Tue, 19 Oct 2021 02:55:57 -0400
Received: from mail-il1-x135.google.com (mail-il1-x135.google.com [IPv6:2607:f8b0:4864:20::135])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6BE42C06161C
        for <linux-unionfs@vger.kernel.org>; Mon, 18 Oct 2021 23:53:45 -0700 (PDT)
Received: by mail-il1-x135.google.com with SMTP id k3so17422010ilu.2
        for <linux-unionfs@vger.kernel.org>; Mon, 18 Oct 2021 23:53:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=8KnZj6mBtHQ69uI49qi6KkXWxN4+VFG9hMsZHX+vaNc=;
        b=P9Yzljy8aZxyW9PErtzTogfrl03/NnA8VitQWh7tpuTbCn+FF3n6lrGYySLtbbajSV
         FX1tFc/UNS+V6/NOVEoebKuWdmJzHquY/cX95/fgzyy4CQBeDGFnk3wpNDVpvVzFUAT6
         nBLQsfcufl4rjYQOSASLRtQ+U1iyUUszD62/XX4J2VLhiXCZkJusRIjKvqD0V5ZfUgYN
         JeRcIfK+NNn0pdaR67PJPdp/OI05fDzwIKL+c4EW5nDdvTrSsz6D708KZwLEX87WLISE
         CT8VQ8JKIVXYggXiOwCZVe1nAVSefBzFtqLsDlyNBFfS7BBbvPNdhiDI6BxwurASJHEA
         idaQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=8KnZj6mBtHQ69uI49qi6KkXWxN4+VFG9hMsZHX+vaNc=;
        b=ArDvh683usyia2EDuAMjN80lAC4sBiAQYfOuh0rUOPbnTwoHfbi9G5pM3Je5fFTzMy
         SpFo+B1+MAf0KieNeL/jv/si81OiWgAuKPv2Xwh36vdykhlpgWOuwmx/wxmHw1kCR0F1
         gJiFm+Zf0eNKrJf2gFELu723kMo6ri+qh5A7B0JQW1LAT6gS+5VHYQ8jEc5+5rYpxJpm
         qC+dPzJ9gMdwSf92ka/AxhmGGMuEW13C9p0ST1ORU6L+1v5J3yJxefZG/Nw/ctYEwkjU
         gjfflAQCoT1iXJtiWrlYnApBnF24heD9VjvyucgcPhSzSd+hJk1BWy0J0Ui0k3+C6Gdb
         PO+w==
X-Gm-Message-State: AOAM533pr680vUrOmbN9rtauEstAXtM/jZXFgyupG5cCuUryVpYEOrTd
        AQMjEOooKK1aB9HxiW5AXuEHbn3VxDjKwlqKWodBlAN/2mE=
X-Google-Smtp-Source: ABdhPJzv+O+WFBAtShxO4dHKnaGCw54lmHTKdP7JO7tTTPrmGXNrrPavml3WhliRS7z7wi7Hn+zJHw0+4imHa4SsAn0=
X-Received: by 2002:a92:cd82:: with SMTP id r2mr18312307ilb.198.1634626424836;
 Mon, 18 Oct 2021 23:53:44 -0700 (PDT)
MIME-Version: 1.0
References: <CADmzSSgquwg49GfMNSxi6KRcvq2nxPhwtiH311D+Ux_VTuE+fA@mail.gmail.com>
 <CADmzSSgZqrBCavL=NmO1_YPCHP7DfG9hLnN4gNBXZXyJTo8XiQ@mail.gmail.com>
In-Reply-To: <CADmzSSgZqrBCavL=NmO1_YPCHP7DfG9hLnN4gNBXZXyJTo8XiQ@mail.gmail.com>
From:   Amir Goldstein <amir73il@gmail.com>
Date:   Tue, 19 Oct 2021 09:53:33 +0300
Message-ID: <CAOQ4uxizf9=arB8V7N_EtgsDrjO3XetKSCkQA3ErtwyovExkuA@mail.gmail.com>
Subject: Re: sd .img partition loop support
To:     Carl Karsten <carl@nextdayvideo.com>
Cc:     overlayfs <linux-unionfs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-unionfs.vger.kernel.org>
X-Mailing-List: linux-unionfs@vger.kernel.org

On Mon, Oct 18, 2021 at 9:46 PM Carl Karsten <carl@nextdayvideo.com> wrote:
>
> I'm trying to overlay an empty upper dir onto a fat/loop/img fs and getting:
>
> juser@negk:~/boot$ sudo mount -o ro /dev/mapper/loop0p1 img
> juser@negk:~/boot$ sudo mount -t overlay overlay
> -olowerdir=img,upperdir=upper,workdir=work merged
> mount: /home/juser/boot/merged: wrong fs type, bad option, bad superblock
> on overlay, missing codepage or helper program, or other error.
>
> [ 2449.670177] overlayfs: filesystem on 'lower' not supported
>

fat was never supported as lower or upper layer AFAIK, see:
https://lore.kernel.org/linux-unionfs/2527352.xHhNOModH5@nerdopolis/

This is due to the case insensitive and special name encoding of fat.
It is not unfixable, but it was never a priority for anyone to fix it.

I suppose it would be easier for you to copy the image to another filesystem
before constructing the overlay.

Thanks,
Amir.
