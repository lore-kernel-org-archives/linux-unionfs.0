From: syzbot <syzbot+a55ccfc8a853d3cff213@syzkaller.appspotmail.com>
Subject: Re: possible deadlock in path_openat
Date: Sun, 17 Nov 2019 18:14:01 -0800
Message-ID: <00000000000042f41905979580cc@google.com>
References: <00000000000044cbf80576baaecd@google.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"; format=flowed; delsp=yes
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <00000000000044cbf80576baaecd@google.com>
Sender: linux-kernel-owner@vger.kernel.org
To: amir73il@gmail.com, ast@kernel.org, linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org, linux-unionfs@vger.kernel.org, miklos@szeredi.hu, syzkaller-bugs@googlegroups.com, viro@zeniv.linux.org.uk
List-Id: linux-unionfs@vger.kernel.org

syzbot has bisected this bug to:

commit 8e54cadab447dae779f80f79c87cbeaea9594f60
Author: Al Viro <viro@zeniv.linux.org.uk>
Date:   Sun Nov 27 01:05:42 2016 +0000

     fix default_file_splice_read()

bisection log:  https://syzkaller.appspot.com/x/bisect.txt?x=108f4416e00000
start commit:   6d906f99 Merge tag 'arm64-fixes' of git://git.kernel.org/p..
git tree:       upstream
final crash:    https://syzkaller.appspot.com/x/report.txt?x=128f4416e00000
console output: https://syzkaller.appspot.com/x/log.txt?x=148f4416e00000
kernel config:  https://syzkaller.appspot.com/x/.config?x=856fc6d0fbbeede9
dashboard link: https://syzkaller.appspot.com/bug?extid=a55ccfc8a853d3cff213
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=101767b7200000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=13c15013200000

Reported-by: syzbot+a55ccfc8a853d3cff213@syzkaller.appspotmail.com
Fixes: 8e54cadab447 ("fix default_file_splice_read()")

For information about bisection process see: https://goo.gl/tpsmEJ#bisection
