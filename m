Return-Path: <SRS0=/kxx=73=vger.kernel.org=linux-unionfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.6 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7A341C433E2
	for <linux-unionfs@archiver.kernel.org>; Sun, 14 Jun 2020 07:01:31 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 4FDDB20776
	for <linux-unionfs@archiver.kernel.org>; Sun, 14 Jun 2020 07:01:31 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="epCYZGec"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726630AbgFNHBa (ORCPT
        <rfc822;linux-unionfs@archiver.kernel.org>);
        Sun, 14 Jun 2020 03:01:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59624 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726672AbgFNHBV (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Sun, 14 Jun 2020 03:01:21 -0400
Received: from mail-wm1-x343.google.com (mail-wm1-x343.google.com [IPv6:2a00:1450:4864:20::343])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 669E5C08C5C2;
        Sun, 14 Jun 2020 00:01:21 -0700 (PDT)
Received: by mail-wm1-x343.google.com with SMTP id r9so11594966wmh.2;
        Sun, 14 Jun 2020 00:01:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=VgsbU1olGZ3FSR/kBLu1xMOGeLhjZCKyfVl010oEcDc=;
        b=epCYZGec87TIrpU+STFdLLD6SHZyr/4T1+Y7volVaXoK99pdgxDYuRM+u+/ExBH0Hl
         STZnkgiQBDe+GJzmBmz3tiRgK6zrqv1HUwxsUlcQwOvGqs6NSaT2995rMvcx4b67ECaZ
         welizIgzxcaR1DtuECh6/FBR2tUtMA/Mt9eaH8XDgzhGprSyqNsAv/XwgTtKmFdozmRf
         WUDYBDr070ukTelAqZs79tiO9g7zrHt5eNj2stklTm2GgLCHC7enapPO9bPsefMZDtGg
         PwKbFepvfiWULO86lTClwt5HpEJnYwCwPaDYYcXqtOVUFPyNF98952IXzCj56XptrsrH
         86FQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=VgsbU1olGZ3FSR/kBLu1xMOGeLhjZCKyfVl010oEcDc=;
        b=pyooCUPGmSeLvKXyNPrZoOxc7G3dLq7UwjGo0ql6usxc6QF7jVIyCrNlllldUQlYp5
         dbCJxdKuEZsxatyQLNzI/nsoJc3flGg299KSx1kiCsIaxZbipyqVtfRtKcAM4WofMPSW
         q3Bj5CQ9mPENG973ywD3JjZqG3Bs63ejyFz4JdaZws8yoNtatG9Pf33eurIf4jsORFUr
         IRwUqxMGxi3ZO8BaeXGgkk/c06fRuj/OJElRvLWTPxOXhjfTxKj1ddPMqP405thMkgAr
         W59qiV/hKxcZhSapEA+hsKafmLiN/yPKelC8rFttqKwd5hrhUrqRkPyBUNPox5IoEE3j
         DfcQ==
X-Gm-Message-State: AOAM531Iy/KlH1pnYmRV3rAFkPUhqfN/z9e7GVeT1Zu3NYVCBTzZCwVH
        a6pd89gc4KQZVp1Yzx0+bfk=
X-Google-Smtp-Source: ABdhPJzPWsfQ8WoUR86fLZONsQBF5W0e65BiUhHGMyb9ujj0Rd9OWICrh8rmP4BJ+HpJ30vXQ9eIBw==
X-Received: by 2002:a05:600c:2215:: with SMTP id z21mr7204113wml.48.1592118080055;
        Sun, 14 Jun 2020 00:01:20 -0700 (PDT)
Received: from localhost.localdomain ([5.102.204.95])
        by smtp.gmail.com with ESMTPSA id i10sm17951010wrw.51.2020.06.14.00.01.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 14 Jun 2020 00:01:19 -0700 (PDT)
From:   Amir Goldstein <amir73il@gmail.com>
To:     Eryu Guan <guaneryu@gmail.com>
Cc:     Miklos Szeredi <miklos@szeredi.hu>,
        Dan Carpenter <dan.carpenter@oracle.com>,
        Lubos Dolezel <lubos@dolezel.info>,
        linux-unionfs@vger.kernel.org, fstests@vger.kernel.org
Subject: [PATCH v2 1/2] open_by_handle: add option -z to query file handle size
Date:   Sun, 14 Jun 2020 10:01:08 +0300
Message-Id: <20200614070109.29842-2-amir73il@gmail.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200614070109.29842-1-amir73il@gmail.com>
References: <20200614070109.29842-1-amir73il@gmail.com>
Sender: linux-unionfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-unionfs.vger.kernel.org>
X-Mailing-List: linux-unionfs@vger.kernel.org

Instead of using MAX_HANDLE_SZ, query the filesystem buffer size
and use that buffer size to get the file handle.

Signed-off-by: Amir Goldstein <amir73il@gmail.com>
---
 src/open_by_handle.c | 27 ++++++++++++++++++++++++---
 1 file changed, 24 insertions(+), 3 deletions(-)

diff --git a/src/open_by_handle.c b/src/open_by_handle.c
index 4fdfacd7..0f74ed08 100644
--- a/src/open_by_handle.c
+++ b/src/open_by_handle.c
@@ -114,6 +114,7 @@ void usage(void)
 	fprintf(stderr, "open_by_handle -i <handles_file> <test_dir> [N] - read test files handles from file and try to open by handle\n");
 	fprintf(stderr, "open_by_handle -o <handles_file> <test_dir> [N] - get file handles of test files and write handles to file\n");
 	fprintf(stderr, "open_by_handle -s <test_dir> [N] - wait in sleep loop after opening files by handle to keep them open\n");
+	fprintf(stderr, "open_by_handle -z <test_dir> [N] - query filesystem required buffer size\n");
 	exit(EXIT_FAILURE);
 }
 
