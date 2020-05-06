Return-Path: <SRS0=Z7uo=6U=vger.kernel.org=linux-unionfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.6 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CEEBDC28CBC
	for <linux-unionfs@archiver.kernel.org>; Wed,  6 May 2020 10:23:10 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id A8CFF2068E
	for <linux-unionfs@archiver.kernel.org>; Wed,  6 May 2020 10:23:10 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Y3i/fAd5"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729022AbgEFKXK (ORCPT
        <rfc822;linux-unionfs@archiver.kernel.org>);
        Wed, 6 May 2020 06:23:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39806 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726354AbgEFKXK (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Wed, 6 May 2020 06:23:10 -0400
Received: from mail-wm1-x342.google.com (mail-wm1-x342.google.com [IPv6:2a00:1450:4864:20::342])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8A93FC061A0F;
        Wed,  6 May 2020 03:23:08 -0700 (PDT)
Received: by mail-wm1-x342.google.com with SMTP id g12so1993508wmh.3;
        Wed, 06 May 2020 03:23:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=VgsbU1olGZ3FSR/kBLu1xMOGeLhjZCKyfVl010oEcDc=;
        b=Y3i/fAd55EsDn5sFAQ/9LLgK5O7AJ3MBHxnGif8wYU7geioPhq4+vjxNhclawBXdK8
         pJ3nkePcwgD3mmAwVuec18UNAjZwjsNwra/H19agrLIvbrVVq7S7tiGMFyId3uyo2Tvl
         96PBafuYStwKyNZ8utajvRhLX0P5pv3MdBMZd0IEMT51p3cnh0Js2iMVMh8bBdZ/j1r0
         8VL1XbUhHS+rbn/KuvJPMtqeyIGQoEd81evGG1mx/1K3WxudAeyvOF2vBjUBWKSRAEHO
         MvozmsKNJA4v+aLyqiniEgzvH+hTJ01Twu2J6GLVFJiDKiyjqNfagovBedyb/YLEDn76
         2BSA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=VgsbU1olGZ3FSR/kBLu1xMOGeLhjZCKyfVl010oEcDc=;
        b=LomMptHDam7tieRPHNlSO+EpZWi9I9MFgFNxd1+Ugaj2XIMUlUP5VC48PlWVSwCsJT
         Tog0K1RPHkC6EzRLS/xJQDxc1UFSRV10LUJ8/YVkJXDI5iYr5LynBtODb3/ht+IEXZzR
         ry5mLZ8G2/JQar46sIR0SNiOq2vu/QnmPFAVG+H/1DOfg0199cBrO36Bs0900hMax25b
         pTlNr/6WWwn0+6jQGD0qu9/iv6EaFE+ymBNZDWGwoITzPxOsBH8i/OrVidQBZYuuIHdK
         oJNhYKcrlc5ecJ0NG+9LL5Q2SX+NWnf0JlisyxnW3mcFExJQOE1pDdi9m4BLLONwAaUp
         /Z9g==
X-Gm-Message-State: AGi0PuZa+1Tlr1ybJyfCoHY7FGF7jSNnTGkrOP0xMciNnhl+4Nk/GXXd
        d1bU+SDmpnyC6x4pLv0eAIg=
X-Google-Smtp-Source: APiQypIfbp+7hc92uGJLLHkIR6176ZgAQVPwtfM/cp1y1VCEoYTmQAiBUbm7SOXtZIRIhbDn0Oe7Wg==
X-Received: by 2002:a7b:c642:: with SMTP id q2mr3880650wmk.41.1588760587307;
        Wed, 06 May 2020 03:23:07 -0700 (PDT)
Received: from localhost.localdomain ([141.226.12.123])
        by smtp.gmail.com with ESMTPSA id u2sm2421379wrd.40.2020.05.06.03.23.05
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 06 May 2020 03:23:06 -0700 (PDT)
From:   Amir Goldstein <amir73il@gmail.com>
To:     Eryu Guan <guaneryu@gmail.com>
Cc:     Miklos Szeredi <miklos@szeredi.hu>,
        Lubos Dolezel <lubos@dolezel.info>,
        Dan Carpenter <dan.carpenter@oracle.com>,
        linux-unionfs@vger.kernel.org, fstests@vger.kernel.org
Subject: [PATCH 1/2] open_by_handle: add option -z to query file handle size
Date:   Wed,  6 May 2020 13:22:58 +0300
Message-Id: <20200506102259.28107-2-amir73il@gmail.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200506102259.28107-1-amir73il@gmail.com>
References: <20200506102259.28107-1-amir73il@gmail.com>
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

