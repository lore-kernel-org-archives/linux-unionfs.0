Return-Path: <amir73il@gmail.com>
MIME-Version: 1.0
References: <20190227113211.28006-1-amir73il@gmail.com> <CAOQ4uxi9m-X6sLqa7aj9sWhrrBs2qyzf3H+YQ4e6T_xMRepYMw@mail.gmail.com>
In-Reply-To: <CAOQ4uxi9m-X6sLqa7aj9sWhrrBs2qyzf3H+YQ4e6T_xMRepYMw@mail.gmail.com>
From: Amir Goldstein <amir73il@gmail.com>
Date: Wed, 3 Apr 2019 09:02:23 +0300
Message-ID: <CAOQ4uxjPi35KGSa1yK6OymGg_R3mWivKXxDc_Nid5Q38+mAO9A@mail.gmail.com>
Subject: Re: [PATCH v2] ovl: support stacked SEEK_HOLE/SEEK_DATA
Content-Type: text/plain; charset="UTF-8"
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: Eddie Horng <eddiehorng.tw@gmail.com>, overlayfs <linux-unionfs@vger.kernel.org>
List-ID: <linux-unionfs@vger.kernel.org>

On Wed, Mar 27, 2019 at 8:35 AM Amir Goldstein <amir73il@gmail.com> wrote:
>
> On Wed, Feb 27, 2019 at 1:32 PM Amir Goldstein <amir73il@gmail.com> wrote:
> >
> > Overlay file f_pos is the master copy that is preserved
> > through copy up and modified on read/write, but only real
> > fs knows how to SEEK_HOLE/SEEK_DATA and real fs may impose
> > limitations that are more strict than ->s_maxbytes for specific
> > files, so we use the real file to perform seeks.
> >
> > We do not call real fs for SEEK_CUR:0 query and for SEEK_SET:0
> > requests.
> >
> > Fixes: d1d04ef8572b ("ovl: stack file ops")
> > Reported-by: Eddie Horng <eddiehorng.tw@gmail.com>
> > Signed-off-by: Amir Goldstein <amir73il@gmail.com>
> > ---
>
> Miklos,
>
> PING.
>
> xfstests are already upstream and failing...
>

I lied... xfstests were only posted for review
Now posted v3 tests.

Thanks,
Amir.
