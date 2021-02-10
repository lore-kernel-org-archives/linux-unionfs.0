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
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3B40BC4332D
	for <linux-unionfs@archiver.kernel.org>; Wed, 10 Feb 2021 19:05:01 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 025C664E76
	for <linux-unionfs@archiver.kernel.org>; Wed, 10 Feb 2021 19:05:00 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233668AbhBJTEu (ORCPT
        <rfc822;linux-unionfs@archiver.kernel.org>);
        Wed, 10 Feb 2021 14:04:50 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44232 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233955AbhBJTE0 (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Wed, 10 Feb 2021 14:04:26 -0500
Received: from mail-ej1-x632.google.com (mail-ej1-x632.google.com [IPv6:2a00:1450:4864:20::632])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6ADA9C061756;
        Wed, 10 Feb 2021 11:03:41 -0800 (PST)
Received: by mail-ej1-x632.google.com with SMTP id hs11so6126782ejc.1;
        Wed, 10 Feb 2021 11:03:41 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=VS579JX6uwPGrlRUjBif6vX6YNZ7KhH/hJO4KN155Jc=;
        b=JJl4vYE8oUKjEOV11FGzoO/L3Drvvdh6CDJwi2LcFkxE8mgSlCCxJfCm44djdyZlFY
         PWq1BaZT0uKzysVrjbEHcx5IYyJQX+M8CAY8uf0H3riKZFjxmwhH52Q/Oa+ymQN1Gqyk
         X2qkXyee9NfCU5s4lVLbKHHRV0rt+suHfzdk2gb+TtFJEvxuNSiNnJ0S+m7as6f8YqZf
         B8AU8K2Y9WGD2Ih2xkq5+mIlpwCBFpTZnHG96Ex+KrNt4KgpnmTmItlqflrVefq/J2Fn
         vUpOVmUMFaW+Ke3eQyJqhBH6CdcHqtK5/Q7nkX7Nx/8JzV12Le/b8tuYVe3VhfyBeJ0d
         uypQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=VS579JX6uwPGrlRUjBif6vX6YNZ7KhH/hJO4KN155Jc=;
        b=gvrALDSwFsU4tu8n01F7V33aJtWVOCoM1zu24g38a1BfLWbSMX5ZMnHhemsprreCxx
         5ZIBQlWrzT5Mrd41AZQtpguoAZ+yevLfhV+/BpCbeZKcWYqPVXLFqw3AEXYtvsBJuHDC
         j2qpGWPdyMPZriszSAPAk7DHBedKb8olb/NdiP7YincHt2TiwDVOTUogwQpv0LoT744y
         /Ta/Tc1A0jJm96C+r6LSV40AXts+2KCAzOZOMWLM46Rzm5MOGWO72ViVjeQuQ2YOqlCg
         fuUs247W4fuBatuPIMMJ6zSdZLQ6sYsm1/TXI6Ss2C+Il5CDjasrsuIYV+ERRrl512oa
         rEQA==
X-Gm-Message-State: AOAM5303Bh63suxNTA5MKy4tS4V+o/q7ZCXcmz9Dnr6U4/Zo1CfkU4vR
        A0B4gZVS4wuAxzuvtBDViVNEKAJiOjE=
X-Google-Smtp-Source: ABdhPJxmXmTrx/FoPuCntGkElbgpcIvGVea9eKpepHEsF/pdsAufw69tcc16fBteyspHrIFOez9eiQ==
X-Received: by 2002:a17:906:15ca:: with SMTP id l10mr4271971ejd.402.1612983820152;
        Wed, 10 Feb 2021 11:03:40 -0800 (PST)
Received: from localhost.localdomain ([141.226.162.179])
        by smtp.gmail.com with ESMTPSA id m19sm1743617edq.81.2021.02.10.11.03.38
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 10 Feb 2021 11:03:39 -0800 (PST)
From:   Amir Goldstein <amir73il@gmail.com>
To:     Eryu Guan <guaneryu@gmail.com>
Cc:     Miklos Szeredi <miklos@szeredi.hu>,
        Icenowy Zheng <icenowy@aosc.io>,
        Chengguang Xu <cgxu519@mykernel.net>,
        linux-unionfs@vger.kernel.org, fstests@vger.kernel.org
Subject: [PATCH v2 2/5] src/t_immutable: factor out some helpers
Date:   Wed, 10 Feb 2021 21:03:31 +0200
Message-Id: <20210210190334.1212210-3-amir73il@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210210190334.1212210-1-amir73il@gmail.com>
References: <20210210190334.1212210-1-amir73il@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-unionfs.vger.kernel.org>
X-Mailing-List: linux-unionfs@vger.kernel.org

Reduce boilerplate code.
define _GNU_SOURCE needed for asprintf.

Signed-off-by: Amir Goldstein <amir73il@gmail.com>
---
 src/t_immutable.c | 221 ++++++++++++++++++++++------------------------
 1 file changed, 104 insertions(+), 117 deletions(-)

diff --git a/src/t_immutable.c b/src/t_immutable.c
index 86c567ed..7431e75d 100644
--- a/src/t_immutable.c
+++ b/src/t_immutable.c
@@ -8,6 +8,9 @@
 
 #define TEST_UTIME
 
+#ifndef _GNU_SOURCE
+#define _GNU_SOURCE
+#endif
 #include <stdio.h>
 #include <stdlib.h>
 #include <string.h>
@@ -1895,13 +1898,66 @@ static int check_test_area(const char *dir)
      return 0;
 }
 
