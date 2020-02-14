Return-Path: <SRS0=3MWK=4C=vger.kernel.org=linux-unionfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.6 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E811CC35242
	for <linux-unionfs@archiver.kernel.org>; Fri, 14 Feb 2020 22:06:32 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id ADA122081E
	for <linux-unionfs@archiver.kernel.org>; Fri, 14 Feb 2020 22:06:32 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="i7mpvqjy"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727458AbgBNWGc (ORCPT
        <rfc822;linux-unionfs@archiver.kernel.org>);
        Fri, 14 Feb 2020 17:06:32 -0500
Received: from mail-il1-f195.google.com ([209.85.166.195]:41772 "EHLO
        mail-il1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726101AbgBNWGc (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Fri, 14 Feb 2020 17:06:32 -0500
Received: by mail-il1-f195.google.com with SMTP id f10so9306658ils.8;
        Fri, 14 Feb 2020 14:06:30 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=lcbJe5atNgncClgN4FOXbcTmuKj4xD8tXw3N8zYwid4=;
        b=i7mpvqjyvtG+UssI6t/3ZplCCNyX3pxethQEI/nPV7UFtKGHtgaiBAjUg0ek2MXpU0
         llIQPhjK+sJVRMXC7W2FyyHF/UbGD4hR2oHh7gwwAfifcI1hZ1GapwGDiOsa5oMNkZiW
         04cGCTRNSRwfTM/oxEn/nuX7ZbI598lEpVFsfVn2Jh2TSPLmJNKGFEqVM8ssep9MY0Qe
         XqFs0wLoOfjnaG4Off/Uyc3gS9KKhFnN6ZJI3s3zEfSBn58NLe0UD7VwM/m9VnUwrepQ
         1eBe+EjMjx3lXj4+Q8Q4kDaVHYoiNnIHGJKqjG2GDPOW24mFdPCnozrvSYYSyB0Pvi6U
         at4w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=lcbJe5atNgncClgN4FOXbcTmuKj4xD8tXw3N8zYwid4=;
        b=lJxQfT5f9mmWwMu0kPNe4312Z7/HXcETiYHkOIZuiSQKgHEAR6NMxx2b5J1S8WMAB1
         OmPSiLXOH8HYa3M8u1Ju76xqMnB+yqpPTr38vTNghEgvmh331Xg/nXAlRv2h3aggXVuS
         XwoFrNgoeDhEMKmbrdP/tu5TYvpE5c1sTCwF6sc7tMG5g9Mqprv3gkOLhGZXSTFThQHg
         SZgvYlUnMTEbN/fowKn9VAwgCH7VM5hOB5+NJHgMVNnuqO1QUZr1vDJsOC7m7VWhkmW0
         SF1XX1gAsspW+RjU9Yq6CgDqORV+m7njDcbM0GwNLpjWmXwOWJNIFavezupyRR+nGTlI
         IGPg==
X-Gm-Message-State: APjAAAW3wZbz5km02px3mBUfAS9tx+NzeRXrBl6G5iqg1LI8C056cXL+
        iGbEfRf1XreGSTUcg7PTok7Dsg4BJabBzT468i4=
X-Google-Smtp-Source: APXvYqwzWV4eFQ9Qwp4OZ6xwfdcUYdcTklgFaXx8XKeUDKXkOpbUrSz8YmWR/u4B2UUwme2ti1qEfeNkOoiz0I9l1IE=
X-Received: by 2002:a92:5c8a:: with SMTP id d10mr5237068ilg.137.1581717990449;
 Fri, 14 Feb 2020 14:06:30 -0800 (PST)
MIME-Version: 1.0
References: <20200214151848.8328-1-mfo@canonical.com> <20200214151848.8328-2-mfo@canonical.com>
In-Reply-To: <20200214151848.8328-2-mfo@canonical.com>
From:   Amir Goldstein <amir73il@gmail.com>
Date:   Sat, 15 Feb 2020 00:06:19 +0200
Message-ID: <CAOQ4uxj9d6G-RF4i7JQ3EfV6q=YFWLhBCWOK+zf5Xy08KqTGOA@mail.gmail.com>
Subject: Re: [PATCH v2 1/5] common/overlay,rc,config: introduce OVL_FSTYP
 variable and aufs
To:     Mauricio Faria de Oliveira <mfo@canonical.com>
Cc:     fstests <fstests@vger.kernel.org>,
        overlayfs <linux-unionfs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-unionfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-unionfs.vger.kernel.org>
X-Mailing-List: linux-unionfs@vger.kernel.org

On Fri, Feb 14, 2020 at 5:18 PM Mauricio Faria de Oliveira
<mfo@canonical.com> wrote:
>
> Recently I was looking for an aufs test suite, and reached out to
> Okajima, but 'There is no public test suite specific to aufs.' [1],
> and it looks like 'xfstests/tests/generic' should be enough [1, 2].
>
> Thus, building on top existing xfstests support for overlay just
> introduce the OVL_FSTYP variable, and the default value "overlay"
> can be changed to "aufs" (uses overlay's upperdir as a rw-branch
> and lowerdir as a ro-branch; workdir is not used.)
>
> This is indeed a workaround^W simple change that does the job vs.
> creating a new FSTYP "aufs" and mechanically changing the number
> of places that check for "overlay" to just handle "aufs" as well.
> (so the effort is still small as aufs has no specific tests now.)
>
> This also allows testing fuse-overlayfs with the next patches.
>
> The changes are minimal -- just translate overlay mount options
> and use $OVL_FSTYP as filesystem type for checking/mount/umount;
> then report it in log headers and document it in README.overlay.
>
> Currently, running './check -overlay' tests (excluding a few [3]
> which either hang or keep looping) the numbers for aufs on loop
> devices on v5.4-based Ubuntu kernel are:
>
>   - Ran: 645 tests
>   - Not run: 483 tests
>   - Failures: 22 tests
>
> So, hopefully this may help with a starting point for an public
> test suite for aufs.
>
> Thanks to Amir Goldstein for feedback/improvements and pointers
> to support fuse-overlayfs as well [v2].
>
> [1] https://sourceforge.net/p/aufs/mailman/message/36918721/
> [2] https://sourceforge.net/p/aufs/mailman/message/36918932/
> [3] Steps:
>
>   $ export OVL_FSTYP=aufs
>   $ export FSTYP=ext4
>   $ export TEST_DEV=/dev/loop0
>   $ export TEST_DIR=/mnt/test
>   $ export SCRATCH_DEV=/dev/loop1
>   $ export SCRATCH_MNT=/mnt/scratch
>
>   $ sudo mkfs.$FSTYP -F $TEST_DEV
>   $ sudo mkfs.$FSTYP -F $SCRATCH_DEV
>   $ sudo mkdir $TEST_DIR $SCRATCH_MNT
>
>   $ cat <<EOF >/tmp/exclude-tests
>   generic/013
>   generic/070
>   generic/075
>   generic/112
>   generic/127
>   generic/461
>   generic/476
>   generic/522
>   generic/530
>   overlay/019
>   EOF
>
>   $ sudo -E ./check -overlay -E /tmp/exclude-tests
>
> Signed-off-by: Mauricio Faria de Oliveira <mfo@canonical.com>
> ---
>  README.overlay |  4 ++++
>  common/config  |  2 ++
>  common/overlay | 11 ++++++++---
>  common/rc      |  6 ++++++
>  4 files changed, 20 insertions(+), 3 deletions(-)
>
> diff --git a/README.overlay b/README.overlay
> index 30b5ddb2d1c3..08a39b8830c9 100644
> --- a/README.overlay
> +++ b/README.overlay
> @@ -50,3 +50,7 @@ In the example above, MOUNT_OPTIONS will be used to mount the base scratch fs,
>  TEST_FS_MOUNT_OPTS will be used to mount the base test fs,
>  OVERLAY_MOUNT_OPTIONS will be used to mount both test and scratch overlay and
>  OVERLAY_FSCK_OPTIONS will be used to check both test and scratch overlay.
> +
> +To test other filesystem types (experimental) configure the OVL_FSTYP variable:
> +
> + OVL_FSTYP=aufs
> diff --git a/common/config b/common/config
> index 9a9c77602b54..d92a78003295 100644
> --- a/common/config
> +++ b/common/config
> @@ -71,6 +71,8 @@ export OVL_LOWER="ovl-lower"
>  export OVL_WORK="ovl-work"
>  # overlay mount point parent must be the base fs root
>  export OVL_MNT="ovl-mnt"
> +# overlay mount filesystem type (for testing other fs)
> +export OVL_FSTYP=${OVL_FSTYP:-overlay}
>
>  # From e2fsprogs/e2fsck/e2fsck.h:
>  # Exit code used by fsck-type programs
> diff --git a/common/overlay b/common/overlay
> index 65c639e9c6d8..a1076926c23f 100644
> --- a/common/overlay
> +++ b/common/overlay
> @@ -18,10 +18,15 @@ _overlay_mount_dirs()
>         local lowerdir=$1
>         local upperdir=$2
>         local workdir=$3
> +       local options
>         shift 3
>
> -       $MOUNT_PROG -t overlay -o lowerdir=$lowerdir -o upperdir=$upperdir \
> -                   -o workdir=$workdir `_common_dev_mount_options $*`
> +       options="-o lowerdir=$lowerdir -o upperdir=$upperdir -o workdir=$workdir"
> +       if [ "$OVL_FSTYP" = "aufs" ]; then
> +               options="-o br=$upperdir=rw -o br=$lowerdir=ro"
> +       fi
> +
> +       $MOUNT_PROG -t $OVL_FSTYP $options `_common_dev_mount_options $*`
>  }
>
>  # Mount with same options/mnt/dev of scratch mount, but optionally
> @@ -302,7 +307,7 @@ _overlay_check_fs()
>                 _overlay_base_mount $*
>         else
>                 # Check and umount overlay for dir check
> -               ovl_mounted=`_is_dir_mountpoint $ovl_mnt`
> +               ovl_mounted=`_is_dir_mountpoint $ovl_mnt $OVL_FSTYP`
>                 [ -z "$ovl_mounted" ] || $UMOUNT_PROG $ovl_mnt
>         fi
>
> diff --git a/common/rc b/common/rc
> index b4a77a2187f4..1feae1a94f9e 100644
> --- a/common/rc
> +++ b/common/rc
> @@ -1471,6 +1471,10 @@ _check_mounted_on()
>                 return 2 # 2 = mounted on wrong mnt
>         fi
>
> +       if [ -n "$type" -a "$type" = "overlay" ]; then
> +               type="$OVL_FSTYP"
> +       fi
> +

Hmm. I found 2 other instances of _fs_type in common/rc.
I think it would be safer to let _fs_type return "overlay" in
case the mounted fs is of type $OVL_FSTYP.
This will be simple to do by extending the sed expression -
no need for special cases and conditions.

Other than that, patch looks good.

Thanks,
Amir.

>         if [ -n "$type" -a "`_fs_type $dev`" != "$type" ]; then
>                 echo "$devname=$dev is mounted but not a type $type filesystem"
>                 # raw $DF_PROG cannot handle NFS/CIFS/overlay correctly
> @@ -2841,6 +2845,8 @@ _full_fstyp_details()
>                 FSTYP="$FSTYP (non-debug)"
>             fi
>         fi
> +     elif [ $FSTYP = "overlay" -a "$OVL_FSTYP" != "overlay" ]; then
> +       FSTYP="$FSTYP ($OVL_FSTYP)"
>       fi
>       echo $FSTYP
>  }
> --
> 2.20.1
>
