Return-Path: <amir73il@gmail.com>
MIME-Version: 1.0
References: <20190423065024.12695-1-jencce.kernel@gmail.com>
 <CAOQ4uxgo-R8CUONFy=e6N8DfbeJb+AJmShJcDd9xgdy69BwZyA@mail.gmail.com>
 <CAJfpeguOMEoxk_CM-akuGQ8rc=K=HvHWVtYMxcUbx88_T-uDtA@mail.gmail.com>
 <CAOQ4uxgk-qkn0YdKP5rEvJvmzhhBUZzjPNqUVe6geXQ+xt9eiw@mail.gmail.com>
 <CAJfpegvwgJnuuAdaVK-TjQ=6_MBwf8zQNztPLcjOK5GpHbeCEA@mail.gmail.com>
 <CAOQ4uxhSbZaLHa9LZ9v6yzVkTof_D4mnCVREYOm=D0roF=nNNw@mail.gmail.com> <CAJfpegvDR7aVg-r+aGot+ATB04=NVg4LigV-1y1n=qHjSfOGvA@mail.gmail.com>
In-Reply-To: <CAJfpegvDR7aVg-r+aGot+ATB04=NVg4LigV-1y1n=qHjSfOGvA@mail.gmail.com>
From: Amir Goldstein <amir73il@gmail.com>
Date: Tue, 23 Apr 2019 18:05:14 +0300
Message-ID: <CAOQ4uxgEMkCPD0FU1VJsdYhWcNdO9wwistMGig8qHaekOiER+A@mail.gmail.com>
Subject: Re: [PATCH] ovl: add RWF_NONITIFY flag to skip wrong duplicate
 fanotify event
Content-Type: text/plain; charset="UTF-8"
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: Murphy Zhou <jencce.kernel@gmail.com>, overlayfs <linux-unionfs@vger.kernel.org>, linux-fsdevel <linux-fsdevel@vger.kernel.org>, Jan Kara <jack@suse.cz>
List-ID: <linux-unionfs@vger.kernel.org>

On Tue, Apr 23, 2019 at 5:16 PM Miklos Szeredi <miklos@szeredi.hu> wrote:
>
> On Tue, Apr 23, 2019 at 3:53 PM Amir Goldstein <amir73il@gmail.com> wrote:
> >
> > On Tue, Apr 23, 2019 at 4:41 PM Miklos Szeredi <miklos@szeredi.hu> wrote:
> > >
> > > On Tue, Apr 23, 2019 at 2:44 PM Amir Goldstein <amir73il@gmail.com> wrote:
> > > >
> > > > On Tue, Apr 23, 2019 at 2:40 PM Miklos Szeredi <miklos@szeredi.hu> wrote:
> > > > >
> > > > > On Tue, Apr 23, 2019 at 1:00 PM Amir Goldstein <amir73il@gmail.com> wrote:
> > > > > >
> > > > > > On Tue, Apr 23, 2019 at 9:51 AM Murphy Zhou <jencce.kernel@gmail.com> wrote:
> > > > > > >
> > > > > > > Overlays ovl_iter_write calls vfs_iter_write to write on real file,
> > > > > > > in which calls fsnotify_modify on this change, however vfs_write also
> > > > > > > calls fsnotify_modify after ovl_iter_write. The first notification
> > > > > > > sent by vfs_iter_write grabs marks from upper inode and overlay mnt,
> > > > > > > because of its fake path. The second one sent by vfs_write grabs marks
> > > > > > > from ovl inode and ovl mnt.
> > > > > > >
> > > > > > > LTP fanotify06 add modify mark for mnt point, then add ignore modify
> > > > > > > mask on testfile, then truncate and write the file. Because the ignore
> > > > > > > mask is marked on ovl inode, not the upper inode, the first event is not
> > > > > > > masked like the second one. So we get a modification event even with a
> > > > > > > mask on the file.
> > > > > >
> > > > > > Care to extend fanotify06 in a similar manner to the way readahead02
> > > > > > was extended to test overlay test case regardless of the base LTP filesystem?
> > > > > >
> > > > > > >
> > > > > > > Proposing fixing this by add a new RWF flag to skip fsnotify on this IO.
> > > > > > > vfs_iter_write used by ovl can use this flag to skip one duplicate event.
> > > > > > >
> > > > > >
> > > > > > This fix is wrong for several reasons:
> > > > > > - It exports RWF_NONOTIFY to uapi
> > > > > > - It will cause no events at all when overlay writes to file even when user
> > > > > > requested events on upper inode
> > > > > >
> > > > > > Please try attached patch.
> > > > >
> > > > > Would be nice, but until mmap stops using realfile this isn't a good solution.
> > > > >
> > > >
> > > > Sigh! I figured there was a catch...
> > > > Will it be ok if fake path used a cloned private mount of overlay mount?
> > >
> > > So the reason we have the fake path is e.g. /proc/$$/maps.  That can
> > > only work with the original mount, AFAICS.
> > >
> > > We could have one realfile for regular I/O and a separate one for mmap
> > > but that would increase complexity as well as resource use, so I'm not
> > > quite sure if that's the right solution.
> > >
> >
> > I see. Well what we could do is set a file flag for fake path, so at least
> > fsnotify will be able to ignore f_path->mnt when calculating ignore mask.
>
> FMODE_NONOTIFY_MNT: like FMODE_NONOTIFY, but only affect mount marks?
>

On second thought I don't think there a need for an explicit
FMODE_NONOTIFY_MNT/FMODE_FAKE_PATH flag because code
can just check for file_inode(f) != d_inode(f->f_path->dentry).
The question is what do do about this.
I think situation is actually worse than reported (CC Jan).

This problem existed even before stacked f_op, but is now manifesting
differently because of stacked f_op.

When user sets a mark on real inode or real parent dir inode, the
user events that user gets when operations are performed via overlayfs file
are with event->fd created by dentry_open(&event->path, ...
So even when ignore mount marks are not involved, user will get the wrong
path (overlayfs path) and referenced by event->fd while the mark was set
on the real inode.

The good new is that I believe fanotify marks are most commonly set on
mount marks in the wild (?), so the events via overlayfs file on real inode
won't be triggered in this case anyway and that's fine.
FAN_MARK_FILESYSTEM may have opened up the possibility of exposing
this bug to new users.

In fsnotify_path(), when inode mismatches path->dentry->d_inode
calling fsnotify_parent() is wrong (we are looking for parent watch of
inode) and passing FSNOTIFY_EVENT_PATH info is wrong, because
fsnotify() will filter by wrong mount and wrong path will we reported to
user via event->fd.

We could still report the event with FSNOTIFY_EVENT_INODE info,
so at least inotify/audit watch on inode itself will work, but parent
watches will not work as well as legacy fanotify inode watches.
New FAN_REPORT_FID fanotify watches should work just fine.

Any other ideas how to untangle?

Thanks,
Amir.
