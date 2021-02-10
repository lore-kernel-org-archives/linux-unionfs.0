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
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1706AC4332B
	for <linux-unionfs@archiver.kernel.org>; Wed, 10 Feb 2021 19:05:01 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id D8B9464E38
	for <linux-unionfs@archiver.kernel.org>; Wed, 10 Feb 2021 19:05:00 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233117AbhBJTEt (ORCPT
        <rfc822;linux-unionfs@archiver.kernel.org>);
        Wed, 10 Feb 2021 14:04:49 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44240 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234117AbhBJTEY (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Wed, 10 Feb 2021 14:04:24 -0500
Received: from mail-ej1-x630.google.com (mail-ej1-x630.google.com [IPv6:2a00:1450:4864:20::630])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D9A59C0613D6;
        Wed, 10 Feb 2021 11:03:42 -0800 (PST)
Received: by mail-ej1-x630.google.com with SMTP id bl23so6090890ejb.5;
        Wed, 10 Feb 2021 11:03:42 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=e81CvUg/4FfNqpB+xmLqCh+M5NuNd+9zjlBJatgTsgU=;
        b=JJZSWl5aecXBhZZg2ZAZW21dhAW6274UxHjkx1q//J/VNrnKwmyCNDSr4mcQISH5Nx
         BPBl7WC2EvovjsMS1adKIV2q6QU7ZTvQpZJ36iHd4NT2vKL/iX8MxPBkLwV3EBRHTPlP
         7xPug+rQaRM3Ir5gh8hk2ATE4atqZpixWxphP0ivTTVraaVuem5QhjzJNi2ZKwqQwDiI
         U4cqZcEsiM5Gf5u61OQuO6OhDqwFI3MixVhwp/lS2htA+1OUCE50A9fk+lgldhjUfUEy
         zuPHRy0Kv4IIxJ0Rjzuzg7KpRt93bSJkLeksrTl4cDhnFmbgzVU0fFd75q/oQDjg3/+U
         +DdQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=e81CvUg/4FfNqpB+xmLqCh+M5NuNd+9zjlBJatgTsgU=;
        b=hHr7f06wwTIYr+jXPdv6EwTcJcI4aicTOYlbRQP1EhnN8HZQKkx1l8WFebrPW7TAIM
         vX7mHIzxs/d+OrOb5Tqzy0T+FpK39RT8CF1YWuJpHpDg8gFw96TtEYqY6yfy+DiyudaO
         bxJQ1bmowAo08IOlNWScMXa0MycDehcJJbJa8jDu+P2z8SodwBiHO0kbKZYsKQvtWbeY
         uRDNnLjwG1+nz6JDh2ZjUt57Uim2gI8NzFgIAKwKu+xgmSzPPKkZSTFObgoGP+wdrB37
         k2FkcDRR86/OsHziPSFhXgm9RcT9NqQsR2OaavJCPS8paYw3zGWZ1E4lR7hA0akNpk4+
         SUDA==
X-Gm-Message-State: AOAM533jJpbiMx0mX0cxrEvyJverM5t/BiS8kObDRKI2OxMdPXVSBbCT
        YZrT6DPbjEeGiuyGciVT9J8=
X-Google-Smtp-Source: ABdhPJw4uep2Czs9EWd+OZKQIymdZK7oxSYyeOkEtFro8b5GpK7kE/unfScCJx9QdMOwM918FxjcZA==
X-Received: by 2002:a17:906:798:: with SMTP id l24mr4491252ejc.92.1612983821605;
        Wed, 10 Feb 2021 11:03:41 -0800 (PST)
Received: from localhost.localdomain ([141.226.162.179])
        by smtp.gmail.com with ESMTPSA id m19sm1743617edq.81.2021.02.10.11.03.40
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 10 Feb 2021 11:03:41 -0800 (PST)
From:   Amir Goldstein <amir73il@gmail.com>
To:     Eryu Guan <guaneryu@gmail.com>
Cc:     Miklos Szeredi <miklos@szeredi.hu>,
        Icenowy Zheng <icenowy@aosc.io>,
        Chengguang Xu <cgxu519@mykernel.net>,
        linux-unionfs@vger.kernel.org, fstests@vger.kernel.org
Subject: [PATCH v2 3/5] src/t_immutable: Allow setting flags on existing files
Date:   Wed, 10 Feb 2021 21:03:32 +0200
Message-Id: <20210210190334.1212210-4-amir73il@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210210190334.1212210-1-amir73il@gmail.com>
References: <20210210190334.1212210-1-amir73il@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-unionfs.vger.kernel.org>
X-Mailing-List: linux-unionfs@vger.kernel.org

For overlayfs tests we need to be able to setflags on existing
(lower) files.

t_immutable -C test_dir

Creates the test area and sets flags, but it also allows setting flags
on an existing test area.

t_immutable -R test_dir

Removes the flags from existing test area, but does not remove the files
in the test area.

To setup a test area with file without flags, need to run the -C and -R
commands.

Signed-off-by: Amir Goldstein <amir73il@gmail.com>
---
 src/t_immutable.c | 30 ++++++++++++++++++++++++------
 1 file changed, 24 insertions(+), 6 deletions(-)

diff --git a/src/t_immutable.c b/src/t_immutable.c
index 7431e75d..0611e193 100644
--- a/src/t_immutable.c
+++ b/src/t_immutable.c
@@ -1898,6 +1898,8 @@ static int check_test_area(const char *dir)
      return 0;
 }
 
