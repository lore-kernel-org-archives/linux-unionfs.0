From: Miklos Szeredi <miklos@szeredi.hu>
Subject: Re: [PATCH v2 07/23] ovl: verify stored origin fh matches lower dir
Date: Tue, 9 Jan 2018 10:52:35 +0100
Message-ID: <CAJfpegvR5=-GdD1sx81+TuPXNi6BFbpwcRKyOTmH7d59DLwB6w@mail.gmail.com>
References: <1515084018-25134-1-git-send-email-amir73il@gmail.com> <1515084018-25134-8-git-send-email-amir73il@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-unionfs-owner@vger.kernel.org>
Received: from mail-qk0-f194.google.com ([209.85.220.194]:42112 "EHLO
        mail-qk0-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752547AbeAIJwh (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Tue, 9 Jan 2018 04:52:37 -0500
Received: by mail-qk0-f194.google.com with SMTP id q1so734496qkb.9
        for <linux-unionfs@vger.kernel.org>; Tue, 09 Jan 2018 01:52:36 -0800 (PST)
In-Reply-To: <1515084018-25134-8-git-send-email-amir73il@gmail.com>
Sender: linux-unionfs-owner@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org
To: Amir Goldstein <amir73il@gmail.com>
Cc: zhangyi <yi.zhang@huawei.com>, overlayfs <linux-unionfs@vger.kernel.org>

On Thu, Jan 4, 2018 at 5:40 PM, Amir Goldstein <amir73il@gmail.com> wrote:
> When the "verify" feature is enabled, a directory inode found in lower
> layer by name or by redirect_dir is verified against the file handle of
> the copy up origin that is stored in the upper layer.
>
> This introduces a change of behavior for the case of lower layer
> modification while overlay is offline. A lower directory created or
> moved offline under an exisitng upper directory, will not be merged with
> that upper directory.
>
> The "verify" feature should not be used after copying layers,
> because the new lower directory inodes would fail verification.
>
> Signed-off-by: Amir Goldstein <amir73il@gmail.com>
> ---
>  Documentation/filesystems/overlayfs.txt | 16 ++++++++++++++++
>  fs/overlayfs/namei.c                    | 13 +++++++++++++
>  2 files changed, 29 insertions(+)
>
> diff --git a/Documentation/filesystems/overlayfs.txt b/Documentation/filesystems/overlayfs.txt
> index e6a5f4912b6d..00e0595f3d7e 100644
> --- a/Documentation/filesystems/overlayfs.txt
> +++ b/Documentation/filesystems/overlayfs.txt
> @@ -299,6 +299,22 @@ filesystem are not allowed.  If the underlying filesystem is changed,
>  the behavior of the overlay is undefined, though it will not result in
>  a crash or deadlock.
>
> +When the underlying filesystems supports NFS export, overlay mount can be
> +made more resilient to offline and online changes of the underlying lower
> +layer by enabling the "verify" feature.
> +
> +On every copy_up, an NFS file handle of the lower inode, along with the
> +UUID of the lower filesystem, are encoded and stored in an extended
> +attribute "trusted.overlay.origin" on the upper inode.
> +
> +When the "verify" feature is enabled, a lookup of a merged directory, that
> +found a lower directory at the lookup path or at the path pointed to by
> +the "trusted.overlay.redirect" extended attribute, will verify that the
> +found lower directory file handle and lower filesystem UUID match the
> +origin file handle that was stored at copy_up time.  If a found lower
> +directory does not match the stored origin, that directory will not be
> +merged with the upper directory.

Ah, here's the doc.

Thinking a bit about this...  I think this is a slightly different
category than "redirect_dir=on".  There we were expanding the
functionality, to allow directory renaming.  With "verify=on" we are
restricting the functionality to not allow some offline changes.
Which is really what we want for NFS.

But the doc should come with more info about when it makes sense to
enable it for non-NFS case and when it does not.  I think enabling
directory origin verification by default (e.g. with config option or
module option) is probably something most users or distros do not want
to do, and the documentation should reflect that.

As for the name, whatever describes the function best but is as short
as possible (e.g. "verify_dir=on/off" should be okay, I think).

The issue here is that NFS export will need lots of options, and that
may be confusing.  How about an "nfs_export=on" option that acts as a
shorthand for all options needed for NFS export?

Thanks,
Miklos
