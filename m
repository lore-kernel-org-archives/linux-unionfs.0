Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.219.49
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793236190;
	b=sMj1ixx6jp++xgQFJpZrLmTKWT7i7FPWJLYU8E2RWGnBd/1RSQZ/ybQ778miPbJQHPQk
	 jJNRNfsx0AiDXDVIDJiE3QVkvAZl+I/z/OybLjdzKtg9FEpNb4C9Uu4mZUSNiLbir8j6D
	 wOcJFsTD6pWDd2kEcv6/9qZqDZlluQsOCx/zuGMEI1NpQ+zNKdmN82Jg9ZDaCAvxPDGaz
	 VDyarLOnvC+sQFV+hHHQju7uEEDdpYliob3b2SoULRDe2dvikMA8a7YQ/ZJVjMRdBJZBj
	 63k2r5oFt5mj5XKu+D4jDPiAvRQ6RZgop521nLzA/BoI1FJJYY3h+u4OrnmmbxzYu/g==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793236190;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 From:Date:Subject:MIME-Version:Content-Type:Content-Transfer-Encoding:
	 Message-Id:References:In-Reply-To:To:Cc:X-Mailer:
	 X-Developer-Signature:X-Developer-Key;
	bh=xmvlffb9sJA63Jov/NeAQNYe2BkSsXwTH1TRPTCyV8M=;
	b=mf3pUO1X+2tCN8UXkfNf1K9XKyU5yYjX9EtgAHLKXNO0zGc9pzmbYJ/y7Vk0bMaaaRyh
	 bgk6TGCNu3chtrfb6dYD+nh0lQLA3mVMgfeqhMa4WQrGxYjeZKeQlONj/VHQi5XsaRCY8
	 dElQnWXWy2/3hDZVB2OWCRQM65/oju/Z7d7XfSV09sUUoMgbzHrpFX84eHMBc7DBYS1xK
	 Z9cbmuL6fR3jS0sNno8/yvct+viL+haJlsDoD4oQ9rJEaCuLrdivQzIrgw76lRH5/5o9R
	 +XCTkh1e6V2V6MFyDCbMxPJOTInCUvE48zwVl4nhPzjxwumsOCC5jzGkeJNaHBBarzQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=none header.from=toxicpanda.com;
	spf=pass smtp.mailfrom=toxicpanda.com;
	dkim=pass header.d=toxicpanda.com header.i=@toxicpanda.com header.a=rsa-sha256 header.s=google header.b=oHNI9kfB;
	arc=none smtp.remote-ip=209.85.219.49
Received: from mail-qv1-f49.google.com (mail-qv1-f49.google.com [209.85.219.49])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CFB2F60A2627
	for <linux-unionfs@vger.kernel.org>; Thu, 29 Oct 2026 01:09:49 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org CFB2F60A2627
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=toxicpanda.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=toxicpanda.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=toxicpanda.com header.i=@toxicpanda.com header.a=rsa-sha256 header.s=google header.b=oHNI9kfB
Received: by mail-qv1-f49.google.com with SMTP id 6a1803df08f44-91b54d1e9cdso13002726d6.1
        for <linux-unionfs@vger.kernel.org>; Wed, 28 Oct 2026 18:09:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=toxicpanda.com; s=google; t=1793236189; x=1793840989; darn=vger.kernel.org;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :content-type:mime-version:subject:date:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=xmvlffb9sJA63Jov/NeAQNYe2BkSsXwTH1TRPTCyV8M=;
        b=oHNI9kfBcd+AqlDVaCaJnCuxe5Y6Zmoh6EqB/wbMvVjLtwLlxBHCm7x4dWOZ/OQBq2
         0M7rE3uPGklzd6RnLt8aGRI0zUm05+ZwDj2cLFPeZPTlqQQSO4UurtbrsUxwoJAiDYMQ
         jGc8jQ9F9ERQqtd/ER0Yw9huoiSRhiWJCJHtCjfjR3et8C1Ncep4BDHguWuL5ndxffcR
         clhdPtOIPs28T9K/EQkkHCn52lDpmGQXlSeghuMqnIsdOfBUmxMryJjiUECpdLzgrDwW
         eYJ4YNw7l5jhgMSwhcCVP6lVEhDRnAcnWzmHMMHY6YXpmI5Bn/NYv1twZ6Pl3kOHSqld
         fRtw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793236189; x=1793840989;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :content-type:mime-version:subject:date:from:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=xmvlffb9sJA63Jov/NeAQNYe2BkSsXwTH1TRPTCyV8M=;
        b=0escgetfnPcw+2LAGWDffKhTFBXbDLkt3YSWfhgBZ52OLQsgg66nHfCGpHsl0NIpTH
         IJRJq7Yh2a8irv6DOnoXirFTv+rwHn3Nj+h00xp2jZUnOwfIlAJk+Bnk4pnY+U3+sS0J
         8o8nJDepQxEMrOejzOL0VkFpqZWj4Yugltm+oTHgjcgKqGRwPtrZRLF/Rlgg5+ZZWBGS
         oi2vx0C/UupgcP2SJyujp4F2z9mbWTTAYWCnn95yI3VbWm4otfDm/Tps0JzYKHoaUVIr
         Td0G1/CxgGDztZh7DCnlICuUzu+XTWay7gmg1l9dmTxBF9VR6lTLbX58dvWYWLR2Gli+
         YyRA==
