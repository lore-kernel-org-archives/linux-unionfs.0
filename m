Return-Path: <jencce.kernel@gmail.com>
MIME-Version: 1.0
References: <20180913073715.2205-1-jencce.kernel@gmail.com> <CAJfpegt+CrqNzj6bho_bqO1CG8-cB0D41X+yeTEbNtm2Gx6dAg@mail.gmail.com>
In-Reply-To: <CAJfpegt+CrqNzj6bho_bqO1CG8-cB0D41X+yeTEbNtm2Gx6dAg@mail.gmail.com>
From: Murphy Zhou <jencce.kernel@gmail.com>
Date: Fri, 14 Sep 2018 10:31:04 +0800
Message-ID: <CADJHv_uYCogkAoPJhMNAZ5UAoJW7PaTA-eAzqETT0oD7UFGUow@mail.gmail.com>
Subject: Re: [PATCH] Revert "vfs: don't open real"
Content-Type: text/plain; charset="UTF-8"
To: miklos@szeredi.hu
Cc: linux-unionfs@vger.kernel.org, xzhou@redhat.com
List-ID: <linux-unionfs@vger.kernel.org>

Hi,

On Thu, Sep 13, 2018 at 4:00 PM Miklos Szeredi <miklos@szeredi.hu> wrote:
>
> On Thu, Sep 13, 2018 at 9:37 AM, Murphy Zhou <jencce.kernel@gmail.com> wrote:
> > From: Xiong Murphy Zhou <jencce.kernel@gmail.com>
> >
> > This reverts commit a6518f73e60e5044656d1ba587e7463479a9381a.
> >
> > swapon a file in overlayfs causes kernel panic since 4.19-rc1.
> > 4.18 works fine. Bisect points to
> >
> > commit a6518f73e60e5044656d1ba587e7463479a9381a
> > Author: Miklos Szeredi <mszeredi@redhat.com>
> > Date:   Fri Jul 6 23:57:06 2018 +0200
> >
> >     vfs: don't open real
> >
> > as first bad commit. Revert it and remove redundant parameters of
> > d_real can fix this panic on top of 4.19-rc3.
>
> Please try instead:
>
>   git://git.kernel.org/pub/scm/linux/kernel/git/mszeredi/vfs.git overlayfs-next

This branch survived a round of xfstests.

Thanks,
Murphy

>
> Will send pull request later today.
>
> Thanks,
> Miklos
