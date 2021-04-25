Return-Path: <linux-unionfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D1250C433B4
	for <linux-unionfs@archiver.kernel.org>; Sun, 25 Apr 2021 07:14:54 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id B482B613C2
	for <linux-unionfs@archiver.kernel.org>; Sun, 25 Apr 2021 07:14:54 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230194AbhDYHPd (ORCPT
        <rfc822;linux-unionfs@archiver.kernel.org>);
        Sun, 25 Apr 2021 03:15:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33048 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229825AbhDYHPd (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Sun, 25 Apr 2021 03:15:33 -0400
Received: from mail-wm1-x32e.google.com (mail-wm1-x32e.google.com [IPv6:2a00:1450:4864:20::32e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 58E23C061574;
        Sun, 25 Apr 2021 00:14:52 -0700 (PDT)
Received: by mail-wm1-x32e.google.com with SMTP id f195-20020a1c1fcc0000b029012eb88126d7so3374927wmf.3;
        Sun, 25 Apr 2021 00:14:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=FIlIiRJSjRiunFMuHCtAG6p9TvlZTNyPYb6XoxHnjlA=;
        b=R+plW7xFxDzBBuf8BB7sPlx17x6/EKFMCoc5EtmZHwTIqLl7t4cx3tm9IC8keTMFI1
         Tf1znqfnVwmS14Ta6UkeI1fc8ZaCIdzAIxXM/uAQIWleCJp9ZArGS9UmOrzMmrppxpvm
         gEdaVmMvlEMzlNzZqhqkP4PHQtQEy6rH9fBoQEel+6BEn+lHSVdVjsrWSdE8hJZWu+Qf
         rutm4lUW7Mg0tPp/yccJCYR2C3Pp2z28NHCaj8J6IwvRFEZ4TAeJnVlNLJMETpJYkpUg
         rUKhQ9oVgVUAaIM/9VICzR8E5Vxy55ZQLdrMaz8CWOHK4GtjLg45J6DynJ5V9bse/Bgv
         j/tA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=FIlIiRJSjRiunFMuHCtAG6p9TvlZTNyPYb6XoxHnjlA=;
        b=DMoeqh+5c/mbxj+84XHX7S/q4ijErCjLi/Hb9IPm6tfyqt5A6cTnQM3ny2xRkM6qiN
         FVi6u+3HLMZtAlPrE0Z/x0CdFpYwPsFNveRSAABoz0EHF+7qN/LV6CLpAmKtE8aHjQTw
         qhJtzRdYFxN3JXewBNXOn1is9ws2fsnCainNfgl0m/lTOrBhXTgwzy2w4/A7tbmi0Zhk
         ZbcynxlKlB8x3bgdgF6kGHiFNnSCniQkb3K3arwnXafrPFoixLkzJqWfmFiHFtwqJk1i
         rFjaY/YE8M20L5m+xU/RKgbFwSUa0gVD7u2YY6ExXL+zVayeJyHVxjHHBVY/wUUFwObl
         z2+w==
X-Gm-Message-State: AOAM533RrzVoormp6yIB/kSw3LYm3Pgc/Ges0PXSYTZPfotpkP07wJB0
        EW/9HyJmbNowZfFS3P6pd8Q=
X-Google-Smtp-Source: ABdhPJzgeu0uyEZ4/Gv8piZpW/A9Sn7zHDyGIGGXcDVXUCkQYLP8Tzw9vtEUJ2/K1EyxcLhcm1vkxw==
X-Received: by 2002:a1c:64c4:: with SMTP id y187mr14203210wmb.162.1619334891092;
        Sun, 25 Apr 2021 00:14:51 -0700 (PDT)
Received: from localhost.localdomain ([82.114.44.37])
        by smtp.gmail.com with ESMTPSA id x189sm15885626wmg.17.2021.04.25.00.14.50
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 25 Apr 2021 00:14:50 -0700 (PDT)
From:   Amir Goldstein <amir73il@gmail.com>
To:     Eryu Guan <guaneryu@gmail.com>
Cc:     Miklos Szeredi <miklos@szeredi.hu>, linux-unionfs@vger.kernel.org,
        fstests@vger.kernel.org
Subject: [PATCH v2 3/5] src/t_dir_offset2: Add option to create or unlink file
Date:   Sun, 25 Apr 2021 10:14:43 +0300
Message-Id: <20210425071445.29547-4-amir73il@gmail.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210425071445.29547-1-amir73il@gmail.com>
References: <20210425071445.29547-1-amir73il@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-unionfs.vger.kernel.org>
X-Mailing-List: linux-unionfs@vger.kernel.org

Will be used to test missing/stale entries after modifications to
an open dirfd.

Signed-off-by: Amir Goldstein <amir73il@gmail.com>
---
 src/t_dir_offset2.c | 56 ++++++++++++++++++++++++++++++++++++++++++---
 1 file changed, 53 insertions(+), 3 deletions(-)

diff --git a/src/t_dir_offset2.c b/src/t_dir_offset2.c
index 7af24519..75b41c1a 100644
--- a/src/t_dir_offset2.c
+++ b/src/t_dir_offset2.c
@@ -34,13 +34,13 @@ static uint64_t d_ino_history[HISTORY_LEN];
 
 void usage()
 {
-	fprintf(stderr, "usage: t_dir_offset2: <dir> [[bufsize] <filename> [-v]]\n");
+	fprintf(stderr, "usage: t_dir_offset2: <dir> [[bufsize] [-|+]<filename> [-v]]\n");
 	exit(EXIT_FAILURE);
 }
 
 int main(int argc, char *argv[])
 {
-	int fd;
+	int fd, fd2 = -1;
 	char buf[BUF_SIZE];
 	int nread, bufsize = BUF_SIZE;
 	struct linux_dirent64 *d;
@@ -49,7 +49,7 @@ int main(int argc, char *argv[])
 	int retval = EXIT_SUCCESS;
 	const char *filename = NULL;
 	int exists = 0, found = 0;
-	int verbose = 0;
+	int modify = 0, verbose = 0;
 
 	if (argc > 2) {
 		bufsize = atoi(argv[2]);
@@ -60,6 +60,13 @@ int main(int argc, char *argv[])
 
 		if (argc > 3) {
 			filename = argv[3];
+			/* +<filename> creates, -<filename> removes */
+			if (filename[0] == '+')
+				modify = 1;
+			else if (filename[0] == '-')
+				modify = -1;
+			if (modify)
+				filename++;
 			if (argc > 4 && !strcmp(argv[4], "-v"))
 				verbose = 1;
 		}
@@ -89,6 +96,49 @@ int main(int argc, char *argv[])
 			exit(EXIT_FAILURE);
 		}
 
+		if (modify && fd2 < 0 && total == 0) {
+			printf("getdents at offset 0 returned %d bytes\n", nread);
+
+			/* create/unlink entry after first getdents */
+			if (modify > 0) {
+				if (openat(fd, filename, O_CREAT, 0600) < 0) {
+					perror("openat");
+					exit(EXIT_FAILURE);
+				}
+				exists = 1;
+				printf("created entry %s\n", filename);
+			} else if (modify < 0) {
+				if (unlinkat(fd, filename, 0) < 0) {
+					perror("unlinkat");
+					exit(EXIT_FAILURE);
+				}
+				exists = 0;
+				printf("unlinked entry %s\n", filename);
+			}
+
+			/*
+			 * Old fd may not return new entry and may return stale
+			 * entries which is allowed.  Keep old fd open and open
+			 * a new fd to check for stale or missing entries later.
+			 */
+			fd2 = open(argv[1], O_RDONLY | O_DIRECTORY);
+			if (fd2 < 0) {
+				perror("open fd2");
+				exit(EXIT_FAILURE);
+			}
+		}
+
+		if (nread == 0) {
+			if (fd2 < 0 || fd == fd2)
+				break;
+
+			/* Re-iterate with new fd leaving old fd open */
+			fd = fd2;
+			total = 0;
+			found = 0;
+			continue;
+		}
+
 		if (nread == 0)
 			break;
 
-- 
2.31.1

