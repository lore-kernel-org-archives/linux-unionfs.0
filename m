Return-Path: <SRS0=C54B=4T=vger.kernel.org=linux-unionfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.4 required=3.0 tests=DKIMWL_WL_MED,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS,USER_IN_DEF_DKIM_WL
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B9D8DC3F2CD
	for <linux-unionfs@archiver.kernel.org>; Mon,  2 Mar 2020 14:58:01 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 84AF421775
	for <linux-unionfs@archiver.kernel.org>; Mon,  2 Mar 2020 14:58:01 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="lw190SWS"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727189AbgCBO56 (ORCPT
        <rfc822;linux-unionfs@archiver.kernel.org>);
        Mon, 2 Mar 2020 09:57:58 -0500
Received: from mail-qt1-f193.google.com ([209.85.160.193]:42597 "EHLO
        mail-qt1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727113AbgCBO56 (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Mon, 2 Mar 2020 09:57:58 -0500
Received: by mail-qt1-f193.google.com with SMTP id r6so85058qtt.9
        for <linux-unionfs@vger.kernel.org>; Mon, 02 Mar 2020 06:57:57 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=+12d+baUufNFOtbrxNu5ULU097qWdzx/LbKAvXyts3U=;
        b=lw190SWS7FliZNcCsP+XIdcY2cyYcgRI0ZRukiujnC6dTpTnP4vV1Sm5wGbvWsp/u1
         OZIf+bFbEC3q1cdOsEYyPa9K31kRYKo/S+ewl4Zn+LE4J+hcXUaqM9Kvf89YP8qo2fMJ
         9zJBRoWfo6DV65sRXeHGtBHjwkkw5XOvKLdCPX+hhciJIDx91yGIyMoQGu6bwNxNTkYC
         bM7qypwcg6DbSnxjdsrFRcyj8NrS4m4S2baXfPx3sth0nF44dP0HQUx8MEc6et4Ws3hF
         CUbStSHXhHtgP6wIChBQvj21zxjuSoXPVs0SGbmA719F0qalW7SFqdlWjknTK5GUmslT
         7gtA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=+12d+baUufNFOtbrxNu5ULU097qWdzx/LbKAvXyts3U=;
        b=e9wvMhuhKA7OjyBbYrN7FqurCSlot+GFidvSJfW/w/negwxv9eNd9NK1kGEcLxLf+C
         nDzvzvXzxJfpKESI7SCVpPoG3EyH/2ygp7NusuSr/MT+FOPbaL4+AlvDcNV3Z1w9qMbC
         nmeOMQoC9xOW5cQpr+Uj/4yVV8vdUZvTtYyQq4VmpdnOW+eM42/VnTshcxpi1ZmPLl8t
         KpGlm5cV652brF/sBIoupSJ/AHa1FhMezLxJqoZgREVOyIAGDlYuiEocv5ZvD7ec0Mv1
         /ejf71+4sE7Dt/SAQDZXRQDzlm54ZpCdQwKHdGgLY/xqRTnAMfG9eWKMPKZHqwfYdN5c
         0kqg==
X-Gm-Message-State: ANhLgQ1E6U/MIIKlub9Woj7ha2Ty32ZBJKbEGGQrt0leeJzz0mGYIo53
        zZK/Le5tkKat77x1Z+quLDxKnrWoOwJ8i48UXPn61Cu4/Sw=
X-Google-Smtp-Source: ADFU+vvHUfuEA9ylWlnKnGddo0NndbQ4T3nsIGDA6Bpx8s8V2RQBxfMvslGiRm9FSYSvhz65ffakJrj1hBMP+wTgrAc=
X-Received: by 2002:ac8:1846:: with SMTP id n6mr76025qtk.257.1583161076404;
 Mon, 02 Mar 2020 06:57:56 -0800 (PST)
MIME-Version: 1.0
References: <000000000000d3e319059fcfdc98@google.com> <CAOQ4uxh=tLw1p8vsbzTTqrTzLSqr33WtVHek+Jhbi5C2HKQLTA@mail.gmail.com>
 <CACT4Y+YBOm-VeHXuRnk4mLgwsEMx2MYrOnQ-FJpBjg5dDU_YzQ@mail.gmail.com>
 <CAOQ4uxh=3XWOfKAJMeJBrsfouLEDo3oqTNoYBMZ2f46mVRigvA@mail.gmail.com>
 <CACT4Y+aBvofv8AQqiWr7M77FODSUqruMMoVcHHA5ROfv5VN7tw@mail.gmail.com> <CAOQ4uxhTAR0-evX0DHdvF9BhHwgC8dU-532FyUiSCqcfujfiKA@mail.gmail.com>
In-Reply-To: <CAOQ4uxhTAR0-evX0DHdvF9BhHwgC8dU-532FyUiSCqcfujfiKA@mail.gmail.com>
From:   Dmitry Vyukov <dvyukov@google.com>
Date:   Mon, 2 Mar 2020 15:57:45 +0100
Message-ID: <CACT4Y+bLxavqe7e1+P7YXRdTaRCMePb_JMDGEjPkUkNNxdzcKg@mail.gmail.com>
Subject: Re: WARNING: bad unlock balance in ovl_llseek
To:     Amir Goldstein <amir73il@gmail.com>
Cc:     syzbot <syzbot+66a9752fa927f745385e@syzkaller.appspotmail.com>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        overlayfs <linux-unionfs@vger.kernel.org>,
        Miklos Szeredi <miklos@szeredi.hu>,
        Miklos Szeredi <mszeredi@redhat.com>,
        syzkaller-bugs <syzkaller-bugs@googlegroups.com>,
        syzkaller <syzkaller@googlegroups.com>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-unionfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-unionfs.vger.kernel.org>
X-Mailing-List: linux-unionfs@vger.kernel.org

On Mon, Mar 2, 2020 at 2:24 PM Amir Goldstein <amir73il@gmail.com> wrote:
> > > > > On Sun, Mar 1, 2020 at 9:13 PM syzbot
> > > > > <syzbot+66a9752fa927f745385e@syzkaller.appspotmail.com> wrote:
> > > > > >
> > > > > > Hello,
> > > > > >
> > > > > > syzbot found the following crash on:
> > > > > >
> > > > > > HEAD commit:    f8788d86 Linux 5.6-rc3
> > > > > > git tree:       upstream
> > > > > > console output: https://syzkaller.appspot.com/x/log.txt?x=13c5f8f9e00000
> > > > > > kernel config:  https://syzkaller.appspot.com/x/.config?x=5d2e033af114153f
> > > > > > dashboard link: https://syzkaller.appspot.com/bug?extid=66a9752fa927f745385e
> > > > > > compiler:       clang version 10.0.0 (https://github.com/llvm/llvm-project/ c2443155a0fb245c8f17f2c1c72b6ea391e86e81)
> > > > > > syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=131d9a81e00000
> > > > > > C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=14117a81e00000
> > > > > >
> > > > >
> > > > > Dmitry,
> > > > >
> > > > > There is something strange about the C repro.
> > > > > It passes an invalid address for the first arg of mount syscall:
> > > > >
> > > > >     syscall(__NR_mount, 0x400000ul, 0x20000000ul, 0x20000080ul, 0ul,
> > > > >             0x20000100ul);
> > > > >
> > > > > With this address mount syscall returns -EFAULT on my system.
> > > > > I fixed this manually, but repro did not trigger the reported bug on my system.
> > > >
> > > > Hi Amir,
> > > >
> > > > This is not strange in the context of fuzzer, it's goal is to pass
> > > > random data. Generally if it says 0x400000ul, that's what it is, don't
> > > > fix it, or you are running a different program that may not reproduce
> > > > the bug. If syzbot attaches a reproducer, the bug was triggered by
> > > > precisely this program.
> > > >
> > >
> > > What's strange it that a bug in overlay code cannot be triggered if overlay
> > > isn't mounted and as it is the repro couldn't mount overlayfs at all, at
> > > lease with my kernel config.
> >
> > Can it depend on kernel config? The bug was triggered by the program
> > provided somehow.
>
> I am not sure. I do not have CONFIG_HARDENED_USERCOPY set.
>
> >
> > Separate question: why is it failing? Isn't src unused for overlayfs?
> > Where/how does vfs code look at src?
> >
>
> SYSCALL_DEFINE5(mount, ...
> copy_mount_string(dev_name)
> strndup_user()
> memdup_user()
> copy_from_user()
>
> Not in overlayfs code.
> Actually, the source (dev) is not used by overlayfs but is visible at
> /proc/mounts.

Oh, I see, this is another instance of "fuzzer fun".

In the descriptions we define src argument as const 0. And const 0 is
fine and is accepted by copy_mount_string (it has a check for NULL).
Generally fuzzer does not try to change values specified as const, but
sometimes it does. So I guess it happened so that address 0x400000ul
is mapped onto the executable and contained something that resembles a
null-terminated string so that copy_mount_string did not fail (but
otherwise that string does not matter much for overlayfs). But in your
binary 0x400000ul did not contain an addressable null-terminated
string and mount failed.
Additionally we don't attempt changing const value back to the default
value during crash mimization/simplification process:
https://github.com/google/syzkaller/blob/4a4e0509de520c7139ca2b5606712cbadc550db2/prog/minimization.go#L202-L206
because it was deemed too expensive (for each attempt we need a
freshly booted and clean machine) and not important enough (just a
single arg value and does not increase "systematic complexity" of the
repro).

All of this has combined into the effect we see here... I am not sure
what's the action item here...

FWIW fuzzer-found will always be more expensive to debug and deal with
for a very long tail of various reasons. Unit tests don't have this
problem. If only we had a comprehensive test coverage for kernel, we
would not need to deal with so many fuzzer-found bugs... ;)
