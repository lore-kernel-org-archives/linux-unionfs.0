From: Dmitry Vyukov <dvyukov@google.com>
Subject: Re: WARNING in ovl_instantiate
Date: Mon, 22 Apr 2019 13:12:04 +0300
Message-ID: <CACT4Y+bcm2PuX0=1miyXa4pSb2jU0nvp+9eyYwmavVncxB5JXQ@mail.gmail.com>
References: <000000000000064bcf057a59e3b9@google.com> <0000000000004f7f7c0584fe33c0@google.com>
 <CAOQ4uxjOm+VFyTbm=2k1d0774qu2tK5gzEgKNnRPjd0GvMnihA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <CAOQ4uxjOm+VFyTbm=2k1d0774qu2tK5gzEgKNnRPjd0GvMnihA@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Amir Goldstein <amir73il@gmail.com>
Cc: syzbot <syzbot+9c69c282adc4edd2b540@syzkaller.appspotmail.com>, linux-kernel <linux-kernel@vger.kernel.org>, overlayfs <linux-unionfs@vger.kernel.org>, Miklos Szeredi <miklos@szeredi.hu>, Miklos Szeredi <mszeredi@redhat.com>, syzkaller-bugs <syzkaller-bugs@googlegroups.com>
List-Id: linux-unionfs@vger.kernel.org

On Fri, Apr 19, 2019 at 11:21 AM Amir Goldstein <amir73il@gmail.com> wrote:
>
> On Tue, Mar 26, 2019 at 2:10 PM syzbot
> <syzbot+9c69c282adc4edd2b540@syzkaller.appspotmail.com> wrote:
> >
> > syzbot has bisected this bug to:
> >
> > commit 01b39dcc95680b04c7af5de7f39f577e9c4865e3
> > Author: Amir Goldstein <amir73il@gmail.com>
> > Date:   Fri May 11 08:15:15 2018 +0000
> >
> >      ovl: use inode_insert5() to hash a newly created inode
> >
> > bisection log:  https://syzkaller.appspot.com/x/bisect.txt?x=176da0cd200000
> > start commit:   de6629eb Merge tag 'pci-v5.0-fixes-1' of git://git.kernel...
> > git tree:       upstream
> > final crash:    https://syzkaller.appspot.com/x/report.txt?x=14eda0cd200000
> > console output: https://syzkaller.appspot.com/x/log.txt?x=10eda0cd200000
> > kernel config:  https://syzkaller.appspot.com/x/.config?x=edf1c3031097c304
> > dashboard link: https://syzkaller.appspot.com/bug?extid=9c69c282adc4edd2b540
> > syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=12c7a94f400000
> >
> > Reported-by: syzbot+9c69c282adc4edd2b540@syzkaller.appspotmail.com
> > Fixes: 01b39dcc9568 ("ovl: use inode_insert5() to hash a newly created
> > inode")
> >
>
> Dmitry,
>
> The root cause of this bug is that repro is mounting overlapping overlay
> layers (i.e. upperdir=./file0,lowerdir=.:file0).
> Miklos claimed that the fix should be to fail such mounts.
> Below is a patch to test:
>
> #syz test: https://github.com/amir73il/linux.git ovl-check-overlap
>
> However, I see that this specific overlapping layers mount has already
> mutated to several other repros out there, like the ones in this bug:
>
> https://syzkaller.appspot.com/bug?extid=a55ccfc8a853d3cff213
>
> I believe that disallowing overlapping layers will silence some
> bugs, whose root cause may be different.
>
> Besides doing the overlapping layers mount, this repro family also
> does extensive access to overlay underlying layers concurrently
> with overlay access and *that* is the root cause for most of these
> "possible deadlock" bugs (some false positives and some real).
>
> Assuming that ovl-check-overlap will get merged, you may need to
> hint syzkaller that overlapping layers is no longer a valid input or
> maybe it will figure it out on its own?...

Hi Amir,

It should figure it out on its own, it's coverage-guided fuzzer. And
unlearning things is easier then learning them :) But thanks for
thinking about this.
But maybe there is something else important in overlayfs that's not
covered. Here you can see the current coverage of overlayfs:
https://storage.googleapis.com/syzkaller/cover/ci-upstream-linux-next-kasan-gce-root.html#e2f448f0ca2e4397fd609ff8c42d4cd118411148
