Return-Path: <linux-unionfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4887DC83F3F
	for <linux-unionfs@archiver.kernel.org>; Sun,  3 Sep 2023 11:16:12 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236596AbjICLQO (ORCPT
        <rfc822;linux-unionfs@archiver.kernel.org>);
        Sun, 3 Sep 2023 07:16:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55326 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236584AbjICLQN (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Sun, 3 Sep 2023 07:16:13 -0400
Received: from mail-wm1-x32a.google.com (mail-wm1-x32a.google.com [IPv6:2a00:1450:4864:20::32a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1EFEA12A
        for <linux-unionfs@vger.kernel.org>; Sun,  3 Sep 2023 04:16:10 -0700 (PDT)
Received: by mail-wm1-x32a.google.com with SMTP id 5b1f17b1804b1-3fef56f7223so5027865e9.3
        for <linux-unionfs@vger.kernel.org>; Sun, 03 Sep 2023 04:16:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1693739768; x=1694344568; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=F+dv49PL7/PwKqjd+onDlDiMc2zNfs/0f2DUUXT6DZE=;
        b=QDGCxVJCSN1VqoFuUMSKYW+3OWnhLyX+mKSTOxBo+ZovkNFYn/KqWVBEmDHO58SoOQ
         CAm5yMhGk9NmPQjckTz3xYo+HkUPiFJkjDqXscOYfLXQv+EnKJ6TV03klmGoXsb/+tzk
         ddyI0og88uTLo+7R7NwLnU6C2ZZnFbjwcEHrWMc5WNlUoHEdMtg1GgNoPQlI0xqc1EE+
         asa6ha8BnXoE1+Ph7C24R1+m+nM8PnyXHp1dUvq+78wkkXzoN4559OvXmqevW1iD2lup
         CriIwNmfJ5EgWaT+Fx6zRE9If/VyHA73UD8Y4xpwky1Pwuiw8RlX6gkE7+Cfp7ayLswL
         lWew==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1693739768; x=1694344568;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=F+dv49PL7/PwKqjd+onDlDiMc2zNfs/0f2DUUXT6DZE=;
        b=GE7DV9uJU3djEkd0S/3V6gw72+sidbaZTywXkjoPvSzD2tepO6MCiRGom9T/E3KMQv
         48gvA6LDReTxZgqxcMrgGeq3ibwfQC4accH9JkfmfHc6hjgL8vSbGvu00lpzGMbk46Iu
         YR/u0dBshfbzlJZZoh0j8WL3KLGlBXh1NdOH4/8R36ryWI1klvs9x+P2SJ7ZlL0MAuCL
         kbMeDfAIR1SiAXmr0+1aAnR3WLhd0LIl7EIUvX6jx5NwR3yyOkdCdz83WHIJDU4H+QDs
         2eZxlBZ+IWfW2YsTS+ECUGX0/obUVAEVyepfaA9L2xD9lPVYST7tazgBv6BZCfM+WvOg
         7fqg==
X-Gm-Message-State: AOJu0YylmGiwaMRlZrSTuGlnDd8N+cv2t9uPYzmSJmAF5KdonAwD5PBJ
        8evIlI/uilb91WG5qSneBjc=
X-Google-Smtp-Source: AGHT+IGeoML/AK0cwgU7N2DeH7ohKQ8WSX7tuN2CBvCTsR9RuXhGuN+GUqtqgcsQ41PBPKbMN3HGOA==
X-Received: by 2002:a7b:cb95:0:b0:401:bf87:989c with SMTP id m21-20020a7bcb95000000b00401bf87989cmr5232704wmi.34.1693739768348;
        Sun, 03 Sep 2023 04:16:08 -0700 (PDT)
Received: from amir-ThinkPad-T480.lan ([5.29.249.86])
        by smtp.gmail.com with ESMTPSA id 9-20020a05600c228900b003fc080acf68sm13899065wmf.34.2023.09.03.04.16.06
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 03 Sep 2023 04:16:07 -0700 (PDT)
From:   Amir Goldstein <amir73il@gmail.com>
To:     Petr Vorel <pvorel@suse.cz>
Cc:     Cyril Hrubis <chrubis@suse.cz>, Jan Kara <jack@suse.cz>,
        Christian Brauner <brauner@kernel.org>,
        Miklos Szeredi <miklos@szeredi.hu>,
        linux-unionfs@vger.kernel.org, ltp@lists.linux.it
Subject: [PATCH 2/3] fanotify13: Test watching overlayfs with FAN_REPORT_FID
Date:   Sun,  3 Sep 2023 14:15:57 +0300
Message-Id: <20230903111558.2603332-3-amir73il@gmail.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20230903111558.2603332-1-amir73il@gmail.com>
References: <20230903111558.2603332-1-amir73il@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-unionfs.vger.kernel.org>
X-Mailing-List: linux-unionfs@vger.kernel.org

Run a test variant watching overlayfs (over all supported fs)
and reporting events with fid.

This requires overlayfs support for AT_HANDLE_FID.

Signed-off-by: Amir Goldstein <amir73il@gmail.com>
---
 testcases/kernel/syscalls/fanotify/fanotify.h   | 15 +++++++++++----
 testcases/kernel/syscalls/fanotify/fanotify13.c |  7 +++++--
 2 files changed, 16 insertions(+), 6 deletions(-)

diff --git a/testcases/kernel/syscalls/fanotify/fanotify.h b/testcases/kernel/syscalls/fanotify/fanotify.h
index 75a081dc9..eea1dad91 100644
--- a/testcases/kernel/syscalls/fanotify/fanotify.h
+++ b/testcases/kernel/syscalls/fanotify/fanotify.h
@@ -93,6 +93,11 @@ static inline void fanotify_get_fid(const char *path, __kernel_fsid_t *fsid,
 
 	if (name_to_handle_at(AT_FDCWD, path, handle, &mount_id, 0) == -1) {
 		if (errno == EOPNOTSUPP) {
+			/* Try to request non-decodeable fid instead */
+			if (name_to_handle_at(AT_FDCWD, path, handle, &mount_id,
+					      AT_HANDLE_FID) == 0)
+				return;
+
 			tst_brk(TCONF,
 				"filesystem %s does not support file handles",
 				tst_device->fs_type);
@@ -179,6 +184,7 @@ static inline int fanotify_events_supported_by_kernel(uint64_t mask,
  * @return  0: fanotify supported both in kernel and on tested filesystem
  * @return -1: @flags not supported in kernel
  * @return -2: @flags not supported on tested filesystem (tested if @fname is not NULL)
+ * @return -3: @flags not supported on overlayfs (tested if @fname == OVL_MNT)
  */
 static inline int fanotify_init_flags_supported_on_fs(unsigned int flags, const char *fname)
 {
@@ -199,7 +205,7 @@ static inline int fanotify_init_flags_supported_on_fs(unsigned int flags, const
 
 	if (fname && fanotify_mark(fd, FAN_MARK_ADD, FAN_ACCESS, AT_FDCWD, fname) < 0) {
 		if (errno == ENODEV || errno == EOPNOTSUPP || errno == EXDEV) {
-			rval = -2;
+			rval = strcmp(fname, OVL_MNT) ? -2 : -3;
 		} else {
 			tst_brk(TBROK | TERRNO,
 				"fanotify_mark (%d, FAN_MARK_ADD, ..., AT_FDCWD, %s) failed",
@@ -226,10 +232,11 @@ static inline void fanotify_init_flags_err_msg(const char *flags_str,
 	if (fail == -1)
 		res_func(file, lineno, TCONF,
 			 "%s not supported in kernel?", flags_str);
-	if (fail == -2)
+	if (fail == -2 || fail == -3)
 		res_func(file, lineno, TCONF,
-			 "%s not supported on %s filesystem",
-			 flags_str, tst_device->fs_type);
+			 "%s not supported on %s%s filesystem",
+			 flags_str, fail == -3 ? "overlayfs over " : "",
+			 tst_device->fs_type);
 }
 
 #define FANOTIFY_INIT_FLAGS_ERR_MSG(flags, fail) \
diff --git a/testcases/kernel/syscalls/fanotify/fanotify13.c b/testcases/kernel/syscalls/fanotify/fanotify13.c
index adba41453..5c1d287d7 100644
--- a/testcases/kernel/syscalls/fanotify/fanotify13.c
+++ b/testcases/kernel/syscalls/fanotify/fanotify13.c
@@ -287,6 +287,7 @@ static void do_setup(void)
 	 * Bind mount to either base fs or to overlayfs over base fs:
 	 * Variant #0: watch base fs - open files on base fs
 	 * Variant #1: watch upper fs - open files on overlayfs
+	 * Variant #2: watch overlayfs - open files on overlayfs
 	 *
 	 * Variant #1 tests a bug whose fix bc2473c90fca ("ovl: enable fsnotify
 	 * events on underlying real files") in kernel 6.5 is not likely to be
@@ -294,11 +295,13 @@ static void do_setup(void)
 	 * To avoid waiting for events that won't arrive when testing old kernels,
 	 * require that kernel supports encoding fid with new flag AT_HADNLE_FID,
 	 * also merged to 6.5 and not likely to be backported to older kernels.
+	 * Variant #2 tests overlayfs watch with FAN_REPORT_FID, which also
+	 * requires kernel with support for AT_HADNLE_FID.
 	 */
 	if (tst_variant) {
 		REQUIRE_HANDLE_TYPE_SUPPORTED_BY_KERNEL(AT_HANDLE_FID);
 		ovl_mounted = TST_MOUNT_OVERLAY();
-		mnt = OVL_UPPER;
+		mnt = tst_variant == 1 ? OVL_UPPER : OVL_MNT;
 	} else {
 		mnt = OVL_BASE_MNTPOINT;
 
@@ -343,7 +346,7 @@ static void do_cleanup(void)
 static struct tst_test test = {
 	.test = do_test,
 	.tcnt = ARRAY_SIZE(test_cases),
-	.test_variants = 2,
+	.test_variants = 3,
 	.setup = do_setup,
 	.cleanup = do_cleanup,
 	.needs_root = 1,
-- 
2.34.1

