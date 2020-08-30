Return-Path: <SRS0=vlVb=CI=vger.kernel.org=linux-unionfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0E4ADC433E2
	for <linux-unionfs@archiver.kernel.org>; Sun, 30 Aug 2020 20:28:15 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id CFBCF2083E
	for <linux-unionfs@archiver.kernel.org>; Sun, 30 Aug 2020 20:28:14 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="mTuzuFsG"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726155AbgH3U2O (ORCPT
        <rfc822;linux-unionfs@archiver.kernel.org>);
        Sun, 30 Aug 2020 16:28:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47656 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726150AbgH3U2N (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Sun, 30 Aug 2020 16:28:13 -0400
Received: from mail-wr1-x442.google.com (mail-wr1-x442.google.com [IPv6:2a00:1450:4864:20::442])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 75E93C061573
        for <linux-unionfs@vger.kernel.org>; Sun, 30 Aug 2020 13:28:13 -0700 (PDT)
Received: by mail-wr1-x442.google.com with SMTP id a17so3122002wrn.6
        for <linux-unionfs@vger.kernel.org>; Sun, 30 Aug 2020 13:28:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=xdtMUToMYSi4hdk7MGNof3ONvtfHudJbFmX3gN9/N8U=;
        b=mTuzuFsGNoPfhp8laSyuVqOUibytKjDmo8DdYYRdszNonnWfKqSAM3sep2tAVSNbfI
         yG8NtI/v+PSgpvPeEGnHJf0jiSZlpGiTkjxP4HOw/i9UxtcL/Th1IY0xaAkPOEWAITTK
         ePadjiEIjVmtwh9s4loUwKgNbMyctAJJt1rNmYzrcEmUKMxypiw0ymSPn1yNvaT0yqF6
         Qg0HAh4jaBUACAkZjEF2DK7WsfQpYZxWJ26fSAObK/JG6+Dx4eh/0AtFPhAVcvB0eu6o
         WN79dsV+c2Ul/lysvV0ABgVxEhDIVR1z3Z8TOyYtE8o4VtcyPGAx9tyTGjLxmgGrb4wc
         rqUw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=xdtMUToMYSi4hdk7MGNof3ONvtfHudJbFmX3gN9/N8U=;
        b=aVD4soKwAwFVIW5f9tfKb1XcC7xz/xkmAugwsPnUM21Ug8kdGZnF2sekFre5gZfte8
         +9ObtQ5ovKqIMzatvhT2DT5ZDoiddcuhRmXhI1TiSyZZpVS4dw1hAdeCf4awtXowH8g/
         1fA7zCvGZJkibdzs0PGC2XrElXNusZsTiu21jqJ9a4efoRmA+MONps2HhfA4yfrFVI6y
         tQbNxkVPiuJ2ZMEgDGR0SIdPZjokMyPWbg1RlRwPoNpSCZs/ui943O4OEc7FPY+b+rXV
         BQ0MgYfKTuMvwO3f9ZKcKDwJmAocyss5N2HIu5L7fdISvsj1wu+erWXfzbvShFBmNBCm
         ZxLQ==
X-Gm-Message-State: AOAM531EDRyfi0S8l53yKiD5cvD9J8cHhPN2LhW/l2i2RTspsBfko088
        c2Ba+11dCiaBqQn7iTNsfXc=
X-Google-Smtp-Source: ABdhPJwPOQwnzxf0Ny8hRxSgHXGTFmHUoYaYEwzin9mV5/IIwgC7oHQEwxLgK+0cCAISZfrkYdoUVg==
X-Received: by 2002:a5d:4c83:: with SMTP id z3mr8606217wrs.359.1598819290090;
        Sun, 30 Aug 2020 13:28:10 -0700 (PDT)
Received: from localhost.localdomain ([141.226.8.56])
        by smtp.gmail.com with ESMTPSA id 71sm8887452wrm.23.2020.08.30.13.28.08
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 30 Aug 2020 13:28:09 -0700 (PDT)
From:   Amir Goldstein <amir73il@gmail.com>
To:     Vivek Goyal <vgoyal@redhat.com>
Cc:     Miklos Szeredi <miklos@szeredi.hu>,
        Giuseppe Scrivano <gscrivan@redhat.com>,
        linux-unionfs@vger.kernel.org
Subject: [PATCH v2] ovl: check for incomapt features in work dir
Date:   Sun, 30 Aug 2020 23:28:03 +0300
Message-Id: <20200830202803.25028-1-amir73il@gmail.com>
X-Mailer: git-send-email 2.17.1
Sender: linux-unionfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-unionfs.vger.kernel.org>
X-Mailing-List: linux-unionfs@vger.kernel.org

An incompatible feature is marked by a non-empty directory nested
2 levels deep under "work" dir, e.g.:
workdir/work/incompat/volatile.

This commit checks for marked incompat features, warns about them
and fails to mount the overlay, for example:
  overlayfs: overlay with incompat feature 'volatile' cannot be mounted

Very old kernels (i.e. v3.18) will fail to remove a non-empty "work"
dir and fail the mount.  Newer kernels will fail to remove a "work"
dir with entries nested 3 levels and fall back to read-only mount.

User mounting with old kernel will see a warning like these in dmesg:
  overlayfs: cleanup of 'incompat/...' failed (-39)
  overlayfs: cleanup of 'work/incompat' failed (-39)
  overlayfs: cleanup of 'ovl-work/work' failed (-39)
  overlayfs: failed to create directory /vdf/ovl-work/work (errno: 17);
             mounting read-only

These warnings should give the hint to the user that:
1. mount failure is caused by backward incompatible features
2. mount failure can be resolved by manually removing the "work" directory

There is nothing preventing users on old kernels from manually removing
workdir entirely or mounting overlay with a new workdir, so this is in
no way a full proof backward compatibility enforcement, but only a best
effort.

Signed-off-by: Amir Goldstein <amir73il@gmail.com>
---

Vivek,

Re-posting with minor cleanups.
Also pushed to branch ovl-incompat.

Thanks,
Amir.

Changes since v1:
- Move check for "incompat" name to ovl_workdir_cleanup_recurse()


 fs/overlayfs/readdir.c | 30 +++++++++++++++++++++++++-----
 fs/overlayfs/super.c   | 25 ++++++++++++++++++-------
 2 files changed, 43 insertions(+), 12 deletions(-)

diff --git a/fs/overlayfs/readdir.c b/fs/overlayfs/readdir.c
index 6918b98faeb6..683c6f27ab77 100644
--- a/fs/overlayfs/readdir.c
+++ b/fs/overlayfs/readdir.c
@@ -1051,7 +1051,9 @@ int ovl_check_d_type_supported(struct path *realpath)
 	return rdd.d_type_supported;
 }
 
