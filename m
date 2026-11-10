Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.160.173
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794320709;
	b=Jzo9DmECKGsT0fDxoY1RB4gu5WPVCZ5oT5juWXp2qreUQqQx6qZnnGqOmMM016Z9amVC
	 bj6QOWrOztQH+bRijZlbluGFjL+DIO3w10wLW7aeQ5CD+eQhFMsTLcRHZnKIbsgL7KM6+
	 TDrsoJ1mh66R3xCuRAP9hJw8KIk5xlOVOeTtiUWGBPCmTdt2XhqmW6nCrSWjUX+w5zkOq
	 ur2NqJ3gQf9nwtEM4pV2ShbdvWDMXokPZliIaIoK0s+zi0rETOhQlqRfoxdJHTf7jBmF4
	 QCvIY2Eh6zDkOx0xWYemn/uNJoVaXImz770eUQl5KgMie0qkOpCoyxDj/u5fentZcOw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794320709;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 From:Date:Subject:MIME-Version:Content-Type:Content-Transfer-Encoding:
	 Message-Id:References:In-Reply-To:To:Cc:X-Mailer:
	 X-Developer-Signature:X-Developer-Key;
	bh=CHRGWu1y5sMNZSgTrnkNI2iw6oVF/DA3QQv0fadpr6s=;
	b=y+FtzGMs4MktA+MlhI+UfmnzbQN36seukSRi6+3lRKG4HeMLFXj6anexKEb/FkllqFK8
	 9V3uBL4vSJdNce4MAq66KP+EDghMA2edtIlyG6fQ3dYFYBow+u3s0l6whvfRXaLcVDdXm
	 vzwK+tkkyv6O9Lk5/DXb8oXuA4L6w0XL2rb3sCx0lw3HoA9sQ1DNoz6T5zD8xxk+XOXa4
	 9snJvjiGKQViRWuuwcEoWXvQBMuEJxnJ0Oz4mmkrMoFzFH5BWt5gSWDLRp8yLTozBZRJe
	 vRtT4QKYuJR4ERgTu7+A3D7XLixQibOhQDEGiWYQ00wRxHyPZ0QqUoKbTYJfJxgkzhg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=none header.from=toxicpanda.com;
	spf=pass smtp.mailfrom=toxicpanda.com;
	dkim=pass header.d=toxicpanda.com header.i=@toxicpanda.com header.a=rsa-sha256 header.s=google header.b=lKZUvQMZ;
	arc=none smtp.remote-ip=209.85.160.173
Received: from mail-qt1-f173.google.com (mail-qt1-f173.google.com [209.85.160.173])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C0CD760A3814
	for <linux-unionfs@vger.kernel.org>; Tue, 10 Nov 2026 14:25:08 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org C0CD760A3814
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=toxicpanda.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=toxicpanda.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=toxicpanda.com header.i=@toxicpanda.com header.a=rsa-sha256 header.s=google header.b=lKZUvQMZ
Received: by mail-qt1-f173.google.com with SMTP id d75a77b69052e-5363316fa0cso22629421cf.3
        for <linux-unionfs@vger.kernel.org>; Tue, 10 Nov 2026 06:25:08 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=toxicpanda.com; s=google; t=1794320708; x=1794925508; darn=vger.kernel.org;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :content-type:mime-version:subject:date:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=CHRGWu1y5sMNZSgTrnkNI2iw6oVF/DA3QQv0fadpr6s=;
        b=lKZUvQMZynJS+GHKNCUte33bDALUA5PKA4BxdV3Fd11vvY4DEqEz01Vs22uUOWYHBd
         lPL0S55k9KDvzgFc8wN7iQWvS3l5u/1qNXSMljvidbWijEuFW2IY8JzzDhbc5+vH8fBS
         aul4ssXxH/RLA9ZAP0If3dpjAlvB/yy941OEyNnbEWPdtwIL8JgH1sDftKDPZnfHJcS8
         LCj3akdvA4we497EAKkL51el1shfwBgUeuniGahuRbPtaKNkIAJ1iG23gogmEnOXWt28
         TaM6r1qTsapZbNZ50Q5blaEZAE3bQdIHKz7qx/ZFFYVNmdB5CXplVOFBUwzFhoqbm7iq
         IQ2w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794320708; x=1794925508;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :content-type:mime-version:subject:date:from:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=CHRGWu1y5sMNZSgTrnkNI2iw6oVF/DA3QQv0fadpr6s=;
        b=yFeoHgebSvHzfiA/JV4ma0natkL8WCU9o6IXhmL9N3KZMn5DZ7GQDIo/eAkQKAduNK
         9azCSW/U2U8DPmT6tpEKPaul3CNQeyNUb9H1RtZDm7Ck5ydzg5qh2H5Dg1TqadbMoZdm
         EKsgZxgXpUB/SPHZSJoBbLtjOFbrY0xyxnCJSxzivTYtP1Qp92pRIPC6LxiQjtFjo5zt
         clNHybKIZG7own7ocRA+W9Qa9hd+5uHbgep3CN/HoSRiQCtkbj+xhBKa5pfv8GS5WkI6
         MQKpz/oc44yMKAhECsO39ea7gXgNZjLdITapNXy+7EPrNQrobZdjcUCUNOLEpGsMdRvG
         mSCA==
