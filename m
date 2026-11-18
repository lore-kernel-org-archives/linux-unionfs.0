Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.128.172
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795021423;
	b=3Dowy8bwjAnMORZIGW9p76YqwE3N6hKxKB3KEtO3X0M6NAg+3yRRmIOsPe0blmYCe1A0
	 BhIpkBIWY0RQO+Ot5W41QaCxOQRMM+bXpshfwolFaDyuyJvyWJtF9zKbbuwUagaG1jphV
	 EQMdI88vjnuKeQ6mWnNid6u2RowA/Vqw4bEmqxeALbIktVDCz+iYN0+BbyeDpIh/sKddJ
	 8lfXJfd/GRkCsBeDhCdPpP7YoE+YfuLE+rxADYQVTu906UQv3yfqEvqrwnUWf0fYWlUVy
	 6eHt16woFSMCR6RYcEcpUGSWYeu+LuZ+jytNEiyB0o5goFn/1oT8Ol7zJW8nn6818hw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795021423;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 From:Date:Subject:MIME-Version:Content-Type:Content-Transfer-Encoding:
	 Message-Id:References:In-Reply-To:To:Cc:X-Mailer:
	 X-Developer-Signature:X-Developer-Key;
	bh=Y70yXZAvOr66TxVQEPkIiAIDxuUPqlw54kS33Yt/9Yg=;
	b=g2HYcpMp4cAHuZbGJNPwnfwKxkDdn7KzN5dsvQ0RWCfXgxhgZYfjct/S1Q7RC1hc00Nc
	 4dJTlSuiECU/zIobqEQ6nPGWp7glqrePfY3CVZO8bkfqNWBcHx1n5YXxIEr2J6oHr8ti4
	 bWhfV6tJGtm8hxwxwAbTJUQ8s3v/5wK2LZVPKkvGyItZMl7gHF282pokCQVZzDBWfbmDl
	 kEParFm2Q8X3VzN9+TbsTnjJXEHMJOcUSDc6H8hGeez+Je0w4o00JIAsaFyuaBrQ8ZBfp
	 l9+IZDEJ4uDIMQtBlXyoytu15A/olAVqaB9GIkqq0lNqRhIIeLVVODbKx1bnPKwnbig==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=none header.from=toxicpanda.com;
	spf=pass smtp.mailfrom=toxicpanda.com;
	dkim=pass header.d=toxicpanda.com header.i=@toxicpanda.com header.a=rsa-sha256 header.s=google header.b=VvxeAFXj;
	arc=none smtp.remote-ip=209.85.128.172
Received: from mail-yw1-f172.google.com (mail-yw1-f172.google.com [209.85.128.172])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 43B3460A3819
	for <linux-unionfs@vger.kernel.org>; Wed, 18 Nov 2026 17:03:42 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 43B3460A3819
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=toxicpanda.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=toxicpanda.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=toxicpanda.com header.i=@toxicpanda.com header.a=rsa-sha256 header.s=google header.b=VvxeAFXj
Received: by mail-yw1-f172.google.com with SMTP id 00721157ae682-8b4d26094beso12936337b3.1
        for <linux-unionfs@vger.kernel.org>; Wed, 18 Nov 2026 09:03:42 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=toxicpanda.com; s=google; t=1795021421; x=1795626221; darn=vger.kernel.org;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :content-type:mime-version:subject:date:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=Y70yXZAvOr66TxVQEPkIiAIDxuUPqlw54kS33Yt/9Yg=;
        b=VvxeAFXjuopI0I2Mu1pmoG80zb9nFW9MNifuU2a++NMuSoxb8LNb9Lvv/nHUcOxGGv
         a6sJyMl9I/E+/mA9w3nkDaQAK5wDp7O4uMLi5+ypwPkDAFrsZNY4dxnk5jGRtsVWFrMN
         ERscCbz1TquRbEoaoCS/ss+u5qbMHwiiFhXxiz7hRGgGHl/iJY1tNpWNep7yE/5FHgzH
         Z7GqyBVuGIkGGp0i2u0s0gpfHXgpIw/ZA2ypd/HTWfZlw1AZu+8Tf/mfXJj+pVX9JTtU
         uA/FnqQoSloTlPWoQj90YnlZdVWtVcFqQIa+9nwH8tKMVgnRUXSeG1+0y/c7yAJt9Z+y
         ZSEQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795021421; x=1795626221;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :content-type:mime-version:subject:date:from:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=Y70yXZAvOr66TxVQEPkIiAIDxuUPqlw54kS33Yt/9Yg=;
        b=wvmxkxoSdoT9UAQXJEg/uKM5RAEn6WlBIl1DqvB9Z6EJD09Beg0KlQh+BhsD0od5X+
         0V4qcajxhFyQvlArN1pZwM6lXOI6kdp+t11kHYOq8n3oUuzWWdBYuPRwOmo6743tg9PR
         pn6ipKIQHyyAh4gZbWnJCLkLVxZlPMS+9Adzn6WRsPR30GDsEA3tjtBPj4pR2RkXveWC
         Zn1+V2XKiWOiCOFUzzA5hmw873IEuAVUrAsgoDRvIp+EOukTB4Lm8vmNDvtokM1cR90I
         /BQNexRr8Z1GjpiRKsHbpvO5rVmrxMtVQN9XqKmv3h8+Fx1JRHDiKs6DoxiQygODdW3O
         7tqw==
