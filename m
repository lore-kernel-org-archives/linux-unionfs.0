Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="dgK5VlfP"
Received: from mail-wm1-x335.google.com (mail-wm1-x335.google.com [IPv6:2a00:1450:4864:20::335])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CB20FB2;
	Mon,  4 Dec 2023 10:59:26 -0800 (PST)
Received: by mail-wm1-x335.google.com with SMTP id 5b1f17b1804b1-40b2ddab817so49088315e9.3;
        Mon, 04 Dec 2023 10:59:26 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1701716365; x=1702321165; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=oPaLWNJjsOPRlk4Fs3MBRBJKK6nVUr7Z/nXAOk5jSpM=;
        b=dgK5VlfPHcVN5nDkqDOL2dckz/gdllD2Z0LtePT2Sylc4fwFQ9iONk79a19eFS7Ala
         S49GQIojPqvdtwsqRpfPRVLvV0CUYNcuhCe2VTZXxM/qpv5C5aVYAgXmV6ZEg7xWRANC
         XgdsAL/7lcavdpW70s7mTJ/GCLboZn3yBMGSiulVJG+fMReYaEmjTyAU6IktPM1bH5kk
         KqgDV8qnsuaSqV3hUbGorkeVY5LOzCGCFGWMH9MmA/5x8rIvNFZo8+eQgd++vrfKnY1Z
         LIo1a4mflVqCfcfVmxdXk6WJ8FfiGtXrfbxVhWbennZ2n0lV9ZXbd3tFmctb08a0A6za
         hGCA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1701716365; x=1702321165;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=oPaLWNJjsOPRlk4Fs3MBRBJKK6nVUr7Z/nXAOk5jSpM=;
        b=T0y02ZzwGRrsfB0QkCVlI/QUVp43mvhc4BRnvI/gRXrpVz40UL0r9KDh/kpPuebq1v
         oc4PLzbiAMfPVg6KjZ1ohXJZS4pfViWbz8mllkhSKKOuXiHjqDwkrhCD+U3nKzeWGNPK
         ad4/fAxzVRaUYa+pHSyGes/xS3Y3IttgQcRvneRA6bg2WC6xmJPbehUK3DDqT3SWtyMN
         6C8eXOlufqYfrk8kbAT5VX8k0IxDPEx6WeNiNuhhJ16QpVs6p1V+gayI4UBL5cFJQ5Zn
         4YLk/OfbWpbQERfPydjEmzjK1iw1ucyEeLVJOuKTKJsaGxwberAp6ZI4HAXlF8uG+6XJ
         LzPQ==
X-Gm-Message-State: AOJu0YwTxg4zrov54zg/bSh3hz9qx7ImyV1e68m9vADKPD3tDzq/wyp5
	Pa2CTStu0fISOC0IoIAvx6Rar35b814=
X-Google-Smtp-Source: AGHT+IEzV9ha3zVXBzF/nihvF3xABReL8kY9QWSOT+5cZG3bb9mvbMYniUe3VhLjm2cUzNHKLeBEGw==
X-Received: by 2002:a05:600c:188f:b0:40b:5e21:e27f with SMTP id x15-20020a05600c188f00b0040b5e21e27fmr2928537wmp.108.1701716365230;
        Mon, 04 Dec 2023 10:59:25 -0800 (PST)
Received: from amir-ThinkPad-T480.lan ([5.29.249.86])
        by smtp.gmail.com with ESMTPSA id d9-20020a05600c34c900b0040b2c195523sm20008098wmq.31.2023.12.04.10.59.07
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 04 Dec 2023 10:59:09 -0800 (PST)
From: Amir Goldstein <amir73il@gmail.com>
To: Zorro Lang <zlang@redhat.com>
Cc: Alexander Larsson <alexl@redhat.com>,
	Miklos Szeredi <miklos@szeredi.hu>,
	linux-unionfs@vger.kernel.org,
	fstests@vger.kernel.org
