Return-Path: <linux-unionfs-owner@vger.kernel.org>
Received: from mail-yw0-f196.google.com ([209.85.161.196]:36299 "EHLO
        mail-yw0-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751240AbeECT5K (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Thu, 3 May 2018 15:57:10 -0400
MIME-Version: 1.0
In-Reply-To: <20180503152635.14974-4-rgoldwyn@suse.de>
References: <20180503152635.14974-1-rgoldwyn@suse.de> <20180503152635.14974-4-rgoldwyn@suse.de>
From: Amir Goldstein <amir73il@gmail.com>
Date: Thu, 3 May 2018 22:57:09 +0300
Message-ID: <CAOQ4uxhjhds4avkGBTHsqLp72nWjP=mAFPtxmUarcF1-jp89ng@mail.gmail.com>
Subject: Re: [PATCH 3/3] ovl: Use splice_with_holes in copy_up
Content-Type: text/plain; charset="UTF-8"
Sender: linux-unionfs-owner@vger.kernel.org
To: Goldwyn Rodrigues <rgoldwyn@suse.de>
Cc: linux-fsdevel <linux-fsdevel@vger.kernel.org>, Christoph Hellwig <hch@lst.de>, Steve French <smfrench@gmail.com>, overlayfs <linux-unionfs@vger.kernel.org>, Anna Schumaker <Anna.Schumaker@netapp.com>, "Darrick J. Wong" <darrick.wong@oracle.com>, Goldwyn Rodrigues <rgoldwyn@suse.com>, Dave Chinner <david@fromorbit.com>
List-ID: <linux-unionfs@vger.kernel.org>

On Thu, May 3, 2018 at 6:26 PM, Goldwyn Rodrigues <rgoldwyn@suse.de> wrote:
> From: Goldwyn Rodrigues <rgoldwyn@suse.com>
>
> Signed-off-by: Goldwyn Rodrigues <rgoldwyn@suse.com>
> ---
>  fs/overlayfs/copy_up.c |  2 +-
>  fs/read_write.c        | 10 ++++++----
>  include/linux/fs.h     |  2 ++
>  3 files changed, 9 insertions(+), 5 deletions(-)
>
> diff --git a/fs/overlayfs/copy_up.c b/fs/overlayfs/copy_up.c
> index 8bede0742619..6634a85255ae 100644
> --- a/fs/overlayfs/copy_up.c
> +++ b/fs/overlayfs/copy_up.c
> @@ -175,7 +175,7 @@ static int ovl_copy_up_data(struct path *old, struct path *new, loff_t len)
>                         break;
>                 }
>
> -               bytes = do_splice_direct(old_file, &old_pos,
> +               bytes = splice_with_holes(old_file, &old_pos,
>                                          new_file, &new_pos,
>                                          this_len, SPLICE_F_MOVE);


Add.. you can remove this comment above :)
        /* FIXME: copy up sparse files efficiently */

For the record, when I added vfs_clone_file_range() above,
Dave Chinner has suggested to replace the entire block with
vfs_copy_file_range(), which would do all the fallbacks.
Since then, vfs_copy_file_range() gained "try to clone first".

There are still differences between the loop in this function and
the loop in vfs_copy_file_range(). Perhaps the differences could
be smoothed away, I did not check recently.

I am not asking that you do this as part of your work, simply
pointing out an opportunity.

Thanks,
Amir.
