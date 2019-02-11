From: Miklos Szeredi <miklos@szeredi.hu>
Subject: Re: possible deadlock in pipe_lock (2)
Date: Mon, 11 Feb 2019 13:06:34 +0100
Message-ID: <CAJfpegvjLgXa1HOCZkz6RKup7UdioMGyY7W4miyqcRtn9PL4QA@mail.gmail.com>
References: <000000000000701c3305818e4814@google.com> <CAOQ4uxhhRs6kBH2rgbPyjd=tXoxxuJG76Y2vpCYmD0c0HzLwhA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <CAOQ4uxhhRs6kBH2rgbPyjd=tXoxxuJG76Y2vpCYmD0c0HzLwhA@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Amir Goldstein <amir73il@gmail.com>
Cc: linux-fsdevel <linux-fsdevel@vger.kernel.org>, linux-kernel <linux-kernel@vger.kernel.org>, syzkaller-bugs@googlegroups.com, Al Viro <viro@zeniv.linux.org.uk>, syzbot <syzbot+31d8b84465a7cbfd8515@syzkaller.appspotmail.com>, overlayfs <linux-unionfs@vger.kernel.org>
List-Id: linux-unionfs@vger.kernel.org

On Mon, Feb 11, 2019 at 8:38 AM Amir Goldstein <amir73il@gmail.com> wrote:
>
> On Sun, Feb 10, 2019 at 8:23 PM syzbot
> <syzbot+31d8b84465a7cbfd8515@syzkaller.appspotmail.com> wrote:

> > -> #1 (&ovl_i_mutex_key[depth]){+.+.}:
> >         down_write+0x38/0x90 kernel/locking/rwsem.c:70
> >         inode_lock include/linux/fs.h:757 [inline]
> >         ovl_write_iter+0x148/0xc20 fs/overlayfs/file.c:231
> >         call_write_iter include/linux/fs.h:1863 [inline]
> >         new_sync_write fs/read_write.c:474 [inline]
> >         __vfs_write+0x613/0x8e0 fs/read_write.c:487
> > kobject: 'loop4' (000000009e2b886d): kobject_uevent_env
> >         __kernel_write+0x110/0x3b0 fs/read_write.c:506
> >         write_pipe_buf+0x15d/0x1f0 fs/splice.c:797
> >         splice_from_pipe_feed fs/splice.c:503 [inline]
> >         __splice_from_pipe+0x39a/0x7e0 fs/splice.c:627
> >         splice_from_pipe+0x108/0x170 fs/splice.c:662
> >         default_file_splice_write+0x3c/0x90 fs/splice.c:809

Irrelevant to the lockdep splat, but why isn't there an
ovl_splice_write() that just recurses into realfile->splice_write()?
Sounds like a much more efficient way to handle splice read and
write...

[...]

> Miklos,
>
> Its good that this report popped up again, because I went to
> look back at my notes from previous report [1].
> If I was right in my previous analysis then we must have a real
> deadlock in current "lazy copy up" WIP patches. Right?

Hmm, AFAICS this circular dependency translated into layman's terms:

pipe lock -> ovl inode lock  (splice to ovl file)

ovl inode lock -> upper freeze lock (truncate of ovl file)

upper freeze lock -> pipe lock (splice to upper file)

> "This looks like a false positive because lockdep is not aware of
> s_stack_depth of the file (fs) associated with the pipe.

But AFAICS the above dependency doesn't include copy up or stacked
overlay, so looks like a real deadlock.

Am I missing something?

Thanks,
Miklos
