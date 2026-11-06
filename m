Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.222.169
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793972227;
	b=k/826c/ZaeuPvZAXt/iT4RHWJuiOLzKgOkE9isJv2yBipLv82jcu6fWmkkMI+28mNYep
	 OP+6M6zIg4i4Bj/VrwuBHJfIUH8oMI1kcrobeCaZCjD9+tQc0jwanNqkeBHbiG0N8Ha2i
	 +gX+EiFFIq8y92hVGU5oiy3rx0RbHz06CtAtoUf9FDKnB7+XffvUPDy/lBWWv3acBPPCd
	 9y26PLPyn0J4DnNFfgGftzcApljgHcL4tRIKqqd9SAtIjRjEE/ClY7IfIuPdOY0CnTnG1
	 APYwt4xo19DCm3LyJyLFq5L/bqznEAvwGnGe4Z8h5xvsiw7o7zTr3vHWX32KY+cDGhA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793972227;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 From:Date:Subject:MIME-Version:Content-Type:Content-Transfer-Encoding:
	 Message-Id:References:In-Reply-To:To:Cc:X-Mailer:
	 X-Developer-Signature:X-Developer-Key;
	bh=i9DWBPZG97vsGWlaJ75QaN2FoT6JlXPkF1MHhAm5KdY=;
	b=4si1ggniMl7L2MWiUIdWFfDWpJe3AIe/SKgnK/Nx9QEqYWC8OHUs3z3i/wwcIPaDoDN5
	 PbLJbf2u9e+eP5Cc2LBGLKCzljal4hPDA5OCqdGpJtxt9eL/5nS5SPn/f3X+37noTd5gD
	 9GgLTWdTIgNHJPBBXQPGl9m6aPvCJRwW29zNM+z7qpBUh0FJF6aSp7UGuauhwaOtsSaY3
	 CTh871Q93chrmaBPXrZCQatgsW1BWJj1mlSnXwT2AyUjbMztTlkcCIMscUT+lmrprp7yk
	 D3RHpc2edVJrQh4LPXI2N1pX7Ni8/6937OieNn+8y9ucg4bkgjqKz2CnV80mJ5mw0Iw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=none header.from=toxicpanda.com;
	spf=pass smtp.mailfrom=toxicpanda.com;
	dkim=pass header.d=toxicpanda.com header.i=@toxicpanda.com header.a=rsa-sha256 header.s=google header.b=TCr7HDMK;
	arc=none smtp.remote-ip=209.85.222.169
Received: from mail-qk1-f169.google.com (mail-qk1-f169.google.com [209.85.222.169])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 69180606D80A
	for <linux-unionfs@vger.kernel.org>; Fri,  6 Nov 2026 13:37:07 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 69180606D80A
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=toxicpanda.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=toxicpanda.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=toxicpanda.com header.i=@toxicpanda.com header.a=rsa-sha256 header.s=google header.b=TCr7HDMK
Received: by mail-qk1-f169.google.com with SMTP id af79cd13be357-93e4c00d71aso64428085a.3
        for <linux-unionfs@vger.kernel.org>; Fri, 06 Nov 2026 05:37:07 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=toxicpanda.com; s=google; t=1793972226; x=1794577026; darn=vger.kernel.org;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :content-type:mime-version:subject:date:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=i9DWBPZG97vsGWlaJ75QaN2FoT6JlXPkF1MHhAm5KdY=;
        b=TCr7HDMKDeZXF8pfcC1o+xJCEEEoghKkFCGWMb/guZ1/6Qqf6u1RiZcDnPDpG51U8p
         5wyq4P7LD173Q68MR7lZZfPc+eqrdrLUFTJk0BwL/6aynQe8YwM99Wx2vFkQr/4ZfGah
         3ffNZf2kTpAxsYEcnIFd4GvzUgS5nWbvc+0v9JryS5QK0doxJaTn95Dp739+Bc/HX6Y7
         xIcjudDXN2+6fWNjHbgbGaxp9J4h8vCGJVzKHEoySw6yYZ9Eeh43OkVU+9phUJvhD41K
         MOBKqPnlC/2xa0ATIKPv9SgBx4WZosQ4S9MTSat64L6wZC7T4/yMEUVxbSe+cxVj8R/D
         t4qQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793972226; x=1794577026;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :content-type:mime-version:subject:date:from:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=i9DWBPZG97vsGWlaJ75QaN2FoT6JlXPkF1MHhAm5KdY=;
        b=oU10tLPILX0mVSqlUEYa2ybpz/JMDxnTKwwsmsho2ETeS6i07ARoVSrtE0EG5bOc03
         xQWtP4Yy1S5qrsrUoXT74Uyp1hMz2GeRB/slh2gmLYTZodc/k6bkz/dMWaIhyLjDjHjf
         MV/QjmYMdJLG2NcWWgJbIVCToIuFmePEmphTZeg6OKRMpeYHsDsqqhJO9d1yxZHs//Tq
         GbwEVjwOPnaNVBoMg7uQ3XlVxVcrVpEL3FTZkXFF6ZCkpkkC2YRQXms08YHKXv7YtGVO
         St527PMjphrtN88KQLbwFFujomh982nyg+6pTEefi3cNpQjsYgyOjxfOzbGiysrcjFL0
         gSFw==
