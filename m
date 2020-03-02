Return-Path: <SRS0=C54B=4T=vger.kernel.org=linux-unionfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,
	SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B76CEC3F2D2
	for <linux-unionfs@archiver.kernel.org>; Mon,  2 Mar 2020 13:24:13 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 866152086A
	for <linux-unionfs@archiver.kernel.org>; Mon,  2 Mar 2020 13:24:13 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="vLt2I3B+"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727736AbgCBNYN (ORCPT
        <rfc822;linux-unionfs@archiver.kernel.org>);
        Mon, 2 Mar 2020 08:24:13 -0500
Received: from mail-io1-f68.google.com ([209.85.166.68]:46710 "EHLO
        mail-io1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727361AbgCBNYN (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Mon, 2 Mar 2020 08:24:13 -0500
Received: by mail-io1-f68.google.com with SMTP id x21so6928686iox.13;
        Mon, 02 Mar 2020 05:24:12 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=iOAD9+MdORb/Grg4ortMCpfAyFSLoych0vXLlv3nkY8=;
        b=vLt2I3B+FU2rLWmITK2V8QAaAVs8MKVbM3akA0p+u03JnJPXIhdkloZ1eATbO8OSTa
         dtCCV865P3KhUPAid0FxOxnXrG9SMm5aaBNufjqOEXhBH4lB6KQX0ZQUt4AtdXUZJ6Vp
         zk9Qdi8Wy8Elyr99oECBcGektmX4fpNv052JKzGHqgNr+kFLhwlZbMxa8crBnFFOmrZL
         bOqq92oat4ljtAl8xKSnDl4+NTteO/gfLIULizJ+bUTFYlDsjpYbgARQcboakK3A7w0B
         nweeGRxjIAAlDANlimeicMtSZ5U4V9riktSO+o4qamWRLj51quf4gZ2V8B0zdDYr0GC3
         +ZZQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=iOAD9+MdORb/Grg4ortMCpfAyFSLoych0vXLlv3nkY8=;
        b=XK6T0nTXwjN0Tt82bruTwcvR4jawiSiNDN5dVhS8NM5DVp5IKP0Rv2u1XSC+aCFy24
         Bssg8xtC9PCP0qvLOQ0PWecOqOs1ik3ftb1RBqACg2adeD9KVmqLxMm542iWIxCa7Xsj
         EXO5rVo+D6XN/rQAjmtJ4qJjd/HNIom3Z1M9sjO84IHSZ5fy5L7WpqdfGVzRkvek7o2D
         +RIAOh7h1gGWSp4EDbqvrLIAACK+fTEJjujCSMw7wVUfdGuo+2K2ZCv87MT2t/8CQlM3
         2Or1Ov8u1OdQ+l+ZNR+o7yhyhbcbpfMGOj2kwyDpmjTiYwNk/Y2DMw7ajTrwzJ2DOe+R
         PTPg==
X-Gm-Message-State: APjAAAXANp7K8O6xUSQM55UbnITS9iXZHiQ2eki70sPQJqthajNszn9k
        +NQCpiREt5KbfXZSBBXknFwQg+uPz6xMIQvKgVPj7uc3
X-Google-Smtp-Source: APXvYqzTJmjHs9wbc7l4b8ASisn2apNkGcisszzY2JgHbofBiPMpwowXFQ+PQyGdo3ojI9I8gE2RSE/DWGULSmRdMWI=
X-Received: by 2002:a5e:8507:: with SMTP id i7mr6889525ioj.9.1583155452284;
 Mon, 02 Mar 2020 05:24:12 -0800 (PST)
MIME-Version: 1.0
References: <000000000000d3e319059fcfdc98@google.com> <CAOQ4uxh=tLw1p8vsbzTTqrTzLSqr33WtVHek+Jhbi5C2HKQLTA@mail.gmail.com>
 <CACT4Y+YBOm-VeHXuRnk4mLgwsEMx2MYrOnQ-FJpBjg5dDU_YzQ@mail.gmail.com>
 <CAOQ4uxh=3XWOfKAJMeJBrsfouLEDo3oqTNoYBMZ2f46mVRigvA@mail.gmail.com> <CACT4Y+aBvofv8AQqiWr7M77FODSUqruMMoVcHHA5ROfv5VN7tw@mail.gmail.com>
In-Reply-To: <CACT4Y+aBvofv8AQqiWr7M77FODSUqruMMoVcHHA5ROfv5VN7tw@mail.gmail.com>
From:   Amir Goldstein <amir73il@gmail.com>
Date:   Mon, 2 Mar 2020 15:24:01 +0200
Message-ID: <CAOQ4uxhTAR0-evX0DHdvF9BhHwgC8dU-532FyUiSCqcfujfiKA@mail.gmail.com>
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

On Mon, Mar 2, 2020 at 2:35 PM Dmitry Vyukov <dvyukov@google.com> wrote:
>
> On Mon, Mar 2, 2020 at 1:10 PM Amir Goldstein <amir73il@gmail.com> wrote:
> > > > On Sun, Mar 1, 2020 at 9:13 PM syzbot
> > > > <syzbot+66a9752fa927f745385e@syzkaller.appspotmail.com> wrote:
> > > > >
> > > > > Hello,
> > > > >
> > > > > syzbot found the following crash on:
> > > > >
> > > > > HEAD commit:    f8788d86 Linux 5.6-rc3
> > > > > git tree:       upstream
> > > > > console output: https://syzkaller.appspot.com/x/log.txt?x=13c5f8f9e00000
> > > > > kernel config:  https://syzkaller.appspot.com/x/.config?x=5d2e033af114153f
> > > > > dashboard link: https://syzkaller.appspot.com/bug?extid=66a9752fa927f745385e
> > > > > compiler:       clang version 10.0.0 (https://github.com/llvm/llvm-project/ c2443155a0fb245c8f17f2c1c72b6ea391e86e81)
> > > > > syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=131d9a81e00000
> > > > > C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=14117a81e00000
> > > > >
> > > >
> > > > Dmitry,
> > > >
> > > > There is something strange about the C repro.
> > > > It passes an invalid address for the first arg of mount syscall:
> > > >
> > > >     syscall(__NR_mount, 0x400000ul, 0x20000000ul, 0x20000080ul, 0ul,
> > > >             0x20000100ul);
> > > >
> > > > With this address mount syscall returns -EFAULT on my system.
> > > > I fixed this manually, but repro did not trigger the reported bug on my system.
> > >
> > > Hi Amir,
> > >
> > > This is not strange in the context of fuzzer, it's goal is to pass
> > > random data. Generally if it says 0x400000ul, that's what it is, don't
> > > fix it, or you are running a different program that may not reproduce
> > > the bug. If syzbot attaches a reproducer, the bug was triggered by
> > > precisely this program.
> > >
> >
> > What's strange it that a bug in overlay code cannot be triggered if overlay
> > isn't mounted and as it is the repro couldn't mount overlayfs at all, at
> > lease with my kernel config.
>
> Can it depend on kernel config? The bug was triggered by the program
> provided somehow.

I am not sure. I do not have CONFIG_HARDENED_USERCOPY set.

>
> Separate question: why is it failing? Isn't src unused for overlayfs?
> Where/how does vfs code look at src?
>

SYSCALL_DEFINE5(mount, ...
copy_mount_string(dev_name)
strndup_user()
memdup_user()
copy_from_user()

Not in overlayfs code.
Actually, the source (dev) is not used by overlayfs but is visible at
/proc/mounts.

Thanks,
Amir.
