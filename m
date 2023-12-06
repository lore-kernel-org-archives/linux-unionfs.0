Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="CnvBj+uo"
Received: from mail-wm1-x332.google.com (mail-wm1-x332.google.com [IPv6:2a00:1450:4864:20::332])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CC82E9A;
	Wed,  6 Dec 2023 04:19:02 -0800 (PST)
Received: by mail-wm1-x332.google.com with SMTP id 5b1f17b1804b1-40c0a0d068bso33435875e9.3;
        Wed, 06 Dec 2023 04:19:02 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1701865141; x=1702469941; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=dVeeaUhHA3OEpCfniwSPXjh45fNvtiKeJJRS3qu6+KY=;
        b=CnvBj+uo+1loN0ICKreIgGbMnAgvh3HBGMh3CAuDMCk1ArRy6Usr1uU43EmFyKJBqk
         DePryVIrA0VBaYxqmPDkDT2X82feHqLThK+x5Wf21Stc/CYXrveMcOCqbck1yzxVVMJj
         py8Gd5gF1z1ISg40CBO4xmtNhBNsmU916dvcKweYHBXtGdGSVaqtErq1uuXYID3TY26z
         yHYrK3RbGMHxUhZ4cMLFB0MS9hrIo3QsZ2x0m59iBXKG0ICnS3I1Qktvd56oaqGAGTC+
         Q2mAiLW7nheeW2NMUq/4DvK4I5ehN6LKgo1HpBPQ5K8zfmWZ0rY5PK/nDJwXgBvbSM/Z
         TxIg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1701865141; x=1702469941;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=dVeeaUhHA3OEpCfniwSPXjh45fNvtiKeJJRS3qu6+KY=;
        b=pclhIqeYl6NRexEBPJvm2pbsshs7/OPYka7PHnRYHnVi4Bhr8H7I4WQSK5U02bemeP
         dnIMBWNiWMKiCax1Yubv86Y13S5qy6TVIO53/iMDJroGpjcmSCdVTE3AjrSYhW4W8SAx
         92pbM+d5YYwdR/EtEBQFNfh41ZSqrBjdBcCOcstYk7A4G8d+9BaIZAmQ8KB+zw1OSmiZ
         dfPjm/n/4WD93SjLx1HBcmoTRmmOUw612y17IEmadb6/RxdXBL8BA31w9+SpbNUnMqMh
         6Up6ciNC4337ApxhqYRreLr5cpO7cjfh1H9abwPyCVj8U7CnlBY0f38T4bApt1T8HnRq
         tizA==
X-Gm-Message-State: AOJu0Yw7FtFMaBeC8X8MVTlGWYvgb+lMnRLsAJwV/UjASAgzcVIkfa6l
	MX6vvbsaAffE+BpZ1U2w0Z8=
X-Google-Smtp-Source: AGHT+IHRKYDR9yEzgQCVjtEGEgIlHHHcfJBJwGVW+9+NCGtfi8f/Bmx00CZV025jj+PZuhGuQREOuA==
X-Received: by 2002:a05:600c:a43:b0:40b:45e2:1f56 with SMTP id c3-20020a05600c0a4300b0040b45e21f56mr684953wmq.39.1701865140923;
        Wed, 06 Dec 2023 04:19:00 -0800 (PST)
Received: from amir-ThinkPad-T480.lan ([5.29.249.86])
        by smtp.gmail.com with ESMTPSA id n10-20020a05600c4f8a00b0040b4b2a15ebsm21608082wmq.28.2023.12.06.04.18.59
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 06 Dec 2023 04:19:00 -0800 (PST)
From: Amir Goldstein <amir73il@gmail.com>
To: Zorro Lang <zlang@redhat.com>
Cc: Alexander Larsson <alexl@redhat.com>,
	Miklos Szeredi <miklos@szeredi.hu>,
	linux-unionfs@vger.kernel.org,
	fstests@vger.kernel.org,
	Zorro Lang <zlang@kernel.org>
Subject: [PATCH] overlay: create helper _overlay_scratch_mount_opts()
Date: Wed,  6 Dec 2023 14:18:57 +0200
Message-Id: <20231206121857.3873367-1-amir73il@gmail.com>
X-Mailer: git-send-email 2.34.1
Precedence: bulk
X-Mailing-List: linux-unionfs@vger.kernel.org
List-Id: <linux-unionfs.vger.kernel.org>
List-Subscribe: <mailto:linux-unionfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-unionfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

The new overlayfs mount options lowerdir+,datadir+ don't fit well
into any of the existing _overlay_scratch_mount* helpers.
Add this new helper to reduce a common pattern of custom mount options.

Suggested-by: Zorro Lang <zlang@kernel.org>
Signed-off-by: Amir Goldstein <amir73il@gmail.com>
---

Zorro,

Here is the cleanup patch that you suggested.

Note that tests overlay/083 and overlay/086 intentionally use
$MOUNT_PROG directly because some of the tests cases use escaping
character "\" and calling _overlay_mount_* helpers can loose the
special chars escaping when bash is evaluating the arguments.

Maybe it is solvabale, but that would be very high on the list of
things that I do not want to do.

Thanks,
Amir.

 common/overlay    | 8 +++++++-
 tests/overlay/011 | 2 +-
 tests/overlay/035 | 3 +--
 tests/overlay/052 | 4 ++--
 tests/overlay/053 | 4 ++--
 tests/overlay/062 | 2 +-
 tests/overlay/079 | 4 ++--
 tests/overlay/085 | 4 ++--
 8 files changed, 18 insertions(+), 13 deletions(-)

diff --git a/common/overlay b/common/overlay
index ea1eb7b1..faa9339a 100644
--- a/common/overlay
+++ b/common/overlay
@@ -32,6 +32,12 @@ _overlay_mount_dirs()
 	$MOUNT_PROG -t overlay $diropts `_common_dev_mount_options $*`
 }
 
+# Mount with mnt/dev of scratch mount and custom mount options
+_overlay_scratch_mount_opts()
+{
+	$MOUNT_PROG -t overlay $OVL_BASE_SCRATCH_MNT $SCRATCH_MNT $*
+}
+
 # Mount with same options/mnt/dev of scratch mount, but optionally
 # with different lower/upper/work dirs
 _overlay_scratch_mount_dirs()
@@ -254,7 +260,7 @@ _require_scratch_overlay_lowerdir_add_layers()
 	local datadir="$OVL_BASE_SCRATCH_MNT/$OVL_LOWER"
 
 	_scratch_mkfs > /dev/null 2>&1
-	$MOUNT_PROG -t overlay $OVL_BASE_SCRATCH_MNT $SCRATCH_MNT \
+	_overlay_scratch_mount_opts \
 		-o"lowerdir+=$lowerdir,datadir+=$datadir" \
 		-o"redirect_dir=follow,metacopy=on" > /dev/null 2>&1 || \
 	        _notrun "overlay lowerdir+,datadir+ not supported on ${SCRATCH_DEV}"
diff --git a/tests/overlay/011 b/tests/overlay/011
index 20812d88..09a950ba 100755
--- a/tests/overlay/011
+++ b/tests/overlay/011
@@ -37,7 +37,7 @@ $SETFATTR_PROG -n "trusted.overlay.opaque" -v "y" $upperdir/testdir
 # $upperdir overlaid on top of $lowerdir, so that "trusted.overlay.opaque"
 # xattr should be honored and should not be listed
 # mount readonly, because there's no upper and workdir
-$MOUNT_PROG -t overlay -o ro -o lowerdir=$upperdir:$lowerdir $OVL_BASE_SCRATCH_MNT $SCRATCH_MNT
+_overlay_scratch_mount_opts -o ro -o lowerdir=$upperdir:$lowerdir
 
 # Dump trusted.overlay xattr, we should not see the "opaque" xattr
 _getfattr -d -m overlay $SCRATCH_MNT/testdir
diff --git a/tests/overlay/035 b/tests/overlay/035
index 8cd76979..f4c981ad 100755
--- a/tests/overlay/035
+++ b/tests/overlay/035
@@ -42,8 +42,7 @@ mkdir -p $lowerdir1 $lowerdir2 $upperdir $workdir
 
 # Mount overlay with lower layers only.
 # Verify that overlay is mounted read-only and that it cannot be remounted rw.
-$MOUNT_PROG -t overlay -o"lowerdir=$lowerdir2:$lowerdir1" \
-			$OVL_BASE_SCRATCH_MNT $SCRATCH_MNT
+_overlay_scratch_mount_opts -o"lowerdir=$lowerdir2:$lowerdir1"
 touch $SCRATCH_MNT/foo 2>&1 | _filter_scratch
 $MOUNT_PROG -o remount,rw $SCRATCH_MNT 2>&1 | _filter_ro_mount
 $UMOUNT_PROG $SCRATCH_MNT
diff --git a/tests/overlay/052 b/tests/overlay/052
index da8c645b..6abe2e01 100755
--- a/tests/overlay/052
+++ b/tests/overlay/052
@@ -133,7 +133,7 @@ unmount_dirs
 
 # Check encode/decode/read of lower file handles on lower layers only r/o overlay.
 # For non-upper overlay mount, nfs_export requires disabling redirect_dir.
-$MOUNT_PROG -t overlay $OVL_BASE_SCRATCH_MNT $SCRATCH_MNT \
+_overlay_scratch_mount_opts \
 			-o ro,redirect_dir=nofollow,nfs_export=on,lowerdir=$middle:$lower
 test_file_handles $SCRATCH_MNT/lowertestdir -rp
 test_file_handles $SCRATCH_MNT/lowertestdir/subdir -rp
@@ -144,7 +144,7 @@ unmount_dirs
 # Overlay lookup cannot follow the redirect from $upper/lowertestdir.new to
 # $lower/lowertestdir. Instead, we mount an overlay subtree rooted at these
 # directories.