X-Forwarded-Encrypted: i=1; AKwUvByNcTYtA0FC3i3IoyMpclug0j62lPwv5KjHykKawmugOADJJ+jqs7aYfsQgFSAJslu6aPsmlHcrM2LashNy@vger.kernel.org
X-Gm-Message-State: APuU4Z8neFSbJabAaHTAoI4qYY1oHNklWEErCMKSkbsKOUe1Ee0C5JQA
	rut/oXBQLaEnKgRlWpk7sKkW1yNaRlfI5HSxH65a4LfUP3NjQ3A6+KXWstv9l7fuKAA=
X-Gm-Gg: AYBFou13COI4adxspxFFNJgxZqXniW3Qgds+BQhFpLQPQsL/+LD2ScQC3ge3mqi/AeC
	il7kYWHWChRrSLpx5ecbg+nXohaJbKLv1QqXIWYqavZrPaFRIpqDQGP5zSAf93Zokhamo4N6JMR
	o51CGXk5FeiiYWtfPxirmx6LZCIZOCY4mnLUEErYGqDenmXwk8mL5Nj6aTeqwOqosKqN+IYMkG8
	GIeI5/OZpPTR/28FLcEjhI/5Uo7kNCk30wEtdVV13NZ7FX+rOsHuXFbWuAjdah/XJTA9byXQPsV
	buwqq2UimS5qnEnAjiWBx3g6h4YF+8LHfc2QIdldBhSjy79PtE8UHoqCFp4o8laqiu2VKOUgnO4
	GF9F1Jbcyp05V4w8yAHZXDv4H3RLL7R0rK3wteXUgi/xTEZhz/ADbK7MgyBhS7wcQuGI6EDnjAY
	sKSKW1PS52b9RDw2krD+N4NwOvuQ2e2N8pgeVLPHbVgC40III7C8w8FVeKU3aJllCAQ8VpWdVE0
	FzZeITiglZrIZFhrPFJAglJqH4uVJPIGAyx3PwtlCcrMnWmBsGqM1jlRND5AgThfubRbK5xLNj0
	tjScb2nE2KmFh5UvXQJbx7oIpChkoBiMIQA3UsCQeNkzkA==
X-Received: by 2002:a05:620a:6c85:b0:93e:5fff:db07 with SMTP id af79cd13be357-945f354dea2mr342832685a.40.1793972226288;
        Fri, 06 Nov 2026 05:37:06 -0800 (PST)
