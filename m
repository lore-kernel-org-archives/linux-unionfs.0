MIME-Version: 1.0
In-Reply-To: <20180202152324.GA2721@redhat.com>
References: <20180202152324.GA2721@redhat.com>
Date: Mon, 26 Feb 2018 16:56:53 +0100
Message-ID: <CAJfpegtzZvU6V4ooZaZ2Ki3prFtFJ0tMDEm_vpANizFHaiYvZQ@mail.gmail.com>
Subject: Re: [PATCH] ovl: redirect_dir=nofollow should not follow redirect for
 opaque lower
From: Miklos Szeredi <miklos@szeredi.hu>
Content-Type: text/plain; charset="UTF-8"
To: Vivek Goyal <vgoyal@redhat.com>
Cc: overlayfs <linux-unionfs@vger.kernel.org>, Amir Goldstein <amir73il@gmail.com>
List-ID: <linux-unionfs@vger.kernel.org>

On Fri, Feb 2, 2018 at 4:23 PM, Vivek Goyal <vgoyal@redhat.com> wrote:
> redirect_dir=nofollow should not follow a redirect. But in a specific
> configuration it can still follow it.  For example try this.
>
> $ mkdir -p lower0 lower1/foo upper work merged
> $ touch lower1/foo/lower-file.txt
> $ setfattr -n "trusted.overlay.opaque" -v "y" lower1/foo
> $ mount -t overlay -o lowerdir=lower1:lower0,workdir=work,upperdir=upper,redirect_dir=on none merged
> $ cd merged
> $ mv foo foo-renamed
> $ umount merged
>
> # mount again. This time with redirect_dir=nofollow
> $ mount -t overlay -o lowerdir=lower1:lower0,workdir=work,upperdir=upper,redirect_dir=nofollow none merged
> $ ls merged/foo-renamed/
> # This lists lower-file.txt, while it should not have.
>
> Basically, we are doing redirect check after we check for d.stop. And
> if this is not last lower, and we find an opaque lower, d.stop will be
> set.
>
> ovl_lookup_single()
>         if (!d->last && ovl_is_opaquedir(this)) {
>                 d->stop = d->opaque = true;
>                 goto out;
>         }
>
> To fix this, first check redirect is allowed. And after that check if
> d.stop has been set or not.
>
> Signed-off-by: Vivek Goyal <vgoyal@redhat.com>

Thanks, applied.

Miklos
