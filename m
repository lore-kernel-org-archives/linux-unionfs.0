Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.160.179
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793972226;
	b=FC2RB8vi5LbRZbcnP1FqNaxp/D/aqV7fYa/bjeLvRt6WxqbG8CJ4FHkY4NQHNtqQgoDr
	 oC/uoXXvd9fO4YQl4iS2PpZVVsSIKrzcOia5q7NHJ6fpm/ugdCas7xIv5uQXHP9/+T1qi
	 +WL17w0CGSU2SX4B3UVtMswaVCRXBppZeBXOYjzncw/ZaLhCXk13SuxJcNqzuHSTlPW/E
	 7Q4Y4WSqSshHaY/gknmpmwsleVnboGo2i0eMbW3Dfv2OUDdBT1nOpgBot42+DVRygUSeM
	 jQoZUdg2WOlO1tAEQ5o2+oh+izF22FS8/Gcp1OIL8vUkQ7hmCo/3/rS+6tvQLqHgb8w==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793972226;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 From:Date:Subject:MIME-Version:Content-Type:Content-Transfer-Encoding:
	 Message-Id:References:In-Reply-To:To:Cc:X-Mailer:
	 X-Developer-Signature:X-Developer-Key;
	bh=e50fdLujD19GXFsNWyHjjIS2DU+IkUb9BQTJ0ZpFODI=;
	b=B5mPcSCxytLxJoxsO8YkDXDIxGKIhs3a0yfCm6KEjg7H6YxfyHBfU+8T0qdVcH+Dg+RG
	 WzzSsWQfZ5oy9toJvbsDJmCSz/MexkS15m0u0g7ZRnWBylgPwRqjMvxQVRMxFT6JpRHML
	 j2joFvIu2j3lfoqA4WUP1V+6w3NXIa5Hp0C/dcQlI0yjeW66VhjsAuWnI/iFp4gY0ay44
	 SrAFks2AQ16wm/QBpUp8WQ0N+8v9aJIjJztUjpEVkaFboh/mZ1D8lDwe71i/QVQJGS4Rm
	 6BG3dFLeY5U1LUUl44vpnAueydXmLgYOr4KwW12icgkRhhsr6Lpw8J1gjAuvDetYufg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=none header.from=toxicpanda.com;
	spf=pass smtp.mailfrom=toxicpanda.com;
	dkim=pass header.d=toxicpanda.com header.i=@toxicpanda.com header.a=rsa-sha256 header.s=google header.b=eiK+teLW;
	arc=none smtp.remote-ip=209.85.160.179
Received: from mail-qt1-f179.google.com (mail-qt1-f179.google.com [209.85.160.179])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E05F3606A32C
	for <linux-unionfs@vger.kernel.org>; Fri,  6 Nov 2026 13:37:05 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org E05F3606A32C
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=toxicpanda.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=toxicpanda.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=toxicpanda.com header.i=@toxicpanda.com header.a=rsa-sha256 header.s=google header.b=eiK+teLW
Received: by mail-qt1-f179.google.com with SMTP id d75a77b69052e-533861a59b8so6602881cf.1
        for <linux-unionfs@vger.kernel.org>; Fri, 06 Nov 2026 05:37:05 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=toxicpanda.com; s=google; t=1793972225; x=1794577025; darn=vger.kernel.org;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :content-type:mime-version:subject:date:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=e50fdLujD19GXFsNWyHjjIS2DU+IkUb9BQTJ0ZpFODI=;
        b=eiK+teLW5U077y8fZowXrErpg3IOeqOdtbFsavI+Xq9f2dZZuoZstcoyUwh1TwtA7b
         aLfgkuNBSimCLrAFos+JTCHCXIFHolSRaqDFLZFl8kWyRaunoYDfbmOvEv1fWd+EeG3c
         YwJuTBKR8v+V9MDzEXXDw6tsGffdk6AjF6Fi8z+m3l4Q18gGNRflYmIAZuc6cSqQqrrY
         yYglR6MQ59b5+/SJp9V6pyRMCB16zOuQkJgCqjjRe3HeSOAB0JFJN330syaL11syO+kE
         j/UUI95BiFoH9Z75LbmZPNSdAZfZqA/ChynismTTa2Dhie+HD6ktUw5nlz73gPlz8py8
         jY0w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793972225; x=1794577025;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :content-type:mime-version:subject:date:from:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=e50fdLujD19GXFsNWyHjjIS2DU+IkUb9BQTJ0ZpFODI=;
        b=D2pZFGEcVJ/IbyXhhmhlXOs9MFriivBQ20uS0KqsR47Ait8cKOtdztymZLtRvL7tww
         ly0Qu97kW2updSPiBGuMY1K9ZjD1N+1WVizxdULJPZiZdk1youCTusq9AatjFP5Eh6xd
         roOVTyym8Vspzt4bFi053r+60UICxMyVoQBq93xeHp4az7ducL5aRTYj0g4Rnt5x46/O
         Mu0tZHxccfp0cCCpaZhdYfzUdGgzyUESRw1xPAyi8h0c3aISgggsXRxvF+2hhyWFsNmP
         4/O91YcxPqW6YKpr19GGlISCiNVD5kMG2bBzlHlXGSWWyP314zuR2WWjDB32/xWqpyue
         JAVw==
