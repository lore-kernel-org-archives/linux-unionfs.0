Return-Path: <amir73il@gmail.com>
MIME-Version: 1.0
In-Reply-To: <CALLuPvpczs-UiDkoHURAu7weCHJCv9U6xKxDKck=5U85T55ukw@mail.gmail.com>
References: <CALLuPvpczs-UiDkoHURAu7weCHJCv9U6xKxDKck=5U85T55ukw@mail.gmail.com>
From: Amir Goldstein <amir73il@gmail.com>
Date: Wed, 14 Mar 2018 11:56:08 +0200
Message-ID: <CAOQ4uxizXWsXLuFXi6Eh7Yzv84pf2_i7=UwpVSm7PfgdA=25vQ@mail.gmail.com>
Subject: Re: readdir returns d_type=DT_UNKNOWN to overlay exported dir (NFSv3)
Content-Type: text/plain; charset="UTF-8"
To: Eddie Horng <eddiehorng.tw@gmail.com>
Cc: Jeff Layton <jlayton@kernel.org>, Miklos Szeredi <miklos@szeredi.hu>, overlayfs <linux-unionfs@vger.kernel.org>, Trond Myklebust <trondmy@primarydata.com>, "J. Bruce Fields" <bfields@fieldses.org>
List-ID: <linux-unionfs@vger.kernel.org>

On Wed, Mar 14, 2018 at 10:42 AM, Eddie Horng <eddiehorng.tw@gmail.com> wrote:
> Hi Amir,
> Since the flock issue is clarified, I would like to start this new
> thread to discuss if we can find the cause of d_type=DT_UNKNOWN. First

Can you provide a simple reproducer? Is DT_UNKNOWN always the case
in readdir or only in lower/upper/merged directories? for all entries?

> of all I tried rdirplus and nordirplus mount option but got no
> difference. Then I roughly trace call flow of nfs3_decode_dirent( ) as
> below:
>
> decode_fattr3()
>     fattr->mode = (be32_to_cpup(p++) & ~S_IFMT) | fmode;
>     fattr->valid |= NFS_ATTR_FATTR_V3;
>
> decode_post_op_attr()
>     p = xdr_inline_decode(xdr, 4);
>     if (*p != xdr_zero)
>        return decode_fattr3(xdr, fattr);
>
> nfs3_decode_dirent()
>     entry->d_type = DT_UNKNOWN;
>     if (entry->fattr->valid & NFS_ATTR_FATTR_V3)
>         entry->d_type = nfs_umode_to_dtype(entry->fattr->mode);
>
> In overlay exported case, decode_post_op_attr hits *p==xdr_zero, so
> decode_fattr3 is not called, then d_type reamins DT_UNKNOWN in
> nfs3_decode_dirent. It seems nfs4_decode_dirent has very different way
> to decode file attr and maybe the xdr layout is quite different as
> well.I have not idea about how the xdr to be filled from overlay and
> nfsd's output. Could some of you master give a hint?
>

Thanks for the detailed analysis.
Seems like server side sets the post op attr in encode_post_op_attr()
probably from nfs3svc_encode_readdirres(). There is a comment
above encode_post_op_attr() that I don't fully understand and not sure
why that would happen in overlayfs.

If you can perform similar tracing on server side and point us at where
the overlay and non-overlay flows diverge this would be helpful.

I also recommend testing with v4.16-rc5, which has some overlayfs NFS
export fixes, although, I am not sure how any of those fixes map to the
problem you reported and I didn't have time to test your report myself yet.

Thanks,
Amir.
