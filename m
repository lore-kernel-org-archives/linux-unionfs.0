From: Amir Goldstein <amir73il@gmail.com>
Subject: Re: [PATCH v2] common/rc: Extending _require_metadata_journaling for
 overlayfs in case shutdown tests run on uncommon overlayfs setup and fail
Date: Sat, 6 Jan 2018 09:47:00 +0200
Message-ID: <CAOQ4uxjRN5vvGWoP+tp1gWjpM-KjPK_43va__+EiWzoncXJzBg@mail.gmail.com>
References: <1515220190-17424-1-git-send-email-cgxu519@icloud.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-unionfs-owner@vger.kernel.org>
Received: from mail-yw0-f194.google.com ([209.85.161.194]:34423 "EHLO
        mail-yw0-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752068AbeAFHrB (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Sat, 6 Jan 2018 02:47:01 -0500
In-Reply-To: <1515220190-17424-1-git-send-email-cgxu519@icloud.com>
Sender: linux-unionfs-owner@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org
To: Chengguang Xu <cgxu519@icloud.com>
Cc: Eryu Guan <eguan@redhat.com>, fstests <fstests@vger.kernel.org>, overlayfs <linux-unionfs@vger.kernel.org>

On Sat, Jan 6, 2018 at 8:29 AM, Chengguang Xu <cgxu519@icloud.com> wrote:
> Currently generic shutdown tests are enabled on overlayfs by extending
> _require_scratch_shutdown() to check shutdown support for overlayfs,
> some of those tests also call _require_metadata_journaling() to inspect
> whether test filesystem support metadata journaling or not, so need to
> extend _require_metadata_journaling() as well to check metadata journaling
> support for overlayfs in case shutdown tests run on uncommon overlayfs
> setup and fail. For example, base filesystem of overlayfs is ext2 or ext4
> with noload mode.
>
> Metadata journaling check is based on base filesystem configurations
> and  because -overlay option saves those configurations to OVL_BASE_*,
> adding restore/override the configurations before/after the check.

These 3 lines would look very good also as a comment in the code!

The subject line is a mouthful ;-)
How about "common/rc: perform _require_metadata_journaling check on
overlay base fs"

Otherwise, looks good.

Amir.

>
> Tested ext2, xfs, ext4(load/no-load mode) as base filesystem of overlayfs
> in single and multi section configurations.
>
> Signed-off-by: Chengguang Xu <cgxu519@icloud.com>
> ---
> Changes since v1:
> - Rewrite commit log.
>
>  common/rc | 9 +++++++++
>  1 file changed, 9 insertions(+)
>
> diff --git a/common/rc b/common/rc
> index 9216efd..83ef3f1 100644
> --- a/common/rc
> +++ b/common/rc
> @@ -3007,6 +3007,15 @@ _require_metadata_journaling()
>                 # ext4 might not load a journal
>                 _exclude_scratch_mount_option "noload"
>                 ;;
> +       overlay)
> +               if [ ! -z $OVL_BASE_FSTYP -a $OVL_BASE_FSTYP != "overlay" ]; then
> +                       _overlay_config_restore
> +                       _require_metadata_journaling
> +                       _overlay_config_override
> +               else
> +                       _notrun "Please specify underlying filesystem type in config file"
> +               fi
> +               ;;
>         *)
>                 # by default we pass; if you need to, add your fs above!
>                 ;;
> --
> 1.8.3.1
>
