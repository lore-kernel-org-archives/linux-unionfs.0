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
	by smtp.lore.kernel.org (Postfix) with ESMTP id 46AF0C43460
	for <linux-unionfs@archiver.kernel.org>; Sun, 25 Apr 2021 07:14:52 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 21C26610A1
	for <linux-unionfs@archiver.kernel.org>; Sun, 25 Apr 2021 07:14:52 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229911AbhDYHPa (ORCPT
        <rfc822;linux-unionfs@archiver.kernel.org>);
        Sun, 25 Apr 2021 03:15:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33038 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230179AbhDYHPa (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Sun, 25 Apr 2021 03:15:30 -0400
Received: from mail-wm1-x32f.google.com (mail-wm1-x32f.google.com [IPv6:2a00:1450:4864:20::32f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 26B0AC061574;
        Sun, 25 Apr 2021 00:14:51 -0700 (PDT)
Received: by mail-wm1-x32f.google.com with SMTP id y204so26842987wmg.2;
        Sun, 25 Apr 2021 00:14:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=wwvJ0SUYHs2mHq+f1YwLTGzVZoArfQUCHwJFLhi7+IA=;
        b=jfSbPtrYWhQmEMRiu5CHowhSGE2vwnv0EAafpYdJ+s4Jvc+/zhgfRpUwebqQl1vlvI
         LbP2Ykl6ZwpAzXgqdigyBE7EzxvWflY9p035lwk9HEOH5QBF01DEFMhArC3wvqVBg3Tp
         dy9EpODOSZrDIpewl2FII9JPsdDl0pVpm7bYa2TAVglJ1R2syqIU/LoEiRg4gApW/AB1
         lo361a6JF47EuC/Hz5h4jZdS7Y72a4AgWjCCwOvDO/KpxEeRup9SKwWP6BsG2GVlIQIM
         kL4Vb98FloguB9a4RW8c2+DKdhXJBRS372BB053V2Qxj3u9L/bRijjp5E2cLys48hYWU
         lyDw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=wwvJ0SUYHs2mHq+f1YwLTGzVZoArfQUCHwJFLhi7+IA=;
        b=lQJGnTY+On/5+alclF0vEAw0g4iy1f0F6jYiKgtUWJnIHJJCTOPNBVtiF5LndJWE10
         be3GgdOFGt5fkSTkeVQFHkB4YGnCgEN2Ou4JPGpuk79a4aq+MI84ppmBaAyuOTcUCU3v
         XDm1kz+7mrZ5QQAbcavVsGlAwFXsMj4asKn+ErYCSo+egfmcoxsdPpmar7huWcCUYPNC
         wAbFYAxB9uvl7Y1hFqhFzC//apgdzTivLrVT1tRBZOwq3jneH6M81OWvoyvNFrsA+i71
         JF5uY30pD6W++SfkUt8crWl/p6zUEBZOI8R9I6KbnaEal/px0ksyv69IcB7N2DqeGqZ2
         rz9w==
X-Gm-Message-State: AOAM531Rt155yuLFBz6tjwQSZxcoP5lEb2dIp1AZtpYmAPVD3MOzBHEm
        OgxjV3a5TvoFZnvnPE8NHRzEFZp2jlQ=
X-Google-Smtp-Source: ABdhPJxxAQb4nATQOnofXWHfmEoMTfNjZhxmT/Y8kU5v6dxRbP99joNpd+VGmC9kY3w8zb/RgS1oQQ==
X-Received: by 2002:a7b:c206:: with SMTP id x6mr2463386wmi.72.1619334889939;
        Sun, 25 Apr 2021 00:14:49 -0700 (PDT)
Received: from localhost.localdomain ([82.114.44.37])
        by smtp.gmail.com with ESMTPSA id x189sm15885626wmg.17.2021.04.25.00.14.48
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 25 Apr 2021 00:14:49 -0700 (PDT)
From:   Amir Goldstein <amir73il@gmail.com>
To:     Eryu Guan <guaneryu@gmail.com>
Cc:     Miklos Szeredi <miklos@szeredi.hu>, linux-unionfs@vger.kernel.org,
        fstests@vger.kernel.org
Subject: [PATCH v2 2/5] src/t_dir_offset2: Add an option to find file by name
Date:   Sun, 25 Apr 2021 10:14:42 +0300
Message-Id: <20210425071445.29547-3-amir73il@gmail.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210425071445.29547-1-amir73il@gmail.com>
References: <20210425071445.29547-1-amir73il@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-unionfs.vger.kernel.org>
X-Mailing-List: linux-unionfs@vger.kernel.org

Will be used to check for missing/stale entries.

Signed-off-by: Amir Goldstein <amir73il@gmail.com>
---
 src/t_dir_offset2.c | 39 ++++++++++++++++++++++++++++++++++++++-
 1 file changed, 38 insertions(+), 1 deletion(-)

diff --git a/src/t_dir_offset2.c b/src/t_dir_offset2.c
index 7aeb990e..7af24519 100644
--- a/src/t_dir_offset2.c
+++ b/src/t_dir_offset2.c
@@ -8,11 +8,13 @@
  * that these offsets are seekable to entry with the right inode.
  */
 
+#include <errno.h>
 #include <fcntl.h>
 #include <stdio.h>
 #include <unistd.h>
 #include <stdint.h>
 #include <stdlib.h>
+#include <string.h>
 #include <sys/stat.h>
 #include <sys/syscall.h>
 
@@ -32,7 +34,7 @@ static uint64_t d_ino_history[HISTORY_LEN];
 
 void usage()
 {
-	fprintf(stderr, "usage: t_dir_offset2: <dir> [bufsize]\n");
+	fprintf(stderr, "usage: t_dir_offset2: <dir> [[bufsize] <filename> [-v]]\n");
 	exit(EXIT_FAILURE);
 }
 
@@ -45,6 +47,9 @@ int main(int argc, char *argv[])
 	int bpos, total, i;
 	off_t lret;
 	int retval = EXIT_SUCCESS;
+	const char *filename = NULL;
+	int exists = 0, found = 0;
+	int verbose = 0;
 
 	if (argc > 2) {
 		bufsize = atoi(argv[2]);
@@ -52,6 +57,12 @@ int main(int argc, char *argv[])
 			usage();
 		if (bufsize > BUF_SIZE)
 			bufsize = BUF_SIZE;
+
+		if (argc > 3) {
+			filename = argv[3];
+			if (argc > 4 && !strcmp(argv[4], "-v"))
+				verbose = 1;
+		}
 	} else if (argc < 2) {
 		usage();
 	}
@@ -62,6 +73,14 @@ int main(int argc, char *argv[])
 		exit(EXIT_FAILURE);
 	}
 
+	if (filename) {
+		exists = !faccessat(fd, filename, F_OK, AT_SYMLINK_NOFOLLOW);
+		if (!exists && errno != ENOENT) {
+			perror("faccessat");
+			exit(EXIT_FAILURE);
+		}
+	}
+
 	total = 0;
 	for ( ; ; ) {
 		nread = syscall(SYS_getdents64, fd, buf, bufsize);
@@ -91,10 +110,28 @@ int main(int argc, char *argv[])
 			}
 			d_off_history[total] = d->d_off;
 			d_ino_history[total] = d->d_ino;
+			if (filename) {
+				if (verbose)
+					printf("entry #%d: %s (d_ino=%lld, d_off=%lld)\n",
+					       i, d->d_name, (long long int)d->d_ino,
+					       (long long int)d->d_off);
+				if (!strcmp(filename, d->d_name))
+					found = 1;
+			}
 			bpos += d->d_reclen;
 		}
 	}
 
+	if (filename) {
+		if (exists == found) {
+			printf("entry %s %sfound as expected\n", filename, found ? "" : "not ");
+		} else {
+			fprintf(stderr, "%s entry %s\n",
+				exists ? "missing" : "stale", filename);
+			exit(EXIT_FAILURE);
+		}
+	}
+
 	/* check if seek works correctly */
 	d = (struct linux_dirent64 *)buf;
 	for (i = total - 1; i >= 0; i--)
-- 
2.31.1