@@ -136,11 +137,12 @@ int main(int argc, char **argv)
 	int	create = 0, delete = 0, nlink = 1, move = 0;
 	int	rd = 0, wr = 0, wrafter = 0, parent = 0;
 	int	keepopen = 0, drop_caches = 1, sleep_loop = 0;
+	int	bufsz = MAX_HANDLE_SZ;
 
 	if (argc < 2)
 		usage();
 
-	while ((c = getopt(argc, argv, "cludmrwapknhi:o:s")) != -1) {
+	while ((c = getopt(argc, argv, "cludmrwapknhi:o:sz")) != -1) {
 		switch (c) {
 		case 'c':
 			create = 1;
@@ -199,6 +201,9 @@ int main(int argc, char **argv)
 		case 's':
 			sleep_loop = 1;
 			break;
+		case 'z':
+			bufsz = 0;
+			break;
 		default:
 			fprintf(stderr, "illegal option '%s'\n", argv[optind]);
 		case 'h':
@@ -300,8 +305,16 @@ int main(int argc, char **argv)
 				return EXIT_FAILURE;
 			}
 		} else {
-			handle[i].fh.handle_bytes = MAX_HANDLE_SZ;
+			handle[i].fh.handle_bytes = bufsz;
 			ret = name_to_handle_at(AT_FDCWD, fname, &handle[i].fh, &mount_id, 0);
+			if (bufsz < handle[i].fh.handle_bytes) {
+				/* Query the filesystem required bufsz and the file handle */
+				if (ret != -1 || errno != EOVERFLOW) {
+					fprintf(stderr, "Unexpected result from name_to_handle_at(%s)\n", fname);
+					return EXIT_FAILURE;
+				}
+				ret = name_to_handle_at(AT_FDCWD, fname, &handle[i].fh, &mount_id, 0);
+			}
 			if (ret < 0) {
 				strcat(fname, ": name_to_handle");
 				perror(fname);
@@ -334,8 +347,16 @@ int main(int argc, char **argv)
 				return EXIT_FAILURE;
 			}
 		} else {
-			dir_handle.fh.handle_bytes = MAX_HANDLE_SZ;
+			dir_handle.fh.handle_bytes = bufsz;
 			ret = name_to_handle_at(AT_FDCWD, test_dir, &dir_handle.fh, &mount_id, 0);
+			if (bufsz < dir_handle.fh.handle_bytes) {
+				/* Query the filesystem required bufsz and the file handle */
+				if (ret != -1 || errno != EOVERFLOW) {
+					fprintf(stderr, "Unexpected result from name_to_handle_at(%s)\n", dname);
+					return EXIT_FAILURE;
+				}
+				ret = name_to_handle_at(AT_FDCWD, test_dir, &dir_handle.fh, &mount_id, 0);
+			}
 			if (ret < 0) {
 				strcat(dname, ": name_to_handle");
 				perror(dname);
-- 
2.17.1

