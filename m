Return-Path: <linux-unionfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 141F3C04A6A
	for <linux-unionfs@archiver.kernel.org>; Wed, 16 Aug 2023 15:31:26 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1343805AbjHPPaz (ORCPT
        <rfc822;linux-unionfs@archiver.kernel.org>);
        Wed, 16 Aug 2023 11:30:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60448 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1343866AbjHPPak (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Wed, 16 Aug 2023 11:30:40 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1C00726A1
        for <linux-unionfs@vger.kernel.org>; Wed, 16 Aug 2023 08:29:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1692199792;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=CvNtcr60akNG972bDPEMRR/6fhcUzUnCTx6FgM3sKdE=;
        b=LSYKOvPrqElRUfl7uLqWcLJx2XNle95hUTAttzWERHi1cwn8/2Lu3CZc+yj0hApxP5sQpy
        wiwp+5wVJJR3y2VFu9188mDnbCjNpXOiAWTAb8pGb4QbVRxvPAsI1MPWvFRk55HeA3XAmC
        z7pANyiq2rjfLgZqJ24wYV6jSAqYvpQ=
Received: from mail-lj1-f199.google.com (mail-lj1-f199.google.com
 [209.85.208.199]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-605-mP_hiLPUMfaFDuqQ7Q3bsQ-1; Wed, 16 Aug 2023 11:29:50 -0400
X-MC-Unique: mP_hiLPUMfaFDuqQ7Q3bsQ-1
Received: by mail-lj1-f199.google.com with SMTP id 38308e7fff4ca-2b961c3af8fso68827711fa.0
        for <linux-unionfs@vger.kernel.org>; Wed, 16 Aug 2023 08:29:50 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1692199789; x=1692804589;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=CvNtcr60akNG972bDPEMRR/6fhcUzUnCTx6FgM3sKdE=;
        b=Wc59xIV1PZ7BPEdEkzu1Z1WwertrbiAgM/o20pSR2qLkVd4g3+CqK58Br8u2hv5lm5
         NpDcI4m4HFURGid602a3kKdwtOEe4JOzsgwylaIHzf5RHbCNyP45ucvEHtSPxk5iwUOo
         cQAJEajniGTwhEo+ygvdgXnJyYPL4JgKoRaz9EPi2jC5QOx072XnsHeI8HWk/GfBeMtn
         ldmF2pcwUB18j21ga1JIBu1SBOVZLbkCAIywCrJhHb3Q974Co8DZRbFRfYsvthYo3Unk
         TNQrMw81GJMESZCwNehcUbPNgOTv7vNe0423wgOxOk19Lu4oII8xeCVy9btsjwgKwTkE
         RsRA==
X-Gm-Message-State: AOJu0Yw8gnU4DPw+0jMcqi+QtCMwXubR3AI+YI68cdBWCPJ7QK2gME6J
        Q51uTBSDguKhSEZixJOA7lSbrfnaedfvbJ3A9iN2ksOHCiHO0PX0Q7BAlgrjdVcJgpLlxa5u7ws
        JbwlfNfCRFBr2wUZRFqtITakfnA==
X-Received: by 2002:a2e:9e09:0:b0:2b6:cc12:4cf3 with SMTP id e9-20020a2e9e09000000b002b6cc124cf3mr1815503ljk.48.1692199789293;
        Wed, 16 Aug 2023 08:29:49 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IF8jLEGLKi6wU71j3l5v/vf7fz6FUTBoMLsfMJ2r/aO0flMAbTxKt3TBnt4Ambs0AP1amEPNw==
X-Received: by 2002:a2e:9e09:0:b0:2b6:cc12:4cf3 with SMTP id e9-20020a2e9e09000000b002b6cc124cf3mr1815492ljk.48.1692199789090;
        Wed, 16 Aug 2023 08:29:49 -0700 (PDT)
Received: from greebo.redhat.com (c-e6a5e255.022-110-73746f36.bbcust.telenor.se. [85.226.165.230])
        by smtp.googlemail.com with ESMTPSA id c13-20020a2e9d8d000000b002b9f03729e2sm3523160ljj.36.2023.08.16.08.29.48
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 16 Aug 2023 08:29:48 -0700 (PDT)
From:   Alexander Larsson <alexl@redhat.com>
To:     miklos@szeredi.hu
Cc:     linux-unionfs@vger.kernel.org, amir73il@gmail.com,
        Alexander Larsson <alexl@redhat.com>
Subject: [PATCH 3/4] ovl: Support creation of whiteout files on overlayfs
Date:   Wed, 16 Aug 2023 17:29:41 +0200
Message-ID: <debe6ded0419607c9575e72e4956b5d5f74ad63e.1692198910.git.alexl@redhat.com>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <cover.1692198910.git.alexl@redhat.com>
References: <cover.1692198910.git.alexl@redhat.com>
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

Signed-off-by: Alexander Larsson <alexl@redhat.com>
---
 fs/overlayfs/dir.c       | 14 ++++++++------
 fs/overlayfs/namei.c     | 14 +++++++++-----
 fs/overlayfs/overlayfs.h | 13 +++++++++++++
 fs/overlayfs/readdir.c   |  7 ++++++-
 fs/overlayfs/super.c     |  2 +-
 fs/overlayfs/util.c      | 20 ++++++++++++++++++++
 6 files changed, 57 insertions(+), 13 deletions(-)

diff --git a/fs/overlayfs/dir.c b/fs/overlayfs/dir.c
index 033fc0458a3d..4ef3a473700c 100644
--- a/fs/overlayfs/dir.c
+++ b/fs/overlayfs/dir.c
@@ -199,6 +199,12 @@ struct dentry *ovl_create_real(struct ovl_fs *ofs, struct inode *dir,
 		case S_IFSOCK:
 			err = ovl_do_mknod(ofs, dir, newdentry, attr->mode,
 					   attr->rdev);
+
+			if (!err && S_ISCHR(attr->mode) && attr->rdev == WHITEOUT_DEV) {
+				err = ovl_setxattr(ofs, newdentry, OVL_XATTR_NOWHITEOUT,
+						   NULL, 0);
+			}
+
 			break;
 
 		case S_IFLNK:
@@ -477,7 +483,7 @@ static int ovl_create_over_whiteout(struct dentry *dentry, struct inode *inode,
 		goto out_unlock;
 
 	err = -ESTALE;
-	if (d_is_negative(upper) || !IS_WHITEOUT(d_inode(upper)))
+	if (d_is_negative(upper) || !ovl_upper_is_whiteout(ofs, upper))
 		goto out_dput;
 
 	newdentry = ovl_create_temp(ofs, workdir, cattr);
@@ -669,10 +675,6 @@ static int ovl_mkdir(struct mnt_idmap *idmap, struct inode *dir,
 static int ovl_mknod(struct mnt_idmap *idmap, struct inode *dir,
 		     struct dentry *dentry, umode_t mode, dev_t rdev)
 {
-	/* Don't allow creation of "whiteout" on overlay */
-	if (S_ISCHR(mode) && rdev == WHITEOUT_DEV)
-		return -EPERM;
-
 	return ovl_create_object(dentry, mode, rdev, NULL);
 }
 
@@ -1219,7 +1221,7 @@ static int ovl_rename(struct mnt_idmap *idmap, struct inode *olddir,
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
index 1dbd01719f63..853335ff26f7 100644
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
index 97bc94459f7a..71c650ba5a1a 100644
--- a/fs/overlayfs/super.c
+++ b/fs/overlayfs/super.c
@@ -688,7 +688,7 @@ static int ovl_check_rename_whiteout(struct ovl_fs *ofs)
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

