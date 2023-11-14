Return-Path: <linux-unionfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8FDD7C4167D
	for <linux-unionfs@archiver.kernel.org>; Tue, 14 Nov 2023 07:23:50 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229580AbjKNHXw (ORCPT
        <rfc822;linux-unionfs@archiver.kernel.org>);
        Tue, 14 Nov 2023 02:23:52 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36624 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230271AbjKNHXv (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Tue, 14 Nov 2023 02:23:51 -0500
Received: from mail-wm1-x333.google.com (mail-wm1-x333.google.com [IPv6:2a00:1450:4864:20::333])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 092B1199
        for <linux-unionfs@vger.kernel.org>; Mon, 13 Nov 2023 23:23:48 -0800 (PST)
Received: by mail-wm1-x333.google.com with SMTP id 5b1f17b1804b1-40906fc54fdso43389225e9.0
        for <linux-unionfs@vger.kernel.org>; Mon, 13 Nov 2023 23:23:47 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1699946626; x=1700551426; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=XRjqmPoGjqCwEmzdD8zzaVXiSu14ojGr+c4OhtAXAwk=;
        b=KYTpBuKTq3Q1lvrwtUhwdnp4ztbmTg7RabwUyB13MoK6mtb2ca0123oqHVDsRysSZp
         UwZEmPBVXO+dY+4tH5ItDwAC1kzkjuHIzk0eXOA7i3TA8w2711x5umHoqJfGSQi9Nnuo
         oOABh4JDm9NuaHtr8LgBtSpKgQQRlBz/bVvXcMOoTsgs4QRB4OL2HEqTl+FI9YfUTPtD
         eiw+JbPqbfNWLpJyQM7FEirUcXSmnfkIY+oe3BeIeFsONjZyt4USCG5o36NjMwCeI0AX
         l1n+xgSdXXYXGdV/Gzbo1gSZRsoNQysrcvaDDhh6DMC2BwIcftYE5h/aTTvqtf4KASg2
         55QA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1699946626; x=1700551426;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=XRjqmPoGjqCwEmzdD8zzaVXiSu14ojGr+c4OhtAXAwk=;
        b=E2Cji1u2elQ7SxkTXradgF6M8g0p9bD1kbke4VE3C6KxijGn0FV0ZOO80rlVU0+rnc
         WnKyc90JJaj8nf68tg3Pvqtwvj0rf95t8+xCxnLIt2VacVPbGxHJBG1oyCfFPtg76sIc
         298gthmQaBlWCkooHtjs6yJy//7i66Ec52yVvkgfdy62l5WR62rgO6DlWQj+W/B7eyc+
         0YADEsCPrthCD8moYjSA5ouLdOYCDbY+RNSbH7eseD1GK1LnIxK0p0IESvzKUDrGv32Y
         /5adfGwO/UeeZoC8zB6ah8w61USlsXEHbfiB7sY2v+R9JN1bcVPVwJZg7J0XWd4vSk3o
         MYbg==
X-Gm-Message-State: AOJu0YwLW4BuFRm7qIECFB/x+9yWgwEld2dnP83H9F1yV+Xi7e5JF/kh
        cUkHv7iQM45l6LeCAdp/yLg=
X-Google-Smtp-Source: AGHT+IF5Ft80Fs+HQrM4IsQ/ydzwv31rzgmK+PwjOnWlW6w/TBoqkW5FH+4zU/Ip1FKt58G+gEynYA==
X-Received: by 2002:a05:6000:2c1:b0:32f:c750:6ebc with SMTP id o1-20020a05600002c100b0032fc7506ebcmr6321541wry.71.1699946626257;
        Mon, 13 Nov 2023 23:23:46 -0800 (PST)
Received: from amir-ThinkPad-T480.lan ([5.29.249.86])
        by smtp.gmail.com with ESMTPSA id g9-20020adff409000000b0032f7d7ec4adsm6865681wro.92.2023.11.13.23.23.45
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 13 Nov 2023 23:23:45 -0800 (PST)
From:   Amir Goldstein <amir73il@gmail.com>
To:     Petr Vorel <pvorel@suse.cz>
Cc:     Cyril Hrubis <chrubis@suse.cz>, Jan Kara <jack@suse.cz>,
        Miklos Szeredi <miklos@szeredi.hu>,
        linux-unionfs@vger.kernel.org, ltp@lists.linux.it
Subject: [PATCH 1/2] fanotify13: Test overlayfs while watching lower fs
Date:   Tue, 14 Nov 2023 09:23:37 +0200
Message-Id: <20231114072338.1669277-2-amir73il@gmail.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20231114072338.1669277-1-amir73il@gmail.com>
References: <20231114072338.1669277-1-amir73il@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-unionfs.vger.kernel.org>
X-Mailing-List: linux-unionfs@vger.kernel.org

We already have a test variant when watching upper fs.

Improve test coverage by adding a test variant with overlayfs
(over all supported fs) when watching the lower fs.

Signed-off-by: Amir Goldstein <amir73il@gmail.com>
---
 .../kernel/syscalls/fanotify/fanotify13.c     | 25 +++++++++++--------
 1 file changed, 15 insertions(+), 10 deletions(-)

diff --git a/testcases/kernel/syscalls/fanotify/fanotify13.c b/testcases/kernel/syscalls/fanotify/fanotify13.c
index a25a360fd..4bcffaab2 100644
--- a/testcases/kernel/syscalls/fanotify/fanotify13.c
+++ b/testcases/kernel/syscalls/fanotify/fanotify13.c
@@ -168,10 +168,10 @@ static void do_test(unsigned int number)
 	if (setup_marks(fanotify_fd, tc) != 0)
 		goto out;
 
-	/* Variant #1: watching upper fs - open files on overlayfs */
-	if (tst_variant == 1) {
+	/* Watching base fs - open files on overlayfs */
+	if (tst_variant) {
 		if (mark->flag & FAN_MARK_MOUNT) {
-			tst_res(TCONF, "overlayfs upper fs cannot be watched with mount mark");
+			tst_res(TCONF, "overlayfs base fs cannot be watched with mount mark");
 			goto out;
 		}
 		SAFE_MOUNT(OVL_MNT, MOUNT_PATH, "none", MS_BIND, NULL);
@@ -191,7 +191,7 @@ static void do_test(unsigned int number)
 			SAFE_CLOSE(fds[i]);
 	}
 
-	if (tst_variant == 1)
+	if (tst_variant)
 		SAFE_UMOUNT(MOUNT_PATH);
 
 	/* Read events from event queue */
@@ -286,9 +286,10 @@ static void do_setup(void)
 	/*
 	 * Bind mount to either base fs or to overlayfs over base fs:
 	 * Variant #0: watch base fs - open files on base fs
-	 * Variant #1: watch upper fs - open files on overlayfs
+	 * Variant #1: watch lower fs - open lower files on overlayfs
+	 * Variant #2: watch upper fs - open upper files on overlayfs
 	 *
-	 * Variant #1 tests a bug whose fix bc2473c90fca ("ovl: enable fsnotify
+	 * Variants 1,2 test a bug whose fix bc2473c90fca ("ovl: enable fsnotify
 	 * events on underlying real files") in kernel 6.5 is not likely to be
 	 * backported to older kernels.
 	 * To avoid waiting for events that won't arrive when testing old kernels,
@@ -298,7 +299,10 @@ static void do_setup(void)
 	if (tst_variant) {
 		REQUIRE_HANDLE_TYPE_SUPPORTED_BY_KERNEL(AT_HANDLE_FID);
 		ovl_mounted = TST_MOUNT_OVERLAY();
-		mnt = OVL_UPPER;
+		if (!ovl_mounted)
+			return;
+
+		mnt = tst_variant & 1 ? OVL_LOWER : OVL_UPPER;
 	} else {
 		mnt = OVL_BASE_MNTPOINT;
 
@@ -312,7 +316,7 @@ static void do_setup(void)
 
 	nofid_fd = SAFE_FANOTIFY_INIT(FAN_CLASS_NOTIF, O_RDONLY);
 
-	/* Create file and directory objects for testing */
+	/* Create file and directory objects for testing on base fs */
 	create_objects();
 
 	/*
@@ -329,7 +333,8 @@ static void do_setup(void)
 
 static void do_cleanup(void)
 {
-	SAFE_CLOSE(nofid_fd);
+	if (nofid_fd > 0)
+		SAFE_CLOSE(nofid_fd);
 	if (fanotify_fd > 0)
 		SAFE_CLOSE(fanotify_fd);
 	if (bind_mounted) {
@@ -343,7 +348,7 @@ static void do_cleanup(void)
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

