Return-Path: <linux-unionfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DB2D0C83F2C
	for <linux-unionfs@archiver.kernel.org>; Sun,  3 Sep 2023 11:16:11 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236578AbjICLQN (ORCPT
        <rfc822;linux-unionfs@archiver.kernel.org>);
        Sun, 3 Sep 2023 07:16:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55312 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236602AbjICLQN (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Sun, 3 Sep 2023 07:16:13 -0400
Received: from mail-wm1-x336.google.com (mail-wm1-x336.google.com [IPv6:2a00:1450:4864:20::336])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D5F94127
        for <linux-unionfs@vger.kernel.org>; Sun,  3 Sep 2023 04:16:08 -0700 (PDT)
Received: by mail-wm1-x336.google.com with SMTP id 5b1f17b1804b1-401bbfc05fcso5759715e9.3
        for <linux-unionfs@vger.kernel.org>; Sun, 03 Sep 2023 04:16:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1693739767; x=1694344567; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Crxp5AewkYhCti6tacp9WyZ482s1lhbJNR8eYXQl6Ts=;
        b=lnmQB6y3gLc6JyzSYF9OLdK8lFr2IfhfDsPg1Eq2M8YrsuM3zJBCe4jNtbgDdC+CxO
         s2EmgksUGFiT101/LBjUVTOMlevPHK4bFq5G51/6TwGwH+kfi4Fcb5oguerP/I8N54CP
         nYybVTPJhamMQLuV+RIrLK/8dik0Jc7dAJ04C+2QweVkK4RaGcF3b+fDjaK9KT4ctOUS
         BSqD24EZ3MCVlxzcq+ZyYJPzBBPQsUwEG8dhmJG3G/TGCU6RbyKRU/zules3QZp427sB
         HG+2CSZcNEAn0pidxUPC5tYYYHc8SgdnREHLqYybvGZoz7eRvIhBHMn3IdJHYPhTHKtA
         3PMQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1693739767; x=1694344567;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=Crxp5AewkYhCti6tacp9WyZ482s1lhbJNR8eYXQl6Ts=;
        b=EumvywSYGKxgTEXklkwp3NVT1ueHHT/IbLP4nZkj+CNUHtbEyB0TSkfhjkTSwJ0Wx8
         KOQ1OKDA/htTawv3yNyTOtwR4LYNY5H71hfafZ9eIaPCp0hgZATkVhEyDRiHrAWspNQT
         jz3EBiMkoit+d7E2XVfrswPgyVtsAI8nTYMlSFHo0IW5VufMoQhK83TelX9jmSfaixPs
         6nk/g36cDcH2oBhJi37b57BFdkLUZJ7YTcEzn6bV7JxhhcamZsusMYJGxGv5PMUWIFPD
         3WgF4vCdvvcFF2JendiQEPgdhon4RGpa/fHKTNN/ey9asrueO5Fgh+zUTaUDvdkQUZ7x
         3xCw==
X-Gm-Message-State: AOJu0YyA7FTv4FBVFUF4ucbJYwHMLzvFQVgvYwYX6TSH+WPRFgd656AI
        3yGqKA961w/y48+AIF4sNOg=
X-Google-Smtp-Source: AGHT+IGf6+HzplC/rqF8Ve9yeWmOqtZ7nRMULZFeAVg6ZGIjEN9Y1RKf8blsE5QB0i457SuPCusu/w==
X-Received: by 2002:a05:600c:144:b0:3fb:ff34:a846 with SMTP id w4-20020a05600c014400b003fbff34a846mr5395729wmm.22.1693739766822;
        Sun, 03 Sep 2023 04:16:06 -0700 (PDT)
Received: from amir-ThinkPad-T480.lan ([5.29.249.86])
        by smtp.gmail.com with ESMTPSA id 9-20020a05600c228900b003fc080acf68sm13899065wmf.34.2023.09.03.04.16.05
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 03 Sep 2023 04:16:06 -0700 (PDT)
From:   Amir Goldstein <amir73il@gmail.com>
To:     Petr Vorel <pvorel@suse.cz>
Cc:     Cyril Hrubis <chrubis@suse.cz>, Jan Kara <jack@suse.cz>,
        Christian Brauner <brauner@kernel.org>,
        Miklos Szeredi <miklos@szeredi.hu>,
        linux-unionfs@vger.kernel.org, ltp@lists.linux.it
Subject: [PATCH 1/3] fanotify13: Test watching overlayfs upper fs
Date:   Sun,  3 Sep 2023 14:15:56 +0300
Message-Id: <20230903111558.2603332-2-amir73il@gmail.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20230903111558.2603332-1-amir73il@gmail.com>
References: <20230903111558.2603332-1-amir73il@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-unionfs.vger.kernel.org>
X-Mailing-List: linux-unionfs@vger.kernel.org

Run a test variant with overlayfs (over all supported fs)
when watching the upper fs.

This is a regression test for kernel fix bc2473c90fca
("ovl: enable fsnotify events on underlying real files"),
from kernel 6.5, which is not likely to be backported to older kernels.

To avoid waiting for events that won't arrive when testing old kernels,
require that kernel supports encoding fid with new flag AT_HADNLE_FID,
also merged to 6.5 and not likely to be backported to older kernels.

Signed-off-by: Amir Goldstein <amir73il@gmail.com>
---
 lib/tst_fs_setup.c                            |  2 +-
 testcases/kernel/syscalls/fanotify/fanotify.h | 21 +++++++
 .../kernel/syscalls/fanotify/fanotify13.c     | 62 +++++++++++++++++--
 3 files changed, 79 insertions(+), 6 deletions(-)

diff --git a/lib/tst_fs_setup.c b/lib/tst_fs_setup.c
index 6b93483de..30673670f 100644
--- a/lib/tst_fs_setup.c
+++ b/lib/tst_fs_setup.c
@@ -42,7 +42,7 @@ int mount_overlay(const char *file, const int lineno, int skip)
 			tst_res_(file, lineno, TINFO,
 				TST_FS_SETUP_OVERLAYFS_MSG);
 		}
