Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.222.177
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794079195;
	b=BhcMElwerEWedlxvXN304PDxMDWCHWSNe27uOHU8Rg+T9OX2qxyfn7alT3eBBHzRkIQG
	 uzKDa20QTSICx4His4uLA+PJYEbTAPNlV86qiAlV+YFVw04BKSG4UbuZxKdFLOtd7p9Z9
	 z8i0drBaPlVRYf/N8TDfG6XP9As5p700TGSd593IzzldHyf/T/XwUNRuW1aGwWy1ATy/m
	 v2cPX4e2JdJFdOFPpko7FoiWGtsglUHztRQaF3EUl3+0PZlmg7fh++tK07uLp/gxvZ69z
	 h6aihHMLn9RHtuAqX40cIca32dyp2bdV98lPEhOjndvnqVdGq0FYDGU+PlSKcTKkKMw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794079195;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 From:Date:Subject:MIME-Version:Content-Type:Content-Transfer-Encoding:
	 Message-Id:References:In-Reply-To:To:Cc:X-Mailer:
	 X-Developer-Signature:X-Developer-Key;
	bh=CHRGWu1y5sMNZSgTrnkNI2iw6oVF/DA3QQv0fadpr6s=;
	b=WicOLSmLiUDra/xzdDMmN7fh8ozxNcF82TjFrgnDxr6/q/dV3MOavSam2MKAnFm8lFfJ
	 ANfs2tsfxtDEUuPi6OTunzfNjQwsmRURfyXXVHNagGyn1elcXEhwVc5p8oCFvdAVPbXc8
	 yZNOfPQUE1R7HPeT1Qz76nynE0idnXtqC3DMRQNS2dk7DyYMlgXv/ETM0V05+C10+Xsui
	 B6KL/wf8Bi22OnNVvi7pzJgkxOB0dNtwD7r7GKRU1eQ+67Y8PWz7Q3tksJ6GKUYEr4uLG
	 YUiz3xkGNSsf10CdKALCcK/ZsfINxDj09DSxqqEYPYa98qgMkkssgXe80DQubVAXcUA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=none header.from=toxicpanda.com;
	spf=pass smtp.mailfrom=toxicpanda.com;
	dkim=pass header.d=toxicpanda.com header.i=@toxicpanda.com header.a=rsa-sha256 header.s=google header.b="A4k/UZoR";
	arc=none smtp.remote-ip=209.85.222.177
Received: from mail-qk1-f177.google.com (mail-qk1-f177.google.com [209.85.222.177])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C1694606D810
	for <linux-unionfs@vger.kernel.org>; Sat,  7 Nov 2026 19:19:54 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org C1694606D810
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=toxicpanda.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=toxicpanda.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=toxicpanda.com header.i=@toxicpanda.com header.a=rsa-sha256 header.s=google header.b=A4k/UZoR
Received: by mail-qk1-f177.google.com with SMTP id af79cd13be357-93f2049ea7aso136738985a.2
        for <linux-unionfs@vger.kernel.org>; Sat, 07 Nov 2026 11:19:54 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=toxicpanda.com; s=google; t=1794079194; x=1794683994; darn=vger.kernel.org;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :content-type:mime-version:subject:date:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=CHRGWu1y5sMNZSgTrnkNI2iw6oVF/DA3QQv0fadpr6s=;
        b=A4k/UZoRaoydIQDmj3d8G0MekiYwq2THpLuDQxddKBvrAv8ps+DDqQhvBqDFyYBK38
         l7oVO2IXHaTBadEZgOaQakH8RHMAKEHofy5NsC7cbzHRzDhF4OSem8IUvKsHV/2WoADO
         Lwv/5IW0QzCBy7xGxDm1NGNvOF3zALZU/ubGFmhwRgNVvwa3Q0B3rvs+Stg+SyEAC74N
         Z7Pwzd3JvbV11O3dr0ZUoo8NOuGiiNFBMxklrOgakJVoK3EmVeBFQbpAZ4Zkk5/s8o1d
         CZ72YrF97TUhhN/xjybw3qcGBEaN9oR83iw1xwYGoathdZ7U/JJQHszhSqrsF2cUu7EU
         cm4w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794079194; x=1794683994;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :content-type:mime-version:subject:date:from:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=CHRGWu1y5sMNZSgTrnkNI2iw6oVF/DA3QQv0fadpr6s=;
        b=cCYjkRz9UoUdKDws4f09E2uUO56/0avAQeRNU8HZUnqx9amk2t3W9IFIqJ1u1mEC/d
         TF8G148gz1OefK0c/vKcvdTfSRQN15XYLwhI20Qg24ZO471XMR/tZPuZsIbp9l0vHiR6
         Ka+0sQWmoEBe+ZKcFSh4Zg7nTg0OC/7iUECiIC1swWyikiUtTgrx/42Tx2ahlEo8u9lg
         y9in0N/UUAt2UTbUAbp3zIPrOeSYY7aufdT14r8ltiMZlhCgrkwtd0wxB50c09qZxu8o
         Fixjr8qfmV+Vc2qiyJjsFIhLxXXbmW4xscQDfVLzuWN3e1tUEseHSdT8l0B7JgiR4Jhn
         Qspw==
X-Forwarded-Encrypted: i=1; AKwUvBzMAruRGOw098mA3mIGjllA7lC4eLvM7aVrZgsO0FEJ/5GE7ETm8OMtn9sSXp7jDbJ14MmJuxaUGIP5nRCv@vger.kernel.org
X-Gm-Message-State: APuU4Z95AevRzYrjCAtGTqc++OKOLDj/w/P1FYvW3Do1VeVYvbS0pgai
	DJtjYZQzlgecLw15uqrYFN0idN2Gt0mhTBQ0C3oRZFSIBgihxuTfmrV5eAD3zPuLyHk=
