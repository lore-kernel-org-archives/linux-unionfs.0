Return-Path: <amir73il@gmail.com>
MIME-Version: 1.0
References: <20190130185937.GB15061@redhat.com>
In-Reply-To: <20190130185937.GB15061@redhat.com>
From: Amir Goldstein <amir73il@gmail.com>
Date: Wed, 30 Jan 2019 21:13:54 +0200
Message-ID: <CAOQ4uxj3q6QzZJDikx+EtR61KdJxauL5yX0f02EeMeM+5KntFA@mail.gmail.com>
Subject: Re: [PATCH][v2] xfstests: overlay: Do not lose security.capability
 xattr over metadata only file copy-up
Content-Type: text/plain; charset="UTF-8"
To: Vivek Goyal <vgoyal@redhat.com>
Cc: fstests <fstests@vger.kernel.org>, overlayfs <linux-unionfs@vger.kernel.org>, Miklos Szeredi <miklos@szeredi.hu>, Eryu Guan <guaneryu@gmail.com>
List-ID: <linux-unionfs@vger.kernel.org>

On Wed, Jan 30, 2019 at 8:59 PM Vivek Goyal <vgoyal@redhat.com> wrote:
>
> Extend test 064 to check security.capability xattr is not lost over copy-up
> of a metadata only file. This requires mounting overlay with option
> metacopy=on and first trigger metadata only copy-up and then trigger
> data copy-up.
>
> Signed-off-by: Vivek Goyal <vgoyal@redhat.com>

Reviewed-by: Amir Goldstein <amir73il@gmail.com>

> ---
>  tests/overlay/064     |   22 +++++++++++++++++-----
>  tests/overlay/064.out |    3 ++-
>  2 files changed, 19 insertions(+), 6 deletions(-)
>
> Index: xfstests-dev/tests/overlay/064
> ===================================================================
> --- xfstests-dev.orig/tests/overlay/064 2019-01-28 15:03:12.590434802 -0500
> +++ xfstests-dev/tests/overlay/064      2019-01-30 13:41:49.363840084 -0500
> @@ -34,26 +34,38 @@ _supported_os Linux
>  _require_scratch
>  _require_command "$SETCAP_PROG" setcap
>  _require_command "$GETCAP_PROG" getcap
> +_require_scratch_overlay_features metacopy
>
>  # Remove all files from previous tests
>  _scratch_mkfs
>
>  # Create test file
>  lowerdir=${OVL_BASE_SCRATCH_MNT}/${OVL_LOWER}
> -echo "This is lower" >> ${lowerdir}/file
> +echo "This is lower1" >> ${lowerdir}/file1
> +echo "This is lower2" >> ${lowerdir}/file2
>
>  # set setuid bit
> -$SETCAP_PROG cap_setuid+ep ${lowerdir}/file
> +$SETCAP_PROG cap_setuid+ep ${lowerdir}/file1
> +$SETCAP_PROG cap_setuid+ep ${lowerdir}/file2
>
> -_scratch_mount
> +_scratch_mount "-o metacopy=on"
>
>  # Trigger file copy up without actually writing anything to file. This
>  # requires opening file with WRITE and xfs_io opens file with
>  # O_RDWR by default.
> -$XFS_IO_PROG -c "stat" ${SCRATCH_MNT}/file >>$seqres.full
> +$XFS_IO_PROG -c "stat" ${SCRATCH_MNT}/file1 >>$seqres.full
>
>  # Make sure cap_setuid is still there
> -$GETCAP_PROG ${SCRATCH_MNT}/file | _filter_scratch
> +$GETCAP_PROG ${SCRATCH_MNT}/file1 | _filter_scratch
> +
> +# Trigger metadata only copy-up
> +chmod 000 ${SCRATCH_MNT}/file2
> +
> +# Trigger data copy-up
> +$XFS_IO_PROG -c "stat" ${SCRATCH_MNT}/file2 >>$seqres.full
> +
> +# Make sure cap_setuid is still there
> +$GETCAP_PROG ${SCRATCH_MNT}/file2 | _filter_scratch
>
>  # success, all done
>  status=0
> Index: xfstests-dev/tests/overlay/064.out
> ===================================================================
> --- xfstests-dev.orig/tests/overlay/064.out     2019-01-28 15:03:12.590434802 -0500
> +++ xfstests-dev/tests/overlay/064.out  2019-01-30 13:42:35.342840084 -0500
> @@ -1,2 +1,3 @@
>  QA output created by 064
> -SCRATCH_MNT/file = cap_setuid+ep
> +SCRATCH_MNT/file1 = cap_setuid+ep
> +SCRATCH_MNT/file2 = cap_setuid+ep
