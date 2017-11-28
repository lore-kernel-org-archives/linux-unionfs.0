From: Amir Goldstein <amir73il@gmail.com>
Subject: Re: [PATCH v8 05/15] ovl: Provide a mount option metacopy=on/off for
 metadata copyup
Date: Tue, 28 Nov 2017 21:15:24 +0200
Message-ID: <CAOQ4uxgtTRg2tksx1i+EUKsyi6F0LTPceOnMGfCZWgQiH8tP6g@mail.gmail.com>
References: <20171128155959.20114-1-vgoyal@redhat.com> <20171128155959.20114-6-vgoyal@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-unionfs-owner@vger.kernel.org>
Received: from mail-yb0-f196.google.com ([209.85.213.196]:34797 "EHLO
        mail-yb0-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751883AbdK1TP0 (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Tue, 28 Nov 2017 14:15:26 -0500
Received: by mail-yb0-f196.google.com with SMTP id k4so404337ybc.1
        for <linux-unionfs@vger.kernel.org>; Tue, 28 Nov 2017 11:15:26 -0800 (PST)
In-Reply-To: <20171128155959.20114-6-vgoyal@redhat.com>
Sender: linux-unionfs-owner@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org
To: Vivek Goyal <vgoyal@redhat.com>
Cc: overlayfs <linux-unionfs@vger.kernel.org>, Miklos Szeredi <miklos@szeredi.hu>

On Tue, Nov 28, 2017 at 5:59 PM, Vivek Goyal <vgoyal@redhat.com> wrote:
> By default metadata only copy up is disabled. Provide a mount option so
> that users can choose one way or other.
>
> Also provide a kernel config and module option to enable/disable
> metacopy feature.
>
> Like index feature, we verify on mount that upper root is not being
> reused with a different lower root. This hopes to get the configuration
> right and detect the copied layers use case. But this does only so
> much as we don't verify all the lowers. So it is possible that a lower is
> missing and later data copy up fails.
>
> Signed-off-by: Vivek Goyal <vgoyal@redhat.com>

Reviewed-by: Amir Goldstein <amir73il@gmail.com>

> ---
>  fs/overlayfs/Kconfig     |  8 ++++++++
>  fs/overlayfs/ovl_entry.h |  1 +
>  fs/overlayfs/super.c     | 40 +++++++++++++++++++++++++++++++++++++---
>  3 files changed, 46 insertions(+), 3 deletions(-)
>
> diff --git a/fs/overlayfs/Kconfig b/fs/overlayfs/Kconfig
> index cbfc196e5dc5..17a0b17ad14c 100644
> --- a/fs/overlayfs/Kconfig
> +++ b/fs/overlayfs/Kconfig
> @@ -43,3 +43,11 @@ config OVERLAY_FS_INDEX
>           outcomes.  However, mounting the same overlay with an old kernel
>           read-write and then mounting it again with a new kernel, will have
>           unexpected results.
> +
> +config OVERLAY_FS_METACOPY
> +       bool "Overlayfs: turn on metadata only copy up feature by default"
> +       depends on OVERLAY_FS
> +       help
> +         If this config option is enabled then overlay filesystems will
> +         copy up only metadata where appropriate and data copy up will
> +         happen when a file is opended for WRITE operation.

Just add some scary stuff about mounting with old kernel.
And the text about module/mount option.
Use the gist version like in REDIRECT_DIR, not like I did...

Amir.
