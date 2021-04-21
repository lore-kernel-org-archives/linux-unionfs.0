Return-Path: <linux-unionfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1B259C43462
	for <linux-unionfs@archiver.kernel.org>; Wed, 21 Apr 2021 09:23:37 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id EB3E861434
	for <linux-unionfs@archiver.kernel.org>; Wed, 21 Apr 2021 09:23:36 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238079AbhDUJYJ (ORCPT
        <rfc822;linux-unionfs@archiver.kernel.org>);
        Wed, 21 Apr 2021 05:24:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45970 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238114AbhDUJYA (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Wed, 21 Apr 2021 05:24:00 -0400
Received: from mail-wm1-x333.google.com (mail-wm1-x333.google.com [IPv6:2a00:1450:4864:20::333])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 44BB6C06138B;
        Wed, 21 Apr 2021 02:23:23 -0700 (PDT)
Received: by mail-wm1-x333.google.com with SMTP id f195-20020a1c1fcc0000b029012eb88126d7so835604wmf.3;
        Wed, 21 Apr 2021 02:23:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=CLIQehnibYhspckcE6x+XJIA/zv+fMeEQtgaaCiLcvA=;
        b=qB1pSgCMQEcM5dhQsKTi2cgDXgeQEOgDcSQCpQEFPCjD20hsToDH2MM1ykgMJFZuJy
         5rKJrjPdloygSuolbM24WQ0ZjS8tyAHLb2pUFYOTrPEOG3iUC3Hjp7ktcU9CxBeFH8A2
         e2QTxnoDdnwjMBO85m4Y4k2HR/uvb35IQZoNQVt40kicre3taAEq7xS9F8n8WlwcinTs
         yMTEAWk7arJ+FHaeYmtB8Y/0cWoCbjhy+1SwyFEwDgdK0mxcHn9UwaUDN95CmwSLLBLR
         yyvr3yA4QhKVEHb/OM0GV4yLXbftMwfuktoPso36GfA/+5Z8/okOTnLRwvHrq/V9KtB2
         kb+w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=CLIQehnibYhspckcE6x+XJIA/zv+fMeEQtgaaCiLcvA=;
        b=pVs1kPnhsdrGgV1CIkH200c0xjxrdgpXBFME+5LCklrz8hSjjG2QpokNXeLptCugCx
         //8V3iHdxxJgECYyJDTjXM4ViXy6Z6sBpFuZWYu6hdZFpuuDtkOtYZg2TmG8H7/s6zLr
         8H2jfQXI3j9vIRdseOGkPa2qg0bmF9aUYJepwyEoiiCgyKra9j1cxb3q4iqKbeoY9s1K
         cHt2ofVRzX6GZLoo9d8RAuyVEFkGwHWaH+hucFTFGt0TIeHTeDs7mTUMdUBrnH3KoDOa
         5sEFUABbOtliO11X+QOvhv2hpYAxFOqMKPVBmzi0dWMjqFx2d3iW/OnAd5U54xjDiC/3
         PX1Q==
X-Gm-Message-State: AOAM530AbF4jTpGTNReSojF3m8yoBW7UIzR6Qfmxf0KzYNSkOxo7FxF8
        FUZKl4JgBjkxwmPGKaw7nLQ=
X-Google-Smtp-Source: ABdhPJzDYo8SQPAMgQ7VBjNIBFWT3YBJvAonThMoGVzWoThGV11OmhDA7bSgt9cFP5EuEFVeyCv2Og==
X-Received: by 2002:a05:600c:2211:: with SMTP id z17mr8736018wml.41.1618997002003;
        Wed, 21 Apr 2021 02:23:22 -0700 (PDT)
Received: from localhost.localdomain ([82.114.44.37])
        by smtp.gmail.com with ESMTPSA id p3sm1551754wmq.31.2021.04.21.02.23.20
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 21 Apr 2021 02:23:21 -0700 (PDT)
From:   Amir Goldstein <amir73il@gmail.com>
To:     Eryu Guan <guaneryu@gmail.com>
Cc:     Miklos Szeredi <miklos@szeredi.hu>, linux-unionfs@vger.kernel.org,
        fstests@vger.kernel.org
Subject: [PATCH 1/2] generic: Test readdir of modified directrory
Date:   Wed, 21 Apr 2021 12:23:16 +0300
Message-Id: <20210421092317.68716-2-amir73il@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210421092317.68716-1-amir73il@gmail.com>
References: <20210421092317.68716-1-amir73il@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-unionfs.vger.kernel.org>
X-Mailing-List: linux-unionfs@vger.kernel.org

Check that directory content read from an open dir fd reflects
changes to the directory after open.

Signed-off-by: Amir Goldstein <amir73il@gmail.com>
---
 src/t_dir_offset2.c   | 63 ++++++++++++++++++++++++++++++++++++++++---
 tests/generic/700     | 60 +++++++++++++++++++++++++++++++++++++++++
 tests/generic/700.out |  2 ++
 tests/generic/group   |  1 +
 4 files changed, 123 insertions(+), 3 deletions(-)
 create mode 100755 tests/generic/700
 create mode 100644 tests/generic/700.out

diff --git a/src/t_dir_offset2.c b/src/t_dir_offset2.c
index 5a6d7193..84dab9cf 100644
--- a/src/t_dir_offset2.c
+++ b/src/t_dir_offset2.c
@@ -13,6 +13,7 @@
 #include <unistd.h>
 #include <stdint.h>
 #include <stdlib.h>
+#include <string.h>
 #include <sys/stat.h>
 #include <sys/syscall.h>
 
@@ -26,19 +27,28 @@ struct linux_dirent64 {
 
 #define BUF_SIZE 4096
 #define HISTORY_LEN 1024
+#define NAME_SIZE 10
 
 static uint64_t d_off_history[HISTORY_LEN];
 static uint64_t d_ino_history[HISTORY_LEN];
+static char d_name_history[HISTORY_LEN][NAME_SIZE+1];
+
+static int is_dot_or_dot_dot(const char *name)
+{
+	return !strcmp(name, ".") || !strcmp(name, "..");
+}
 
 int
 main(int argc, char *argv[])
 {
-	int fd, nread;
+	int fd, nread, nread_0 = 0;
 	char buf[BUF_SIZE];
 	struct linux_dirent64 *d;
 	int bpos, total, i;
 	off_t lret;
 	int retval = EXIT_SUCCESS;
+	int create = 0, unlink = 0;
+	FILE *warn = stderr;
 
 	fd = open(argv[1], O_RDONLY | O_DIRECTORY);
 	if (fd < 0) {
@@ -46,6 +56,15 @@ main(int argc, char *argv[])
 		exit(EXIT_FAILURE);
 	}
 
+	if (argc > 2) {
+		if (!strcmp(argv[2], "-u"))
+			unlink = 1;
+		else
+			create = 1;
+		/* Some mismatch warnings are expected */
+		warn = stdout;
+	}
+
 	total = 0;
 	for ( ; ; ) {
 		nread = syscall(SYS_getdents64, fd, buf, BUF_SIZE);
@@ -54,6 +73,10 @@ main(int argc, char *argv[])
 			exit(EXIT_FAILURE);
 		}
 
+		if (total == 0 && (create || unlink)) {
+			nread_0 = nread;
+			printf("getdents at offset 0 returned %d bytes\n", nread);
+		}
 		if (nread == 0)
 			break;
 
@@ -75,20 +98,40 @@ main(int argc, char *argv[])
 			}
 			d_off_history[total] = d->d_off;
 			d_ino_history[total] = d->d_ino;
+			strncpy(d_name_history[total], d->d_name, NAME_SIZE);
 			bpos += d->d_reclen;
 		}
 	}
 
