Return-Path: <linux-unionfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 64460C433B4
	for <linux-unionfs@archiver.kernel.org>; Thu, 15 Apr 2021 17:09:38 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 43FEC6109D
	for <linux-unionfs@archiver.kernel.org>; Thu, 15 Apr 2021 17:09:38 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233587AbhDORKA (ORCPT
        <rfc822;linux-unionfs@archiver.kernel.org>);
        Thu, 15 Apr 2021 13:10:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45738 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233074AbhDORJ6 (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Thu, 15 Apr 2021 13:09:58 -0400
Received: from mail-io1-xd29.google.com (mail-io1-xd29.google.com [IPv6:2607:f8b0:4864:20::d29])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A3BF2C061574
        for <linux-unionfs@vger.kernel.org>; Thu, 15 Apr 2021 10:09:35 -0700 (PDT)
Received: by mail-io1-xd29.google.com with SMTP id d5so15514021iof.3
        for <linux-unionfs@vger.kernel.org>; Thu, 15 Apr 2021 10:09:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=12eq7+NJYwQarAv9pEFi9qfkOce8f7aSAYU1muwi6Tw=;
        b=nkasqoJZjY3FITtbZT06wVcF+b3iOkAMXwdLM1Xdwqs8cCSJ0WnfxN9037lKs3zx3B
         9Pg6V7j0OUuSdO/0O6eGGq6U4LwDYG7cls3MtGLtfL1ckxdP9MlQS1++hm3EI+NYTS8z
         jiobaVn40SNaO4Ef5s/S9eLi/nc3uiwjvDPvmmwdaWb2lzUbKFE1dRuoQNsa3JH12ANI
         G89W6Y1ZzOFxG9zbZ+74j9OfBrvfoW48ctXFPUvUWdQRRkXGMGAQ3skOON0LLykCDlxK
         LeWjQzFqY6PcWdqbW5Etwyjt5ZNh9TY3s3xkxyUy8b+4A8Ot3K4ZiWUKmG9jqxsuMenB
         tK5w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=12eq7+NJYwQarAv9pEFi9qfkOce8f7aSAYU1muwi6Tw=;
        b=AQn+13NqS9TUsSX0E62z3nbHdVMf+mAkAXE2tRtrVj+paWHbOhx0rXpXV63ALdu/S9
         0BuN6g/pcD3MhRK9zNGyxISlXycRFzvxBEu2YmzecSxCzBYjofKXr40BwkE68k0XnNd6
         d4bPjMAY+VbhtA7LgrXft64K07wEq8bT311NtXkMKhjdH7eq3BYKLFhvGfWLuIjLCmP4
         7rV+R0Bx9TGGtbpo02y0Mm0NzE1KOS9Cz/ZxK/FQjsJ4RMZhJl32FzecbjPlRHJihiV7
         wutmSZDy5oJPvedAzBirr0nOxpe4WRaU9ySNelztr8YjpF41iItBrOyDYjxTpI9yt5gN
         NW+Q==
X-Gm-Message-State: AOAM530BpgBxxuMiPcBqQfE1pXt/JScjulETP3T9ZmeVB1l6FIYn1nM1
        2Ouzzs58hPu4i+Q9PGy/4iD5kmwpvXfPAjIx6K8=
X-Google-Smtp-Source: ABdhPJy6bjRzu+GfWU89bvaWsITNENKE0q5sP1jkTgPbFdWimulQR0+5dhE+JjGeQu9LRTlEageL5uuTaiyT9k7Yj/E=
X-Received: by 2002:a02:7a53:: with SMTP id z19mr279560jad.120.1618506575121;
 Thu, 15 Apr 2021 10:09:35 -0700 (PDT)
MIME-Version: 1.0
References: <6312af55.47e2.178d53227d0.Coremail.ouyangxuan10@163.com>
In-Reply-To: <6312af55.47e2.178d53227d0.Coremail.ouyangxuan10@163.com>
From:   Amir Goldstein <amir73il@gmail.com>
Date:   Thu, 15 Apr 2021 20:09:23 +0300
Message-ID: <CAOQ4uxgPq9E9xxwU2CDyHy-_yCZZeymg+3n+-6AqkGGE1YtwvQ@mail.gmail.com>
Subject: Re: [kernel]:overlayfs: invalid origin (root/bmcweb_persistent_data.json,
 ftype=8000, origin ftype=4000)
To:     www <ouyangxuan10@163.com>
Cc:     Kevin Locke <kevin@kevinlocke.name>,
        Miklos Szeredi <miklos@szeredi.hu>,
        overlayfs <linux-unionfs@vger.kernel.org>,
        kernelnewbies@kernelnewbies.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-unionfs.vger.kernel.org>
X-Mailing-List: linux-unionfs@vger.kernel.org

On Thu, Apr 15, 2021 at 2:03 PM www <ouyangxuan10@163.com> wrote:
>
> Dear Amir, kevin, miklos,
>
> An open source project uses overlay filesystem and systemd. when the system first time boot, there is an error in the file system:
> kernel: overlayfs: invalid origin (root/bmcweb_persistent_data.json, ftype=8000, origin ftype=4000)
>
> What's the reason for this? Can you give some help and suggestions to solve this problem?
>
> The details are as follows:
> 1. linux kernel version:
> root@N/A:~# uname -a Linux N/A 5.1.5-yocto-s-dirty-1605363 #1 Tue Apr 13 01:13:48 UTC 2021 armv6l GNU/Linux
>
> 2. mount command
> mount -t overlay -o lowerdir=$rodir,upperdir=$upper,workdir=$work cow /root
> (rodir=run/initramfs/ro, upper=run/initramfs/rw/cow, work=rwdir=run/initramfs/rw/work)
>
> 3. mountinfo
> root@N/A:~# cat /proc/self/mountinfo
> 13 21 0:6 / /dev rw,relatime shared:8 - devtmpfs dev rw,size=220800k,nr_inodes=55200,mode=755
> 14 21 0:13 / /sys rw,relatime shared:3 - sysfs sys rw
> 15 21 0:4 / /proc rw,relatime shared:2 - proc proc rw
> 16 21 0:14 / /run rw,nosuid,nodev shared:11 - tmpfs tmpfs rw,mode=755
> 17 16 7:0 / /run/initramfs/ro ro,relatime shared:12 - squashfs /dev/loop0 ro
> 18 16 31:5 / /run/initramfs/rw rw,relatime shared:13 - jffs2 /dev/mtdblock5 rw
> 21 0 0:15 / / rw,relatime shared:1 - overlay cow rw,lowerdir=run/initramfs/ro,upperdir=run/initramfs/rw/cow,workdir=run/initramfs/rw/work
> 22 13 0:17 / /dev/shm rw,nosuid,nodev shared:9 - tmpfs tmpfs rw
> 23 13 0:18 / /dev/pts rw,relatime shared:10 - devpts devpts rw,gid=5,mode=620,ptmxmode=000
> 24 14 0:19 / /sys/fs/cgroup ro,nosuid,nodev,noexec shared:4 - tmpfs tmpfs ro,mode=755
> 25 24 0:20 / /sys/fs/cgroup/unified rw,nosuid,nodev,noexec,relatime shared:5 - cgroup2 cgroup2 rw,nsdelegate
> 26 24 0:21 / /sys/fs/cgroup/systemd rw,nosuid,nodev,noexec,relatime shared:6 - cgroup cgroup rw,xattr,name=systemd
> 27 14 0:22 / /sys/fs/bpf rw,nosuid,nodev,noexec,relatime shared:7 - bpf bpf rw,mode=700
> 28 14 0:7 / /sys/kernel/debug rw,nosuid,nodev,noexec,relatime shared:14 - debugfs debugfs rw
> 29 14 0:12 / /sys/kernel/config rw,nosuid,nodev,noexec,relatime shared:15 - configfs configfs rw
> 30 21 0:23 / /tmp rw,nosuid,nodev shared:16 - tmpfs tmpfs rw
> 31 21 0:24 / /var/volatile rw,relatime shared:17 - tmpfs tmpfs rw
>
> 4. xino_auto
>
> 5. file in ro is correct
> 6. file in rw is correct
> 7. but the file in overlayfs is  incorrect
>
> What's the reason for this?

I suppose lower squashfs was recreated and mounted with an existing
upper dir that already contains upper files with origin references to the
old squashfs lower fs.

> Can you give some help and suggestions to solve this problem?

Cherry-pick this fix to your kernel:
a888db310195 ovl: fix regression with re-formatted lower squashfs

OR as a workaround, build the lower squashfs with the "-no-exports"
mksquashfs option.

Thanks,
Amir.
