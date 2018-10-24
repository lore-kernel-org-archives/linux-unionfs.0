MIME-Version: 1.0
In-Reply-To: <20180903061211.20830-4-amir73il@gmail.com>
References: <20180903061211.20830-1-amir73il@gmail.com>
	<20180903061211.20830-4-amir73il@gmail.com>
Date: Wed, 24 Oct 2018 16:34:56 +0200
Message-ID: <CAJfpegu-MVikDXiD3o1Lx8ZyAitFpMnB5kVp9neJneM84L8=aA@mail.gmail.com>
Subject: Re: [PATCH 3/3] ovl: compact nested ovl_fh
From: Miklos Szeredi <miklos@szeredi.hu>
Content-Type: text/plain; charset="UTF-8"
To: Amir Goldstein <amir73il@gmail.com>
Cc: overlayfs <linux-unionfs@vger.kernel.org>
List-ID: <linux-unionfs@vger.kernel.org>

On Mon, Sep 3, 2018 at 8:12 AM, Amir Goldstein <amir73il@gmail.com> wrote:
> When encoding a file handle from lower nested overlayfs, prepending
> another ovl_fh header for nested overlay file handle adds no new
> information for decoding.  Instead, we just set a 'nested' flag in ovl_fh
> header for nested file handle, so we know to distinguish between real
> upper file handle that should be decoded from real upper layer and
> nested upper file handle that should be decoded from nested lower layer.
> For the maximum allowed overlay nesting depth of 1, one bit is enough.

This is an optimization, right?

What are the user-visible advantages that would justify the added complexity?

Thanks,
Miklos
