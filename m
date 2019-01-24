Return-Path: <amir73il@gmail.com>
MIME-Version: 1.0
References: <20190122123457.10600-1-amir73il@gmail.com>
In-Reply-To: <20190122123457.10600-1-amir73il@gmail.com>
From: Amir Goldstein <amir73il@gmail.com>
Date: Thu, 24 Jan 2019 19:18:22 +0200
Message-ID: <CAOQ4uxhj4X03c43fy2WuOgG7q3ztC=wdw5pBod778d-B5dKmAA@mail.gmail.com>
Subject: Re: [RFC][PATCH v2 0/5] Experiments with overlayfs filemap
Content-Type: text/plain; charset="UTF-8"
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: Vivek Goyal <vgoyal@redhat.com>, cgxu519 <cgxu519@gmx.com>, overlayfs <linux-unionfs@vger.kernel.org>
List-ID: <linux-unionfs@vger.kernel.org>

>
> Can you please point me in the direction of how to implement proper
> aops? Or better yet, send me a demo patch?
> I figure we need to call vfs_iter_read/vfs_iter_write of real file
> with IOCB_DIRECT for page io? But I am very uncertain about locking
> order requirements and whether there is already some infrastructure
> that we can use (some splice variant)?
>
> Any other thoughts?
>

Miklos,

I've made a small progress.

Pushed two more commits to ovl-lazy-copyup-wip:
ea9a0083d1ed - ovl: readahead upper inode page cache on overlay page fault
d1ff6e6366d5 - ovl: implement overlay stacked readpage

That implements readpage by reading and copying from upper page cache.

With that change, the basic unionmount test on tmpfs passes.
With unionmount over xfs, tests fail because partial page write
is not working correctly, although mmap partial write works well.

I will try to follow similar pattern to implement writepage by copy to
upper page cache.

Let me know if you think I am going in the wrong direction.

Thanks,
Amir.
