From: Amir Goldstein <amir73il@gmail.com>
Subject: Re: [PATCH v6 12/15] ovl: Fix encryption status of a metacopy only file
Date: Fri, 10 Nov 2017 11:09:26 +0200
Message-ID: <CAOQ4uxjrfhoCh1gnQM04xkgNNWzxUs2S20NXGFwhfAPg4=D4Xw@mail.gmail.com>
References: <20171109205019.11409-1-vgoyal@redhat.com> <20171109205019.11409-13-vgoyal@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-unionfs-owner@vger.kernel.org>
Received: from mail-yw0-f195.google.com ([209.85.161.195]:55981 "EHLO
        mail-yw0-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752097AbdKJJJ2 (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Fri, 10 Nov 2017 04:09:28 -0500
Received: by mail-yw0-f195.google.com with SMTP id t11so7589190ywg.12
        for <linux-unionfs@vger.kernel.org>; Fri, 10 Nov 2017 01:09:28 -0800 (PST)
In-Reply-To: <20171109205019.11409-13-vgoyal@redhat.com>
Sender: linux-unionfs-owner@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org
To: Vivek Goyal <vgoyal@redhat.com>
Cc: overlayfs <linux-unionfs@vger.kernel.org>, Miklos Szeredi <miklos@szeredi.hu>

On Thu, Nov 9, 2017 at 10:50 PM, Vivek Goyal <vgoyal@redhat.com> wrote:
> If file is metacopy only, it is possible that lower is encrypted while
> other is not. In that case, report file as encrypted (despite the fact
> that only data is encrypted while metadata is not).

Better consult ext4 guys or find out which user tools care about this
flag and what they could do in response to this flag.

When I commented that we need to see what do to about all these
flags I just gave encrypted flag as an example.

On a hunch I would say that we need a mask of statx flags that are
readonly attributes of the data itself and that mask should probably
contain encrypted and compressed to begin with.
I don't see a reason for 2 separate patches and certainly not for
2 separate helpers.

>
> Signed-off-by: Vivek Goyal <vgoyal@redhat.com>
> ---
>  fs/overlayfs/inode.c | 14 +++++++++++++-
>  1 file changed, 13 insertions(+), 1 deletion(-)
>
> diff --git a/fs/overlayfs/inode.c b/fs/overlayfs/inode.c
> index 7ba19a97a8da..15713d4ac2dd 100644
> --- a/fs/overlayfs/inode.c
> +++ b/fs/overlayfs/inode.c
> @@ -66,6 +66,16 @@ int ovl_setattr(struct dentry *dentry, struct iattr *attr)
>         return err;
>  }
>
> +static void ovl_stat_set_encryption(struct kstat *ustat, struct kstat *lstat) {
> +       if (!((lstat->attributes_mask & STATX_ATTR_ENCRYPTED) &&
> +           (lstat->attributes & STATX_ATTR_ENCRYPTED)))
> +               return;
> +
> +       ustat->attributes |= STATX_ATTR_ENCRYPTED;
> +       ustat->attributes_mask |= STATX_ATTR_ENCRYPTED;
> +}
> +


This looks buggy. you set STATX_ATTR_ENCRYPTED even if lower
doesn't have STATX_ATTR_ENCRYPTED in attributes nor in attributes_mask.

Amir.