-	} else {
+	} else if (skip) {
 		tst_brk_(file, lineno, TBROK | TERRNO,
 			"overlayfs mount failed");
 	}
diff --git a/testcases/kernel/syscalls/fanotify/fanotify.h b/testcases/kernel/syscalls/fanotify/fanotify.h
index 51078103e..75a081dc9 100644
--- a/testcases/kernel/syscalls/fanotify/fanotify.h
+++ b/testcases/kernel/syscalls/fanotify/fanotify.h
@@ -72,6 +72,10 @@ static inline int safe_fanotify_mark(const char *file, const int lineno,
 #define MAX_HANDLE_SZ		128
 #endif
 
+#ifndef AT_HANDLE_FID
+#define AT_HANDLE_FID		0x200
+#endif
+
 /*
  * Helper function used to obtain fsid and file_handle for a given path.
  * Used by test files correlated to FAN_REPORT_FID functionality.
@@ -260,10 +264,27 @@ static inline int fanotify_mark_supported_by_kernel(uint64_t flag)
 	return rval;
 }
 
+static inline int fanotify_handle_supported_by_kernel(int flag)
+{
+	/*
+	 * On Kernel that does not support AT_HANDLE_FID this will result
+	 * with EINVAL. On older kernels, this will result in EBADF.
+	 */
+	if (name_to_handle_at(-1, "", NULL, NULL, AT_EMPTY_PATH | flag)) {
+		if (errno == EINVAL)
+			return -1;
+	}
+	return 0;
+}
+
 #define REQUIRE_MARK_TYPE_SUPPORTED_BY_KERNEL(mark_type) \
 	fanotify_init_flags_err_msg(#mark_type, __FILE__, __LINE__, tst_brk_, \
 				    fanotify_mark_supported_by_kernel(mark_type))
 
+#define REQUIRE_HANDLE_TYPE_SUPPORTED_BY_KERNEL(handle_type) \
+	fanotify_init_flags_err_msg(#handle_type, __FILE__, __LINE__, tst_brk_, \
+				    fanotify_handle_supported_by_kernel(handle_type))
+
 #define REQUIRE_FANOTIFY_EVENTS_SUPPORTED_ON_FS(init_flags, mark_type, mask, fname) do { \
 	if (mark_type)							\
 		REQUIRE_MARK_TYPE_SUPPORTED_BY_KERNEL(mark_type);	\
diff --git a/testcases/kernel/syscalls/fanotify/fanotify13.c b/testcases/kernel/syscalls/fanotify/fanotify13.c
index c3daaf3a2..adba41453 100644
--- a/testcases/kernel/syscalls/fanotify/fanotify13.c
+++ b/testcases/kernel/syscalls/fanotify/fanotify13.c
@@ -25,6 +25,7 @@
 #include <sys/statfs.h>
 #include <sys/types.h>
 #include <sys/stat.h>
+#include <sys/mount.h>
 #include <errno.h>
 #include <unistd.h>
 #include "tst_test.h"
@@ -37,7 +38,7 @@
 #define DIR_ONE "dir_one"
 #define FILE_ONE "file_one"
 #define FILE_TWO "file_two"
-#define MOUNT_PATH "mntpoint"
+#define MOUNT_PATH "tstmnt"
 #define EVENT_MAX ARRAY_SIZE(objects)
 #define DIR_PATH_ONE MOUNT_PATH"/"DIR_ONE
 #define FILE_PATH_ONE MOUNT_PATH"/"FILE_ONE
@@ -88,6 +89,8 @@ static struct test_case_t {
 	}
 };
 
