Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="d0oqL0p+"
Received: from mail-wm1-x331.google.com (mail-wm1-x331.google.com [IPv6:2a00:1450:4864:20::331])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0F4F71BD;
	Wed, 22 Nov 2023 07:20:20 -0800 (PST)
Received: by mail-wm1-x331.google.com with SMTP id 5b1f17b1804b1-40790b0a224so32129595e9.0;
        Wed, 22 Nov 2023 07:20:19 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1700666418; x=1701271218; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=Ae3vwokpRSyYo9V3VM33W3RoxhRsEKFbkXT1nDI9pbA=;
        b=d0oqL0p+A585oXWKmzRIJiCPDlCLr9F7bJU81zU6d2ibTcSP8FEYqyq9QKVNbx0/sy
         qQ8ba8lHIabKLpMIR+pryI2pBtM5ET7zKzZF+8+Lvgkoi4r2exl0GYp3PM97nQdJJHjP
         bby5IGGES6thmYrJYRsmIj1IuI1IbB5Tz6Jw6SV8QY3jjXePwotdTUGDPQZ/5tklCYvs
         sDbH7KuJWhUAmvLaNvmfu1zZvr/kw53IdbNnNkxSg2WE+IAtJ1d1MqwIXxjLo0gmRQQ3
         iclXO20E4ceOerd7CgQ2Fg+kXdLXOMdEODBdTbA4u93HjSfYM6SZbf6tBO+qu46zIVdg
         0q4Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1700666418; x=1701271218;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=Ae3vwokpRSyYo9V3VM33W3RoxhRsEKFbkXT1nDI9pbA=;
        b=ZKCD6vUsTXGYR56ZyKNPMxP/wNx2MlsaoJHhGVmXOowWBlQa27Kz4zBff8tTyXi+Gp
         IS0VsGjth2m5uknrjMXnG7+EKuonnKifPMKJ/Nk2jIbBOMI/NBMg0Hv4i8jdX6NAc5Jw
         h4pn/SIe6a+mnZQ/Rpb/KbhPVYKBozDJw5/dj0U5a4NG5prn482UKXyRDyNnDJ9rouWO
         VosmDA4pOY+2S+KpK6PP7JbMwaQex5gt4/P+PyU10COjZGeUEX7c+Bk9gcHFUuk6W8Gv
         7Q8OD21Z38xt1bJl/JzxsjvzRYbOn63rnSVi/Zrslz9U5h+yGcS9SO5LuIHPpBWMwaCG
         UVig==
X-Gm-Message-State: AOJu0Yy1OuKLq5CFTPoeuOV5mOuXMBX2c0BVpE6454dfris2Wx6QAp7R
	hQxHy2DcEUVv3T4UVvAKZkjlxATHhFs=
X-Google-Smtp-Source: AGHT+IHqmQN65E5aUNLUjN6xeWIalSi7AkR8WZQ8lhaDgLPh2yd/Qhyzi6o8G7tto8jF2EOnOdzLJg==
X-Received: by 2002:a05:600c:5c1:b0:407:8e85:89ad with SMTP id p1-20020a05600c05c100b004078e8589admr2075946wmd.14.1700666418051;
        Wed, 22 Nov 2023 07:20:18 -0800 (PST)
Received: from amir-ThinkPad-T480.lan ([5.29.249.86])
        by smtp.gmail.com with ESMTPSA id bd6-20020a05600c1f0600b0040b338b055fsm1716445wmb.18.2023.11.22.07.20.16
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 22 Nov 2023 07:20:17 -0800 (PST)
From: Amir Goldstein <amir73il@gmail.com>
To: Zorro Lang <zlang@redhat.com>
Cc: Alexander Larsson <alexl@redhat.com>,
	Miklos Szeredi <miklos@szeredi.hu>,
	linux-unionfs@vger.kernel.org,
	fstests@vger.kernel.org
Subject: [PATCH v2] overlay/026: Fix test expectation for newer kernels
Date: Wed, 22 Nov 2023 17:20:13 +0200
Message-Id: <20231122152013.2569153-1-amir73il@gmail.com>
X-Mailer: git-send-email 2.34.1
Precedence: bulk
X-Mailing-List: linux-unionfs@vger.kernel.org
List-Id: <linux-unionfs.vger.kernel.org>
List-Subscribe: <mailto:linux-unionfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-unionfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Alexander Larsson <alexl@redhat.com>

The test checks the expectaion from old kernels that set/get of
trusted.overlay.* xattrs is not supported on an overlayfs filesystem.

New kernels support set/get xattr of trusted.overlay.* xattrs, so adapt
the test to check that either both set and get work on new kernel, or
neither work on old kernel.

Signed-off-by: Alexander Larsson <alexl@redhat.com>
Signed-off-by: Amir Goldstein <amir73il@gmail.com>
---

Zorro,

Per your request on v1 [1], I've added a helper to check escaped overlay
xattrs support.

The helper was taken from the patch that adds test overlay/084 [2], and
re-factored, but other than that, overlay/084 itself is unchanged, so
I am not re-posting it nor any of the other patches in the overlay tests
for v6.7-rc1.

Let me know if this works for you.

Thanks,
Amir.

