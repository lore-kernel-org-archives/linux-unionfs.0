Return-Path: <amir73il@gmail.com>
MIME-Version: 1.0
References: <20190609160344.24979-1-amir73il@gmail.com> <CAJfpegt4QXGC0-y_sug7kuFo2q28c6DFJQnQ-UHe1bmCGC0jag@mail.gmail.com>
In-Reply-To: <CAJfpegt4QXGC0-y_sug7kuFo2q28c6DFJQnQ-UHe1bmCGC0jag@mail.gmail.com>
From: Amir Goldstein <amir73il@gmail.com>
Date: Tue, 18 Jun 2019 16:36:18 +0300
Message-ID: <CAOQ4uxi2HANUnep5JQV5=kTTPFmCgnqgBMYcLdvgFPnC9Z3Osg@mail.gmail.com>
Subject: Re: [PATCH] ovl: make i_ino consistent with st_ino in more cases
Content-Type: text/plain; charset="UTF-8"
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: overlayfs <linux-unionfs@vger.kernel.org>
List-ID: <linux-unionfs@vger.kernel.org>

On Tue, Jun 11, 2019 at 4:58 PM Miklos Szeredi <miklos@szeredi.hu> wrote:
>
> On Sun, Jun 9, 2019 at 6:03 PM Amir Goldstein <amir73il@gmail.com> wrote:
> >
> > Relax the condition that overlayfs supports nfs export, to require
> > that i_ino is consistent with st_ino/d_ino.
> >
> > It is enough to require that st_ino and d_ino are consistent.
>
> Yes.
>
> >
> > This fixes the failure of xfstest generic/504, due to mismatch of
> > st_ino to inode number in the output of /proc/locks.
> >
> > Fixes: 12574a9f4c9c ("ovl: consistent i_ino for non-samefs with xino")
> > Cc: <stable@vger.kernel.org> # v4.19
> > Signed-off-by: Amir Goldstein <amir73il@gmail.com>
> > ---
> >
> > Miklos,
> >
> > TBH, I can't remember why I put the s_export_op condition in the
> > first place (can you?), expect for the fact the original bug fix
> > was reported on nfsd readdirplus.
>
> I have no recollection of any issue that would require nfs export.
>
> I've applied the patch.
>

Forgot to apply to overlayfs-next or intentionally left for 5.3?

Thanks,
Amir.
