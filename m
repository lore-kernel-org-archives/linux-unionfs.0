Return-Path: <eddiehorng.tw@gmail.com>
MIME-Version: 1.0
From: Eddie Horng <eddiehorng.tw@gmail.com>
Date: Wed, 14 Mar 2018 16:42:23 +0800
Message-ID: <CALLuPvpczs-UiDkoHURAu7weCHJCv9U6xKxDKck=5U85T55ukw@mail.gmail.com>
Subject: readdir returns d_type=DT_UNKNOWN to overlay exported dir (NFSv3)
Content-Type: text/plain; charset="UTF-8"
To: Jeff Layton <jlayton@kernel.org>
Cc: Amir Goldstein <amir73il@gmail.com>, Miklos Szeredi <miklos@szeredi.hu>, overlayfs <linux-unionfs@vger.kernel.org>, Trond Myklebust <trondmy@primarydata.com>, "J. Bruce Fields" <bfields@fieldses.org>
List-ID: <linux-unionfs@vger.kernel.org>

Hi Amir,
Since the flock issue is clarified, I would like to start this new
thread to discuss if we can find the cause of d_type=DT_UNKNOWN. First
of all I tried rdirplus and nordirplus mount option but got no
difference. Then I roughly trace call flow of nfs3_decode_dirent( ) as
below:

decode_fattr3()
    fattr->mode = (be32_to_cpup(p++) & ~S_IFMT) | fmode;
    fattr->valid |= NFS_ATTR_FATTR_V3;

decode_post_op_attr()
    p = xdr_inline_decode(xdr, 4);
    if (*p != xdr_zero)
       return decode_fattr3(xdr, fattr);

nfs3_decode_dirent()
    entry->d_type = DT_UNKNOWN;
    if (entry->fattr->valid & NFS_ATTR_FATTR_V3)
        entry->d_type = nfs_umode_to_dtype(entry->fattr->mode);

In overlay exported case, decode_post_op_attr hits *p==xdr_zero, so
decode_fattr3 is not called, then d_type reamins DT_UNKNOWN in
nfs3_decode_dirent. It seems nfs4_decode_dirent has very different way
to decode file attr and maybe the xdr layout is quite different as
well.I have not idea about how the xdr to be filled from overlay and
nfsd's output. Could some of you master give a hint?

thanks,
Eddie
