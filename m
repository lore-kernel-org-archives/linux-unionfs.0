From: Rock Lee <rockdotlee@gmail.com>
Subject: Re: [RFC][PATCH 02/13] ovl: redirect dir by file handle on copy up
Date: Mon, 17 Apr 2017 21:33:35 +0800
Message-ID: <CAL-1w2sBpUTLEYVXzv6s6mGwoodbHMkUw9EgU9gNW9ybX-eLGQ@mail.gmail.com>
References: <1492387183-18847-1-git-send-email-amir73il@gmail.com> <1492387183-18847-3-git-send-email-amir73il@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-unionfs-owner@vger.kernel.org>
Received: from mail-yw0-f173.google.com ([209.85.161.173]:33583 "EHLO
        mail-yw0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753283AbdDQNdg (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Mon, 17 Apr 2017 09:33:36 -0400
In-Reply-To: <1492387183-18847-3-git-send-email-amir73il@gmail.com>
Sender: linux-unionfs-owner@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org
To: Amir Goldstein <amir73il@gmail.com>
Cc: Miklos Szeredi <miklos@szeredi.hu>, Al Viro <viro@zeniv.linux.org.uk>, linux-unionfs@vger.kernel.org, linux-fsdevel@vger.kernel.org

Hi, Amir:

> +static int ovl_set_redirect_fh(struct dentry *dentry, struct dentry *upper)
> +{
> +       int err;
> +       const struct ovl_fh *fh;
> +
> +       fh = ovl_get_redirect_fh(ovl_dentry_lower(dentry));
> +       err = PTR_ERR(fh);
> +       if (IS_ERR(fh))
> +               goto out_err;
> +
> +       err = ovl_do_setxattr(upper, OVL_XATTR_FH, fh, fh->len, 0);
> +       if (err)
> +               goto out_free;

I'm not quite sure, maybe you missed a 'free(fh)' here.

> +       return 0;
> +
> +out_free:
> +       kfree(fh);
> +out_err:
> +       if (err == -EOPNOTSUPP) {
> +               ovl_clear_redirect_fh(dentry->d_sb);
> +               return 0;
> +       }
> +       pr_warn_ratelimited("overlay: failed to set redirect fh (%i)\n", err);
> +       return err;
> +}
> +






-- 
Cheers,
Rock
