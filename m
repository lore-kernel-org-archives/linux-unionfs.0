Return-Path: <linux-unionfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C36CBC2BBCA
	for <linux-unionfs@archiver.kernel.org>; Thu, 17 Dec 2020 18:07:50 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 872F323975
	for <linux-unionfs@archiver.kernel.org>; Thu, 17 Dec 2020 18:07:50 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728055AbgLQSHu (ORCPT
        <rfc822;linux-unionfs@archiver.kernel.org>);
        Thu, 17 Dec 2020 13:07:50 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41846 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726773AbgLQSHu (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Thu, 17 Dec 2020 13:07:50 -0500
Received: from mail-io1-xd2e.google.com (mail-io1-xd2e.google.com [IPv6:2607:f8b0:4864:20::d2e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CD2FDC0617A7
        for <linux-unionfs@vger.kernel.org>; Thu, 17 Dec 2020 10:07:09 -0800 (PST)
Received: by mail-io1-xd2e.google.com with SMTP id t8so28392914iov.8
        for <linux-unionfs@vger.kernel.org>; Thu, 17 Dec 2020 10:07:09 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=udVfvakiPnRfFe0FHLB4QNYwENFx080Zyvviyr/8VNA=;
        b=UNEhS0gZ9/46ptn6k1wuNAcI29l3xNDSyAxmjbcc9WHkZEqBKfrQ5nMa8tr7dEITQk
         p5l9mXN19uCUJjHpGyfh/Az19e/27Uc4FrDL6mBze2n2EIvZu2O2zJoQufMoKQySEUsR
         ie0taj4v7fUqugdMWf8YwyuegIjE66NFPLhnbcNLKPMe3WkNlvYpbGfI8+A/SOXikiTt
         Dg5WYzcY/+Yi2XnU6BxbDJD3iB7zmMJtxmEYGxzU/y2gsBevMYE9lOhGKhs9EYrN/tsY
         X6tRw8zUTzUIuFW29m8s09vgxw+mXkOSgflKcu1UCDL3xzD7UxeJ3XXHB496YouRk8wQ
         MsDQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=udVfvakiPnRfFe0FHLB4QNYwENFx080Zyvviyr/8VNA=;
        b=BCeoWEL9yTXW+1NN+ngllBbRMyZLRPoJyU/VsMfoYDEsdW5ZGueERUVlOOCsQGtio3
         CtcMxhmJEdqEkAQwY09bvyxTE231TasxoPCraq3V92on0vcMXLJ0yyAh1oDkprEKsMUx
         zDNIRSLG5Tfc3V0ENuLItqRFhucGVeO2bqKsTVc2RnoCw9+IS7r1CgeCRNssc4eojjGH
         ZGNPSqKWMlTWjVYwxEEQq5Oiuzxqp+9ptRtoPRbjRtcA8tRNRU5SIVkthVue+LSquGy3
         ZIOCtHuaj90GjYh2xZo/mLxDQMajLpULmHV9dGZIVOt3H8TTcAviNqlwyfkb8uQkEPPP
         UEwA==
X-Gm-Message-State: AOAM533PhWXPMo86dTITnrPerZ2ezg2dGLHV03BfWvCjXOTkCQ5iPvDp
        s3yypPgi4zAJ/uO1l0vGh52yp5m9J108cZsmOAEJffVB
X-Google-Smtp-Source: ABdhPJzFkIoB3A1VAkNYYmushK0hshI1Z2iGA/gLrRHfQGavWOBEQYNBWpUp40pt8IMXInmjGOQWqe4hVJWxJpmdnk4=
X-Received: by 2002:a02:9f19:: with SMTP id z25mr110920jal.30.1608228429009;
 Thu, 17 Dec 2020 10:07:09 -0800 (PST)
MIME-Version: 1.0
References: <2nv9d47zt7.fsf@aldarion.sourceruckus.org> <2n1rfrf5l0.fsf@aldarion.sourceruckus.org>
 <CAOQ4uxg4hmtGXg6dNghjfVpfiJFj6nauzqTgZucwSJAJq1Z3Eg@mail.gmail.com>
 <CAOQxz3wW8QF-+HFL1gcgH+nVvySN3fogop0v+KNcxpbzu9BkJA@mail.gmail.com>
 <CAOQ4uxgsFnkUqnXYyMNdZU=s_Wq18fdbr0ZhepNLMYh9MfPe9w@mail.gmail.com>
 <CAOQxz3wUvi_O7hzNrN8oTGfnFz-PiVr3Z6nG1ZXLFjpnH4q81g@mail.gmail.com>
 <CAOQxz3zGaKnJCUe7DuegOqbbPAvNj8hTFA6_LsGEPTMXwUpn6g@mail.gmail.com>
 <CAOQ4uxifSf-q1fXC_zxOpqR8GDX8sr2CWPsXrJ6e0YSrfB6v8Q@mail.gmail.com> <CAOQxz3xZWCdF=7AZ=N0ajcN8FVjzU2sS_SpxzwRFyHGvwc7dZA@mail.gmail.com>
In-Reply-To: <CAOQxz3xZWCdF=7AZ=N0ajcN8FVjzU2sS_SpxzwRFyHGvwc7dZA@mail.gmail.com>
From:   Amir Goldstein <amir73il@gmail.com>
Date:   Thu, 17 Dec 2020 20:06:57 +0200
Message-ID: <CAOQ4uxjmUY+N6sBoD-d2MN4eehPCcWzBXTHkDqAcCVtkpbG2kw@mail.gmail.com>
Subject: Re: failed open: No data available
To:     Michael Labriola <michael.d.labriola@gmail.com>
Cc:     overlayfs <linux-unionfs@vger.kernel.org>,
        Miklos Szeredi <miklos@szeredi.hu>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-unionfs.vger.kernel.org>
X-Mailing-List: linux-unionfs@vger.kernel.org

On Thu, Dec 17, 2020 at 6:22 PM Michael Labriola
<michael.d.labriola@gmail.com> wrote:
>
> On Thu, Dec 17, 2020 at 7:00 AM Amir Goldstein <amir73il@gmail.com> wrote:
> >
> > > > > and 'grep Y /sys/module/overlay/parameters/*'
> > > >
> > > > /sys/module/overlay/parameters/redirect_always_follow:Y
> > > > /sys/module/overlay/parameters/xino_auto:Y
> >
> > That's likely the reason that you are affected.
> > If you do not need the xino feature, you can set this to N or mount with
> > xino=off your system should be good.
>
> I just tried mounting w/ xino=off but everything still behaves the same.
>
> >
> > As the commit a888db3101 message says:
> >
> >     To avoid the reported regression while still allowing the new features
> >     with single lower squashfs, do not allow decoding origin with lower null
> >     uuid unless user opted-in to one of the new features that require
> >     following the lower inode of non-dir upper (index, xino, metacopy).
> >
> > You or someone related to your distro opted-in to xino by
> > CONFIG_OVERLAY_FS_XINO_AUTO=y
>
> Kernel config help for this sounded like something good, plus the
> Ubuntu 18.04 kernels all have this set (or did, when I checked last
> year).
>

Nice :) I didn't know that.

> >
> > which is smart to do IMO, but it probably exposed a bug.
> >
> > I still do not understand what the bug is, but please try the workaround.
> >
> > > >
> > > > >
> > > > > Do you see any "overlayfs:" logs in kmsg?
> > > >
> > > > [    4.828299] overlayfs: "xino" feature enabled using 32 upper inode bits.
> > > >
> > > > >
> > > > > If you do not need nfs export, you could try to create squashfs image with
> > > > > -no-exports as a possible workaround.
> > > >
> > > > If the problem persists, I will try that.  I'm not exporting anything
> > > > from the overlay.
> > >
> > > Ok, I can reproduce the problem 100% of the time using the attached
> > > squashfs image in 5.9 or 5.10.  In 5.8.18 and 5.4.83, everything works
> > > just fine.
> > >
> > >  mkdir -p t tt ttt
> > >  mount borky2.sqsh t
> > >  mount -t tmpfs tmp tt
> > >  mkdir -p tt/upper/{upper,work}
> > >  mount -t overlay -o \
> > >     lowerdir=t,upperdir=tt/upper/upper,workdir=tt/upper/work blarg ttt
> > > [ 1685.825956] overlayfs: "xino" feature enabled using 2 upper inode bits.
> > >
> > >  echo hello there > ttt/FOO
> > > zsh: no data available: ttt/FOO
> > >
> > >  echo hello there > ttt/BAR
> > > for some reason, that file is editable
> > >
> > >  touch ttt/*
> > > touch: cannot touch 'ttt/BAZ': No data available
> > > touch: cannot touch 'ttt/FOO': No data available
> > > touch: cannot touch 'ttt/FOO-symlink': No data available
> > >
> > > Things look completely broken now that I'm looking this closely at a
> > > fresh overlay... I'm honestly surprised my system was usable at all.
> > > I guess most of the files on my lower layer had already been
> > > upgraded prior to me starting to use the 5.9 kernel.
> > >
> > > I also tried creating a squashfs file w/ -no-exports...  exact same results.
> > >
> > > In case it helps, here are the relevant kernel config items:
> > >
> > > CONFIG_OVERLAY_FS=y
> > > # CONFIG_OVERLAY_FS_REDIRECT_DIR is not set
> > > CONFIG_OVERLAY_FS_REDIRECT_ALWAYS_FOLLOW=y
> > > # CONFIG_OVERLAY_FS_INDEX is not set
> > > CONFIG_OVERLAY_FS_XINO_AUTO=y
> > > # CONFIG_OVERLAY_FS_METACOPY is not set
> > >
> > > CONFIG_SQUASHFS=y
> > > # CONFIG_SQUASHFS_FILE_CACHE is not set
> > > CONFIG_SQUASHFS_FILE_DIRECT=y
> > > # CONFIG_SQUASHFS_DECOMP_SINGLE is not set
> > > # CONFIG_SQUASHFS_DECOMP_MULTI is not set
> > > CONFIG_SQUASHFS_DECOMP_MULTI_PERCPU=y
> > > CONFIG_SQUASHFS_XATTR=y
> > > CONFIG_SQUASHFS_ZLIB=y
> > > CONFIG_SQUASHFS_LZ4=y
> > > CONFIG_SQUASHFS_LZO=y
> > > CONFIG_SQUASHFS_XZ=y
> > > CONFIG_SQUASHFS_ZSTD=y
> > > # CONFIG_SQUASHFS_4K_DEVBLK_SIZE is not set
> > > # CONFIG_SQUASHFS_EMBEDDED is not set
> > > CONFIG_SQUASHFS_FRAGMENT_CACHE_SIZE=3
> > >
> >
> > Thanks for the reproducer and all the info, but it does not reproduce
> > on my test machine with v5.10.0.
> > I even changed my kernel config to match yours.
>
> Figured as much, given that I seem to be the only one reporting this.  ;-)
>
> >
> > So I am going to have to ask you to debug this and figure out which
> > overlayfs execution path is responsible for the error.
>
> Gladly.
>
> >
> > First thing in order is to get an strace to see which system call is
> > failing and try to enable overlayfs debug prints with:
> > echo "file fs/overlayfs/*  +p" > /sys/kernel/debug/dynamic_debug/control
> >
> > If that is not enough to pin point the problem, will need to ask you do
> > add debug prints in overlayfs code to understand the path of failure.
>
> Thanks, Amir.  I didn't have CONFIG_DYNAMIC_DEBUG enabled, so

I honestly don't expect to find much in the existing overlay debug prints
but you never know..
I suspect you will have to add debug prints to find the problem.

> recompiling with that and without CONFIG_OVERLAY_FS_XINO_AUTO to see
> if that changes anything.  Here's output of strace touch FOO (from
> inside my overlay mount) w/ yesterday's kernel and xino=off while I wait:
>
> execve("/usr/bin/touch", ["touch", "FOO"], 0x7ffe51adb598 /* 22 vars */) = 0
> brk(NULL)                               = 0x55bdf16c1000
> access("/etc/ld.so.nohwcap", F_OK)      = -1 ENOENT (No such file or directory)
> access("/etc/ld.so.preload", R_OK)      = -1 ENOENT (No such file or directory)
> openat(AT_FDCWD, "/etc/ld.so.cache", O_RDONLY|O_CLOEXEC) = 3
> fstat(3, {st_mode=S_IFREG|0644, st_size=180434, ...}) = 0
> mmap(NULL, 180434, PROT_READ, MAP_PRIVATE, 3, 0) = 0x151ca6528000
> close(3)                                = 0
> access("/etc/ld.so.nohwcap", F_OK)      = -1 ENOENT (No such file or directory)
> openat(AT_FDCWD, "/lib/x86_64-linux-gnu/libc.so.6", O_RDONLY|O_CLOEXEC) = 3
> read(3, "\177ELF\2\1\1\3\0\0\0\0\0\0\0\0\3\0>\0\1\0\0\0\20\35\2\0\0\0\0\0"...,
> 832) = 832
> fstat(3, {st_mode=S_IFREG|0755, st_size=2030928, ...}) = 0
> mmap(NULL, 8192, PROT_READ|PROT_WRITE, MAP_PRIVATE|MAP_ANONYMOUS, -1,
> 0) = 0x151ca6526000
> mmap(NULL, 4131552, PROT_READ|PROT_EXEC, MAP_PRIVATE|MAP_DENYWRITE, 3,
> 0) = 0x151ca5f3b000
> mprotect(0x151ca6122000, 2097152, PROT_NONE) = 0
> mmap(0x151ca6322000, 24576, PROT_READ|PROT_WRITE,
> MAP_PRIVATE|MAP_FIXED|MAP_DENYWRITE, 3, 0x1e7000) = 0x151ca6322000
> mmap(0x151ca6328000, 15072, PROT_READ|PROT_WRITE,
> MAP_PRIVATE|MAP_FIXED|MAP_ANONYMOUS, -1, 0) = 0x151ca6328000
> close(3)                                = 0
> arch_prctl(ARCH_SET_FS, 0x151ca6527540) = 0
> mprotect(0x151ca6322000, 16384, PROT_READ) = 0
> mprotect(0x55bdf0214000, 4096, PROT_READ) = 0
> mprotect(0x151ca6555000, 4096, PROT_READ) = 0
> munmap(0x151ca6528000, 180434)          = 0
> brk(NULL)                               = 0x55bdf16c1000
> brk(0x55bdf16e2000)                     = 0x55bdf16e2000
> openat(AT_FDCWD, "FOO", O_WRONLY|O_CREAT|O_NOCTTY|O_NONBLOCK, 0666) =
> -1 ENODATA (No data available)

As expected that added no new information either, but needed to be sure.

Thanks,
Amir.
