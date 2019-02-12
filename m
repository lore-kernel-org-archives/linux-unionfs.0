From: Jan Kara <jack@suse.cz>
Subject: Re: possible deadlock in pipe_lock (2)
Date: Tue, 12 Feb 2019 12:14:02 +0100
Message-ID: <20190212111402.GU19029@quack2.suse.cz>
References: <000000000000701c3305818e4814@google.com>
 <CAOQ4uxhhRs6kBH2rgbPyjd=tXoxxuJG76Y2vpCYmD0c0HzLwhA@mail.gmail.com>
 <CAJfpegvjLgXa1HOCZkz6RKup7UdioMGyY7W4miyqcRtn9PL4QA@mail.gmail.com>
 <CAJfpegsJo8X+efgWSa4QwSGpAGADpoossZZg=m7x5ApPXhxCoA@mail.gmail.com>
 <CAOQ4uxj0nKK1csWGxxLT-EvC3hv8Zz5-HpvMF_a2r2iVcLXt1A@mail.gmail.com>
 <CAJfpegsadeK=3EON9HgZ8rLCDWCJXR9QrXxA3ZZjdjzq6FDRjw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <CAJfpegsadeK=3EON9HgZ8rLCDWCJXR9QrXxA3ZZjdjzq6FDRjw@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: Amir Goldstein <amir73il@gmail.com>, Jan Kara <jack@suse.cz>, linux-fsdevel <linux-fsdevel@vger.kernel.org>, linux-kernel <linux-kernel@vger.kernel.org>, syzkaller-bugs@googlegroups.com, Al Viro <viro@zeniv.linux.org.uk>, syzbot <syzbot+31d8b84465a7cbfd8515@syzkaller.appspotmail.com>, overlayfs <linux-unionfs@vger.kernel.org>
List-Id: linux-unionfs@vger.kernel.org

On Mon 11-02-19 15:33:38, Miklos Szeredi wrote:
> On Mon, Feb 11, 2019 at 2:08 PM Amir Goldstein <amir73il@gmail.com> wrote:
> >
> > On Mon, Feb 11, 2019 at 2:37 PM Miklos Szeredi <miklos@szeredi.hu> wrote:
> > >
> > > On Mon, Feb 11, 2019 at 1:06 PM Miklos Szeredi <miklos@szeredi.hu> wrote:
> > > >
> > > > On Mon, Feb 11, 2019 at 8:38 AM Amir Goldstein <amir73il@gmail.com> wrote:
> > > > >
> > > > > On Sun, Feb 10, 2019 at 8:23 PM syzbot
> > > > > <syzbot+31d8b84465a7cbfd8515@syzkaller.appspotmail.com> wrote:
> > > >
> > > > > > -> #1 (&ovl_i_mutex_key[depth]){+.+.}:
> > > > > >         down_write+0x38/0x90 kernel/locking/rwsem.c:70
> > > > > >         inode_lock include/linux/fs.h:757 [inline]
> > > > > >         ovl_write_iter+0x148/0xc20 fs/overlayfs/file.c:231
> > > > > >         call_write_iter include/linux/fs.h:1863 [inline]
> > > > > >         new_sync_write fs/read_write.c:474 [inline]
> > > > > >         __vfs_write+0x613/0x8e0 fs/read_write.c:487
> > > > > > kobject: 'loop4' (000000009e2b886d): kobject_uevent_env
> > > > > >         __kernel_write+0x110/0x3b0 fs/read_write.c:506
> > > > > >         write_pipe_buf+0x15d/0x1f0 fs/splice.c:797
> > > > > >         splice_from_pipe_feed fs/splice.c:503 [inline]
> > > > > >         __splice_from_pipe+0x39a/0x7e0 fs/splice.c:627
> > > > > >         splice_from_pipe+0x108/0x170 fs/splice.c:662
> > > > > >         default_file_splice_write+0x3c/0x90 fs/splice.c:809
> > > >
> > > > Irrelevant to the lockdep splat, but why isn't there an
> > > > ovl_splice_write() that just recurses into realfile->splice_write()?
> > > > Sounds like a much more efficient way to handle splice read and
> > > > write...
> > > >
> > > > [...]
> > > >
> > > > > Miklos,
> > > > >
> > > > > Its good that this report popped up again, because I went to
> > > > > look back at my notes from previous report [1].
> > > > > If I was right in my previous analysis then we must have a real
> > > > > deadlock in current "lazy copy up" WIP patches. Right?
> > > >
> > > > Hmm, AFAICS this circular dependency translated into layman's terms:
> > > >
> > > > pipe lock -> ovl inode lock  (splice to ovl file)
> > > >
> > > > ovl inode lock -> upper freeze lock (truncate of ovl file)
> > > >
> > > > upper freeze lock -> pipe lock (splice to upper file)
> > >
> > > So what can we do with this?
> > >
> > > The "freeze lock -> inode lock" dependency is fixed.   This is
> > > reversed in overlay to "ovl inode lock -> upper freeze lock", which is
> > > okay, because this is a nesting that cannot be reversed.   But in
> > > splice the pipe locks comes in between: "freeze lock -> pipe lock ->
> > > inode lock" which breaks this nesting direction and creates a true
> > > reverse dependency between ovl inode lock and upper freeze lock.
> > >
> > > The only way I see this could be fixed is to move the freeze lock
> > > inside the pipe lock.  But that would mean splice/sendfile/etc could
> > > be frozen with the pipe lock held.  It doesn't look nice.
> > >
> > > Any other ideas?
> > >
> >
> > [CC Jan]
> >
> > I think we are allowed to file_start_write_trylock(upper)
> > before ovl_inode_lock(). This in ONLY needed to cover the corner
> > case of upper being frozen in between "upper freeze lock -> pipe lock"
> > and thread B being in between "ovl inode lock -> upper freeze lock".
> > Is it OK to return a transient error in this corner copy up case?
> 
> This case shouldn't happen assuming adherence to the "upper shall not
> be modified while part of the overlay" rule.
> 
> Side note: I don't see that it has anything to do with copy-up, but I
> may be missing something.
> 
> My other thought is that perhaps sb_start_write() should invoke
> s_ops->start_write() so that overlay can do the freeze protection on
> the upper early.

So my understanding of overlayfs is pretty basic so I'm sorry if I miss
something. If I'm right, we have three superblocks here: ovl, upper, lower.
Now 'lower' is read-only so for freezing purposes we can just forget about
it. 'upper' is where the real changes are going into and 'ovl' is a wrapper
virtual superblock that handles merging of 'lower' and 'upper'. Correct so
far?

And the problem seems to be that when you acquire freeze protection for the
'ovl' superblock, you in fact want to acquire freeze protection for the
'upper' (as 'ovl' is just virtual and has no disk state to protect). So I
agree that a callback to allow overlayfs to acquire freeze protection on
'upper' right away would be one solution. Or we could make s_writers a
pointer and redirect ovl->s_writers to upper->s_writers. Then VFS should do
the right thing from the start unless overlayfs calls back into operations
on 'upper' that will try to acquire the freeze protection again. Thoughts?

								Honza
-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR
