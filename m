Received: from mail-qv1-f42.google.com (mail-qv1-f42.google.com [209.85.219.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 71081537FD;
	Mon, 25 Dec 2023 20:08:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="beSAOAYC"
Received: by mail-qv1-f42.google.com with SMTP id 6a1803df08f44-67f147c04b7so36630106d6.2;
        Mon, 25 Dec 2023 12:08:31 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1703534910; x=1704139710; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=shEeyr+LcqwS6mk/WkYt3fmysBoddKrwyyhSaKBTn8A=;
        b=beSAOAYC777LXTW4wbjH/nA5IY9rg4nIOzphhi5D27IYpBHxihSEwRF/ApUGcxwyPy
         BQrUZZv1+n7aAX4EoQydFI72qLiacoWfyFf85Z901grjsQrzVsaSQugpnXHKvi0eorhZ
         OK+wosAtJLin3RwK2qr9mJfXmy5Lr3zdNYkcAzp+z8lb1zuGPzmDN5RvimK0EH7S8Mt3
         qcoCef5Z4Po1jYUqj6yAQilEx4BlvTGF+zVqsB53j+LOvbzcyR9R5CC4o87ozG8FbmWA
         QnPXqxvzhTnjVwDbdw0tJSGVAoxLLRHcnkJ0VEfW6SGFyqdBDTldKF6mSfkBo4EsnJ3d
         17rg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1703534910; x=1704139710;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=shEeyr+LcqwS6mk/WkYt3fmysBoddKrwyyhSaKBTn8A=;
        b=fEaezmT6xM66Q6RJgpMMh6+M6tCLblaiy4TVM9hUy3JuFVVewFG5V5nK6/X6hhaiPl
         NjzAgwad7mzoV4PvtUNEP3W64MBQvqru/hYtbg2sVDWsf4eSInUrTeuI5DE9AkLDQNB5
         VEWPSvsH+PZPC8Y48JBEaIP0mYcdmEtL/PHV4UHsGLyQ2xlNZrtK9oHxSsZPJpMPkNwI
         ZdsZnevJR1stAeUIlTQfi4KVIS587koeZ1eUusxMroGiQGOwAeZovlvGeWtC6JL4Gx47
         AST0kgvk1VpbN/fj7EFGuj4oaGhG5pntOnDuT3+zdFZlrLjkOGAtUBL7do935lLIDh/n
         MCZQ==
X-Gm-Message-State: AOJu0YyUmVypuz7SrQuxt3PezUChHtc4/A7QrEz04KQPbq0IpjJhJe8n
	1S3qt+5MNKz5f0Rq3BOjpAqRQe/jzLwbxB7dA+w=
X-Google-Smtp-Source: AGHT+IGCiTVR/PcvM1XRuO6eXaWJ7WmAEj9XLcrGAzPTKSopYzV3AI3I05M+38un4/HFNG2VNDky+x2szS4KCyzfQbU=
X-Received: by 2002:a05:6214:18d:b0:67f:de0c:1aa with SMTP id
 q13-20020a056214018d00b0067fde0c01aamr3990646qvr.123.1703534910316; Mon, 25
 Dec 2023 12:08:30 -0800 (PST)
Precedence: bulk
X-Mailing-List: linux-unionfs@vger.kernel.org
List-Id: <linux-unionfs.vger.kernel.org>
List-Subscribe: <mailto:linux-unionfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-unionfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20231206121857.3873367-1-amir73il@gmail.com>
In-Reply-To: <20231206121857.3873367-1-amir73il@gmail.com>
From: Amir Goldstein <amir73il@gmail.com>
Date: Mon, 25 Dec 2023 22:08:19 +0200
Message-ID: <CAOQ4uxjFMThryZXt3cS0nAMgBxCgNXvXJv-WqQAgVe4--CZqHw@mail.gmail.com>
Subject: Re: [PATCH] overlay: create helper _overlay_scratch_mount_opts()
To: Zorro Lang <zlang@redhat.com>
Cc: Alexander Larsson <alexl@redhat.com>, Miklos Szeredi <miklos@szeredi.hu>, linux-unionfs@vger.kernel.org, 
	fstests@vger.kernel.org, Zorro Lang <zlang@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, Dec 6, 2023 at 2:19=E2=80=AFPM Amir Goldstein <amir73il@gmail.com> =
wrote:
>
> The new overlayfs mount options lowerdir+,datadir+ don't fit well
> into any of the existing _overlay_scratch_mount* helpers.
> Add this new helper to reduce a common pattern of custom mount options.
>
> Suggested-by: Zorro Lang <zlang@kernel.org>
> Signed-off-by: Amir Goldstein <amir73il@gmail.com>
> ---
>
> Zorro,
>
> Here is the cleanup patch that you suggested.
>
> Note that tests overlay/083 and overlay/086 intentionally use
> $MOUNT_PROG directly because some of the tests cases use escaping
> character "\" and calling _overlay_mount_* helpers can loose the
> special chars escaping when bash is evaluating the arguments.
>
> Maybe it is solvabale, but that would be very high on the list of
> things that I do not want to do.
>

Hi Zorro,

I guess you missed this cleanup patch for the Xmas release.
Oh well, next time.

Merry Christmas and Happy New Year!

Thanks,
Amir.

>
>  common/overlay    | 8 +++++++-
>  tests/overlay/011 | 2 +-
>  tests/overlay/035 | 3 +--
>  tests/overlay/052 | 4 ++--
>  tests/overlay/053 | 4 ++--
>  tests/overlay/062 | 2 +-
>  tests/overlay/079 | 4 ++--
>  tests/overlay/085 | 4 ++--
>  8 files changed, 18 insertions(+), 13 deletions(-)
>
> diff --git a/common/overlay b/common/overlay
> index ea1eb7b1..faa9339a 100644
> --- a/common/overlay
> +++ b/common/overlay
> @@ -32,6 +32,12 @@ _overlay_mount_dirs()
>         $MOUNT_PROG -t overlay $diropts `_common_dev_mount_options $*`
>  }
>
> +# Mount with mnt/dev of scratch mount and custom mount options
> +_overlay_scratch_mount_opts()
> +{
> +       $MOUNT_PROG -t overlay $OVL_BASE_SCRATCH_MNT $SCRATCH_MNT $*
> +}
> +
>  # Mount with same options/mnt/dev of scratch mount, but optionally
>  # with different lower/upper/work dirs
>  _overlay_scratch_mount_dirs()
> @@ -254,7 +260,7 @@ _require_scratch_overlay_lowerdir_add_layers()
>         local datadir=3D"$OVL_BASE_SCRATCH_MNT/$OVL_LOWER"
>
>         _scratch_mkfs > /dev/null 2>&1
> -       $MOUNT_PROG -t overlay $OVL_BASE_SCRATCH_MNT $SCRATCH_MNT \
> +       _overlay_scratch_mount_opts \
>                 -o"lowerdir+=3D$lowerdir,datadir+=3D$datadir" \
>                 -o"redirect_dir=3Dfollow,metacopy=3Don" > /dev/null 2>&1 =
|| \
>                 _notrun "overlay lowerdir+,datadir+ not supported on ${SC=
RATCH_DEV}"
> diff --git a/tests/overlay/011 b/tests/overlay/011
> index 20812d88..09a950ba 100755
> --- a/tests/overlay/011
> +++ b/tests/overlay/011
> @@ -37,7 +37,7 @@ $SETFATTR_PROG -n "trusted.overlay.opaque" -v "y" $uppe=
rdir/testdir
>  # $upperdir overlaid on top of $lowerdir, so that "trusted.overlay.opaqu=
e"
>  # xattr should be honored and should not be listed
>  # mount readonly, because there's no upper and workdir
> -$MOUNT_PROG -t overlay -o ro -o lowerdir=3D$upperdir:$lowerdir $OVL_BASE=
_SCRATCH_MNT $SCRATCH_MNT
> +_overlay_scratch_mount_opts -o ro -o lowerdir=3D$upperdir:$lowerdir
>
>  # Dump trusted.overlay xattr, we should not see the "opaque" xattr
>  _getfattr -d -m overlay $SCRATCH_MNT/testdir
> diff --git a/tests/overlay/035 b/tests/overlay/035
> index 8cd76979..f4c981ad 100755
> --- a/tests/overlay/035
> +++ b/tests/overlay/035
> @@ -42,8 +42,7 @@ mkdir -p $lowerdir1 $lowerdir2 $upperdir $workdir
>
>  # Mount overlay with lower layers only.
>  # Verify that overlay is mounted read-only and that it cannot be remount=
ed rw.
> -$MOUNT_PROG -t overlay -o"lowerdir=3D$lowerdir2:$lowerdir1" \
> -                       $OVL_BASE_SCRATCH_MNT $SCRATCH_MNT
> +_overlay_scratch_mount_opts -o"lowerdir=3D$lowerdir2:$lowerdir1"
>  touch $SCRATCH_MNT/foo 2>&1 | _filter_scratch
>  $MOUNT_PROG -o remount,rw $SCRATCH_MNT 2>&1 | _filter_ro_mount
>  $UMOUNT_PROG $SCRATCH_MNT
> diff --git a/tests/overlay/052 b/tests/overlay/052
> index da8c645b..6abe2e01 100755
> --- a/tests/overlay/052
> +++ b/tests/overlay/052
> @@ -133,7 +133,7 @@ unmount_dirs
>
>  # Check encode/decode/read of lower file handles on lower layers only r/=
o overlay.
>  # For non-upper overlay mount, nfs_export requires disabling redirect_di=
r.
> -$MOUNT_PROG -t overlay $OVL_BASE_SCRATCH_MNT $SCRATCH_MNT \
> +_overlay_scratch_mount_opts \
>                         -o ro,redirect_dir=3Dnofollow,nfs_export=3Don,low=
erdir=3D$middle:$lower
>  test_file_handles $SCRATCH_MNT/lowertestdir -rp
>  test_file_handles $SCRATCH_MNT/lowertestdir/subdir -rp
> @@ -144,7 +144,7 @@ unmount_dirs
>  # Overlay lookup cannot follow the redirect from $upper/lowertestdir.new=
 to
>  # $lower/lowertestdir. Instead, we mount an overlay subtree rooted at th=
ese
>  # directories.
> -$MOUNT_PROG -t overlay $OVL_BASE_SCRATCH_MNT $SCRATCH_MNT \
> +_overlay_scratch_mount_opts \
>                 -o ro,redirect_dir=3Dnofollow,nfs_export=3Don,lowerdir=3D=
$upper/lowertestdir.new:$lower/lowertestdir
>  test_file_handles $SCRATCH_MNT -r
>  test_file_handles $SCRATCH_MNT/subdir -rp
> diff --git a/tests/overlay/053 b/tests/overlay/053
> index dfa29d01..cf94f930 100755
> --- a/tests/overlay/053
> +++ b/tests/overlay/053
> @@ -162,7 +162,7 @@ unmount_dirs
>
>  # Check encode/decode/read of lower file handles on lower layers only r/=
o overlay.
>  # For non-upper overlay mount, nfs_export requires disabling redirect_di=
r.
> -$MOUNT_PROG -t overlay $OVL_BASE_SCRATCH_MNT $SCRATCH_MNT \
> +_overlay_scratch_mount_opts \
>                         -o ro,redirect_dir=3Dnofollow,nfs_export=3Don,low=
erdir=3D$middle:$lower
>  test_file_handles $SCRATCH_MNT/lowertestdir -rp
>  test_file_handles $SCRATCH_MNT/lowertestdir/subdir -rp
> @@ -173,7 +173,7 @@ unmount_dirs
>  # Overlay lookup cannot follow the redirect from $upper/lowertestdir.new=
 to
