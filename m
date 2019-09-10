Return-Path: <amir73il@gmail.com>
MIME-Version: 1.0
References: <20190712122434.14809-1-amir73il@gmail.com> <CAOQ4uxg+equ2vt3xqsC_v=m=YMFSAj2ywk2pga=BGZWgOQcVoA@mail.gmail.com>
In-Reply-To: <CAOQ4uxg+equ2vt3xqsC_v=m=YMFSAj2ywk2pga=BGZWgOQcVoA@mail.gmail.com>
From: Amir Goldstein <amir73il@gmail.com>
Date: Tue, 10 Sep 2019 16:53:23 +0300
Message-ID: <CAOQ4uxhC_=oPcjwpzgq7YvZuFL=HWJ=9hXwcY=EupcAnLobcsA@mail.gmail.com>
Subject: Re: [PATCH] ovl: fix regression caused by overlapping layers detection
Content-Type: text/plain; charset="UTF-8"
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: Vivek Goyal <vgoyal@redhat.com>, overlayfs <linux-unionfs@vger.kernel.org>, Colin Walters <walters@verbum.org>
List-ID: <linux-unionfs@vger.kernel.org>

On Tue, Jul 16, 2019 at 8:15 AM Amir Goldstein <amir73il@gmail.com> wrote:
>
> On Fri, Jul 12, 2019 at 3:24 PM Amir Goldstein <amir73il@gmail.com> wrote:
> >
> > Once upon a time, commit 2cac0c00a6cd ("ovl: get exclusive ownership on
> > upper/work dirs") in v4.13 added some sanity checks on overlayfs layers.
> > This change caused a docker regression. The root cause was mount leaks
> > by docker, which as far as I know, still exist.
> >
> > To mitigate the regression, commit 85fdee1eef1a ("ovl: fix regression
> > caused by exclusive upper/work dir protection") in v4.14 turned the
> > mount errors into warnings for the default index=off configuration.
> >
> > Recently, commit 146d62e5a586 ("ovl: detect overlapping layers") in
> > v5.2, re-introduced exclusive upper/work dir checks regardless of
> > index=off configuration.
> >
> > This changes the status quo and mount leak related bug reports have
> > started to re-surface. Restore the status quo to fix the regressions.
> > To clarify, index=off does NOT relax overlapping layers check for this
> > ovelayfs mount. index=off only relaxes exclusive upper/work dir checks
> > with another overlayfs mount.
> >
> > To cover the part of overlapping layers detection that used the
> > exclusive upper/work dir checks to detect overlap with self upper/work
> > dir, add a trap also on the work base dir.
> >
> > Link: https://github.com/moby/moby/issues/34672
> > Link: https://lore.kernel.org/linux-fsdevel/20171006121405.GA32700@veci.piliscsaba.szeredi.hu/
> > Link: https://github.com/containers/libpod/issues/3540
> > Fixes: 146d62e5a586 ("ovl: detect overlapping layers")
> > Cc: <stable@vger.kernel.org> # v4.19+
> > Signed-off-by: Amir Goldstein <amir73il@gmail.com>
>
> Miklos,
>
> Please add:
> Tested-by: Colin Walters <walters@verbum.org>
>

Miklos,

This patch got stuck in overlayfs-next.
Could you push it to Linus please?

Thanks,
Amir.
