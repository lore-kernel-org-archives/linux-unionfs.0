From: Amir Goldstein <amir73il@gmail.com>
Subject: Re: [PATCH] ovl: check ERR_PTR() return value from ovl_lookup_real()
Date: Tue, 6 Feb 2018 13:46:15 +0200
Message-ID: <CAOQ4uxhrfJ4DPcamWEZQ6DN1iVzS=QvpixTjBKOKzf+ub4nYEA@mail.gmail.com>
References: <1517316127-27555-1-git-send-email-amir73il@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-unionfs-owner@vger.kernel.org>
Received: from mail-yw0-f193.google.com ([209.85.161.193]:41341 "EHLO
        mail-yw0-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752246AbeBFLqQ (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Tue, 6 Feb 2018 06:46:16 -0500
Received: by mail-yw0-f193.google.com with SMTP id b129so1068579ywa.8
        for <linux-unionfs@vger.kernel.org>; Tue, 06 Feb 2018 03:46:16 -0800 (PST)
In-Reply-To: <1517316127-27555-1-git-send-email-amir73il@gmail.com>
Sender: linux-unionfs-owner@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: Dan Carpenter <dan.carpenter@oracle.com>, overlayfs <linux-unionfs@vger.kernel.org>

On Tue, Jan 30, 2018 at 2:42 PM, Amir Goldstein <amir73il@gmail.com> wrote:
> Reported-by: Dan Carpenter <dan.carpenter@oracle.com>
> Fixes: 061701540349 ("ovl: lookup indexed ancestor of lower dir")
> Signed-off-by: Amir Goldstein <amir73il@gmail.com>
> ---
> Miklos,
>
> Another fix, for yet another issue reported by 0-day robot.
> At least it looks like the smatch checker got to the last patch ;-).

Miklos,

I guess you missed this patch when updated for-linus, because
subject looks very similar the the "other" 0-day reported bug fix?

>
> All 3 fixes over overlayfs-next are push to branch ovl-nfs-export
> on my github.
>

At this time, my ovl-nfs-export is rebased on current master and has
all the patches that are candidates for rc2 (including this fix).
The branch also contains "hash by file handle" work, which is now
complete. Will be posting it shortly.

Thanks,
Amir.

>
>  fs/overlayfs/export.c | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
>
> diff --git a/fs/overlayfs/export.c b/fs/overlayfs/export.c
> index bb94ce9da5c8..07d70255095b 100644
> --- a/fs/overlayfs/export.c
> +++ b/fs/overlayfs/export.c
> @@ -355,8 +355,8 @@ static struct dentry *ovl_lookup_real_inode(struct super_block *sb,
>                 dput(upper);
>         }
>
> -       if (!this)
> -               return NULL;
> +       if (IS_ERR_OR_NULL(this))
> +               return this;
>
>         if (WARN_ON(ovl_dentry_real_at(this, layer->idx) != real)) {
>                 dput(this);
> --
> 2.7.4
>
