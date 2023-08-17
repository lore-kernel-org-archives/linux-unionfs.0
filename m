Return-Path: <linux-unionfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8F031C2FC1A
	for <linux-unionfs@archiver.kernel.org>; Thu, 17 Aug 2023 11:06:53 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1350090AbjHQLGV (ORCPT
        <rfc822;linux-unionfs@archiver.kernel.org>);
        Thu, 17 Aug 2023 07:06:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49042 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1350157AbjHQLGT (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Thu, 17 Aug 2023 07:06:19 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D077F26A4
        for <linux-unionfs@vger.kernel.org>; Thu, 17 Aug 2023 04:05:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1692270334;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=vSRqfaQDOnHg7yQHeRIs+CXNf2ggkbvK16xeQ2IQhFc=;
        b=WPUkYtbCyfWmNAv/mw7Rv8RS8jXWMG6b71IOfW0hq9ArsyEgDPe5eTbvyU1ISXLECQ1wNe
        senyHR1ej4E3c6M1Wr7PPNreUEOSHK4MCMXujgqI7PUXu6eJSg7cGy1iYBzQ1SqurlMDWP
        +5Rn1KH6r0nTbwMUKb6dWVWiMNFytYI=
Received: from mail-lj1-f198.google.com (mail-lj1-f198.google.com
 [209.85.208.198]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-501-1Rp3K5grPsil1E_o_-lAdw-1; Thu, 17 Aug 2023 07:05:32 -0400
X-MC-Unique: 1Rp3K5grPsil1E_o_-lAdw-1
Received: by mail-lj1-f198.google.com with SMTP id 38308e7fff4ca-2b9fa64dba8so76178961fa.0
        for <linux-unionfs@vger.kernel.org>; Thu, 17 Aug 2023 04:05:32 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1692270331; x=1692875131;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=vSRqfaQDOnHg7yQHeRIs+CXNf2ggkbvK16xeQ2IQhFc=;
        b=PeoDPjxwib1PDA+yxRr9uVKnRn27hcaQaLaikmwLzFcvmwUvIio0OUm55NNK9/58bM
         stJGgCqfsWzWpjj9QyZTkAezMu+6zrJUsqFOx8f09CxC/225gQ1TBGWO2XQCb8DY5QyB
         FAEqO+VLnft80/D2fmTsuIdOTs607JFwR+2une+VlcSa3sEhkMJSOMtipW1ucIoCqi8B
         lZGMxLI8bBZV3yN2KxfoGHPN2OdIAxJqcoIHuKvmAE2IMEYaXd4nK+d1w0cVIAO5pRx5
         oykFBmP7OiPfRASu6ZqN0XannkSTXUU5xMkWsHn3L6K6elVbiRPXevljEPWrDUiA5xI5
         TEVQ==
X-Gm-Message-State: AOJu0YxjjPOLHcCW4cIFpwEXNmLfYMFvTgmJC8towirvguBHntJkhkCF
        EG0f05e2gxhnEFpmuan4yv9+rIO96/vCLeQE1M3L9nbmToRwNSDMO1r8pyxP+7Kvmwvcjc4P56S
        6AX/ard5STs9ytTs0YEnnWmw2zg==
X-Received: by 2002:a2e:8857:0:b0:2bb:a697:31d with SMTP id z23-20020a2e8857000000b002bba697031dmr1079957ljj.48.1692270330892;
        Thu, 17 Aug 2023 04:05:30 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IEo7q+T2jyXc4Tmij8aQaDNtN62FFQnsKmDidQzn0aibuGCiLzOkD/VgIOEIU1F6Kt308ok9A==
X-Received: by 2002:a2e:8857:0:b0:2bb:a697:31d with SMTP id z23-20020a2e8857000000b002bba697031dmr1079944ljj.48.1692270330504;
        Thu, 17 Aug 2023 04:05:30 -0700 (PDT)
Received: from greebo.redhat.com (c-e6a5e255.022-110-73746f36.bbcust.telenor.se. [85.226.165.230])
        by smtp.googlemail.com with ESMTPSA id l20-20020a2e8694000000b002ba15c272e8sm69010lji.71.2023.08.17.04.05.29
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 17 Aug 2023 04:05:30 -0700 (PDT)
From:   Alexander Larsson <alexl@redhat.com>
To:     miklos@szeredi.hu
Cc:     linux-unionfs@vger.kernel.org, amir73il@gmail.com,
        Alexander Larsson <alexl@redhat.com>
Subject: [PATCH v2 4/5] ovl: Support creation of whiteout files on overlayfs
Date:   Thu, 17 Aug 2023 13:05:23 +0200
Message-ID: <f140fd46c2f61e69630c14a6b3fb8ed5e3c62307.1692270188.git.alexl@redhat.com>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <cover.1692270188.git.alexl@redhat.com>
References: <cover.1692270188.git.alexl@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-unionfs.vger.kernel.org>
X-Mailing-List: linux-unionfs@vger.kernel.org

This is needed to properly stack overlay filesystems, I.E, being able
to create a whiteout file on an overlay mount and then use that as
part of the lowerdir in another overlay mount.

The way this works is that we create a regular whiteout, but set the
`overlay.nowhiteout` xattr on it. Whenever we check if a file is a
whiteout we check this xattr and don't treat it as a whiteout if it is
set. The xattr itself is then stripped and when viewed as part of the
overlayfs mount it looks like a regular whiteout.

In order to make the creation of the whiteout file with xattr atomic
we always take ovl_create_over_whiteout() codepath when creating
whiteouts.

Signed-off-by: Alexander Larsson <alexl@redhat.com>
---
 fs/overlayfs/dir.c       | 24 +++++++++++++++++-------
 fs/overlayfs/namei.c     | 14 +++++++++-----
 fs/overlayfs/overlayfs.h | 13 +++++++++++++
 fs/overlayfs/readdir.c   |  7 ++++++-
 fs/overlayfs/super.c     |  2 +-
 fs/overlayfs/util.c      | 20 ++++++++++++++++++++
 6 files changed, 66 insertions(+), 14 deletions(-)

diff --git a/fs/overlayfs/dir.c b/fs/overlayfs/dir.c
index 033fc0458a3d..2f3442f5430d 100644
--- a/fs/overlayfs/dir.c
+++ b/fs/overlayfs/dir.c
@@ -442,6 +442,11 @@ static int ovl_set_upper_acl(struct ovl_fs *ofs, struct dentry *upperdentry,
 	return ovl_do_set_acl(ofs, upperdentry, acl_name, acl);
 }
 
+static bool ovl_cattr_is_whiteout(struct ovl_cattr *attr)
+{
+	return S_ISCHR(attr->mode) && attr->rdev == WHITEOUT_DEV;
+}
+
 static int ovl_create_over_whiteout(struct dentry *dentry, struct inode *inode,
 				    struct ovl_cattr *cattr)
 {
@@ -477,7 +482,8 @@ static int ovl_create_over_whiteout(struct dentry *dentry, struct inode *inode,
 		goto out_unlock;
 
 	err = -ESTALE;
-	if (d_is_negative(upper) || !IS_WHITEOUT(d_inode(upper)))
+	if (!ovl_cattr_is_whiteout(cattr) &&
+	    (d_is_negative(upper) || !ovl_upper_is_whiteout(ofs, upper)))
 		goto out_dput;
 
 	newdentry = ovl_create_temp(ofs, workdir, cattr);
@@ -485,6 +491,13 @@ static int ovl_create_over_whiteout(struct dentry *dentry, struct inode *inode,
 	if (IS_ERR(newdentry))
 		goto out_dput;
 
+	if (ovl_cattr_is_whiteout(cattr)) {
+		err = ovl_setxattr(ofs, newdentry, OVL_XATTR_NOWHITEOUT,
+				   NULL, 0);
+		if (err < 0)
+			goto out_cleanup;
+	}
+
 	/*
 	 * mode could have been mutilated due to umask (e.g. sgid directory)
 	 */
@@ -606,7 +619,8 @@ static int ovl_create_or_link(struct dentry *dentry, struct inode *inode,
 		put_cred(override_cred);
 	}
 
-	if (!ovl_dentry_is_whiteout(dentry))
+	/* Create whiteouts in workdir so we can atomically set nowiteout xattr */
+	if (!ovl_dentry_is_whiteout(dentry) && !ovl_cattr_is_whiteout(attr))
 		err = ovl_create_upper(dentry, inode, attr);
 	else
 		err = ovl_create_over_whiteout(dentry, inode, attr);
@@ -669,10 +683,6 @@ static int ovl_mkdir(struct mnt_idmap *idmap, struct inode *dir,
 static int ovl_mknod(struct mnt_idmap *idmap, struct inode *dir,
 		     struct dentry *dentry, umode_t mode, dev_t rdev)
 {
-	/* Don't allow creation of "whiteout" on overlay */
-	if (S_ISCHR(mode) && rdev == WHITEOUT_DEV)
-		return -EPERM;
-
 	return ovl_create_object(dentry, mode, rdev, NULL);
 }
 
@@ -1219,7 +1229,7 @@ static int ovl_rename(struct mnt_idmap *idmap, struct inode *olddir,
 		}
 	} else {
 		if (!d_is_negative(newdentry)) {
-			if (!new_opaque || !ovl_is_whiteout(newdentry))
+			if (!new_opaque || !ovl_upper_is_whiteout(ofs, newdentry))
 				goto out_dput;
 		} else {
 			if (flags & RENAME_EXCHANGE)
diff --git a/fs/overlayfs/namei.c b/fs/overlayfs/namei.c
index 80391c687c2a..e90167789a13 100644
--- a/fs/overlayfs/namei.c
+++ b/fs/overlayfs/namei.c
@@ -251,7 +251,9 @@ static int ovl_lookup_single(struct dentry *base, struct ovl_lookup_data *d,
 		err = -EREMOTE;
 		goto out_err;
 	}
-	if (ovl_is_whiteout(this)) {
+	path.dentry = this;
+	path.mnt = d->mnt;
+	if (ovl_path_is_whiteout(OVL_FS(d->sb), &path)) {
 		d->stop = d->opaque = true;
 		goto put_and_out;
 	}
@@ -264,8 +266,6 @@ static int ovl_lookup_single(struct dentry *base, struct ovl_lookup_data *d,
 		goto put_and_out;
 	}
 
-	path.dentry = this;
-	path.mnt = d->mnt;
 	if (!d_can_lookup(this)) {
 		if (d->is_dir || !last_element) {
 			d->stop = true;
@@ -438,7 +438,7 @@ int ovl_check_origin_fh(struct ovl_fs *ofs, struct ovl_fh *fh, bool connected,
 	else if (IS_ERR(origin))
 		return PTR_ERR(origin);
 
-	if (upperdentry && !ovl_is_whiteout(upperdentry) &&
+	if (upperdentry && !ovl_upper_is_whiteout(ofs, upperdentry) &&
 	    inode_wrong_type(d_inode(upperdentry), d_inode(origin)->i_mode))
 		goto invalid;
 
@@ -1383,7 +1383,11 @@ bool ovl_lower_positive(struct dentry *dentry)
 				break;
 			}
 		} else {
-			positive = !ovl_is_whiteout(this);
+			struct path path = {
+				.dentry = this,
+				.mnt = parentpath->layer->mnt,
+			};
+			positive = !ovl_path_is_whiteout(OVL_FS(dentry->d_sb), &path);
 			done = true;
 			dput(this);
 		}
diff --git a/fs/overlayfs/overlayfs.h b/fs/overlayfs/overlayfs.h
index 311e1f37ce84..33d4c0011bb9 100644
--- a/fs/overlayfs/overlayfs.h
+++ b/fs/overlayfs/overlayfs.h
@@ -49,6 +49,7 @@ enum ovl_xattr {
 	OVL_XATTR_UUID,
 	OVL_XATTR_METACOPY,
 	OVL_XATTR_PROTATTR,
+	OVL_XATTR_NOWHITEOUT,
 };
 
 enum ovl_inode_flag {
@@ -469,16 +470,28 @@ void ovl_inode_update(struct inode *inode, struct dentry *upperdentry);
 void ovl_dir_modified(struct dentry *dentry, bool impurity);
 u64 ovl_inode_version_get(struct inode *inode);
 bool ovl_is_whiteout(struct dentry *dentry);
+bool ovl_path_is_whiteout(struct ovl_fs *ofs, const struct path *path);
 struct file *ovl_path_open(const struct path *path, int flags);
 int ovl_copy_up_start(struct dentry *dentry, int flags);
 void ovl_copy_up_end(struct dentry *dentry);
 bool ovl_already_copied_up(struct dentry *dentry, int flags);
 bool ovl_path_check_dir_xattr(struct ovl_fs *ofs, const struct path *path,
 			      enum ovl_xattr ox);
+bool ovl_path_check_nowhiteout_xattr(struct ovl_fs *ofs, const struct path *path);
 bool ovl_path_check_origin_xattr(struct ovl_fs *ofs, const struct path *path);
 bool ovl_init_uuid_xattr(struct super_block *sb, struct ovl_fs *ofs,
 			 const struct path *upperpath);
 
+static inline bool ovl_upper_is_whiteout(struct ovl_fs *ofs,
+					 struct dentry *upperdentry)
+{
+	struct path upperpath = {
+		.dentry = upperdentry,
+		.mnt = ovl_upper_mnt(ofs),
+	};
+	return ovl_path_is_whiteout(ofs, &upperpath);
+}
+
 static inline bool ovl_check_origin_xattr(struct ovl_fs *ofs,
 					  struct dentry *upperdentry)
 {
diff --git a/fs/overlayfs/readdir.c b/fs/overlayfs/readdir.c
index de39e067ae65..9cf8e7e2961c 100644
--- a/fs/overlayfs/readdir.c
+++ b/fs/overlayfs/readdir.c
@@ -280,7 +280,12 @@ static int ovl_check_whiteouts(const struct path *path, struct ovl_readdir_data
 			rdd->first_maybe_whiteout = p->next_maybe_whiteout;
 			dentry = lookup_one(mnt_idmap(path->mnt), p->name, dir, p->len);
 			if (!IS_ERR(dentry)) {
-				p->is_whiteout = ovl_is_whiteout(dentry);
+				struct path childpath = {
+					.dentry = dentry,
+					.mnt = path->mnt,
+				};
+				p->is_whiteout = ovl_path_is_whiteout(OVL_FS(rdd->dentry->d_sb),
+								      &childpath);
 				dput(dentry);
 			}
 		}
diff --git a/fs/overlayfs/super.c b/fs/overlayfs/super.c
index a3be13306c73..995c21349bb9 100644
--- a/fs/overlayfs/super.c
+++ b/fs/overlayfs/super.c
@@ -579,7 +579,7 @@ static int ovl_check_rename_whiteout(struct ovl_fs *ofs)
 	if (IS_ERR(whiteout))
 		goto cleanup_temp;
 
-	err = ovl_is_whiteout(whiteout);
+	err = ovl_upper_is_whiteout(ofs, whiteout);
 
 	/* Best effort cleanup of whiteout and temp file */
 	if (err)
diff --git a/fs/overlayfs/util.c b/fs/overlayfs/util.c
index 0f387092450e..da6d2abf64dd 100644
--- a/fs/overlayfs/util.c
+++ b/fs/overlayfs/util.c
@@ -575,6 +575,16 @@ bool ovl_is_whiteout(struct dentry *dentry)
 	return inode && IS_WHITEOUT(inode);
 }
 
+/*
+ * Use this over ovl_is_whiteout for upper and lower files, as it also
+ * handles escaped whiteout files.
+ */
+bool ovl_path_is_whiteout(struct ovl_fs *ofs, const struct path *path)
+{
+	return ovl_is_whiteout(path->dentry) &&
+		!ovl_path_check_nowhiteout_xattr(ofs, path);
+}
+
 struct file *ovl_path_open(const struct path *path, int flags)
 {
 	struct inode *inode = d_inode(path->dentry);
@@ -663,6 +673,14 @@ void ovl_copy_up_end(struct dentry *dentry)
 	ovl_inode_unlock(d_inode(dentry));
 }
 
+bool ovl_path_check_nowhiteout_xattr(struct ovl_fs *ofs, const struct path *path)
+{
+	int res;
+
+	res = ovl_path_getxattr(ofs, path, OVL_XATTR_NOWHITEOUT, NULL, 0);
+	return res >= 0;
+}
+
 bool ovl_path_check_origin_xattr(struct ovl_fs *ofs, const struct path *path)
 {
 	int res;
@@ -760,6 +778,7 @@ bool ovl_path_check_dir_xattr(struct ovl_fs *ofs, const struct path *path,
 #define OVL_XATTR_UUID_POSTFIX		"uuid"
 #define OVL_XATTR_METACOPY_POSTFIX	"metacopy"
 #define OVL_XATTR_PROTATTR_POSTFIX	"protattr"
+#define OVL_XATTR_NOWHITEOUT_POSTFIX	"nowhiteout"
 
 #define OVL_XATTR_TAB_ENTRY(x) \
 	[x] = { [false] = OVL_XATTR_TRUSTED_PREFIX x ## _POSTFIX, \
@@ -775,6 +794,7 @@ const char *const ovl_xattr_table[][2] = {
 	OVL_XATTR_TAB_ENTRY(OVL_XATTR_UUID),
 	OVL_XATTR_TAB_ENTRY(OVL_XATTR_METACOPY),
 	OVL_XATTR_TAB_ENTRY(OVL_XATTR_PROTATTR),
+	OVL_XATTR_TAB_ENTRY(OVL_XATTR_NOWHITEOUT),
 };
 
 int ovl_check_setxattr(struct ovl_fs *ofs, struct dentry *upperdentry,
-- 
2.41.0

