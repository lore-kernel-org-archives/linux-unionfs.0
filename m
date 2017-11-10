From: Amir Goldstein <amir73il@gmail.com>
Subject: Re: [PATCH v6 10/15] ovl: Return lower dentry if only metadata copy
 up took place
Date: Fri, 10 Nov 2017 10:48:41 +0200
Message-ID: <CAOQ4uxh3ScwV_Tu0y68eZoazqMVeK=Zv8=JoTC6DFU+LcrQkBw@mail.gmail.com>
References: <20171109205019.11409-1-vgoyal@redhat.com> <20171109205019.11409-11-vgoyal@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-unionfs-owner@vger.kernel.org>
Received: from mail-yw0-f196.google.com ([209.85.161.196]:44913 "EHLO
        mail-yw0-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750937AbdKJIsm (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Fri, 10 Nov 2017 03:48:42 -0500
Received: by mail-yw0-f196.google.com with SMTP id k11so7594470ywh.1
        for <linux-unionfs@vger.kernel.org>; Fri, 10 Nov 2017 00:48:42 -0800 (PST)
In-Reply-To: <20171109205019.11409-11-vgoyal@redhat.com>
Sender: linux-unionfs-owner@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org
To: Vivek Goyal <vgoyal@redhat.com>
Cc: overlayfs <linux-unionfs@vger.kernel.org>, Miklos Szeredi <miklos@szeredi.hu>

On Thu, Nov 9, 2017 at 10:50 PM, Vivek Goyal <vgoyal@redhat.com> wrote:
> Upper dentry inode does not have data. So return lower dentry if upper
> is only a metadata copy.
>
> Signed-off-by: Vivek Goyal <vgoyal@redhat.com>
> ---
>  fs/overlayfs/super.c | 5 +++++
>  1 file changed, 5 insertions(+)
>
> diff --git a/fs/overlayfs/super.c b/fs/overlayfs/super.c
> index 84b8f6dc0f61..5cb19781763d 100644
> --- a/fs/overlayfs/super.c
> +++ b/fs/overlayfs/super.c
> @@ -101,14 +101,19 @@ static struct dentry *ovl_d_real(struct dentry *dentry,
>
>         real = ovl_dentry_upper(dentry);
>         if (real && (!inode || inode == d_inode(real))) {
> +               bool metacopy = !ovl_has_upperdata(dentry);
>                 if (!inode) {
>                         err = ovl_check_append_only(d_inode(real), open_flags);
>                         if (err)
>                                 return ERR_PTR(err);
> +
> +                       if (unlikely(metacopy))

I don't see why boolean var is needed and I prefer if memory barrier
was introduced
already in this patch.

Amir.
