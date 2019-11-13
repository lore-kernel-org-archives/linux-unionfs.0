MIME-Version: 1.0
Date: Wed, 13 Nov 2019 11:26:13 +0100
References: <20191111073000.2957-1-amir73il@gmail.com>
	<CAJfpegvASSszZoYOdX9dcffo0EUNGVe_b8RU3JTtn-tXr9O7eg@mail.gmail.com>
	<CAOQ4uxhMqYWYnXfXrzU7Qtv8xpR6k_tR9CFSo01NLZSvqBOxsw@mail.gmail.com>
In-Reply-To: <CAOQ4uxhMqYWYnXfXrzU7Qtv8xpR6k_tR9CFSo01NLZSvqBOxsw@mail.gmail.com>
Message-ID: <CAJfpeguvm=1Dw7V4XTr4gyo3uK+-EFNYKeDCFvUmuMPJxA=TcA@mail.gmail.com>
Subject: Re: [PATCH] ovl: fix timestamp limits
From: Miklos Szeredi <miklos@szeredi.hu>
Content-Type: text/plain; charset="UTF-8"
To: Amir Goldstein <amir73il@gmail.com>
Cc: Deepa Dinamani <deepa.kernel@gmail.com>, overlayfs <linux-unionfs@vger.kernel.org>, linux-fsdevel <linux-fsdevel@vger.kernel.org>
List-ID: <linux-unionfs@vger.kernel.org>

On Tue, Nov 12, 2019 at 5:06 PM Amir Goldstein <amir73il@gmail.com> wrote:
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

Ah.   How about moving the timestamp_truncate() inside notify_change()?

> clamping seems to happen when user sets the times,
> so setting the overlay limits to those of upper fs seems
> correct anyway.

It does seem correct, I just think moving the truncation into the
right layer would make more sense.

Thanks,
Miklos
