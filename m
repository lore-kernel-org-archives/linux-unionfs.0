From: Amir Goldstein <amir73il@gmail.com>
Subject: Re: [PATCH] ovl: add NULL check in ovl_alloc_inode
Date: Tue, 26 Sep 2017 07:06:49 +0300
Message-ID: <CAOQ4uxiEFEia8SS81gGvgvUsaW+91kStiNx06jsREA=icKgMRg@mail.gmail.com>
References: <20170925180953.10587-1-nklabs@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <stable-owner@vger.kernel.org>
In-Reply-To: <20170925180953.10587-1-nklabs@gmail.com>
Sender: stable-owner@vger.kernel.org
To: Hirofumi Nakagawa <nklabs@gmail.com>
Cc: overlayfs <linux-unionfs@vger.kernel.org>, Miklos Szeredi <miklos@szeredi.hu>, "stable [v4.13]" <stable@vger.kernel.org>
List-Id: linux-unionfs@vger.kernel.org

On Mon, Sep 25, 2017 at 9:09 PM, Hirofumi Nakagawa <nklabs@gmail.com> wrote:
> This was detected by fault injection test
>
> Signed-off-by: Hirofumi Nakagawa <nklabs@gmail.com>

Fixes: 13cf199d0088 ("ovl: allocate an ovl_inode struct")
Cc: <stable@vger.kernel.org> # v4.13


> ---
>  fs/overlayfs/super.c | 3 +++
>  1 file changed, 3 insertions(+)
>
> diff --git a/fs/overlayfs/super.c b/fs/overlayfs/super.c
> index fd5ea4facc62..701aa2f3536d 100644
> --- a/fs/overlayfs/super.c
> +++ b/fs/overlayfs/super.c
> @@ -174,6 +174,9 @@ static struct inode *ovl_alloc_inode(struct super_block *sb)
>  {
>         struct ovl_inode *oi = kmem_cache_alloc(ovl_inode_cachep, GFP_KERNEL);
>
> +       if (!oi)
> +               return NULL;
> +
>         oi->cache = NULL;
>         oi->redirect = NULL;
>         oi->version = 0;
> --
> 2.14.1
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-unionfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
