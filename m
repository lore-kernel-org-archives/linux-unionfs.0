Received: from mail-wr1-f44.google.com (mail-wr1-f44.google.com [209.85.221.44])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2502844C77;
	Sun, 17 Dec 2023 15:00:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="XbV8k6vw"
Received: by mail-wr1-f44.google.com with SMTP id ffacd0b85a97d-33666946422so201499f8f.1;
        Sun, 17 Dec 2023 07:00:22 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1702825221; x=1703430021; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=KxQmdvdTsE+BizfZPDHKV4c+mSHHunHuY4qqWDo4SAY=;
        b=XbV8k6vwgRDVqBMSD7RJaZ0T5oztrm66+KG+9DgrbgIOSXXS/TgKQtieTi0CuXjh/1
         b6+0E3nzUp0oYSP9+fWLrdT4RWa/FevzvnHKGlf6ygzD+5CTQHV34IyoUSZzGVfj3O7q
         IQAwHESe5kKyxksGPjJmT7mq8gUIRKlswbAhNnvOSLvJyX1ENW2r1dZ48YVWLzXNMc/m
         ruoGQjDsrSmDG1V6WKIrdBMEPyvrUUiR1wBt8SuCYsgIKQkUnfaCHpNQ+P/t6GwmtpXL
         xf/NjNkD4Qa672Et7LbIF01pEkbNCYAJxuipYSEte9RLF2G3JWhGpttrYh4BM7iaEgGf
         9KgQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1702825221; x=1703430021;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=KxQmdvdTsE+BizfZPDHKV4c+mSHHunHuY4qqWDo4SAY=;
        b=rAgnT5L1SYfHmEabNaDra8MIMNVb5jjykM6EkToiSBxGWo+e0OkrN4dcw7v1OSGpoR
         j7aBdiGqFbKNXTqKvQIfKhW0Z7nD/ts3srthqjkIHgBvnxY4ait70Y2WG1yEAvPieJCd
         h908l4brPz7XuQQpp1Od8Y88/sbabUg/k0i9U0ybmfY9J6Vwz7b85D9wmAaAigiS8/1s
         BKqPBLvn5N84Ql0SEMV7Urw3uok67b9ebWWWS+/mQptFfeHsjrrB8XcEep4IHxlliRYz
         8TeCKN0t8o5xPKO2tyLgMTs+Yj7N191c7CkzjSvlAK0AgFqqnaKwpfnfWVBcJ6rKPwDq
         icQQ==
X-Gm-Message-State: AOJu0YyMWGORtbIkXeE3eQtyNf7oMig5cc0DLstL+O7+dzb/BQNbQhA6
	5M09ljPpAi2A4xhY41mV9dW0N9rnJtM=
X-Google-Smtp-Source: AGHT+IHwE3wyVDMVR3X8NVZaB/fG45mbApCAlGWnXeBOWDS8mmlxLgx++sVb9NExUs8RO9+/TfZCAg==
X-Received: by 2002:adf:db51:0:b0:336:5383:a721 with SMTP id f17-20020adfdb51000000b003365383a721mr2334700wrj.100.1702825221034;
        Sun, 17 Dec 2023 07:00:21 -0800 (PST)
Received: from amir-ThinkPad-T480.lan ([5.29.249.86])
        by smtp.gmail.com with ESMTPSA id w13-20020a5d608d000000b0033662b81ff0sm2280052wrt.91.2023.12.17.07.00.20
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 17 Dec 2023 07:00:20 -0800 (PST)
From: Amir Goldstein <amir73il@gmail.com>
To: Zorro Lang <zlang@redhat.com>
Cc: Miklos Szeredi <miklos@szeredi.hu>,
	linux-unionfs@vger.kernel.org,
	fstests@vger.kernel.org
Subject: [PATCH] overlay/081: fix test when running with index enabled
Date: Sun, 17 Dec 2023 17:00:17 +0200
Message-Id: <20231217150017.569077-1-amir73il@gmail.com>
X-Mailer: git-send-email 2.34.1
Precedence: bulk
X-Mailing-List: linux-unionfs@vger.kernel.org
List-Id: <linux-unionfs.vger.kernel.org>
List-Subscribe: <mailto:linux-unionfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-unionfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Test overlay/081 fails with:
 CONFIG_OVERLAY_FS_INDEX=y
