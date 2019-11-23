From: syzbot <syzbot+ae82084b07d0297e566b@syzkaller.appspotmail.com>
Subject: Re: possible deadlock in mnt_want_write
Date: Fri, 22 Nov 2019 18:27:00 -0800
Message-ID: <000000000000ebac4d0597fa4340@google.com>
References: <000000000000d03eea0571adfe83@google.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"; format=flowed; delsp=yes
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <000000000000d03eea0571adfe83@google.com>
Sender: linux-kernel-owner@vger.kernel.org
To: amir73il@gmail.com, ast@kernel.org, dvyukov@google.com, linux-fsdevel@vger.kernel.org, linux-integrity@vger.kernel.org, linux-kernel@vger.kernel.org, linux-unionfs@vger.kernel.org, mszeredi@redhat.com, rgoldwyn@suse.de, syzkaller-bugs@googlegroups.com, viro@zeniv.linux.org.uk, zohar@linux.ibm.com, zohar@linux.vnet.ibm.com
List-Id: linux-unionfs@vger.kernel.org

syzbot has bisected this bug to:

commit 8e54cadab447dae779f80f79c87cbeaea9594f60
Author: Al Viro <viro@zeniv.linux.org.uk>
Date:   Sun Nov 27 01:05:42 2016 +0000

     fix default_file_splice_read()

bisection log:  https://syzkaller.appspot.com/x/bisect.txt?x=15147a36e00000
start commit:   6d906f99 Merge tag 'arm64-fixes' of git://git.kernel.org/p..
git tree:       upstream
final crash:    https://syzkaller.appspot.com/x/report.txt?x=17147a36e00000
console output: https://syzkaller.appspot.com/x/log.txt?x=13147a36e00000
kernel config:  https://syzkaller.appspot.com/x/.config?x=856fc6d0fbbeede9
dashboard link: https://syzkaller.appspot.com/bug?extid=ae82084b07d0297e566b
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=111767b7200000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=1611ab2d200000

Reported-by: syzbot+ae82084b07d0297e566b@syzkaller.appspotmail.com
Fixes: 8e54cadab447 ("fix default_file_splice_read()")

For information about bisection process see: https://goo.gl/tpsmEJ#bisection
