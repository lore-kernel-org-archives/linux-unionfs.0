MIME-Version: 1.0
Date: Thu, 22 Nov 2018 15:45:07 +0100
References: <20181105055010.19511-1-amir73il@gmail.com>
In-Reply-To: <20181105055010.19511-1-amir73il@gmail.com>
Message-ID: <CAJfpegvbThWobvfmvk=_=tJ=0Csk-t-nOWFbmY=6EfNwD9tw+Q@mail.gmail.com>
Subject: Re: [PATCH] ovl: fix decode of dir file handle with multi lower layers
From: Miklos Szeredi <miklos@szeredi.hu>
Content-Type: text/plain; charset="UTF-8"
To: Amir Goldstein <amir73il@gmail.com>
Cc: overlayfs <linux-unionfs@vger.kernel.org>
List-ID: <linux-unionfs@vger.kernel.org>

On Mon, Nov 5, 2018 at 6:50 AM Amir Goldstein <amir73il@gmail.com> wrote:
>
> When decoding a lower file handle, we first call ovl_check_origin_fh()
> with connected=false to get any real lower dentry for overlay inode
> cache lookup.
>
> If the real dentry is a disconnected dir dentry, ovl_check_origin_fh()
> is called again with connected=true to get a connected real dentry
> and find the lower layer the real dentry belongs to.
>
> If the first call returned a connected real dentry, we use it to
> lookup an overlay connected dentry, but the first ovl_check_origin_fh()
> call with connected=false did not check that the found dentry is under
> the root of the layer (see ovl_acceptable()), it only checked that
> the found dentry super block matches the uuid of the lower file handle.
>
> In case there are multiple lower layers on the same fs and the found
> dentry is not from the top most lower layer, using the layer index
> returned from the first ovl_check_origin_fh() is wrong and we end
> up failing to decode the file handle.
>
> Fix this by always calling ovl_check_origin_fh() with connected=true
> if we got a directory dentry in the first call.

Hi Amir,

Does this have a testcase?

Thanks,
Miklos
