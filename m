From: syzbot <syzbot+9c69c282adc4edd2b540@syzkaller.appspotmail.com>
Subject: Re: WARNING in ovl_instantiate
Date: Fri, 19 Apr 2019 01:52:01 -0700
Message-ID: <0000000000006a47db0586de3ba6@google.com>
References: <CAOQ4uxjOm+VFyTbm=2k1d0774qu2tK5gzEgKNnRPjd0GvMnihA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"; format=flowed; delsp=yes
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <CAOQ4uxjOm+VFyTbm=2k1d0774qu2tK5gzEgKNnRPjd0GvMnihA@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: amir73il@gmail.com, dvyukov@google.com, linux-kernel@vger.kernel.org, linux-unionfs@vger.kernel.org, miklos@szeredi.hu, mszeredi@redhat.com, syzkaller-bugs@googlegroups.com
List-Id: linux-unionfs@vger.kernel.org

Hello,

syzbot has tested the proposed patch and the reproducer did not trigger  
crash:

Reported-and-tested-by:  
syzbot+9c69c282adc4edd2b540@syzkaller.appspotmail.com

Tested on:

commit:         59ef64de ovl: detect overlapping layers
git tree:       https://github.com/amir73il/linux.git ovl-check-overlap
kernel config:  https://syzkaller.appspot.com/x/.config?x=f3ee46e9dfc8a383
compiler:       gcc (GCC) 9.0.0 20181231 (experimental)

Note: testing is done by a robot and is best-effort only.