+	if (create) {
+		if (openat(fd, argv[2], O_CREAT, 0600) < 0) {
+			perror("openat");
+			exit(EXIT_FAILURE);
+		}
+		printf("created entry %d:%s\n", total, argv[2]);
+	}
+
 	/* check if seek works correctly */
 	d = (struct linux_dirent64 *)buf;
 	for (i = total - 1; i >= 0; i--)
 	{
+		const char *name = i > 0 ? d_name_history[i - 1] : NULL;
+
 		lret = lseek(fd, i > 0 ? d_off_history[i - 1] : 0, SEEK_SET);
 		if (lret == -1) {
 			perror("lseek");
 			exit(EXIT_FAILURE);
 		}
 
+		/* Unlink prev entry, but not "." nor ".." */
+		if (unlink && name && !is_dot_or_dot_dot(name)) {
+			if (unlinkat(fd, name, 0) < 0) {
+				perror("unlinkat");
+				exit(EXIT_FAILURE);
+			}
+			printf("unlinked entry %d:%s\n", i - 1, name);
+		}
+
 		nread = syscall(SYS_getdents64, fd, buf, BUF_SIZE);
 		if (nread == -1) {
 			perror("getdents");
@@ -96,17 +139,31 @@ main(int argc, char *argv[])
 		}
 
 		if (nread == 0) {
-			fprintf(stderr, "getdents returned 0 on entry %d\n", i);
+			fprintf(warn, "getdents returned 0 on entry %d\n", i);
+			retval = EXIT_FAILURE;
+		}
+
+		if (i == 0 && nread_0 && nread != nread_0) {
+			fprintf(warn, "getdents at offset 0 returned %d bytes, expected %d\n", nread, nread_0);
 			retval = EXIT_FAILURE;
 		}
 
 		if (d->d_ino != d_ino_history[i]) {
-			fprintf(stderr, "entry %d has inode %lld, expected %lld\n",
+			fprintf(warn, "entry %d has inode %lld, expected %lld\n",
 				i, (long long int)d->d_ino, (long long int)d_ino_history[i]);
 			retval = EXIT_FAILURE;
 		}
+		if (create || unlink)
+			printf("found entry %d:%s (nread=%d)\n", i, d->d_name, nread);
 	}
 
+	/*
+	 * With create/unlink option we expect to find some mismatch with getdents
+	 * before create/unlink, so if everything matches there is something wrong.
+	 */
+	if (create || unlink)
+		retval = retval ? EXIT_SUCCESS : EXIT_FAILURE;
+
 	close(fd);
 	exit(retval);
 }
diff --git a/tests/generic/700 b/tests/generic/700
new file mode 100755
index 00000000..eb08958d
--- /dev/null
+++ b/tests/generic/700
@@ -0,0 +1,60 @@
+#! /bin/bash
+# SPDX-License-Identifier: GPL-2.0
+# Copyright (C) 2021 CTERA Networks. All Rights Reserved.
+#
+# Check that directory content read from an open dir fd reflects
+# changes to the directory after open.
+#
+seq=`basename $0`
+seqres=$RESULT_DIR/$seq
+echo "QA output created by $seq"
+
+here=`pwd`
+tmp=/tmp/$$
+status=1	# failure is the default!
+
+_cleanup()
+{
+	cd /
+	rm -f $tmp.*
+}
+trap "_cleanup; exit \$status" 0 1 2 3 15
+
+# get standard environment, filters and checks
+. ./common/rc
+. ./common/filter
+
+# real QA test starts here
+_supported_fs generic
+_require_test
+
+rm -f $seqres.full
+
+testdir=$TEST_DIR/test-$seq
+rm -rf $testdir
+mkdir $testdir
+
+# Use small number of files that we can assume to be returned in a single
+# gendents() call, so t_dir_offset2 can compare the entries count before
+# and after seek to start
+for n in {1..10}; do
+    touch $testdir/$n
+done
+
+# Does opendir, readdir, seek to offsets, readdir and
+# compares d_ino of entries on second readdir
+$here/src/t_dir_offset2 $testdir
+
+# Check readdir content changes after adding a new file before seek to start
+echo "Create file in an open dir:" >> $seqres.full
+$here/src/t_dir_offset2 $testdir 0 2>&1 >> $seqres.full || \
+	echo "Missing created file in open dir (see $seqres.full for details)"
+
+# Check readdir content changes after removing files before seek to start
+echo "Remove files in an open dir:" >> $seqres.full
+$here/src/t_dir_offset2 $testdir -u 2>&1 >> $seqres.full || \
+	echo "Found unlinked files in open dir (see $seqres.full for details)"
+
+# success, all done
+echo "Silence is golden"
+status=0
diff --git a/tests/generic/700.out b/tests/generic/700.out
new file mode 100644
index 00000000..f9acaa71
--- /dev/null
+++ b/tests/generic/700.out
@@ -0,0 +1,2 @@
+QA output created by 700
+Silence is golden
diff --git a/tests/generic/group b/tests/generic/group
index ab00cc04..bac5aa48 100644
--- a/tests/generic/group
+++ b/tests/generic/group
@@ -634,3 +634,4 @@
 629 auto quick rw copy_range
 630 auto quick rw dedupe clone
 631 auto rw overlay rename
+700 auto quick dir
-- 
2.25.1

