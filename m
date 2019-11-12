Return-Path: <deepa.kernel@gmail.com>
MIME-Version: 1.0
References: <20191111073000.2957-1-amir73il@gmail.com> <CAJfpegvASSszZoYOdX9dcffo0EUNGVe_b8RU3JTtn-tXr9O7eg@mail.gmail.com>
 <CAOQ4uxhMqYWYnXfXrzU7Qtv8xpR6k_tR9CFSo01NLZSvqBOxsw@mail.gmail.com>
In-Reply-To: <CAOQ4uxhMqYWYnXfXrzU7Qtv8xpR6k_tR9CFSo01NLZSvqBOxsw@mail.gmail.com>
From: Deepa Dinamani <deepa.kernel@gmail.com>
Date: Tue, 12 Nov 2019 08:45:04 -0800
Message-ID: <CABeXuvreoQkM1A3JBONtfD7uVLvC5MQ0hDRKX5rEQ_VUFGER8w@mail.gmail.com>
Subject: Re: [PATCH] ovl: fix timestamp limits
Content-Type: text/plain; charset="UTF-8"
To: Amir Goldstein <amir73il@gmail.com>
Cc: Miklos Szeredi <miklos@szeredi.hu>, overlayfs <linux-unionfs@vger.kernel.org>, linux-fsdevel <linux-fsdevel@vger.kernel.org>
List-ID: <linux-unionfs@vger.kernel.org>

On Tue, Nov 12, 2019 at 8:06 AM Amir Goldstein <amir73il@gmail.com> wrote:
>
> On Tue, Nov 12, 2019 at 5:48 PM Miklos Szeredi <miklos@szeredi.hu> wrote:
> >
> > On Mon, Nov 11, 2019 at 8:30 AM Amir Goldstein <amir73il@gmail.com> wrote:
> > >
> > > Overlayfs timestamp overflow limits should be inherrited from upper
> > > filesystem.
> > >
> > > The current behavior, when overlayfs is over an underlying filesystem
> > > that does not support post 2038 timestamps (e.g. xfs), is that overlayfs
> > > overflows post 2038 timestamps instead of clamping them.
> >
> > How?  Isn't the clamping supposed to happen in the underlying filesystem anyway?
> >
>
> Not sure if it is supposed to be it doesn't.
> It happens in do_utimes() -> utimes_common()

Clamping also happens as part of current_time(). If this is called on
an inode belonging to the upper fs, then the timestamps are clamped to
those limits.

-Deepa