>  # $lower/lowertestdir. Instead, we mount an overlay subtree rooted at th=
ese
>  # directories.
> -$MOUNT_PROG -t overlay $OVL_BASE_SCRATCH_MNT $SCRATCH_MNT \
> +_overlay_scratch_mount_opts \
>                 -o ro,redirect_dir=3Dnofollow,nfs_export=3Don,lowerdir=3D=
$upper/lowertestdir.new:$lower/lowertestdir
>  test_file_handles $SCRATCH_MNT -r
>  test_file_handles $SCRATCH_MNT/subdir -rp
> diff --git a/tests/overlay/062 b/tests/overlay/062
> index 04e13e46..a4e9560a 100755
> --- a/tests/overlay/062
> +++ b/tests/overlay/062
> @@ -65,7 +65,7 @@ create_test_files $lowertestdir
>  $MOUNT_PROG --bind $lowertestdir $lowertestdir
>
>  # For non-upper overlay mount, nfs_export requires disabling redirect_di=
r.
> -$MOUNT_PROG -t overlay $OVL_BASE_SCRATCH_MNT $SCRATCH_MNT \
> +_overlay_scratch_mount_opts \
>         -o ro,redirect_dir=3Dnofollow,nfs_export=3Don,lowerdir=3D$lower:$=
lower2
>
>  # Decode an overlay directory file handle, whose underlying lower dir de=
ntry
> diff --git a/tests/overlay/079 b/tests/overlay/079
> index 078ee816..f28fc313 100755
> --- a/tests/overlay/079
> +++ b/tests/overlay/079
> @@ -141,7 +141,7 @@ mount_overlay()
>  {
>         local _lowerdir=3D$1 _datadir2=3D$2 _datadir=3D$3
>
> -       $MOUNT_PROG -t overlay $OVL_BASE_SCRATCH_MNT $SCRATCH_MNT \
> +       _overlay_scratch_mount_opts \
>                 -o"lowerdir=3D$_lowerdir::$_datadir2::$_datadir" \
>                 -o"upperdir=3D$upperdir,workdir=3D$workdir" \
>                 -o redirect_dir=3Don,metacopy=3Don
> @@ -151,7 +151,7 @@ mount_ro_overlay()
>  {
>         local _lowerdir=3D$1 _datadir2=3D$2 _datadir=3D$3
>
> -       $MOUNT_PROG -t overlay $OVL_BASE_SCRATCH_MNT $SCRATCH_MNT \
> +       _overlay_scratch_mount_opts \
>                 -o"lowerdir=3D$_lowerdir::$_datadir2::$_datadir" \
>                 -o redirect_dir=3Dfollow,metacopy=3Don
>  }
> diff --git a/tests/overlay/085 b/tests/overlay/085
> index 07a32c24..0f4e4b06 100755
> --- a/tests/overlay/085
> +++ b/tests/overlay/085
> @@ -142,7 +142,7 @@ mount_overlay()
>  {
>         local _lowerdir=3D$1 _datadir2=3D$2 _datadir=3D$3
>
> -       $MOUNT_PROG -t overlay $OVL_BASE_SCRATCH_MNT $SCRATCH_MNT \
> +       _overlay_scratch_mount_opts \
>                 -o"lowerdir+=3D$_lowerdir,datadir+=3D$_datadir2,datadir+=
=3D$_datadir" \
>                 -o"upperdir=3D$upperdir,workdir=3D$workdir" \
>                 -o redirect_dir=3Don,metacopy=3Don
> @@ -152,7 +152,7 @@ mount_ro_overlay()
>  {
>         local _lowerdir=3D$1 _datadir2=3D$2 _datadir=3D$3
>
> -       $MOUNT_PROG -t overlay $OVL_BASE_SCRATCH_MNT $SCRATCH_MNT \
> +       _overlay_scratch_mount_opts \
>                 -o"lowerdir+=3D$_lowerdir,datadir+=3D$_datadir2,datadir+=
=3D$_datadir" \
>                 -o redirect_dir=3Dfollow,metacopy=3Don
>  }
> --
> 2.34.1
>