X-Forwarded-Encrypted: i=1; AKwUvBxUuKNlBWEkjvC1VuIQRs8BdR2lRUsrQD3OKZElPOj7FSGKkbcKH2Gj3NiMhGFhEBHkuVnDjnSpJSU3+ZmC@vger.kernel.org
X-Gm-Message-State: APuU4Z/T0OMsAGg6x5U4J0s94l94pKwzOhk9PHKk/7t6E5/abIv+Zyc6
	1YMWxFbKtMCZErA9PqXc3E9ojea8cO2sNR3MadQN1W1eHoU9Bfi4R4VaB+V5t4ahA3U=
X-Gm-Gg: AYBFou0umwpMbznnLEuB3HEk57O71Xd4vlFxGmdoDrw7KSHFDk0G9TCO7f7n1XSARgb
	E5BArFlq2nIBE7nHOU8wIsuiKIHINKi3G8S4oMw1olcJUdHW0lUytryq5MKPPK311NsIx0NauZr
	mMuXhqgkK03RhZFsy4uMWt3sRaQZsaphB+VLQwUDPU0CuTDTqLxpO/GFLvdTYGdm0YclkRdHRt3
	5GJe/iQHIGULPp7P+TJCBS88vLK8xJ1BwRf/hGJzGO2B+eOIlqyod3JiRoBZkVZNdocJVcUbtrO
	RR4KKaQCnRsGWRpPDii7PwMDsAiJqZcgdwKTq8wkimUO9Fat1s9a/+DZVxP0UQx2NOoNWtRXfW0
	sTuB1fzeNHKcUaJkTzUh0jPUy0P7AR59JstPh6I/K7XDq6Pg5fBgFUm0HWMfCvgFrIbBCjcmlJT
	eYcPGIgSnzAJ/H+U4W0N8Ro45yrL+eJnjj3oSwcktRC42FDVpo/yv4f8jeHY6oA+slSqiDeEbok
	c8qXJX703MSHqeDCFjPhGjk8ZJEp3r3cRXSDNZhypk9e5pCQ+1u8+V7PtfzIPgLEwp7azKVpWdu
	CdQya/nhsWUvq29ZOW12GeHM1vBiMSObogstWJnafbJUxQ==
X-Received: by 2002:a05:622a:5c1a:b0:536:5e62:4647 with SMTP id d75a77b69052e-54e13098132mr42234321cf.16.1793972224813;
        Fri, 06 Nov 2026 05:37:04 -0800 (PST)
Received: from toxicpanda.com ([153.61.196.244])
        by smtp.gmail.com with ESMTPSA id d75a77b69052e-54e270179f0sm20539301cf.26.2026.11.06.05.37.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 06 Nov 2026 05:37:04 -0800 (PST)
From: Josef Bacik <josef@toxicpanda.com>
Date: Fri, 06 Nov 2026 13:36:46 +0000
Subject: [PATCH v4 4/8] ovl: mark the overlay inode dirty on modification
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
Message-Id: <20261106-b4-ovl-containerized-sync-v4-4-6ddde0b7dd8a@toxicpanda.com>
References: <20261106-b4-ovl-containerized-sync-v4-0-6ddde0b7dd8a@toxicpanda.com>
In-Reply-To: <20261106-b4-ovl-containerized-sync-v4-0-6ddde0b7dd8a@toxicpanda.com>
To: Miklos Szeredi <miklos@szeredi.hu>, Amir Goldstein <amir73il@gmail.com>, 
 Christian Brauner <brauner@kernel.org>
Cc: Alexander Viro <viro@zeniv.linux.org.uk>, Jan Kara <jack@suse.cz>, 
 Christoph Hellwig <hch@infradead.org>, Chris Mason <mason@kernel.org>, 
 Chengguang Xu <cgxu519@mykernel.net>, linux-unionfs@vger.kernel.org, 
 linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org, 
 Josef Bacik <josef@toxicpanda.com>
