From: Miklos Szeredi <miklos@szeredi.hu>
Subject: Re: [PATCH 06/10] ovl: force read-only mount with no index dir
Date: Thu, 13 Jul 2017 22:11:54 +0200
Message-ID: <CAJfpegsz3ZzMQNBY8sDtAoAxGmUQ_ai2f32hMTdXEZ4URzvj7w@mail.gmail.com>
References: <1499777923-29410-1-git-send-email-amir73il@gmail.com> <1499777923-29410-7-git-send-email-amir73il@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-unionfs-owner@vger.kernel.org>
Received: from mail-oi0-f68.google.com ([209.85.218.68]:33588 "EHLO
        mail-oi0-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752757AbdGMUL4 (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Thu, 13 Jul 2017 16:11:56 -0400
Received: by mail-oi0-f68.google.com with SMTP id f134so7965528oig.0
        for <linux-unionfs@vger.kernel.org>; Thu, 13 Jul 2017 13:11:55 -0700 (PDT)
In-Reply-To: <1499777923-29410-7-git-send-email-amir73il@gmail.com>
Sender: linux-unionfs-owner@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org
To: Amir Goldstein <amir73il@gmail.com>
Cc: "linux-unionfs@vger.kernel.org" <linux-unionfs@vger.kernel.org>

On Tue, Jul 11, 2017 at 2:58 PM, Amir Goldstein <amir73il@gmail.com> wrote:
> When workdir creation fails, overlay is mounted read-only and
> remount,rw is not allowed. When index dir creation fails, overlay
> is mounted readonly, but we also need to enforce no remount,rw in
> that case.

I don't understand the logic for ovl_show_options().  It should show
the options supplied, right?  It doesn't currently do that for
"index=FOO" but this patch doesn't help that, afaics.

Thanks,
Miklos

>
> Signed-off-by: Amir Goldstein <amir73il@gmail.com>
> ---
>  fs/overlayfs/super.c | 11 ++++-------
>  1 file changed, 4 insertions(+), 7 deletions(-)
>
> diff --git a/fs/overlayfs/super.c b/fs/overlayfs/super.c
> index 6381e71b0d5d..215b6d23d944 100644
> --- a/fs/overlayfs/super.c
> +++ b/fs/overlayfs/super.c
> @@ -274,7 +274,8 @@ static int ovl_statfs(struct dentry *dentry, struct kstatfs *buf)
>  /* Will this overlay be forced to mount/remount ro? */
>  static bool ovl_force_readonly(struct ovl_fs *ufs)
>  {
> -       return (!ufs->upper_mnt || !ufs->workdir);
> +       return (!ufs->upper_mnt || !ufs->workdir ||
> +               (ufs->config.index && !ufs->indexdir));
>  }
>
>  /**
> @@ -298,7 +299,7 @@ static int ovl_show_options(struct seq_file *m, struct dentry *dentry)
>         if (ufs->config.redirect_dir != ovl_redirect_dir_def)
>                 seq_printf(m, ",redirect_dir=%s",
>                            ufs->config.redirect_dir ? "on" : "off");
> -       if (ufs->config.index != ovl_index_def)
> +       if (!ovl_force_readonly(ufs) && ufs->config.index != ovl_index_def)
>                 seq_printf(m, ",index=%s",
>                            ufs->config.index ? "on" : "off");
>         return 0;
> @@ -1050,7 +1051,7 @@ static int ovl_fill_super(struct super_block *sb, void *data, int silent)
>         else if (ufs->upper_mnt->mnt_sb != ufs->same_sb)
>                 ufs->same_sb = NULL;
>
> -       if (!(ovl_force_readonly(ufs)) && ufs->config.index) {
> +       if (ufs->upper_mnt && ufs->workdir && ufs->config.index) {
>                 /* Verify lower root is upper root origin */
>                 err = ovl_verify_origin(upperpath.dentry, ufs->lower_mnt[0],
>                                         stack[0].dentry, false, true);
> @@ -1080,10 +1081,6 @@ static int ovl_fill_super(struct super_block *sb, void *data, int silent)
>                         goto out_put_indexdir;
>         }
>
> -       /* Show index=off/on in /proc/mounts for any of the reasons above */
> -       if (!ufs->indexdir)
> -               ufs->config.index = false;
> -
>         if (remote)
>                 sb->s_d_op = &ovl_reval_dentry_operations;
>         else
> --
> 2.7.4
>
