From: Jan Kara <jack@suse.cz>
Subject: Re: possible deadlock in pipe_lock (2)
Date: Tue, 12 Feb 2019 17:11:07 +0100
Message-ID: <20190212161107.GB19076@quack2.suse.cz>
References: <000000000000701c3305818e4814@google.com>
 <CAOQ4uxhhRs6kBH2rgbPyjd=tXoxxuJG76Y2vpCYmD0c0HzLwhA@mail.gmail.com>
 <CAJfpegvjLgXa1HOCZkz6RKup7UdioMGyY7W4miyqcRtn9PL4QA@mail.gmail.com>
 <CAJfpegsJo8X+efgWSa4QwSGpAGADpoossZZg=m7x5ApPXhxCoA@mail.gmail.com>
 <CAOQ4uxj0nKK1csWGxxLT-EvC3hv8Zz5-HpvMF_a2r2iVcLXt1A@mail.gmail.com>
 <CAJfpegsadeK=3EON9HgZ8rLCDWCJXR9QrXxA3ZZjdjzq6FDRjw@mail.gmail.com>
 <20190212111402.GU19029@quack2.suse.cz>
 <CAOQ4uxh_o53RimG-yKPYkN9sszQhwjQbmHw9pHc4kJU5MywMNA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <CAOQ4uxh_o53RimG-yKPYkN9sszQhwjQbmHw9pHc4kJU5MywMNA@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Amir Goldstein <amir73il@gmail.com>
Cc: Jan Kara <jack@suse.cz>, Miklos Szeredi <miklos@szeredi.hu>, linux-fsdevel <linux-fsdevel@vger.kernel.org>, linux-kernel <linux-kernel@vger.kernel.org>, syzkaller-bugs@googlegroups.com, Al Viro <viro@zeniv.linux.org.uk>, syzbot <syzbot+31d8b84465a7cbfd8515@syzkaller.appspotmail.com>, overlayfs <linux-unionfs@vger.kernel.org>
List-Id: linux-unionfs@vger.kernel.org

On Tue 12-02-19 15:39:38, Amir Goldstein wrote:
> > > My other thought is that perhaps sb_start_write() should invoke
> > > s_ops->start_write() so that overlay can do the freeze protection on
> > > the upper early.
> >
> > So my understanding of overlayfs is pretty basic so I'm sorry if I miss
> > something. If I'm right, we have three superblocks here: ovl, upper, lower.
> > Now 'lower' is read-only so for freezing purposes we can just forget about
> > it. 'upper' is where the real changes are going into and 'ovl' is a wrapper
> > virtual superblock that handles merging of 'lower' and 'upper'. Correct so
> > far?
> 
> Yes.
> 
> >
> > And the problem seems to be that when you acquire freeze protection for the
> > 'ovl' superblock, you in fact want to acquire freeze protection for the
> > 'upper' (as 'ovl' is just virtual and has no disk state to protect). So I
> 
> There are use case for freezing ovl (i.e. ovl snapshots) but it is not
> implemented
> at the moment.
> 
> Overlayfs already gets upper freeze protection internally before any
> modification
> to upper.
> The problem that locking order of upper freeze is currently under overlay
> inode mutex. And that brings a problem with the above pipe case.
> 
> > agree that a callback to allow overlayfs to acquire freeze protection on
> > 'upper' right away would be one solution. Or we could make s_writers a
> > pointer and redirect ovl->s_writers to upper->s_writers. Then VFS should do
> > the right thing from the start unless overlayfs calls back into operations
> > on 'upper' that will try to acquire the freeze protection again. Thoughts?
> 
> Overlayfs definitely calls into operations on upper and upper certainly
> acquires several levels of s_writers itself.
> 
> The problem with the proposal to change locking order to
> ovl freeze -> upper freeze -> ovl inode -> upper inode
> is that for some non-write operations (e.g. lookup, readdir)
> overlay may end up updating xattrs on upper, so will need
> to take upper freeze after ovl inode lock without ovl freeze
> being called by vfs.
> 
> I suggested that we may use upper freeze trylock in those
> cases and skip xattr update if trylock fails.

Yes, that's what VFS does as well e.g. for atime updates. In fact I don't
see other sensible possibility since blocking read operation on frozen
filesystem is surprising to the user.

> Not sure if my assumption is correct that this would be ok
> w.r.t locking rules?

It should be fine AFAICT.

> Not sure if we can get away with trylock in all the cases that
> we need to modify upper.

I don't know overlayfs enough to be able to tell :).

								Honza
-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR
