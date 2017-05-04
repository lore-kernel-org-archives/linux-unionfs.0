From: Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH v2 2/8] xfs: re-define uuid_t as common struct uuid_v1
Date: Thu, 4 May 2017 15:34:17 +0200
Message-ID: <20170504133417.GD17222@lst.de>
References: <1493904383-2187-1-git-send-email-amir73il@gmail.com> <1493904383-2187-3-git-send-email-amir73il@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-fsdevel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1493904383-2187-3-git-send-email-amir73il@gmail.com>
Sender: linux-fsdevel-owner@vger.kernel.org
To: Amir Goldstein <amir73il@gmail.com>
Cc: "Darrick J . Wong" <darrick.wong@oracle.com>, Christoph Hellwig <hch@lst.de>, Miklos Szeredi <miklos@szeredi.hu>, Theodore Tso <tytso@mit.edu>, Richard Weinberger <richard@nod.at>, Mark Fasheh <mfasheh@versity.com>, Dan Williams <dan.j.williams@intel.com>, Andy Shevchenko <andriy.shevchenko@linux.intel.com>, David Howells <dhowells@redhat.com>, Shaohua Li <shli@kernel.org>, Al Viro <viro@zeniv.linux.org.uk>, linux-xfs@vger.kernel.org, linux-unionfs@vger.kernel.org, linux-fsdevel@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org

On Thu, May 04, 2017 at 04:26:17PM +0300, Amir Goldstein wrote:
> xfs was defining a non namespaced type named uuid_t and for no good
> reason. xfs code doesn't care about the internals of uuid_t struct -
> it only cares about its size.
> 
> Re-define uuid_t as the common struct uuid_v1 in include/linux/uuid.h
> and get rid of the xfs private definition.

I'm not sure this really is a good idea.  uuid_v1 currently is only
used by afs.  I'd much rather switch both afs and xfs to use the
uuid_be type (which might as well grow the standard uuid_t name while
we're at it), and use accessors that do the byte-array access for
the very few places that care about the interpretation.

There is some more fallou from this, e.g. generate_random_uuid
should also take a uuid_be (and maybe renamed to uuid_generate_random).