X-Mailer: b4 0.15.2
X-Developer-Signature: v=1; a=openssh-sha256; t=1793972217; l=6376;
 i=josef@toxicpanda.com; h=from:subject:message-id;
 bh=TU06+rREPT1daQiI8+LqLuaKoTaGv9ykYfd+dewLeWw=;
 b=U1NIU0lHAAAAAQAAADMAAAALc3NoLWVkMjU1MTkAAAAgUBr36M/n0nWN0DNbnxwzIiCZez6MG
 JiruuNaSCI/zXsAAAAGcGF0YXR0AAAAAAAAAAZzaGE1MTIAAABTAAAAC3NzaC1lZDI1NTE5AAAA
 QPJMikO87ALC9liebhoY3ZY7b+zm/iAQdQ2PXnZhu0U66qRi7laEa/opwe4eWk91UL1bM2yNvCN
 I3ceFKkfZkgM=
X-Developer-Key: i=josef@toxicpanda.com; a=openssh;
 fpr=SHA256:C8kOX2QUJCMqnCX+KEeoqRAjLo9L+ELOSH2NSAJHqGA

To sync only what was written through an overlay, we have to know which
upper inodes were modified through it.  Mark the overlay inode dirty when
its upper inode is modified, which puts it on the dirty list of the
overlay's bdi.

Nearly every modification ends in ovl_copyattr(), so do it there.  Copy up,
the data copy up of a metacopy inode, atime updates and shared writable
mappings do not, so they mark the inode themselves.

Do not mark an unhashed inode.  __mark_inode_dirty() would set its dirty
flags without queueing it, and every later call would return early.  The
inode of a lower hardlink is unhashed until ovl_inode_update() hashes it.

Based on work by Chengguang Xu.

Link: https://lore.kernel.org/r/20211122030038.1938875-1-cgxu519@mykernel.net
Suggested-by: Amir Goldstein <amir73il@gmail.com>
Suggested-by: Miklos Szeredi <miklos@szeredi.hu>
Signed-off-by: Josef Bacik <josef@toxicpanda.com>
---
 fs/overlayfs/copy_up.c   |  5 +++++
 fs/overlayfs/file.c      |  7 ++++++-
 fs/overlayfs/inode.c     |  4 +++-
 fs/overlayfs/overlayfs.h | 20 ++++++++++++++++++++
 fs/overlayfs/util.c      | 14 +++++++++++++-
 5 files changed, 47 insertions(+), 3 deletions(-)

diff --git a/fs/overlayfs/copy_up.c b/fs/overlayfs/copy_up.c
index e963701b4c87..40486d2a4b30 100644
--- a/fs/overlayfs/copy_up.c
+++ b/fs/overlayfs/copy_up.c
@@ -1122,6 +1122,11 @@ static int ovl_copy_up_meta_inode_data(struct ovl_copy_up_ctx *c)
 	ovl_clear_flag(OVL_HAS_DIGEST, d_inode(c->dentry));
 	ovl_clear_flag(OVL_VERIFIED_DIGEST, d_inode(c->dentry));
 	ovl_set_upperdata(d_inode(c->dentry));
+	/*
+	 * The data was written to the upper inode, and there may be no later
+	 * write that would mark the overlay inode dirty.
+	 */
+	ovl_mark_inode_dirty(d_inode(c->dentry));
 out_free:
 	kfree(capability);
 out:
diff --git a/fs/overlayfs/file.c b/fs/overlayfs/file.c
index 7433220d4ad6..53c5131a0482 100644
--- a/fs/overlayfs/file.c
+++ b/fs/overlayfs/file.c
@@ -472,8 +472,13 @@ static int ovl_mmap(struct file *file, struct vm_area_struct *vma)
 		.cred = ovl_creds(file_inode(file)->i_sb),
 		.accessed = ovl_file_accessed,
 	};
+	int err;
 
-	return backing_file_mmap(of->realfile, vma, &ctx);
+	err = backing_file_mmap(of->realfile, vma, &ctx);
+	/* Stores through the mapping go straight to the upper inode */
+	if (!err && vma_is_shared_maywrite(vma))
+		ovl_mark_inode_dirty(file_inode(file));
+	return err;
 }
 
 static long ovl_fallocate(struct file *file, int mode, loff_t offset, loff_t len)
