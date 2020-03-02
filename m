Return-Path: <SRS0=C54B=4T=vger.kernel.org=linux-unionfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.4 required=3.0 tests=DKIMWL_WL_MED,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS,USER_IN_DEF_DKIM_WL autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E527EC3F2D1
	for <linux-unionfs@archiver.kernel.org>; Mon,  2 Mar 2020 11:29:56 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id BBFD821D56
	for <linux-unionfs@archiver.kernel.org>; Mon,  2 Mar 2020 11:29:56 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="Sazxwk4o"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727027AbgCBL3y (ORCPT
        <rfc822;linux-unionfs@archiver.kernel.org>);
        Mon, 2 Mar 2020 06:29:54 -0500
Received: from mail-qk1-f193.google.com ([209.85.222.193]:41426 "EHLO
        mail-qk1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726470AbgCBL3y (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Mon, 2 Mar 2020 06:29:54 -0500
Received: by mail-qk1-f193.google.com with SMTP id b5so9584588qkh.8
        for <linux-unionfs@vger.kernel.org>; Mon, 02 Mar 2020 03:29:53 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=h0Fuv3v/Qpfe7SqDVP/B7XBJ3fTGbrxdPJa80K2tHaI=;
        b=Sazxwk4oSdJXcL6gVo+VQCHI1bZZzad9P2BpI0a567CcOw8uHu6FGoU5FmFIjRIs1j
         jszO10ynRnrcbC1zmg6noV1N/C6oewlnt8ahlmMyxcRX3hdA5nSYxiNVyv+cEwuSd1qM
         SPfESMs33MMYlLSJWnQ51+CevBgTlzoke11tgZJFbQdmieiKDYXB+3VgFoxPL95o+8aN
         DFZr7pUauaw2YU13h8IsfFQcJou7qu64h+0F0gV7DcoUkGE7M5Q7sdpOdjgzllIbT8aX
         N/49GJ3gow2Ix83dy+3nA9iaSC6nwZMgNbWE3oTrPAEO2n+Hr3SYP49HmVnAoCgmxQ63
         IW3A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=h0Fuv3v/Qpfe7SqDVP/B7XBJ3fTGbrxdPJa80K2tHaI=;
        b=n/cHNBP7eSDzfPP7yd41pWvibmLIRt/df0ldR2REEbHS2fcUNxcdCZKw6BxBj2gpvA
         RwXMI17zcDhmP35IY4+YI57+lRqsR/Ww2FnI2EVou68O/dWzc31q3CWBI5b9yUDlgJ03
         UImJUjfLdZBUhit98kRNmwI+rgE+gJLZnGnQOWPPqAvodRUnZ2MXK48x82dTHMSmYo9E
         dloMDy54JDvH1J/9hCDTVr9wXWM7ta3gdiS2pDtBGjLbJF7PvouY+RdsntKON6zOrLrN
         LjHoDBNbvb/PHxQn0olYi+pPA2TuQ+mG3FDTCHRgQzCUnfNZzWiDFbKAOOANOZxzFFrZ
         A+iw==
X-Gm-Message-State: APjAAAVt4BlBliVGCj/HIZAE5eaaIQyLXeYVRxnMQUXKMroOzfFe2idH
        X8fm0OstXaxE5YeUvpli3qLV/4O/oQ09kVi9ItGk1w==
X-Google-Smtp-Source: APXvYqx2MDaR51I9fDjR+lnrTLZO5+C0iQ8iSMhMTRigSri8CSF4mFnpRIVFZCte1EqYN2MBVvi/HLgqJhWi/AYYTio=
X-Received: by 2002:ae9:e003:: with SMTP id m3mr16126112qkk.250.1583148592977;
 Mon, 02 Mar 2020 03:29:52 -0800 (PST)
MIME-Version: 1.0
References: <000000000000d3e319059fcfdc98@google.com> <CAOQ4uxh=tLw1p8vsbzTTqrTzLSqr33WtVHek+Jhbi5C2HKQLTA@mail.gmail.com>
In-Reply-To: <CAOQ4uxh=tLw1p8vsbzTTqrTzLSqr33WtVHek+Jhbi5C2HKQLTA@mail.gmail.com>
From:   Dmitry Vyukov <dvyukov@google.com>
Date:   Mon, 2 Mar 2020 12:29:41 +0100
Message-ID: <CACT4Y+YBOm-VeHXuRnk4mLgwsEMx2MYrOnQ-FJpBjg5dDU_YzQ@mail.gmail.com>
Subject: Re: WARNING: bad unlock balance in ovl_llseek
To:     Amir Goldstein <amir73il@gmail.com>
Cc:     syzbot <syzbot+66a9752fa927f745385e@syzkaller.appspotmail.com>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        overlayfs <linux-unionfs@vger.kernel.org>,
        Miklos Szeredi <miklos@szeredi.hu>,
        Miklos Szeredi <mszeredi@redhat.com>,
        syzkaller-bugs <syzkaller-bugs@googlegroups.com>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-unionfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-unionfs.vger.kernel.org>
X-Mailing-List: linux-unionfs@vger.kernel.org

On Mon, Mar 2, 2020 at 12:10 PM Amir Goldstein <amir73il@gmail.com> wrote:
>
> On Sun, Mar 1, 2020 at 9:13 PM syzbot
> <syzbot+66a9752fa927f745385e@syzkaller.appspotmail.com> wrote:
> >
> > Hello,
> >
> > syzbot found the following crash on:
> >
> > HEAD commit:    f8788d86 Linux 5.6-rc3
> > git tree:       upstream
> > console output: https://syzkaller.appspot.com/x/log.txt?x=13c5f8f9e00000
> > kernel config:  https://syzkaller.appspot.com/x/.config?x=5d2e033af114153f
> > dashboard link: https://syzkaller.appspot.com/bug?extid=66a9752fa927f745385e
> > compiler:       clang version 10.0.0 (https://github.com/llvm/llvm-project/ c2443155a0fb245c8f17f2c1c72b6ea391e86e81)
> > syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=131d9a81e00000
> > C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=14117a81e00000
> >
>
> Dmitry,
>
> There is something strange about the C repro.
> It passes an invalid address for the first arg of mount syscall:
>
>     syscall(__NR_mount, 0x400000ul, 0x20000000ul, 0x20000080ul, 0ul,
>             0x20000100ul);
>
> With this address mount syscall returns -EFAULT on my system.
> I fixed this manually, but repro did not trigger the reported bug on my system.

Hi Amir,

This is not strange in the context of fuzzer, it's goal is to pass
random data. Generally if it says 0x400000ul, that's what it is, don't
fix it, or you are running a different program that may not reproduce
the bug. If syzbot attaches a reproducer, the bug was triggered by
precisely this program.

The reason why it passes non-pointers here is we think the src
argument of overlay mount is unused:
https://github.com/google/syzkaller/blob/4a4e0509de520c7139ca2b5606712cbadc550db2/sys/linux/filesystem.txt#L12
If it's not true, it needs to be fixed (or almost all overlay mounts
fail with EFAULT during fuzzing).


> > The bug was bisected to:
> >
> > commit b1f9d3858f724ed45b279b689fb5b400d91352e3
> > Author: Amir Goldstein <amir73il@gmail.com>
> > Date:   Sat Dec 21 09:42:29 2019 +0000
> >
> >     ovl: use ovl_inode_lock in ovl_llseek()
> >
> > bisection log:  https://syzkaller.appspot.com/x/bisect.txt?x=16ff3bede00000
> > final crash:    https://syzkaller.appspot.com/x/report.txt?x=15ff3bede00000
> > console output: https://syzkaller.appspot.com/x/log.txt?x=11ff3bede00000
> >
> > IMPORTANT: if you fix the bug, please add the following tag to the commit:
> > Reported-by: syzbot+66a9752fa927f745385e@syzkaller.appspotmail.com
> > Fixes: b1f9d3858f72 ("ovl: use ovl_inode_lock in ovl_llseek()")
> >
> > =====================================
> > WARNING: bad unlock balance detected!
> > 5.6.0-rc3-syzkaller #0 Not tainted
> > -------------------------------------
> > syz-executor194/8947 is trying to release lock (&ovl_i_lock_key[depth]) at:
> > [<ffffffff828b7835>] ovl_inode_unlock fs/overlayfs/overlayfs.h:328 [inline]
> > [<ffffffff828b7835>] ovl_llseek+0x215/0x2c0 fs/overlayfs/file.c:193
> > but there are no more locks to release!
> >
>
> This is strange. I don't see how that can happen nor how my change would
> have caused this regression. If anything, the lock chance may have brought
> a bug in stack file ops to light, but don't see the bug.
>
> The repro is multi-threaded but when I ran the repro, a single thread did:
> - open lower file (pre copy up)
> - lchown file (copy up)
> - llseek the open file (so llseek is on a temporary ovl_open_realfile())
>
> Perhaps when bug was triggered ops above were executed by different
> threads?

Perfectly possible.

> Dmitry, I may have asked this before - how hard would it be to attach an
> strace of the repro to a bug report?

This is tracked in https://github.com/google/syzkaller/issues/197 but
no progress so far.
What exactly were the main pain points in this case? But note that
strace is not atomic with actual execution, so it may lead you down
even worse rabbit hole...
