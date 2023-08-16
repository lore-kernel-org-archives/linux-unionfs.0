Return-Path: <linux-unionfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 94FECC04FE0
	for <linux-unionfs@archiver.kernel.org>; Wed, 16 Aug 2023 15:24:54 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344131AbjHPPYX (ORCPT
        <rfc822;linux-unionfs@archiver.kernel.org>);
        Wed, 16 Aug 2023 11:24:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49016 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344211AbjHPPYJ (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Wed, 16 Aug 2023 11:24:09 -0400
Received: from mail-wr1-x42f.google.com (mail-wr1-x42f.google.com [IPv6:2a00:1450:4864:20::42f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 47C2B2701
        for <linux-unionfs@vger.kernel.org>; Wed, 16 Aug 2023 08:23:44 -0700 (PDT)
Received: by mail-wr1-x42f.google.com with SMTP id ffacd0b85a97d-31956020336so3514712f8f.0
        for <linux-unionfs@vger.kernel.org>; Wed, 16 Aug 2023 08:23:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1692199422; x=1692804222;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=bIb1K+QyQHare2k3G7aWiU7Akbkd/ZAMlYkUx41SQtk=;
        b=QPkNSHXrBL/9qJ00S9PYogmYvzKJ1QB5BWEss4ViyLtzlLeNzUHqfOpKjlm4wK8pBP
         tYj7wx6ZQ/aBsUpH8ieNhpShAcHqTQLJDzaRpDtPEuWm9i/8kfEFdT5e2m8/R17o7hCw
         tPm3S5sE3+kizVvQ00geqGaJ/FPCai4m6Fsuf81vcC9GzMOHk0ethauAnZLs7oIlERPl
         VRrWJWbI9Xxj5xcpiFbpj3tIs0K84a8XT+Ix3ZiT67MFFSlHSyUmgexTkzEgCAobYK/h
         f+vnl3LKp3SWcN52dkankcPrJUrnnUZRX9+VBY/KjXpRDj5BAn3qAPPG0YSUgP5CE7ja
         39lg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1692199422; x=1692804222;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=bIb1K+QyQHare2k3G7aWiU7Akbkd/ZAMlYkUx41SQtk=;
        b=EJ4cheDxn63KRjZJiUyg5n9TS7q0gywtsWNirxpsMnt0bN2hsxGCGLSEfqWNJ1Esh9
         AoHTZMivWwfofHnIX7StTpyS7gGcsz2cjsqhLCtsaH+gg/1kwC1EW9EHxkIFrAB7cibH
         x9Ld6bjqQ5M3+Xe3PkGhWxhNa/0gFpvpy0cglpKYk4k9fe07wG4hGWlWPP453k3AUjaQ
         M2YNtmWKvczi70txiXJB56LsR/fgHDY5PuJ/nQspI8Enb9odTe/ijGtMXqyLKuFw080g
         XmNyVGUjydkyHTJ9/zURVxtAebR8+fQtxpzQqePdk7tJTyKTNgAqV0LzuZXkqHBpyW79
         Ztfg==
X-Gm-Message-State: AOJu0Yw6YaOxsZxVKGyCrwSDX65lNOp6UBQGCi5v2PKg4pain1tBW/L2
        C7liuMzW8+VJahMzfobPqak89o5mSQ8=
X-Google-Smtp-Source: AGHT+IHYqZjTWbo+ssqlaxXA95dM+rT1tSZF1k5Xyr5tcPydAMEEZoGRnFGYxOMzLr9s1ZtUTmV6AQ==
X-Received: by 2002:a5d:45cb:0:b0:30f:c1fa:7901 with SMTP id b11-20020a5d45cb000000b0030fc1fa7901mr2187358wrs.5.1692199422413;
        Wed, 16 Aug 2023 08:23:42 -0700 (PDT)
Received: from amir-ThinkPad-T480.lan ([5.29.249.86])
        by smtp.gmail.com with ESMTPSA id k7-20020adfe3c7000000b003176c6e87b1sm21701988wrm.81.2023.08.16.08.23.41
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 16 Aug 2023 08:23:41 -0700 (PDT)
From:   Amir Goldstein <amir73il@gmail.com>
To:     Miklos Szeredi <miklos@szeredi.hu>
Cc:     linux-unionfs@vger.kernel.org
Subject: [PATCH v3 3/4] ovl: do not open/llseek lower file with upper sb_writers held
Date:   Wed, 16 Aug 2023 18:23:33 +0300
Message-Id: <20230816152334.924960-4-amir73il@gmail.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20230816152334.924960-1-amir73il@gmail.com>
References: <20230816152334.924960-1-amir73il@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-unionfs.vger.kernel.org>
X-Mailing-List: linux-unionfs@vger.kernel.org

overlayfs file open (ovl_maybe_lookup_lowerdata) and overlay file llseek
take the ovl_inode_lock, without holding upper sb_writers.

In case of nested lower overlay that uses same upper fs as this overlay,
lockdep will warn about (possibly false positive) circular lock
dependency when doing open/llseek of lower ovl file during copy up with
our upper sb_writers held, because the locking ordering seems reverse to
the locking order in ovl_copy_up_start():

- lower ovl_inode_lock
- upper sb_writers

Let the copy up "transaction" keeps an elevated mnt write count on upper
mnt, but leaves taking upper sb_writers to lower level helpers only when
they actually need it.  This allows to avoid holding upper sb_writers
during lower file open/llseek and prevents the lockdep warning.

Minimizing the scope of upper sb_writers during copy up is also needed
for fixing another possible deadlocks by a following patch.

Signed-off-by: Amir Goldstein <amir73il@gmail.com>
---
 fs/overlayfs/copy_up.c | 76 ++++++++++++++++++++++++++++++------------
 fs/overlayfs/util.c    |  8 +++--
 2 files changed, 61 insertions(+), 23 deletions(-)

diff --git a/fs/overlayfs/copy_up.c b/fs/overlayfs/copy_up.c
index e9adff187284..add5861cf06b 100644
--- a/fs/overlayfs/copy_up.c
+++ b/fs/overlayfs/copy_up.c
@@ -252,7 +252,9 @@ static int ovl_copy_up_file(struct ovl_fs *ofs, struct dentry *dentry,
 		return PTR_ERR(old_file);
 
 	/* Try to use clone_file_range to clone up within the same fs */
+	ovl_start_write(dentry);
 	cloned = do_clone_file_range(old_file, 0, new_file, 0, len, 0);
+	ovl_end_write(dentry);
 	if (cloned == len)
 		goto out_fput;
 	/* Couldn't clone, so now we try to copy the data */
@@ -287,8 +289,12 @@ static int ovl_copy_up_file(struct ovl_fs *ofs, struct dentry *dentry,
 		 * it may not recognize all kind of holes and sometimes
 		 * only skips partial of hole area. However, it will be
 		 * enough for most of the use cases.
+		 *
+		 * We do not hold upper sb_writers throughout the loop to avert
+		 * lockdep warning with llseek of lower file in nested overlay:
+		 * - upper sb_writers
+		 * -- lower ovl_inode_lock (ovl_llseek)
 		 */
-
 		if (skip_hole && data_pos < old_pos) {
 			data_pos = vfs_llseek(old_file, old_pos, SEEK_DATA);
 			if (data_pos > old_pos) {
@@ -303,9 +309,11 @@ static int ovl_copy_up_file(struct ovl_fs *ofs, struct dentry *dentry,
 			}
 		}
 
+		ovl_start_write(dentry);
 		bytes = do_splice_direct(old_file, &old_pos,
 					 new_file, &new_pos,
 					 this_len, SPLICE_F_MOVE);
+		ovl_end_write(dentry);
 		if (bytes <= 0) {
 			error = bytes;
 			break;
@@ -555,14 +563,16 @@ static int ovl_link_up(struct ovl_copy_up_ctx *c)
 	struct ovl_fs *ofs = OVL_FS(c->dentry->d_sb);
 	struct inode *udir = d_inode(upperdir);
 
+	ovl_start_write(c->dentry);
+
 	/* Mark parent "impure" because it may now contain non-pure upper */
 	err = ovl_set_impure(c->parent, upperdir);
 	if (err)
-		return err;
+		goto out;
 
 	err = ovl_set_nlink_lower(c->dentry);
 	if (err)
-		return err;
+		goto out;
 
 	inode_lock_nested(udir, I_MUTEX_PARENT);
 	upper = ovl_lookup_upper(ofs, c->dentry->d_name.name, upperdir,
@@ -581,10 +591,12 @@ static int ovl_link_up(struct ovl_copy_up_ctx *c)
 	}
 	inode_unlock(udir);
 	if (err)
-		return err;
+		goto out;
 
 	err = ovl_set_nlink_upper(c->dentry);
 
+out:
+	ovl_end_write(c->dentry);
 	return err;
 }
 
@@ -718,21 +730,19 @@ static int ovl_copy_up_workdir(struct ovl_copy_up_ctx *c)
 		.link = c->link
 	};
 
-	/* workdir and destdir could be the same when copying up to indexdir */
-	err = -EIO;
-	if (lock_rename(c->workdir, c->destdir) != NULL)
-		goto unlock;
-
 	err = ovl_prep_cu_creds(c->dentry, &cc);
 	if (err)
-		goto unlock;
+		return err;
 
+	ovl_start_write(c->dentry);
+	inode_lock(wdir);
 	temp = ovl_create_temp(ofs, c->workdir, &cattr);
+	inode_unlock(wdir);
+	ovl_end_write(c->dentry);
 	ovl_revert_cu_creds(&cc);
 
-	err = PTR_ERR(temp);
 	if (IS_ERR(temp))
-		goto unlock;
+		return PTR_ERR(temp);
 
 	/*
 	 * Copy up data first and then xattrs. Writing data after
@@ -740,8 +750,21 @@ static int ovl_copy_up_workdir(struct ovl_copy_up_ctx *c)
 	 */
 	path.dentry = temp;
 	err = ovl_copy_up_data(c, &path);
-	if (err)
+	/*
+	 * We cannot hold lock_rename() throughout this helper, because or
+	 * lock ordering with sb_writers, which shouldn't be held when calling
+	 * ovl_copy_up_data(), so lock workdir and destdir and make sure that
+	 * temp wasn't moved before copy up completion or cleanup.
+	 * If temp was moved, abort without the cleanup.
+	 */
+	ovl_start_write(c->dentry);
+	if (lock_rename(c->workdir, c->destdir) != NULL ||
+	    temp->d_parent != c->workdir) {
+		err = -EIO;
+		goto unlock;
+	} else if (err) {
 		goto cleanup;
+	}
 
 	err = ovl_copy_up_metadata(c, temp);
 	if (err)
@@ -778,6 +801,7 @@ static int ovl_copy_up_workdir(struct ovl_copy_up_ctx *c)
 		ovl_set_flag(OVL_WHITEOUTS, inode);
 unlock:
 	unlock_rename(c->workdir, c->destdir);
+	ovl_end_write(c->dentry);
 
 	return err;
 
@@ -801,9 +825,10 @@ static int ovl_copy_up_tmpfile(struct ovl_copy_up_ctx *c)
 	if (err)
 		return err;
 
+	ovl_start_write(c->dentry);
 	tmpfile = ovl_do_tmpfile(ofs, c->workdir, c->stat.mode);
+	ovl_end_write(c->dentry);
 	ovl_revert_cu_creds(&cc);
-
 	if (IS_ERR(tmpfile))
 		return PTR_ERR(tmpfile);
 
@@ -814,9 +839,11 @@ static int ovl_copy_up_tmpfile(struct ovl_copy_up_ctx *c)
 			goto out_fput;
 	}
 
+	ovl_start_write(c->dentry);
+
 	err = ovl_copy_up_metadata(c, temp);
 	if (err)
-		goto out_fput;
+		goto out;
 
 	inode_lock_nested(udir, I_MUTEX_PARENT);
 
@@ -830,7 +857,7 @@ static int ovl_copy_up_tmpfile(struct ovl_copy_up_ctx *c)
 	inode_unlock(udir);
 
 	if (err)
-		goto out_fput;
+		goto out;
 
 	if (c->metacopy_digest)
 		ovl_set_flag(OVL_HAS_DIGEST, d_inode(c->dentry));
@@ -842,6 +869,8 @@ static int ovl_copy_up_tmpfile(struct ovl_copy_up_ctx *c)
 		ovl_set_upperdata(d_inode(c->dentry));
 	ovl_inode_update(d_inode(c->dentry), dget(temp));
 
+out:
+	ovl_end_write(c->dentry);
 out_fput:
 	fput(tmpfile);
 	return err;
@@ -892,7 +921,9 @@ static int ovl_do_copy_up(struct ovl_copy_up_ctx *c)
 		 * Mark parent "impure" because it may now contain non-pure
 		 * upper
 		 */
+		ovl_start_write(c->dentry);
 		err = ovl_set_impure(c->parent, c->destdir);
+		ovl_end_write(c->dentry);
 		if (err)
 			return err;
 	}
@@ -908,6 +939,7 @@ static int ovl_do_copy_up(struct ovl_copy_up_ctx *c)
 	if (c->indexed)
 		ovl_set_flag(OVL_INDEX, d_inode(c->dentry));
 
+	ovl_start_write(c->dentry);
 	if (to_index) {
 		/* Initialize nlink for copy up of disconnected dentry */
 		err = ovl_set_nlink_upper(c->dentry);
@@ -922,6 +954,7 @@ static int ovl_do_copy_up(struct ovl_copy_up_ctx *c)
 		ovl_dentry_set_upper_alias(c->dentry);
 		ovl_dentry_update_reval(c->dentry, ovl_dentry_upper(c->dentry));
 	}
+	ovl_end_write(c->dentry);
 
 out:
 	if (to_index)
@@ -1010,15 +1043,16 @@ static int ovl_copy_up_meta_inode_data(struct ovl_copy_up_ctx *c)
 	 * Writing to upper file will clear security.capability xattr. We
 	 * don't want that to happen for normal copy-up operation.
 	 */
+	ovl_start_write(c->dentry);
 	if (capability) {
 		err = ovl_do_setxattr(ofs, upperpath.dentry, XATTR_NAME_CAPS,
 				      capability, cap_size, 0);
-		if (err)
-			goto out_free;
 	}
-
-
-	err = ovl_removexattr(ofs, upperpath.dentry, OVL_XATTR_METACOPY);
+	if (!err) {
+		err = ovl_removexattr(ofs, upperpath.dentry,
+				      OVL_XATTR_METACOPY);
+	}
+	ovl_end_write(c->dentry);
 	if (err)
 		goto out_free;
 
diff --git a/fs/overlayfs/util.c b/fs/overlayfs/util.c
index 980e128ba0a4..4e67ef0cc8da 100644
--- a/fs/overlayfs/util.c
+++ b/fs/overlayfs/util.c
@@ -670,6 +670,10 @@ bool ovl_already_copied_up(struct dentry *dentry, int flags)
 	return false;
 }
 
+/*
+ * The copy up "transaction" keeps an elevated mnt write count on upper mnt,
+ * but leaves taking freeze protection on upper sb to lower level helpers.
+ */
 int ovl_copy_up_start(struct dentry *dentry, int flags)
 {
 	struct inode *inode = d_inode(dentry);
@@ -682,7 +686,7 @@ int ovl_copy_up_start(struct dentry *dentry, int flags)
 	if (ovl_already_copied_up_locked(dentry, flags))
 		err = 1; /* Already copied up */
 	else
-		err = ovl_want_write(dentry);
+		err = ovl_get_mnt_write(dentry);
 	if (err)
 		goto out_unlock;
 
@@ -695,7 +699,7 @@ int ovl_copy_up_start(struct dentry *dentry, int flags)
 
 void ovl_copy_up_end(struct dentry *dentry)
 {
-	ovl_drop_write(dentry);
+	ovl_put_mnt_write(dentry);
 	ovl_inode_unlock(d_inode(dentry));
 }
 
-- 
2.34.1

