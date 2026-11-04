Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.160.179
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793825125;
	b=MAaufemz3fK55rT46UNRb18U0Orx4dTTVk3a33rxQbNp4nTfViLR2F4gzWSZ1oVAm5tT
	 Oi6ESnHX4IkYb2SRSKCDiv0llE1dhXsTKRua/6NNVn3pxLHWZNTPxa65Z1AIkE3gkVdnG
	 x+04brMXVZ0F5Ufpg9HrApj93aobH7CxiPnmTGB4pafbBrtoOWx92eLD6d97fCYvZPoUb
	 TuRip649UkezknrxW7HXRa3WHm48+eEvEhCtYVFtyu5C7bJHsDDeMZPmsvdETn2ib7xwK
	 3dficD9Q0utW7Enn+gvJzqluOnZz7zPObzLdDvKbX0+lbcewsmb7KeDMeE+sqV2amnw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793825125;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 From:Date:Subject:MIME-Version:Content-Type:Content-Transfer-Encoding:
	 Message-Id:References:In-Reply-To:To:Cc:X-Mailer:
	 X-Developer-Signature:X-Developer-Key;
	bh=X/8n7nokQ8ex0NxvVbrQ93PkTmPCnS2Wh1hM1HeTwtc=;
	b=VIFNzNs2DUWmwTjIYgpVdUvijiEhCLrkgftRiiwJqbqbnYspYXNNXJtVD7DCAZO/MY/g
	 WpEiOnTIYpSihHeJzICVHI3cEGP2m4mUVtwkRacP8h0Sy/kAu4z2Rdp6ByieIwNIvN5X1
	 tGmKeV3YI+TmKFkki40Qoin6cSv1LEcCuEJjKEDEgPPgzm+mIIhWhgBgh7z6UwCeKVHIb
	 0tu+6X+FbddKDDRw/0m3M5vJJg3fjzcq1G2iAjeQdESBDNESh9CElSzpsBu54pE5b+Rlz
	 3hLjRiABduuugmNG2QxcBvp/g/3ZJ0sMaXzGiEzfoOnWi862pCQdUGtef0FzWDE/9DA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=none header.from=toxicpanda.com;
	spf=pass smtp.mailfrom=toxicpanda.com;
	dkim=pass header.d=toxicpanda.com header.i=@toxicpanda.com header.a=rsa-sha256 header.s=google header.b=IwwfBbIb;
	arc=none smtp.remote-ip=209.85.160.179
Received: from mail-qt1-f179.google.com (mail-qt1-f179.google.com [209.85.160.179])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9DFE66077B58
	for <linux-unionfs@vger.kernel.org>; Wed,  4 Nov 2026 20:45:24 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 9DFE66077B58
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=toxicpanda.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=toxicpanda.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=toxicpanda.com header.i=@toxicpanda.com header.a=rsa-sha256 header.s=google header.b=IwwfBbIb
Received: by mail-qt1-f179.google.com with SMTP id d75a77b69052e-53665358476so12027791cf.2
        for <linux-unionfs@vger.kernel.org>; Wed, 04 Nov 2026 12:45:24 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=toxicpanda.com; s=google; t=1793825124; x=1794429924; darn=vger.kernel.org;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :content-type:mime-version:subject:date:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=X/8n7nokQ8ex0NxvVbrQ93PkTmPCnS2Wh1hM1HeTwtc=;
        b=IwwfBbIbXa++O8FWu6MBooaD0tklLQqd0dMn624SWSAOoXAhqlcd2I8gje7SFfOn2V
         gFxDglZ31Wh+69OICbxcDQgwJcuoKFOMU1jgJ/bfRn6NPtQ+rUiL1ZIuefDNwy64Fc8X
         kvIiqbeSoiDApqsmBTgJvbz9qFC1AOfiBP5H+pF0zc4+Bvd8MxpKaLjvq0BgwbhxnaOR
         LMVq0yCHq2pAlzGSuUmZlutahWsrcLRWwknVVzCvMbbqWIPTfT9KCwV60tLvkUTM0kkv
         ZH4jVcPj2n7FBmwW6exr42aXRIofPGNtBf55fITdQ/xSBwX675ncfAbJ/kK13AHMrCIC
         95kA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793825124; x=1794429924;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :content-type:mime-version:subject:date:from:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=X/8n7nokQ8ex0NxvVbrQ93PkTmPCnS2Wh1hM1HeTwtc=;
        b=oN1s0ezx04z/5DWwqNtZNHj9Cu4RfsIvEC62/x7q1ongkP40DhWymTnrckDGcn6TSa
         OlsaAFPEFXgqzESvQQIcI7GE4I65/fg0aCjUqUeej2uDTocjaR5NmGmYcxT8RuFpsWXm
         3BDBjvFM4iByyDZDI9zDPvwEhymSoeuVdsw50+iujIS4x5zHFN+Htfc+X095D2CQYZi9
         xlhl9/E1NDNCxjOB0ga4klpgg5xkLxELhwyOI7+CkQDpVQv6uiOasKfrhPndcvFcHLMi
         KCUEzDdvKWSLvbF/zFIPFF6l8JJX8JoZ2ian9TML1tXzgugBGHjjIBZLqwSkhX8isDaj
         wDyg==
