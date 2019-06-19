MIME-Version: 1.0
Date: Wed, 19 Jun 2019 09:03:07 +0200
References: <20190609160344.24979-1-amir73il@gmail.com>
	<CAJfpegt4QXGC0-y_sug7kuFo2q28c6DFJQnQ-UHe1bmCGC0jag@mail.gmail.com>
	<CAOQ4uxi2HANUnep5JQV5=kTTPFmCgnqgBMYcLdvgFPnC9Z3Osg@mail.gmail.com>
In-Reply-To: <CAOQ4uxi2HANUnep5JQV5=kTTPFmCgnqgBMYcLdvgFPnC9Z3Osg@mail.gmail.com>
Message-ID: <CAJfpegsrFJk3BjG2Jy4FeLY2=ykBNGz-Qnd=mdCBARYSxrz1vQ@mail.gmail.com>
Subject: Re: [PATCH] ovl: make i_ino consistent with st_ino in more cases
From: Miklos Szeredi <miklos@szeredi.hu>
Content-Type: text/plain; charset="UTF-8"
To: Amir Goldstein <amir73il@gmail.com>
Cc: overlayfs <linux-unionfs@vger.kernel.org>
List-ID: <linux-unionfs@vger.kernel.org>

On Tue, Jun 18, 2019 at 3:36 PM Amir Goldstein <amir73il@gmail.com> wrote:
>
> On Tue, Jun 11, 2019 at 4:58 PM Miklos Szeredi <miklos@szeredi.hu> wrote:
> >
> > On Sun, Jun 9, 2019 at 6:03 PM Amir Goldstein <amir73il@gmail.com> wrote:

> > > TBH, I can't remember why I put the s_export_op condition in the
> > > first place (can you?), expect for the fact the original bug fix
> > > was reported on nfsd readdirplus.
> >
> > I have no recollection of any issue that would require nfs export.
> >
> > I've applied the patch.
> >
>
> Forgot to apply to overlayfs-next or intentionally left for 5.3?

Safer to leave it to 5.3 since this is not a recent regression and the
only reporter is xfstests.

Thanks,
Miklos