Subject: [PATCH v2 2/4] overlay: prepare for new lowerdir+,datadir+ tests
Date: Mon,  4 Dec 2023 20:58:57 +0200
Message-Id: <20231204185859.3731975-3-amir73il@gmail.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20231204185859.3731975-1-amir73il@gmail.com>
References: <20231204185859.3731975-1-amir73il@gmail.com>
Precedence: bulk
X-Mailing-List: linux-unionfs@vger.kernel.org
List-Id: <linux-unionfs.vger.kernel.org>
List-Subscribe: <mailto:linux-unionfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-unionfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

In preparation to forking tests for new lowerdir+,datadir+ mount options,
prepare a helper to test kernel support and pass datadirs into mount
helpers in overlay/079 test.

Signed-off-by: Amir Goldstein <amir73il@gmail.com>
---
 common/overlay    | 15 +++++++++++++++
 tests/overlay/079 | 36 +++++++++++++++++++++---------------
 2 files changed, 36 insertions(+), 15 deletions(-)

diff --git a/common/overlay b/common/overlay
index 8f275228..ea1eb7b1 100644
--- a/common/overlay
+++ b/common/overlay
@@ -247,6 +247,21 @@ _require_scratch_overlay_lowerdata_layers()
 	_scratch_unmount
 }
 
