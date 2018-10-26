MIME-Version: 1.0
In-Reply-To: <20181006061009.8150-1-amir73il@gmail.com>
References: <20181006061009.8150-1-amir73il@gmail.com>
Date: Fri, 26 Oct 2018 16:41:42 +0200
Message-ID: <CAJfpegvWL9c4MYFr29DgsrkDg9V+wB2k7+e=n7pPXFPo6gWw0g@mail.gmail.com>
Subject: Re: [PATCH] ovl: disable new features for deprecated upper fs
From: Miklos Szeredi <miklos@szeredi.hu>
Content-Type: text/plain; charset="UTF-8"
To: Amir Goldstein <amir73il@gmail.com>
Cc: overlayfs <linux-unionfs@vger.kernel.org>
List-ID: <linux-unionfs@vger.kernel.org>

On Sat, Oct 6, 2018 at 8:10 AM, Amir Goldstein <amir73il@gmail.com> wrote:
> Overlayfs works sub-optimally with upper fs that has no
> xattr/d_type/O_TMPFILE support. We should basically deprecate
> support for those filesystems, but so far, we only issue a warning
> and don't fail the mount for the sake of backward compat.
> Some features are already being disabled with no xattr support.
>
> Such configurations, if they exist in the wild at all, get very
> little to no testing coverage for new features, so disable all new
> features for all of these untested configurations.
>
> For example, when upper fs is created with mkfs.xfs -m crc=0 -n ftype=0
> and all overlayfs features are enalbed by default, mount emits the
> following warnings:
>
>  overlayfs: upper fs needs to support d_type.
>  ...upper fs missing required features, falling back to redirect_dir=off.
>  ...upper fs missing required features, falling back to index=off.
>  ...upper fs missing required features, falling back to xino=off.
>  ...upper fs missing required features, falling back to metacopy=off.
>  ...NFS export requires "index=on", falling back to nfs_export=off.
>
> [backport hint: The new features started rolling in since kernel v4.10
>  so different stable kernels will need different versions of this patch]

I do not have good feelings about this patch.  At least a little more
analysis about what are the requirements of each overlay feature would
be good.

Also, disabling a feature instead of failing the mount is not always
the right answer, as Vivek's recent report pointed out.   Maybe the
best thing would be for metacopy to simply fail if there are no
xattrs.   The others are a bit more risky to change because of
possible backward compatibility failures.

Not getting enough testing is not a valid reason to disable a feature.
We could allow artificially disabling xattr or tmpfile with an overlay
mount option to allow testing these cases (possibly gated with a
kernel config option to not let ordinary users mess with such testing
options).

For now I'll just reduce the scope of this patch to only disable those
features where it obviously makes no sense without xattr.

Not sure if tmpfile is actually required by any feature?

Thanks,
Miklos
