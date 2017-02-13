From: Amir Goldstein <amir73il@gmail.com>
Subject: Re: [PATCH v3 8/9] overlay: fix test and scratch filters for overlay
 base fs
Date: Mon, 13 Feb 2017 22:39:35 +0200
Message-ID: <CAOQ4uxiUa5Ws=7J2hT9U=z2iMBfJ4Kec9YrTC_s4egy=9m6XwA@mail.gmail.com>
References: <1486932224-17075-1-git-send-email-amir73il@gmail.com> <1486932224-17075-9-git-send-email-amir73il@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-unionfs-owner@vger.kernel.org>
Received: from mail-ot0-f196.google.com ([74.125.82.196]:34798 "EHLO
        mail-ot0-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752282AbdBMUjh (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Mon, 13 Feb 2017 15:39:37 -0500
In-Reply-To: <1486932224-17075-9-git-send-email-amir73il@gmail.com>
Sender: linux-unionfs-owner@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org
To: Eryu Guan <eguan@redhat.com>
Cc: Miklos Szeredi <miklos@szeredi.hu>, linux-unionfs@vger.kernel.org, fstests <fstests@vger.kernel.org>

On Sun, Feb 12, 2017 at 10:43 PM, Amir Goldstein <amir73il@gmail.com> wrote:
> When configuring overlay base fs, TEST_DEV/DIR and SCRATCH_DEV/MNT
> are derived from the base fs mount points, where *_DEV are the
> path of the base fs mount point and TEST_DIR/SCRATCH_MNT are
> a directory under the base fs mount point.
>
> This means that the overlay DEV paths are prefixes of the overlay
> mount points.
> Fix the test and sctach filters to try and match TEST_DIR/SCRATCH_MNT
> first and only then try and match the shorter *_DEV.
>

And who would have thought that MNT could also be a substr of DEV?
Well is kvm-xfstests it is!

I will have to check for echo $SCRATCH_DEV | grep $SCRATCH_MNT
and vice versa explicitly before deciding which filter order to use.

FSTYP         -- xfs (debug)
PLATFORM      -- Linux/x86_64 kvm-xfstests 4.9.0-debug-12264-g60ae0f1
MKFS_OPTIONS  -- -f -m rmapbt=1,reflink=1 /dev/vdc
MOUNT_OPTIONS -- /dev/vdc /vdc

 [20:36:04] - output mismatch (see
/results/xfs/results-reflink/generic/050.out.bad)
    --- tests/generic/050.out 2017-02-13 08:36:18.000000000 +0000
    +++ /results/xfs/results-reflink/generic/050.out.bad 2017-02-13
20:36:04.054172980 +0000
    @@ -1,7 +1,7 @@
     QA output created by 050
     setting device read-only
     mounting read-only block device:
    -mount: SCRATCH_DEV is write-protected, mounting read-only
    +mount: /devSCRATCH_MNT is write-protected, mounting read-only
     touching file on read-only filesystem (should fail)
     touch: cannot touch 'SCRATCH_MNT/foo': Read-only file system
    ...


> Signed-off-by: Amir Goldstein <amir73il@gmail.com>
> ---
>  common/filter | 7 ++++---
>  1 file changed, 4 insertions(+), 3 deletions(-)
>
> diff --git a/common/filter b/common/filter
> index 4328159..ef20ea6 100644
> --- a/common/filter
> +++ b/common/filter
> @@ -280,13 +280,14 @@ _filter_xfs_io_pages_modified()
>
>  _filter_test_dir()
>  {
> -       sed -e "s,$TEST_DEV,TEST_DEV,g" -e "s,$TEST_DIR,TEST_DIR,g"
> +       sed -e "s,$TEST_DIR,TEST_DIR,g" \
> +           -e "s,$TEST_DEV,TEST_DEV,g"
>  }
>
>  _filter_scratch()
>  {
> -       sed -e "s,$SCRATCH_DEV,SCRATCH_DEV,g" \
> -           -e "s,$SCRATCH_MNT,SCRATCH_MNT,g" \
> +       sed -e "s,$SCRATCH_MNT,SCRATCH_MNT,g" \
> +           -e "s,$SCRATCH_DEV,SCRATCH_DEV,g" \
>             -e "/.use_space/d"
>  }
>
> --
> 2.7.4
>
