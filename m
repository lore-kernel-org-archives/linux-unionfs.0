From: Amir Goldstein <amir73il@gmail.com>
Subject: Re: [PATCH v3 4/5] vfs: add helper lookup_one_len_noperm()
Date: Mon, 5 Jun 2017 15:36:40 +0300
Message-ID: <CAOQ4uxib4bNVQOYigg0VfFwaLj+FumPg9iqP-B=H_QDn-_gb3w@mail.gmail.com>
References: <1496307779-2766-1-git-send-email-amir73il@gmail.com> <1496307779-2766-5-git-send-email-amir73il@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-unionfs-owner@vger.kernel.org>
Received: from mail-oi0-f65.google.com ([209.85.218.65]:33993 "EHLO
        mail-oi0-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751554AbdFEMgl (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Mon, 5 Jun 2017 08:36:41 -0400
Received: by mail-oi0-f65.google.com with SMTP id d99so9972969oic.1
        for <linux-unionfs@vger.kernel.org>; Mon, 05 Jun 2017 05:36:41 -0700 (PDT)
In-Reply-To: <1496307779-2766-5-git-send-email-amir73il@gmail.com>
Sender: linux-unionfs-owner@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: Chandan Rajendra <chandan@linux.vnet.ibm.com>, overlayfs <linux-unionfs@vger.kernel.org>

On Thu, Jun 1, 2017 at 12:02 PM, Amir Goldstein <amir73il@gmail.com> wrote:
> This is a variant of lookup_one_len() that does not check task
> permissions.
>
> Signed-off-by: Amir Goldstein <amir73il@gmail.com>
> ---
>  fs/namei.c            | 29 +++++++++++++++++++++++++++++
>  include/linux/namei.h |  1 +
>  2 files changed, 30 insertions(+)
>
> diff --git a/fs/namei.c b/fs/namei.c
> index 263caf0efafe..837da8bfb36f 100644
> --- a/fs/namei.c
> +++ b/fs/namei.c
> @@ -2511,6 +2511,35 @@ struct dentry *lookup_one_len(const char *name, struct dentry *base, int len)
>  EXPORT_SYMBOL(lookup_one_len);
>
>  /**
> + * lookup_one_len_noperm - filesystem helper to lookup single pathname component
> + * @name:      pathname component to lookup
> + * @base:      base directory to lookup from
> + * @len:       maximum length @len should be interpreted to
> + *
> + * Note that this routine is purely a helper for filesystem usage and should
> + * not be called by generic code.
> + *
> + * Unlike lookup_one_len, it does not check the task permissions.
> + *
> + * The caller must hold base->i_mutex.
> + */
> +struct dentry *lookup_one_len_noperm(const char *name, struct dentry *base,
> +                                    int len)
> +{
> +       struct qstr this;
> +       int err;
> +
> +       WARN_ON_ONCE(!inode_is_locked(base->d_inode));
> +
> +       err = lookup_one_len_init(&this, base, name, len);
> +       if (err)
> +               return ERR_PTR(err);
> +
> +       return __lookup_hash(&this, base, 0);
> +}
> +EXPORT_SYMBOL(lookup_one_len);

Miklos,

Chandan pointed out to me that I have a copy&paste typo:

+EXPORT_SYMBOL(lookup_one_len_noperm);

Please fix when applying if I don't end up sending another version.

Thanks,
Amir.
