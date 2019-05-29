Return-Path: <amir73il@gmail.com>
MIME-Version: 1.0
References: <20190529103120.GA15021@mwanda>
In-Reply-To: <20190529103120.GA15021@mwanda>
From: Amir Goldstein <amir73il@gmail.com>
Date: Wed, 29 May 2019 13:42:54 +0300
Message-ID: <CAOQ4uxjZi-XF17+GT1iQYEHmr18AiZpTjL1M_HhGPaLhtSvBxQ@mail.gmail.com>
Subject: Re: [bug report] ovl: detect overlapping layers
Content-Type: text/plain; charset="UTF-8"
To: Dan Carpenter <dan.carpenter@oracle.com>, Miklos Szeredi <miklos@szeredi.hu>
Cc: overlayfs <linux-unionfs@vger.kernel.org>
List-ID: <linux-unionfs@vger.kernel.org>

On Wed, May 29, 2019 at 1:31 PM Dan Carpenter <dan.carpenter@oracle.com> wrote:
>
> Hello Amir Goldstein,
>
> The patch 0e7f2cccb42a: "ovl: detect overlapping layers" from Apr 18,
> 2019, leads to the following static checker warning:
>
>         fs/overlayfs/super.c:998 ovl_setup_trap()
>         warn: passing a valid pointer to 'PTR_ERR'
>
> fs/overlayfs/super.c
>    991  static int ovl_setup_trap(struct super_block *sb, struct dentry *dir,
>    992                            struct inode **ptrap, const char *name)
>    993  {
>    994          struct inode *trap;
>    995          int err;
>    996
>    997          trap = ovl_get_trap_inode(sb, dir);
>    998          err = PTR_ERR(trap);
>    999          if (IS_ERR(trap) && err == -ELOOP) {
>   1000                  pr_err("overlayfs: conflicting %s path\n", name);
>   1001                  return err;
>   1002          }
>   1003
>   1004          *ptrap = trap;
>   1005          return 0;
>   1006  }
>
> The warning message is wrong but the code is also wrong.  The
> ovl_get_trap_inode() can return ERR_PTR(-ENOMEM) and that would lead to
> and Oops when we try to call iput() on it.
>

Right, thank you for spotting this!

Miklos,

Can you fold in this fix:

Thanks,
Amir.

--- a/fs/overlayfs/super.c
+++ b/fs/overlayfs/super.c
@@ -996,8 +996,9 @@ static int ovl_setup_trap(struct super_block *sb,
struct dentry *dir,

        trap = ovl_get_trap_inode(sb, dir);
        err = PTR_ERR(trap);
-       if (IS_ERR(trap) && err == -ELOOP) {
-               pr_err("overlayfs: conflicting %s path\n", name);
+       if (IS_ERR(trap)) {
+               if (err == -ELOOP)
+                       pr_err("overlayfs: conflicting %s path\n", name);
                return err;
        }
