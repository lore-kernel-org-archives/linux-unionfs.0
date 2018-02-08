From: Eryu Guan <eguan@redhat.com>
Subject: Re: [xfstests PATCH v3 2/5] overlay: define common overlay xattr keys
Date: Thu, 8 Feb 2018 20:06:39 +0800
Message-ID: <20180208120639.GD18267@eguan.usersys.redhat.com>
References: <20180208031913.14013-1-yi.zhang@huawei.com>
 <20180208031913.14013-3-yi.zhang@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-unionfs-owner@vger.kernel.org>
Received: from mx3-rdu2.redhat.com ([66.187.233.73]:59300 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1751878AbeBHMGm (ORCPT <rfc822;linux-unionfs@vger.kernel.org>);
        Thu, 8 Feb 2018 07:06:42 -0500
Content-Disposition: inline
In-Reply-To: <20180208031913.14013-3-yi.zhang@huawei.com>
Sender: linux-unionfs-owner@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org
To: "zhangyi (F)" <yi.zhang@huawei.com>
Cc: fstests@vger.kernel.org, linux-unionfs@vger.kernel.org, miklos@szeredi.hu, amir73il@gmail.com, miaoxie@huawei.com, yangerkun@huawei.com

On Thu, Feb 08, 2018 at 11:19:10AM +0800, zhangyi (F) wrote:
> Define common overlay xattr keys from Linux kernel for ovl tests use.
> 
> Signed-off-by: zhangyi (F) <yi.zhang@huawei.com>
> ---
>  common/overlay | 10 ++++++++++
>  1 file changed, 10 insertions(+)
> 
> diff --git a/common/overlay b/common/overlay
> index 16f13a8..9000432 100644
> --- a/common/overlay
> +++ b/common/overlay
> @@ -3,6 +3,16 @@
>  #
>  . ./common/module
>  
> +# Export overlayfs xattrs and constant value
> +export OVL_XATTR_OPAQUE="trusted.overlay.opaque"
> +export OVL_XATTR_REDIRECT="trusted.overlay.redirect"
> +export OVL_XATTR_IMPURE="trusted.overlay.impure"
> +export OVL_XATTR_ORIGIN="trusted.overlay.origin"
> +export OVL_XATTR_NLINK="trusted.overlay.nlink"
> +export OVL_XATTR_UPPER="trusted.overlay.upper"
> +export OVL_XATTR_OPAQUE_VAL="y"
> +export OVL_XATTR_IMPURE_VAL="y"

Sorry, I was not clear enough in previous review. I mean putting the
common xattr keys to common/overlay, but I don't think the <VAL>="y" is
needed.

I'll edit on commit to remove them from here and add them to tests where
needed.

Thanks,
Eryu

> +
>  # helper function to do the actual overlayfs mount operation
>  _overlay_mount_dirs()
>  {
> -- 
> 2.5.0
> 
> --
> To unsubscribe from this list: send the line "unsubscribe fstests" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