X-Forwarded-Encrypted: i=1; AKwUvBw5iAB5RlkZi28D2aOzVAM/kMS1Lh1tL3S3t5Q/acfPAsCJXwgwMQ711JBE3ZT05F/UlfXlrVE4KO+osDWR@vger.kernel.org
X-Gm-Message-State: AFq9FYJFJ5mM5LI2Pj7L7WY1JEHTv8Fbs+8EbcGI6I2M7wBOy8iOqxWC
	tMLTI5Zq+ER/+95QW54FWAAGo/eKST82WdWSOMlG3fgEF8qzsaUsX8DswBhzIHuobps=
X-Gm-Gg: AYBFou1j0SMDexx+CmU1tmfdN7+cyVnFiE5zKux9mV2OoEmbCtz9eOtYKHnhF7/NRcp
	MWkit+Sx2aGaZ6fV892KFxypOTOYTW4xZgRaORoi09ecZXBv/Oo0rVxITY7dG6+GtRk4E/b5fEI
	vu88NdWC/otiTe6GnhgX2b6HB1lfnRxElbXwu6E0eVNGI4IPO6hDPF8q3p+WXQVB4UsUt5oeM5b
	mN1BXRQMTeG0bbBh07gaLAK85EayUcD+8RwxZvQsjRwFbmJENPALMlYs2fDi1a7AcvXP15v51XH
	2uve1uxvpFHobixnEqNPb2D/XRe5FPCySw0yFqi+O9g9EI+nupADaJcHRqZCuA7/PXjZMJo6qm+
	9GPTju8aMOTQsPTI9JQSSrWEyqSz+w8FWAoqNUUG1WJ7FfOuYnKSRqhzdM618oIqvqqzM5HjHbd
	CUX2SdX1Y5HbcA/Vw6SaN9Ej3EULHx0Tap8mDuUE8LY8xnV2nkL2lnqWo/LK0/0i+NqNfXgWN/k
	6vebwi+4uy+5y7a6JN/cmCAK6UWS/UkR5YiyWzlBFW17+AvZlFoF8JUToWcKlz1aljjYNz46Wwa
	9AMUJu1n/0dKifLbGtE9QIV0nWHIO4+p6i/cDXRHSgAEkiU9wF1Ix3Mfo9eUGPOgl6c=
X-Received: by 2002:a05:620a:461e:b0:93b:be6d:4f3e with SMTP id af79cd13be357-94408a71220mr638379685a.25.1793236188829;
        Wed, 28 Oct 2026 18:09:48 -0700 (PDT)
