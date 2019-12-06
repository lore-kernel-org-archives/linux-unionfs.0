From: syzbot <syzbot+bb1836a212e69f8e201a@syzkaller.appspotmail.com>
Subject: Re: WARNING in ovl_rename
Date: Thu, 05 Dec 2019 17:54:00 -0800
Message-ID: <000000000000db84550598ff519f@google.com>
References: <0000000000002492cc0587d58ed8@google.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"; format=flowed; delsp=yes
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <0000000000002492cc0587d58ed8@google.com>
Sender: linux-kernel-owner@vger.kernel.org
To: amir73il@gmail.com, linux-kernel@vger.kernel.org, linux-unionfs@vger.kernel.org, miklos@szeredi.hu, mszeredi@redhat.com, syzkaller-bugs@googlegroups.com
List-Id: linux-unionfs@vger.kernel.org

syzbot suspects this bug was fixed by commit:

commit 146d62e5a5867fbf84490d82455718bfb10fe824
Author: Amir Goldstein <amir73il@gmail.com>
Date:   Thu Apr 18 14:42:08 2019 +0000

     ovl: detect overlapping layers

bisection log:  https://syzkaller.appspot.com/x/bisect.txt?x=138841dae00000
start commit:   037904a2 Merge branch 'x86-urgent-for-linus' of git://git...
git tree:       upstream
kernel config:  https://syzkaller.appspot.com/x/.config?x=a42d110b47dd6b36
dashboard link: https://syzkaller.appspot.com/bug?extid=bb1836a212e69f8e201a
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=15ba097ca00000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=10be1ceca00000

If the result looks correct, please mark the bug fixed by replying with:

#syz fix: ovl: detect overlapping layers

For information about bisection process see: https://goo.gl/tpsmEJ#bisection