X-Forwarded-Encrypted: i=1; AL+hErEJqqrcKpCHA+OS0r5jIrFENinRMhELwvHU2lZWZ7IVs0B14dBC+AumXto7TNe6nc6y7J4wKoosBYCrvbSt@vger.kernel.org
X-Gm-Message-State: APuU4Z/qeRRnDmUriwl/1uGcAl0Lyf7YUxudUsrllxA6Ky/GR+fw9XDi
	nMgSjDefkDD1gKapgPel3nXajeksAGnpRkI77s3INywv+BEKbqWm73NjJpL419KuhVU=
X-Gm-Gg: AZFdTZcpjyGRnR4xsEyIQbfdjf7y8YwvQdtrnrNkZIzHneBosL1kF6WM3TMamj1nHBw
	Lm8xJNnO+gYJ7/yUhYORDIpAWoNOVXLqFzDJ7Uny9dkoiQ+qJPJlv886xwRQzKYMjWWiWwM3T3O
	RfS8agMh8JzczcTUs0CLDUk6ybQLCvPndhpGG8mVPphbWmXhyQbaefcbhqTwtx50ZosK7bHtJ72
	nCFqwDeJ0Znn6edH5TIhKprgT+4hevee0yz2n11zaLV/q4/7SdQ2hQpMwfLjJ77LMk6VVs472sm
	TTRJSBmeawl53aDAcLjn3JbkBFzlvVKMOgkAcKS2zGUIiqDO4QJ3g/MU0zd4oUBVsRQFYtoFTbK
	+rLL54x+yp9694M+6C7Xx1AXDqFmRhgd8ggHGiGS4oHGqZn3rLjFaS/0BbtuWWpOvVz+SmojLZl
	g/SYuCHWR1wbOsH0vC+sJLPDeubwTN/vPB8B4vWsc+MQhW/q2vUslMyKnPw+jOpsNrtYgGYzeay
	EmH6LlTph88eDSJO/Aoi1onkJ+HkDvWn+pcMGsQJq0UVW7R2TrV869Ui0Aj3NovVgkjJIV/rgZZ
	Ihr7d4jvSV/0jsacNvvrQVRb8UU1y6Tqqw+igL0FwzeofA==
X-Received: by 2002:a05:690c:a417:20b0:8b5:6e9:217a with SMTP id 00721157ae682-8b506e927ebmr6451737b3.31.1795021420862;
        Wed, 18 Nov 2026 09:03:40 -0800 (PST)
Received: from toxicpanda.com ([153.61.196.248])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-9499b7ccf2fsm224499785a.36.2026.11.18.09.03.40
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 18 Nov 2026 09:03:40 -0800 (PST)
From: Josef Bacik <josef@toxicpanda.com>
Date: Wed, 18 Nov 2026 17:03:28 +0000
Subject: [PATCH v7 5/7] ovl: add a set of the inodes that a sync has to
 write
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
Message-Id: <20261118-b4-ovl-containerized-sync-v7-5-54f45743fe55@toxicpanda.com>
References: <20261118-b4-ovl-containerized-sync-v7-0-54f45743fe55@toxicpanda.com>
In-Reply-To: <20261118-b4-ovl-containerized-sync-v7-0-54f45743fe55@toxicpanda.com>
To: Miklos Szeredi <miklos@szeredi.hu>, Amir Goldstein <amir73il@gmail.com>, 
 Christian Brauner <brauner@kernel.org>
