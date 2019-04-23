MIME-Version: 1.0
Date: Tue, 23 Apr 2019 13:39:48 +0200
References: <20190423065024.12695-1-jencce.kernel@gmail.com>
	<CAOQ4uxgo-R8CUONFy=e6N8DfbeJb+AJmShJcDd9xgdy69BwZyA@mail.gmail.com>
In-Reply-To: <CAOQ4uxgo-R8CUONFy=e6N8DfbeJb+AJmShJcDd9xgdy69BwZyA@mail.gmail.com>
Message-ID: <CAJfpeguOMEoxk_CM-akuGQ8rc=K=HvHWVtYMxcUbx88_T-uDtA@mail.gmail.com>
Subject: Re: [PATCH] ovl: add RWF_NONITIFY flag to skip wrong duplicate
 fanotify event
From: Miklos Szeredi <miklos@szeredi.hu>
Content-Type: text/plain; charset="UTF-8"
To: Amir Goldstein <amir73il@gmail.com>
Cc: Murphy Zhou <jencce.kernel@gmail.com>, overlayfs <linux-unionfs@vger.kernel.org>, linux-fsdevel <linux-fsdevel@vger.kernel.org>
List-ID: <linux-unionfs@vger.kernel.org>

On Tue, Apr 23, 2019 at 1:00 PM Amir Goldstein <amir73il@gmail.com> wrote:
>
> On Tue, Apr 23, 2019 at 9:51 AM Murphy Zhou <jencce.kernel@gmail.com> wrote:
> >
> > Overlays ovl_iter_write calls vfs_iter_write to write on real file,
> > in which calls fsnotify_modify on this change, however vfs_write also
> > calls fsnotify_modify after ovl_iter_write. The first notification
> > sent by vfs_iter_write grabs marks from upper inode and overlay mnt,
> > because of its fake path. The second one sent by vfs_write grabs marks
> > from ovl inode and ovl mnt.
> >
> > LTP fanotify06 add modify mark for mnt point, then add ignore modify
> > mask on testfile, then truncate and write the file. Because the ignore
> > mask is marked on ovl inode, not the upper inode, the first event is not
> > masked like the second one. So we get a modification event even with a
> > mask on the file.
>
> Care to extend fanotify06 in a similar manner to the way readahead02
> was extended to test overlay test case regardless of the base LTP filesystem?
>
> >
> > Proposing fixing this by add a new RWF flag to skip fsnotify on this IO.
> > vfs_iter_write used by ovl can use this flag to skip one duplicate event.
> >
>
> This fix is wrong for several reasons:
> - It exports RWF_NONOTIFY to uapi
> - It will cause no events at all when overlay writes to file even when user
> requested events on upper inode
>
> Please try attached patch.

Would be nice, but until mmap stops using realfile this isn't a good solution.

Thanks,
Miklos
