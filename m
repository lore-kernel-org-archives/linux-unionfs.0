Return-Path: <linux-unionfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 25B8AC4361B
	for <linux-unionfs@archiver.kernel.org>; Thu, 17 Dec 2020 16:23:15 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id D445823426
	for <linux-unionfs@archiver.kernel.org>; Thu, 17 Dec 2020 16:23:14 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727253AbgLQQXO (ORCPT
        <rfc822;linux-unionfs@archiver.kernel.org>);
        Thu, 17 Dec 2020 11:23:14 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53944 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726999AbgLQQXO (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Thu, 17 Dec 2020 11:23:14 -0500
Received: from mail-oi1-x22a.google.com (mail-oi1-x22a.google.com [IPv6:2607:f8b0:4864:20::22a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E27C4C061794
        for <linux-unionfs@vger.kernel.org>; Thu, 17 Dec 2020 08:22:33 -0800 (PST)
Received: by mail-oi1-x22a.google.com with SMTP id 15so32804958oix.8
        for <linux-unionfs@vger.kernel.org>; Thu, 17 Dec 2020 08:22:33 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=dg3DBOsqX+iBdlfxSKs9YHhwScAoCdoBWQ1W3WduEE8=;
        b=NErsqQDkhyMT6E+CvkRQqAJF7mgiCjTvqb5KM4iZ21ys4+0oZRqkkD7fMZDta2GLCi
         /hSCK6CeE+X7UqOMcUpZRg2infyzfY+Pps6UjdZze2xJZM96fGF+ikN490Qc8sgsANIa
         NPlEjtwJFj4IfizRG//X94BgRfunLQE7dgK/OJ76cd56QYwwSrET0xWQtu26xOYC029X
         0mMQOFJTcyNzD8OqyvQ5vtGcj2j70upF6DykkPQhyc1pA5sE2qMeEHDxymZcrNVMacxh
         OqjMOypoNFAS+zmlMAtXL6xVkc7nQ11vVmhcyznsqUIC8X2IqujVRUqiKkbbFBgRsGoo
         F9qA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=dg3DBOsqX+iBdlfxSKs9YHhwScAoCdoBWQ1W3WduEE8=;
        b=TQ5F0rxU9Y6vSGPAJAmF8va+dlJE4eM7hdwZqxrLFadrvy24fs+ZI/v484Kjp7QQ7p
         vCVf8waDU0Z4n/vEJza4oeyStSHCciXS9f3WVR6OD86x1YMiVhgyW3a4lBDjBihI1tFu
         aNB+EBvZ+IeCQSpIJe7qg/sK5OTsQ9gkD1xP+wNX+lfpu8LMlNBmUY3RG7hU8Gggg7Jt
         VVVBDd8IHDSdFmCAZQ7kiF5NahH2BsU9IDbmGOffntpJQhLJSYyyslwcIw8NBRIjIzbt
         kUho58xoxZg+D7Spni/BSTJ3pNOrjROPu6FubCrf2xvP8lSidX7nArPP3XsHuWMALZ5D
         gNQQ==
X-Gm-Message-State: AOAM53136ny8C5YHbti4W4iQ/fVsB/qY6jFE63hnIglB+5784jVdfI1e
        qxassxPY+ri28WvZtETqBdYKR6B5sZIN33KoccdoD2gwMn57BQ==
X-Google-Smtp-Source: ABdhPJzoRUvVlGwjU/10ddd05WBbEW6xvqX4vFj4B8j8oPtF+AF6i8TcKUWIYv431MoA/HfZet/ZMhTcUtJR1EEXfJA=
X-Received: by 2002:aca:ec43:: with SMTP id k64mr5331658oih.43.1608222153189;
 Thu, 17 Dec 2020 08:22:33 -0800 (PST)
MIME-Version: 1.0
References: <2nv9d47zt7.fsf@aldarion.sourceruckus.org> <2n1rfrf5l0.fsf@aldarion.sourceruckus.org>
 <CAOQ4uxg4hmtGXg6dNghjfVpfiJFj6nauzqTgZucwSJAJq1Z3Eg@mail.gmail.com>
 <CAOQxz3wW8QF-+HFL1gcgH+nVvySN3fogop0v+KNcxpbzu9BkJA@mail.gmail.com>
 <CAOQ4uxgsFnkUqnXYyMNdZU=s_Wq18fdbr0ZhepNLMYh9MfPe9w@mail.gmail.com>
 <CAOQxz3wUvi_O7hzNrN8oTGfnFz-PiVr3Z6nG1ZXLFjpnH4q81g@mail.gmail.com>
 <CAOQxz3zGaKnJCUe7DuegOqbbPAvNj8hTFA6_LsGEPTMXwUpn6g@mail.gmail.com> <CAOQ4uxifSf-q1fXC_zxOpqR8GDX8sr2CWPsXrJ6e0YSrfB6v8Q@mail.gmail.com>
In-Reply-To: <CAOQ4uxifSf-q1fXC_zxOpqR8GDX8sr2CWPsXrJ6e0YSrfB6v8Q@mail.gmail.com>
From:   Michael Labriola <michael.d.labriola@gmail.com>
Date:   Thu, 17 Dec 2020 11:22:22 -0500
Message-ID: <CAOQxz3xZWCdF=7AZ=N0ajcN8FVjzU2sS_SpxzwRFyHGvwc7dZA@mail.gmail.com>
Subject: Re: failed open: No data available
To:     Amir Goldstein <amir73il@gmail.com>
Cc:     overlayfs <linux-unionfs@vger.kernel.org>,
        Miklos Szeredi <miklos@szeredi.hu>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-unionfs.vger.kernel.org>
X-Mailing-List: linux-unionfs@vger.kernel.org

On Thu, Dec 17, 2020 at 7:00 AM Amir Goldstein <amir73il@gmail.com> wrote:
>
> > > > and 'grep Y /sys/module/overlay/parameters/*'
> > >
> > > /sys/module/overlay/parameters/redirect_always_follow:Y
> > > /sys/module/overlay/parameters/xino_auto:Y
>
> That's likely the reason that you are affected.
> If you do not need the xino feature, you can set this to N or mount with
> xino=off your system should be good.

I just tried mounting w/ xino=off but everything still behaves the same.

>
> As the commit a888db3101 message says:
>
>     To avoid the reported regression while still allowing the new features
>     with single lower squashfs, do not allow decoding origin with lower null
>     uuid unless user opted-in to one of the new features that require
>     following the lower inode of non-dir upper (index, xino, metacopy).
>
> You or someone related to your distro opted-in to xino by
> CONFIG_OVERLAY_FS_XINO_AUTO=y

Kernel config help for this sounded like something good, plus the
Ubuntu 18.04 kernels all have this set (or did, when I checked last
year).

>
> which is smart to do IMO, but it probably exposed a bug.
>
> I still do not understand what the bug is, but please try the workaround.
>
> > >
> > > >
> > > > Do you see any "overlayfs:" logs in kmsg?
> > >
> > > [    4.828299] overlayfs: "xino" feature enabled using 32 upper inode bits.
> > >
> > > >
> > > > If you do not need nfs export, you could try to create squashfs image with
> > > > -no-exports as a possible workaround.
> > >
> > > If the problem persists, I will try that.  I'm not exporting anything
> > > from the overlay.
> >
> > Ok, I can reproduce the problem 100% of the time using the attached
> > squashfs image in 5.9 or 5.10.  In 5.8.18 and 5.4.83, everything works
> > just fine.
> >
> >  mkdir -p t tt ttt
> >  mount borky2.sqsh t
> >  mount -t tmpfs tmp tt
> >  mkdir -p tt/upper/{upper,work}
> >  mount -t overlay -o \
> >     lowerdir=t,upperdir=tt/upper/upper,workdir=tt/upper/work blarg ttt
> > [ 1685.825956] overlayfs: "xino" feature enabled using 2 upper inode bits.
> >
> >  echo hello there > ttt/FOO
> > zsh: no data available: ttt/FOO
> >
> >  echo hello there > ttt/BAR
> > for some reason, that file is editable
> >
> >  touch ttt/*
> > touch: cannot touch 'ttt/BAZ': No data available
> > touch: cannot touch 'ttt/FOO': No data available
> > touch: cannot touch 'ttt/FOO-symlink': No data available
> >
> > Things look completely broken now that I'm looking this closely at a
> > fresh overlay... I'm honestly surprised my system was usable at all.
> > I guess most of the files on my lower layer had already been
> > upgraded prior to me starting to use the 5.9 kernel.
> >
> > I also tried creating a squashfs file w/ -no-exports...  exact same results.
> >
> > In case it helps, here are the relevant kernel config items:
> >
> > CONFIG_OVERLAY_FS=y
> > # CONFIG_OVERLAY_FS_REDIRECT_DIR is not set
> > CONFIG_OVERLAY_FS_REDIRECT_ALWAYS_FOLLOW=y
> > # CONFIG_OVERLAY_FS_INDEX is not set
> > CONFIG_OVERLAY_FS_XINO_AUTO=y
> > # CONFIG_OVERLAY_FS_METACOPY is not set
> >
> > CONFIG_SQUASHFS=y
> > # CONFIG_SQUASHFS_FILE_CACHE is not set
> > CONFIG_SQUASHFS_FILE_DIRECT=y
> > # CONFIG_SQUASHFS_DECOMP_SINGLE is not set
> > # CONFIG_SQUASHFS_DECOMP_MULTI is not set
> > CONFIG_SQUASHFS_DECOMP_MULTI_PERCPU=y
> > CONFIG_SQUASHFS_XATTR=y
> > CONFIG_SQUASHFS_ZLIB=y
> > CONFIG_SQUASHFS_LZ4=y
> > CONFIG_SQUASHFS_LZO=y
> > CONFIG_SQUASHFS_XZ=y
> > CONFIG_SQUASHFS_ZSTD=y
> > # CONFIG_SQUASHFS_4K_DEVBLK_SIZE is not set
> > # CONFIG_SQUASHFS_EMBEDDED is not set
> > CONFIG_SQUASHFS_FRAGMENT_CACHE_SIZE=3
> >
>
> Thanks for the reproducer and all the info, but it does not reproduce
> on my test machine with v5.10.0.
> I even changed my kernel config to match yours.

Figured as much, given that I seem to be the only one reporting this.  ;-)

>
> So I am going to have to ask you to debug this and figure out which
> overlayfs execution path is responsible for the error.

Gladly.

>
> First thing in order is to get an strace to see which system call is
> failing and try to enable overlayfs debug prints with:
> echo "file fs/overlayfs/*  +p" > /sys/kernel/debug/dynamic_debug/control
>
> If that is not enough to pin point the problem, will need to ask you do
> add debug prints in overlayfs code to understand the path of failure.

Thanks, Amir.  I didn't have CONFIG_DYNAMIC_DEBUG enabled, so
recompiling with that and without CONFIG_OVERLAY_FS_XINO_AUTO to see
if that changes anything.  Here's output of strace touch FOO (from
inside my overlay mount) w/ yesterday's kernel and xino=off while I wait:

execve("/usr/bin/touch", ["touch", "FOO"], 0x7ffe51adb598 /* 22 vars */) = 0
brk(NULL)                               = 0x55bdf16c1000
access("/etc/ld.so.nohwcap", F_OK)      = -1 ENOENT (No such file or directory)
access("/etc/ld.so.preload", R_OK)      = -1 ENOENT (No such file or directory)
openat(AT_FDCWD, "/etc/ld.so.cache", O_RDONLY|O_CLOEXEC) = 3
fstat(3, {st_mode=S_IFREG|0644, st_size=180434, ...}) = 0
mmap(NULL, 180434, PROT_READ, MAP_PRIVATE, 3, 0) = 0x151ca6528000
close(3)                                = 0
access("/etc/ld.so.nohwcap", F_OK)      = -1 ENOENT (No such file or directory)
openat(AT_FDCWD, "/lib/x86_64-linux-gnu/libc.so.6", O_RDONLY|O_CLOEXEC) = 3
read(3, "\177ELF\2\1\1\3\0\0\0\0\0\0\0\0\3\0>\0\1\0\0\0\20\35\2\0\0\0\0\0"...,
832) = 832
fstat(3, {st_mode=S_IFREG|0755, st_size=2030928, ...}) = 0
mmap(NULL, 8192, PROT_READ|PROT_WRITE, MAP_PRIVATE|MAP_ANONYMOUS, -1,
0) = 0x151ca6526000
mmap(NULL, 4131552, PROT_READ|PROT_EXEC, MAP_PRIVATE|MAP_DENYWRITE, 3,
0) = 0x151ca5f3b000
mprotect(0x151ca6122000, 2097152, PROT_NONE) = 0
mmap(0x151ca6322000, 24576, PROT_READ|PROT_WRITE,
MAP_PRIVATE|MAP_FIXED|MAP_DENYWRITE, 3, 0x1e7000) = 0x151ca6322000
mmap(0x151ca6328000, 15072, PROT_READ|PROT_WRITE,
MAP_PRIVATE|MAP_FIXED|MAP_ANONYMOUS, -1, 0) = 0x151ca6328000
close(3)                                = 0
arch_prctl(ARCH_SET_FS, 0x151ca6527540) = 0
mprotect(0x151ca6322000, 16384, PROT_READ) = 0
mprotect(0x55bdf0214000, 4096, PROT_READ) = 0
mprotect(0x151ca6555000, 4096, PROT_READ) = 0
munmap(0x151ca6528000, 180434)          = 0
brk(NULL)                               = 0x55bdf16c1000
brk(0x55bdf16e2000)                     = 0x55bdf16e2000
openat(AT_FDCWD, "FOO", O_WRONLY|O_CREAT|O_NOCTTY|O_NONBLOCK, 0666) =
-1 ENODATA (No data available)
utimensat(AT_FDCWD, "FOO", NULL, 0)     = -1 ENODATA (No data available)
write(2, "touch: ", 7touch: )                  = 7
write(2, "cannot touch 'FOO'", 18cannot touch 'FOO')      = 18
write(2, ": No data available", 19: No data available)     = 19
write(2, "\n", 1
)                       = 1
close(1)                                = 0
close(2)                                = 0
exit_group(1)                           = ?
+++ exited with 1 +++


-- 
Michael D Labriola
21 Rip Van Winkle Cir
Warwick, RI 02886
401-316-9844 (cell)
