Return-Path: <amir73il@gmail.com>
MIME-Version: 1.0
References: <20191111073000.2957-1-amir73il@gmail.com> <CAJfpegvASSszZoYOdX9dcffo0EUNGVe_b8RU3JTtn-tXr9O7eg@mail.gmail.com>
 <CAOQ4uxhMqYWYnXfXrzU7Qtv8xpR6k_tR9CFSo01NLZSvqBOxsw@mail.gmail.com> <CABeXuvreoQkM1A3JBONtfD7uVLvC5MQ0hDRKX5rEQ_VUFGER8w@mail.gmail.com>
In-Reply-To: <CABeXuvreoQkM1A3JBONtfD7uVLvC5MQ0hDRKX5rEQ_VUFGER8w@mail.gmail.com>
From: Amir Goldstein <amir73il@gmail.com>
Date: Tue, 12 Nov 2019 18:49:38 +0200
Message-ID: <CAOQ4uxhH48Lso7ZLOngd904=YKFv8zbM=8oPfqYRPjD9fCzh7g@mail.gmail.com>
Subject: Re: [PATCH] ovl: fix timestamp limits
Content-Type: text/plain; charset="UTF-8"
To: Deepa Dinamani <deepa.kernel@gmail.com>
Cc: Miklos Szeredi <miklos@szeredi.hu>, overlayfs <linux-unionfs@vger.kernel.org>, linux-fsdevel <linux-fsdevel@vger.kernel.org>
List-ID: <linux-unionfs@vger.kernel.org>

On Tue, Nov 12, 2019 at 6:45 PM Deepa Dinamani <deepa.kernel@gmail.com> wrote:
>
> On Tue, Nov 12, 2019 at 8:06 AM Amir Goldstein <amir73il@gmail.com> wrote:
> >
> > On Tue, Nov 12, 2019 at 5:48 PM Miklos Szeredi <miklos@szeredi.hu> wrote:
> > >
> > > On Mon, Nov 11, 2019 at 8:30 AM Amir Goldstein <amir73il@gmail.com> wrote:
> > > >
> > > > Overlayfs timestamp overflow limits should be inherrited from upper
> > > > filesystem.
> > > >
> > > > The current behavior, when overlayfs is over an underlying filesystem
> > > > that does not support post 2038 timestamps (e.g. xfs), is that overlayfs
> > > > overflows post 2038 timestamps instead of clamping them.
> > >
> > > How?  Isn't the clamping supposed to happen in the underlying filesystem anyway?
> > >
> >
> > Not sure if it is supposed to be it doesn't.
> > It happens in do_utimes() -> utimes_common()
>
> Clamping also happens as part of current_time(). If this is called on
> an inode belonging to the upper fs, then the timestamps are clamped to
> those limits.
>

OK, but from utimes syscall they do not get clamped inside filesystem
only in syscall itself. Right?

Thanks,
Amir.
