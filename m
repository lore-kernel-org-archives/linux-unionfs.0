Return-Path: <linux-unionfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 82B7CC433EF
	for <linux-unionfs@archiver.kernel.org>; Thu,  2 Dec 2021 07:07:30 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345413AbhLBHKv (ORCPT
        <rfc822;linux-unionfs@archiver.kernel.org>);
        Thu, 2 Dec 2021 02:10:51 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48010 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230521AbhLBHKu (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Thu, 2 Dec 2021 02:10:50 -0500
Received: from mail-vk1-xa2b.google.com (mail-vk1-xa2b.google.com [IPv6:2607:f8b0:4864:20::a2b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BC7F4C061574
        for <linux-unionfs@vger.kernel.org>; Wed,  1 Dec 2021 23:07:28 -0800 (PST)
Received: by mail-vk1-xa2b.google.com with SMTP id j1so17832233vkr.1
        for <linux-unionfs@vger.kernel.org>; Wed, 01 Dec 2021 23:07:28 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=nextdayvideo-com.20210112.gappssmtp.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to;
        bh=4XJjXcFv1jrw5EI7h70lAMcVT9BW6orRFh8oh8HgT+w=;
        b=TBP2cS5Ox+vouDOKw4utyt7otPnSxEFvtUZmYgjnRA7zCaWZpTdnlyuZeRQQhg/7T5
         xp9ydwDgifVHJ6M9LWHLEuqPyDsghUawieHUcgzOzsL+pPplponAn6hkpSYjGDcKFXnP
         JIAE4qQXqwt12o3xJi6YwvGQij8JZSuMcA6UUQHnlfiWbrKGBh2vKRH0PLCX7w3Qoc9n
         GGBqPWZYD5/gVGxSF871EhRXdb/ezWK5HoFF8iA3fXnlVQ8XqnnoS41NcLYDRFuFAn0v
         NdxjSlG4Dd6TZ13q8aVEnwPc8Ttrs6djkLHqqd4j70MByuh7NbDSqQfuQRbt2LGdxHe1
         GvsQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to;
        bh=4XJjXcFv1jrw5EI7h70lAMcVT9BW6orRFh8oh8HgT+w=;
        b=H0fGvVuKNOd8dfJCljAXSp7PaTN6Q79Ck93guL110r0T4BSNJ4XOvksBYK0b+sGuLK
         +t1gIjaXuHbLCF5ee1gp0L0Yd6S1KZj1KbBC4Nl+BRDGkrc5Fa77FaOrF6QHTge89cbV
         oaL12d5YD3fmz6JhhKGulL5LbG21QksBBBb/bsQmHSLiL1LcdA7KOSZJjsH40J1+rrQm
         QjOCRrAXbjWqCPiDgZYdlS9J+gbdrowm6qKYXy7EFMmXn/X0BIMdtIfx4o+RTpWrLa1V
         SwD4Y+N9TmBhNEbGJ5lOvufq5IEynNVpfFl2yrUGj0NfI8B2YxVnxDArAIMHbJSVdD1L
         Z1QA==
X-Gm-Message-State: AOAM5302UkCdm8SLwERiXdlzqwdtU5CX9/4mphOyXUfmgFPTgepfnXFh
        KkeTfn2liD/AFbKBW+oh59K9o9IfJQBSJpGHGXGb8JZkwXA=
X-Google-Smtp-Source: ABdhPJx2QhCNnj0yYaYnRVH/Lu1aJLmfySpaWoNAqch/ydNYH3Q7cFSVEtOzBA6469zJF0EMz08KoUxOJcU2sW7SKxw=
X-Received: by 2002:ac5:c93a:: with SMTP id u26mr14217838vkl.41.1638428846484;
 Wed, 01 Dec 2021 23:07:26 -0800 (PST)
MIME-Version: 1.0
References: <CADmzSSiE_XKnN3XaoP5HFV_3LOwOe9txCfbcEPAm-8B_9HkLRA@mail.gmail.com>
In-Reply-To: <CADmzSSiE_XKnN3XaoP5HFV_3LOwOe9txCfbcEPAm-8B_9HkLRA@mail.gmail.com>
From:   Carl Karsten <carl@nextdayvideo.com>
Date:   Wed, 1 Dec 2021 23:06:59 -0800
Message-ID: <CADmzSShngoD8xp4Ew1XkgP=inFvGwuxRaOKEs7TUQO3USuABew@mail.gmail.com>
Subject: Re: nfsd blocked
To:     overlayfs <linux-unionfs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-unionfs.vger.kernel.org>
X-Mailing-List: linux-unionfs@vger.kernel.org

strace

close(15)                               = 0
write(13, "\nStart-Date: 2021-12-02  06:56:5"..., 132) = 132
clone(child_stack=NULL,
flags=CLONE_CHILD_CLEARTID|CLONE_CHILD_SETTID|SIGCHLD,
child_tidptr=0xf72d90a8) = 901
wait4(901, [{WIFEXITED(s) && WEXITSTATUS(s) == 0}], 0, NULL) = 901
--- SIGCHLD {si_signo=SIGCHLD, si_code=CLD_EXITED, si_pid=901,
si_uid=0, si_status=0, si_utime=2, si_stime=2} ---
clone(child_stack=NULL,
flags=CLONE_CHILD_CLEARTID|CLONE_CHILD_SETTID|SIGCHLD,
child_tidptr=0xf72d90a8) = 902
wait4(902, [{WIFEXITED(s) && WEXITSTATUS(s) == 0}], 0, NULL) = 902
--- SIGCHLD {si_signo=SIGCHLD, si_code=CLD_EXITED, si_pid=902,
si_uid=0, si_status=0, si_utime=2, si_stime=1} ---
ioctl(0, TCGETS, {B38400 opost isig icanon echo ...}) = 0
openat(AT_FDCWD, "/dev/ptmx", O_RDWR|O_NOCTTY) = 15
statfs("/dev/pts", {f_type=DEVPTS_SUPER_MAGIC, f_bsize=4096,
f_blocks=0, f_bfree=0, f_bavail=0, f_files=0, f_ffree=0,
f_fsid={val=[0, 0]}, f_namelen=255, f_frsize=4096,
f_flags=ST_VALID|ST_NOSUID|ST_NOEXEC|ST_RELATIME}) = 0
ioctl(15, TIOCSPTLCK, [0])              = 0
ioctl(15, TCGETS, {B38400 opost isig icanon echo ...}) = 0
ioctl(15, TIOCGPTN, [1])                = 0
stat64("/dev/pts/1", {st_mode=S_IFCHR|0620, st_rdev=makedev(0x88,
0x1), ...}) = 0
ioctl(15, TCGETS, {B38400 opost isig icanon echo ...}) = 0
ioctl(15, TIOCGPTN, [1])                = 0
stat64("/dev/pts/1", {st_mode=S_IFCHR|0620, st_rdev=makedev(0x88,
0x1), ...}) = 0
getuid32()                              = 0
openat(AT_FDCWD, "/etc/group", O_RDONLY|O_CLOEXEC) = 16
_llseek(16, 0, [0], SEEK_CUR)           = 0
fstat64(16, {st_mode=S_IFREG|0644, st_size=762, ...}) = 0
read(16, "root:x:0:\ndaemon:x:1:\nbin:x:2:\ns"..., 4096) = 762
close(16)                               = 0
ioctl(0, TCGETS, {B38400 opost isig icanon echo ...}) = 0
ioctl(1, TCGETS, {B38400 opost isig icanon echo ...}) = 0
ioctl(1, TIOCGWINSZ, {ws_row=28, ws_col=110, ws_xpixel=0, ws_ypixel=0}) = 0
ioctl(15, TIOCSWINSZ, {ws_row=28, ws_col=110, ws_xpixel=0, ws_ypixel=0}) = 0
ioctl(15, TCGETS, {B38400 opost isig icanon echo ...}) = 0
ioctl(15, SNDCTL_TMR_START or TCSETS, {B38400 opost isig icanon echo ...}) = 0
ioctl(15, TCGETS, {B38400 opost isig icanon echo ...}) = 0
rt_sigprocmask(SIG_BLOCK, [TTOU], [], 8) = 0
ioctl(0, TCGETS, {B38400 opost isig icanon echo ...}) = 0
ioctl(0, SNDCTL_TMR_CONTINUE or TCSETSF, {B38400 -opost isig -icanon
-echo ...}) = 0
ioctl(0, TCGETS, {B38400 -opost isig -icanon -echo ...}) = 0
rt_sigprocmask(SIG_SETMASK, [], NULL, 8) = 0
openat(AT_FDCWD, "/dev/pts/1", O_RDWR|O_NOCTTY|O_LARGEFILE|O_CLOEXEC) = 16
ioctl(1, TIOCGWINSZ, {ws_row=28, ws_col=110, ws_xpixel=0, ws_ypixel=0}) = 0
write(1, "\n", 1)                       = 1
write(1, "\0337\33[0;27r\338\33[1A", 15) = 15
ioctl(15, TIOCGWINSZ, {ws_row=28, ws_col=110, ws_xpixel=0, ws_ypixel=0}) = 0
ioctl(15, TIOCSWINSZ, {ws_row=27, ws_col=110, ws_xpixel=0, ws_ypixel=0}) = 0
pipe([17, 18])                          = 0
rt_sigaction(SIGQUIT, {sa_handler=SIG_IGN, sa_mask=[QUIT],
sa_flags=SA_RESTORER|SA_RESTART, sa_restorer=0xf776cda0},
{sa_handler=SIG_DFL, sa_mask=[QUIT], sa_flags=SA_RESTORER|SA_RESTART,
sa_restorer=0xf776cda0}, 8) = 0
rt_sigaction(SIGINT, {sa_handler=0xf7b425fc, sa_mask=[INT],
sa_flags=SA_RESTORER|SA_RESTART, sa_restorer=0xf776cda0},
{sa_handler=SIG_DFL, sa_mask=[INT], sa_flags=SA_RESTORER|SA_RESTART,
sa_restorer=0xf776cda0}, 8) = 0
rt_sigaction(SIGHUP, {sa_handler=SIG_IGN, sa_mask=[HUP],
sa_flags=SA_RESTORER|SA_RESTART, sa_restorer=0xf776cda0},
{sa_handler=SIG_DFL, sa_mask=[], sa_flags=0}, 8) = 0
clone(child_stack=NULL,
flags=CLONE_CHILD_CLEARTID|CLONE_CHILD_SETTID|SIGCHLD,
child_tidptr=0xf72d90a8) = 903
close(18)                               = 0
rt_sigprocmask(SIG_BLOCK, [], [], 8)    = 0
wait4(903, 0xff9c6574, WNOHANG, NULL)   = 0
pselect6(18, [0 15 17], NULL, NULL, {tv_sec=0, tv_nsec=50000000}, {[],
8}) = 0 (Timeout)
wait4(903, 0xff9c6574, WNOHANG, NULL)   = 0
pselect6(18, [0 15 17], NULL, NULL, {tv_sec=0, tv_nsec=50000000}, {[],
8}) = 1 (in [17], left {tv_sec=0, tv_nsec=28968682})
read(17, "status: libfuse2:armhf: half-ins"..., 1024) = 39
ioctl(1, TIOCGWINSZ, {ws_row=28, ws_col=110, ws_xpixel=0, ws_ypixel=0}) = 0
write(1, "\0337\33[28;0f\33[42m\33[30mProgress: [ 5"..., 45) = 45
write(1, " [##############################"..., 92) = 92
write(1, "\338", 2)                     = 2
wait4(903, 0xff9c6574, WNOHANG, NULL)   = 0
pselect6(18, [0 15 17], NULL, NULL, {tv_sec=0, tv_nsec=50000000}, {[],
8}) = 1 (in [15], left {tv_sec=0, tv_nsec=30205081})
read(15, "(Reading database ... \r", 1024) = 23
write(1, "(Reading database ... \r", 23) = 23
write(5, "(Reading database ... \r", 23) = 23
wait4(903, 0xff9c6574, WNOHANG, NULL)   = 0
pselect6(18, [0 15 17], NULL, NULL, {tv_sec=0, tv_nsec=50000000}, {[],
8}) = 0 (Timeout)
wait4(903, 0xff9c6574, WNOHANG, NULL)   = 0
pselect6(18, [0 15 17], NULL, NULL, {tv_sec=0, tv_nsec=50000000}, {[],
8}) = 0 (Timeout)
wait4(903, 0xff9c6574, WNOHANG, NULL)   = 0
pselect6(18, [0 15 17], NULL, NULL, {tv_sec=0, tv_nsec=50000000}, {[],
8}) = 0 (Timeout)
wait4(903, 0xff9c6574, WNOHANG, NULL)   = 0
pselect6(18, [0 15 17], NULL, NULL, {tv_sec=0, tv_nsec=50000000}, {[],
8}) = 0 (Timeout)
wait4(903, 0xff9c6574, WNOHANG, NULL)   = 0
pselect6(18, [0 15 17], NULL, NULL, {tv_sec=0, tv_nsec=50000000}, {[],
8}) = 0 (Timeout)
wait4(903, 0xff9c6574, WNOHANG, NULL)   = 0
pselect6(18, [0 15 17], NULL, NULL, {tv_sec=0, tv_nsec=50000000}, {[],
8}) = 0 (Timeout)
wait4(903, 0xff9c6574, WNOHANG, NULL)   = 0
pselect6(18, [0 15 17], NULL, NULL, {tv_sec=0, tv_nsec=50000000}, {[],
8}) = 0 (Timeout)
wait4(903, 0xff9c6574, WNOHANG, NULL)   = 0
pselect6(18, [0 15 17], NULL, NULL, {tv_sec=0, tv_nsec=50000000}, {[],
8}) = 0 (Timeout)
wait4(903, 0xff9c6574, WNOHANG, NULL)   = 0
pselect6(18, [0 15 17], NULL, NULL, {tv_sec=0, tv_nsec=50000000}, {[],
8}) = 0 (Timeout)
wait4(903, 0xff9c6574, WNOHANG, NULL)   = 0
pselect6(18, [0 15 17], NULL, NULL, {tv_sec=0, tv_nsec=50000000}, {[],
8}) = 0 (Timeout)
wait4(903, 0xff9c6574, WNOHANG, NULL)   = 0
pselect6(18, [0 15 17], NULL, NULL, {tv_sec=0, tv_nsec=50000000}, {[],
8}) = 0 (Timeout)
wait4(903, 0xff9c6574, WNOHANG, NULL)   = 0
pselect6(18, [0 15 17], NULL, NULL, {tv_sec=0, tv_nsec=50000000}, {[],
8}) = 0 (Timeout)
wait4(903, 0xff9c6574, WNOHANG, NULL)   = 0
pselect6(18, [0 15 17], NULL, NULL, {tv_sec=0, tv_nsec=50000000}, {[],
8}) = 0 (Timeout)
wait4(903, 0xff9c6574, WNOHANG, NULL)   = 0
pselect6(18, [0 15 17], NULL, NULL, {tv_sec=0, tv_nsec=50000000}, {[],
8}) = 0 (Timeout)
wait4(903, 0xff9c6574, WNOHANG, NULL)   = 0
pselect6(18, [0 15 17], NULL, NULL, {tv_sec=0, tv_nsec=50000000}, {[],
8}) = 0 (Timeout)
wait4(903, 0xff9c6574, WNOHANG, NULL)   = 0
pselect6(18, [0 15 17], NULL, NULL, {tv_sec=0, tv_nsec=50000000}, {[],
8}) = 0 (Timeout)
wait4(903, 0xff9c6574, WNOHANG, NULL)   = 0
pselect6(18, [0 15 17], NULL, NULL, {tv_sec=0, tv_nsec=50000000}, {[],
8}) = 0 (Timeout)
wait4(903, 0xff9c6574, WNOHANG, NULL)   = 0
pselect6(18, [0 15 17], NULL, NULL, {tv_sec=0, tv_nsec=50000000}, {[],
8}) = 0 (Timeout)
wait4(903, 0xff9c6574, WNOHANG, NULL)   = 0
pselect6(18, [0 15 17], NULL, NULL, {tv_sec=0, tv_nsec=50000000}, {[],
8}) = 0 (Timeout)
wait4(903, 0xff9c6574, WNOHANG, NULL)   = 0
pselect6(18, [0 15 17], NULL, NULL, {tv_sec=0, tv_nsec=50000000}, {[],
8}) = 0 (Timeout)
wait4(903, 0xff9c6574, WNOHANG, NULL)   = 0
pselect6(18, [0 15 17], NULL, NULL, {tv_sec=0, tv_nsec=50000000}, {[],
8}) = 0 (Timeout)
wait4(903, 0xff9c6574, WNOHANG, NULL)   = 0
pselect6(18, [0 15 17], NULL, NULL, {tv_sec=0, tv_nsec=50000000}, {[],
8}) = 0 (Timeout)
wait4(903, 0xff9c6574, WNOHANG, NULL)   = 0
pselect6(18, [0 15 17], NULL, NULL, {tv_sec=0, tv_nsec=50000000}, {[],
8}) = 0 (Timeout)
wait4(903, 0xff9c6574, WNOHANG, NULL)   = 0
pselect6(18, [0 15 17], NULL, NULL, {tv_sec=0, tv_nsec=50000000}, {[],
8}) = 0 (Timeout)
wait4(903, 0xff9c6574, WNOHANG, NULL)   = 0
pselect6(18, [0 15 17], NULL, NULL, {tv_sec=0, tv_nsec=50000000}, {[],
8}) = 1 (in [15], left {tv_sec=0, tv_nsec=5882690})
read(15, "(Reading database ... 5%\r", 1024) = 25
write(1, "(Reading database ... 5%\r", 25) = 25
write(5, "(Reading database ... 5%\r", 25) = 25
wait4(903, 0xff9c6574, WNOHANG, NULL)   = 0
pselect6(18, [0 15 17], NULL, NULL, {tv_sec=0, tv_nsec=50000000}, {[],
8}) = 0 (Timeout)
wait4(903, 0xff9c6574, WNOHANG, NULL)   = 0
pselect6(18, [0 15 17], NULL, NULL, {tv_sec=0, tv_nsec=50000000}, {[],
8}) = 0 (Timeout)
wait4(903, 0xff9c6574, WNOHANG, NULL)   = 0
pselect6(18, [0 15 17], NULL, NULL, {tv_sec=0, tv_nsec=50000000}, {[],
8}) = 0 (Timeout)
wait4(903, 0xff9c6574, WNOHANG, NULL)   = 0
pselect6(18, [0 15 17], NULL, NULL, {tv_sec=0, tv_nsec=50000000}, {[],
8}) = 1 (in [15], left {tv_sec=0, tv_nsec=10230422})
read(15, "(Reading database ... 10%\r", 1024) = 26
write(1, "(Reading database ... 10%\r", 26) = 26
write(5, "(Reading database ... 10%\r", 26) = 26
wait4(903, 0xff9c6574, WNOHANG, NULL)   = 0
pselect6(18, [0 15 17], NULL, NULL, {tv_sec=0, tv_nsec=50000000}, {[],
8}) = 0 (Timeout)
wait4(903, 0xff9c6574, WNOHANG, NULL)   = 0
pselect6(18, [0 15 17], NULL, NULL, {tv_sec=0, tv_nsec=50000000}, {[],
8}) = 0 (Timeout)
wait4(903, 0xff9c6574, WNOHANG, NULL)   = 0
pselect6(18, [0 15 17], NULL, NULL, {tv_sec=0, tv_nsec=50000000}, {[],
8}) = 0 (Timeout)
wait4(903, 0xff9c6574, WNOHANG, NULL)   = 0
pselect6(18, [0 15 17], NULL, NULL, {tv_sec=0, tv_nsec=50000000}, {[],
8}) = 0 (Timeout)
wait4(903, 0xff9c6574, WNOHANG, NULL)   = 0
pselect6(18, [0 15 17], NULL, NULL, {tv_sec=0, tv_nsec=50000000}, {[],
8}) = 1 (in [15], left {tv_sec=0, tv_nsec=45862892})
read(15, "(Reading database ... 15%\r", 1024) = 26
write(1, "(Reading database ... 15%\r", 26) = 26
write(5, "(Reading database ... 15%\r", 26) = 26
wait4(903, 0xff9c6574, WNOHANG, NULL)   = 0
pselect6(18, [0 15 17], NULL, NULL, {tv_sec=0, tv_nsec=50000000}, {[],
8}) = 0 (Timeout)
wait4(903, 0xff9c6574, WNOHANG, NULL)   = 0
pselect6(18, [0 15 17], NULL, NULL, {tv_sec=0, tv_nsec=50000000}, {[],
8}) = 0 (Timeout)
wait4(903, 0xff9c6574, WNOHANG, NULL)   = 0
pselect6(18, [0 15 17], NULL, NULL, {tv_sec=0, tv_nsec=50000000}, {[],
8}) = 0 (Timeout)
wait4(903, 0xff9c6574, WNOHANG, NULL)   = 0
pselect6(18, [0 15 17], NULL, NULL, {tv_sec=0, tv_nsec=50000000}, {[],
8}) = 0 (Timeout)
wait4(903, 0xff9c6574, WNOHANG, NULL)   = 0
pselect6(18, [0 15 17], NULL, NULL, {tv_sec=0, tv_nsec=50000000}, {[],
8}) = 0 (Timeout)
wait4(903, 0xff9c6574, WNOHANG, NULL)   = 0
pselect6(18, [0 15 17], NULL, NULL, {tv_sec=0, tv_nsec=50000000}, {[],
8}) = 1 (in [15], left {tv_sec=0, tv_nsec=30138674})
read(15, "(Reading database ... 20%\r", 1024) = 26
write(1, "(Reading database ... 20%\r", 26) = 26
write(5, "(Reading database ... 20%\r", 26) = 26
wait4(903, 0xff9c6574, WNOHANG, NULL)   = 0
pselect6(18, [0 15 17], NULL, NULL, {tv_sec=0, tv_nsec=50000000}, {[],
8}) = 0 (Timeout)
wait4(903, 0xff9c6574, WNOHANG, NULL)   = 0
pselect6(18, [0 15 17], NULL, NULL, {tv_sec=0, tv_nsec=50000000}, {[],
8}) = 0 (Timeout)
wait4(903, 0xff9c6574, WNOHANG, NULL)   = 0
pselect6(18, [0 15 17], NULL, NULL, {tv_sec=0, tv_nsec=50000000}, {[],
8}) = 0 (Timeout)
wait4(903, 0xff9c6574, WNOHANG, NULL)   = 0
pselect6(18, [0 15 17], NULL, NULL, {tv_sec=0, tv_nsec=50000000}, {[],
8}) = 1 (in [15], left {tv_sec=0, tv_nsec=10269380})
read(15, "(Reading database ... 25%\r", 1024) = 26
write(1, "(Reading database ... 25%\r", 26) = 26
write(5, "(Reading database ... 25%\r", 26) = 26
wait4(903, 0xff9c6574, WNOHANG, NULL)   = 0
pselect6(18, [0 15 17], NULL, NULL, {tv_sec=0, tv_nsec=50000000}, {[],
8}) = 0 (Timeout)
wait4(903, 0xff9c6574, WNOHANG, NULL)   = 0
pselect6(18, [0 15 17], NULL, NULL, {tv_sec=0, tv_nsec=50000000}, {[],
8}) = 0 (Timeout)
wait4(903, 0xff9c6574, WNOHANG, NULL)   = 0
pselect6(18, [0 15 17], NULL, NULL, {tv_sec=0, tv_nsec=50000000}, {[],
8}) = 0 (Timeout)
wait4(903, 0xff9c6574, WNOHANG, NULL)   = 0
pselect6(18, [0 15 17], NULL, NULL, {tv_sec=0, tv_nsec=50000000}, {[],
8}) = 1 (in [15], left {tv_sec=0, tv_nsec=5309987})
read(15, "(Reading database ... 30%\r", 1024) = 26
write(1, "(Reading database ... 30%\r", 26) = 26
write(5, "(Reading database ... 30%\r", 26) = 26
wait4(903, 0xff9c6574, WNOHANG, NULL)   = 0
pselect6(18, [0 15 17], NULL, NULL, {tv_sec=0, tv_nsec=50000000}, {[],
8}) = 0 (Timeout)
wait4(903, 0xff9c6574, WNOHANG, NULL)   = 0
pselect6(18, [0 15 17], NULL, NULL, {tv_sec=0, tv_nsec=50000000}, {[],
8}) = 0 (Timeout)
wait4(903, 0xff9c6574, WNOHANG, NULL)   = 0
pselect6(18, [0 15 17], NULL, NULL, {tv_sec=0, tv_nsec=50000000}, {[],
8}) = 0 (Timeout)
wait4(903, 0xff9c6574, WNOHANG, NULL)   = 0
pselect6(18, [0 15 17], NULL, NULL, {tv_sec=0, tv_nsec=50000000}, {[],
8}) = 1 (in [15], left {tv_sec=0, tv_nsec=2216674})
read(15, "(Reading database ... 35%\r", 1024) = 26
write(1, "(Reading database ... 35%\r", 26) = 26
write(5, "(Reading database ... 35%\r", 26) = 26
wait4(903, 0xff9c6574, WNOHANG, NULL)   = 0
pselect6(18, [0 15 17], NULL, NULL, {tv_sec=0, tv_nsec=50000000}, {[],
8}) = 0 (Timeout)
wait4(903, 0xff9c6574, WNOHANG, NULL)   = 0
pselect6(18, [0 15 17], NULL, NULL, {tv_sec=0, tv_nsec=50000000}, {[],
8}) = 0 (Timeout)
wait4(903, 0xff9c6574, WNOHANG, NULL)   = 0
pselect6(18, [0 15 17], NULL, NULL, {tv_sec=0, tv_nsec=50000000}, {[],
8}) = 0 (Timeout)
wait4(903, 0xff9c6574, WNOHANG, NULL)   = 0
pselect6(18, [0 15 17], NULL, NULL, {tv_sec=0, tv_nsec=50000000}, {[],
8}) = 1 (in [15], left {tv_sec=0, tv_nsec=8630745})
read(15, "(Reading database ... 40%\r", 1024) = 26
write(1, "(Reading database ... 40%\r", 26) = 26
write(5, "(Reading database ... 40%\r", 26) = 26
wait4(903, 0xff9c6574, WNOHANG, NULL)   = 0
pselect6(18, [0 15 17], NULL, NULL, {tv_sec=0, tv_nsec=50000000}, {[],
8}) = 0 (Timeout)
wait4(903, 0xff9c6574, WNOHANG, NULL)   = 0
pselect6(18, [0 15 17], NULL, NULL, {tv_sec=0, tv_nsec=50000000}, {[],
8}) = 0 (Timeout)
wait4(903, 0xff9c6574, WNOHANG, NULL)   = 0
pselect6(18, [0 15 17], NULL, NULL, {tv_sec=0, tv_nsec=50000000}, {[],
8}) = 1 (in [15], left {tv_sec=0, tv_nsec=12330669})
read(15, "(Reading database ... 45%\r", 1024) = 26
write(1, "(Reading database ... 45%\r", 26) = 26
write(5, "(Reading database ... 45%\r", 26) = 26
wait4(903, 0xff9c6574, WNOHANG, NULL)   = 0
pselect6(18, [0 15 17], NULL, NULL, {tv_sec=0, tv_nsec=50000000}, {[],
8}) = 1 (in [15], left {tv_sec=0, tv_nsec=49975053})
read(15, "(Reading database ... 50%\r(Readi"..., 1024) = 360
write(1, "(Reading database ... 50%\r(Readi"..., 360) = 360
write(5, "(Reading database ... 50%\r(Readi"..., 360) = 360
wait4(903, 0xff9c6574, WNOHANG, NULL)   = 0
pselect6(18, [0 15 17], NULL, NULL, {tv_sec=0, tv_nsec=50000000}, {[],
8}) = 1 (in [15], left {tv_sec=0, tv_nsec=38900960})
read(15, "Removing libfuse2:armhf (2.9.9-5"..., 1024) = 39
write(1, "Removing libfuse2:armhf (2.9.9-5"..., 39) = 39
write(5, "Removing libfuse2:armhf (2.9.9-5"..., 39) = 39
wait4(903, 0xff9c6574, WNOHANG, NULL)   = 0
pselect6(18, [0 15 17], NULL, NULL, {tv_sec=0, tv_nsec=50000000}, {[],
8}) = 1 (in [17], left {tv_sec=0, tv_nsec=49974896})
read(17, "processing: remove: libfuse2:arm"..., 1024) = 35
wait4(903, 0xff9c6574, WNOHANG, NULL)   = 0
pselect6(18, [0 15 17], NULL, NULL, {tv_sec=0, tv_nsec=50000000}, {[],
8}) = 1 (in [17], left {tv_sec=0, tv_nsec=42313593})
read(17, "status: libc-bin: triggers-pendi"..., 1024) = 35
wait4(903, 0xff9c6574, WNOHANG, NULL)   = 0
pselect6(18, [0 15 17], NULL, NULL, {tv_sec=0, tv_nsec=50000000}, {[],
8}) = 0 (Timeout)
wait4(903, 0xff9c6574, WNOHANG, NULL)   = 0
pselect6(18, [0 15 17], NULL, NULL, {tv_sec=0, tv_nsec=50000000}, {[],
8}) = 0 (Timeout)
wait4(903, 0xff9c6574, WNOHANG, NULL)   = 0
pselect6(18, [0 15 17], NULL, NULL, {tv_sec=0, tv_nsec=50000000}, {[],
8}) = 0 (Timeout)
wait4(903, 0xff9c6574, WNOHANG, NULL)   = 0

On Wed, Dec 1, 2021 at 6:56 PM Carl Karsten <carl@nextdayvideo.com> wrote:
>
> there is overlayfs in the middle of the stack dump, so I think this is
> the place to post.   happy to post it somewhere else if directed.
>
> currently very reproducible - 3 times in a row, rebooting both clent
> and server between.
>
> tt may be related to me setting nfsvers=3. I plan on testing this
> guess, but it may be a while. hours or maybe a day or 2.
>
> I tried to pin down the file operation client side, but that hasn't
> happened yet either.
>
> client and server Details:
>
> server: raspberry pi v3,
> pi@rpi-cb-1f-f7:~$ uname -a
> Linux rpi-cb-1f-f7 5.10.63-v7+ #1488 SMP Thu Nov 18 16:14:44 GMT 2021
> armv7l GNU/Linux
>
> pi@rpi-cb-1f-f7:~$ cat /etc/exports
> /srv/nfs/rpi/bullseye/root/merged
> *(rw,sync,no_subtree_check,no_root_squash,fsid=2)
>
> pi@rpi-cb-1f-f7:~$ findmnt /srv/nfs/rpi/bullseye/root/merged | cat
> TARGET                            SOURCE  FSTYPE  OPTIONS
> /srv/nfs/rpi/bullseye/root/merged overlay overlay
> rw,relatime,lowerdir=/srv/nfs/rpi/bullseye/root/setup:/srv/nfs/rpi/bullseye/root/base,upperdir=/srv/nfs/rpi/bullseye/root/updates,workdir=/srv/nfs/rpi/bullseye/root/work,index=on,nfs_export=on
>
> pi@rpi-cb-1f-f7:~$ findmnt  /
> TARGET SOURCE         FSTYPE OPTIONS
> /      /dev/mmcblk0p2 ext4   rw,noatime
>
> client: also a pi:
> pi@raspberrypi:~ $ uname -a
> Linux raspberrypi 5.10.63-v8+ #1488 SMP PREEMPT Thu Nov 18 16:16:16
> GMT 2021 aarch64 GNU/Linux
>
> root@raspberrypi:~# cat /etc/fstab
> # proc            /proc           proc    defaults          0       0
> 10.21.0.1:/srv/nfs/rpi/bullseye/root/merged / nfs defaults,auto,rw,nfsvers=3 0 0
>
> root@raspberrypi:~# findmnt /|cat
> /      10.21.0.1:/srv/nfs/rpi/bullseye/root/merged nfs
> rw,relatime,vers=3,rsize=4096,wsize=4096,namlen=255,hard,nolock,proto=tcp,timeo=600,retrans=2,sec=sys,mountaddr=10.21.0.1,mountvers=3,mountproto=tcp,local_lock=all,addr=10.21.0.1
>
> on the client, I run
> apt autoremove --assume-yes
>
>
>
>
> [ 1103.834869] INFO: task nfsd:1029 blocked for more than 122 seconds.
> [ 1103.834889]       Tainted: G         C        5.10.63-v7+ #1488
> [ 1103.834901] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs"
> disables this message.
> [ 1103.834915] task:nfsd            state:D stack:    0 pid: 1029
> ppid:     2 flags:0x00000000
> [ 1103.834945] Backtrace:
> [ 1103.834992] [<809f9df0>] (__schedule) from [<809fa7c8>] (schedule+0x68/0xe4)
> [ 1103.835015]  r10:00000000 r9:86f67d4c r8:8fc134a0 r7:00000002
> r6:00000001 r5:86dc4d80
> [ 1103.835029]  r4:ffffe000
> [ 1103.835056] [<809fa760>] (schedule) from [<8017bcac>]
> (rwsem_down_write_slowpath+0x318/0x518)
> [ 1103.835072]  r5:ffffe000 r4:8fc13490
> [ 1103.835094] [<8017b994>] (rwsem_down_write_slowpath) from
> [<809fd700>] (down_write+0x6c/0x70)
> [ 1103.835116]  r10:7f0f2df4 r9:00000000 r8:8c696bb0 r7:82ba73d0
> r6:85d00600 r5:8fc13490
> [ 1103.835129]  r4:8fc13490
> [ 1103.835195] [<809fd694>] (down_write) from [<7f6676b8>]
> (ovl_dir_release+0x34/0x70 [overlay])
> [ 1103.835211]  r5:8fc13490 r4:96d1eb80
> [ 1103.835267] [<7f667684>] (ovl_dir_release [overlay]) from
> [<803359f0>] (__fput+0x90/0x25c)
> [ 1103.835286]  r7:82ba73d0 r6:000a841d r5:8fc13408 r4:85d00600
> [ 1103.835307] [<80335960>] (__fput) from [<80335c24>] (delayed_fput+0x4c/0x58)
> [ 1103.835328]  r9:8fc13408 r8:00000122 r7:00000100 r6:80f05008
> r5:86f67e34 r4:85d00180
> [ 1103.835348] [<80335bd8>] (delayed_fput) from [<80335c4c>]
> (flush_delayed_fput+0x1c/0x20)
> [ 1103.835363]  r5:86f67e34 r4:00000001
> [ 1103.835570] [<80335c30>] (flush_delayed_fput) from [<7f0c7ec4>]
> (nfsd_file_close_inode_sync+0x180/0x188 [nfsd])
> [ 1103.835916] [<7f0c7d44>] (nfsd_file_close_inode_sync [nfsd]) from
> [<7f0c065c>] (nfsd_unlink+0x230/0x270 [nfsd])
> [ 1103.835938]  r8:ffffc000 r7:92419068 r6:86f44000 r5:937dd3b8 r4:86fa0008
> [ 1103.836285] [<7f0c042c>] (nfsd_unlink [nfsd]) from [<7f0ca3f4>]
> (nfsd3_proc_remove+0x80/0xd8 [nfsd])
> [ 1103.836308]  r9:00000018 r8:96dd5000 r7:86f44000 r6:86fa0008
> r5:86fa0000 r4:86f38000
> [ 1103.836650] [<7f0ca374>] (nfsd3_proc_remove [nfsd]) from
> [<7f0b973c>] (nfsd_dispatch+0xc8/0x14c [nfsd])
> [ 1103.836669]  r7:96dd5014 r6:7f0f2df4 r5:86f45000 r4:86f44000
> [ 1103.836856] [<7f0b9674>] (nfsd_dispatch [nfsd]) from [<809ca22c>]
> (svc_process_common+0x374/0x70c)
> [ 1103.836878]  r9:86f45000 r8:86f45a20 r7:86f44000 r6:80f05008
> r5:00000014 r4:86f44184
> [ 1103.836901] [<809c9eb8>] (svc_process_common) from [<809ca69c>]
> (svc_process+0xd8/0xec)
> [ 1103.836923]  r10:856abcfc r9:86f44000 r8:81016540 r7:7f100bc4
> r6:816cae00 r5:bab24000
> [ 1103.836937]  r4:86f44000
> [ 1103.837120] [<809ca5c4>] (svc_process) from [<7f0b9100>]
> (nfsd+0xf4/0x164 [nfsd])
> [ 1103.837135]  r5:00057e40 r4:86f44000
> [ 1103.837321] [<7f0b900c>] (nfsd [nfsd]) from [<80143790>]
> (kthread+0x170/0x174)
> [ 1103.837342]  r9:86f44000 r8:7f0b900c r7:86f66000 r6:00000000
> r5:892b9580 r4:847acbc0
> [ 1103.837364] [<80143620>] (kthread) from [<801000ec>]
> (ret_from_fork+0x14/0x28)
> [ 1103.837378] Exception stack(0x86f67fb0 to 0x86f67ff8)
> [ 1103.837396] 7fa0:                                     00000000
> 00000000 00000000 00000000
> [ 1103.837415] 7fc0: 00000000 00000000 00000000 00000000 00000000
> 00000000 00000000 00000000
> [ 1103.837434] 7fe0: 00000000 00000000 00000000 00000000 00000013 00000000
> [ 1103.837454]  r10:00000000 r9:00000000 r8:00000000 r7:00000000
> r6:00000000 r5:80143620
> [ 1103.837467]  r4:892b9580
>
>
> --
> Carl K



-- 
Carl K
