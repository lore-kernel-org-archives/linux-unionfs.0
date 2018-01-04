From: Amir Goldstein <amir73il@gmail.com>
Subject: Re: [PATCH] common/rc: add overlay support to _require_metadata_journaling
Date: Thu, 4 Jan 2018 08:48:18 +0200
Message-ID: <CAOQ4uxgHZQhCHS3NN3y4zBW-+FvCNVCXDLcgQ9Lhecx5w85fZA@mail.gmail.com>
References: <1515035017-156043-1-git-send-email-cgxu519@icloud.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <fstests-owner@vger.kernel.org>
In-Reply-To: <1515035017-156043-1-git-send-email-cgxu519@icloud.com>
Sender: fstests-owner@vger.kernel.org
To: Chengguang Xu <cgxu519@icloud.com>
Cc: Eryu Guan <eguan@redhat.com>, fstests <fstests@vger.kernel.org>, overlayfs <linux-unionfs@vger.kernel.org>
List-Id: linux-unionfs@vger.kernel.org

On Thu, Jan 4, 2018 at 5:03 AM, Chengguang Xu <cgxu519@icloud.com> wrote:
> metadata journaling check needs base filesystem configureations
> and ./check -overlay saves those configurations to OVL_BASE_*,
> so restore/override the configuratons before/after the check.
>

1. Presumably, you are making this change because you ran into a problem
with some setup? Please you specify that motivation in commit message.

2. Can you please give a brief summary of the type of generic tests
that are going
to "notrun" because of this change without specifying base FSTYP.
I suppose it will be good for those tests not to run, just want to get the idea,
because I have a feeling that _require_metadata_journaling is used for
various different reasons.

3. Please specify with which base fs you tested and preferably, run the
test with the 3 major fs as base fs. Bonus points for running the test with
multi section config file with several base fs ;-)

Thanks,
Amir.

> Signed-off-by: Chengguang Xu <cgxu519@icloud.com>
> ---
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
> --
> To unsubscribe from this list: send the line "unsubscribe linux-unionfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