diff --git a/fs/overlayfs/inode.c b/fs/overlayfs/inode.c
index 63906b3dafcb..9a4bf7c2502b 100644
--- a/fs/overlayfs/inode.c
+++ b/fs/overlayfs/inode.c
@@ -587,6 +587,7 @@ int ovl_update_time(struct inode *inode, enum fs_update_time type,
 			touch_atime(&upperpath);
 			inode_set_atime_to_ts(inode,
 					      inode_get_atime(d_inode(upperpath.dentry)));
+			ovl_mark_inode_dirty(inode);
 		}
 	}
 	return 0;
@@ -898,7 +899,8 @@ void ovl_inode_init(struct inode *inode, struct ovl_inode_params *oip,
 	oi->lowerdata_redirect = oip->lowerdata_redirect;
 
 	realinode = ovl_inode_real(inode);
-	ovl_copyattr(inode);
+	/* Nothing was changed, the inode is only being looked up */
+	__ovl_copyattr(inode);
 	ovl_copyflags(realinode, inode);
 	ovl_map_ino(inode, ino, fsid);
 }
diff --git a/fs/overlayfs/overlayfs.h b/fs/overlayfs/overlayfs.h
index 5b1a097ce543..5a1479863a6f 100644
--- a/fs/overlayfs/overlayfs.h
+++ b/fs/overlayfs/overlayfs.h
@@ -691,6 +691,25 @@ static inline bool ovl_should_sync_upper_fs(struct ovl_fs *ofs)
 	return ovl_should_sync(ofs) && !ovl_tracks_dirty(ofs);
 }
 
+/*
+ * The upper inode was modified through this overlay.  Put the overlay inode on
+ * the dirty list of the overlay, where syncfs() and unmount find it.
+ *
+ * Do not look at the dirty flags of the upper inode here.  They are cleared
+ * when the writeback of the upper inode starts, not when it completes.
+ *
+ * Do not mark an inode that is not hashed.  __mark_inode_dirty() would set its
+ * dirty flags without putting it on a dirty list, and once the flags are set,
+ * later calls return early.  The overlay inode of a lower hardlink is unhashed
+ * until ovl_inode_update() hashes it, and ovl_inode_update() marks it after
+ * that.
+ */
+static inline void ovl_mark_inode_dirty(struct inode *inode)
+{
+	if (ovl_tracks_dirty(OVL_FS(inode->i_sb)) && !inode_unhashed(inode))
+		mark_inode_dirty(inode);
+}
+
 /*
  * To avoid regressions in existing setups with overlay lower offline changes,
  * we allow lower changes only if none of the new features are used.
@@ -878,6 +897,7 @@ bool ovl_lookup_trap_inode(struct super_block *sb, struct dentry *dir);
 struct inode *ovl_get_trap_inode(struct super_block *sb, struct dentry *dir);
 struct inode *ovl_get_inode(struct super_block *sb,
 			    struct ovl_inode_params *oip);
+void __ovl_copyattr(struct inode *to);
 void ovl_copyattr(struct inode *to);
 
 /* vfs fileattr flags read from overlay.protattr xattr to ovl inode */
diff --git a/fs/overlayfs/util.c b/fs/overlayfs/util.c
index 521717209b2e..f32202500b3d 100644
--- a/fs/overlayfs/util.c
+++ b/fs/overlayfs/util.c
@@ -604,6 +604,8 @@ void ovl_inode_update(struct inode *inode, struct dentry *upperdentry)
 		inode->i_private = upperinode;
 		__insert_inode_hash(inode, (unsigned long) upperinode);
 	}
+	/* The copy up has written to the upper inode */
+	ovl_mark_inode_dirty(inode);
 }
 
 static void ovl_dir_version_inc(struct dentry *dentry, bool impurity)
@@ -1492,7 +1494,7 @@ int ovl_sync_status(struct ovl_fs *ofs)
  * map any lower or upper inode owned by id 1001 to id 1000. These mapping
  * helpers are nops when the relevant layer isn't idmapped.
  */
-void ovl_copyattr(struct inode *inode)
+void __ovl_copyattr(struct inode *inode)
 {
 	struct path realpath;
 	struct inode *realinode;
@@ -1516,3 +1518,13 @@ void ovl_copyattr(struct inode *inode)
 	i_size_write(inode, i_size_read(realinode));
 	spin_unlock(&inode->i_lock);
 }
+
+/*
+ * The attributes are copied because the real inode was modified through the
+ * overlay, so this is also where the overlay inode is marked dirty.
+ */
+void ovl_copyattr(struct inode *inode)
+{
+	__ovl_copyattr(inode);
+	ovl_mark_inode_dirty(inode);
+}

-- 
2.55.0

