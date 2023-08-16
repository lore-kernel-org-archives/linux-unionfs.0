Return-Path: <linux-unionfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3A832C001E0
	for <linux-unionfs@archiver.kernel.org>; Wed, 16 Aug 2023 15:24:54 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344123AbjHPPYX (ORCPT
        <rfc822;linux-unionfs@archiver.kernel.org>);
        Wed, 16 Aug 2023 11:24:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48948 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344201AbjHPPYH (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Wed, 16 Aug 2023 11:24:07 -0400
Received: from mail-wr1-x42b.google.com (mail-wr1-x42b.google.com [IPv6:2a00:1450:4864:20::42b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C6B1D1BF7
        for <linux-unionfs@vger.kernel.org>; Wed, 16 Aug 2023 08:23:41 -0700 (PDT)
Received: by mail-wr1-x42b.google.com with SMTP id ffacd0b85a97d-3196afc7d4bso3628155f8f.3
        for <linux-unionfs@vger.kernel.org>; Wed, 16 Aug 2023 08:23:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1692199420; x=1692804220;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=50xOKByBq7jYvtaALwK1WUGNFF5NyxI0BtjB/iT3lWM=;
        b=Sz44Oh2/bL5IPnkPsYQYVGqFBN/EJoBYYhAWwuOi5TuU+XMz+3Wak7doiOHA1Q2MB2
         z7ChqDOBV/1pzxIGVzLAYIyt45lwoLvWaRH3zjJvZJ4TEssU32GMDsmLOkGGjqnhDJaa
         jend6mLGIfzklcP1TsrPsZOvHOizI9rvRiBCgW9YrPCrUuPtGfgL8fvNJitlX6ThsOKU
         W7kpLCn85gR08um3T9WAyzEjnmaKqoy9p/nCrk0m198pHUNbn1ED/UWGKxPpXwrIvVAo
         m/ZU2ELr1+D+/HHbhfv8K/ny05m2UrM5OEK5IgdRHYkJTcc8ztx6PZwFXt5/zJklYpS4
         JT+Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1692199420; x=1692804220;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=50xOKByBq7jYvtaALwK1WUGNFF5NyxI0BtjB/iT3lWM=;
        b=RW4jN8+b9GcQyjTi/7HZMlfBWrpSZ144H913E6gi/ZOikQTqUCngbXCXy9KhcqWPSH
         uDd10Ud+2VrOML/lFaJdaq6J9xKSiYXskhxiqFP2JmQK6VzTb4fD6aCwFD0pvUdFxCl6
         e1rcKwvobDbBJcX9iWNUYL0L5MzZvs38uuywGbTD+PDlUZag3vh0EdxDAxsHL8Cmuc7A
         qnP0I4lm293IzTt8SPihtjaGLQRieOYUpGZRD6hMQCMQNoP0ydq8qkkR9+53lfNXD9aw
         B2fIDnmhEQcpRd8oMOMn4RJnVL/7Xl+o8z+AYJrKI4m9tzXhbu7hGgRtJvcztF5rHaN1
         uz/Q==
X-Gm-Message-State: AOJu0YxofutTmxio8XTQRr4+Jy5ybLBho7WtiX0SHmfWslAzrb13d6hF
        jwVdpKzNWjOTkZkIU9aL+ODTN2yKw2k=
X-Google-Smtp-Source: AGHT+IH3xQbRjwCxy0EnYYeZy4Cfei9RWOlOcd7zhL+oRUW6E1QN2gY2vUcLYZ9b/WJPxLjx2s/OSQ==
X-Received: by 2002:adf:f6cc:0:b0:315:ade6:a52d with SMTP id y12-20020adff6cc000000b00315ade6a52dmr1904767wrp.19.1692199420001;
        Wed, 16 Aug 2023 08:23:40 -0700 (PDT)
Received: from amir-ThinkPad-T480.lan ([5.29.249.86])
        by smtp.gmail.com with ESMTPSA id k7-20020adfe3c7000000b003176c6e87b1sm21701988wrm.81.2023.08.16.08.23.38
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 16 Aug 2023 08:23:39 -0700 (PDT)
From:   Amir Goldstein <amir73il@gmail.com>
To:     Miklos Szeredi <miklos@szeredi.hu>
Cc:     linux-unionfs@vger.kernel.org
Subject: [PATCH v3 1/4] ovl: reorder ovl_want_write() after ovl_inode_lock()
Date:   Wed, 16 Aug 2023 18:23:31 +0300
Message-Id: <20230816152334.924960-2-amir73il@gmail.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20230816152334.924960-1-amir73il@gmail.com>
References: <20230816152334.924960-1-amir73il@gmail.com>
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
and ovl_copy_up_start which currently take the ovl_inode_lock() after
ovl_want_write().

Signed-off-by: Amir Goldstein <amir73il@gmail.com>
---
 fs/overlayfs/copy_up.c | 13 +++------
 fs/overlayfs/dir.c     | 60 ++++++++++++++++++------------------------
 fs/overlayfs/export.c  |  7 +----
 fs/overlayfs/inode.c   | 57 +++++++++++++++++++--------------------
 fs/overlayfs/util.c    | 34 +++++++++++++++++++-----
 5 files changed, 84 insertions(+), 87 deletions(-)

diff --git a/fs/overlayfs/copy_up.c b/fs/overlayfs/copy_up.c
index bae404a1bad4..e9adff187284 100644
--- a/fs/overlayfs/copy_up.c
+++ b/fs/overlayfs/copy_up.c
@@ -1169,17 +1169,10 @@ static bool ovl_open_need_copy_up(struct dentry *dentry, int flags)
 
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
index 033fc0458a3d..768120c20f85 100644
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
@@ -626,6 +622,10 @@ static int ovl_create_object(struct dentry *dentry, int mode, dev_t rdev,
 		.link = link,
 	};
 
+	err = ovl_copy_up(dentry->d_parent);
+	if (err)
+		return err;
+
 	err = ovl_want_write(dentry);
 	if (err)
 		goto out;
@@ -700,28 +700,24 @@ static int ovl_link(struct dentry *old, struct inode *newdir,
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
 
@@ -731,9 +727,8 @@ static int ovl_link(struct dentry *old, struct inode *newdir,
 	if (err)
 		iput(inode);
 
+out_nlink_end:
 	ovl_nlink_end(old);
-out_drop_write:
-	ovl_drop_write(old);
 out:
 	return err;
 }
@@ -891,17 +886,13 @@ static int ovl_do_remove(struct dentry *dentry, bool is_dir)
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
@@ -926,8 +917,6 @@ static int ovl_do_remove(struct dentry *dentry, bool is_dir)
 	if (ovl_dentry_upper(dentry))
 		ovl_copyattr(d_inode(dentry));
 
-out_drop_write:
-	ovl_drop_write(dentry);
 out:
 	ovl_cache_free(&list);
 	return err;
@@ -1131,29 +1120,32 @@ static int ovl_rename(struct mnt_idmap *idmap, struct inode *olddir,
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
@@ -1286,8 +1278,8 @@ static int ovl_rename(struct mnt_idmap *idmap, struct inode *olddir,
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
index b395cd84bfce..ed0de98602ed 100644
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
+			goto out_put_write;
+
 		inode_lock(upperdentry->d_inode);
 		old_cred = ovl_override_creds(dentry->d_sb);
 		err = ovl_do_notify_change(ofs, upperdentry, attr);
@@ -85,12 +85,12 @@ int ovl_setattr(struct mnt_idmap *idmap, struct dentry *dentry,
 		if (!err)
 			ovl_copyattr(dentry->d_inode);
 		inode_unlock(upperdentry->d_inode);
+		ovl_drop_write(dentry);
 
+out_put_write:
 		if (winode)
 			put_write_access(winode);
 	}
-out_drop_write:
-	ovl_drop_write(dentry);
 out:
 	return err;
 }
@@ -361,27 +361,27 @@ int ovl_xattr_set(struct dentry *dentry, struct inode *inode, const char *name,
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
@@ -391,12 +391,10 @@ int ovl_xattr_set(struct dentry *dentry, struct inode *inode, const char *name,
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
@@ -611,10 +609,6 @@ static int ovl_set_or_remove_acl(struct dentry *dentry, struct inode *inode,
 	struct dentry *upperdentry = ovl_dentry_upper(dentry);
 	struct dentry *realdentry = upperdentry ?: ovl_dentry_lower(dentry);
 
-	err = ovl_want_write(dentry);
-	if (err)
-		return err;
-
 	/*
 	 * If ACL is to be removed from a lower file, check if it exists in
 	 * the first place before copying it up.
@@ -630,7 +624,7 @@ static int ovl_set_or_remove_acl(struct dentry *dentry, struct inode *inode,
 		revert_creds(old_cred);
 		if (IS_ERR(real_acl)) {
 			err = PTR_ERR(real_acl);
-			goto out_drop_write;
+			goto out;
 		}
 		posix_acl_release(real_acl);
 	}
@@ -638,23 +632,26 @@ static int ovl_set_or_remove_acl(struct dentry *dentry, struct inode *inode,
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
 
@@ -777,14 +774,14 @@ int ovl_fileattr_set(struct mnt_idmap *idmap,
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
@@ -797,6 +794,7 @@ int ovl_fileattr_set(struct mnt_idmap *idmap,
 		if (!err)
 			err = ovl_real_fileattr_set(&upperpath, fa);
 		revert_creds(old_cred);
+		ovl_drop_write(dentry);
 
 		/*
 		 * Merge real inode flags with inode flags read from
@@ -811,7 +809,6 @@ int ovl_fileattr_set(struct mnt_idmap *idmap,
 		/* Update ctime */
 		ovl_copyattr(inode);
 	}
-	ovl_drop_write(dentry);
 out:
 	return err;
 }
diff --git a/fs/overlayfs/util.c b/fs/overlayfs/util.c
index 0f387092450e..753734c55647 100644
--- a/fs/overlayfs/util.c
+++ b/fs/overlayfs/util.c
@@ -650,16 +650,26 @@ int ovl_copy_up_start(struct dentry *dentry, int flags)
 	int err;
 
 	err = ovl_inode_lock_interruptible(inode);
-	if (!err && ovl_already_copied_up_locked(dentry, flags)) {
+	if (err)
+		return err;
+
+	if (ovl_already_copied_up_locked(dentry, flags))
 		err = 1; /* Already copied up */
-		ovl_inode_unlock(inode);
-	}
+	else
+		err = ovl_want_write(dentry);
+	if (err)
+		goto out_unlock;
+
+	return 0;
 
+out_unlock:
+	ovl_inode_unlock(inode);
 	return err;
 }
 
 void ovl_copy_up_end(struct dentry *dentry)
 {
+	ovl_drop_write(dentry);
 	ovl_inode_unlock(d_inode(dentry));
 }
 
@@ -1062,8 +1072,12 @@ int ovl_nlink_start(struct dentry *dentry)
 	if (err)
 		return err;
 
+	err = ovl_want_write(dentry);
+	if (err)
+		goto out_unlock;
+
 	if (d_is_dir(dentry) || !ovl_test_flag(OVL_INDEX, inode))
-		goto out;
+		return 0;
 
 	old_cred = ovl_override_creds(dentry->d_sb);
 	/*
@@ -1074,10 +1088,15 @@ int ovl_nlink_start(struct dentry *dentry)
 	 */
 	err = ovl_set_nlink_upper(dentry);
 	revert_creds(old_cred);
-
-out:
 	if (err)
-		ovl_inode_unlock(inode);
+		goto out_drop_write;
+
+	return 0;
+
+out_drop_write:
+	ovl_drop_write(dentry);
+out_unlock:
+	ovl_inode_unlock(inode);
 
 	return err;
 }
@@ -1094,6 +1113,7 @@ void ovl_nlink_end(struct dentry *dentry)
 		revert_creds(old_cred);
 	}
 
+	ovl_drop_write(dentry);
 	ovl_inode_unlock(inode);
 }
 
-- 
2.34.1

