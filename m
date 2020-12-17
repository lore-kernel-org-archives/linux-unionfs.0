Return-Path: <linux-unionfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 382DCC4361B
	for <linux-unionfs@archiver.kernel.org>; Thu, 17 Dec 2020 12:01:16 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id D277E238EF
	for <linux-unionfs@archiver.kernel.org>; Thu, 17 Dec 2020 12:01:15 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725871AbgLQMBA (ORCPT
        <rfc822;linux-unionfs@archiver.kernel.org>);
        Thu, 17 Dec 2020 07:01:00 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41414 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725988AbgLQMA6 (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Thu, 17 Dec 2020 07:00:58 -0500
Received: from mail-io1-xd34.google.com (mail-io1-xd34.google.com [IPv6:2607:f8b0:4864:20::d34])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9AD11C061794
        for <linux-unionfs@vger.kernel.org>; Thu, 17 Dec 2020 04:00:18 -0800 (PST)
Received: by mail-io1-xd34.google.com with SMTP id p187so27243013iod.4
        for <linux-unionfs@vger.kernel.org>; Thu, 17 Dec 2020 04:00:18 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=YelazWLZ8agMIBPlLR2wcULul0uLlU+nmzaXPeCEHnY=;
        b=N2R+cuJwfDJ8W5BKfOAFAosG7v6EUqAxpSSiDZI4OpzReowAMKh27kDwT9J4AqjKui
         lwvfStVV2f7voTg0H3t1T7a9A8t37PqOhwdWT4Z/UUlYkw78iXcCKIkWk38M8T3lBSC8
         tf29ppUHZRQiFrlpaOoBzCpbSUTvDknJ8AH3NIg8a1fea62zuw14JD8iA9H8jXoGIeqI
         CVVbLmG8XqO8CfMgPmcVXwZTR9Oto5JaZeHJUwgHzs5DWh/Fet18NhVTFEcY+G/l7v7g
         q8sssbNiYrtwidiuB/xCMJ+Md8CCrz5KrYfbRzCATraEIp9PpTKQNMLfZ0jpu+vbHInG
         OoaA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=YelazWLZ8agMIBPlLR2wcULul0uLlU+nmzaXPeCEHnY=;
        b=NWrQVANQifQs1mQSgLxd10zm0wgwmsmfvM3GZMrypkqjyOSljyy9fFy1yiDRDtDUsT
         79yD2Zl89fp8R9M4VTAtFZd6NLWUQXzwLYUxkP4ycyvYORGTSCS/recOGFZy++fxDi3G
         SidBY1+0J/af2O5p3RnPfgqRkLgKMKlBwyaPqAd1Rs3s21vbR3n7hcOl3T/ESUuXFw5V
         II2CR8Ut5wGGzSOxysorTfOLD/SBWmuPdiQck8ZxxjM7PMXOtVnvqNF+DeBwpdGfXuLq
         SEYdHK9N3CTT4bVLSBlby8mBxK9hYje49Xtd6TFf8hqwR9V5QYJn+p6D1LAbn3Zs/4Vm
         4H5w==
X-Gm-Message-State: AOAM5327vbV3GU3rrdZn18zR/AOxX1VSTZTH9T40XhdWUZTFvu428Wd9
        delNGy/ZkvYH3t5ccqO4/33eoGQempqrpuM9QbN1gZZ6o/M=
X-Google-Smtp-Source: ABdhPJwnSRkyvl9ERz3x/SvxKKTmO6wCT4sUNrdKtAJySU/AyBYktSk2ex7CyRIx4xZ/YFDpf4GENINPt8BfSJ31O8Y=
X-Received: by 2002:a02:9f19:: with SMTP id z25mr47438946jal.30.1608206417966;
 Thu, 17 Dec 2020 04:00:17 -0800 (PST)
MIME-Version: 1.0
References: <2nv9d47zt7.fsf@aldarion.sourceruckus.org> <2n1rfrf5l0.fsf@aldarion.sourceruckus.org>
 <CAOQ4uxg4hmtGXg6dNghjfVpfiJFj6nauzqTgZucwSJAJq1Z3Eg@mail.gmail.com>
 <CAOQxz3wW8QF-+HFL1gcgH+nVvySN3fogop0v+KNcxpbzu9BkJA@mail.gmail.com>
 <CAOQ4uxgsFnkUqnXYyMNdZU=s_Wq18fdbr0ZhepNLMYh9MfPe9w@mail.gmail.com>
 <CAOQxz3wUvi_O7hzNrN8oTGfnFz-PiVr3Z6nG1ZXLFjpnH4q81g@mail.gmail.com> <CAOQxz3zGaKnJCUe7DuegOqbbPAvNj8hTFA6_LsGEPTMXwUpn6g@mail.gmail.com>
In-Reply-To: <CAOQxz3zGaKnJCUe7DuegOqbbPAvNj8hTFA6_LsGEPTMXwUpn6g@mail.gmail.com>
From:   Amir Goldstein <amir73il@gmail.com>
Date:   Thu, 17 Dec 2020 14:00:06 +0200
Message-ID: <CAOQ4uxifSf-q1fXC_zxOpqR8GDX8sr2CWPsXrJ6e0YSrfB6v8Q@mail.gmail.com>
Subject: Re: failed open: No data available
To:     Michael Labriola <michael.d.labriola@gmail.com>
Cc:     overlayfs <linux-unionfs@vger.kernel.org>,
        Miklos Szeredi <miklos@szeredi.hu>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-unionfs.vger.kernel.org>
X-Mailing-List: linux-unionfs@vger.kernel.org

> > > and 'grep Y /sys/module/overlay/parameters/*'
> >
> > /sys/module/overlay/parameters/redirect_always_follow:Y
> > /sys/module/overlay/parameters/xino_auto:Y

That's likely the reason that you are affected.
If you do not need the xino feature, you can set this to N or mount with
xino=off your system should be good.

As the commit a888db3101 message says:

    To avoid the reported regression while still allowing the new features
    with single lower squashfs, do not allow decoding origin with lower null
    uuid unless user opted-in to one of the new features that require
    following the lower inode of non-dir upper (index, xino, metacopy).

You or someone related to your distro opted-in to xino by
CONFIG_OVERLAY_FS_XINO_AUTO=y

which is smart to do IMO, but it probably exposed a bug.

I still do not understand what the bug is, but please try the workaround.

> >
> > >
> > > Do you see any "overlayfs:" logs in kmsg?
> >
> > [    4.828299] overlayfs: "xino" feature enabled using 32 upper inode bits.
> >
> > >
> > > If you do not need nfs export, you could try to create squashfs image with
> > > -no-exports as a possible workaround.
> >
> > If the problem persists, I will try that.  I'm not exporting anything
> > from the overlay.
>
> Ok, I can reproduce the problem 100% of the time using the attached
> squashfs image in 5.9 or 5.10.  In 5.8.18 and 5.4.83, everything works
> just fine.
>
>  mkdir -p t tt ttt
>  mount borky2.sqsh t
>  mount -t tmpfs tmp tt
>  mkdir -p tt/upper/{upper,work}
>  mount -t overlay -o \
>     lowerdir=t,upperdir=tt/upper/upper,workdir=tt/upper/work blarg ttt
> [ 1685.825956] overlayfs: "xino" feature enabled using 2 upper inode bits.
>
>  echo hello there > ttt/FOO
> zsh: no data available: ttt/FOO
>
>  echo hello there > ttt/BAR
> for some reason, that file is editable
>
>  touch ttt/*
> touch: cannot touch 'ttt/BAZ': No data available
> touch: cannot touch 'ttt/FOO': No data available
> touch: cannot touch 'ttt/FOO-symlink': No data available
>
> Things look completely broken now that I'm looking this closely at a
> fresh overlay... I'm honestly surprised my system was usable at all.
> I guess most of the files on my lower layer had already been
> upgraded prior to me starting to use the 5.9 kernel.
>
> I also tried creating a squashfs file w/ -no-exports...  exact same results.
>
> In case it helps, here are the relevant kernel config items:
>
> CONFIG_OVERLAY_FS=y
> # CONFIG_OVERLAY_FS_REDIRECT_DIR is not set
> CONFIG_OVERLAY_FS_REDIRECT_ALWAYS_FOLLOW=y
> # CONFIG_OVERLAY_FS_INDEX is not set
> CONFIG_OVERLAY_FS_XINO_AUTO=y
> # CONFIG_OVERLAY_FS_METACOPY is not set
>
> CONFIG_SQUASHFS=y
> # CONFIG_SQUASHFS_FILE_CACHE is not set
> CONFIG_SQUASHFS_FILE_DIRECT=y
> # CONFIG_SQUASHFS_DECOMP_SINGLE is not set
> # CONFIG_SQUASHFS_DECOMP_MULTI is not set
> CONFIG_SQUASHFS_DECOMP_MULTI_PERCPU=y
> CONFIG_SQUASHFS_XATTR=y
> CONFIG_SQUASHFS_ZLIB=y
> CONFIG_SQUASHFS_LZ4=y
> CONFIG_SQUASHFS_LZO=y
> CONFIG_SQUASHFS_XZ=y
> CONFIG_SQUASHFS_ZSTD=y
> # CONFIG_SQUASHFS_4K_DEVBLK_SIZE is not set
> # CONFIG_SQUASHFS_EMBEDDED is not set
> CONFIG_SQUASHFS_FRAGMENT_CACHE_SIZE=3
>

Thanks for the reproducer and all the info, but it does not reproduce
on my test machine with v5.10.0.
I even changed my kernel config to match yours.

So I am going to have to ask you to debug this and figure out which
overlayfs execution path is responsible for the error.

First thing in order is to get an strace to see which system call is
failing and try to enable overlayfs debug prints with:
echo "file fs/overlayfs/*  +p" > /sys/kernel/debug/dynamic_debug/control

If that is not enough to pin point the problem, will need to ask you do
add debug prints in overlayfs code to understand the path of failure.

Thanks,
Amir.