Received: from toxicpanda.com ([153.61.196.255])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-945fdcdfa64sm51283585a.26.2026.11.06.05.37.05
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 06 Nov 2026 05:37:05 -0800 (PST)
From: Josef Bacik <josef@toxicpanda.com>
Date: Fri, 06 Nov 2026 13:36:47 +0000
Subject: [PATCH v4 5/8] ovl: implement overlayfs' own ->write_inode
 operation
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
Message-Id: <20261106-b4-ovl-containerized-sync-v4-5-6ddde0b7dd8a@toxicpanda.com>
References: <20261106-b4-ovl-containerized-sync-v4-0-6ddde0b7dd8a@toxicpanda.com>
In-Reply-To: <20261106-b4-ovl-containerized-sync-v4-0-6ddde0b7dd8a@toxicpanda.com>
To: Miklos Szeredi <miklos@szeredi.hu>, Amir Goldstein <amir73il@gmail.com>, 
 Christian Brauner <brauner@kernel.org>
Cc: Alexander Viro <viro@zeniv.linux.org.uk>, Jan Kara <jack@suse.cz>, 
 Christoph Hellwig <hch@infradead.org>, Chris Mason <mason@kernel.org>, 
 Chengguang Xu <cgxu519@mykernel.net>, linux-unionfs@vger.kernel.org, 
 linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org, 
 Chengguang Xu <charliecgxu@tencent.com>, Josef Bacik <josef@toxicpanda.com>
X-Mailer: b4 0.15.2
X-Developer-Signature: v=1; a=openssh-sha256; t=1793972217; l=8161;
 i=josef@toxicpanda.com; h=from:subject:message-id;
 bh=tGLyX/F+nQv38pMSbxQo0bGFOhSgR86uTpBVYhaZh1Y=;
 b=U1NIU0lHAAAAAQAAADMAAAALc3NoLWVkMjU1MTkAAAAgUBr36M/n0nWN0DNbnxwzIiCZez6MG
 JiruuNaSCI/zXsAAAAGcGF0YXR0AAAAAAAAAAZzaGE1MTIAAABTAAAAC3NzaC1lZDI1NTE5AAAA
 QLnMLw/NVbW7zeSSW4cvN49qECJrylW7Blx2JqgAN65S8H6cpgKqlc+02l+JlI0eLscewuC6Fks
 /m3pDmvKOGgU=
X-Developer-Key: i=josef@toxicpanda.com; a=openssh;
 fpr=SHA256:C8kOX2QUJCMqnCX+KEeoqRAjLo9L+ELOSH2NSAJHqGA

From: Chengguang Xu <charliecgxu@tencent.com>

Sync dirty data and meta of upper inode in overlayfs' ->write_inode()
and redirty overlayfs' inode.

The overlay inode is only redirtied while the upper inode is open for
writing, dirty or under writeback.  So a clean overlay inode means that
everything written through it has been written back.

The periodic pass of the flusher does not write the upper inode, the
flusher of the upper filesystem does that.  syncfs() waits for the data and
leaves the commit to ->sync_fs(), like sync_inodes_sb() does with for_sync.

The VFS ignores the return value of ->write_inode(), so record errors in
s_wb_err of the overlay for the next syncfs().

Signed-off-by: Chengguang Xu <charliecgxu@tencent.com>
[josef: everything after the first paragraph]
Signed-off-by: Josef Bacik <josef@toxicpanda.com>
---
 fs/overlayfs/overlayfs.h | 13 +++++++++
 fs/overlayfs/super.c     | 75 ++++++++++++++++++++++++++++++++++++++++++++++++
 fs/overlayfs/util.c      | 56 ++++++++++++++++++++++++++++++++++++
 3 files changed, 144 insertions(+)

diff --git a/fs/overlayfs/overlayfs.h b/fs/overlayfs/overlayfs.h
index 5a1479863a6f..1cc682f28cc3 100644
--- a/fs/overlayfs/overlayfs.h
+++ b/fs/overlayfs/overlayfs.h
@@ -512,6 +512,19 @@ const struct ovl_layer *ovl_layer_lower(struct dentry *dentry);
 struct dentry *ovl_dentry_real(struct dentry *dentry);
 struct dentry *ovl_i_dentry_upper(struct inode *inode);
 struct inode *ovl_inode_upper(struct inode *inode);