+static int create_dir(char **ppath, const char *fmt, const char *dir)
+{
+     const char *path;
+     struct stat st;
+
+     if (asprintf(ppath, fmt, dir) == -1) {
+	  return 1;
+     }
+     path = *ppath;
+     if (stat(path, &st) == 0) {
+	  fprintf(stderr, "%s: Test area directory %s must not exist for test area creation.\n",
+		  __progname, path);
+	  return 1;
+     }
+     if (mkdir(path, 0777) != 0) {
+	  fprintf(stderr, "%s: error creating directory %s: %s\n", __progname, path, strerror(errno));
+	  return 1;
+     }
+     return 0;
+}
+
+static int create_file(char **ppath, const char *fmt, const char *dir)
+{
+     const char *path;
+     int fd;
+
+     if (asprintf(ppath, fmt, dir) == -1) {
+	  return 1;
+     }
+     path = *ppath;
+     if ((fd = open(path, O_WRONLY|O_CREAT|O_EXCL, 0666)) == -1) {
+	  fprintf(stderr, "%s: error creating file %s: %s\n", __progname, path, strerror(errno));
+          return 1;
+     }
+     return fd;
+}
+
+static int create_xattrs(int fd)
+{
+     if (fsetxattr(fd, "trusted.test", "readonly", strlen("readonly"), XATTR_CREATE) != 0) {
+	  if (errno != EOPNOTSUPP) {
+	       perror("setxattr");
+	       return 1;
+	  }
+     }
+     if (fsetxattr(fd, "user.test", "readonly", strlen("readonly"), XATTR_CREATE) != 0) {
+	  if (errno != EOPNOTSUPP) {
+	       perror("setxattr");
+	       return 1;
+	  }
+     }
+     return 0;
+}
+
 static int create_test_area(const char *dir)
 {
      int fd;
      char *path;
      static const char *acl_u_text = "u::rw-,g::rw-,o::rw-,u:nobody:rw-,m::rw-";
      static const char *acl_u_text_d = "u::rwx,g::rwx,o::rwx,u:nobody:rwx,m::rwx";
-     struct stat st;
      static const char *immutable = "This is an immutable file.\nIts contents cannot be altered.\n";
      static const char *append_only = "This is an append-only file.\nIts contents cannot be altered.\n"
 	  "Data can only be appended.\n---\n";
@@ -1911,79 +1967,45 @@ static int create_test_area(const char *dir)
 	  return 1;
      }
 
-     if (stat(dir, &st) == 0) {
-	  fprintf(stderr, "%s: Test area directory %s must not exist for test area creation.\n",
-		  __progname, dir);
-	  return 1;
-     }
-
      umask(0000);
