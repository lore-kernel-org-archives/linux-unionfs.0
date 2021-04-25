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
	by smtp.lore.kernel.org (Postfix) with ESMTP id C063FC43470
	for <linux-unionfs@archiver.kernel.org>; Sun, 25 Apr 2021 07:14:52 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id A84C7611C9
	for <linux-unionfs@archiver.kernel.org>; Sun, 25 Apr 2021 07:14:52 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230198AbhDYHPb (ORCPT
        <rfc822;linux-unionfs@archiver.kernel.org>);
        Sun, 25 Apr 2021 03:15:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33036 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230194AbhDYHPa (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Sun, 25 Apr 2021 03:15:30 -0400
Received: from mail-wr1-x42f.google.com (mail-wr1-x42f.google.com [IPv6:2a00:1450:4864:20::42f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 08E20C061756;
        Sun, 25 Apr 2021 00:14:50 -0700 (PDT)
Received: by mail-wr1-x42f.google.com with SMTP id s7so52476039wru.6;
        Sun, 25 Apr 2021 00:14:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=55sVTQrFfGEhu0JHBA9CDTtF22kDefd1VZe71y3fPL8=;
        b=RXISvwUQR2zyFwKuwi/M6vAZW83b/J8XAdwmPRQt9up9tJB3n93unot/SnGphs3aup
         qr8N/PhpP5TaOKuXcNLfNrYM+tjghP28+mbmVrchckCXWoaq4qr61SZfdUhdRpRn7KLx
         Ae62Q20vfvMvKSMjqsNbdUJlmooS4vOTjquRF7kwKIdknUafa3Y6lgcRsV5aRBoXeQ03
         V7EWj7w1CrqNfXoX4EpBdZcnBh9FVdIc+Mo12PzUdcphNEAdp03u/mNstmYXxWoTioOx
         yKNJabeHG88ltqJWmynZR9KXmm7l5aySMUSC50/PVdJIt7An3NeEa5Q9DcSS7+lt2leD
         GwPg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=55sVTQrFfGEhu0JHBA9CDTtF22kDefd1VZe71y3fPL8=;
        b=fQ7UbIGOGCjD4o3YiNTZRp8G7KoVuMqWyaAz09UoPuhFoSsTILNMoJdz7490dZdH8t
         d63Wtta52ThLQOsYiowgXrUmVPzm5KnQUDiovTHi+LX6hfQQuma5INE3ssNwZggMYzpB
         SoSqcp6ZfgMO3WxDgi0ES51fN727SSshRz6JCwsJeH91qbCEu1ZNGQdpOKnMKUf9Qz1u
         0Thh/TJHm/tzVsoKP5IS7ohOezwoGp8DdR05f+3QeBtL08QcJe8rzc26RySIMrVJct+X
         KHGMSiEOfEHzEWp8W0zqNQcrHIgU38l83OpBQcTBvfglNVtxOYurop+RUEJkYXe/WhIh
         bmNg==
X-Gm-Message-State: AOAM531lZ432ZOvIWP9BwAFda2kSM1DWwX+180UaPAxIzaWzZmx3Rk7E
        tlYBWKj018G1npyTahbS0FNwzohmiYc=
X-Google-Smtp-Source: ABdhPJyqp61GnK0ZFDazcr/BYfBkasMS/UJOKDNbHfL2h4i2QCQRJBeU+Yo5wfJp4zy0zNI67Qep9Q==
X-Received: by 2002:a5d:4acf:: with SMTP id y15mr15213796wrs.245.1619334888770;
        Sun, 25 Apr 2021 00:14:48 -0700 (PDT)
Received: from localhost.localdomain ([82.114.44.37])
        by smtp.gmail.com with ESMTPSA id x189sm15885626wmg.17.2021.04.25.00.14.47
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 25 Apr 2021 00:14:48 -0700 (PDT)
From:   Amir Goldstein <amir73il@gmail.com>
To:     Eryu Guan <guaneryu@gmail.com>
Cc:     Miklos Szeredi <miklos@szeredi.hu>, linux-unionfs@vger.kernel.org,
        fstests@vger.kernel.org
Subject: [PATCH v2 1/5] src/t_dir_offset2: Add an option to limit of buffer size
Date:   Sun, 25 Apr 2021 10:14:41 +0300
Message-Id: <20210425071445.29547-2-amir73il@gmail.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210425071445.29547-1-amir73il@gmail.com>
References: <20210425071445.29547-1-amir73il@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-unionfs.vger.kernel.org>
X-Mailing-List: linux-unionfs@vger.kernel.org

Will be used to force readdir in several getdents calls.

Signed-off-by: Amir Goldstein <amir73il@gmail.com>
---
 src/t_dir_offset2.c | 26 +++++++++++++++++++++-----
 1 file changed, 21 insertions(+), 5 deletions(-)

diff --git a/src/t_dir_offset2.c b/src/t_dir_offset2.c
index 5a6d7193..7aeb990e 100644
--- a/src/t_dir_offset2.c
+++ b/src/t_dir_offset2.c
@@ -30,16 +30,32 @@ struct linux_dirent64 {
 static uint64_t d_off_history[HISTORY_LEN];
 static uint64_t d_ino_history[HISTORY_LEN];
 
-int
-main(int argc, char *argv[])
+void usage()
 {
-	int fd, nread;
+	fprintf(stderr, "usage: t_dir_offset2: <dir> [bufsize]\n");
+	exit(EXIT_FAILURE);
+}
+
+int main(int argc, char *argv[])
+{
+	int fd;
 	char buf[BUF_SIZE];
+	int nread, bufsize = BUF_SIZE;
 	struct linux_dirent64 *d;
 	int bpos, total, i;
 	off_t lret;
 	int retval = EXIT_SUCCESS;
 
+	if (argc > 2) {
+		bufsize = atoi(argv[2]);
+		if (!bufsize)
+			usage();
+		if (bufsize > BUF_SIZE)
+			bufsize = BUF_SIZE;
+	} else if (argc < 2) {
+		usage();
+	}
+
 	fd = open(argv[1], O_RDONLY | O_DIRECTORY);
 	if (fd < 0) {
 		perror("open");
@@ -48,7 +64,7 @@ main(int argc, char *argv[])
 
 	total = 0;
 	for ( ; ; ) {
-		nread = syscall(SYS_getdents64, fd, buf, BUF_SIZE);
+		nread = syscall(SYS_getdents64, fd, buf, bufsize);
 		if (nread == -1) {
 			perror("getdents");
 			exit(EXIT_FAILURE);
@@ -89,7 +105,7 @@ main(int argc, char *argv[])
 			exit(EXIT_FAILURE);
 		}
 
-		nread = syscall(SYS_getdents64, fd, buf, BUF_SIZE);
+		nread = syscall(SYS_getdents64, fd, buf, bufsize);
 		if (nread == -1) {
 			perror("getdents");
 			exit(EXIT_FAILURE);
-- 
2.31.1

