From: Amir Goldstein <amir73il@gmail.com>
Subject: Re: [PATCH v3 12/23] ovl: store upper/lower real inode in ovl_inode_info
Date: Wed, 14 Jun 2017 14:00:24 +0300
Message-ID: <CAOQ4uxjn9KQuqrWC6QHRfKXUXqfs75wwijUQWK6QxUv=4yHBKA@mail.gmail.com>
References: <1497425202-16270-1-git-send-email-amir73il@gmail.com> <1497425202-16270-13-git-send-email-amir73il@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-unionfs-owner@vger.kernel.org>
Received: from mail-oi0-f66.google.com ([209.85.218.66]:34929 "EHLO
        mail-oi0-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751863AbdFNLAZ (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Wed, 14 Jun 2017 07:00:25 -0400
Received: by mail-oi0-f66.google.com with SMTP id v74so13628407oie.2
        for <linux-unionfs@vger.kernel.org>; Wed, 14 Jun 2017 04:00:25 -0700 (PDT)
In-Reply-To: <1497425202-16270-13-git-send-email-amir73il@gmail.com>
Sender: linux-unionfs-owner@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: overlayfs <linux-unionfs@vger.kernel.org>

On Wed, Jun 14, 2017 at 10:26 AM, Amir Goldstein <amir73il@gmail.com> wrote:
> Introduce ovl_inode_info struct that is embedded in ovl_inode
> and contains a reference to lowerinode and/or upperinode.
>
> Storing the upper/lower real inode in ovl_inode_info replaces
> the method of storing realinode & ISUPPER flag in vfs inode
> i_private field.
>
> This will be used for hashing overlay inodes before copy up.
>
> Signed-off-by: Amir Goldstein <amir73il@gmail.com>
> ---

> +struct inode *ovl_inode_real(struct inode *inode, bool *is_upper)
> +{
> +       struct ovl_inode_info *oi = OVL_I_INFO(inode);
> +       struct inode *realinode;
> +
> +       realinode = READ_ONCE(oi->__upperinode);
> +       if (!realinode)
> +               realinode = oi->lowerinode;
> +       else if (is_upper)
> +               *is_upper = true;

oops, bug, not setting false (caught by ./run --ov rmdir):
        if (is_upper)
                *is_upper = !realinode;

> +
> +       return realinode;
>  }
>