-$MOUNT_PROG -t overlay $OVL_BASE_SCRATCH_MNT $SCRATCH_MNT \
+_overlay_scratch_mount_opts \
 		-o ro,redirect_dir=nofollow,nfs_export=on,lowerdir=$upper/lowertestdir.new:$lower/lowertestdir
 test_file_handles $SCRATCH_MNT -r
 test_file_handles $SCRATCH_MNT/subdir -rp
diff --git a/tests/overlay/053 b/tests/overlay/053
index dfa29d01..cf94f930 100755
--- a/tests/overlay/053
+++ b/tests/overlay/053
@@ -162,7 +162,7 @@ unmount_dirs
 
 # Check encode/decode/read of lower file handles on lower layers only r/o overlay.
 # For non-upper overlay mount, nfs_export requires disabling redirect_dir.
-$MOUNT_PROG -t overlay $OVL_BASE_SCRATCH_MNT $SCRATCH_MNT \
+_overlay_scratch_mount_opts \
 			-o ro,redirect_dir=nofollow,nfs_export=on,lowerdir=$middle:$lower
 test_file_handles $SCRATCH_MNT/lowertestdir -rp
 test_file_handles $SCRATCH_MNT/lowertestdir/subdir -rp
@@ -173,7 +173,7 @@ unmount_dirs
 # Overlay lookup cannot follow the redirect from $upper/lowertestdir.new to
 # $lower/lowertestdir. Instead, we mount an overlay subtree rooted at these
 # directories.
-$MOUNT_PROG -t overlay $OVL_BASE_SCRATCH_MNT $SCRATCH_MNT \
+_overlay_scratch_mount_opts \
 		-o ro,redirect_dir=nofollow,nfs_export=on,lowerdir=$upper/lowertestdir.new:$lower/lowertestdir
 test_file_handles $SCRATCH_MNT -r
 test_file_handles $SCRATCH_MNT/subdir -rp
diff --git a/tests/overlay/062 b/tests/overlay/062
index 04e13e46..a4e9560a 100755
--- a/tests/overlay/062
+++ b/tests/overlay/062
@@ -65,7 +65,7 @@ create_test_files $lowertestdir
 $MOUNT_PROG --bind $lowertestdir $lowertestdir
 
 # For non-upper overlay mount, nfs_export requires disabling redirect_dir.
-$MOUNT_PROG -t overlay $OVL_BASE_SCRATCH_MNT $SCRATCH_MNT \
+_overlay_scratch_mount_opts \
 	-o ro,redirect_dir=nofollow,nfs_export=on,lowerdir=$lower:$lower2
 
 # Decode an overlay directory file handle, whose underlying lower dir dentry
diff --git a/tests/overlay/079 b/tests/overlay/079
index 078ee816..f28fc313 100755
--- a/tests/overlay/079
+++ b/tests/overlay/079
@@ -141,7 +141,7 @@ mount_overlay()
 {
 	local _lowerdir=$1 _datadir2=$2 _datadir=$3
 
-	$MOUNT_PROG -t overlay $OVL_BASE_SCRATCH_MNT $SCRATCH_MNT \
+	_overlay_scratch_mount_opts \
 		-o"lowerdir=$_lowerdir::$_datadir2::$_datadir" \
 		-o"upperdir=$upperdir,workdir=$workdir" \
 		-o redirect_dir=on,metacopy=on
@@ -151,7 +151,7 @@ mount_ro_overlay()
 {
 	local _lowerdir=$1 _datadir2=$2 _datadir=$3
 
-	$MOUNT_PROG -t overlay $OVL_BASE_SCRATCH_MNT $SCRATCH_MNT \
+	_overlay_scratch_mount_opts \
 		-o"lowerdir=$_lowerdir::$_datadir2::$_datadir" \
 		-o redirect_dir=follow,metacopy=on
 }
diff --git a/tests/overlay/085 b/tests/overlay/085
index 07a32c24..0f4e4b06 100755
--- a/tests/overlay/085
+++ b/tests/overlay/085
@@ -142,7 +142,7 @@ mount_overlay()
 {
 	local _lowerdir=$1 _datadir2=$2 _datadir=$3
 
-	$MOUNT_PROG -t overlay $OVL_BASE_SCRATCH_MNT $SCRATCH_MNT \
+	_overlay_scratch_mount_opts \
 		-o"lowerdir+=$_lowerdir,datadir+=$_datadir2,datadir+=$_datadir" \
 		-o"upperdir=$upperdir,workdir=$workdir" \
 		-o redirect_dir=on,metacopy=on
@@ -152,7 +152,7 @@ mount_ro_overlay()
 {
 	local _lowerdir=$1 _datadir2=$2 _datadir=$3
 
-	$MOUNT_PROG -t overlay $OVL_BASE_SCRATCH_MNT $SCRATCH_MNT \
+	_overlay_scratch_mount_opts \
 		-o"lowerdir+=$_lowerdir,datadir+=$_datadir2,datadir+=$_datadir" \
 		-o redirect_dir=follow,metacopy=on
 }
-- 
2.34.1