+
+/* How ovl_write_upper_inode() writes an upper inode */
+enum ovl_write_mode {
+	/* Start the writeback and do not wait for it */
+	OVL_WRITE_START,
+	/* Wait for the data, ->sync_fs() is going to commit the metadata */
+	OVL_WRITE_WAIT,
+	/* A write_inode_now() that waits, for a caller that is not a sync */
+	OVL_WRITE_COMMIT,
+};
+
+int ovl_write_upper_inode(struct super_block *sb, struct inode *upper,
+			  enum ovl_write_mode mode);
 struct inode *ovl_inode_lower(struct inode *inode);
 struct inode *ovl_inode_lowerdata(struct inode *inode);
 struct inode *ovl_inode_real(struct inode *inode);
diff --git a/fs/overlayfs/super.c b/fs/overlayfs/super.c
index 9eb6a5e485ee..fe4ff5c6ce07 100644
--- a/fs/overlayfs/super.c
+++ b/fs/overlayfs/super.c
@@ -15,6 +15,8 @@
 #include <linux/seq_file.h>
 #include <linux/posix_acl_xattr.h>
 #include <linux/exportfs.h>
+#include <linux/pagemap.h>
+#include <linux/writeback.h>
 #include <linux/backing-dev.h>
 #include <linux/file.h>
 #include <linux/fs_context.h>
@@ -314,12 +316,85 @@ static int ovl_statfs(struct dentry *dentry, struct kstatfs *buf)
 	return err;
 }
 
+/*
+ * Could there be anything left to write or to wait for on @upper?
+ *
+ * A task that has @upper open for writing may have it mapped, and overlayfs
+ * does not see stores through a mapping.  The mapping holds the file open.
+ *
+ * Writeback that has been started but not completed, by us or by the flusher of
+ * the upper filesystem, shows in the page cache tags.  It does not show in the
+ * dirty flags of the inode, which are cleared when writeback starts.
+ *
+ * So dirty flags that are clear say nothing.  Dirty flags that are set do say
+ * that there is something left to write.  @upper may not have been written at
+ * all, see ovl_write_inode().  And a write_inode_now() that does not wait does
+ * nothing if the flusher of the upper filesystem is writing @upper.  A
+ * modification that was made during that pass is only recorded in the flags.
+ *
+ * i_writecount has to be read first.  If it is seen at zero, the tag of a page
+ * that was dirtied through a mapping must be seen as well.  The tag is set when
+ * the mapping goes away at the latest.  i_writecount drops after that, when the
+ * file is released, with the full barrier of the last fput() in between.
+ */
+static bool ovl_upper_unfinished(struct inode *upper)
+{
+	struct address_space *mapping = upper->i_mapping;
+
+	return atomic_read_acquire(&upper->i_writecount) > 0 ||
+	       mapping_tagged(mapping, PAGECACHE_TAG_DIRTY) ||
+	       mapping_tagged(mapping, PAGECACHE_TAG_WRITEBACK) ||
+	       (inode_state_read_once(upper) & (I_DIRTY | I_SYNC));
+}
+
+static enum ovl_write_mode ovl_write_mode(struct inode *inode,
+					  struct writeback_control *wbc)
+{
+	if (wbc->sync_mode != WB_SYNC_ALL)
+		return OVL_WRITE_START;
+
+	/*
+	 * syncfs() and unmount call ovl_sync_fs() next.  While the overlay is
+	 * being mounted, iput() writes a dirty inode because it cannot keep it.
+	 * Nobody has asked for that inode to be durable yet.
+	 */
+	if (wbc->for_sync || !(inode->i_sb->s_flags & SB_ACTIVE))
+		return OVL_WRITE_WAIT;
+
+	return OVL_WRITE_COMMIT;
+}
+
+static int ovl_write_inode(struct inode *inode, struct writeback_control *wbc)
+{
+	struct inode *upper = ovl_inode_upper(inode);
+	int ret = 0;
+
+	if (!upper)
+		return 0;
+
+	/*
+	 * Leave periodic and background writeback to the flusher of the upper
+	 * filesystem.  @upper is on its dirty list, and it knows when the data
+	 * is old enough to be written.  All there is to do here is to find out
+	 * whether the overlay inode can be clean again.
+	 */
+	if (!wbc->for_kupdate && !wbc->for_background)
+		ret = ovl_write_upper_inode(inode->i_sb, upper,
+					    ovl_write_mode(inode, wbc));
+
+	if (ovl_upper_unfinished(upper))
+		ovl_mark_inode_dirty(inode);
+
+	return ret;
+}
+
 static const struct super_operations ovl_super_operations = {
 	.alloc_inode	= ovl_alloc_inode,
 	.free_inode	= ovl_free_inode,
 	.destroy_inode	= ovl_destroy_inode,
 	.drop_inode	= inode_just_drop,
 	.put_super	= ovl_put_super,
+	.write_inode	= ovl_write_inode,
 	.sync_fs	= ovl_sync_fs,
 	.statfs		= ovl_statfs,
 	.show_options	= ovl_show_options,
diff --git a/fs/overlayfs/util.c b/fs/overlayfs/util.c
index f32202500b3d..ce5a1ed50521 100644
--- a/fs/overlayfs/util.c
+++ b/fs/overlayfs/util.c
@@ -14,6 +14,7 @@
 #include <linux/fileattr.h>
 #include <linux/uuid.h>
 #include <linux/namei.h>
+#include <linux/pagemap.h>
 #include <linux/ratelimit.h>
 #include <linux/overflow.h>
 #include "overlayfs.h"
@@ -1528,3 +1529,58 @@ void ovl_copyattr(struct inode *inode)
 	__ovl_copyattr(inode);
 	ovl_mark_inode_dirty(inode);
 }
