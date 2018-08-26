Return-Path: <amir73il@gmail.com>
MIME-Version: 1.0
References: <1535300717-26686-1-git-send-email-amir73il@gmail.com>
 <1535300717-26686-6-git-send-email-amir73il@gmail.com> <CAJfpegvwndyAPEbrB2aSRJWkUXLCATEU_4qSbG6C_MzzMo6ybw@mail.gmail.com>
In-Reply-To: <CAJfpegvwndyAPEbrB2aSRJWkUXLCATEU_4qSbG6C_MzzMo6ybw@mail.gmail.com>
From: Amir Goldstein <amir73il@gmail.com>
Date: Mon, 27 Aug 2018 00:23:17 +0300
Message-ID: <CAOQ4uxhSz1fA_c8AjGXM5cYYqyfmdbADKdJgc4W1nQ_wjgi_nw@mail.gmail.com>
Subject: Re: [PATCH v2 5/6] vfs: fix fadvise64 syscall on an overlayfs file
Content-Type: text/plain; charset="UTF-8"
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: Al Viro <viro@zeniv.linux.org.uk>, Dave Chinner <david@fromorbit.com>, overlayfs <linux-unionfs@vger.kernel.org>, linux-fsdevel <linux-fsdevel@vger.kernel.org>
List-ID: <linux-unionfs@vger.kernel.org>

On Sun, Aug 26, 2018 at 10:30 PM Miklos Szeredi <miklos@szeredi.hu> wrote:
>
> On Sun, Aug 26, 2018 at 6:25 PM, Amir Goldstein <amir73il@gmail.com> wrote:
> > For an overlayfs file/inode, gage io is operating on the real underlying
> > file, so the readahead hints set by fadvise64() should also be set on the
> > real underlying file to take affect.
>
> Hmm, how about making this be an f_op?
>
> Would also fix readahead(2), which can be translated to fadvise(...,
> POSIX_FADV_WILLNEED).
>

Ok. I guess we could match readahead(2) semantics to an advise
for fs that implements f_op->advise(). Semantics are not currently
the same for the case of !mapping->a_ops->readpages, but they
are already the same (i.e. both return 0) for dax_mapping(mapping).

Thanks,
Amir.