-static void ovl_workdir_cleanup_recurse(struct path *path, int level)
+#define OVL_INCOMPATDIR_NAME "incompat"
+
+static int ovl_workdir_cleanup_recurse(struct path *path, int level)
 {
 	int err;
 	struct inode *dir = path->dentry->d_inode;
@@ -1065,6 +1067,15 @@ static void ovl_workdir_cleanup_recurse(struct path *path, int level)
 		.root = &root,
 		.is_lowest = false,
 	};
+	bool incompat = false;
+
+	/*
+	 * The "work/incompat" directory is treated specially - if it is not
+	 * empty, instead of printing a generic error and mounting read-only,
+	 * we will error about incompat features and fail the mount.
+	 */
+	if (level == 2 && !strcmp(path->dentry->d_name.name, OVL_INCOMPATDIR_NAME))
+		incompat = true;
 
 	err = ovl_dir_read(path, &rdd);
 	if (err)
@@ -1079,21 +1090,29 @@ static void ovl_workdir_cleanup_recurse(struct path *path, int level)
 				continue;
 			if (p->len == 2 && p->name[1] == '.')
 				continue;
+		} else if (incompat) {
+			pr_warn("overlay with incompat feature '%.*s' cannot be mounted\n",
+				p->len, p->name);
+			err = -EEXIST;
+			break;
 		}
 		dentry = lookup_one_len(p->name, path->dentry, p->len);
 		if (IS_ERR(dentry))
 			continue;
 		if (dentry->d_inode)
-			ovl_workdir_cleanup(dir, path->mnt, dentry, level);
+			err = ovl_workdir_cleanup(dir, path->mnt, dentry, level);
 		dput(dentry);