+
+/*
+ * Do what sync_inodes_sb() does to an inode: wait for the data, hand the inode
+ * to the filesystem, and leave it to ->sync_fs() to commit it.  It gets there
+ * by setting for_sync, which write_inode_now() cannot be told about.  If that
+ * waits, ext4 commits a transaction for every inode.
+ */
+static int ovl_sync_upper_inode(struct inode *upper)
+{
+	int err, err2;
+
+	err = filemap_write_and_wait(upper->i_mapping);
+
+	/* A sync also writes the timestamps that lazytime defers */
+	if (inode_state_read_once(upper) & I_DIRTY_TIME)
+		mark_inode_dirty_sync(upper);
+
+	err2 = sync_inode_metadata(upper, 0);
+	/*
+	 * That does nothing if the flusher of the upper filesystem is writing
+	 * @upper, and the flusher may have looked at the inode before it was
+	 * modified.  Wait for the flusher in that case.
+	 */
+	if (inode_state_read_once(upper) & (I_DIRTY_INODE | I_SYNC))
+		err2 = sync_inode_metadata(upper, 1);
+
+	return err ? err : err2;
+}
+
+/*
+ * Write @upper for the overlay @sb.
+ *
+ * Nobody may be there to take the error.  The VFS ignores what ->write_inode()
+ * returns when it walks the dirty list.  Record the error in the superblock of
+ * the overlay, like mapping_set_error() does for a page that could not be
+ * written, so that the next syncfs() on the overlay returns it.
+ */
+int ovl_write_upper_inode(struct super_block *sb, struct inode *upper,
+			  enum ovl_write_mode mode)
+{
+	int err;
+
+	/* sync_inodes_sb() does not wait for such a filesystem either */
+	if (upper->i_sb->s_iflags & SB_I_NO_DATA_INTEGRITY)
+		mode = OVL_WRITE_START;
+
+	if (mode == OVL_WRITE_WAIT)
+		err = ovl_sync_upper_inode(upper);
+	else
+		err = write_inode_now(upper, mode == OVL_WRITE_COMMIT);
+
+	if (err)
+		errseq_set(&sb->s_wb_err, err);
+	return err;
+}

-- 
2.55.0

