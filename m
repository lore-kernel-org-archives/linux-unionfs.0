Return-Path: <SRS0=xMZa=52=vger.kernel.org=linux-unionfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.6 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D1F73C2BBFD
	for <linux-unionfs@archiver.kernel.org>; Fri, 10 Apr 2020 08:34:18 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 32E97218AC
	for <linux-unionfs@archiver.kernel.org>; Fri, 10 Apr 2020 08:25:49 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="P53BQzQY"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725912AbgDJIZs (ORCPT
        <rfc822;linux-unionfs@archiver.kernel.org>);
        Fri, 10 Apr 2020 04:25:48 -0400
Received: from mail-wr1-f67.google.com ([209.85.221.67]:36360 "EHLO
        mail-wr1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725858AbgDJIZr (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Fri, 10 Apr 2020 04:25:47 -0400
Received: by mail-wr1-f67.google.com with SMTP id u13so998455wrp.3
        for <linux-unionfs@vger.kernel.org>; Fri, 10 Apr 2020 01:25:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=1XGmJomvW9JjPrEsV8CRBwFKgJMNq2h+55QpbqT6KHM=;
        b=P53BQzQYd6g0Vpb0I/zgOZD9SRrr4konLA7ZQ8NE/v3CIiICCwVgrZmxRKqBMrAW2P
         wU9EcjsKSjQjtNHbX5tnStHYXbHbaWIeCChmMuk/xpVIa9PAe7aR5Q8eoNquhtGyfR8I
         x8gWii+YFcUPNIEFvmfmy35foyL/wVX/kID4/6kRECupSTy6DYOqJz+LuBMb3ZKePeXk
         NxxnLBlLMWMKmt4DDuvbzz0WV1pBRahc0fh7JWuBdqsCrAhzrHY36OFABpNY6Wvdas33
         22GZncj2MNwSrjtvl251ApacvYSfOvVh0whH/ZcvpXrWWl1wVwf8XCxr9V8S47e0IOxL
         2zhA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=1XGmJomvW9JjPrEsV8CRBwFKgJMNq2h+55QpbqT6KHM=;
        b=cFl8emLPpIr0pMl7g1Ok0/SRjGEyqEAnoBmBe8SPdbPXuSL//eDztqA5dBvHg9OIwF
         Pwi7cVa8u7SCY8X0NApmCRJOe3XuNt/gT+uV9z31Eofd/oZs6f6KAo7HHuBWV8Gch1cm
         idob7grvtSMj7K1ErjnGIV4JzNsxeZrf9JgSerAsriXt9SYeHAkKQ4CLygbE5B5y91bI
         R0EnXtAXROAe2Y8kIaxwilDdgGJrZJuqNaaLQh/aIqhto6x7o5vu2he7YPtStupcbRbo
         G6w7RJ+wt+7AGnWVBROywqYoZ0Z7wb8k92vs24nnhXrz09CIJ2X+RaR++oy+xGo6upO2
         Mv9w==
X-Gm-Message-State: AGi0PuZaUMqIAcXU/ZyA2ElkQ5rfXUeiBuIzsyHcCNNENuuKE84y6b8q
        sqFGJRoxic45jn4dcyc8pjsHeXcM
X-Google-Smtp-Source: APiQypKmQIM+G4v8uz4fDzIFS7mKprLBv4NdkOnM81uSUOUbn3EValXLxNieCWX3FKxi4K/aurbUMg==
X-Received: by 2002:a5d:694a:: with SMTP id r10mr3455247wrw.228.1586507147327;
        Fri, 10 Apr 2020 01:25:47 -0700 (PDT)
Received: from localhost.localdomain ([141.226.12.123])
        by smtp.gmail.com with ESMTPSA id b7sm1710327wrn.67.2020.04.10.01.25.46
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 10 Apr 2020 01:25:46 -0700 (PDT)
From:   Amir Goldstein <amir73il@gmail.com>
To:     Miklos Szeredi <miklos@szeredi.hu>
Cc:     Chengguang Xu <cgxu519@mykernel.net>, linux-unionfs@vger.kernel.org
Subject: [PATCH 1/3] ovl: cleanup non-empty directories in ovl_indexdir_cleanup()
Date:   Fri, 10 Apr 2020 11:25:37 +0300
Message-Id: <20200410082539.23627-2-amir73il@gmail.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200410082539.23627-1-amir73il@gmail.com>
References: <20200410082539.23627-1-amir73il@gmail.com>
Sender: linux-unionfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-unionfs.vger.kernel.org>
X-Mailing-List: linux-unionfs@vger.kernel.org

Teach ovl_indexdir_cleanup() to remove temp directories containing
whiteouts to prepare for using index dir instead of work dir for
removing merge directories.

Signed-off-by: Amir Goldstein <amir73il@gmail.com>
---
 fs/overlayfs/overlayfs.h |  4 ++--
 fs/overlayfs/readdir.c   | 13 +++++++------
 2 files changed, 9 insertions(+), 8 deletions(-)

diff --git a/fs/overlayfs/overlayfs.h b/fs/overlayfs/overlayfs.h
index e6f3670146ed..e00b1ff6dea9 100644
--- a/fs/overlayfs/overlayfs.h
+++ b/fs/overlayfs/overlayfs.h
@@ -394,8 +394,8 @@ void ovl_cleanup_whiteouts(struct dentry *upper, struct list_head *list);
 void ovl_cache_free(struct list_head *list);
 void ovl_dir_cache_free(struct inode *inode);
 int ovl_check_d_type_supported(struct path *realpath);
-void ovl_workdir_cleanup(struct inode *dir, struct vfsmount *mnt,
-			 struct dentry *dentry, int level);
+int ovl_workdir_cleanup(struct inode *dir, struct vfsmount *mnt,
+			struct dentry *dentry, int level);
 int ovl_indexdir_cleanup(struct ovl_fs *ofs);
 
 /* inode.c */
diff --git a/fs/overlayfs/readdir.c b/fs/overlayfs/readdir.c
index e452ff7d583d..d6b601caf122 100644
--- a/fs/overlayfs/readdir.c
+++ b/fs/overlayfs/readdir.c
@@ -1071,14 +1071,13 @@ static void ovl_workdir_cleanup_recurse(struct path *path, int level)
 	ovl_cache_free(&list);
 }
 
-void ovl_workdir_cleanup(struct inode *dir, struct vfsmount *mnt,
+int ovl_workdir_cleanup(struct inode *dir, struct vfsmount *mnt,
 			 struct dentry *dentry, int level)
 {
 	int err;
 
 	if (!d_is_dir(dentry) || level > 1) {
-		ovl_cleanup(dir, dentry);
-		return;
+		return ovl_cleanup(dir, dentry);
 	}
 
 	err = ovl_do_rmdir(dir, dentry);
@@ -1088,8 +1087,10 @@ void ovl_workdir_cleanup(struct inode *dir, struct vfsmount *mnt,
 		inode_unlock(dir);
 		ovl_workdir_cleanup_recurse(&path, level + 1);
 		inode_lock_nested(dir, I_MUTEX_PARENT);
-		ovl_cleanup(dir, dentry);
+		err = ovl_cleanup(dir, dentry);
 	}
+
+	return err;
 }
 
 int ovl_indexdir_cleanup(struct ovl_fs *ofs)
@@ -1132,8 +1133,8 @@ int ovl_indexdir_cleanup(struct ovl_fs *ofs)
 		if (!err) {
 			goto next;
 		} else if (err == -ESTALE) {
-			/* Cleanup stale index entries */
-			err = ovl_cleanup(dir, index);
+			/* Cleanup stale index entries and leftover whiteouts */
+			err = ovl_workdir_cleanup(dir, path.mnt, index, 1);
 		} else if (err != -ENOENT) {
 			/*
 			 * Abort mount to avoid corrupting the index if
-- 
2.17.1

