Return-Path: <amir73il@gmail.com>
MIME-Version: 1.0
In-Reply-To: <20180426191013.13219-29-vgoyal@redhat.com>
References: <20180426191013.13219-1-vgoyal@redhat.com> <20180426191013.13219-29-vgoyal@redhat.com>
From: Amir Goldstein <amir73il@gmail.com>
Date: Sat, 28 Apr 2018 02:28:20 -0700
Message-ID: <CAOQ4uxgP0VA5KHoX68ncD=bS55Qkhk93j7kPEeSg3Xo_HNkWsA@mail.gmail.com>
Subject: Re: [PATCH v14 28/31] ovl: Disbale metacopy for MAP_SHARED mmap()
Content-Type: text/plain; charset="UTF-8"
To: Vivek Goyal <vgoyal@redhat.com>
Cc: overlayfs <linux-unionfs@vger.kernel.org>, Miklos Szeredi <miklos@szeredi.hu>
List-ID: <linux-unionfs@vger.kernel.org>

On Thu, Apr 26, 2018 at 12:10 PM, Vivek Goyal <vgoyal@redhat.com> wrote:
> When user chose the option of copying up a file when mmap(MAP_SHARED)
> happens, then do full copy up and not just metacopy.
>
> Signed-off-by: Vivek Goyal <vgoyal@redhat.com>

Reviewed-by: Amir Goldstein <amir73il@gmail.com>

+ nit

> ---
>  fs/overlayfs/file.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/fs/overlayfs/file.c b/fs/overlayfs/file.c
> index be531b79d2e5..d61c8355b892 100644
> --- a/fs/overlayfs/file.c
> +++ b/fs/overlayfs/file.c
> @@ -304,7 +304,7 @@ static int ovl_pre_mmap(struct file *file, unsigned long prot,
>          * later.
>          */
>         if ((flag & MAP_SHARED) && ovl_copy_up_shared(file_inode(file)->i_sb))
> -               err = ovl_copy_up(file_dentry(file));
> +               err = ovl_copy_up_flags(file_dentry(file), O_WRONLY);

Either add comment or use wrapper ovl_full_copy_up().

Thanks,
Amir.