Received: from toxicpanda.com ([153.61.196.250])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-91c47cb4f56sm147358106d6.35.2026.10.28.18.09.47
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 28 Oct 2026 18:09:48 -0700 (PDT)
From: Josef Bacik <josef@toxicpanda.com>
Date: Thu, 29 Oct 2026 01:09:23 +0000
Subject: [PATCH v2 09/10] ovl: put modified upper inodes on the dirty list
X-Mailing-List: linux-unionfs@vger.kernel.org
List-Id: <linux-unionfs.vger.kernel.org>
List-Post: <mailto:linux-unionfs@vger.kernel.org>
List-Help: <mailto:linux-unionfs+help@vger.kernel.org>
List-Subscribe: <mailto:linux-unionfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-unionfs+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-unionfs+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20261029-b4-ovl-containerized-sync-v2-9-4e9f08e4a052@toxicpanda.com>
References: <20261029-b4-ovl-containerized-sync-v2-0-4e9f08e4a052@toxicpanda.com>
In-Reply-To: <20261029-b4-ovl-containerized-sync-v2-0-4e9f08e4a052@toxicpanda.com>
To: Miklos Szeredi <miklos@szeredi.hu>, Amir Goldstein <amir73il@gmail.com>, 
 Christian Brauner <brauner@kernel.org>
Cc: Alexander Viro <viro@zeniv.linux.org.uk>, Jan Kara <jack@suse.cz>, 
 Christoph Hellwig <hch@infradead.org>, Chris Mason <mason@kernel.org>, 
 Chengguang Xu <cgxu519@mykernel.net>, linux-unionfs@vger.kernel.org, 
 linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org, 
 Josef Bacik <josef@toxicpanda.com>
X-Mailer: b4 0.15.2
X-Developer-Signature: v=1; a=openssh-sha256; t=1793236166; l=17450;
 i=josef@toxicpanda.com; h=from:subject:message-id;
 bh=MLygtTnd0ORLTEDigWqPvHn6/Jg0aMRaXaBUQI8orn4=;
 b=U1NIU0lHAAAAAQAAADMAAAALc3NoLWVkMjU1MTkAAAAgUBr36M/n0nWN0DNbnxwzIiCZez6MG
 JiruuNaSCI/zXsAAAAGcGF0YXR0AAAAAAAAAAZzaGE1MTIAAABTAAAAC3NzaC1lZDI1NTE5AAAA
 QMxFRQCMQLbgVLKXFN82fVqf8ya6FIG+Eb9NJQF/LC+M9LeYKDxsPdCyhTcxwbpjPTosglKSeaR
 0Zzh+VtoSogQ=
X-Developer-Key: i=josef@toxicpanda.com; a=openssh;
 fpr=SHA256:C8kOX2QUJCMqnCX+KEeoqRAjLo9L+ELOSH2NSAJHqGA

Many upper inodes that overlayfs modifies have no overlay inode that could
be on the dirty list: whiteouts, index entries, the work directories.

overlayfs modifies the namespace and the attributes of the upper filesystem
through the ovl_do_*() helpers, and each helper knows which upper inodes it
touches.  Have them call ovl_upper_modified(), which gives the upper inode
a fake overlay inode and marks that dirty.  A fake inode is hashed by the
real inode and has no dentry, like a trap inode.  From there on it is an
ordinary dirty overlay inode.

An upper inode only gets a fake inode if the VFS considers it dirty,
sync_filesystem() would not write it otherwise.  The flusher clears the
dirty flags when it starts, so also look at I_SYNC and the page cache tags.

If there is no memory for a fake inode, write the upper inode right away.
If that fails, or the lookup of the whiteout that RENAME_WHITEOUT made, the
next syncfs() returns the error.

Not covered: the atime of an upper directory that cannot be opened with
O_NOATIME, and inodes that the upper filesystem dirties on its own, like
the quota file of ext2 and jfs.

Signed-off-by: Josef Bacik <josef@toxicpanda.com>
---
 fs/overlayfs/inode.c     | 107 ++++++++++++++++++++++++++++++++++++++++++++++-
 fs/overlayfs/overlayfs.h |  90 +++++++++++++++++++++++++++++++--------
 fs/overlayfs/ovl_entry.h |   2 +
 fs/overlayfs/super.c     |  18 +++++---
 fs/overlayfs/util.c      |  42 +++++++++++++++++++
 5 files changed, 235 insertions(+), 24 deletions(-)

