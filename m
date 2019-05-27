MIME-Version: 1.0
Date: Mon, 27 May 2019 10:04:11 +0200
References: <20190526062825.23059-1-amir73il@gmail.com>
In-Reply-To: <20190526062825.23059-1-amir73il@gmail.com>
Message-ID: <CAJfpegvsN4qUXOpRGwv-0PkE8tjy6dGNCtekfbFaJviiDQd8Xg@mail.gmail.com>
Subject: Re: [PATCH] ovl: support the FS_IOC_FS[SG]ETXATTR ioctls
From: Miklos Szeredi <miklos@szeredi.hu>
Content-Type: text/plain; charset="UTF-8"
To: Amir Goldstein <amir73il@gmail.com>
Cc: Dave Chinner <david@fromorbit.com>, overlayfs <linux-unionfs@vger.kernel.org>, linux-xfs <linux-xfs@vger.kernel.org>
List-ID: <linux-unionfs@vger.kernel.org>

On Sun, May 26, 2019 at 8:28 AM Amir Goldstein <amir73il@gmail.com> wrote:
>
> They are the extended version of FS_IOC_FS[SG]ETFLAGS ioctls.
> xfs_io -c "chattr <flags>" uses the new ioctls for setting flags.
>
> This used to work in kernel pre v4.19, before stacked file ops
> introduced the ovl_ioctl whitelist.
>
> Reported-by: Dave Chinner <david@fromorbit.com>
> Fixes: d1d04ef8572b ("ovl: stack file ops")
> Cc: <stable@vger.kernel.org> # v4.19
> Signed-off-by: Amir Goldstein <amir73il@gmail.com>

Thanks,  applied.

Miklos
