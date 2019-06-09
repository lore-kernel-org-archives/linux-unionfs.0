MIME-Version: 1.0
Date: Sun, 9 Jun 2019 21:36:28 +0200
References: <20190608135717.8472-1-amir73il@gmail.com>
	<20190608135717.8472-2-amir73il@gmail.com>
In-Reply-To: <20190608135717.8472-2-amir73il@gmail.com>
Message-ID: <CAJfpegs9=W7BwqqBpTPgoXj5xaR=YMkDHLFM3pBaj8YLK-CwyQ@mail.gmail.com>
Subject: Re: [PATCH 1/2] vfs: replace i_readcount with a biased i_count
From: Miklos Szeredi <miklos@szeredi.hu>
Content-Type: text/plain; charset="UTF-8"
To: Amir Goldstein <amir73il@gmail.com>
Cc: "J . Bruce Fields" <bfields@fieldses.org>, Jeff Layton <jlayton@poochiereds.net>, Mimi Zohar <zohar@linux.ibm.com>, Al Viro <viro@zeniv.linux.org.uk>, linux-fsdevel@vger.kernel.org, overlayfs <linux-unionfs@vger.kernel.org>, linux-integrity <linux-integrity@vger.kernel.org>
List-ID: <linux-unionfs@vger.kernel.org>

On Sat, Jun 8, 2019 at 3:57 PM Amir Goldstein <amir73il@gmail.com> wrote:
>
> Count struct files open RO together with inode reference count instead
> of using a dedicated i_readcount field.  This will allow us to use the
> RO count also when CONFIG_IMA is not defined and will reduce the size of
> struct inode for 32bit archs when CONFIG_IMA is defined.
>
> We need this RO count for posix leases code, which currently naively
> checks i_count and d_count in an inaccurate manner.
>
> Should regular i_count overflow into RO count bias by struct files
> opened for write, it's not a big deal, as we mostly need the RO count
> to be reliable when the first writer comes along.
>
> Cc: <stable@vger.kernel.org> # v4.19
> Signed-off-by: Amir Goldstein <amir73il@gmail.com>
> ---
>  include/linux/fs.h                | 33 +++++++++++++++++++------------
>  security/integrity/ima/ima_main.c |  2 +-
>  2 files changed, 21 insertions(+), 14 deletions(-)
>
> diff --git a/include/linux/fs.h b/include/linux/fs.h
> index f7fdfe93e25d..504bf17967dd 100644
> --- a/include/linux/fs.h
> +++ b/include/linux/fs.h
> @@ -694,9 +694,6 @@ struct inode {
>         atomic_t                i_count;
>         atomic_t                i_dio_count;
>         atomic_t                i_writecount;
> -#ifdef CONFIG_IMA
> -       atomic_t                i_readcount; /* struct files open RO */
> -#endif
>         union {
>                 const struct file_operations    *i_fop; /* former ->i_op->default_file_ops */
>                 void (*free_inode)(struct inode *);
> @@ -2890,26 +2887,36 @@ static inline bool inode_is_open_for_write(const struct inode *inode)
>         return atomic_read(&inode->i_writecount) > 0;
>  }
>
> -#ifdef CONFIG_IMA
> +/*
> + * Count struct files open RO together with inode rerefernce count.
> + * We need this count for IMA and for posix leases. The RO count should not
> + * include files opened RDWR nor files opened O_PATH and internal kernel
> + * inode references, like the ones taken by overlayfs and inotify.
> + * Should regular i_count overflow into I_RO_COUNT_BIAS by struct files
> + * opened for write, it's not a big deal, as we mostly need
> + * inode_is_open_rdonly() to be reliable when the first writer comes along.

The bigger issue is allowing i_count to wrap around: all you need is a
file with 1025 hard links and 4194304 opens of said file.  Doable
without privileges?  Not sure, but it does seem pretty fragile.

BTW the current 32 bit i_readcount that IMA uses also has wraparound
issues, though that's not nearly as bad.

Going to a 64 bit i_count would fix these, I guess.

Thanks,
Miklos