[1] https://lore.kernel.org/fstests/20231116075250.ntopaswush4sn2qf@dell-per750-06-vm-08.rhts.eng.pek2.redhat.com/
[2] https://lore.kernel.org/fstests/20231114064857.1666718-2-amir73il@gmail.com/

 common/overlay        | 19 +++++++++++++++++++
 tests/overlay/026     | 42 +++++++++++++++++++++++++++++-------------
 tests/overlay/026.out |  2 --
 3 files changed, 48 insertions(+), 15 deletions(-)

diff --git a/common/overlay b/common/overlay
index 7004187f..8f275228 100644
--- a/common/overlay
+++ b/common/overlay
@@ -201,6 +201,25 @@ _require_scratch_overlay_features()
 	_scratch_unmount
 }
 
+_check_scratch_overlay_xattr_escapes()
+{
+	local testfile=$1
+
+	touch $testfile
+	! ($GETFATTR_PROG -n trusted.overlay.foo $testfile 2>&1 | grep -E -q "not (permitted|supported)")
+}
+
+_require_scratch_overlay_xattr_escapes()
+{
+	_scratch_mkfs > /dev/null 2>&1
+	_scratch_mount
+
+        _check_scratch_overlay_xattr_escapes $SCRATCH_MNT/file || \
+                  _notrun "xattr escaping is not supported by overlay"
+
+	_scratch_unmount
+}
+
 _require_scratch_overlay_verity()
 {
 	local lowerdirs="$OVL_BASE_SCRATCH_MNT/$OVL_UPPER:$OVL_BASE_SCRATCH_MNT/$OVL_LOWER"
diff --git a/tests/overlay/026 b/tests/overlay/026
index 77030d20..25c70bc8 100755
--- a/tests/overlay/026
+++ b/tests/overlay/026
@@ -52,26 +52,42 @@ touch $SCRATCH_MNT/testf1
 # getfattr    ok         no attr     ok    ok
 #
 $SETFATTR_PROG -n "trusted.overlayfsrz" -v "n" \
-  $SCRATCH_MNT/testf0 2>&1 | _filter_scratch
+  $SCRATCH_MNT/testf0 2>&1 | tee -a $seqres.full | _filter_scratch
 
 _getfattr --absolute-names -n "trusted.overlayfsrz" \
-  $SCRATCH_MNT/testf0 2>&1 | _filter_scratch
+  $SCRATCH_MNT/testf0 2>&1 | tee -a $seqres.full | _filter_scratch
 
-# {s,g}etfattr of "trusted.overlay.xxx" should fail.
+# {s,g}etfattr of "trusted.overlay.xxx" fail on older kernels
 # The errno returned varies among kernel versions,
-#            v4.3/7   v4.8-rc1    v4.8       v4.10
-# setfattr  not perm  not perm   not perm   not supp
-# getfattr  no attr   no attr    not perm   not supp
+#            v4.3/7   v4.8-rc1    v4.8       v4.10     v6.7
+# setfattr  not perm  not perm   not perm   not supp  ok
+# getfattr  no attr   no attr    not perm   not supp  ok
 #
-# Consider "Operation not {supported,permitted}" pass.
+# Consider "Operation not {supported,permitted}" pass for old kernels.
 #
-$SETFATTR_PROG -n "trusted.overlay.fsz" -v "n" \
-  $SCRATCH_MNT/testf1 2>&1 | _filter_scratch | \
-  sed -e 's/permitted/supported/g'
+if _check_scratch_overlay_xattr_escapes $SCRATCH_MNT/testf0; then
+	setexp=""
+	getexp="No such attribute"
+else
+	setexp="Operation not supported"
+	getexp="Operation not supported"
+fi
 
-_getfattr --absolute-names -n "trusted.overlay.fsz" \
-  $SCRATCH_MNT/testf1 2>&1 | _filter_scratch | \
-  sed -e 's/permitted/supported/g'
+getres=$(_getfattr --absolute-names -n "trusted.overlay.fsz" \
+  $SCRATCH_MNT/testf1 2>&1 | tee -a $seqres.full | _filter_scratch | \
+  sed 's/permitted/supported/')
+
+[[ "$getres" =~ "$getexp" ]] || echo unexpected getattr result: $getres
+
+setres=$($SETFATTR_PROG -n "trusted.overlay.fsz" -v "n" \
+  $SCRATCH_MNT/testf1 2>&1 | tee -a $seqres.full |_filter_scratch | \
+  sed -e 's/permitted/supported/g')
+
+if [ "$setexp" ]; then
+	[[ "$setres" =~ "$expres" ]] || echo unexpected setattr result: $setres
+else
+	[[ "$setres" == "" ]] || echo unexpected setattr result: $setres
+fi
 
 # success, all done
 status=0
diff --git a/tests/overlay/026.out b/tests/overlay/026.out
index c4572d67..53030009 100644
--- a/tests/overlay/026.out
+++ b/tests/overlay/026.out
@@ -2,5 +2,3 @@ QA output created by 026
 # file: SCRATCH_MNT/testf0
 trusted.overlayfsrz="n"
 
-setfattr: SCRATCH_MNT/testf1: Operation not supported
-SCRATCH_MNT/testf1: trusted.overlay.fsz: Operation not supported
-- 
2.34.1