or
 echo Y > /sys/modules/overlay/params/index

The reason is that mount option uuid=off has the undesired side effect
of disabling index feature.

uuid=null is exactly the same as uuid=off for the purpose of this test
but without the undesired side effect.

The test was created to test the new modes uuid=null/auto/on, so the
fact that is is testing the mode uuid=off is just an oversight.

Covert the use of uuid=off to uuid=null to fix this problem.

Signed-off-by: Amir Goldstein <amir73il@gmail.com>
---

Zorro,

Following your report that the new test overlay/084 is failing with
non-default overlayfs Kconfig [1], I reran the existing overlay tests
with non-default config.

The run with CONFIG_OVERLAY_FS_INDEX=y found another failure in a test
that was added recently to cover a new feature in v6.6.

Thanks,
Amir.


[1] https://lore.kernel.org/fstests/20231210204503.poggjg4z57eg2nn7@dell-per750-06-vm-08.rhts.eng.pek2.redhat.com/

 tests/overlay/081 | 14 +++++++-------
 1 file changed, 7 insertions(+), 7 deletions(-)

diff --git a/tests/overlay/081 b/tests/overlay/081
index 05156a3c..481e9931 100755
--- a/tests/overlay/081
+++ b/tests/overlay/081
@@ -5,7 +5,7 @@
 # FSQA Test No. 081
 #
 # Test persistent (and optionally unique) overlayfs fsid
-# with mount options uuid=null/on introduced in kernel v6.6
+# with mount options uuid=null/auto/on introduced in kernel v6.6
 #
 . ./common/preamble
 _begin_fstest auto quick
@@ -55,7 +55,7 @@ _scratch_mount
 
 ovl_fsid=$(stat -f -c '%i' $test_dir)
 [[ "$ovl_fsid" == "$upper_fsid" ]] || \
-	echo "Overlayfs (uuid=auto) and upper fs fsid differ"
+	echo "Overlayfs (after uuid=null) and upper fs fsid differ"
 
 $UMOUNT_PROG $SCRATCH_MNT
 
@@ -74,16 +74,16 @@ _scratch_mount
 
 ovl_fsid=$(stat -f -c '%i' $test_dir)
 [[ "$ovl_fsid" == "$ovl_unique_fsid" ]] || \
-	echo "Overlayfs (uuid=auto) unique fsid is not persistent"
+	echo "Overlayfs (after uuid=on) unique fsid is not persistent"
 
 $UMOUNT_PROG $SCRATCH_MNT
 
 # Test ignore existing persistent fsid on explicit opt-out
-_scratch_mount -o uuid=off
+_scratch_mount -o uuid=null
 
 ovl_fsid=$(stat -f -c '%i' $test_dir)
 [[ "$ovl_fsid" == "$upper_fsid" ]] || \
-	echo "Overlayfs (uuid=off) and upper fs fsid differ"
+	echo "Overlayfs (uuid=null) and upper fs fsid differ"
 
 $UMOUNT_PROG $SCRATCH_MNT
 
@@ -92,7 +92,7 @@ _overlay_scratch_mount_dirs "$upperdir:$lowerdir" "-" "-" -o ro,uuid=on
 
 ovl_fsid=$(stat -f -c '%i' $test_dir)
 [[ "$ovl_fsid" == "$lower_fsid" ]] || \
-	echo "Overlayfs (uuid=null) and lower fs fsid differ"
+	echo "Overlayfs (no upper) and lower fs fsid differ"
 
 # Re-create fresh overlay layers, so following (uuid=auto) mounts
 # will behave as first time mount of a new overlayfs
@@ -110,7 +110,7 @@ _scratch_mount
 ovl_fsid=$(stat -f -c '%i' $test_dir)
 ovl_unique_fsid=$ovl_fsid
 [[ "$ovl_fsid" != "$upper_fsid" ]] || \
-	echo "Overlayfs (uuid=auto) and upper fs fsid are the same"
+	echo "Overlayfs (new) and upper fs fsid are the same"
 
 $UMOUNT_PROG $SCRATCH_MNT
 
-- 
2.34.1

