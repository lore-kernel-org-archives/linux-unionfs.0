From: Amir Goldstein <amir73il@gmail.com>
Subject: Re: [PATCH] overlay/038: Miscellaneous fixes
Date: Sun, 8 Oct 2017 21:39:45 +0300
Message-ID: <CAOQ4uxgJrexT9AHe4rKD-AQhsd70EyFLn2tFW++4MEUQfpP+Jw@mail.gmail.com>
References: <20171008112535.18975-1-chandan@linux.vnet.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-unionfs-owner@vger.kernel.org>
Received: from mail-qt0-f193.google.com ([209.85.216.193]:35602 "EHLO
        mail-qt0-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753236AbdJHSjq (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Sun, 8 Oct 2017 14:39:46 -0400
In-Reply-To: <20171008112535.18975-1-chandan@linux.vnet.ibm.com>
Sender: linux-unionfs-owner@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org
To: Chandan Rajendra <chandan@linux.vnet.ibm.com>
Cc: fstests <fstests@vger.kernel.org>, overlayfs <linux-unionfs@vger.kernel.org>, Eryu Guan <eguan@redhat.com>

On Sun, Oct 8, 2017 at 2:25 PM, Chandan Rajendra
<chandan@linux.vnet.ibm.com> wrote:
> This commit removes the redundant chown operation which was supposed to
> cause the test file to be copied up. Also, _overlay_scratch_unmount() is
> used to unmount the overlay filesystem rather than invoking $UMOUNT_PROG.
>
> Signed-off-by: Chandan Rajendra <chandan@linux.vnet.ibm.com>
> ---
>  tests/overlay/038 | 8 +++-----
>  1 file changed, 3 insertions(+), 5 deletions(-)
>
> diff --git a/tests/overlay/038 b/tests/overlay/038
> index 57281fa..148995b 100755
> --- a/tests/overlay/038
> +++ b/tests/overlay/038
> @@ -1,7 +1,7 @@
>  #! /bin/bash
>  # FSQA Test No. 038
>  #
> -# Test constant d_ino numbers
> +# Test consistent d_ino numbers for samefs setup.
>  #
>  #-----------------------------------------------------------------------
>  #
> @@ -102,10 +102,8 @@ current_d=$($here/src/t_dir_type $impure_dir $impure_dir_st_ino)
>  [[ $current_d == ". d" ]] || \
>      echo "Before dir becomes impure: Invalid d_ino reported for ."
>
> -chown -h 100 $SCRATCH_MNT/test_file
> -test_file_st_ino=$(stat -c '%i' $SCRATCH_MNT/test_file)
> -
>  mv $SCRATCH_MNT/test_file $impure_dir
> +test_file_st_ino=$(stat -c '%i' $impure_dir/test_file)
>
>  impure=$($GETFATTR_PROG --absolute-names --only-values -n 'trusted.overlay.impure' \
>                         $upperdir/test_dir/impure_dir)
> @@ -187,7 +185,7 @@ parent_d=$($here/src/t_dir_type $SCRATCH_MNT/test_dir/pure_lower_dir $test_dir_s
>  [[ $parent_d == ".. d" ]] || \
>         echo "Pure lower in dir which has another lower layer: Invalid d_ino reported for .."
>
> -$UMOUNT_PROG $SCRATCH_MNT
> +_overlay_scratch_unmount
>

Neither variant is really needed at end of test but fine.

>  echo "Silence is golden"
>  status=0
> --
> 2.9.5
>
