From: Amir Goldstein <amir73il@gmail.com>
Subject: Re: [PATCH 11/17] ovl: hash overlay non-dir inodes by copy up origin inode
Date: Mon, 5 Jun 2017 15:42:48 +0300
Message-ID: <CAOQ4uxgviS0MP1uEs_sdYyxizPntVmeT1RzSTXUHxjOE8q60hw@mail.gmail.com>
References: <1496412284-4113-1-git-send-email-amir73il@gmail.com> <1496412284-4113-12-git-send-email-amir73il@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-unionfs-owner@vger.kernel.org>
Received: from mail-oi0-f66.google.com ([209.85.218.66]:34471 "EHLO
        mail-oi0-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751303AbdFEMmt (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Mon, 5 Jun 2017 08:42:49 -0400
Received: by mail-oi0-f66.google.com with SMTP id d99so9999775oic.1
        for <linux-unionfs@vger.kernel.org>; Mon, 05 Jun 2017 05:42:49 -0700 (PDT)
In-Reply-To: <1496412284-4113-12-git-send-email-amir73il@gmail.com>
Sender: linux-unionfs-owner@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: overlayfs <linux-unionfs@vger.kernel.org>

On Fri, Jun 2, 2017 at 5:04 PM, Amir Goldstein <amir73il@gmail.com> wrote:
> Non-dir pure upper overlay inodes are hashed by the address of the
> upper real inode.  When inodes index feature is enabled, hash all non-dir
> inodes by the address of the copy up origin inode if we know it.
>
> This is going to be used to prevent breaking lower hardlinks on copy up.
>
> Because overlay dentries of lower hardlink aliases have the same overlay
> inode, copy up of those lower aliases can result is conflict when setting
> the real upper inode of a broken hardlink. Copy up of an alias that lost
> in this conflict will return -EEXIST and drop the overlay dentry.
>
> This conflict is going to be handled more gracefully by following patches.
>
> Signed-off-by: Amir Goldstein <amir73il@gmail.com>
> ---
...
>  static int ovl_inode_test(struct inode *inode, void *data)
>  {
> -       return READ_ONCE(inode->i_private) == data;
> +       void *this = READ_ONCE(inode->i_private);
> +
> +       if (this == data)
> +               return true;
> +
> +       /*
> +        * Overlay inodes hash key is the address of the lower origin inode.
> +        * Return same overlay inode when looking up by lower real inode, but
> +        * an existing overlay inode, that is hashed by the same lower origin
> +        * inode, has already been updated on copy up to a real upper inode.
> +        */
> +       return ovl_indexdir(inode->i_sb) &&
> +               ovl_inode_data_is_upper(this) &&
> +               !ovl_inode_data_is_upper(data);
>  }
>

Miklos,

FYI, the test above is completely bogus.
I used it for testing, because for small numbers of inodes hash collision
probability is low.

In v2 of the inode hash patches, I stored the origin inode in
i_data.private_data. I hope you will approve of this, if not, maybe
it's time to allocate an ovl_inode. I may have other interesting things
to store there (e.g. copyup and coverup nlink count).

Amir.
