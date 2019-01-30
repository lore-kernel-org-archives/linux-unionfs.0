Return-Path: <amir73il@gmail.com>
MIME-Version: 1.0
References: <20190130163247.GB2757@redhat.com>
In-Reply-To: <20190130163247.GB2757@redhat.com>
From: Amir Goldstein <amir73il@gmail.com>
Date: Wed, 30 Jan 2019 19:58:04 +0200
Message-ID: <CAOQ4uxhPZ-_-vGLOjnK+wHpLciVJc0o3Kcnn_Xz+HM1BJD6-XA@mail.gmail.com>
Subject: Re: [PATCH] xfstests: overlay: Do not lose security.capability xattr
 over metadata only file copy-up
Content-Type: text/plain; charset="UTF-8"
To: Vivek Goyal <vgoyal@redhat.com>
Cc: fstests <fstests@vger.kernel.org>, overlayfs <linux-unionfs@vger.kernel.org>, Miklos Szeredi <miklos@szeredi.hu>
List-ID: <linux-unionfs@vger.kernel.org>

On Wed, Jan 30, 2019 at 6:32 PM Vivek Goyal <vgoyal@redhat.com> wrote:
>
> Extend test 064 to check security.capability xattr is not lost over copy-up
> of a metadata only file. This requires mounting overlay with option
> metacopy=on and first trigger metadata only copy-up and then trigger
> data copy-up.
>

I'm ok with extending the test, but it is not done right.

For using metacopy=on you need:

_require_scratch_overlay_features metacopy, so test will be skipped
on kernel < 4.19, but then the existing test case won't run on old kernels.
That is fine (I guess?) because the bug was introduced by metacopy
patches anyway.

So instead of repeating the test, I suggest to mount overlay with metacopy=on
to begin with and have 2 test files. One gets metacopied and then both get
data copied.

Thanks,
Amir.

> Signed-off-by: Vivek Goyal <vgoyal@redhat.com>
> ---
>  tests/overlay/064     |   18 ++++++++++++++++++
>  tests/overlay/064.out |    1 +
>  2 files changed, 19 insertions(+)
>
> Index: xfstests-dev/tests/overlay/064
> ===================================================================
> --- xfstests-dev.orig/tests/overlay/064 2019-01-28 15:03:12.590434802 -0500
> +++ xfstests-dev/tests/overlay/064      2019-01-30 11:18:29.595591985 -0500
> @@ -55,6 +55,24 @@ $XFS_IO_PROG -c "stat" ${SCRATCH_MNT}/fi
>  # Make sure cap_setuid is still there
>  $GETCAP_PROG ${SCRATCH_MNT}/file | _filter_scratch
>
> +# Test copy-up with metacopy on.
> +$UMOUNT_PROG $SCRATCH_MNT
> +_scratch_mkfs
> +echo "This is lower" >> ${lowerdir}/file
> +
> +# Set CAP_SETUID
> +$SETCAP_PROG cap_setuid+ep ${lowerdir}/file
> +_scratch_mount "-o metacopy=on"
> +
> +# Trigger metadata only copy-up
> +chmod 000 ${SCRATCH_MNT}/file
> +
> +# Trigger data copy-up
> +$XFS_IO_PROG -c "stat" ${SCRATCH_MNT}/file >>$seqres.full
> +
> +# Make sure cap_setuid is still there
> +$GETCAP_PROG ${SCRATCH_MNT}/file | _filter_scratch
> +
>  # success, all done
>  status=0
>  exit
> Index: xfstests-dev/tests/overlay/064.out
> ===================================================================
> --- xfstests-dev.orig/tests/overlay/064.out     2019-01-28 15:03:12.590434802 -0500
> +++ xfstests-dev/tests/overlay/064.out  2019-01-30 11:21:11.745591985 -0500
> @@ -1,2 +1,3 @@
>  QA output created by 064
>  SCRATCH_MNT/file = cap_setuid+ep
> +SCRATCH_MNT/file = cap_setuid+ep