-     if (mkdir(dir, 0777) != 0) {
-	  fprintf(stderr, "%s: error creating directory %s: %s\n", __progname, dir, strerror(errno));
+     if (create_dir(&path, "%s", dir)) {
 	  return 1;
      }
-
-     asprintf(&path, "%s/immutable.d", dir);
-     if (mkdir(path, 0777) != 0) {
-          fprintf(stderr, "%s: error creating directory %s: %s\n", __progname, path, strerror(errno));
-          return 1;
-     }
-     free(path);
-
-     asprintf(&path, "%s/empty-immutable.d", dir);
-     if (mkdir(path, 0777) != 0) {
-          fprintf(stderr, "%s: error creating directory %s: %s\n", __progname, path, strerror(errno));
-          return 1;
-     }
      free(path);
 
-     asprintf(&path, "%s/append-only.d", dir);
-     if (mkdir(path, 0777) != 0) {
-          fprintf(stderr, "%s: error creating directory %s: %s\n", __progname, path, strerror(errno));
-          return 1;
+     if (create_dir(&path, "%s/append-only.d", dir)) {
+	  return 1;
      }
      free(path);
 
-     asprintf(&path, "%s/empty-append-only.d", dir);
-     if (mkdir(path, 0777) != 0) {
-          fprintf(stderr, "%s: error creating directory %s: %s\n", __progname, path, strerror(errno));
-          return 1;
+     if (create_dir(&path, "%s/append-only.d/dir", dir)) {
+	  return 1;
      }
      free(path);
 
-     asprintf(&path, "%s/immutable.d/dir", dir);
-     if (mkdir(path, 0777) != 0) {
-          fprintf(stderr, "%s: error creating directory %s: %s\n", __progname, path, strerror(errno));
+     if ((fd = create_file(&path, "%s/append-only.d/file", dir)) == -1) {
           return 1;
      }
+     close(fd);
      free(path);
 
-     asprintf(&path, "%s/append-only.d/dir", dir);
-     if (mkdir(path, 0777) != 0) {
-          fprintf(stderr, "%s: error creating directory %s: %s\n", __progname, path, strerror(errno));
-          return 1;
+     if (create_dir(&path, "%s/immutable.d", dir)) {
+	  return 1;
      }
      free(path);
 
-     asprintf(&path, "%s/append-only.d/file", dir);
-     if ((fd = open(path, O_WRONLY|O_CREAT|O_EXCL, 0666)) == -1) {
-	  fprintf(stderr, "%s: error creating file %s: %s\n", __progname, path, strerror(errno));
-          return 1;
+     if (create_dir(&path, "%s/immutable.d/dir", dir)) {
+	  return 1;
      }
-     close(fd);
      free(path);
 
-     asprintf(&path, "%s/immutable.d/file", dir);
-     if ((fd = open(path, O_WRONLY|O_CREAT|O_EXCL, 0666)) == -1) {
-          fprintf(stderr, "%s: error creating file %s: %s\n", __progname, path, strerror(errno));
+     if ((fd = create_file(&path, "%s/immutable.d/file", dir)) == -1) {
           return 1;
      }
      close(fd);
      free(path);
 
-     asprintf(&path, "%s/immutable.f", dir);
-     if ((fd = open(path, O_WRONLY|O_CREAT|O_EXCL, 0666)) == -1) {
-          fprintf(stderr, "%s: error creating file %s: %s\n", __progname, path, strerror(errno));
+     if ((fd = create_file(&path, "%s/immutable.f", dir)) == -1) {
           return 1;
      }
      if (write(fd, immutable, strlen(immutable)) != strlen(immutable)) {
@@ -1994,17 +2016,8 @@ static int create_test_area(const char *dir)
 	  perror("acl");
 	  return 1;
      }
-     if (fsetxattr(fd, "trusted.test", "readonly", strlen("readonly"), XATTR_CREATE) != 0) {
-	  if (errno != EOPNOTSUPP) {
-	       perror("setxattr");
-	       return 1;
-	  }
-     }
-     if (fsetxattr(fd, "user.test", "readonly", strlen("readonly"), XATTR_CREATE) != 0) {
-	  if (errno != EOPNOTSUPP) {
-	       perror("setxattr");
-	       return 1;
-	  }
+     if (create_xattrs(fd)) {
+	  return 1;
      }
      if (fsetflag(path, fd, 1, 1)) {
           perror("fsetflag");
@@ -2014,8 +2027,7 @@ static int create_test_area(const char *dir)
      close(fd);
      free(path);
 
-     asprintf(&path, "%s/append-only.f", dir);
-     if ((fd = open(path, O_WRONLY|O_CREAT|O_EXCL, 0666)) == -1) {
+     if ((fd = create_file(&path, "%s/append-only.f", dir)) == -1) {
           fprintf(stderr, "%s: error creating file %s: %s\n", __progname, path, strerror(errno));
           return 1;
      }
@@ -2027,17 +2039,8 @@ static int create_test_area(const char *dir)
           perror("acl");
           return 1;
      }
-     if (fsetxattr(fd, "trusted.test", "readonly", strlen("readonly"), XATTR_CREATE) != 0) {
-	  if (errno != EOPNOTSUPP) {
-	       perror("setxattr");
-	       return 1;
-	  }
-     }
-     if (fsetxattr(fd, "user.test", "readonly", strlen("readonly"), XATTR_CREATE) != 0) {
-	  if (errno != EOPNOTSUPP) {
-	       perror("setxattr");
-	       return 1;
-	  }
+     if (create_xattrs(fd)) {
+	  return 1;
      }
      if (fsetflag(path, fd, 1, 0)) {
           perror("fsetflag");
@@ -2056,17 +2059,8 @@ static int create_test_area(const char *dir)
           perror("acl");
           return 1;
      }
-     if (fsetxattr(fd, "trusted.test", "readonly", strlen("readonly"), XATTR_CREATE) != 0) {
-	  if (errno != EOPNOTSUPP) {
-	       perror("setxattr");
-	       return 1;
-	  }
-     }
-     if (fsetxattr(fd, "user.test", "readonly", strlen("readonly"), XATTR_CREATE) != 0) {
-	  if (errno != EOPNOTSUPP) {
-	       perror("setxattr");
-	       return 1;
-	  }
+     if (create_xattrs(fd)) {
+	  return 1;
      }
      if (fsetflag(path, fd, 1, 1)) {
           perror("fsetflag");
@@ -2076,7 +2070,9 @@ static int create_test_area(const char *dir)
      close(fd);
      free(path);
 
-     asprintf(&path, "%s/empty-immutable.d", dir);
+     if (create_dir(&path, "%s/empty-immutable.d", dir)) {
+	  return 1;
+     }
      if ((fd = open(path, O_RDONLY)) == -1) {
           fprintf(stderr, "%s: error opening %s: %s\n", __progname, path, strerror(errno));
           return 1;
@@ -2098,17 +2094,8 @@ static int create_test_area(const char *dir)
           perror("acl");
           return 1;
      }
-     if (fsetxattr(fd, "trusted.test", "readonly", strlen("readonly"), XATTR_CREATE) != 0) {
-	  if (errno != EOPNOTSUPP) {
-	       perror("setxattr");
-	       return 1;
-	  }
-     }
-     if (fsetxattr(fd, "user.test", "readonly", strlen("readonly"), XATTR_CREATE) != 0) {
-	  if (errno != EOPNOTSUPP) {
-	       perror("setxattr");
-	       return 1;
-	  }
+     if (create_xattrs(fd)) {
+	  return 1;
      }
      if (fsetflag(path, fd, 1, 0)) {
           perror("fsetflag");
@@ -2118,7 +2105,9 @@ static int create_test_area(const char *dir)
      close(fd);
      free(path);
 
-     asprintf(&path, "%s/empty-append-only.d", dir);
+     if (create_dir(&path, "%s/empty-append-only.d", dir)) {
+	  return 1;
+     }
      if ((fd = open(path, O_RDONLY)) == -1) {
           fprintf(stderr, "%s: error opening %s: %s\n", __progname, path, strerror(errno));
           return 1;
@@ -2242,6 +2231,7 @@ int main(int argc, char **argv)
 {
      int ret;
      int failed = 0;
+     int runtest = 1, create = 0, remove = 0;
 
 /* this arg parsing is gross, but who cares, its a test program */
 
@@ -2251,32 +2241,29 @@ int main(int argc, char **argv)
      }
 
      if (!strcmp(argv[1], "-c")) {
-	  if (argc == 3) {
-	       if ((ret = create_test_area(argv[argc-1])))
-		    return ret;
-	  } else {
-	       fprintf(stderr, "usage: t_immutable -c test_area_dir\n");
-	       return 1;
-	  }
+	  create = 1;
      } else if (!strcmp(argv[1], "-C")) {
-          if (argc == 3) {
-               return create_test_area(argv[argc-1]);
-          } else {
-               fprintf(stderr, "usage: t_immutable -C test_area_dir\n");
-               return 1;
-          }
+	  /* Prepare test area without running tests */
+	  create = 1;
+	  runtest = 0;
      } else if (!strcmp(argv[1], "-r")) {
-	  if (argc == 3)
-	       return remove_test_area(argv[argc-1]);
-	  else {
-	       fprintf(stderr, "usage: t_immutable -r test_area_dir\n");
-	       return 1;
-	  }
-     } else if (argc != 2) {
-	  fprintf(stderr, "usage: t_immutable [-c|-r] test_area_dir\n");
+	  remove = 1;
+     }
+
+     if (argc != 2 + (create | remove)) {
+	  fprintf(stderr, "usage: t_immutable [-C|-c|-r] test_area_dir\n");
 	  return 1;
      }
 
+     if (create) {
+	  ret = create_test_area(argv[argc-1]);
+	  if (ret || !runtest) {
+               return ret;
+	  }
+     } else if (remove) {
+	  return remove_test_area(argv[argc-1]);
+     }
+
      umask(0000);
 
      if (check_test_area(argv[argc-1]))
-- 
2.25.1