X-Forwarded-Encrypted: i=1; AL+hErF5KnxV6enxRuImrFyC30HxVJ6LgCHI2C5KfKFMTXXZ4FEFTfRUnb1Ffemz2cIwrCQAmtajTib8jp2e0zJi@vger.kernel.org
X-Gm-Message-State: APuU4Z95QXFLWqag5G9P14fxRnWx9arMz5GJ02dSSzxaSsSgCeT6sQ1F
	h1ruz8PWPj992nC1F/7DeWxDwGacSLGR0fIu3RGRIQ+TyNfi8yLhHhR+FTZTUx7mT6s=
X-Gm-Gg: AYBFou0ov06qLXRAD2H7D3NlBReeqtWtLXnoOlj3Lwv0D6yJHBS1BEkQR8s586FM95I
	NK/4rSPf8DePrQoyHCzwwOnN6MtgdZLmnWeHFSPgPfxyzAdJ7v0pdN6+iNuZ79w4dd83rXAOodF
	4jdcKKRM07VkIzm3jL69TZNro7NEBYDgguFE1RuaUj/KXwCBTkLPzowZIP6HEiTbZARu9WtDGsa
	tLdbOU5EvHDDy2IfQcoyk/uMhqWpeg0Xf4fdI9Tp7ez2DDJF0pKPbV8yyUfXLC2zPapn5L9aa1P
	U6miQjo4JgAt/cNLTdJ2XLYstfupoq25842oKocFX6LT+OtwqNRB/3j+TbKBULNjveHJVhyknLN
	p9YKpMVnd32LDy3VwDekmX9Y5qlZ6rIJ3TWf2yhNOPcuyDaDv9MJZqpo428ayx8umYkVuSdVpe0
	9QeKZg1xa/D0/jWyYsZumYkgFWlhRcCIDMxD0e0klysoX1CsiiK1XGX167SY0mqjDU88d9BnUXq
	JhofDIhrq0gxQaHM8Xf2l4gfw96zxGegcUlFbwYwMac+lAKB0m0PlXO3imswcFBWFe+ohhHWhVU
	gIMUc/W1bAp/i2f4fsCD8QPwZ4QDTHkiaRCjpfqP41qZdQ==
X-Received: by 2002:ac8:5e49:0:b0:536:5ee8:cca9 with SMTP id d75a77b69052e-55527f0f4eemr40813811cf.12.1794320707556;
        Tue, 10 Nov 2026 06:25:07 -0800 (PST)
Received: from toxicpanda.com ([153.61.196.250])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-91ef0547744sm22110936d6.44.2026.11.10.06.25.06
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 10 Nov 2026 06:25:06 -0800 (PST)
From: Josef Bacik <josef@toxicpanda.com>
Date: Tue, 10 Nov 2026 14:24:53 +0000
Subject: [PATCH v6 5/9] ovl: implement overlayfs' own ->write_inode
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
Message-Id: <20261110-b4-ovl-containerized-sync-v6-5-43d1be16a4d6@toxicpanda.com>
References: <20261110-b4-ovl-containerized-sync-v6-0-43d1be16a4d6@toxicpanda.com>
In-Reply-To: <20261110-b4-ovl-containerized-sync-v6-0-43d1be16a4d6@toxicpanda.com>
To: Miklos Szeredi <miklos@szeredi.hu>, Amir Goldstein <amir73il@gmail.com>, 
 Christian Brauner <brauner@kernel.org>
Cc: Alexander Viro <viro@zeniv.linux.org.uk>, Jan Kara <jack@suse.cz>, 
 Christoph Hellwig <hch@infradead.org>, Chris Mason <mason@kernel.org>, 
 Chengguang Xu <cgxu519@mykernel.net>, linux-unionfs@vger.kernel.org, 
 linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org, 
 Chengguang Xu <charliecgxu@tencent.com>, Josef Bacik <josef@toxicpanda.com>
X-Mailer: b4 0.15.2
X-Developer-Signature: v=1; a=openssh-sha256; t=1794320698; l=8033;
 i=josef@toxicpanda.com; h=from:subject:message-id;
 bh=eeak9zEOr5GWnl7gy4E2TACDB4aj0LomXdxwbSspm2g=;
 b=U1NIU0lHAAAAAQAAADMAAAALc3NoLWVkMjU1MTkAAAAgUBr36M/n0nWN0DNbnxwzIiCZez6MG
 JiruuNaSCI/zXsAAAAGcGF0YXR0AAAAAAAAAAZzaGE1MTIAAABTAAAAC3NzaC1lZDI1NTE5AAAA
 QPV+2OULPVHvLGtNj6GKNE6oqaDNJ23o3VPSWR0tYgp0sB75e11tnHZQOAY8aLPFomE9dAwt9Vw
 dMHaHplqjeAY=
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

