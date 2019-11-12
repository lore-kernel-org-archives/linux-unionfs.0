Return-Path: <amir73il@gmail.com>
MIME-Version: 1.0
References: <20191111073000.2957-1-amir73il@gmail.com> <CAJfpegvASSszZoYOdX9dcffo0EUNGVe_b8RU3JTtn-tXr9O7eg@mail.gmail.com>
In-Reply-To: <CAJfpegvASSszZoYOdX9dcffo0EUNGVe_b8RU3JTtn-tXr9O7eg@mail.gmail.com>
From: Amir Goldstein <amir73il@gmail.com>
Date: Tue, 12 Nov 2019 18:06:12 +0200
Message-ID: <CAOQ4uxhMqYWYnXfXrzU7Qtv8xpR6k_tR9CFSo01NLZSvqBOxsw@mail.gmail.com>
Subject: Re: [PATCH] ovl: fix timestamp limits
Content-Type: text/plain; charset="UTF-8"
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: Deepa Dinamani <deepa.kernel@gmail.com>, overlayfs <linux-unionfs@vger.kernel.org>, linux-fsdevel <linux-fsdevel@vger.kernel.org>
List-ID: <linux-unionfs@vger.kernel.org>

On Tue, Nov 12, 2019 at 5:48 PM Miklos Szeredi <miklos@szeredi.hu> wrote:
>
> On Mon, Nov 11, 2019 at 8:30 AM Amir Goldstein <amir73il@gmail.com> wrote:
> >
> > Overlayfs timestamp overflow limits should be inherrited from upper
> > filesystem.
> >
> > The current behavior, when overlayfs is over an underlying filesystem
> > that does not support post 2038 timestamps (e.g. xfs), is that overlayfs
> > overflows post 2038 timestamps instead of clamping them.
>
> How?  Isn't the clamping supposed to happen in the underlying filesystem anyway?
>

Not sure if it is supposed to be it doesn't.
It happens in do_utimes() -> utimes_common()

clamping seems to happen when user sets the times,
so setting the overlay limits to those of upper fs seems
correct anyway.

Thanks,
Amir.
