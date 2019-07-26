From: Amir Goldstein <amir73il@gmail.com>
Subject: Re: WARNING in ovl_real_fdget_meta
Date: Fri, 26 Jul 2019 19:31:34 +0300
Message-ID: <CAOQ4uxi1w0uJkJzJOMQgeoQXZ0aQqYpwSLyQQmB779DjdY3D_Q@mail.gmail.com>
References: <0000000000004a3a63058e722b94@google.com> <00000000000086c732058e79cb59@google.com>
 <CAOQ4uxhAi6sqBR2219ZvzX7izeF_RezN+VKRrHiQ04P=t0uiOg@mail.gmail.com> <CAOQ4uxhRWzjY=RcgFtFZL4VUg7Y8EyRa2eaWuqtVOHDZWWO1PQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <CAOQ4uxhRWzjY=RcgFtFZL4VUg7Y8EyRa2eaWuqtVOHDZWWO1PQ@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: syzbot <syzbot+032bc63605089a199d30@syzkaller.appspotmail.com>
Cc: "J. Bruce Fields" <bfields@fieldses.org>, Jeff Layton <jlayton@kernel.org>, linux-fsdevel <linux-fsdevel@vger.kernel.org>, linux-kernel <linux-kernel@vger.kernel.org>, overlayfs <linux-unionfs@vger.kernel.org>, Miklos Szeredi <miklos@szeredi.hu>, syzkaller-bugs <syzkaller-bugs@googlegroups.com>, Al Viro <viro@zeniv.linux.org.uk>
List-Id: linux-unionfs@vger.kernel.org

On Fri, Jul 26, 2019 at 1:06 PM Amir Goldstein <amir73il@gmail.com> wrote:
>
> On Fri, Jul 26, 2019 at 11:11 AM Amir Goldstein <amir73il@gmail.com> wrote:
> >
> > On Thu, Jul 25, 2019 at 7:24 AM syzbot
> > <syzbot+032bc63605089a199d30@syzkaller.appspotmail.com> wrote:
> > >
> > > syzbot has bisected this bug to:
> > >
> > > commit 387e3746d01c34457d6a73688acd90428725070b
> > > Author: Amir Goldstein <amir73il@gmail.com>
> > > Date:   Fri Jun 7 14:24:38 2019 +0000
> > >
> > >      locks: eliminate false positive conflicts for write lease
> > >
> > > bisection log:  https://syzkaller.appspot.com/x/bisect.txt?x=15a79594600000
> > > start commit:   c6dd78fc Merge branch 'x86-urgent-for-linus' of git://git...
> > > git tree:       upstream
> > > final crash:    https://syzkaller.appspot.com/x/report.txt?x=17a79594600000
> > > console output: https://syzkaller.appspot.com/x/log.txt?x=13a79594600000
> > > kernel config:  https://syzkaller.appspot.com/x/.config?x=3c8985c08e1f9727
> > > dashboard link: https://syzkaller.appspot.com/bug?extid=032bc63605089a199d30
> > > syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=15855334600000
> > > C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=17fcc4c8600000
> > >
> > > Reported-by: syzbot+032bc63605089a199d30@syzkaller.appspotmail.com
> > > Fixes: 387e3746d01c ("locks: eliminate false positive conflicts for write
> > > lease")
> > >
> > > For information about bisection process see: https://goo.gl/tpsmEJ#bisection
> >
> > The repro:
> > #{"repeat":true,"procs":1,"sandbox":"none","fault_call":-1,"cgroups":true,"close_fds":true,"tmpdir":true}
> > mkdir(&(0x7f0000000100)='./file0\x00', 0x0)
> > mkdirat$cgroup_root(0xffffffffffffff9c,
> > &(0x7f0000000000)='./cgroup.net/syz1\x00', 0x1ff)
> > mount$fuse(0x20000000, &(0x7f0000000140)='./file0\x00', 0x0, 0x1004, 0x0)
> > mount$overlay(0x400000, &(0x7f0000000100)='./file0\x00',
> > &(0x7f00000001c0)='overlay\x00', 0x0,
> > &(0x7f0000000040)=ANY=[@ANYBLOB=',lowerdir=.:file0'])
> > r0 = open(&(0x7f0000000500)='./file0\x00', 0x0, 0x0)
> > r1 = openat$cgroup_procs(r0, &(0x7f00000004c0)='cgroup.procs\x00', 0x48, 0x0)
> > dup3(r1, r0, 0x0)
> > fcntl$setlease(r0, 0x400, 0x1)
> > lseek(r0, 0x4, 0x0)
> >
> > I though we would stop these family of overlapping layers fuzzers with:
> > 146d62e5a586 ("ovl: detect overlapping layers")
> >
> > But syzbot got the upper hand, because we do not check for overlapping layers
> > that cross fs boundary. Not sure if we should (?).
>
> No, we shouldn't care about that.
> overlayfs doesn't follow cross-fs in underlying layers.
>
> >
> > ./ is a tmpfs dir and ./file0/ is some kind of fuse mount (?)
> > then after one cycle, ./file0/ itself is an overlapping overlay mount
> > (lowerdir=./:./file0/)
> > and after another cycle, ./file0/ is a nested overlapping overlayfs mount.
> > Fine. Whatever.
>
> But damage can still be created if a lower overlayfs layer
> overlaps with the another nested overlay lower underlying layer.
> It actually shouldn't be too hard to add a guard also on the
> nested overlay lower underlying layer inode.
>

Here's a draft

#syz test: https://github.com/amir73il/linux.git ovl-check-nested-overlap

Thanks,
Amir.
