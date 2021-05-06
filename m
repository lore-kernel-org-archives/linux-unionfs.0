Return-Path: <linux-unionfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,
	SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CC5CEC433B4
	for <linux-unionfs@archiver.kernel.org>; Thu,  6 May 2021 10:26:05 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 815836100A
	for <linux-unionfs@archiver.kernel.org>; Thu,  6 May 2021 10:26:05 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234089AbhEFK1C (ORCPT
        <rfc822;linux-unionfs@archiver.kernel.org>);
        Thu, 6 May 2021 06:27:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48886 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231863AbhEFK1B (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Thu, 6 May 2021 06:27:01 -0400
Received: from mail-il1-x129.google.com (mail-il1-x129.google.com [IPv6:2607:f8b0:4864:20::129])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 078A1C061574
        for <linux-unionfs@vger.kernel.org>; Thu,  6 May 2021 03:26:03 -0700 (PDT)
Received: by mail-il1-x129.google.com with SMTP id j12so4322127ils.4
        for <linux-unionfs@vger.kernel.org>; Thu, 06 May 2021 03:26:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=n9ma0B6GeSEfsCNy1X+ng5FhSNpomtblQ4lQKSeP5y8=;
        b=vHm5eRSsU9a9ZMWe31WOMZth/lUphi+JhcJ6miNcN/M6Xw47ig20toUtn6Tsxn9UV1
         bA9u7s5s5pNI/7DG4lb2Y8uUFIxb34lboGEjPpr8WWLE5XcGTyRwFW2RX73vp2OCGZMf
         MPB+DDEoQnR/uoqe93lExRDGAl12JdZWD3zl3zclhouNyVVW/NVtVTWqWcQeaDvP7r8p
         aEZduugWkx2P9sCCgV/LGVVNOB+Z1kaPnY5lW+hCd7p6Yfm0i+9j8LFgHg6hmuy+/DWH
         LXgLwy/1SIR9b1RoxhKAdxT8zq6FqrvZbkt5duoq+babaTRxz1bN3Ifbm6Iw/ikq00i2
         WaqQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=n9ma0B6GeSEfsCNy1X+ng5FhSNpomtblQ4lQKSeP5y8=;
        b=nYPd6GYrRmTjKg9OF9FJef/QO2IHN3N+ezfmoKC1lk3R6HeGGkTYPaICRIDZ9l+Q5+
         xSYSnt3TzrK5x5tI77SRf5iuUmmoXgH+dT6AklHBj/dHxGSfUlfeFU6YgWYhN3vbyTF2
         Byto7G1OUZZyc+JCCOe3bwaqc1Bna/C3bAkX9BBhLhcl/IIG9+Q3zEDZP2mPeaFc4JP4
         8F8EwRfDZBVomvUI4WZTezfb7rIYLFqrLt4BcXJEUVS4s36K0l9TimBu+p4cldW8WoTh
         dq6NdohVGxpK36ke75g4FF/Nh6Tt90pEZtqQI9/E9fO5OXIik7hkY7ckxKBnHoUGe/L+
         c2Pg==
X-Gm-Message-State: AOAM533IxNFHRDxwzl7G1iM7oks0lXVNQnKwe7mT9AWoNY8lH1lgvgt6
        12tMpgilU1FYRb22xlvIwm3zpd6ejOQEI8ALy3Q=
X-Google-Smtp-Source: ABdhPJwsZthPJVF+DgZgiwKudHnyWKboYMk2n2vFzoolEoRPZTmU9HtNwNx6e1JwxeFLFYS57Ef+wQXLfPO7ou49bYQ=
X-Received: by 2002:a92:de0c:: with SMTP id x12mr3587377ilm.275.1620296762481;
 Thu, 06 May 2021 03:26:02 -0700 (PDT)
MIME-Version: 1.0
References: <20210427102826.1189410-1-amir73il@gmail.com> <123ca2cd.45f7.1792236c0e9.Coremail.ouyangxuan10@163.com>
 <CAOQ4uxh7So5F3H_qY+nDXV_u+8A9K8B+275mTb1deedO_9Fg+Q@mail.gmail.com> <74a06ca.4928.17941146e4b.Coremail.ouyangxuan10@163.com>
In-Reply-To: <74a06ca.4928.17941146e4b.Coremail.ouyangxuan10@163.com>
From:   Amir Goldstein <amir73il@gmail.com>
Date:   Thu, 6 May 2021 13:25:51 +0300
Message-ID: <CAOQ4uxhchH1XAHLB8z-s-3CSsAdwCCt9mqT9X4k40t-GvAL5Vw@mail.gmail.com>
Subject: Re: Re: [PATCH] ovl: relax lookup error on mismatch origin ftype
To:     www <ouyangxuan10@163.com>
Cc:     Miklos Szeredi <miklos@szeredi.hu>,
        Kevin Locke <kevin@kevinlocke.name>,
        overlayfs <linux-unionfs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-unionfs.vger.kernel.org>
X-Mailing-List: linux-unionfs@vger.kernel.org

On Thu, May 6, 2021 at 12:49 PM www <ouyangxuan10@163.com> wrote:
>
> Hi Amir,
>
>
>
> At 2021-05-01 00:16:28, "Amir Goldstein" <amir73il@gmail.com> wrote:
> >On Fri, Apr 30, 2021 at 12:59 PM www <ouyangxuan10@163.com> wrote:
> >>
> >> Hi Amir,
> >>
> >>
> >> Thank you very much for your help.  I have another question to clarify.
> >>
> >> >> 3. If we upgrade overlayfs separately, we are not very good at verifying that we have solved this problem, because the recurrence probability of this problem is very low. So I want to ask, how can we quickly reproduce this problem?
> >>
> >> >Re-creating a lower squashfs after files have been copied to upper should
> >> >reproduce the problem quite often.
> >>
> >> Does the re-creating lower squashfs here mean that remount squashfs?
> >> I've tested dozens of times in the remount way, but I haven't found this problem again?
> >> My test steps are:
> >> 1). umount lower squashfs;
> >> 2). modify the file in upper dir;
> >> 3). mount lower squanshfs;
> >> 4). restart service(it will re-parse the modified file)  or reboot the system and the problem didn't happen.
> >>
> >
> >No. That's not what I mean by re-creating lower fs.
> >What I mean is that overlayfs is the file is question is in the squashfs
> >image and has been copied up.
> >
> >I don't know where the squashfs image you are using comes from
> >but I am guessing you have replaced it with a new squashfs image.
> >In the new squashfs image, files have different inode numbers.
> >
> >I reckon this behavior is common for OpenWRT where the system
> >image is being upgraded.
> >
> https://github.com/openbmc/openbmc/blob/master/meta-phosphor/recipes-phosphor/initrdscripts/files/obmc-init.sh   (init file)
> ...
> line 376: mount  /run/image-rofs /run/initramfs/ro -t  squanshfs -o ro,loop          (line 358, set copy-base-filesystem-to-ram=y)
> ...
> line 416: mkdir -p $upper/var/log      --- new add line, not in the file
> line 417: mount -t overlayfs -o lowerdir=run/initramfs/ro,upperdir=run/initramfs/rw/cow,workdir=run/initramfs/rw/work  cow  /root
>  ...
> I would like to ask if the newly added line(line 416)  or "set set copy-base-filesystem-to-ram=y" causes this problem?(This folder is created and the value is set every time the system starts, but the probability of problems is not high)
> There are no other changes.
>
>

I don't know.

I am not sure what wasn't clear in my answer.

The lowerfs image, namely /run/image-rofs in your script can be downloaded
from tftp or from the web. I have no idea what actually happens in your setup.

Every time you run this init script this lower fs image may change, while the
upper f2fs rwfs does not change.
When that happens, it MAY cause the reported issue.

Thanks,
Amir.