+static int allow_existing;
+
 static int create_dir(char **ppath, const char *fmt, const char *dir)
 {
      const char *path;
@@ -1908,6 +1910,9 @@ static int create_dir(char **ppath, const char *fmt, const char *dir)
      }
      path = *ppath;
      if (stat(path, &st) == 0) {
+	  if (allow_existing && S_ISDIR(st.st_mode)) {
+	       return 0;
+	  }
 	  fprintf(stderr, "%s: Test area directory %s must not exist for test area creation.\n",
 		  __progname, path);
 	  return 1;
@@ -1921,6 +1926,7 @@ static int create_dir(char **ppath, const char *fmt, const char *dir)
 
 static int create_file(char **ppath, const char *fmt, const char *dir)
 {
+     int flags = O_WRONLY|O_CREAT | (allow_existing ? 0 : O_EXCL);
      const char *path;
      int fd;
 
@@ -1928,7 +1934,7 @@ static int create_file(char **ppath, const char *fmt, const char *dir)
 	  return 1;
      }
      path = *ppath;
-     if ((fd = open(path, O_WRONLY|O_CREAT|O_EXCL, 0666)) == -1) {
+     if ((fd = open(path, flags, 0666)) == -1) {
 	  fprintf(stderr, "%s: error creating file %s: %s\n", __progname, path, strerror(errno));
           return 1;
      }
@@ -1937,13 +1943,15 @@ static int create_file(char **ppath, const char *fmt, const char *dir)
 
 static int create_xattrs(int fd)
 {
-     if (fsetxattr(fd, "trusted.test", "readonly", strlen("readonly"), XATTR_CREATE) != 0) {
+     int flags = allow_existing ? 0 : XATTR_CREATE;
+
+     if (fsetxattr(fd, "trusted.test", "readonly", strlen("readonly"), flags) != 0) {
 	  if (errno != EOPNOTSUPP) {
 	       perror("setxattr");
 	       return 1;
 	  }
      }
-     if (fsetxattr(fd, "user.test", "readonly", strlen("readonly"), XATTR_CREATE) != 0) {
+     if (fsetxattr(fd, "user.test", "readonly", strlen("readonly"), flags) != 0) {
 	  if (errno != EOPNOTSUPP) {
 	       perror("setxattr");
 	       return 1;
@@ -2214,6 +2222,10 @@ static int remove_test_area(const char *dir)
 	  return 1;
      }
 
+     if (allow_existing) {
+	     return 0;
+     }
+
      pid = fork();
      if (!pid) {
 	  execl("/bin/rm", "rm", "-rf", dir, NULL);
@@ -2236,7 +2248,7 @@ int main(int argc, char **argv)
 /* this arg parsing is gross, but who cares, its a test program */
 
      if (argc < 2) {
-	  fprintf(stderr, "usage: t_immutable [-C|-c|-r] test_area_dir\n");
+	  fprintf(stderr, "usage: t_immutable [-C|-c|-R|-r] test_area_dir\n");
 	  return 1;
      }
 
@@ -2246,18 +2258,24 @@ int main(int argc, char **argv)
 	  /* Prepare test area without running tests */
 	  create = 1;
 	  runtest = 0;
+	  /* With existing test area, only setflags */
+	  allow_existing = 1;
      } else if (!strcmp(argv[1], "-r")) {
 	  remove = 1;
+     } else if (!strcmp(argv[1], "-R")) {
+	  /* Cleanup flags on test area but leave the files */
+	  remove = 1;
+	  allow_existing = 1;
      }
 
      if (argc != 2 + (create | remove)) {
-	  fprintf(stderr, "usage: t_immutable [-C|-c|-r] test_area_dir\n");
+	  fprintf(stderr, "usage: t_immutable [-C|-c|-R|-r] test_area_dir\n");
 	  return 1;
      }
 
      if (create) {
 	  ret = create_test_area(argv[argc-1]);
-	  if (ret || !runtest) {
+	  if (ret || allow_existing || !runtest) {
                return ret;
 	  }
      } else if (remove) {
-- 
2.25.1