+static int ovl_mounted;
+static int bind_mounted;
 static int nofid_fd;
 static int fanotify_fd;
 static int filesystem_mark_unsupported;
@@ -143,8 +146,13 @@ static void do_test(unsigned int number)
 	struct fanotify_mark_type *mark = &tc->mark;
 
 	tst_res(TINFO,
-		"Test #%d: FAN_REPORT_FID with mark flag: %s",
-		number, mark->name);
+		"Test #%d.%d: FAN_REPORT_FID with mark flag: %s",
+		number, tst_variant, mark->name);
+
+	if (tst_variant && !ovl_mounted) {
+		tst_res(TCONF, "overlayfs not supported on %s", tst_device->fs_type);
+		return;
+	}
 
 	if (filesystem_mark_unsupported && mark->flag & FAN_MARK_FILESYSTEM) {
 		tst_res(TCONF, "FAN_MARK_FILESYSTEM not supported in kernel?");
@@ -160,6 +168,15 @@ static void do_test(unsigned int number)
 	if (setup_marks(fanotify_fd, tc) != 0)
 		goto out;
 
+	/* Variant #1: watching upper fs - open files on overlayfs */
+	if (tst_variant == 1) {
+		if (mark->flag & FAN_MARK_MOUNT) {
+			tst_res(TCONF, "overlayfs upper fs cannot be watched with mount mark");
+			goto out;
+		}
+		SAFE_MOUNT(OVL_MNT, MOUNT_PATH, "none", MS_BIND, NULL);
+	}
+
 	/* Generate sequence of FAN_OPEN events on objects */
 	for (i = 0; i < ARRAY_SIZE(objects); i++)
 		fds[i] = SAFE_OPEN(objects[i].path, O_RDONLY);
@@ -174,6 +191,9 @@ static void do_test(unsigned int number)
 			SAFE_CLOSE(fds[i]);
 	}
 
+	if (tst_variant == 1)
+		SAFE_UMOUNT(MOUNT_PATH);
+
 	/* Read events from event queue */
 	len = SAFE_READ(0, fanotify_fd, events_buf, BUF_SIZE);
 
@@ -261,7 +281,32 @@ out:
 
 static void do_setup(void)
 {
-	REQUIRE_FANOTIFY_INIT_FLAGS_SUPPORTED_ON_FS(FAN_REPORT_FID, MOUNT_PATH);
+	const char *mnt;
+
+	/*
+	 * Bind mount to either base fs or to overlayfs over base fs:
+	 * Variant #0: watch base fs - open files on base fs
+	 * Variant #1: watch upper fs - open files on overlayfs
+	 *
+	 * Variant #1 tests a bug whose fix bc2473c90fca ("ovl: enable fsnotify
+	 * events on underlying real files") in kernel 6.5 is not likely to be
+	 * backported to older kernels.
+	 * To avoid waiting for events that won't arrive when testing old kernels,
+	 * require that kernel supports encoding fid with new flag AT_HADNLE_FID,
+	 * also merged to 6.5 and not likely to be backported to older kernels.
+	 */
+	if (tst_variant) {
+		REQUIRE_HANDLE_TYPE_SUPPORTED_BY_KERNEL(AT_HANDLE_FID);
+		ovl_mounted = TST_MOUNT_OVERLAY();
+		mnt = OVL_UPPER;
+	} else {
+		mnt = OVL_BASE_MNTPOINT;
+
+	}
+	REQUIRE_FANOTIFY_INIT_FLAGS_SUPPORTED_ON_FS(FAN_REPORT_FID, mnt);
+	SAFE_MKDIR(MOUNT_PATH, 0755);
+	SAFE_MOUNT(mnt, MOUNT_PATH, "none", MS_BIND, NULL);
+	bind_mounted = 1;
 
 	filesystem_mark_unsupported = fanotify_mark_supported_by_kernel(FAN_MARK_FILESYSTEM);
 
@@ -287,16 +332,23 @@ static void do_cleanup(void)
 	SAFE_CLOSE(nofid_fd);
 	if (fanotify_fd > 0)
 		SAFE_CLOSE(fanotify_fd);
+	if (bind_mounted) {
+		SAFE_UMOUNT(MOUNT_PATH);
+		SAFE_RMDIR(MOUNT_PATH);
+	}
+	if (ovl_mounted)
+		SAFE_UMOUNT(OVL_MNT);
 }
 
 static struct tst_test test = {
 	.test = do_test,
 	.tcnt = ARRAY_SIZE(test_cases),
+	.test_variants = 2,
 	.setup = do_setup,
 	.cleanup = do_cleanup,
 	.needs_root = 1,
 	.mount_device = 1,
-	.mntpoint = MOUNT_PATH,
+	.mntpoint = OVL_BASE_MNTPOINT,
 	.all_filesystems = 1,
 	.tags = (const struct tst_tag[]) {
 		{"linux-git", "c285a2f01d69"},
-- 
2.34.1