X-Forwarded-Encrypted: i=1; AKwUvBwH103P2fQ4pvPKqxp9ty76UUGZKIpQN9RBOwGDqjs/bO4V3I1r7BvcUQxpPshVMC1AYhezbahCjNkTsxDr@vger.kernel.org
X-Gm-Message-State: APuU4Z9g/krcRKbe43dY0jbhUA3pqqGaFO6ShJnhjTHq99Qpitzu47T2
	prR9oUy4SDoafhtYfH6BiVz6xJ6YbVrogJ31FVmI5rg5WnmmCbM8nm5/qljNP+8sU2c=
X-Gm-Gg: AYBFou2saxILTGsnYbt2Wf8EZ8FlcPZELO/H/h2gEP0qa0o9zjFq/8PgrGk/aUHxI49
	nCsRJ1X/s90uESm1OZZWNNtyjnJzi5/APDALHFBa+EeftA7zjSuTTWuMfNVdjoJFDvxBnbOxymk
	1rHZ1KsX7V8WlyLz2GXn9rzR0MQlDQ13FxZVYLKO+at0ULeTLxAeVxOVzfHvxTS8zHjHdWbpmDu
	IDC+MNVqvb0y3FSubIq4ThJxZxDw542LLJbK+w+knjL466qLNS0jlQBOiXUTx4RZocP1j2XGUgb
	hdPI2nkV3DwGK6sf4NEH7XkGtvFQ4MD8fkcfT/g2grvOwg2yjugKo0xlpu038wNQD1ZSZIadqpG
	PtPFP4kB8dGw0b6dQSqH/YCnd7yNpfdGzRhSrnb6Jnpuf8j2MVPRpf9WxnU1VWlAFWfZUMQqff8
	AfsUFPiwDoIppfgqVPP5aQVHgfgCzQxsqKa/2PMEvb1m24BXlj3EUAx5RrFV2ysl2FWvYj9wnpI
	ZhZ8A0oXM8VCKe+TcR5Sa4tgJ7ft80VsnOl0SFZ/zIrED7orFngJHqwbKg0UawVwa8MVqJBq/Mn
	262VGKaAEu/E+f4hJ+qHsrtQfXT0UQAno2LQ/0r0wTYHzQ==
X-Received: by 2002:a05:622a:1a97:b0:537:59d2:c228 with SMTP id d75a77b69052e-542b81fdb4bmr266565091cf.69.1793825123444;
        Wed, 04 Nov 2026 12:45:23 -0800 (PST)
Received: from toxicpanda.com ([153.61.196.241])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-91e7e008399sm28470266d6.23.2026.11.04.12.45.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 04 Nov 2026 12:45:22 -0800 (PST)
From: Josef Bacik <josef@toxicpanda.com>
Date: Wed, 04 Nov 2026 20:45:02 +0000
Subject: [PATCH v3 5/8] ovl: implement overlayfs' own ->write_inode
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
Message-Id: <20261104-b4-ovl-containerized-sync-v3-5-8daa20144f53@toxicpanda.com>
References: <20261104-b4-ovl-containerized-sync-v3-0-8daa20144f53@toxicpanda.com>
In-Reply-To: <20261104-b4-ovl-containerized-sync-v3-0-8daa20144f53@toxicpanda.com>
To: Miklos Szeredi <miklos@szeredi.hu>, Amir Goldstein <amir73il@gmail.com>, 
 Christian Brauner <brauner@kernel.org>
Cc: Alexander Viro <viro@zeniv.linux.org.uk>, Jan Kara <jack@suse.cz>, 
 Christoph Hellwig <hch@infradead.org>, Chris Mason <mason@kernel.org>, 
 Chengguang Xu <cgxu519@mykernel.net>, linux-unionfs@vger.kernel.org, 
 linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org, 
 Chengguang Xu <charliecgxu@tencent.com>, Josef Bacik <josef@toxicpanda.com>
X-Mailer: b4 0.15.2
X-Developer-Signature: v=1; a=openssh-sha256; t=1793825112; l=8159;
 i=josef@toxicpanda.com; h=from:subject:message-id;
 bh=qXnKhgp9zJ29vkA7eq3Be7AsMvQ5vAIjKSnMOgJHKQQ=;
 b=U1NIU0lHAAAAAQAAADMAAAALc3NoLWVkMjU1MTkAAAAgUBr36M/n0nWN0DNbnxwzIiCZez6MG
 JiruuNaSCI/zXsAAAAGcGF0YXR0AAAAAAAAAAZzaGE1MTIAAABTAAAAC3NzaC1lZDI1NTE5AAAA
 QJmlsOX3zk/P+zpqROyeYwuXG1mMOj9NS/C5cCBTLSLE9fbErgpbEXGQdMkZTckgnLCfXPOOF93
 LGK8nAha+2g8=
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
index bc68150ccf68..bbe1a5bb8e97 100644
--- a/fs/overlayfs/overlayfs.h
+++ b/fs/overlayfs/overlayfs.h
@@ -513,6 +513,19 @@ const struct ovl_layer *ovl_layer_lower(struct dentry *dentry);
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
index 55635648b3de..c1bd70972519 100644
--- a/fs/overlayfs/super.c
+++ b/fs/overlayfs/super.c
@@ -15,6 +15,8 @@
 #include <linux/seq_file.h>
 #include <linux/posix_acl_xattr.h>
 #include <linux/exportfs.h>
+#include <linux/pagemap.h>
+#include <linux/writeback.h>
 #include <linux/file.h>
 #include <linux/fs_context.h>
 #include <linux/fs_parser.h>
@@ -313,12 +315,85 @@ static int ovl_statfs(struct dentry *dentry, struct kstatfs *buf)
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

