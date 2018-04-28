Return-Path: <amir73il@gmail.com>
MIME-Version: 1.0
In-Reply-To: <20180426191013.13219-23-vgoyal@redhat.com>
References: <20180426191013.13219-1-vgoyal@redhat.com> <20180426191013.13219-23-vgoyal@redhat.com>
From: Amir Goldstein <amir73il@gmail.com>
Date: Sat, 28 Apr 2018 02:14:12 -0700
Message-ID: <CAOQ4uxj3p87gDa=OJgy8HmAaPoq9m2BNz3rBJoFJwxcCP+n2hw@mail.gmail.com>
Subject: Re: [PATCH v14 22/31] ovl: Do not set dentry type ORIGIN for broken hardlinks
Content-Type: text/plain; charset="UTF-8"
To: Vivek Goyal <vgoyal@redhat.com>
Cc: overlayfs <linux-unionfs@vger.kernel.org>, Miklos Szeredi <miklos@szeredi.hu>
List-ID: <linux-unionfs@vger.kernel.org>

On Thu, Apr 26, 2018 at 12:10 PM, Vivek Goyal <vgoyal@redhat.com> wrote:
> If a dentry has copy up origin, we set flag OVL_PATH_ORIGIN. So far
> this decision was easy that we had to check only for oe->numlower
> and if it is non-zero, we knew there is copy up origin. (For non-dir
> we installed origin dentry in lowerstack[0]).
>
> But we don't create ORGIN xattr for broken hardlinks (index=off). And
> with metacopy feature it is possible that we will install lowerstack[0]
> but ORIGIN xattr is not there. It is data dentry of upper metacopy dentry
> which has been found using regular name based lookup or using REDIRECT.
> So with addition of this new case, just presence of oe->numlower is
> not sufficient to guarantee that ORIGIN xattr is present.
>
> So two differentiate between two cases, look at OVL_CONST_INO flag. If

typo: to differentiate..

> this flag is set and upperdentry is there, that means ORIGIN xattr
> must be present.


This statement is not accurate. For dir we set OVL_CONST_INO
regardless of of ORIGIN xattr, but that is ok because dir is not
a broken hardlink...

> OVL_CONST_INO is not set if lower hardlink is broken
> or will be broken over copy up.
>
> Signed-off-by: Vivek Goyal <vgoyal@redhat.com>

Reviewed-by: Amir Goldstein <amir73il@gmail.com>

> ---
>  fs/overlayfs/util.c | 3 ++-
>  1 file changed, 2 insertions(+), 1 deletion(-)
>
> diff --git a/fs/overlayfs/util.c b/fs/overlayfs/util.c
> index f85ff5714852..69acce1c9026 100644
> --- a/fs/overlayfs/util.c
> +++ b/fs/overlayfs/util.c
> @@ -133,7 +133,8 @@ enum ovl_path_type ovl_path_type(struct dentry *dentry)
>                  * Non-dir dentry can hold lower dentry of its copy up origin.
>                  */
>                 if (oe->numlower) {
> -                       type |= __OVL_PATH_ORIGIN;
> +                       if (ovl_test_flag(OVL_CONST_INO, d_inode(dentry)))
> +                               type |= __OVL_PATH_ORIGIN;
>                         if (d_is_dir(dentry) ||
>                             !ovl_has_upperdata(d_inode(dentry)))
>                                 type |= __OVL_PATH_MERGE;
> --
> 2.13.6
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-unionfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
