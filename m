MIME-Version: 1.0
Date: Tue, 12 Nov 2019 16:48:24 +0100
References: <20191111073000.2957-1-amir73il@gmail.com>
In-Reply-To: <20191111073000.2957-1-amir73il@gmail.com>
Message-ID: <CAJfpegvASSszZoYOdX9dcffo0EUNGVe_b8RU3JTtn-tXr9O7eg@mail.gmail.com>
Subject: Re: [PATCH] ovl: fix timestamp limits
From: Miklos Szeredi <miklos@szeredi.hu>
Content-Type: text/plain; charset="UTF-8"
To: Amir Goldstein <amir73il@gmail.com>
Cc: Deepa Dinamani <deepa.kernel@gmail.com>, overlayfs <linux-unionfs@vger.kernel.org>, linux-fsdevel@vger.kernel.org
List-ID: <linux-unionfs@vger.kernel.org>

On Mon, Nov 11, 2019 at 8:30 AM Amir Goldstein <amir73il@gmail.com> wrote:
>
> Overlayfs timestamp overflow limits should be inherrited from upper
> filesystem.
>
> The current behavior, when overlayfs is over an underlying filesystem
> that does not support post 2038 timestamps (e.g. xfs), is that overlayfs
> overflows post 2038 timestamps instead of clamping them.

How?  Isn't the clamping supposed to happen in the underlying filesystem anyway?

Thanks,
Miklos
