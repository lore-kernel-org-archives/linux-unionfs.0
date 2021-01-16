Return-Path: <linux-unionfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BA1BAC433DB
	for <linux-unionfs@archiver.kernel.org>; Sat, 16 Jan 2021 17:07:12 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 89B6922A99
	for <linux-unionfs@archiver.kernel.org>; Sat, 16 Jan 2021 17:07:12 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726785AbhAPRHH (ORCPT
        <rfc822;linux-unionfs@archiver.kernel.org>);
        Sat, 16 Jan 2021 12:07:07 -0500
Received: from mail-ej1-f52.google.com ([209.85.218.52]:42968 "EHLO
        mail-ej1-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727898AbhAPRGu (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Sat, 16 Jan 2021 12:06:50 -0500
Received: by mail-ej1-f52.google.com with SMTP id r12so6420815ejb.9;
        Sat, 16 Jan 2021 09:06:34 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=f1/Piw45BGbvrGj/usOEnL03jLiIpZV3qUgR6D6ISU4=;
        b=PT7/sdoOVEcUwjMhV6ajiRNgPe/lCst2tYkK6pkUhea0W8aH+mITsxze3Zw3yzRvAF
         ONKnHmAf+3ykHqTzEUnlmsAGuivE10MsG2Q5FL5/ACwnZ6y9a8qZAMtxaYsuizxJcayF
         tGZr/2wCtp++aDxYEW9vRzjv+dTmpbTJvpGaYK4JKg0TeEKzxG9MyXU3UiD78EMUB/Ad
         msCnQx3rUJHG9XZEdVoDKOVad86WU1v0l11mfJzw/ElP8fN4yDHStIFxs0Jvf8UOjU+L
         LakOvIfXJISahQweLZLX9VOTCHg0bzpORsFOSw4JC9uxfEd0T8tE91iN0z5PliogG+WA
         foSQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=f1/Piw45BGbvrGj/usOEnL03jLiIpZV3qUgR6D6ISU4=;
        b=YQDxRzG30HoQGqBuKNsVOO6zNJMZ1Tl/ZhPSsfaO5m+qs4Yg67UxzSE5TxIWbX8Ju4
         c45oGnlhAeel9Ty0RVjgMGuU1WWYl9Mjss7qAAQ8rJdVTTmPEBktxxV8wx90rY16W6CS
         3rL0fzKyU8giOcexT9ltnMh1V92IPqjw8HJjIJwfaiF3/1G7mHDpxrjixaTkAU/ew0gw
         jYxnb3DPCkZltlvStXByzIkpjJGUoLHC/NiaEeXZIg7gFjth4xZK5cfiAxGs/VntDCDY
         Fr4I+49RHzoh0MmItFue2IoKqhOREZdTfKRAqdXcG0PMyQu3T4ZP6DP3sWTQ3Iudxxa9
         cVNg==
X-Gm-Message-State: AOAM531bKTn53i++lFh2WLcYX2ITv9OaTNNNMviL8NDup+tY11NN7pUz
        54LOCz7Ojcym+fVNA/wwXArOXfkHmVo=
X-Google-Smtp-Source: ABdhPJx3cdhgtX9ufv3PK4FCWEFG4ia55xeGf1EThJ+Bgi+gZ1wqoe0OOMgI6CkKnGai3TpJ5rtHPg==
X-Received: by 2002:a17:906:660b:: with SMTP id b11mr13584345ejp.458.1610816188073;
        Sat, 16 Jan 2021 08:56:28 -0800 (PST)
Received: from localhost.localdomain ([31.210.181.203])
        by smtp.gmail.com with ESMTPSA id zn8sm7061063ejb.39.2021.01.16.08.56.26
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 16 Jan 2021 08:56:27 -0800 (PST)
From:   Amir Goldstein <amir73il@gmail.com>
To:     Eryu Guan <guaneryu@gmail.com>
Cc:     Icenowy Zheng <icenowy@aosc.io>,
        Chengguang Xu <cgxu519@mykernel.net>,
        Xiao Yang <yangx.jy@cn.fujitsu.com>,
        Miklos Szeredi <miklos@szeredi.hu>,
        linux-unionfs@vger.kernel.org, fstests@vger.kernel.org
Subject: [PATCH 3/4] src/t_immutable: Allow setting flags on existing files
Date:   Sat, 16 Jan 2021 18:56:18 +0200
Message-Id: <20210116165619.494265-4-amir73il@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210116165619.494265-1-amir73il@gmail.com>
References: <20210116165619.494265-1-amir73il@gmail.com>
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
index b6a76af0..a2e6796d 100644
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
 	  return -1;
      }
      path = *ppath;
-     if ((fd = open(path, O_WRONLY|O_CREAT|O_EXCL, 0666)) == -1) {
+     if ((fd = open(path, flags, 0666)) == -1) {
 	  fprintf(stderr, "%s: error creating file %s: %s\n", __progname, path, strerror(errno));
           return -1;
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
+	  if (ret || allow_existing) {
                return ret;
 	  }
      } else if (remove) {
-- 
2.25.1