+# Check kernel support for lowerdir+=<lowerdir>,datadir+=<lowerdatadir> format
+_require_scratch_overlay_lowerdir_add_layers()
+{
+	local lowerdir="$OVL_BASE_SCRATCH_MNT/$OVL_UPPER"
+	local datadir="$OVL_BASE_SCRATCH_MNT/$OVL_LOWER"
+
+	_scratch_mkfs > /dev/null 2>&1
+	$MOUNT_PROG -t overlay $OVL_BASE_SCRATCH_MNT $SCRATCH_MNT \
+		-o"lowerdir+=$lowerdir,datadir+=$datadir" \
+		-o"redirect_dir=follow,metacopy=on" > /dev/null 2>&1 || \
+	        _notrun "overlay lowerdir+,datadir+ not supported on ${SCRATCH_DEV}"
+
+	_scratch_unmount
+}
+
 # Helper function to check underlying dirs of overlay filesystem
 _overlay_fsck_dirs()
 {
diff --git a/tests/overlay/079 b/tests/overlay/079
index 77f94598..078ee816 100755
--- a/tests/overlay/079
+++ b/tests/overlay/079
@@ -139,16 +139,21 @@ check_file_size_contents()
 
 mount_overlay()
 {
-	local _lowerdir=$1
+	local _lowerdir=$1 _datadir2=$2 _datadir=$3
 
-	_overlay_scratch_mount_dirs "$_lowerdir" $upperdir $workdir -o redirect_dir=on,index=on,metacopy=on
+	$MOUNT_PROG -t overlay $OVL_BASE_SCRATCH_MNT $SCRATCH_MNT \
+		-o"lowerdir=$_lowerdir::$_datadir2::$_datadir" \
+		-o"upperdir=$upperdir,workdir=$workdir" \
+		-o redirect_dir=on,metacopy=on
 }
 
 mount_ro_overlay()
 {
-	local _lowerdir=$1
+	local _lowerdir=$1 _datadir2=$2 _datadir=$3
 
-	_overlay_scratch_mount_dirs "$_lowerdir" "-" "-" -o ro,redirect_dir=follow,metacopy=on
+	$MOUNT_PROG -t overlay $OVL_BASE_SCRATCH_MNT $SCRATCH_MNT \
+		-o"lowerdir=$_lowerdir::$_datadir2::$_datadir" \
+		-o redirect_dir=follow,metacopy=on
 }
 
 umount_overlay()
@@ -160,14 +165,14 @@ test_no_access()
 {
 	local _target=$1
 
-	mount_ro_overlay "$lowerdir::$datadir2::$datadir"
+	mount_ro_overlay "$lowerdir" "$datadir2" "$datadir"
 
 	stat $SCRATCH_MNT/$_target >> $seqres.full 2>&1 || \
 		echo "No access to lowerdata layer $_target"
 
 	echo "Unmount and Mount rw"
 	umount_overlay
-	mount_overlay "$lowerdir::$datadir2::$datadir"
+	mount_overlay "$lowerdir" "$datadir2" "$datadir"
 	stat $SCRATCH_MNT/$_target >> $seqres.full 2>&1 || \
 		echo "No access to lowerdata layer $_target"
 	umount_overlay
@@ -175,11 +180,12 @@ test_no_access()
 
 test_common()
 {
-	local _lowerdirs=$1 _target=$2 _size=$3 _blocks=$4 _data="$5"
-	local _redirect=$6
+	local _lowerdir=$1 _datadir2=$2 _datadir=$3
+	local _target=$4 _size=$5 _blocks=$6 _data="$7"
+	local _redirect=$8
 
 	echo "Mount ro"
-	mount_ro_overlay $_lowerdirs
+	mount_ro_overlay $_lowerdir $_datadir2 $_datadir
 
 	# Check redirect xattr to lowerdata
 	[ -n "$_redirect" ] && check_redirect $lowerdir/$_target "$_redirect"
@@ -191,7 +197,7 @@ test_common()
 	# Do a mount cycle and check size and contents again.
 	echo "Unmount and Mount rw"
 	umount_overlay
-	mount_overlay $_lowerdirs
+	mount_overlay $_lowerdir $_datadir2 $_datadir
 	echo "check properties of metadata copied up file $_target"
 	check_file_size_contents $SCRATCH_MNT/$_target $_size "$_data"
 	check_file_blocks $SCRATCH_MNT/$_target $_blocks
@@ -203,7 +209,7 @@ test_common()
 	check_file_size_contents $upperdir/$_target $_size ""
 
 	# Trigger data copy up and check absence of metacopy xattr.
-	mount_overlay $_lowerdirs
+	mount_overlay $_lowerdir $_datadir2 $_datadir
 	$XFS_IO_PROG -c "falloc 0 1" $SCRATCH_MNT/$_target >> $seqres.full
 	echo "check properties of data copied up file $_target"
 	check_file_size_contents $SCRATCH_MNT/$_target $_size "$_data"
@@ -216,7 +222,7 @@ test_lazy()
 {
 	local _target=$1
 
-	mount_overlay "$lowerdir::$datadir2::$datadir"
+	mount_overlay "$lowerdir" "$datadir2" "$datadir"
 
 	# Metadata should be valid
 	check_file_size $SCRATCH_MNT/$_target $datasize
@@ -305,12 +311,12 @@ test_no_access "$sharedname"
 
 echo -e "\n== Check follow to lowerdata layer with absolute redirect =="
 prepare_midlayer "/subdir/$dataname"
-test_common "$lowerdir::$datadir2::$datadir" "$dataname" $datasize $datablocks \
+test_common "$lowerdir" "$datadir2" "$datadir" "$dataname" $datasize $datablocks \
 		"$datacontent" "/subdir/$dataname"
-test_common "$lowerdir::$datadir2::$datadir" "$dataname2" $datasize $datablocks \
+test_common "$lowerdir" "$datadir2" "$datadir" "$dataname2" $datasize $datablocks \
 		"$datacontent2" "/subdir/$dataname.2"
 # Shared file should be picked from upper datadir
-test_common "$lowerdir::$datadir2::$datadir" "$sharedname" $datasize $datablocks \
+test_common "$lowerdir" "$datadir2" "$datadir" "$sharedname" $datasize $datablocks \
 		"$datacontent2" "/subdir/$dataname.shared"
 
 echo -e "\n== Check lazy follow to lowerdata layer =="
-- 
2.34.1

