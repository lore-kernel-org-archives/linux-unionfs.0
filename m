From: syzbot <syzbot+032bc63605089a199d30@syzkaller.appspotmail.com>
Subject: Re: WARNING in ovl_real_fdget_meta
Date: Wed, 24 Jul 2019 21:24:00 -0700
Message-ID: <00000000000086c732058e79cb59@google.com>
References: <0000000000004a3a63058e722b94@google.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"; format=flowed; delsp=yes
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <0000000000004a3a63058e722b94@google.com>
Sender: linux-kernel-owner@vger.kernel.org
To: amir73il@gmail.com, bfields@fieldses.org, jlayton@kernel.org, linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org, linux-unionfs@vger.kernel.org, miklos@szeredi.hu, syzkaller-bugs@googlegroups.com, viro@zeniv.linux.org.uk
List-Id: linux-unionfs@vger.kernel.org

syzbot has bisected this bug to:

commit 387e3746d01c34457d6a73688acd90428725070b
Author: Amir Goldstein <amir73il@gmail.com>
Date:   Fri Jun 7 14:24:38 2019 +0000

     locks: eliminate false positive conflicts for write lease

bisection log:  https://syzkaller.appspot.com/x/bisect.txt?x=15a79594600000
start commit:   c6dd78fc Merge branch 'x86-urgent-for-linus' of git://git...
git tree:       upstream
final crash:    https://syzkaller.appspot.com/x/report.txt?x=17a79594600000
console output: https://syzkaller.appspot.com/x/log.txt?x=13a79594600000
kernel config:  https://syzkaller.appspot.com/x/.config?x=3c8985c08e1f9727
dashboard link: https://syzkaller.appspot.com/bug?extid=032bc63605089a199d30
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=15855334600000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=17fcc4c8600000

Reported-by: syzbot+032bc63605089a199d30@syzkaller.appspotmail.com
Fixes: 387e3746d01c ("locks: eliminate false positive conflicts for write  
lease")

For information about bisection process see: https://goo.gl/tpsmEJ#bisection
