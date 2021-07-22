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
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8E045C6377D
	for <linux-unionfs@archiver.kernel.org>; Thu, 22 Jul 2021 17:02:24 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 6D88C61241
	for <linux-unionfs@archiver.kernel.org>; Thu, 22 Jul 2021 17:02:24 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233809AbhGVQVt (ORCPT
        <rfc822;linux-unionfs@archiver.kernel.org>);
        Thu, 22 Jul 2021 12:21:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52966 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232978AbhGVQVq (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Thu, 22 Jul 2021 12:21:46 -0400
Received: from mail-wr1-x431.google.com (mail-wr1-x431.google.com [IPv6:2a00:1450:4864:20::431])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6B27EC061575;
        Thu, 22 Jul 2021 10:02:20 -0700 (PDT)
Received: by mail-wr1-x431.google.com with SMTP id c15so6685366wrs.5;
        Thu, 22 Jul 2021 10:02:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=bPM5CdkPkPLqyCsiLD0jWGYT0lXbzICDkXV9Taq+dKw=;
        b=ZahsXDZm7KGlL/HHmT2ADNHLvHQP+1kACtlpteP5PEp5OuBuVZwqztPed5pPF0J+O9
         6D80Repuy01rBzdFLgVrhU9E6mGWSrNdZH6f7OATUS6eG4RafSvBJ5nDjqZAJev+115K
         p5n06tJtyqFQF89H8MIM1zfWY97p8oq7CEx4ckemF96KAmkIWEI/pDdrbIKI0gs/PYqV
         X8kYMM708CRjn7I4RfzYM2n3EdWn57c1Rbkw2Q4UVQDMLP6RWX6kGJvH6FIN/VZwT0m6
         ZIIVoEzh9WfhKB6cbWG+PpPMWtouWdQqTusR0ZJsk2RBR2tAufr9lN/sUvgyVsaLTX6J
         f9ug==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=bPM5CdkPkPLqyCsiLD0jWGYT0lXbzICDkXV9Taq+dKw=;
        b=dkAJfJFFksbxNWIptMMdo/UKi/AbVY1dDw+xqOmItfcSME2AAEA+xo8LAQ5O2VzJ0c
         XY5sfEWjX0Xvq++vX4mnAqyLj8ohioULeImBd1eUaDoROlchzVID7VPbxypO33bHcV/4
         q/B7wZgow13iSAeXx02yb3umNIC55JYybfizu0YgdzPtQofhWRaOHXXpMZCb0x17r4Sv
         eJ6bSNgd1sE+cgZ2N+peWx2SViManCKBDpaSDigP6JO6uTvABFCxpyptGjQLLvS+1XLT
         nb2v7g8UT52Y4RHyrAZavdsdXmZHVnInsXp46IrPAsfYVxyS+byT264cqaeQh7TefkwZ
         CBcQ==
X-Gm-Message-State: AOAM530d6whJPq2QgWxOjbNWWnGWPO8uwNQI9cBEXxB8r0jWj0BlCewP
        12ZfKQ16o3WrG4iyBu4p/m0=
X-Google-Smtp-Source: ABdhPJwQNUENRWBTfHfFQNhSOAvL3Y5KxJ1mKX0aM1zgVRe8wfyHWChQVh8GrzgreQUesNAwedcEmw==
X-Received: by 2002:adf:f9d0:: with SMTP id w16mr971077wrr.88.1626973339036;
        Thu, 22 Jul 2021 10:02:19 -0700 (PDT)
Received: from localhost.localdomain ([82.114.44.223])
        by smtp.gmail.com with ESMTPSA id n11sm3416710wms.0.2021.07.22.10.02.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 22 Jul 2021 10:02:18 -0700 (PDT)
From:   Amir Goldstein <amir73il@gmail.com>
To:     Eryu Guan <guaneryu@gmail.com>
Cc:     Miklos Szeredi <miklos@szeredi.hu>, linux-unionfs@vger.kernel.org,
        fstests@vger.kernel.org
Subject: [PATCH] overlay/077: check for inconsistent d_ino/st_ino
Date:   Thu, 22 Jul 2021 20:02:16 +0300
Message-Id: <20210722170216.424666-1-amir73il@gmail.com>
X-Mailer: git-send-email 2.32.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-unionfs.vger.kernel.org>
X-Mailing-List: linux-unionfs@vger.kernel.org

After unlink of a directory entry, that entry may still apear in getdents
results of an already open directory fd, but it should return a d_ino
value that is consistent with the already observed st_ino of that entry.

Remove redundant break condition from gendents read loop.

For testing of inconsistent d_ino/st_ino we need to unlink an entry
whose st_ino is not that of the upper inode.

In the former merge dir setup we unlink all the files in the lower
dir after copyup, so they all use st_ino of the upper inode.

Let the unlinked file f100 reside in a lower path that is not being
unlinked so it will have the st_ino of the lower inode.

This is a regression test for kernel commit fcb7f373684d
("ovl: skip stale entries in merge dir cache iteration")

Signed-off-by: Amir Goldstein <amir73il@gmail.com>
---

Eryu,

This increases the test coverage of overlay/077 to detect another
overlay readdir issue that is fixed in current overlayfs-next.

Thanks,
Amir.

 src/t_dir_offset2.c | 18 ++++++++++++------
 tests/overlay/077   |  5 +++--
 2 files changed, 15 insertions(+), 8 deletions(-)

diff --git a/src/t_dir_offset2.c b/src/t_dir_offset2.c
index 75b41c1a..026bc8f3 100644
--- a/src/t_dir_offset2.c
+++ b/src/t_dir_offset2.c
@@ -44,6 +44,7 @@ int main(int argc, char *argv[])
 	char buf[BUF_SIZE];
 	int nread, bufsize = BUF_SIZE;
 	struct linux_dirent64 *d;
+	struct stat st = {};
 	int bpos, total, i;
 	off_t lret;
 	int retval = EXIT_SUCCESS;
@@ -81,9 +82,9 @@ int main(int argc, char *argv[])
 	}
 
 	if (filename) {
-		exists = !faccessat(fd, filename, F_OK, AT_SYMLINK_NOFOLLOW);
+		exists = !fstatat(fd, filename, &st, AT_SYMLINK_NOFOLLOW);
 		if (!exists && errno != ENOENT) {
-			perror("faccessat");
+			perror("fstatat");
 			exit(EXIT_FAILURE);
 		}
 	}
