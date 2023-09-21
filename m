Return-Path: <linux-unionfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DFADFE7D0A2
	for <linux-unionfs@archiver.kernel.org>; Thu, 21 Sep 2023 19:01:42 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231158AbjIUTBq (ORCPT
        <rfc822;linux-unionfs@archiver.kernel.org>);
        Thu, 21 Sep 2023 15:01:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35106 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230391AbjIUTBT (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Thu, 21 Sep 2023 15:01:19 -0400
Received: from mail-ed1-x52f.google.com (mail-ed1-x52f.google.com [IPv6:2a00:1450:4864:20::52f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2C66A88AC6;
        Thu, 21 Sep 2023 10:39:16 -0700 (PDT)
Received: by mail-ed1-x52f.google.com with SMTP id 4fb4d7f45d1cf-523100882f2so1471344a12.2;
        Thu, 21 Sep 2023 10:39:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1695317954; x=1695922754; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=D5iXvHpoNdFLaDpVKrTwt1qO8piu2NWVNt1TPpkdWGE=;
        b=Mfz2G237KQX1VDC6TVsZsS5Yz9GJ2WA+w4tsdZ1c2jpX4VeAIgnlgTHMo0hkLuwA5R
         cAqKTgNE9r456hyIEwy9ZnuOtVOHWgR1p+og4uVvhvUzfXGDAhMRKNsgbvEOvAf/GtK+
         cFXTGdJV/Hmbc1q5UHI2DUb0m2QietdFJLbW1TRDQqVxaAemtQZGIvuhw8h2lA317OTR
         Hq33vFsmmbPENvlFt51cBMdec5u7jsWscJMfUjeJu30da2CSRkBiflr/jO60UlyUItFl
         1aT2iYy/lOisLI3vFfFmUT3i08ZK7Hak0A5qcUZESNheSga+NPGCRqkgdGBmHztJONvO
         hCEg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1695317954; x=1695922754;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=D5iXvHpoNdFLaDpVKrTwt1qO8piu2NWVNt1TPpkdWGE=;
        b=pyXhuiXuaGlBUv8fXPxmThlZBSiNM/pQBhZBvBlBCH707/J9tq7QJu36SVKggGm8sY
         EqpJ6jI4OZ8lMSwCnXPwaYoiJt9INbDayXvOZH/Yu4jB0zK/s55dp8iDnPeGSgOecMJ8
         ShfY1U13d417y98wSsS1/tUQf24jXMfiWyxEQM3awKzwQYGvngu1EyZ4f06+judcdai6
         miJLKDsYzYCnXAeYvOne2bvs9k+qr7d1PiBXGgFazl2zaW+1l4FtLN/iUhXPTv4OQAAj
         j9/xG49p1Yl+sSRMfeAq6ZIMd+j6GiGt0oWfSl5IUwT9KLeyZQ/c8hP1gWHTtGh9fK1b
         lZpA==
X-Gm-Message-State: AOJu0Yy/xiDKiIDDORlXuprRxLfL93kK6GqutMbAIQZgRN5k3TVrSVX8
        do2Yac8wExvtOKkVCQXhrE8dOZlwHh0=
X-Google-Smtp-Source: AGHT+IFscQSijhqoaczFLa9ImDHpCdMV5THADMXs1J3lDyiybvsmRGBT5FwcgkasJ559b+DDJ/SmzA==
X-Received: by 2002:a05:600c:3782:b0:402:f55e:ac11 with SMTP id o2-20020a05600c378200b00402f55eac11mr5121997wmr.20.1695306667924;
        Thu, 21 Sep 2023 07:31:07 -0700 (PDT)
Received: from amir-ThinkPad-T480.lan ([5.29.249.86])
        by smtp.gmail.com with ESMTPSA id y2-20020a7bcd82000000b00403bbe69629sm2099334wmj.31.2023.09.21.07.31.06
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 21 Sep 2023 07:31:07 -0700 (PDT)
From:   Amir Goldstein <amir73il@gmail.com>
To:     Zorro Lang <zlang@redhat.com>
Cc:     Miklos Szeredi <miklos@szeredi.hu>,
        Ruiwen Zhao <ruiwen@google.com>, linux-unionfs@vger.kernel.org,
        fstests@vger.kernel.org
Subject: [PATCH v2 1/2] common: add helper _require_chattr_inherit
Date:   Thu, 21 Sep 2023 17:31:01 +0300
Message-Id: <20230921143102.127526-2-amir73il@gmail.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20230921143102.127526-1-amir73il@gmail.com>
References: <20230921143102.127526-1-amir73il@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-unionfs.vger.kernel.org>
X-Mailing-List: linux-unionfs@vger.kernel.org

Similar to _require_chattr, but also checks if an attribute is
inheritted from parent dir to children.

Signed-off-by: Amir Goldstein <amir73il@gmail.com>
---
 common/rc | 52 +++++++++++++++++++++++++++++++++++++++++++---------
 1 file changed, 43 insertions(+), 9 deletions(-)

diff --git a/common/rc b/common/rc
index 1618ded5..00cfd434 100644
--- a/common/rc
+++ b/common/rc
@@ -4235,23 +4235,57 @@ _require_test_lsattr()
 		_notrun "lsattr not supported by test filesystem type: $FSTYP"
 }
 
+_check_chattr_inherit()
+{
+	local attribute=$1
+	local path=$2
+	local inherit=$3
+
+	touch $path
+	$CHATTR_PROG "+$attribute" $path > $tmp.chattr 2>&1
+	local ret=$?
+	if [ -n "$inherit" ]; then
+		touch "$path/$inherit"
+	fi
+	$CHATTR_PROG "-$attribute" $path > $tmp.chattr 2>&1
+	if [ "$ret" -ne 0 ]; then
+		_notrun "file system doesn't support chattr +$attribute"
+	fi
+	cat $tmp.chattr >> $seqres.full
+	rm -f $tmp.chattr
+	return $ret
+}
+
 _require_chattr()
 {
 	if [ -z "$1" ]; then
 		echo "Usage: _require_chattr <attr>"
 		exit 1
 	fi
-	local attribute=$1
+	_check_chattr_inherit $1 $TEST_DIR/syscalltest
+}
 
-	touch $TEST_DIR/syscalltest
-	chattr "+$attribute" $TEST_DIR/syscalltest > $TEST_DIR/syscalltest.out 2>&1
-	local ret=$?
-	chattr "-$attribute" $TEST_DIR/syscalltest > $TEST_DIR/syscalltest.out 2>&1
-	if [ "$ret" -ne 0 ]; then
-		_notrun "file system doesn't support chattr +$attribute"
+_require_chattr_inherit()
+{
+	if [ -z "$1" ]; then
+		echo "Usage: _require_chattr_inherit <attr>"
+		exit 1
 	fi
-	cat $TEST_DIR/syscalltest.out >> $seqres.full
-	rm -f $TEST_DIR/syscalltest.out
+	local attribute=$1
+	local testdir="$TEST_DIR/chattrtest"
+	mkdir -p $testdir
+	_check_chattr_inherit $attribute $testdir testfile || \
+		return
+
+	local testfile="$TEST_DIR/chattrtest/testfile"
+	local lsattrout=($($LSATTR_PROG $testfile 2>> $seqres.full))
+	echo ${lsattrout[*]} >> $seqres.full
+	echo ${lsattrout[0]} | grep -q $attribute || \
+		_notrun "file system doesn't inherit chattr +$attribute"
+
+	$CHATTR_PROG "-$attribute" $testfile >> $seqres.full 2>&1
+	rm -f $testfile
+	rmdir $testdir
 }
 
 _get_total_inode()
-- 
2.34.1

