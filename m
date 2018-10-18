Return-Path: <amir73il@gmail.com>
MIME-Version: 1.0
References: <20181016074559.24728-1-yi.zhang@huawei.com> <20181016074559.24728-2-yi.zhang@huawei.com>
 <CAOQ4uxh8YWXprDPp1H6Si+L1QXBwcTp1+P78MqYZD5wMzuJopg@mail.gmail.com> <25d4f255-7dd0-cfe6-3c33-556365de2c68@huawei.com>
In-Reply-To: <25d4f255-7dd0-cfe6-3c33-556365de2c68@huawei.com>
From: Amir Goldstein <amir73il@gmail.com>
Date: Thu, 18 Oct 2018 07:37:30 +0300
Message-ID: <CAOQ4uxjrf8mcUtcxwmhpg4Y4m3u0PXC2QNc+s3tkUiPN3anzvw@mail.gmail.com>
Subject: Re: [PATCH v2 1/4] overlay: correct fsck.overlay exit code
Content-Type: text/plain; charset="UTF-8"
To: "zhangyi (F)" <yi.zhang@huawei.com>
Cc: fstests <fstests@vger.kernel.org>, Eryu Guan <guaneryu@gmail.com>, Miklos Szeredi <miklos@szeredi.hu>, Miao Xie <miaoxie@huawei.com>, overlayfs <linux-unionfs@vger.kernel.org>
List-ID: <linux-unionfs@vger.kernel.org>

On Thu, Oct 18, 2018 at 5:37 AM zhangyi (F) <yi.zhang@huawei.com> wrote:
>
> On 2018/10/16 17:45, Amir Goldstein Wrote:
> > On Tue, Oct 16, 2018 at 10:32 AM zhangyi (F) <yi.zhang@huawei.com> wrote:
[...]
> >
> > Please consider the name _overlay_repair_dirs() with reference to
> > _repair_scratch_fs(), which is used for roughly the same purpose.
> >
>
> _run_check_fsck() is helper used to test fsck and may expect to return
> "error" exit code when we do exception tests(see patch 4), but
> _repair_scratch_fs() always want to return "correct" exit code.
>

Right. so perhaps we need _overlay_repair_dirs() as a convenience
helper for things like the stress test and also related to another
comment about expecting return 0 is too fragile.

> > BTW, the tests generic/330 generic/332 when run with -overlay
> > over xfs with reflink support seem to call _repair_scratch_fs() which does:
> >         # Let's hope fsck -y suffices...
> >         fsck -t $FSTYP -y $SCRATCH_DEV 2>&1
> >         local res=$?
> >         case $res in
> >         0|1|2)
> >                 res=0
> >                 ;;
> >         *)
> >                 _dump_err2 "fsck.$FSTYP failed, err=$res"
> >
> > How come fsck.overlay is not complaining about missing arguments??
> >
> > The rest of the generic tests that call _repair_scratch_fs() have
> > _require_dm_target() which _require_block_device(), so don't run with overlay.
> >
> > If you do sort this out and add overlay support to
> > _repair_scratch_fs() its probably
> > worth replacing 0|1|2) with FSCK_ constants.
> >
>
> Thanks for pointing this out, I think we do something like below can fix
> this problem, what do you think?

I am puzzled about why those tests do NOT fail when fsck.overlay is given
incorrect args??

>
> diff --git a/common/overlay b/common/overlay
> index 2896594..b9fe1ee 100644
> --- a/common/overlay
> +++ b/common/overlay
> @@ -226,6 +226,14 @@ _run_check_fsck()
>                 echo "fsck return unexpected value:$expect_ret,$fsck_ret"
>  }
>
> +_scratch_overlay_repair()
> +{
> +       _overlay_fsck_dirs $OVL_BASE_SCRATCH_MNT/$OVL_LOWER \
> +                          $OVL_BASE_SCRATCH_MNT/$OVL_UPPER \
> +                          $OVL_BASE_SCRATCH_MNT/$OVL_WORK \
> +                          -y
> +}
> +

All overlay "global" helpers should be prefixed _overlay_XXX
unless there is a good reason to break that rule (even though we did
not always abide by this rule in the past).

But anyway, I think that a more specific _overlay_repair_scratch_fs()
should be used to hide the details of "correct" error code from common/rc.

And it would probably be useful if it used a helper _overlay_repair_dirs()
that can be used from overlay specific tests (like stress test).

Thanks,
Amir.
