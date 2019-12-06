From: Amir Goldstein <amir73il@gmail.com>
Subject: Re: WARNING in ovl_rename
Date: Fri, 6 Dec 2019 08:46:36 +0200
Message-ID: <CAOQ4uxgzGRJs3o=7_rM3HtdMjEP-Emy=0a98LMVvYa-3==ZpjQ@mail.gmail.com>
References: <0000000000002492cc0587d58ed8@google.com> <000000000000db84550598ff519f@google.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <000000000000db84550598ff519f@google.com>
Sender: linux-kernel-owner@vger.kernel.org
To: syzbot <syzbot+bb1836a212e69f8e201a@syzkaller.appspotmail.com>, Dmitry Vyukov <dvyukov@google.com>
Cc: linux-kernel <linux-kernel@vger.kernel.org>, overlayfs <linux-unionfs@vger.kernel.org>, Miklos Szeredi <miklos@szeredi.hu>, Miklos Szeredi <mszeredi@redhat.com>, syzkaller-bugs <syzkaller-bugs@googlegroups.com>
List-Id: linux-unionfs@vger.kernel.org

On Fri, Dec 6, 2019 at 3:54 AM syzbot
<syzbot+bb1836a212e69f8e201a@syzkaller.appspotmail.com> wrote:
>
> syzbot suspects this bug was fixed by commit:
>
> commit 146d62e5a5867fbf84490d82455718bfb10fe824
> Author: Amir Goldstein <amir73il@gmail.com>
> Date:   Thu Apr 18 14:42:08 2019 +0000
>
>      ovl: detect overlapping layers
>
> bisection log:  https://syzkaller.appspot.com/x/bisect.txt?x=138841dae00000
> start commit:   037904a2 Merge branch 'x86-urgent-for-linus' of git://git...
> git tree:       upstream
> kernel config:  https://syzkaller.appspot.com/x/.config?x=a42d110b47dd6b36
> dashboard link: https://syzkaller.appspot.com/bug?extid=bb1836a212e69f8e201a
> syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=15ba097ca00000
> C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=10be1ceca00000
>
> If the result looks correct, please mark the bug fixed by replying with:
>
> #syz fix: ovl: detect overlapping layers
>

Not exactly. Depends how you define "the bug".

The actual bug wasn't introduced by:
     ovl: fix EIO from lookup of non-indexed upper

Nor was it fixed by:
     ovl: detect overlapping layers

It would be more accurate to say that the former commit exposed the bug
to this specific repro and the latter commit has masked it from this repro.

The actual bug was introduced by:
    804032fabb3b ("ovl: don't check rename to self")

Which did not take into account hardlinking underneath overlayfs.

I posted a fix to relax this WARN_ON(), which is marked for stable 4.9+,
because I see that the repro is also reported on kernel 4.14.y and
"ovl: detect overlapping layers" is not expected to land in 4.14.y.

Thanks,
Amir.