diff --git a/fs/overlayfs/inode.c b/fs/overlayfs/inode.c
index 88cec47d0bc8..85ccbb773534 100644
--- a/fs/overlayfs/inode.c
+++ b/fs/overlayfs/inode.c
@@ -13,6 +13,7 @@
 #include <linux/fileattr.h>
 #include <linux/security.h>
 #include <linux/namei.h>
+#include <linux/pagemap.h>
 #include <linux/posix_acl.h>
 #include <linux/posix_acl_xattr.h>
 #include "overlayfs.h"
@@ -752,7 +753,7 @@ int ovl_fileattr_get(struct dentry *dentry, struct file_kattr *fa)
  */
 void ovl_sync_lazytime(struct inode *inode)
 {
-	struct inode *upper = ovl_inode_upper(inode);
+	struct inode *upper = ovl_inode_upper_to_write(inode);
 
 	if (upper && (inode_state_read_once(upper) & I_DIRTY_TIME))
 		mark_inode_dirty_sync(upper);
@@ -1169,6 +1170,110 @@ struct inode *ovl_lookup_inode(struct super_block *sb, struct dentry *real,
 	return inode;
 }
 
+static const struct inode_operations ovl_fake_inode_operations = {
+	.sync_lazytime	= ovl_sync_lazytime,
+};
+
+/* The upper inode that ovl_write_inode() has to write for @inode */
+struct inode *ovl_inode_upper_to_write(struct inode *inode)
+{
+	if (ovl_test_flag(OVL_FAKE, inode))
+		return inode->i_private;
+
+	return ovl_inode_upper(inode);
+}
+
+/*
+ * Is there anything sync_filesystem() would write or wait for on @upper?
+ *
+ * The dirty flags alone cannot tell, because the flusher of the upper
+ * filesystem clears them when it starts to write the inode.  But it sets I_SYNC
+ * before it clears them, it clears I_SYNC after ->write_inode() has returned,
+ * and all of them are in one word.  The caller has modified @upper before it
+ * gets here.  So if neither a dirty flag nor I_SYNC is set, the modification
+ * has not dirtied the inode, or the flusher has handed all of it to the
+ * filesystem.  Pages whose writeback has been started but not completed show in
+ * the page cache tags.
+ */
+static bool ovl_upper_inode_dirty(struct inode *upper)
+{
+	struct address_space *mapping = upper->i_mapping;
+	unsigned int state = inode_state_read_once(upper);
+
+	/* The data of a regular file is left to its overlay inode */
+	if (S_ISREG(upper->i_mode))
+		return state & (I_DIRTY_INODE | I_DIRTY_TIME | I_SYNC);
+
+	return (state & (I_DIRTY_ALL | I_SYNC)) ||
+	       mapping_tagged(mapping, PAGECACHE_TAG_DIRTY) ||
+	       mapping_tagged(mapping, PAGECACHE_TAG_WRITEBACK);
+}
+
+/*
+ * overlayfs has modified @upper on the upper filesystem.  Many of these inodes
+ * have no overlay inode that could be on the dirty list of the overlay:
+ * whiteouts, index entries and the work directories.  Give @upper a fake
+ * overlay inode and mark that dirty.  From there on it is treated like any
+ * other dirty overlay inode.  syncfs(), unmount and the flusher find it on the
+ * dirty list, ovl_write_inode() writes @upper, and ovl_drop_inode() keeps the
+ * fake inode for as long as it is dirty.
+ *
+ * Like a trap inode, a fake inode is hashed by the real inode and has no
+ * dentry. It holds a reference to @upper.
+ *
+ * sync_filesystem() on the upper filesystem would only write the inodes that
+ * are on a dirty list there.  So an inode that the VFS does not consider dirty
+ * after it was modified does not need a fake inode.  This is the normal case
+ * for a filesystem that logs its metadata.
+ */
+void ovl_upper_modified(struct ovl_fs *ofs, struct inode *upper)
+{
+	struct inode *fake;
+
+	if (!upper || !ovl_tracks_dirty(ofs))
+		return;
+
+	/*
+	 * Nobody is going to look for an inode that has no name left.  Drop its
+	 * fake inode, so that the space of @upper is freed.
+	 */
+	if (!upper->i_nlink) {
+		fake = ovl_ilookup(ofs->sb, upper, true);
+		if (fake) {
+			/* clear_nlink() counts, it must not run twice */
+			spin_lock(&fake->i_lock);
+			clear_nlink(fake);
+			spin_unlock(&fake->i_lock);
+			iput(fake);
+		}
+		return;
+	}
+
+	if (!ovl_upper_inode_dirty(upper))
+		return;
+
+	fake = ovl_iget_locked(ofs->sb, upper, true);
+	if (!fake) {
+		/*
+		 * There is no memory to remember @upper, so write it now.  The
+		 * modification itself has succeeded, so this is not an error of
+		 * the caller.  If the write fails, the next syncfs() says so.
+		 */
+		ovl_write_upper_inode(ofs->sb, upper, OVL_WRITE_WAIT);
+		return;
+	}
+
+	if (inode_state_read_once(fake) & I_NEW) {
+		ihold(upper);
+		fake->i_mode = upper->i_mode & S_IFMT;
+		fake->i_op = &ovl_fake_inode_operations;
+		unlock_new_inode(fake);
+	}
+
+	ovl_mark_inode_dirty(fake);
+	iput(fake);
+}
+
 bool ovl_lookup_trap_inode(struct super_block *sb, struct dentry *dir)
 {
 	struct inode *key = d_inode(dir);
diff --git a/fs/overlayfs/overlayfs.h b/fs/overlayfs/overlayfs.h
index 83e25700c8a0..98a6946a96af 100644
--- a/fs/overlayfs/overlayfs.h
+++ b/fs/overlayfs/overlayfs.h
@@ -210,28 +210,58 @@ static inline const char *ovl_xattr(struct ovl_fs *ofs, enum ovl_xattr ox)
  * care to map 1000 to 1001.
  * The mnt idmapping helpers are nops if the upper layer isn't idmapped.
  */
+void ovl_upper_modified(struct ovl_fs *ofs, struct inode *upper);
+
+/*
+ * The ovl_do_*() helpers below are how overlayfs modifies the namespace and the
+ * attributes of the upper filesystem.  Each of them calls ovl_upper_modified()
+ * for all the upper inodes that it has modified, which puts them on the dirty
+ * list of the overlay.  Code that modifies the upper filesystem in another way
+ * has to mark the overlay inode of the file dirty.
+ */
 static inline int ovl_do_notify_change(struct ovl_fs *ofs,
 				       struct dentry *upperdentry,
 				       struct iattr *attr)
 {
-	return notify_change(ovl_upper_mnt_idmap(ofs), upperdentry, attr, NULL);
+	int err = notify_change(ovl_upper_mnt_idmap(ofs), upperdentry, attr,
+				NULL);
+
+	if (!err)
+		ovl_upper_modified(ofs, d_inode(upperdentry));
+	return err;
 }
 
 static inline int ovl_do_rmdir(struct ovl_fs *ofs,
 			       struct inode *dir, struct dentry *dentry)
 {
-	int err = vfs_rmdir(ovl_upper_mnt_idmap(ofs), dir, dentry, NULL);
+	struct inode *inode = d_inode(dentry);
+	int err;
 
+	ihold(inode);
+	err = vfs_rmdir(ovl_upper_mnt_idmap(ofs), dir, dentry, NULL);
 	pr_debug("rmdir(%pd2) = %i\n", dentry, err);
+	if (!err) {
+		ovl_upper_modified(ofs, dir);
+		ovl_upper_modified(ofs, inode);
+	}
+	iput(inode);
 	return err;
 }
 
 static inline int ovl_do_unlink(struct ovl_fs *ofs, struct inode *dir,
 				struct dentry *dentry)
 {
-	int err = vfs_unlink(ovl_upper_mnt_idmap(ofs), dir, dentry, NULL);
+	struct inode *inode = d_inode(dentry);
+	int err;
 
+	ihold(inode);
+	err = vfs_unlink(ovl_upper_mnt_idmap(ofs), dir, dentry, NULL);
 	pr_debug("unlink(%pd2) = %i\n", dentry, err);
+	if (!err) {
+		ovl_upper_modified(ofs, dir);
+		ovl_upper_modified(ofs, inode);
+	}
+	iput(inode);
 	return err;
 }
 
@@ -242,6 +272,10 @@ static inline int ovl_do_link(struct ovl_fs *ofs, struct dentry *old_dentry,
 			   new_dentry, NULL);
 
 	pr_debug("link(%pd2, %pd2) = %i\n", old_dentry, new_dentry, err);
+	if (!err) {
+		ovl_upper_modified(ofs, dir);
+		ovl_upper_modified(ofs, d_inode(old_dentry));
+	}
 	return err;
 }
 
@@ -252,6 +286,10 @@ static inline int ovl_do_create(struct ovl_fs *ofs,
 	int err = vfs_create(ovl_upper_mnt_idmap(ofs), dentry, mode, NULL);
 
 	pr_debug("create(%pd2, 0%o) = %i\n", dentry, mode, err);
+	if (!err) {
+		ovl_upper_modified(ofs, dir);
+		ovl_upper_modified(ofs, d_inode(dentry));
+	}
 	return err;
 }
 
@@ -266,6 +304,10 @@ static inline struct dentry *ovl_do_mkdir(struct ovl_fs *ofs,
 	pr_debug("mkdir(%pd2, 0%o)\n", dentry, mode);
 	ret = vfs_mkdir(ovl_upper_mnt_idmap(ofs), dir, dentry, mode, NULL);
 	pr_debug("...mkdir = %i\n", PTR_ERR_OR_ZERO(ret));
+	if (!IS_ERR(ret)) {
+		ovl_upper_modified(ofs, dir);
+		ovl_upper_modified(ofs, d_inode(ret));
+	}
 	return ret;
 }
 
@@ -276,6 +318,10 @@ static inline int ovl_do_mknod(struct ovl_fs *ofs,
 	int err = vfs_mknod(ovl_upper_mnt_idmap(ofs), dir, dentry, mode, dev, NULL);
 
 	pr_debug("mknod(%pd2, 0%o, 0%o) = %i\n", dentry, mode, dev, err);
+	if (!err) {
+		ovl_upper_modified(ofs, dir);
+		ovl_upper_modified(ofs, d_inode(dentry));
+	}
 	return err;
 }
 
@@ -286,6 +332,10 @@ static inline int ovl_do_symlink(struct ovl_fs *ofs,
 	int err = vfs_symlink(ovl_upper_mnt_idmap(ofs), dir, dentry, oldname, NULL);
 
 	pr_debug("symlink(\"%s\", %pd2) = %i\n", oldname, dentry, err);
+	if (!err) {
+		ovl_upper_modified(ofs, dir);
+		ovl_upper_modified(ofs, d_inode(dentry));
+	}
 	return err;
 }
 
@@ -336,6 +386,8 @@ static inline int ovl_do_setxattr(struct ovl_fs *ofs, struct dentry *dentry,
 
 	pr_debug("setxattr(%pd2, \"%s\", \"%*pE\", %zu, %d) = %i\n",
 		 dentry, name, min((int)size, 48), value, size, flags, err);
+	if (!err)
+		ovl_upper_modified(ofs, d_inode(dentry));
 	return err;
 }
 
@@ -351,6 +403,8 @@ static inline int ovl_do_removexattr(struct ovl_fs *ofs, struct dentry *dentry,
 {
 	int err = vfs_removexattr(ovl_upper_mnt_idmap(ofs), dentry, name);
 	pr_debug("removexattr(%pd2, \"%s\") = %i\n", dentry, name, err);
+	if (!err)
+		ovl_upper_modified(ofs, d_inode(dentry));
 	return err;
 }
 
@@ -363,30 +417,25 @@ static inline int ovl_removexattr(struct ovl_fs *ofs, struct dentry *dentry,
 static inline int ovl_do_set_acl(struct ovl_fs *ofs, struct dentry *dentry,
 				 const char *acl_name, struct posix_acl *acl)
 {
-	return vfs_set_acl(ovl_upper_mnt_idmap(ofs), dentry, acl_name, acl);
+	int err = vfs_set_acl(ovl_upper_mnt_idmap(ofs), dentry, acl_name, acl);
+
+	if (!err)
+		ovl_upper_modified(ofs, d_inode(dentry));
+	return err;
 }
 
 static inline int ovl_do_remove_acl(struct ovl_fs *ofs, struct dentry *dentry,
 				    const char *acl_name)
 {
-	return vfs_remove_acl(ovl_upper_mnt_idmap(ofs), dentry, acl_name);
-}
+	int err = vfs_remove_acl(ovl_upper_mnt_idmap(ofs), dentry, acl_name);
 
-static inline int ovl_do_rename_rd(struct ovl_fs *ofs,
-				   struct renamedata *rd)
-{
-	int err;
-
-	pr_debug("rename(%pd2, %pd2, 0x%x)\n", rd->old_dentry, rd->new_dentry,
-		 rd->flags);
-	err = vfs_rename(rd);
-	if (err) {
-		pr_debug("...rename(%pd2, %pd2, ...) = %i\n",
-			 rd->old_dentry, rd->new_dentry, err);
-	}
+	if (!err)
+		ovl_upper_modified(ofs, d_inode(dentry));
 	return err;
 }
 
+int ovl_do_rename_rd(struct ovl_fs *ofs, struct renamedata *rd);
+
 static inline int ovl_do_rename(struct ovl_fs *ofs, struct dentry *olddir,
 				struct dentry *olddentry, struct dentry *newdir,
 				struct dentry *newdentry, unsigned int flags)
@@ -408,6 +457,10 @@ static inline int ovl_do_whiteout(struct ovl_fs *ofs,
 {
 	int err = vfs_whiteout(ovl_upper_mnt_idmap(ofs), dir, dentry);
 	pr_debug("whiteout(%pd2) = %i\n", dentry, err);
+	if (!err) {
+		ovl_upper_modified(ofs, dir);
+		ovl_upper_modified(ofs, d_inode(dentry));
+	}
 	return err;
 }
 
@@ -516,6 +569,7 @@ const struct ovl_layer *ovl_layer_lower(struct dentry *dentry);
 struct dentry *ovl_dentry_real(struct dentry *dentry);
 struct dentry *ovl_i_dentry_upper(struct inode *inode);
 struct inode *ovl_inode_upper(struct inode *inode);
+struct inode *ovl_inode_upper_to_write(struct inode *inode);
 
 /* How ovl_write_upper_inode() writes an upper inode */
 enum ovl_write_mode {
diff --git a/fs/overlayfs/ovl_entry.h b/fs/overlayfs/ovl_entry.h
index ac07e8769f9b..ed9a3a959fc0 100644
--- a/fs/overlayfs/ovl_entry.h
+++ b/fs/overlayfs/ovl_entry.h
@@ -85,6 +85,8 @@ struct ovl_fs {
 	int xino_mode;
 	/* For allocation of non-persistent inode numbers */
 	atomic_long_t last_ino;
+	/* For ovl_upper_modified(), which only gets to see upper inodes */
+	struct super_block *sb;
 	/* Shared whiteout cache */
 	struct dentry *whiteout;
 	bool no_shared_whiteout;
diff --git a/fs/overlayfs/super.c b/fs/overlayfs/super.c
index c43f8fdd6230..84258edb5530 100644
--- a/fs/overlayfs/super.c
+++ b/fs/overlayfs/super.c
@@ -235,6 +235,8 @@ static void ovl_destroy_inode(struct inode *inode)
 {
 	struct ovl_inode *oi = OVL_I(inode);
 
+	if (ovl_test_flag(OVL_FAKE, inode))
+		iput(inode->i_private);
 	dput(oi->__upperdentry);
 	ovl_stack_put(ovl_lowerstack(oi->oe), ovl_numlower(oi->oe));
 	if (S_ISDIR(inode->i_mode))
@@ -336,12 +338,16 @@ static int ovl_statfs(struct dentry *dentry, struct kstatfs *buf)
  * the mapping goes away at the latest.  i_writecount drops after that, when the
  * file is released, with the full barrier of the last fput() in between.
  */
-static bool ovl_upper_unfinished(struct inode *upper)
+static bool ovl_upper_unfinished(struct inode *inode, struct inode *upper)
 {
 	struct address_space *mapping = upper->i_mapping;
 
-	return atomic_read_acquire(&upper->i_writecount) > 0 ||
-	       mapping_tagged(mapping, PAGECACHE_TAG_DIRTY) ||
+	/* A file that can be mapped has an overlay inode, which keeps track */
+	if (!ovl_test_flag(OVL_FAKE, inode) &&
+	    atomic_read_acquire(&upper->i_writecount) > 0)
+		return true;
+
+	return mapping_tagged(mapping, PAGECACHE_TAG_DIRTY) ||
 	       mapping_tagged(mapping, PAGECACHE_TAG_WRITEBACK) ||
 	       (inode_state_read_once(upper) & (I_DIRTY | I_SYNC));
 }
@@ -395,7 +401,7 @@ static void ovl_park_inode(struct inode *inode)
 
 static int ovl_write_inode(struct inode *inode, struct writeback_control *wbc)
 {
-	struct inode *upper = ovl_inode_upper(inode);
+	struct inode *upper = ovl_inode_upper_to_write(inode);
 	int ret = 0;
 
 	if (!upper)
@@ -411,7 +417,7 @@ static int ovl_write_inode(struct inode *inode, struct writeback_control *wbc)
 		ret = ovl_write_upper_inode(inode->i_sb, upper,
 					    ovl_write_mode(inode, upper, wbc));
 
-	if (ovl_upper_unfinished(upper))
+	if (ovl_upper_unfinished(inode, upper))
 		ovl_mark_inode_dirty(inode);
 	else if (inode_state_read_once(upper) & I_DIRTY_TIME)
 		ovl_park_inode(inode);
@@ -1697,6 +1703,8 @@ int ovl_fill_super(struct super_block *sb, struct fs_context *fc)
 	struct ovl_fs *ofs = sb->s_fs_info;
 	int err;
 
+	ofs->sb = sb;
+
 	err = -EINVAL;
 	/* The fscontext fd may have been passed to another user namespace. */
 	if (fc->user_ns != current_user_ns())
diff --git a/fs/overlayfs/util.c b/fs/overlayfs/util.c
index 76e090b2a0c5..ff43f8c39979 100644
--- a/fs/overlayfs/util.c
+++ b/fs/overlayfs/util.c
@@ -1580,3 +1580,45 @@ int ovl_write_upper_inode(struct super_block *sb, struct inode *upper,
 		errseq_set(&sb->s_wb_err, err);
 	return err;
 }
+
+int ovl_do_rename_rd(struct ovl_fs *ofs, struct renamedata *rd)
+{
+	struct inode *target = d_inode(rd->new_dentry);
+	struct name_snapshot old_name;
+	struct dentry *whiteout;
+	int err;
+
+	pr_debug("rename(%pd2, %pd2, 0x%x)\n", rd->old_dentry, rd->new_dentry,
+		 rd->flags);
+
+	/* The old dentry is going to have the new name */
+	take_dentry_name_snapshot(&old_name, rd->old_dentry);
+
+	err = vfs_rename(rd);
+	if (err) {
+		pr_debug("...rename(%pd2, %pd2, ...) = %i\n",
+			 rd->old_dentry, rd->new_dentry, err);
+		goto out;
+	}
+
+	ovl_upper_modified(ofs, d_inode(rd->old_parent));
+	ovl_upper_modified(ofs, d_inode(rd->new_parent));
+	ovl_upper_modified(ofs, d_inode(rd->old_dentry));
+	ovl_upper_modified(ofs, target);
+
+	/* The upper filesystem has made this inode itself, so look it up */
+	if ((rd->flags & RENAME_WHITEOUT) && ovl_tracks_dirty(ofs)) {
+		whiteout = lookup_one(rd->mnt_idmap, &old_name.name,
+				      rd->old_parent);
+		if (!IS_ERR(whiteout)) {
+			ovl_upper_modified(ofs, d_inode(whiteout));
+			dput(whiteout);
+		} else {
+			/* The rename has succeeded, let syncfs() say it */
+			errseq_set(&ofs->sb->s_wb_err, PTR_ERR(whiteout));
+		}
+	}
+out:
+	release_dentry_name_snapshot(&old_name);
+	return err;
+}

-- 
2.55.0

