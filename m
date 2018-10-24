Return-Path: <amir73il@gmail.com>
MIME-Version: 1.0
References: <20180903061211.20830-1-amir73il@gmail.com> <20180903061211.20830-4-amir73il@gmail.com>
 <CAJfpegu-MVikDXiD3o1Lx8ZyAitFpMnB5kVp9neJneM84L8=aA@mail.gmail.com>
In-Reply-To: <CAJfpegu-MVikDXiD3o1Lx8ZyAitFpMnB5kVp9neJneM84L8=aA@mail.gmail.com>
From: Amir Goldstein <amir73il@gmail.com>
Date: Wed, 24 Oct 2018 20:56:43 +0300
Message-ID: <CAOQ4uxh43FidQ3c87QE0HFbXAkD8QSJGpLjm6BfTq4-dUSjzJw@mail.gmail.com>
Subject: Re: [PATCH 3/3] ovl: compact nested ovl_fh
Content-Type: text/plain; charset="UTF-8"
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: overlayfs <linux-unionfs@vger.kernel.org>
List-ID: <linux-unionfs@vger.kernel.org>

On Wed, Oct 24, 2018 at 5:34 PM Miklos Szeredi <miklos@szeredi.hu> wrote:
>
> On Mon, Sep 3, 2018 at 8:12 AM, Amir Goldstein <amir73il@gmail.com> wrote:
> > When encoding a file handle from lower nested overlayfs, prepending
> > another ovl_fh header for nested overlay file handle adds no new
> > information for decoding.  Instead, we just set a 'nested' flag in ovl_fh
> > header for nested file handle, so we know to distinguish between real
> > upper file handle that should be decoded from real upper layer and
> > nested upper file handle that should be decoded from nested lower layer.
> > For the maximum allowed overlay nesting depth of 1, one bit is enough.
>
> This is an optimization, right?
>

Optimization was not my motivation.
It started off as a patch to enable NFS export for nested overlay,
which I needed for snapshots, but then I relaxed uuid requirement
and nested overlay NFS export just worked (I think - need to re-check)
Then it felt a bit silly to double encode, so posted this patch with its
current title, because it did not change functionality anymore, but...

> What are the user-visible advantages that would justify the added complexity?
>

...When you put it this way, it's really hard to justify the patch on its own.
One thing that comes to mind w.r.t. advantages of compact
representation of ovl_fh
is in-inode xattrs space, but that is quite a far fetched justification.
If we wanted more compact xattrs we should have started with shorter names...

So feel free to drop this patch.
If I ever come with a better reason, I will re-post it.

Thanks,
Amir.