X-Gm-Gg: AYBFou24ZcgWtIky952r8A+XQLD3yHEIA5eePRT5vEEvHyeYMO+HcWCVykW1tefJtvt
	Ev7NODucfstYPNVs9IDTahAAj6k1+BxbyNrIy+1YDN8vOnpvnZdbleGxd6nOyJtPDUGnKwxY1vl
	4joOF1dr7jS+vuvdU893Y6NEYDEhf8XKIED25mi3jVdyBl5EE003/NRbzDLVZ0PcRGKzbsoNgRn
	nhtLvuxQy2ThILOjfZlyJftWqwh5SVFgGP07vsY2fzmt/23e4jSfyflUrLxHKol/9y+kmVfasM0
	m7YQP1c9oazKesQDwtKTakP6VKwtZoqGamj7hNYmtmZcbB3T6XJaXvD82xG1y+L3LZRZzilLcpJ
	tdocIilQAkM8TkeLT2qsws6DCK0FIN9K5kBDSAW8k0tXRuy+8UqnmuUhHb9qRmdBsfSDK/D3K88
	Of+FX6Qy59AARamPSWGurm3/K9FL5ifi7HsUM1GeH+ucqt2GgyimidxpER+OPlG5ornCy9KUKRq
	XbxMAvlofaCjfTop2jU62R3FN7ft+3d30iltBvYkqYdcwYtPtW5pGj+aG3pzR/309UgFrpvr+iv
	DogOw+79ja6SLb9EGvnFXYZMIGliwdna881aOEnu53mjNg==
X-Received: by 2002:a05:620a:aa14:b0:943:b019:f011 with SMTP id af79cd13be357-946811b9167mr218000185a.28.1794079193774;
        Sat, 07 Nov 2026 11:19:53 -0800 (PST)
Received: from toxicpanda.com ([153.61.196.251])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-94782dce4edsm2362385a.36.2026.11.07.11.19.52
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 07 Nov 2026 11:19:53 -0800 (PST)
From: Josef Bacik <josef@toxicpanda.com>
Date: Sat, 07 Nov 2026 19:19:34 +0000
Subject: [PATCH v5 5/8] ovl: implement overlayfs' own ->write_inode
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
Message-Id: <20261107-b4-ovl-containerized-sync-v5-5-d34b4ae57fdf@toxicpanda.com>
References: <20261107-b4-ovl-containerized-sync-v5-0-d34b4ae57fdf@toxicpanda.com>
In-Reply-To: <20261107-b4-ovl-containerized-sync-v5-0-d34b4ae57fdf@toxicpanda.com>
To: Miklos Szeredi <miklos@szeredi.hu>, Amir Goldstein <amir73il@gmail.com>, 
 Christian Brauner <brauner@kernel.org>
Cc: Alexander Viro <viro@zeniv.linux.org.uk>, Jan Kara <jack@suse.cz>, 
 Christoph Hellwig <hch@infradead.org>, Chris Mason <mason@kernel.org>, 
 Chengguang Xu <cgxu519@mykernel.net>, linux-unionfs@vger.kernel.org, 
 linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org, 
 Chengguang Xu <charliecgxu@tencent.com>, Josef Bacik <josef@toxicpanda.com>
X-Mailer: b4 0.15.2
X-Developer-Signature: v=1; a=openssh-sha256; t=1794079181; l=8033;
 i=josef@toxicpanda.com; h=from:subject:message-id;
 bh=eeak9zEOr5GWnl7gy4E2TACDB4aj0LomXdxwbSspm2g=;
 b=U1NIU0lHAAAAAQAAADMAAAALc3NoLWVkMjU1MTkAAAAgUBr36M/n0nWN0DNbnxwzIiCZez6MG
 JiruuNaSCI/zXsAAAAGcGF0YXR0AAAAAAAAAAZzaGE1MTIAAABTAAAAC3NzaC1lZDI1NTE5AAAA
 QNkzRyKPjRlqtEdNFtxWzXRoEDnBGo6UCEmaeflc3bMqDZ3PLcVDLP6spyC6s1B1rVSRCwwfafG
 orcrgU5MQ0wo=
X-Developer-Key: i=josef@toxicpanda.com; a=openssh;
 fpr=SHA256:C8kOX2QUJCMqnCX+KEeoqRAjLo9L+ELOSH2NSAJHqGA

From: Chengguang Xu <charliecgxu@tencent.com>

Sync dirty data and meta of upper inode in overlayfs' ->write_inode()
and redirty overlayfs' inode.

The overlay inode is only redirtied while the upper inode is open for
writing, dirty or under writeback.  So a clean overlay inode means that
everything written through it has been written back, or could not be.

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
 fs/overlayfs/util.c      | 52 +++++++++++++++++++++++++++++++++
 3 files changed, 140 insertions(+)

diff --git a/fs/overlayfs/overlayfs.h b/fs/overlayfs/overlayfs.h
index d82c4bed5af2..1d7b102a1127 100644
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
index 22a8d4eb3b7c..41d0d37accda 100644
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
index a260c5a350e2..d7b08a46cb76 100644
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
@@ -1526,3 +1527,54 @@ void ovl_copyattr(struct inode *inode)
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
+	err2 = sync_inode_metadata(upper, 0);
+	/*
+	 * That does nothing if the flusher of the upper filesystem is writing
+	 * @upper, and the flusher may have looked at the inode before it was
+	 * modified.  Wait for the flusher in that case.
+	 */
+	if (!err2 && (inode_state_read_once(upper) & (I_DIRTY_INODE | I_SYNC)))
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

