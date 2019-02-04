Return-Path: <amir73il@gmail.com>
MIME-Version: 1.0
References: <20190204183454.GA19549@redhat.com>
In-Reply-To: <20190204183454.GA19549@redhat.com>
From: Amir Goldstein <amir73il@gmail.com>
Date: Mon, 4 Feb 2019 22:04:42 +0200
Message-ID: <CAOQ4uxjVJHd4iSs12yn8UJrG8rXwF1-By9zauzYQaPSFoTiLZA@mail.gmail.com>
Subject: Re: [PATCH] xfstest, overlayfs: Use falloc to make sure a meta copy
 file got copied up
Content-Type: text/plain; charset="UTF-8"
To: Vivek Goyal <vgoyal@redhat.com>
Cc: fstests <fstests@vger.kernel.org>, overlayfs <linux-unionfs@vger.kernel.org>, Miklos Szeredi <miklos@szeredi.hu>
List-ID: <linux-unionfs@vger.kernel.org>

On Mon, Feb 4, 2019 at 8:34 PM Vivek Goyal <vgoyal@redhat.com> wrote:
>
> Overlayfs might copy up data of file on first write of file (and
> not necessarily upon open of file). So call falloc file opened
> with O_RDWR and after that data must have been copied up.
>
> Signed-off-by: Vivek Goyal <vgoyal@redhat.com>
Reviewed-by: Amir Goldstein <amir73il@gmail.com>

> ---
>  tests/overlay/060 |    2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>
> Index: xfstests-dev/tests/overlay/060
> ===================================================================
> --- xfstests-dev.orig/tests/overlay/060 2018-08-27 11:21:51.811847671 -0400
> +++ xfstests-dev/tests/overlay/060      2019-02-04 11:28:09.023718690 -0500
> @@ -170,7 +170,7 @@ test_common()
>
>         # Trigger data copy up and check absence of metacopy xattr.
>         mount_overlay $_lowerdir
> -       $XFS_IO_PROG -c "open -a $SCRATCH_MNT/$_target"
> +       $XFS_IO_PROG -c "falloc 0 1" $SCRATCH_MNT/$_target >> $seqres.full
>         echo "check properties of data copied up file"
>         check_file_size_contents $SCRATCH_MNT/$_target $_size "$_data"
>         umount_overlay
