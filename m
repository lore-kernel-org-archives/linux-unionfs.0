MIME-Version: 1.0
Date: Mon, 6 May 2019 07:58:42 -0400
References: <20190424163950.14123-1-amir73il@gmail.com>
	<CADJHv_tDBdHNBqrO_uARQhMZYEeadPcoshtXFVnvpcVpOFGdhQ@mail.gmail.com>
In-Reply-To: <CADJHv_tDBdHNBqrO_uARQhMZYEeadPcoshtXFVnvpcVpOFGdhQ@mail.gmail.com>
Message-ID: <CAJfpegvCtm1rEZ2FyGM1xxJ8Ee-5Q_dr6PCt_WBNvMdJLiTcaw@mail.gmail.com>
Subject: Re: [PATCH v2] ovl: do not generate duplicate fsnotify events for
 "fake" path
From: Miklos Szeredi <miklos@szeredi.hu>
Content-Type: text/plain; charset="UTF-8"
To: Murphy Zhou <jencce.kernel@gmail.com>
Cc: Amir Goldstein <amir73il@gmail.com>, Jan Kara <jack@suse.cz>, Linux-Fsdevel <linux-fsdevel@vger.kernel.org>, overlayfs <linux-unionfs@vger.kernel.org>
List-ID: <linux-unionfs@vger.kernel.org>

On Sat, Apr 27, 2019 at 11:09 PM Murphy Zhou <jencce.kernel@gmail.com> wrote:
>
> On Thu, Apr 25, 2019 at 12:39 AM Amir Goldstein <amir73il@gmail.com> wrote:
> >
> > Overlayfs "fake" path is used for stacked file operations on
> > underlying files.  Operations on files with "fake" path must not
> > generate fsnotify events with path data, because those events have
> > already been generated at overlayfs layer and because the reported
> > event->fd for fanotify marks on underlying inode/filesystem will
> > have the wrong path (the overlayfs path).
> >
> > Link: https://lore.kernel.org/linux-fsdevel/20190423065024.12695-1-jencce.kernel@gmail.com/
> > Reported-by: Murphy Zhou <jencce.kernel@gmail.com>
> > Fixes: d1d04ef8572b ("ovl: stack file ops")
> > Signed-off-by: Amir Goldstein <amir73il@gmail.com>
> > ---
> >
> > Miklos,
> >
> > V1 was addressed to Jan and was trying to teach fsnotify about fake path.
> > V2 leaves fsnotify subsystem alone and just sets the FMODE_NONOTIFY
> > flag on realfile. All the rest of the complications with mark mounts
> > are irrelevant.
> >
> > Same extended fanotify06 that was used to verify V1 also verified V2.
>
> Thanks for fixing this!
>
> My overlayfs tests on this patch looks good.

Thanks, applied.

Miklos