@@ -139,9 +140,6 @@ int main(int argc, char *argv[])
 			continue;
 		}
 
-		if (nread == 0)
-			break;
-
 		for (bpos = 0; bpos < nread; total++) {
 			d = (struct linux_dirent64 *) (buf + bpos);
 
@@ -165,8 +163,16 @@ int main(int argc, char *argv[])
 					printf("entry #%d: %s (d_ino=%lld, d_off=%lld)\n",
 					       i, d->d_name, (long long int)d->d_ino,
 					       (long long int)d->d_off);
-				if (!strcmp(filename, d->d_name))
+				if (!strcmp(filename, d->d_name)) {
 					found = 1;
+					if (st.st_ino && d->d_ino != st.st_ino) {
+						fprintf(stderr, "entry %s has inconsistent d_ino (%lld != %lld)\n",
+								filename,
+								(long long int)d->d_ino,
+								(long long int)st.st_ino);
+					}
+				}
+
 			}
 			bpos += d->d_reclen;
 		}
diff --git a/tests/overlay/077 b/tests/overlay/077
index 6510f81f..49dc8144 100755
--- a/tests/overlay/077
+++ b/tests/overlay/077
@@ -46,8 +46,8 @@ mkdir -p $lowerdir/merge $lowerdir/former $upperdir/pure $upperdir/impure
 create_files $lowerdir/merge m
 # Files to be moved into impure upper dir
 create_files $lowerdir o
-# File to be copied up to make former merge dir impure
-touch $lowerdir/former/f100
+# File to be moved into former merge dir to make it impure
+touch $lowerdir/f100
 
 _scratch_mount
 
@@ -57,6 +57,7 @@ create_files $SCRATCH_MNT/former f
 touch $SCRATCH_MNT/merge/m100
 # Move copied up files so readdir will need to lookup origin d_ino
 mv $SCRATCH_MNT/o* $SCRATCH_MNT/impure/
+mv $SCRATCH_MNT/f100 $SCRATCH_MNT/former/
 
 # Remove the lower directory and mount overlay again to create
 # a "former merge dir"
-- 
2.32.0

