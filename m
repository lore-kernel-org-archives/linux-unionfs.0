Return-Path: <deepa.kernel@gmail.com>
MIME-Version: 1.0
References: <20191111074010.3738-1-amir73il@gmail.com>
In-Reply-To: <20191111074010.3738-1-amir73il@gmail.com>
From: Deepa Dinamani <deepa.kernel@gmail.com>
Date: Mon, 11 Nov 2019 14:32:26 -0800
Message-ID: <CABeXuvo8SADSgtQYbJHE-afU5EYzCFZp17BoVLpeiYvqJ6RiCw@mail.gmail.com>
Subject: Re: [PATCH] overlay: support timestamp range check
Content-Type: text/plain; charset="UTF-8"
To: Amir Goldstein <amir73il@gmail.com>
Cc: Eryu Guan <guaneryu@gmail.com>, Miklos Szeredi <miklos@szeredi.hu>, linux-unionfs@vger.kernel.org, fstests@vger.kernel.org
List-ID: <linux-unionfs@vger.kernel.org>

On Sun, Nov 10, 2019 at 11:40 PM Amir Goldstein <amir73il@gmail.com> wrote:
>
> Overlayfs timestamp range is the same as base fs timestamp range
>
> Signed-off-by: Amir Goldstein <amir73il@gmail.com>
> ---
>
> Eryu,
>
> This change will cause the test to start running and failing on upstream
> kernel with overlayfs over some fs (e.g. xfs/ext4).
>
> The kernel fix is posted:
> https://lore.kernel.org/linux-fsdevel/20191111073000.2957-1-amir73il@gmail.com/T/#u

The patch seems ok to me.
Acked-by: Deepa Dinamani <deepa.kernel@gmail.com>