+		if (err)
+			break;
 	}
 	inode_unlock(dir);
 out:
 	ovl_cache_free(&list);
+	return err;
 }
 
 int ovl_workdir_cleanup(struct inode *dir, struct vfsmount *mnt,
-			 struct dentry *dentry, int level)
+			struct dentry *dentry, int level)
 {
 	int err;
 
@@ -1106,9 +1125,10 @@ int ovl_workdir_cleanup(struct inode *dir, struct vfsmount *mnt,
 		struct path path = { .mnt = mnt, .dentry = dentry };
 
 		inode_unlock(dir);
-		ovl_workdir_cleanup_recurse(&path, level + 1);
+		err = ovl_workdir_cleanup_recurse(&path, level + 1);
 		inode_lock_nested(dir, I_MUTEX_PARENT);
-		err = ovl_cleanup(dir, dentry);
+		if (!err)
+			err = ovl_cleanup(dir, dentry);
 	}
 
 	return err;
diff --git a/fs/overlayfs/super.c b/fs/overlayfs/super.c
index 4b38141c2985..3cd47e4b2eae 100644
--- a/fs/overlayfs/super.c
+++ b/fs/overlayfs/super.c
@@ -705,8 +705,12 @@ static struct dentry *ovl_workdir_create(struct ovl_fs *ofs,
 				goto out_unlock;
 
 			retried = true;
-			ovl_workdir_cleanup(dir, mnt, work, 0);
+			err = ovl_workdir_cleanup(dir, mnt, work, 0);
 			dput(work);
+			if (err == -EEXIST) {
+				work = ERR_PTR(err);
+				goto out_unlock;
+			}
 			goto retry;
 		}
 
@@ -1203,7 +1207,7 @@ static int ovl_make_workdir(struct super_block *sb, struct ovl_fs *ofs,
 			    struct path *workpath)
 {
 	struct vfsmount *mnt = ovl_upper_mnt(ofs);
-	struct dentry *temp;
+	struct dentry *temp, *workdir;
 	bool rename_whiteout;
 	bool d_type;
 	int fh_type;
@@ -1213,10 +1217,13 @@ static int ovl_make_workdir(struct super_block *sb, struct ovl_fs *ofs,
 	if (err)
 		return err;
 
-	ofs->workdir = ovl_workdir_create(ofs, OVL_WORKDIR_NAME, false);
-	if (!ofs->workdir)
+	workdir = ovl_workdir_create(ofs, OVL_WORKDIR_NAME, false);
+	err = PTR_ERR(workdir);
+	if (IS_ERR_OR_NULL(workdir))
 		goto out;
 
+	ofs->workdir = workdir;
+
 	err = ovl_setup_trap(sb, ofs->workdir, &ofs->workdir_trap, "workdir");
 	if (err)
 		goto out;
@@ -1347,6 +1354,7 @@ static int ovl_get_indexdir(struct super_block *sb, struct ovl_fs *ofs,
 			    struct ovl_entry *oe, struct path *upperpath)
 {
 	struct vfsmount *mnt = ovl_upper_mnt(ofs);
+	struct dentry *indexdir;
 	int err;
 
 	err = mnt_want_write(mnt);
@@ -1366,9 +1374,12 @@ static int ovl_get_indexdir(struct super_block *sb, struct ovl_fs *ofs,
 	ofs->workdir_trap = NULL;
 	dput(ofs->workdir);
 	ofs->workdir = NULL;
-	ofs->indexdir = ovl_workdir_create(ofs, OVL_INDEXDIR_NAME, true);
-	if (ofs->indexdir) {
-		ofs->workdir = dget(ofs->indexdir);
+	indexdir = ovl_workdir_create(ofs, OVL_INDEXDIR_NAME, true);
+	if (IS_ERR(indexdir)) {
+		err = PTR_ERR(indexdir);
+	} else if (indexdir) {
+		ofs->indexdir = indexdir;
+		ofs->workdir = dget(indexdir);
 
 		err = ovl_setup_trap(sb, ofs->indexdir, &ofs->indexdir_trap,
 				     "indexdir");
-- 
2.17.1

