Return-Path: <amir73il@gmail.com>
MIME-Version: 1.0
In-Reply-To: <20180426191013.13219-31-vgoyal@redhat.com>
References: <20180426191013.13219-1-vgoyal@redhat.com> <20180426191013.13219-31-vgoyal@redhat.com>
From: Amir Goldstein <amir73il@gmail.com>
Date: Sat, 28 Apr 2018 01:31:18 -0700
Message-ID: <CAOQ4uxjkSrczVOoxrBhTEwFpip_dK2ipvU_ZGgP_9hbgZQdwiA@mail.gmail.com>
Subject: Re: [PATCH v14 30/31] ovl: Do not do metacopy only for ioctl
 modifying file attr
Content-Type: text/plain; charset="UTF-8"
To: Vivek Goyal <vgoyal@redhat.com>
Cc: overlayfs <linux-unionfs@vger.kernel.org>, Miklos Szeredi <miklos@szeredi.hu>
List-ID: <linux-unionfs@vger.kernel.org>

On Thu, Apr 26, 2018 at 12:10 PM, Vivek Goyal <vgoyal@redhat.com> wrote:
> ovl_copy_up() by default will only do metadata only copy up (if enabled).
> That means when ovl_real_ioctl() calls ovl_real_file(), it will still
> get the lower file (as ovl_real_file() opens data file and not metacopy).
> And that means "chattr +i" will end up modifying lower inode.
>
> There seem to be two ways to solve this.
> A. Open metacopy file in ovl_real_ioctl() and do operations on that
> B. Force full copy up when FS_IOC_SETFLAGS is called.
>
> I am resorting to option B for now as it feels little safer option. If
> there are performance issues due to this, we can revisit it.

I agree with your choice. This doesn't seem like a performance
sensitive use case, so simplicity is better.

>
> Signed-off-by: Vivek Goyal <vgoyal@redhat.com>

Reviewed-by: Amir Goldstein <amir73il@gmail.com>

+ nit

> ---
>  fs/overlayfs/file.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/fs/overlayfs/file.c b/fs/overlayfs/file.c
> index d61c8355b892..9a9efaac71f4 100644
> --- a/fs/overlayfs/file.c
> +++ b/fs/overlayfs/file.c
> @@ -397,7 +397,7 @@ long ovl_ioctl(struct file *file, unsigned int cmd, unsigned long arg)
>                 if (ret)
>                         return ret;
>
> -               ret = ovl_copy_up(file_dentry(file));
> +               ret = ovl_copy_up_flags(file_dentry(file), O_WRONLY);

2 options: either add a comment or a wrapper with meaningful name like
ovl_copy_up_with_data.

Thanks,
Amir.
