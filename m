Return-Path: <amir73il@gmail.com>
MIME-Version: 1.0
References: <CAOQ4uxh7fszXGXV0U5K4yz4o3WwDk40LmOi+dH2Nwi+yq_5+Pw@mail.gmail.com>
 <CAJfpegv8sN=XB5ePnEiz3KfVhHhyNmYWW8C-bckaxeYiQ0Ee-g@mail.gmail.com>
In-Reply-To: <CAJfpegv8sN=XB5ePnEiz3KfVhHhyNmYWW8C-bckaxeYiQ0Ee-g@mail.gmail.com>
From: Amir Goldstein <amir73il@gmail.com>
Date: Mon, 9 Dec 2019 18:47:12 +0200
Message-ID: <CAOQ4uxir4WC_atq6r-zpRr+m7+c3t7HcVBsaMYM+5xWbKzUXrw@mail.gmail.com>
Subject: Re: Overlayfs fixes queue
Content-Type: text/plain; charset="UTF-8"
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: overlayfs <linux-unionfs@vger.kernel.org>
List-ID: <linux-unionfs@vger.kernel.org>

On Mon, Dec 9, 2019 at 4:57 PM Miklos Szeredi <miklos@szeredi.hu> wrote:
>
> On Mon, Dec 2, 2019 at 7:32 AM Amir Goldstein <amir73il@gmail.com> wrote:
> >
> > Hi Miklos,
> >
> > Will you have time to queue some of the queued fixed [1] and docs .rst
> > conversion [2] for 5.5, maybe rc2?
> >
> > The timestamp limits issue is also being addressed by Deepa in vfs as
> > you suggested, so not critical but nice to have.
> >
> > I posted an xfstest [3] that demonstrates the corner case of
> > non-unique st_dev;st_ino (v4.17 regression).
>
> Hi Amir,
>
> I'm going though your queue, hoping to finish it for -rc2.
>

OK. for the record, following patch was added to branch
since I posted the summary:

* 4d85701cda95 - ovl: relax WARN_ON() on rename to self

Thanks,
Amir.
