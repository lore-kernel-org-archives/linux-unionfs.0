From: Amir Goldstein <amir73il@gmail.com>
Subject: Re: WARNING in ovl_instantiate
Date: Mon, 17 Dec 2018 15:30:14 +0200
Message-ID: <CAOQ4uxg6HNyK9_j7A2SarJaSnVViR_c07_1CKGwD0Vr89571sQ@mail.gmail.com>
References: <000000000000064bcf057a59e3b9@google.com> <00000000000058055a057d14a1f4@google.com>
 <CAOQ4uxgcxGXcCiC02UJrvwkCjiXERJxuNvoG_mfLga7Am3c5GA@mail.gmail.com> <CACT4Y+YHK0rOtYZEDzzVLjNP6XHOiG=SXHMR7SicU01Vu_ivtA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <CACT4Y+YHK0rOtYZEDzzVLjNP6XHOiG=SXHMR7SicU01Vu_ivtA@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Dmitry Vyukov <dvyukov@google.com>
Cc: syzbot+9c69c282adc4edd2b540@syzkaller.appspotmail.com, linux-kernel <linux-kernel@vger.kernel.org>, overlayfs <linux-unionfs@vger.kernel.org>, Miklos Szeredi <miklos@szeredi.hu>, syzkaller-bugs@googlegroups.com
List-Id: linux-unionfs@vger.kernel.org

On Mon, Dec 17, 2018 at 12:47 PM Dmitry Vyukov <dvyukov@google.com> wrote:
>
> On Sun, Dec 16, 2018 at 6:00 PM Amir Goldstein <amir73il@gmail.com> wrote:
> >
> > On Sat, Dec 15, 2018 at 9:34 PM syzbot
> > <syzbot+9c69c282adc4edd2b540@syzkaller.appspotmail.com> wrote:
> > >
> > > syzbot has found a reproducer for the following crash on:
> > >
> > > HEAD commit:    d14b746c6c1c Add linux-next specific files for 20181214
> > > git tree:       linux-next
> > > console output: https://syzkaller.appspot.com/x/log.txt?x=143f9a15400000
> > > kernel config:  https://syzkaller.appspot.com/x/.config?x=1da6d2d18f803140
> > > dashboard link: https://syzkaller.appspot.com/bug?extid=9c69c282adc4edd2b540
> > > compiler:       gcc (GCC) 8.0.1 20180413 (experimental)
> > > syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=12a6e543400000
> > >
> > > IMPORTANT: if you fix the bug, please add the following tag to the commit:
> > > Reported-by: syzbot+9c69c282adc4edd2b540@syzkaller.appspotmail.com
> > >
> > > overlayfs: filesystem on './file0' not supported as upperdir
> > > overlayfs: filesystem on './file0' not supported as upperdir
> > > overlayfs: filesystem on './file0' not supported as upperdir
> > > overlayfs: filesystem on './file0' not supported as upperdir
> > > overlayfs: filesystem on './file0' not supported as upperdir
> > > WARNING: CPU: 1 PID: 28918 at fs/overlayfs/dir.c:263
> > > ovl_instantiate+0x369/0x400 fs/overlayfs/dir.c:263
> >
> > Looks like some corner case race when using same dir as upper and lower.
> > Doesn't look like a critical issue, I just don't know how to explain
> > getting to this
> > state. Couldn't reproduce on my target machine.
> >
> > It would have been interesting for me to see the strace of the repro threads
> > when that WARN happens. I wonder if anyone else has already asked for it and
> > how hard would it be to make that information available with the bug report.
>
> Hi Amir,
>
> By strace you mean return values of syscalls, or something else?
>

I do mean return values.
Some of the commands in the repro are obviously going to fail and
some will fail conditionally depending on who wins the race.
It could have been good for analysis of the bug to know when the
race happened which syscall sequence took place.

> We had only 1 strace-related request, and it was related to better
> static decoding of inputs rather then dynamic behavior:
> https://github.com/google/syzkaller/issues?utf8=%E2%9C%93&q=is%3Aissue+is%3Aopen+strace
>
> I don't immediately see how to capture runtime behavior. It would work
> if we dump everything onto console right away. But this will produce
> tons of output (really lots). And that output will be intermixed
> across parallel processes. And it will be hard to understand which
> exactly syscalls participated in the process that provoked the crash.
> Or maybe it's exactly syscalls from several processes interacted. Lots
> of output can also slow down and perturb execution.

Yeh, I figured. Maybe the return values of syscalls is something that syzkaller
should cache and in case of failure, report recent run sequences in format
similar to the repro program. Just a though. Much easier said than done.

>
> But meanwhile I was able to reproduce this on the first run within 4
> minutes. Maybe you need to wait longer, it does not happen
> immediately.

Oh! I wonder if this type of information, how long or how many repeats before
crash happens is available in the bug report and I missed it - if not, could be
useful to add it.

Anyway, The reason that WARN_ON is there is because I wasn't sure
if that could happen. Apparently it can with this weird setup. Once I am able to
understand how it happens most likely the result will be to covert the WARN_ON
to pr_warn. User anyway gets an error, so there is probably nothing to
worry about
(famous last words).

Thanks,
Amir.
