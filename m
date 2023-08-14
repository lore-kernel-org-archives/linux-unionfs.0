Return-Path: <linux-unionfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9AD11C41513
	for <linux-unionfs@archiver.kernel.org>; Mon, 14 Aug 2023 14:06:24 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229984AbjHNOFx (ORCPT
        <rfc822;linux-unionfs@archiver.kernel.org>);
        Mon, 14 Aug 2023 10:05:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59754 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231524AbjHNOF0 (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Mon, 14 Aug 2023 10:05:26 -0400
Received: from mail-wr1-x434.google.com (mail-wr1-x434.google.com [IPv6:2a00:1450:4864:20::434])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3927AE3
        for <linux-unionfs@vger.kernel.org>; Mon, 14 Aug 2023 07:05:25 -0700 (PDT)
Received: by mail-wr1-x434.google.com with SMTP id ffacd0b85a97d-31757edd9edso3635821f8f.2
        for <linux-unionfs@vger.kernel.org>; Mon, 14 Aug 2023 07:05:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1692021924; x=1692626724;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=5V17D3hVipoRPKWTTYuX6YdMJdWuIOAdAVRoiukonPg=;
        b=k7VMpCcbjCZfRs3vJVZG1iVBc7ZNNZJudxqWg0Bp+r6NHz4M6ZUUpQdCiJLXuf7iBf
         Lm3sxxUVyYYM1u6tH2KFC4ePJlaC9x+4FQFZyEXTH34r7bJmfk1aXCAtVLtlVgGQnHhf
         KwWgyYCX85tKA29fVq7GDGmMthPei3fOOVtVj3Tvs82l8+DQjy43W87Vg3apmftt3o1I
         j3rCQoOcFOCNDA2nHjVYwWLO4p9hkjPoiaqomGW0syX05VtltYP1p5GV3lt7tPA/VnLn
         XhmLKtsJvuN7/zqxcofSF0LEzknLhF2nH6wZLr5P6QfzhgNo4GvN9GgMyT6KXEI4W8wX
         NTFg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1692021924; x=1692626724;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=5V17D3hVipoRPKWTTYuX6YdMJdWuIOAdAVRoiukonPg=;
        b=I+NuUPkIk18Ov9RSqLK722W4zHd7dvkElTl8hU6g/0CLNBNQotzwM3f0kT9Q7Ft0Jj
         KeIpEvllYfn2FZ9PLTDymE8kJI4ynN11hRjhxr6UgLsEjBmdq74j1UvnencbpWKvZRDO
         Q75Qogt0Fa5WGXzMKAQVZ3RC24QMZXXXAYqetIYFLAHF8LNUXH6lCD2Qr+1yGGKKABR8
         kqJp1/B/RETlBC18pQFAfDXqIkfED95wmGoHX5UV/b9FwZZDaqabpZKf/DNKQ8bBQs6D
         esGQWWtnzy/Jmv9wsjDwKDr5xnHWSYNvCedo57+PMKtTwo2eDZn40Xaq/CSh7kcDN+/s
         QwSQ==
X-Gm-Message-State: AOJu0YzgcNpN7/RcWrgU0dutF4K33Ocv0cQuU0ADHHalaLO4lSFt1mGg
        e9JN7gOH4R/a1hgFq9wl/RQ=
X-Google-Smtp-Source: AGHT+IF2JsWA2J+7vDGWe1jtckNOXpFnLPNEbKgh8SgTTiRFD7jAaPchrbxPjVg7Skw07OcuFapi3Q==
X-Received: by 2002:a5d:6547:0:b0:317:6965:ef4d with SMTP id z7-20020a5d6547000000b003176965ef4dmr6337501wrv.56.1692021923353;
        Mon, 14 Aug 2023 07:05:23 -0700 (PDT)
Received: from amir-ThinkPad-T480.ctera.local (bzq-166-168-31-246.red.bezeqint.net. [31.168.166.246])
        by smtp.gmail.com with ESMTPSA id j4-20020adfff84000000b003142ea7a661sm14609901wrr.21.2023.08.14.07.05.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 14 Aug 2023 07:05:23 -0700 (PDT)
From:   Amir Goldstein <amir73il@gmail.com>
To:     Miklos Szeredi <miklos@szeredi.hu>
Cc:     Jan Kara <jack@suse.cz>, linux-unionfs@vger.kernel.org
Subject: [PATCH v2 1/3] ovl: reorder ovl_want_write() after ovl_inode_lock()
Date:   Mon, 14 Aug 2023 17:05:16 +0300
Message-Id: <20230814140518.763674-2-amir73il@gmail.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20230814140518.763674-1-amir73il@gmail.com>
References: <20230814140518.763674-1-amir73il@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-unionfs.vger.kernel.org>
X-Mailing-List: linux-unionfs@vger.kernel.org

Make the locking order of ovl_inode_lock() strictly between the two
vfs stacked layers, i.e.:
- ovl vfs locks: sb_writers, inode_lock, ...
- ovl_inode_lock
- upper vfs locks: sb_writers, inode_lock, ...

To that effect, move ovl_want_write() into the helpers ovl_nlink_start()
and ovl_copy_up_one() which currently take the ovl_inode_lock() after
ovl_want_write().

Signed-off-by: Amir Goldstein <amir73il@gmail.com>
---
 fs/overlayfs/copy_up.c | 36 ++++++++++-----------
 fs/overlayfs/dir.c     | 71 ++++++++++++++++++------------------------
 fs/overlayfs/export.c  |  7 +----
 fs/overlayfs/inode.c   | 56 ++++++++++++++++-----------------
 fs/overlayfs/util.c    |  7 +++++
 5 files changed, 83 insertions(+), 94 deletions(-)

diff --git a/fs/overlayfs/copy_up.c b/fs/overlayfs/copy_up.c
index bae404a1bad4..c998dab440f8 100644
--- a/fs/overlayfs/copy_up.c
+++ b/fs/overlayfs/copy_up.c
@@ -1085,15 +1085,22 @@ static int ovl_copy_up_one(struct dentry *parent, struct dentry *dentry,
 	if (unlikely(err)) {
 		if (err > 0)
 			err = 0;
-	} else {
-		if (!ovl_dentry_upper(dentry))
-			err = ovl_do_copy_up(&ctx);
-		if (!err && parent && !ovl_dentry_has_upper_alias(dentry))
-			err = ovl_link_up(&ctx);
-		if (!err && ovl_dentry_needs_data_copy_up_locked(dentry, flags))
-			err = ovl_copy_up_meta_inode_data(&ctx);
-		ovl_copy_up_end(dentry);
+		goto out;
 	}
+
+	err = ovl_want_write(dentry);
+	if (err)
+		goto out;
+
+	if (!ovl_dentry_upper(dentry))
+		err = ovl_do_copy_up(&ctx);
+	if (!err && parent && !ovl_dentry_has_upper_alias(dentry))
+		err = ovl_link_up(&ctx);
+	if (!err && ovl_dentry_needs_data_copy_up_locked(dentry, flags))
+		err = ovl_copy_up_meta_inode_data(&ctx);
+	ovl_drop_write(dentry);
+	ovl_copy_up_end(dentry);
+out:
 	do_delayed_call(&done);
 
 	return err;
@@ -1169,17 +1176,10 @@ static bool ovl_open_need_copy_up(struct dentry *dentry, int flags)
 
 int ovl_maybe_copy_up(struct dentry *dentry, int flags)
 {
-	int err = 0;
-
-	if (ovl_open_need_copy_up(dentry, flags)) {
-		err = ovl_want_write(dentry);
-		if (!err) {
-			err = ovl_copy_up_flags(dentry, flags);
-			ovl_drop_write(dentry);
-		}
-	}
+	if (!ovl_open_need_copy_up(dentry, flags))
+		return 0;
 
-	return err;
+	return ovl_copy_up_flags(dentry, flags);
 }
 
 int ovl_copy_up_with_data(struct dentry *dentry)
diff --git a/fs/overlayfs/dir.c b/fs/overlayfs/dir.c
index 033fc0458a3d..f01031fe7b97 100644
--- a/fs/overlayfs/dir.c
+++ b/fs/overlayfs/dir.c
@@ -559,10 +559,6 @@ static int ovl_create_or_link(struct dentry *dentry, struct inode *inode,
 	struct cred *override_cred;
 	struct dentry *parent = dentry->d_parent;
 
-	err = ovl_copy_up(parent);
-	if (err)
-		return err;
-
 	old_cred = ovl_override_creds(dentry->d_sb);
 
 	/*
@@ -626,15 +622,11 @@ static int ovl_create_object(struct dentry *dentry, int mode, dev_t rdev,
 		.link = link,
 	};
 
-	err = ovl_want_write(dentry);
-	if (err)
-		goto out;
-
 	/* Preallocate inode to be used by ovl_get_inode() */
 	err = -ENOMEM;
 	inode = ovl_new_inode(dentry->d_sb, mode, rdev);
 	if (!inode)
-		goto out_drop_write;
+		goto out;
 
 	spin_lock(&inode->i_lock);
 	inode->i_state |= I_CREATING;
@@ -643,12 +635,19 @@ static int ovl_create_object(struct dentry *dentry, int mode, dev_t rdev,
 	inode_init_owner(&nop_mnt_idmap, inode, dentry->d_parent->d_inode, mode);
 	attr.mode = inode->i_mode;
 
+	err = ovl_copy_up(dentry->d_parent);
+	if (err)
+		return err;
+
+	err = ovl_want_write(dentry);
+	if (err)
+		goto out;
+
 	err = ovl_create_or_link(dentry, inode, &attr, false);
 	/* Did we end up using the preallocated inode? */
 	if (inode != d_inode(dentry))
 		iput(inode);
 
-out_drop_write:
 	ovl_drop_write(dentry);
 out:
 	return err;
@@ -700,28 +699,24 @@ static int ovl_link(struct dentry *old, struct inode *newdir,
 	int err;
 	struct inode *inode;
 
-	err = ovl_want_write(old);
+	err = ovl_copy_up(old);
 	if (err)
 		goto out;
 
-	err = ovl_copy_up(old);
+	err = ovl_copy_up(new->d_parent);
 	if (err)
-		goto out_drop_write;
+		goto out;
 
-	err = ovl_copy_up(new->d_parent);
+	err = ovl_nlink_start(old);
 	if (err)
-		goto out_drop_write;
+		goto out;
 
 	if (ovl_is_metacopy_dentry(old)) {
 		err = ovl_set_link_redirect(old);
 		if (err)
-			goto out_drop_write;
+			goto out_nlink_end;
 	}
 
-	err = ovl_nlink_start(old);
-	if (err)
-		goto out_drop_write;
-
 	inode = d_inode(old);
 	ihold(inode);
 
@@ -731,9 +726,8 @@ static int ovl_link(struct dentry *old, struct inode *newdir,
 	if (err)
 		iput(inode);
 
+out_nlink_end:
 	ovl_nlink_end(old);
-out_drop_write:
-	ovl_drop_write(old);
 out:
 	return err;
 }
@@ -891,17 +885,13 @@ static int ovl_do_remove(struct dentry *dentry, bool is_dir)
 			goto out;
 	}
 
-	err = ovl_want_write(dentry);
-	if (err)
-		goto out;
-
 	err = ovl_copy_up(dentry->d_parent);
 	if (err)
-		goto out_drop_write;
+		goto out;
 
 	err = ovl_nlink_start(dentry);
 	if (err)
-		goto out_drop_write;
+		goto out;
 
 	old_cred = ovl_override_creds(dentry->d_sb);
 	if (!lower_positive)
@@ -926,8 +916,6 @@ static int ovl_do_remove(struct dentry *dentry, bool is_dir)
 	if (ovl_dentry_upper(dentry))
 		ovl_copyattr(d_inode(dentry));
 
-out_drop_write:
-	ovl_drop_write(dentry);
 out:
 	ovl_cache_free(&list);
 	return err;
@@ -1131,29 +1119,32 @@ static int ovl_rename(struct mnt_idmap *idmap, struct inode *olddir,
 		}
 	}
 
-	err = ovl_want_write(old);
-	if (err)
-		goto out;
-
 	err = ovl_copy_up(old);
 	if (err)
-		goto out_drop_write;
+		goto out;
 
 	err = ovl_copy_up(new->d_parent);
 	if (err)
-		goto out_drop_write;
+		goto out;
 	if (!overwrite) {
 		err = ovl_copy_up(new);
 		if (err)
-			goto out_drop_write;
+			goto out;
 	} else if (d_inode(new)) {
 		err = ovl_nlink_start(new);
 		if (err)
-			goto out_drop_write;
+			goto out;
 
 		update_nlink = true;
 	}
 
+	if (!update_nlink) {
+		/* ovl_nlink_start() took ovl_want_write() */
+		err = ovl_want_write(old);
+		if (err)
+			goto out;
+	}
+
 	old_cred = ovl_override_creds(old->d_sb);
 
 	if (!list_empty(&list)) {
@@ -1286,8 +1277,8 @@ static int ovl_rename(struct mnt_idmap *idmap, struct inode *olddir,
 	revert_creds(old_cred);
 	if (update_nlink)
 		ovl_nlink_end(new);
-out_drop_write:
-	ovl_drop_write(old);
+	else
+		ovl_drop_write(old);
 out:
 	dput(opaquedir);
 	ovl_cache_free(&list);
diff --git a/fs/overlayfs/export.c b/fs/overlayfs/export.c
index c8c8588bd98c..4a79c479c971 100644
--- a/fs/overlayfs/export.c
+++ b/fs/overlayfs/export.c
@@ -23,12 +23,7 @@ static int ovl_encode_maybe_copy_up(struct dentry *dentry)
 	if (ovl_dentry_upper(dentry))
 		return 0;
 
-	err = ovl_want_write(dentry);
-	if (!err) {
-		err = ovl_copy_up(dentry);
-		ovl_drop_write(dentry);
-	}
-
+	err = ovl_copy_up(dentry);
 	if (err) {
 		pr_warn_ratelimited("failed to copy up on encode (%pd2, err=%i)\n",
 				    dentry, err);
diff --git a/fs/overlayfs/inode.c b/fs/overlayfs/inode.c
index b395cd84bfce..f5638cfe8f6d 100644
--- a/fs/overlayfs/inode.c
+++ b/fs/overlayfs/inode.c
@@ -32,10 +32,6 @@ int ovl_setattr(struct mnt_idmap *idmap, struct dentry *dentry,
 	if (err)
 		return err;
 
-	err = ovl_want_write(dentry);
-	if (err)
-		goto out;
-
 	if (attr->ia_valid & ATTR_SIZE) {
 		/* Truncate should trigger data copy up as well */
 		full_copy_up = true;
@@ -54,7 +50,7 @@ int ovl_setattr(struct mnt_idmap *idmap, struct dentry *dentry,
 			winode = d_inode(upperdentry);
 			err = get_write_access(winode);
 			if (err)
-				goto out_drop_write;
+				goto out;
 		}
 
 		if (attr->ia_valid & (ATTR_KILL_SUID|ATTR_KILL_SGID))
@@ -78,6 +74,10 @@ int ovl_setattr(struct mnt_idmap *idmap, struct dentry *dentry,
 		 */
 		attr->ia_valid &= ~ATTR_OPEN;
 
+		err = ovl_want_write(dentry);
+		if (err)
+			goto out;
+
 		inode_lock(upperdentry->d_inode);
 		old_cred = ovl_override_creds(dentry->d_sb);
 		err = ovl_do_notify_change(ofs, upperdentry, attr);
@@ -85,12 +85,11 @@ int ovl_setattr(struct mnt_idmap *idmap, struct dentry *dentry,
 		if (!err)
 			ovl_copyattr(dentry->d_inode);
 		inode_unlock(upperdentry->d_inode);
+		ovl_drop_write(dentry);
 
 		if (winode)
 			put_write_access(winode);
 	}
-out_drop_write:
-	ovl_drop_write(dentry);
 out:
 	return err;
 }
@@ -361,27 +360,27 @@ int ovl_xattr_set(struct dentry *dentry, struct inode *inode, const char *name,
 	struct path realpath;
 	const struct cred *old_cred;
 
-	err = ovl_want_write(dentry);
-	if (err)
-		goto out;
-
 	if (!value && !upperdentry) {
 		ovl_path_lower(dentry, &realpath);
 		old_cred = ovl_override_creds(dentry->d_sb);
 		err = vfs_getxattr(mnt_idmap(realpath.mnt), realdentry, name, NULL, 0);
 		revert_creds(old_cred);
 		if (err < 0)
-			goto out_drop_write;
+			goto out;
 	}
 
 	if (!upperdentry) {
 		err = ovl_copy_up(dentry);
 		if (err)
-			goto out_drop_write;
+			goto out;
 
 		realdentry = ovl_dentry_upper(dentry);
 	}
 
+	err = ovl_want_write(dentry);
+	if (err)
+		goto out;
+
 	old_cred = ovl_override_creds(dentry->d_sb);
 	if (value) {
 		err = ovl_do_setxattr(ofs, realdentry, name, value, size,
@@ -391,12 +390,10 @@ int ovl_xattr_set(struct dentry *dentry, struct inode *inode, const char *name,
 		err = ovl_do_removexattr(ofs, realdentry, name);
 	}
 	revert_creds(old_cred);
+	ovl_drop_write(dentry);
 
 	/* copy c/mtime */
 	ovl_copyattr(inode);
-
-out_drop_write:
-	ovl_drop_write(dentry);
 out:
 	return err;
 }
@@ -611,10 +608,6 @@ static int ovl_set_or_remove_acl(struct dentry *dentry, struct inode *inode,
 	struct dentry *upperdentry = ovl_dentry_upper(dentry);
 	struct dentry *realdentry = upperdentry ?: ovl_dentry_lower(dentry);
 
-	err = ovl_want_write(dentry);
-	if (err)
-		return err;
-
 	/*
 	 * If ACL is to be removed from a lower file, check if it exists in
 	 * the first place before copying it up.
@@ -630,7 +623,7 @@ static int ovl_set_or_remove_acl(struct dentry *dentry, struct inode *inode,
 		revert_creds(old_cred);
 		if (IS_ERR(real_acl)) {
 			err = PTR_ERR(real_acl);
-			goto out_drop_write;
+			goto out;
 		}
 		posix_acl_release(real_acl);
 	}
@@ -638,23 +631,26 @@ static int ovl_set_or_remove_acl(struct dentry *dentry, struct inode *inode,
 	if (!upperdentry) {
 		err = ovl_copy_up(dentry);
 		if (err)
-			goto out_drop_write;
+			goto out;
 
 		realdentry = ovl_dentry_upper(dentry);
 	}
 
+	err = ovl_want_write(dentry);
+	if (err)
+		goto out;
+
 	old_cred = ovl_override_creds(dentry->d_sb);
 	if (acl)
 		err = ovl_do_set_acl(ofs, realdentry, acl_name, acl);
 	else
 		err = ovl_do_remove_acl(ofs, realdentry, acl_name);
 	revert_creds(old_cred);
+	ovl_drop_write(dentry);
 
 	/* copy c/mtime */
 	ovl_copyattr(inode);
-
-out_drop_write:
-	ovl_drop_write(dentry);
+out:
 	return err;
 }
 
@@ -777,14 +773,14 @@ int ovl_fileattr_set(struct mnt_idmap *idmap,
 	unsigned int flags;
 	int err;
 
-	err = ovl_want_write(dentry);
-	if (err)
-		goto out;
-
 	err = ovl_copy_up(dentry);
 	if (!err) {
 		ovl_path_real(dentry, &upperpath);
 
+		err = ovl_want_write(dentry);
+		if (err)
+			goto out;
+
 		old_cred = ovl_override_creds(inode->i_sb);
 		/*
 		 * Store immutable/append-only flags in xattr and clear them
@@ -797,6 +793,7 @@ int ovl_fileattr_set(struct mnt_idmap *idmap,
 		if (!err)
 			err = ovl_real_fileattr_set(&upperpath, fa);
 		revert_creds(old_cred);
+		ovl_drop_write(dentry);
 
 		/*
 		 * Merge real inode flags with inode flags read from
@@ -811,7 +808,6 @@ int ovl_fileattr_set(struct mnt_idmap *idmap,
 		/* Update ctime */
 		ovl_copyattr(inode);
 	}
-	ovl_drop_write(dentry);
 out:
 	return err;
 }
diff --git a/fs/overlayfs/util.c b/fs/overlayfs/util.c
index 0f387092450e..4deed8a2a112 100644
--- a/fs/overlayfs/util.c
+++ b/fs/overlayfs/util.c
@@ -1062,6 +1062,10 @@ int ovl_nlink_start(struct dentry *dentry)
 	if (err)
 		return err;
 
+	err = ovl_want_write(dentry);
+	if (err)
+		goto out;
+
 	if (d_is_dir(dentry) || !ovl_test_flag(OVL_INDEX, inode))
 		goto out;
 
@@ -1074,6 +1078,8 @@ int ovl_nlink_start(struct dentry *dentry)
 	 */
 	err = ovl_set_nlink_upper(dentry);
 	revert_creds(old_cred);
+	if (err)
+		ovl_drop_write(dentry);
 
 out:
 	if (err)
@@ -1094,6 +1100,7 @@ void ovl_nlink_end(struct dentry *dentry)
 		revert_creds(old_cred);
 	}
 
+	ovl_drop_write(dentry);
 	ovl_inode_unlock(inode);
 }
 
-- 
2.34.1

