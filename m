Return-Path: <SRS0=C54B=4T=vger.kernel.org=linux-unionfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,
	SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D1B69C3F2D2
	for <linux-unionfs@archiver.kernel.org>; Mon,  2 Mar 2020 12:10:50 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 9D49B20656
	for <linux-unionfs@archiver.kernel.org>; Mon,  2 Mar 2020 12:10:50 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="mSDFqCyL"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727669AbgCBMKu (ORCPT
        <rfc822;linux-unionfs@archiver.kernel.org>);
        Mon, 2 Mar 2020 07:10:50 -0500
Received: from mail-io1-f65.google.com ([209.85.166.65]:37520 "EHLO
        mail-io1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726773AbgCBMKu (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Mon, 2 Mar 2020 07:10:50 -0500
Received: by mail-io1-f65.google.com with SMTP id c17so11234297ioc.4;
        Mon, 02 Mar 2020 04:10:48 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=Fg8CGDKXOGLLoGGvqfqqeD6aZ8g66qpYFJ5EHOq2wds=;
        b=mSDFqCyLC3wcWDEKiseaJAhKDh2u34xcICvotR7FzhuoS1ze+CzsROn4+3lZSFhFHS
         HftMcgbnmMNk5GFnAc+Ie1+TRl1XQQGEfhkWs+0v/xk8ASW4xW6A3dAD2KsD95ozpmE0
         CgaLNdxk22QIkDTxo4llrYgZvez195e2FYmw+VRL/4Nm30Fc7YGZArH01NmTXSbiR97y
         j3UDmePdiZtahPGw9+q+a8gKzPDKV90iXuvU1Zk3U2UmuBs27LxodGxicrNj4qWnoWpn
         9HAGEH8lZ7d4Trg49o0Z8rG288Uk2vZ3Yij/ug5V0a8SjZ/swCmu/RxwqXrdM0MmXQ7x
         LTxQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=Fg8CGDKXOGLLoGGvqfqqeD6aZ8g66qpYFJ5EHOq2wds=;
        b=PcYOuT8xtzEbJi8+kLjy/qa47wpMIi8OQ2ryPdfCS0iQ1PWk3TI6DE12SoYTIE8s6j
         pAHtrs5CnEYfznIHg9KOgpmI54g87WXMkJfUpBewjqBLAdkDK7raiPRdBWFBJyc78m+f
         9aB2DxNU5RgyDxP8TPPSc1R1Y4lAcLXF59SKjv/gUaCbCq3JwyjNthPhac7pJkOHwm0f
         uVRJECZetR2qWQuj4iF0GmoRMforcYpFMeG1DEsyJFxgazt0c6LXwVIHVIO5nLiMRqOW
         19joi7xSsVJjv9dMv5Os4MZf+p56Pgz7BRVHb4hflxxq8OgU40I8BC1Sq/b5eV57SxMc
         rKHw==
X-Gm-Message-State: APjAAAW7QDD+77YBKZVnmwZXOywlkGCW0fkOuo01cVWABik8wMLgJFaj
        l7k93oTWJBvaoqDV95OcCgHRe3xNdbb5LRhVtzk=
X-Google-Smtp-Source: APXvYqzc/LalXVaqrNCguatgtteYnTuRPcyk16CTg+vbh+b8kuMvYbIWjiAJvkfjN25Y2D81QpITqnoLJUov6KSXC9E=
X-Received: by 2002:a5e:8507:: with SMTP id i7mr6642777ioj.9.1583151048170;
 Mon, 02 Mar 2020 04:10:48 -0800 (PST)
MIME-Version: 1.0
References: <000000000000d3e319059fcfdc98@google.com> <CAOQ4uxh=tLw1p8vsbzTTqrTzLSqr33WtVHek+Jhbi5C2HKQLTA@mail.gmail.com>
 <CACT4Y+YBOm-VeHXuRnk4mLgwsEMx2MYrOnQ-FJpBjg5dDU_YzQ@mail.gmail.com>
In-Reply-To: <CACT4Y+YBOm-VeHXuRnk4mLgwsEMx2MYrOnQ-FJpBjg5dDU_YzQ@mail.gmail.com>
From:   Amir Goldstein <amir73il@gmail.com>
Date:   Mon, 2 Mar 2020 14:10:36 +0200
Message-ID: <CAOQ4uxh=3XWOfKAJMeJBrsfouLEDo3oqTNoYBMZ2f46mVRigvA@mail.gmail.com>
Subject: Re: WARNING: bad unlock balance in ovl_llseek
To:     Dmitry Vyukov <dvyukov@google.com>
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

On Mon, Mar 2, 2020 at 1:29 PM Dmitry Vyukov <dvyukov@google.com> wrote:
>
> On Mon, Mar 2, 2020 at 12:10 PM Amir Goldstein <amir73il@gmail.com> wrote:
> >
> > On Sun, Mar 1, 2020 at 9:13 PM syzbot
> > <syzbot+66a9752fa927f745385e@syzkaller.appspotmail.com> wrote:
> > >
> > > Hello,
> > >
> > > syzbot found the following crash on:
> > >
> > > HEAD commit:    f8788d86 Linux 5.6-rc3
> > > git tree:       upstream
> > > console output: https://syzkaller.appspot.com/x/log.txt?x=13c5f8f9e00000
> > > kernel config:  https://syzkaller.appspot.com/x/.config?x=5d2e033af114153f
> > > dashboard link: https://syzkaller.appspot.com/bug?extid=66a9752fa927f745385e
> > > compiler:       clang version 10.0.0 (https://github.com/llvm/llvm-project/ c2443155a0fb245c8f17f2c1c72b6ea391e86e81)
> > > syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=131d9a81e00000
> > > C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=14117a81e00000
> > >
> >
> > Dmitry,
> >
> > There is something strange about the C repro.
> > It passes an invalid address for the first arg of mount syscall:
> >
> >     syscall(__NR_mount, 0x400000ul, 0x20000000ul, 0x20000080ul, 0ul,
> >             0x20000100ul);
> >
> > With this address mount syscall returns -EFAULT on my system.
> > I fixed this manually, but repro did not trigger the reported bug on my system.
>
> Hi Amir,
>
> This is not strange in the context of fuzzer, it's goal is to pass
> random data. Generally if it says 0x400000ul, that's what it is, don't
> fix it, or you are running a different program that may not reproduce
> the bug. If syzbot attaches a reproducer, the bug was triggered by
> precisely this program.
>

What's strange it that a bug in overlay code cannot be triggered if overlay
isn't mounted and as it is the repro couldn't mount overlayfs at all, at
lease with my kernel config.
The bounds check that causes mount failure is in vfs code, not in
overlayfs code,
so not sure what exactly went on there.


> The reason why it passes non-pointers here is we think the src
> argument of overlay mount is unused:
> https://github.com/google/syzkaller/blob/4a4e0509de520c7139ca2b5606712cbadc550db2/sys/linux/filesystem.txt#L12
> If it's not true, it needs to be fixed (or almost all overlay mounts
> fail with EFAULT during fuzzing).
>
>
> > > The bug was bisected to:
> > >
> > > commit b1f9d3858f724ed45b279b689fb5b400d91352e3
> > > Author: Amir Goldstein <amir73il@gmail.com>
> > > Date:   Sat Dec 21 09:42:29 2019 +0000
> > >
> > >     ovl: use ovl_inode_lock in ovl_llseek()
> > >
> > > bisection log:  https://syzkaller.appspot.com/x/bisect.txt?x=16ff3bede00000
> > > final crash:    https://syzkaller.appspot.com/x/report.txt?x=15ff3bede00000
> > > console output: https://syzkaller.appspot.com/x/log.txt?x=11ff3bede00000
> > >
> > > IMPORTANT: if you fix the bug, please add the following tag to the commit:
> > > Reported-by: syzbot+66a9752fa927f745385e@syzkaller.appspotmail.com
> > > Fixes: b1f9d3858f72 ("ovl: use ovl_inode_lock in ovl_llseek()")
> > >
> > > =====================================
> > > WARNING: bad unlock balance detected!
> > > 5.6.0-rc3-syzkaller #0 Not tainted
> > > -------------------------------------
> > > syz-executor194/8947 is trying to release lock (&ovl_i_lock_key[depth]) at:
> > > [<ffffffff828b7835>] ovl_inode_unlock fs/overlayfs/overlayfs.h:328 [inline]
> > > [<ffffffff828b7835>] ovl_llseek+0x215/0x2c0 fs/overlayfs/file.c:193
> > > but there are no more locks to release!
> > >
> >
> > This is strange. I don't see how that can happen nor how my change would
> > have caused this regression. If anything, the lock chance may have brought
> > a bug in stack file ops to light, but don't see the bug.
> >
> > The repro is multi-threaded but when I ran the repro, a single thread did:
> > - open lower file (pre copy up)
> > - lchown file (copy up)
> > - llseek the open file (so llseek is on a temporary ovl_open_realfile())
> >
> > Perhaps when bug was triggered ops above were executed by different
> > threads?
>
> Perfectly possible.
>
> > Dmitry, I may have asked this before - how hard would it be to attach an
> > strace of the repro to a bug report?
>
> This is tracked in https://github.com/google/syzkaller/issues/197 but
> no progress so far.
> What exactly were the main pain points in this case? But note that
> strace is not atomic with actual execution, so it may lead you down
> even worse rabbit hole...

Sure, but it can add more insight for analysis.

Thanks,
Amir.
