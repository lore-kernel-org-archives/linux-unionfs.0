MIME-Version: 1.0
Date: Fri, 13 Dec 2019 13:22:10 +0100
References: <20191213103705.iurz35cawvp6w46w@kili.mountain>
In-Reply-To: <20191213103705.iurz35cawvp6w46w@kili.mountain>
Message-ID: <CAJfpegv1d=XRcqD0yJpobP2j3F+gBbKhmJ2mUzwq33s=4gD4Bw@mail.gmail.com>
Subject: Re: [bug report] ovl: make sure that real fid is 32bit aligned in memory
From: Miklos Szeredi <miklos@szeredi.hu>
Content-Type: text/plain; charset="UTF-8"
To: Dan Carpenter <dan.carpenter@oracle.com>
Cc: Amir Goldstein <amir73il@gmail.com>, overlayfs <linux-unionfs@vger.kernel.org>
List-ID: <linux-unionfs@vger.kernel.org>

On Fri, Dec 13, 2019 at 11:38 AM Dan Carpenter <dan.carpenter@oracle.com> wrote:
>
> Hello Amir Goldstein,
>
> This is a semi-automatic email about new static checker warnings.
>
> The patch cbe7fba8edfc: "ovl: make sure that real fid is 32bit
> aligned in memory" from Nov 15, 2019, leads to the following Smatch
> complaint:
>
>     fs/overlayfs/copy_up.c:338 ovl_set_origin()
>      warn: variable dereferenced before check 'fh' (see line 337)
>
> fs/overlayfs/copy_up.c
>    336           */
>    337          err = ovl_check_setxattr(dentry, upper, OVL_XATTR_ORIGIN, fh->buf,
>                                                                           ^^^^^^^
> The patch adds an unconditional dereference

But in fact fh->buf is not a dereference:

struct ovl_fh {
    u8 padding[3];    /* make sure fb.fid is 32bit aligned */
    union {
        struct ovl_fb fb;
        u8 buf[0];
    };
} __packed;

Subsequent code will also not dereference fh->buf, because the
supplied size is zero.

Thanks,
Miklos
