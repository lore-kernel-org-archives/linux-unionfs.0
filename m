From: Amir Goldstein <amir73il@gmail.com>
Subject: Re: WARNING in ovl_instantiate
Date: Sun, 16 Dec 2018 19:00:33 +0200
Message-ID: <CAOQ4uxgcxGXcCiC02UJrvwkCjiXERJxuNvoG_mfLga7Am3c5GA@mail.gmail.com>
References: <000000000000064bcf057a59e3b9@google.com> <00000000000058055a057d14a1f4@google.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <00000000000058055a057d14a1f4@google.com>
Sender: linux-kernel-owner@vger.kernel.org
To: syzbot+9c69c282adc4edd2b540@syzkaller.appspotmail.com, Dmitry Vyukov <dvyukov@google.com>
Cc: linux-kernel <linux-kernel@vger.kernel.org>, overlayfs <linux-unionfs@vger.kernel.org>, Miklos Szeredi <miklos@szeredi.hu>, syzkaller-bugs@googlegroups.com
List-Id: linux-unionfs@vger.kernel.org

On Sat, Dec 15, 2018 at 9:34 PM syzbot
<syzbot+9c69c282adc4edd2b540@syzkaller.appspotmail.com> wrote:
>
> syzbot has found a reproducer for the following crash on:
>
> HEAD commit:    d14b746c6c1c Add linux-next specific files for 20181214
> git tree:       linux-next
> console output: https://syzkaller.appspot.com/x/log.txt?x=143f9a15400000
> kernel config:  https://syzkaller.appspot.com/x/.config?x=1da6d2d18f803140
> dashboard link: https://syzkaller.appspot.com/bug?extid=9c69c282adc4edd2b540
> compiler:       gcc (GCC) 8.0.1 20180413 (experimental)
> syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=12a6e543400000
>
> IMPORTANT: if you fix the bug, please add the following tag to the commit:
> Reported-by: syzbot+9c69c282adc4edd2b540@syzkaller.appspotmail.com
>
> overlayfs: filesystem on './file0' not supported as upperdir
> overlayfs: filesystem on './file0' not supported as upperdir
> overlayfs: filesystem on './file0' not supported as upperdir
> overlayfs: filesystem on './file0' not supported as upperdir
> overlayfs: filesystem on './file0' not supported as upperdir
> WARNING: CPU: 1 PID: 28918 at fs/overlayfs/dir.c:263
> ovl_instantiate+0x369/0x400 fs/overlayfs/dir.c:263

Looks like some corner case race when using same dir as upper and lower.
Doesn't look like a critical issue, I just don't know how to explain
getting to this
state. Couldn't reproduce on my target machine.

It would have been interesting for me to see the strace of the repro threads
when that WARN happens. I wonder if anyone else has already asked for it and
how hard would it be to make that information available with the bug report.

Thanks,
Amir.