Cc: Alexander Viro <viro@zeniv.linux.org.uk>, Jan Kara <jack@suse.cz>, 
 Christoph Hellwig <hch@infradead.org>, Chris Mason <mason@kernel.org>, 
 Chengguang Xu <cgxu519@mykernel.net>, linux-unionfs@vger.kernel.org, 
 linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org, 
 Josef Bacik <josef@toxicpanda.com>
X-Mailer: b4 0.15.2
X-Developer-Signature: v=1; a=openssh-sha256; t=1795021413; l=20402;
 i=josef@toxicpanda.com; h=from:subject:message-id;
 bh=firYUPSqbzQV1rQ8cQeHwp95pCeKXnKisRaN+Gl6t8o=;
 b=U1NIU0lHAAAAAQAAADMAAAALc3NoLWVkMjU1MTkAAAAgUBr36M/n0nWN0DNbnxwzIiCZez6MG
 JiruuNaSCI/zXsAAAAGcGF0YXR0AAAAAAAAAAZzaGE1MTIAAABTAAAAC3NzaC1lZDI1NTE5AAAA
 QEljXLHtzHBpk8vxccH/PMMI9TEAjtx8LAvS3h7xdPgPJpL3boy0e962JJt5UDTlAaBTV/pjA8c
 Zn1OCOKHeHgs=
X-Developer-Key: i=josef@toxicpanda.com; a=openssh;
 fpr=SHA256:C8kOX2QUJCMqnCX+KEeoqRAjLo9L+ELOSH2NSAJHqGA

To sync only what was written through an overlay, overlayfs has to know
which upper inodes were modified through it.

An overlay inode has no pages and no metadata of its own.  What is dirty,
under writeback or deferred by lazytime is the state of the upper inode, in
another superblock, and nothing tells overlayfs when it changes.  So do not
mirror that state.  Only remember the overlay inodes that were modified, in
an xarray of the overlay, and let a sync ask the upper inode of each.

The xarray has the marks of the page cache, dirty, towrite and writeback.
This patch only uses the first, the others come with the sync.

The set holds a reference to an inode that has a mark.  The overlay inode
holds the upper dentry, so the upper inode is one pointer away, whatever
the upper filesystem is.

An inode gets its slot in the xarray when it is allocated, and tracking it
only sets a mark, so that cannot fail.  The index is the address of the
inode.  i_ino is not unique in an overlay, and xa_alloc() needs one of the
three marks for itself.  So with fsync=relaxed, which the default resolves
to on most upper filesystems, every inode of the overlay, also one that is
never modified, costs a slot and takes the lock of the xarray when it is
allocated and when it is freed.

All overlays allocate from one slab cache, so where their inodes are mixed
a slot can cost a node of the xarray or more.  With 64 overlays of 2000
files on a guest with KASAN and lockdep it is 21 bytes an inode if they
are walked one after the other, 89 if all at once, and 489 if they take
turns entry by entry.  The tree is tall, about 6K for every overlay.

An inode leaves the set in a sync, when it is unlinked, or when memory is
needed and its upper inode has become clean.  For the last one use the
hooks of the superblock's own shrinker.  Reclaim in a memory cgroup only
runs shrinkers that have objects on a list_lru of that cgroup, which one of
our own would not have.  The hook only queues a work item.  The reference
that is dropped may be the last one to an upper inode that was unlinked,
and filesystems allocate memory under locks that deleting a file needs.

An inode only leaves the set for being clean if its upper inode is seen
clean under the i_lock of the overlay inode, which tracking takes as well.
A modification that came before is visible, and one that comes later puts
the inode back.  So whoever walks the set needs no lock against anybody
else who does.

With lazytime the upper inode holds timestamps back for up to a day.  The
last iput() would write them, but that cannot come while the inode is in
the set.  So the work item hands them to the upper filesystem.

When an inode enters the set, remember where the wb_err of the upper
mapping is.  Writeback that fails from there on, whoever does it, is for a
sync of the overlay to report, and until then the inode is not clean.

Nothing is put into the set yet, and syncfs() still syncs the upper
filesystem.

Signed-off-by: Josef Bacik <josef@toxicpanda.com>
---
 fs/overlayfs/Makefile    |   2 +-
 fs/overlayfs/overlayfs.h |  13 ++
 fs/overlayfs/ovl_entry.h |   9 ++
 fs/overlayfs/params.c    |   2 +
 fs/overlayfs/super.c     |  11 +-
 fs/overlayfs/sync.c      | 374 +++++++++++++++++++++++++++++++++++++++++++++++
 6 files changed, 409 insertions(+), 2 deletions(-)

