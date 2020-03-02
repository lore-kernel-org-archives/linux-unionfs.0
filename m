Return-Path: <SRS0=C54B=4T=vger.kernel.org=linux-unionfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,
	SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CCE94C3F2D2
	for <linux-unionfs@archiver.kernel.org>; Mon,  2 Mar 2020 11:10:59 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 9EEE52083E
	for <linux-unionfs@archiver.kernel.org>; Mon,  2 Mar 2020 11:10:59 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="pPzJCl6w"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726661AbgCBLK7 (ORCPT
        <rfc822;linux-unionfs@archiver.kernel.org>);
        Mon, 2 Mar 2020 06:10:59 -0500
Received: from mail-io1-f68.google.com ([209.85.166.68]:33507 "EHLO
        mail-io1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725996AbgCBLK7 (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Mon, 2 Mar 2020 06:10:59 -0500
Received: by mail-io1-f68.google.com with SMTP id r15so2417432iog.0;
        Mon, 02 Mar 2020 03:10:58 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=JhiTjN0sACMySdn78HZVXBgamsKxhlPehaOxgnQ+L7Q=;
        b=pPzJCl6wVC5Zl4M2LfkBEgulsd8mEv3CvMmybE8h+4hsbw6I1OayQsoJxvLQy/iSlJ
         kllbqLB+tJhcJ1pwltLmSm0Eu5OirH6VbpC0mizrMSsCuum2z1+vQNA0/eDIJruoHweN
         SbEKHJ9ZCqFyouluqyNcDQL6jZB5s5sb9G2XjevhW2Becv88LLMUp7ahKiAfItuKYaDY
         P9dhLlqqocvavBjHoIfVYiadHfPacmI0fJ0K2p7K/GFunEiWXB1YPygaMUd+dHOV0/Rq
         fjixuSpyrrrETI0bmiN20rkSeoyk3ilta6vQvX8s09cNc+j2L6LndGWcrdCpE+hve0ya
         OKBA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=JhiTjN0sACMySdn78HZVXBgamsKxhlPehaOxgnQ+L7Q=;
        b=j6S+EFYH1XQOHdvLSO3d5z+OBZcCEWkAexGfEoPs/KZpuXEVUM/XWw99sNYzPMYgQI
         HiCHAIIfiCliXSgkDWhJPkbXitvhE8S0ANmON2s4KmXBynQ+kMuItCysMeHgEGVNebGY
         w1raWxfm0EjtUNR2/Dk/ewEN2QguxQyok34ChyZZ59rNylV6nDlNzHDABKdrOZ4KLIz3
         AGB5G5VX8nDXq7XXJUbpDYaGWIkxf+PB8Uc7QCkHQDW0tEo4/wg8jEOis636OgupviAd
         QKc+4VMFs6CrZCNF/OQwQqoHjBhDQHuWAzD3wn6MOeMwA8H07gJfpGFOS/TEFmr39Guu
         /uXQ==
X-Gm-Message-State: APjAAAU76zYin7Arfp+VVAWX0lOv0bZ7B5jflzBIGtNyehQQmWp9bOA+
        tEyZeAHyo85WlW2hMVuLUcoxlwcObxAXE6oyr0Jm581x
X-Google-Smtp-Source: APXvYqz7QRebIfXeyoWy8dd3F7xvNfK1oerNMKeGKQcKIIbfdBJnNm+eRBLpBk2bmkG5Zt4zbaBgKfxIiMfNMB7C1Nk=
X-Received: by 2002:a02:7656:: with SMTP id z83mr13409880jab.81.1583147458564;
 Mon, 02 Mar 2020 03:10:58 -0800 (PST)
MIME-Version: 1.0
References: <000000000000d3e319059fcfdc98@google.com>
In-Reply-To: <000000000000d3e319059fcfdc98@google.com>
From:   Amir Goldstein <amir73il@gmail.com>
Date:   Mon, 2 Mar 2020 13:10:47 +0200
Message-ID: <CAOQ4uxh=tLw1p8vsbzTTqrTzLSqr33WtVHek+Jhbi5C2HKQLTA@mail.gmail.com>
Subject: Re: WARNING: bad unlock balance in ovl_llseek
To:     syzbot <syzbot+66a9752fa927f745385e@syzkaller.appspotmail.com>,
        Dmitry Vyukov <dvyukov@google.com>
Cc:     linux-kernel <linux-kernel@vger.kernel.org>,
        overlayfs <linux-unionfs@vger.kernel.org>,
        Miklos Szeredi <miklos@szeredi.hu>,
        Miklos Szeredi <mszeredi@redhat.com>,
        syzkaller-bugs <syzkaller-bugs@googlegroups.com>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-unionfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-unionfs.vger.kernel.org>
X-Mailing-List: linux-unionfs@vger.kernel.org

On Sun, Mar 1, 2020 at 9:13 PM syzbot
<syzbot+66a9752fa927f745385e@syzkaller.appspotmail.com> wrote:
>
> Hello,
>
> syzbot found the following crash on:
>
> HEAD commit:    f8788d86 Linux 5.6-rc3
> git tree:       upstream
> console output: https://syzkaller.appspot.com/x/log.txt?x=13c5f8f9e00000
> kernel config:  https://syzkaller.appspot.com/x/.config?x=5d2e033af114153f
> dashboard link: https://syzkaller.appspot.com/bug?extid=66a9752fa927f745385e
> compiler:       clang version 10.0.0 (https://github.com/llvm/llvm-project/ c2443155a0fb245c8f17f2c1c72b6ea391e86e81)
> syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=131d9a81e00000
> C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=14117a81e00000
>

Dmitry,

There is something strange about the C repro.
It passes an invalid address for the first arg of mount syscall:

    syscall(__NR_mount, 0x400000ul, 0x20000000ul, 0x20000080ul, 0ul,
            0x20000100ul);

With this address mount syscall returns -EFAULT on my system.
I fixed this manually, but repro did not trigger the reported bug on my system.

> The bug was bisected to:
>
> commit b1f9d3858f724ed45b279b689fb5b400d91352e3
> Author: Amir Goldstein <amir73il@gmail.com>
> Date:   Sat Dec 21 09:42:29 2019 +0000
>
>     ovl: use ovl_inode_lock in ovl_llseek()
>
> bisection log:  https://syzkaller.appspot.com/x/bisect.txt?x=16ff3bede00000
> final crash:    https://syzkaller.appspot.com/x/report.txt?x=15ff3bede00000
> console output: https://syzkaller.appspot.com/x/log.txt?x=11ff3bede00000
>
> IMPORTANT: if you fix the bug, please add the following tag to the commit:
> Reported-by: syzbot+66a9752fa927f745385e@syzkaller.appspotmail.com
> Fixes: b1f9d3858f72 ("ovl: use ovl_inode_lock in ovl_llseek()")
>
> =====================================
> WARNING: bad unlock balance detected!
> 5.6.0-rc3-syzkaller #0 Not tainted
> -------------------------------------
> syz-executor194/8947 is trying to release lock (&ovl_i_lock_key[depth]) at:
> [<ffffffff828b7835>] ovl_inode_unlock fs/overlayfs/overlayfs.h:328 [inline]
> [<ffffffff828b7835>] ovl_llseek+0x215/0x2c0 fs/overlayfs/file.c:193
> but there are no more locks to release!
>

This is strange. I don't see how that can happen nor how my change would
have caused this regression. If anything, the lock chance may have brought
a bug in stack file ops to light, but don't see the bug.

The repro is multi-threaded but when I ran the repro, a single thread did:
- open lower file (pre copy up)
- lchown file (copy up)
- llseek the open file (so llseek is on a temporary ovl_open_realfile())

Perhaps when bug was triggered ops above were executed by different
threads?

Dmitry, I may have asked this before - how hard would it be to attach an
strace of the repro to a bug report?

Thanks,
Amir.
