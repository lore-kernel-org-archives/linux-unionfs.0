From: syzbot <syzbot+9c69c282adc4edd2b540@syzkaller.appspotmail.com>
Subject: Re: WARNING in ovl_instantiate
Date: Tue, 26 Mar 2019 05:10:00 -0700
Message-ID: <0000000000004f7f7c0584fe33c0@google.com>
References: <000000000000064bcf057a59e3b9@google.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"; format=flowed; delsp=yes
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <000000000000064bcf057a59e3b9@google.com>
Sender: linux-kernel-owner@vger.kernel.org
To: amir73il@gmail.com, dvyukov@google.com, linux-kernel@vger.kernel.org, linux-unionfs@vger.kernel.org, miklos@szeredi.hu, mszeredi@redhat.com, syzkaller-bugs@googlegroups.com
List-Id: linux-unionfs@vger.kernel.org

syzbot has bisected this bug to:

commit 01b39dcc95680b04c7af5de7f39f577e9c4865e3
Author: Amir Goldstein <amir73il@gmail.com>
Date:   Fri May 11 08:15:15 2018 +0000

     ovl: use inode_insert5() to hash a newly created inode

bisection log:  https://syzkaller.appspot.com/x/bisect.txt?x=176da0cd200000
start commit:   de6629eb Merge tag 'pci-v5.0-fixes-1' of git://git.kernel...
git tree:       upstream
final crash:    https://syzkaller.appspot.com/x/report.txt?x=14eda0cd200000
console output: https://syzkaller.appspot.com/x/log.txt?x=10eda0cd200000
kernel config:  https://syzkaller.appspot.com/x/.config?x=edf1c3031097c304
dashboard link: https://syzkaller.appspot.com/bug?extid=9c69c282adc4edd2b540
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=12c7a94f400000

Reported-by: syzbot+9c69c282adc4edd2b540@syzkaller.appspotmail.com
Fixes: 01b39dcc9568 ("ovl: use inode_insert5() to hash a newly created  
inode")

For information about bisection process see: https://goo.gl/tpsmEJ#bisection