diff --git a/fs/overlayfs/Makefile b/fs/overlayfs/Makefile
index 5648954f8588..080fb902bafd 100644
--- a/fs/overlayfs/Makefile
+++ b/fs/overlayfs/Makefile
@@ -6,4 +6,4 @@
 obj-$(CONFIG_OVERLAY_FS) += overlay.o
 
 overlay-objs := super.o namei.o util.o inode.o file.o dir.o readdir.o \
-		copy_up.o export.o params.o xattrs.o
+		copy_up.o export.o params.o xattrs.o sync.o
diff --git a/fs/overlayfs/overlayfs.h b/fs/overlayfs/overlayfs.h
index 13fbe016ed75..fad8ab77ac19 100644
--- a/fs/overlayfs/overlayfs.h
+++ b/fs/overlayfs/overlayfs.h
@@ -65,6 +65,8 @@ enum ovl_inode_flag {
 	OVL_CONST_INO,
 	OVL_HAS_DIGEST,
 	OVL_VERIFIED_DIGEST,
+	/* Modified since a sync has started to write it, under i_lock */
+	OVL_TRACKED,
 };
 
 enum ovl_entry_flag {
@@ -886,6 +888,17 @@ struct inode *ovl_get_inode(struct super_block *sb,
 			    struct ovl_inode_params *oip);
 void ovl_copyattr(struct inode *to);
 
+/* sync.c */
+void ovl_track_init(struct ovl_fs *ofs);
+void ovl_track_exit(struct ovl_fs *ofs);
+int ovl_track_alloc(struct super_block *sb, struct inode *inode);
+void ovl_track_inode(struct inode *inode);
+void ovl_untrack_inode(struct inode *inode);
+void ovl_forget_inode(struct inode *inode);
+void ovl_drop_tracked(struct ovl_fs *ofs);
+long ovl_nr_cached_objects(struct super_block *sb, struct shrink_control *sc);
+long ovl_free_cached_objects(struct super_block *sb, struct shrink_control *sc);
+
 /* vfs fileattr flags read from overlay.protattr xattr to ovl inode */
 #define OVL_PROT_I_FLAGS_MASK  (S_APPEND | S_IMMUTABLE)
 /* vfs fileattr flags copied from real to ovl inode */
diff --git a/fs/overlayfs/ovl_entry.h b/fs/overlayfs/ovl_entry.h
index ac07e8769f9b..44e22b2860d2 100644
--- a/fs/overlayfs/ovl_entry.h
+++ b/fs/overlayfs/ovl_entry.h
@@ -92,6 +92,13 @@ struct ovl_fs {
 	/* r/o snapshot of upperdir sb's only taken on volatile mounts */
 	errseq_t errseq;
 	bool casefold;
+	/* The inodes that syncfs() and unmount have to write, see sync.c */
+	struct xarray tracked;
+	atomic_long_t nr_tracked;
+	/* Reclaim has this drop what is clean: how many, and where it goes on */
+	struct work_struct release_work;
+	atomic_long_t release_nr;
+	unsigned long release_id[2];
 };
 
 /* Number of lower layers, not including data-only layers */
@@ -164,6 +171,8 @@ struct ovl_inode {
 	const char *redirect;
 	u64 version;
 	unsigned long flags;
+	/* wb_err of the upper mapping up to where a sync has reported it */
+	errseq_t wb_err;
 	struct inode vfs_inode;
 	struct dentry *__upperdentry;
 	struct ovl_entry *oe;
diff --git a/fs/overlayfs/params.c b/fs/overlayfs/params.c
index 549fc1e83ac9..370dd6341392 100644
--- a/fs/overlayfs/params.c
+++ b/fs/overlayfs/params.c
@@ -842,6 +842,7 @@ int ovl_init_fs_context(struct fs_context *fc)
 	fc->ops			= &ovl_context_ops;
 
 	mutex_init(&ofs->whiteout_lock);
+	ovl_track_init(ofs);
 	return 0;
 
 out_err:
@@ -883,6 +884,7 @@ void ovl_free_fs(struct ovl_fs *ofs)
 	kfree(ofs->config.workdir);
 	if (ofs->creator_cred)
 		put_cred(ofs->creator_cred);
+	ovl_track_exit(ofs);
 	kfree(ofs);
 }
 
diff --git a/fs/overlayfs/super.c b/fs/overlayfs/super.c
index 31a58e28968c..5eb510bf1b9a 100644
--- a/fs/overlayfs/super.c
+++ b/fs/overlayfs/super.c
@@ -221,6 +221,10 @@ static struct inode *ovl_alloc_inode(struct super_block *sb)
 	oi->__upperdentry = NULL;
 	oi->lowerdata_redirect = NULL;
 	oi->oe = NULL;
+	if (ovl_track_alloc(sb, &oi->vfs_inode)) {
+		kmem_cache_free(ovl_inode_cachep, oi);
+		return NULL;
+	}
 	mutex_init(&oi->lock);
 
 	return &oi->vfs_inode;
@@ -240,6 +244,7 @@ static void ovl_destroy_inode(struct inode *inode)
 {
 	struct ovl_inode *oi = OVL_I(inode);
 
+	ovl_forget_inode(inode);
 	dput(oi->__upperdentry);
 	ovl_stack_put(ovl_lowerstack(oi->oe), ovl_numlower(oi->oe));
 	if (S_ISDIR(inode->i_mode))
@@ -252,8 +257,10 @@ static void ovl_put_super(struct super_block *sb)
 {
 	struct ovl_fs *ofs = OVL_FS(sb);
 
-	if (ofs)
+	if (ofs) {
+		ovl_drop_tracked(ofs);
 		ovl_free_fs(ofs);
+	}
 }
 
 /* Sync real dirty inodes in upper filesystem (if it exists) */
@@ -327,6 +334,8 @@ static const struct super_operations ovl_super_operations = {
 	.drop_inode	= inode_just_drop,
 	.put_super	= ovl_put_super,
 	.sync_fs	= ovl_sync_fs,
+	.nr_cached_objects = ovl_nr_cached_objects,
+	.free_cached_objects = ovl_free_cached_objects,
 	.statfs		= ovl_statfs,
 	.show_options	= ovl_show_options,
 };
diff --git a/fs/overlayfs/sync.c b/fs/overlayfs/sync.c
new file mode 100644
index 000000000000..03dfd903bf08
--- /dev/null
+++ b/fs/overlayfs/sync.c
@@ -0,0 +1,374 @@
+// SPDX-License-Identifier: GPL-2.0-only
+/*
+ * The inodes that syncfs() and unmount have to write with fsync=relaxed.
+ *
+ * An overlay inode has no pages and no metadata of its own.  What is dirty,
+ * under writeback or deferred by lazytime is the state of the upper inode, and
+ * nothing tells overlayfs when it changes.  So overlayfs does not mirror that
+ * state.  It only remembers which overlay inodes were modified, and a sync
+ * asks the upper inode of each of them.
+ *
+ * The set is an xarray with the marks of the page cache:
+ *
+ *   OVL_X_DIRTY      the upper inode was modified
+ *   OVL_X_TOWRITE    a sync that has begun is going to write it
+ *   OVL_X_WRITEBACK  a sync has started to write it
+ *
+ * The set holds one reference to an inode that has any of them.  They change
+ * under the i_lock of the inode, except that OVL_X_TOWRITE is added to
+ * OVL_X_DIRTY under the lock of the xarray alone.
+ *
+ * There is one difference to the page cache.  No completion clears
+ * OVL_X_WRITEBACK, whoever has waited does.  Another sync may have started the
+ * inode again meanwhile, so the mark only goes when the upper inode is seen
+ * clean.  That way whoever walks the set needs no lock against anybody else who
+ * does.
+ */
+
+#include <linux/fs.h>
+#include <linux/log2.h>
+#include <linux/mount.h>
+#include <linux/pagemap.h>
+#include <linux/writeback.h>
+#include <linux/xarray.h>
+#include <linux/xattr.h>
+#include "overlayfs.h"
+
+#define OVL_X_DIRTY	XA_MARK_0
+#define OVL_X_TOWRITE	XA_MARK_1
+#define OVL_X_WRITEBACK	XA_MARK_2
+
+/*
+ * Index by address.  Inodes are at least their size apart and the shift rounds
+ * down, so it stays unique, and neighbours in a slab share an xarray node.
+ */
+static unsigned long ovl_slot(struct inode *inode)
+{
+	return (unsigned long)OVL_I(inode) >> ilog2(sizeof(struct ovl_inode));
+}
+
+/*
+ * Give a new inode its slot in the set, so that tracking it later cannot fail.
+ * An entry without a mark is never looked at.
+ */
+int ovl_track_alloc(struct super_block *sb, struct inode *inode)
+{
+	struct ovl_fs *ofs = OVL_FS(sb);
+
+	if (!ovl_tracks_dirty(ofs))
+		return 0;
+
+	return xa_insert(&ofs->tracked, ovl_slot(inode), inode, GFP_KERNEL);
+}
+
+/*
+ * @inode is about to be freed.  It is not tracked, or it had a reference.
+ *
+ * Mount settles on the fsync mode after it has allocated the first trap inodes,
+ * so the mode does not tell if @inode has a slot.
+ */
+void ovl_forget_inode(struct inode *inode)
+{
+	struct ovl_fs *ofs = OVL_FS(inode->i_sb);
+
+	WARN_ON_ONCE(ovl_test_flag(OVL_TRACKED, inode));
+	if (!xa_empty(&ofs->tracked))
+		xa_erase(&ofs->tracked, ovl_slot(inode));
+}
+
+static bool ovl_marked(struct ovl_fs *ofs, unsigned long id)
+{
+	return xa_get_mark(&ofs->tracked, id, OVL_X_DIRTY) ||
+	       xa_get_mark(&ofs->tracked, id, OVL_X_TOWRITE) ||
+	       xa_get_mark(&ofs->tracked, id, OVL_X_WRITEBACK);
+}
+
+/* OVL_TRACKED is OVL_X_DIRTY without a walk down the tree */
+static void ovl_set_dirty(struct ovl_fs *ofs, struct inode *inode)
+{
+	unsigned long id = ovl_slot(inode);
+
+	lockdep_assert_held(&inode->i_lock);
+
+	if (ovl_test_flag(OVL_TRACKED, inode))
+		return;
+	if (!ovl_marked(ofs, id)) {
+		struct inode *upper = ovl_inode_upper(inode);
+
+		__iget(inode);
+		atomic_long_inc(&ofs->nr_tracked);
+		/* A sync reports what fails now, or what nobody has seen */
+		OVL_I(inode)->wb_err = filemap_sample_wb_err(upper->i_mapping);
+	}
+	ovl_set_flag(OVL_TRACKED, inode);
+	xa_set_mark(&ofs->tracked, id, OVL_X_DIRTY);
+}
+
+/* OVL_X_DIRTY goes first, nobody adds OVL_X_TOWRITE after that */
+static void ovl_clear_dirty(struct ovl_fs *ofs, struct inode *inode)
+{
+	unsigned long id = ovl_slot(inode);
+
+	lockdep_assert_held(&inode->i_lock);
+
+	ovl_clear_flag(OVL_TRACKED, inode);
+	xa_clear_mark(&ofs->tracked, id, OVL_X_DIRTY);
+	xa_clear_mark(&ofs->tracked, id, OVL_X_TOWRITE);
+}
+
+/*
+ * The upper inode was modified through this overlay, remember the overlay
+ * inode for syncfs() and unmount.  The caller holds a reference to @inode.
+ *
+ * Do not look at the upper inode here.  Its dirty flags are cleared when its
+ * writeback starts, not when it completes.
+ *
+ * Nobody needs an unlinked file to be durable, and the reference would keep its
+ * space.  An O_TMPFILE that can still get a name is not such a file.
+ *
+ * This takes i_lock even if @inode is tracked already, see ovl_untrack().
+ */
+void ovl_track_inode(struct inode *inode)
+{
+	if (!ovl_tracks_dirty(OVL_FS(inode->i_sb)) || !ovl_inode_upper(inode))
+		return;
+
+	spin_lock(&inode->i_lock);
+	if (inode->i_nlink || (inode_state_read(inode) & I_LINKABLE))
+		ovl_set_dirty(OVL_FS(inode->i_sb), inode);
+	spin_unlock(&inode->i_lock);
+}
+
+/*
+ * Is there nothing that a sync would have to do for the upper inode?  The
+ * caller holds i_lock.
+ *
+ * Stores through a shared mapping dirty the pages without a call into
+ * overlayfs, so the inode has to stay tracked while there may be one.  The
+ * mapping holds the real file open for writing.  Read i_writecount first: the
+ * page cache tag is set before the last fput().
+ *
+ * That does not cover pages that are pinned through such a mapping.  A direct
+ * read into it that completes after the last munmap() and close() dirties them
+ * with nobody looking.
+ *
+ * An error that was not reported yet is something to do as well.
+ */
+static bool ovl_upper_clean(struct inode *inode)
+{
+	struct inode *upper = ovl_inode_upper(inode);
+	struct address_space *mapping = upper->i_mapping;
+
+	if (atomic_read_acquire(&upper->i_writecount) > 0)
+		return false;
+
+	return !mapping_tagged(mapping, PAGECACHE_TAG_DIRTY) &&
+	       !mapping_tagged(mapping, PAGECACHE_TAG_WRITEBACK) &&
+	       !(inode_state_read_once(upper) & (I_DIRTY_ALL | I_SYNC)) &&
+	       !filemap_check_wb_err(mapping, OVL_I(inode)->wb_err);
+}
+
+enum ovl_untrack {
+	OVL_UNTRACK_ALWAYS,
+	OVL_UNTRACK_CLEAN,	/* if the upper inode is clean */
+	OVL_UNTRACK_UNLINKED,	/* if it has no link and cannot get one */
+};
+
+/*
+ * Take @inode out of the set.  The caller holds a reference to @inode of its
+ * own.
+ *
+ * The condition is looked at under i_lock as well.  A task that has called
+ * ovl_track_inode() before is ordered by i_lock, so what it did to the upper
+ * inode, or to the link count, is visible.  One that calls it later tracks
+ * @inode again.
+ */
+static bool ovl_untrack(struct inode *inode, enum ovl_untrack when)
+{
+	struct ovl_fs *ofs = OVL_FS(inode->i_sb);
+	unsigned long id = ovl_slot(inode);
+	bool done;
+
+	spin_lock(&inode->i_lock);
+	done = ovl_marked(ofs, id);
+	if (done && when == OVL_UNTRACK_CLEAN)
+		done = ovl_upper_clean(inode);
+	else if (done && when == OVL_UNTRACK_UNLINKED)
+		done = !inode->i_nlink &&
+		       (!(inode_state_read(inode) & I_LINKABLE) ||
+			hlist_empty(&inode->i_dentry));
+	if (done) {
+		ovl_clear_dirty(ofs, inode);
+		xa_clear_mark(&ofs->tracked, id, OVL_X_WRITEBACK);
+		atomic_long_dec(&ofs->nr_tracked);
+	}
+	spin_unlock(&inode->i_lock);
+
+	if (done)
+		iput(inode);
+	return done;
+}
+
+/*
+ * A link to @inode was removed, or a dentry of it has gone and it may be an
+ * O_TMPFILE that never got a name.  The caller holds a reference to @inode.
+ */
+void ovl_untrack_inode(struct inode *inode)
+{
+	if (ovl_tracks_dirty(OVL_FS(inode->i_sb)) && !inode->i_nlink)
+		ovl_untrack(inode, OVL_UNTRACK_UNLINKED);
+}
+
+/*
+ * Get a reference to the first inode with @mark from *@id on.  A mark is
+ * cleared before the reference of the set is dropped, so under the lock of the
+ * xarray an inode that has one is alive.
+ */
+static struct inode *ovl_next_marked(struct ovl_fs *ofs, unsigned long *id,
+				     xa_mark_t mark)
+{
+	struct inode *inode;
+
+	xa_lock(&ofs->tracked);
+	inode = xa_find(&ofs->tracked, id, ULONG_MAX, mark);
+	if (inode)
+		ihold(inode);
+	xa_unlock(&ofs->tracked);
+
+	return inode;
+}
+
+/* Does only lazytime keep @upper from being clean? */
+static bool ovl_only_lazytime(struct inode *upper)
+{
+	return (inode_state_read_once(upper) & I_DIRTY_ALL) == I_DIRTY_TIME &&
+	       atomic_read(&upper->i_writecount) <= 0;
+}
+
+/*
+ * Drop @inode if its upper inode is clean.
+ *
+ * lazytime holds timestamps back for up to a day.  The last iput() would write
+ * them, but that cannot come while the overlay inode is tracked.  So hand them
+ * to the upper filesystem.  Nobody has asked for them to be on disk, so there
+ * is nothing to wait for.
+ */
+static void ovl_release_inode(struct vfsmount *mnt, struct inode *inode)
+{
+	struct inode *upper = ovl_inode_upper(inode);
+	int err;
+
+	if (ovl_untrack(inode, OVL_UNTRACK_CLEAN) ||
+	    !ovl_only_lazytime(upper) || mnt_get_write_access(mnt))
+		return;
+
+	err = write_inode_for_sync(upper);
+	mnt_put_write_access(mnt);
+	if (err)
+		errseq_set(&inode->i_sb->s_wb_err, err);
+
+	ovl_untrack(inode, OVL_UNTRACK_CLEAN);
+}
+
+/*
+ * Look at up to *@nr inodes with @mark.  Dropping one writes nothing, so that
+ * also works on an upper filesystem that has become read-only.  It keeps a
+ * freeze out, because on a frozen filesystem dropping the last reference to an
+ * inode that was unlinked sleeps until the thaw.
+ */
+static void ovl_scan_marked(struct ovl_fs *ofs, xa_mark_t mark,
+			    unsigned long *id, unsigned long *nr)
+{
+	struct vfsmount *mnt = ovl_upper_mnt(ofs);
+	struct inode *inode;
+
+	while (*nr && sb_start_write_trylock(mnt->mnt_sb)) {
+		--*nr;
+		inode = ovl_next_marked(ofs, id, mark);
+		if (inode) {
+			ovl_release_inode(mnt, inode);
+			iput(inode);
+		}
+		sb_end_write(mnt->mnt_sb);
+
+		if (!inode) {
+			*id = 0;
+			break;
+		}
+		++*id;
+		cond_resched();
+	}
+}
+
+/*
+ * An inode may be left with OVL_X_WRITEBACK alone, if a sync did not get to
+ * wait for it.
+ */
+static void ovl_release_work(struct work_struct *work)
+{
+	struct ovl_fs *ofs = container_of(work, struct ovl_fs, release_work);
+	unsigned long nr = atomic_long_xchg(&ofs->release_nr, 0);
+
+	ovl_scan_marked(ofs, OVL_X_DIRTY, &ofs->release_id[0], &nr);
+	ovl_scan_marked(ofs, OVL_X_WRITEBACK, &ofs->release_id[1], &nr);
+}
+
+void ovl_track_init(struct ovl_fs *ofs)
+{
+	xa_init_flags(&ofs->tracked, XA_FLAGS_ACCOUNT);
+	INIT_WORK(&ofs->release_work, ovl_release_work);
+}
+
+void ovl_track_exit(struct ovl_fs *ofs)
+{
+	unsigned long id = 0;
+
+	/* Not xa_empty(), an insert that has failed can leave nodes behind */
+	WARN_ON(xa_find(&ofs->tracked, &id, ULONG_MAX, XA_PRESENT));
+	xa_destroy(&ofs->tracked);
+}
+
+/*
+ * Unmount.  The sync of generic_shutdown_super() has written what it could, if
+ * the overlay is not read-only.  evict_inodes() has left alone what is still
+ * in the set.  Trap inodes can be in the xarray as well, without a mark.
+ */
+void ovl_drop_tracked(struct ovl_fs *ofs)
+{
+	struct inode *inode;
+	unsigned long id;
+
+	cancel_work_sync(&ofs->release_work);
+
+	xa_for_each(&ofs->tracked, id, inode) {
+		ihold(inode);
+		ovl_untrack(inode, OVL_UNTRACK_ALWAYS);
+		iput(inode);
+		cond_resched();
+	}
+}
+
+long ovl_nr_cached_objects(struct super_block *sb, struct shrink_control *sc)
+{
+	return atomic_long_read(&OVL_FS(sb)->nr_tracked);
+}
+
+/*
+ * A tracked inode, its upper inode and the dentry of that cannot be reclaimed.
+ * While the upper inode is dirty that is as with any filesystem.  Afterwards
+ * nothing tells overlayfs, so look when memory is needed.
+ *
+ * Not from reclaim itself.  The reference that is dropped may be the last one
+ * to an upper inode that was unlinked, and handing over timestamps takes locks
+ * of an upper inode that is in use.  Filesystems allocate memory under the
+ * locks that both need.
+ */
+long ovl_free_cached_objects(struct super_block *sb, struct shrink_control *sc)
+{
+	struct ovl_fs *ofs = OVL_FS(sb);
+
+	atomic_long_add(sc->nr_to_scan, &ofs->release_nr);
+	queue_work(system_dfl_wq, &ofs->release_work);
+
+	return 0;
+}

-- 
2.55.0

