From: Amir Goldstein <amir73il@gmail.com>
Subject: Re: [PATCH 09/11] ovl: Return lower dentry if only metadata copy up
 took place
Date: Wed, 18 Oct 2017 08:07:41 +0300
Message-ID: <CAOQ4uxiMoTDTyahBY1hT57aiSPWw1UuxPEe6_-A1jRK8_CLO=A@mail.gmail.com>
References: <1508274358-17456-1-git-send-email-vgoyal@redhat.com> <1508274358-17456-10-git-send-email-vgoyal@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-unionfs-owner@vger.kernel.org>
Received: from mail-qt0-f194.google.com ([209.85.216.194]:56454 "EHLO
        mail-qt0-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1756878AbdJRFHm (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Wed, 18 Oct 2017 01:07:42 -0400
Received: by mail-qt0-f194.google.com with SMTP id z28so8324796qtz.13
        for <linux-unionfs@vger.kernel.org>; Tue, 17 Oct 2017 22:07:42 -0700 (PDT)
In-Reply-To: <1508274358-17456-10-git-send-email-vgoyal@redhat.com>
Sender: linux-unionfs-owner@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org
To: Vivek Goyal <vgoyal@redhat.com>
Cc: overlayfs <linux-unionfs@vger.kernel.org>, Miklos Szeredi <miklos@szeredi.hu>

On Wed, Oct 18, 2017 at 12:05 AM, Vivek Goyal <vgoyal@redhat.com> wrote:
> Upper dentry inode does not have data. So return lower dentry if upper
> is only a metadata copy.
>
> Signed-off-by: Vivek Goyal <vgoyal@redhat.com>

Reviewed-by: Amir Goldstein <amir73il@gmail.com>

> ---
>  fs/overlayfs/super.c | 4 ++++
>  1 file changed, 4 insertions(+)
>
> diff --git a/fs/overlayfs/super.c b/fs/overlayfs/super.c
> index 32e3d4be1a71..fa802c89235a 100644
> --- a/fs/overlayfs/super.c
> +++ b/fs/overlayfs/super.c
> @@ -101,10 +101,14 @@ static struct dentry *ovl_d_real(struct dentry *dentry,
>                         err = ovl_check_append_only(d_inode(real), open_flags);
>                         if (err)
>                                 return ERR_PTR(err);
> +
> +                       if (ovl_test_flag(OVL_METACOPY, d_inode(dentry)))
> +                               goto lower;
>                 }
>                 return real;
>         }
>
> +lower:
>         real = ovl_dentry_lower(dentry);
>         if (!real)
>                 goto bug;
> --
> 2.13.5
>
