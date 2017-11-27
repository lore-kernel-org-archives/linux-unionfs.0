From: Amir Goldstein <amir73il@gmail.com>
Subject: Re: [PATCH] ovl: Pass ovl_get_nlink() parameters in right order
Date: Mon, 27 Nov 2017 20:24:48 +0200
Message-ID: <CAOQ4uxjSFNE7_-a=Ah4wgRjoQwyRn0PrukchmNUNyKEGDysiHQ@mail.gmail.com>
References: <20171127151244.GA22007@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-unionfs-owner@vger.kernel.org>
Received: from mail-yb0-f193.google.com ([209.85.213.193]:44654 "EHLO
        mail-yb0-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752820AbdK0SYt (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Mon, 27 Nov 2017 13:24:49 -0500
Received: by mail-yb0-f193.google.com with SMTP id x72so10942544ybg.11
        for <linux-unionfs@vger.kernel.org>; Mon, 27 Nov 2017 10:24:49 -0800 (PST)
In-Reply-To: <20171127151244.GA22007@redhat.com>
Sender: linux-unionfs-owner@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org
To: Vivek Goyal <vgoyal@redhat.com>
Cc: overlayfs <linux-unionfs@vger.kernel.org>

On Mon, Nov 27, 2017 at 5:12 PM, Vivek Goyal <vgoyal@redhat.com> wrote:
> Hi Amir,
>
> I am wondering if this is a bug or it is supposed to be like this. I felt
> it is a bug, so I generated a patch and sending it for your review.
>

Yap. That's a bug. Good catch!
I fixed test overlay/033 to catch it.

Please add cc:stable # v4.13 and Fixes tag.

Thanks!
Amir.

> Vivek
>
>
> Right now we seem to be passing index as "lowerdentry" and origin.dentry
> as "upperdentry". IIUC, we should pass these parameters in reversed order
> and this looks like a bug.
>
> Signed-off-by: Vivek Goyal <vgoyal@redhat.com>
> ---
>  fs/overlayfs/namei.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/fs/overlayfs/namei.c b/fs/overlayfs/namei.c
> index 625ed8066570..5ef69bc09e0c 100644
> --- a/fs/overlayfs/namei.c
> +++ b/fs/overlayfs/namei.c
> @@ -435,7 +435,7 @@ int ovl_verify_index(struct dentry *index, struct ovl_path *lower,
>
>         /* Check if index is orphan and don't warn before cleaning it */
>         if (d_inode(index)->i_nlink == 1 &&
> -           ovl_get_nlink(index, origin.dentry, 0) == 0)
> +           ovl_get_nlink(origin.dentry, index, 0) == 0)
>                 err = -ENOENT;
>
>         dput(origin.dentry);
