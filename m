Return-Path: <SRS0=PFgV=7F=vger.kernel.org=linux-unionfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.6 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5B449C433E0
	for <linux-unionfs@archiver.kernel.org>; Sat, 23 May 2020 09:17:23 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 2E6272071C
	for <linux-unionfs@archiver.kernel.org>; Sat, 23 May 2020 09:17:23 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="kkA+8MDP"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387687AbgEWJRW (ORCPT
        <rfc822;linux-unionfs@archiver.kernel.org>);
        Sat, 23 May 2020 05:17:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59082 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2387498AbgEWJRW (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Sat, 23 May 2020 05:17:22 -0400
Received: from mail-il1-x144.google.com (mail-il1-x144.google.com [IPv6:2607:f8b0:4864:20::144])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 53071C061A0E;
        Sat, 23 May 2020 02:17:22 -0700 (PDT)
Received: by mail-il1-x144.google.com with SMTP id y17so10999423ilg.0;
        Sat, 23 May 2020 02:17:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=2bunXetlqNv3VWmi6iXlq+r+zkRK9hb4sDb55CH5nkE=;
        b=kkA+8MDP/4JNt7e1HoFyXXbNrq/h2365y4TE0/ERNcc/a0pOqbRB+MlhzjDG/2Zhq1
         BuPlHDRey3ClJI3UGcPHV2ZC2MfcqqIpOwjRMQgzSSx6CDLOQ4qG6qi7nAvT/xdys07z
         zooU6TEDqavqqVDcSGbR9voWbnXbJw4jKphciBz9yrGJMklnLnmOxirVVxB4WQp6Xvdv
         6k94NoIMmAbRTngvDDS9e1PVriE32PgvXQ5S5bZH+wfSawxuItc5bm+tHNgIgglUGujX
         YWsk2ioTfeklBd3cIPQGYHnACEN4we5StQQ4G+hP5vNp1bNnICCKu9Kz41wHj0+2/3dr
         vF+g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=2bunXetlqNv3VWmi6iXlq+r+zkRK9hb4sDb55CH5nkE=;
        b=OvucS0jXQj06/X9whYSpC4pMXHqytp1XlR0xR0Pm6FcvuvydgRzjvdcT2zwreOqJc1
         rhOn3CCNI8r+zM6OksAx4lu54CNNWAJ4xH5MoZOrn38UB6dnl0Y9YcY11YGr/Lm9jlnA
         7d1vvuq/N0XjcTbLFmLBtfhBcQrzMxognJgQj/zxqoDrZP7Q95prqR2GgWsfOYd5CPw+
         7DDSfjWdPZsxuNRicUFeRFS0GyxHjv4wX+Wji4A1tWVw6E/OWMZiK7Cw6YwQoAg/XWAk
         TvAtZYoaClnWfmuy+vLspDY/ORE9llChS34Y4OGalwA2HMcA2hMgDPhSYeJtXw6xWRRU
         XpYg==
X-Gm-Message-State: AOAM533gDbNiLefdMT/qisPnnSCl9FCc/uwkBfJFZu/ZOp1ga00AF4lL
        yuDN/jGB8KpXA0nrHlsdLLVwlXK9cgbLs1fPiJ0=
X-Google-Smtp-Source: ABdhPJxSuW6pu3VjUNa1vbP1KEtcsqgA5WE0QGdkzLAtAetE1zKjaefUEpjil3JCKns2YrSbcmNXsT5LV+doUJ6kQmA=
X-Received: by 2002:a92:99cf:: with SMTP id t76mr17315667ilk.9.1590225441683;
 Sat, 23 May 2020 02:17:21 -0700 (PDT)
MIME-Version: 1.0
References: <0000000000005fd9aa05a6441365@google.com>
In-Reply-To: <0000000000005fd9aa05a6441365@google.com>
From:   Amir Goldstein <amir73il@gmail.com>
Date:   Sat, 23 May 2020 12:17:10 +0300
Message-ID: <CAOQ4uxh2+fhAdpyu4JB93MGB9wV0ztExc6cWBZnhfLmozk8Fag@mail.gmail.com>
Subject: Re: KASAN: slab-out-of-bounds Read in ovl_check_fb_len
To:     syzbot <syzbot+61958888b1c60361a791@syzkaller.appspotmail.com>
Cc:     linux-kernel <linux-kernel@vger.kernel.org>,
        overlayfs <linux-unionfs@vger.kernel.org>,
        Miklos Szeredi <miklos@szeredi.hu>,
        Miklos Szeredi <mszeredi@redhat.com>,
        syzkaller-bugs <syzkaller-bugs@googlegroups.com>,
        Dan Carpenter <dan.carpenter@oracle.com>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-unionfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-unionfs.vger.kernel.org>
X-Mailing-List: linux-unionfs@vger.kernel.org

On Sat, May 23, 2020 at 1:23 AM syzbot
<syzbot+61958888b1c60361a791@syzkaller.appspotmail.com> wrote:
>
> Hello,
>
> syzbot found the following crash on:
>
> HEAD commit:    b85051e7 Merge tag 'fixes-for-5.7-rc6' of git://git.kernel..
> git tree:       upstream
> console output: https://syzkaller.appspot.com/x/log.txt?x=165d2b81100000
> kernel config:  https://syzkaller.appspot.com/x/.config?x=b3368ce0cc5f5ace
> dashboard link: https://syzkaller.appspot.com/bug?extid=61958888b1c60361a791
> compiler:       gcc (GCC) 9.0.0 20181231 (experimental)
> syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=168e6272100000
>
> The bug was bisected to:
>
> commit cbe7fba8edfc8cb8e621599e376f8ac5c224fa72
> Author: Amir Goldstein <amir73il@gmail.com>
> Date:   Fri Nov 15 11:33:03 2019 +0000
>
>     ovl: make sure that real fid is 32bit aligned in memory
>
> bisection log:  https://syzkaller.appspot.com/x/bisect.txt?x=11f95922100000
> final crash:    https://syzkaller.appspot.com/x/report.txt?x=13f95922100000
> console output: https://syzkaller.appspot.com/x/log.txt?x=15f95922100000
>
> IMPORTANT: if you fix the bug, please add the following tag to the commit:
> Reported-by: syzbot+61958888b1c60361a791@syzkaller.appspotmail.com
> Fixes: cbe7fba8edfc ("ovl: make sure that real fid is 32bit aligned in memory")
>
> ==================================================================
> BUG: KASAN: slab-out-of-bounds in ovl_check_fb_len+0x171/0x1a0 fs/overlayfs/namei.c:89
> Read of size 1 at addr ffff88809727834d by task syz-executor.4/8488
>
> CPU: 0 PID: 8488 Comm: syz-executor.4 Not tainted 5.7.0-rc6-syzkaller #0
> Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
> Call Trace:
>  __dump_stack lib/dump_stack.c:77 [inline]
>  dump_stack+0x188/0x20d lib/dump_stack.c:118
>  print_address_description.constprop.0.cold+0xd3/0x413 mm/kasan/report.c:382
>  __kasan_report.cold+0x20/0x38 mm/kasan/report.c:511
>  kasan_report+0x33/0x50 mm/kasan/common.c:625
>  ovl_check_fb_len+0x171/0x1a0 fs/overlayfs/namei.c:89
>  ovl_check_fh_len fs/overlayfs/overlayfs.h:358 [inline]
>  ovl_fh_to_dentry+0x1ab/0x814 fs/overlayfs/export.c:812
>  exportfs_decode_fh+0x11f/0x717 fs/exportfs/expfs.c:434
>
>

repro crafts a file handle
{ .handle_bytes = 2, .handle_type = OVL_FILEID_V1 }

handle_bytes gets rounded to 0, so we call
ovl_check_fh_len(f_handle, 0) => ovl_check_fb_len(f_handle + 3, -3)

I guess compiler may be evaluating the 2nd condition before the first:
        if (fb_len < sizeof(struct ovl_fb) || fb_len < fb->len)

Silly thing is that Dan's patch that was just merged fixes a crash with:
{ .handle_bytes = 2, .handle_type = OVL_FILEID_V0 }
The original patch that he sent would have caught this case as well,
but I gave it a bad review comment, because I was too confident
about ovl_check_fh_len()'s safety.

But now I see that we also need to fix:
{ .handle_bytes = 4, .handle_type = OVL_FILEID_V0 }
which wasn't covered even with the original fix patch.

Let's try this fix:

#syz test: https://github.com/amir73il/linux.git ovl-fixes

Thanks,
Amir.
