Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.222.172
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793825123;
	b=Uk+72I2tYV4sOzI6F34KHNYY8QnrdDUxCbrCje6ZFarFKgQBXLNc9wVx7dFLcHyfCBfB
	 xp6qrcMwMymKC756ASiu7ZKYzemZA4RUVakLrYQCkFgbZnnh9UztF1OTBL1SCga8YPyzC
	 ts8OqKvPqpsqIVnJ64D40gf1DOdYFKmYBrIYQw74FitK6qAZn762KiFQqViAJxDP5CxCT
	 GSl0JjFE3jcLnRysXPVhR4jAxXyYmzaMsB7LkNLV/DJ9/XS/fm+NUb6Yf927oRFyyWUaH
	 M7Nl829I7uP+hMVY1qzZEg0pNVcpbMfOWnzHwN6NGEOWD/ksv1FJojYAi6aBXkmfRrA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793825123;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 From:Date:Subject:MIME-Version:Content-Type:Content-Transfer-Encoding:
	 Message-Id:References:In-Reply-To:To:Cc:X-Mailer:
	 X-Developer-Signature:X-Developer-Key;
	bh=EQwID2Oh8rCQ0gGKnGbAeXoCyD7h019Ha+hxH2LRHRI=;
	b=fWdWwcHzOHBmniQmqAkbaZMvo2pa+AFkXnFWRWAVLgAC4QNBbu7U4sVxnRzhdgZnskga
	 Q428NAdeaI9KrAW+QKSRusJPqQ3ogBIv371fyZiwfj0vS6dj0lYJw9/OK2eTjoCdE+Opm
	 XUFX4U/wIdCVmxHWFI9CZGqGa6rqzB6HNXyp5/Hhi6L7MkyHD+xBpoSBet6t/2yaRSv66
	 uHoD3FsLjo/NQPp7VEdfr4r+dOeaetTFZn1Ym4XMv8vr1D38CvGIbSWZyNmBFEXZF9A4E
	 Vnv/2amc3Ef7gE8zEntYEq9ikFg+R815fZWzWlzOoAVurt5ZcBFWmvLyIhu31XYMemA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=none header.from=toxicpanda.com;
	spf=pass smtp.mailfrom=toxicpanda.com;
	dkim=pass header.d=toxicpanda.com header.i=@toxicpanda.com header.a=rsa-sha256 header.s=google header.b=dqj1YiHD;
	arc=none smtp.remote-ip=209.85.222.172
Received: from mail-qk1-f172.google.com (mail-qk1-f172.google.com [209.85.222.172])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7BD6B6077B41
	for <linux-unionfs@vger.kernel.org>; Wed,  4 Nov 2026 20:45:23 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 7BD6B6077B41
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=toxicpanda.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=toxicpanda.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=toxicpanda.com header.i=@toxicpanda.com header.a=rsa-sha256 header.s=google header.b=dqj1YiHD
Received: by mail-qk1-f172.google.com with SMTP id af79cd13be357-93f3c8958d5so126821885a.2
        for <linux-unionfs@vger.kernel.org>; Wed, 04 Nov 2026 12:45:23 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=toxicpanda.com; s=google; t=1793825122; x=1794429922; darn=vger.kernel.org;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :content-type:mime-version:subject:date:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=EQwID2Oh8rCQ0gGKnGbAeXoCyD7h019Ha+hxH2LRHRI=;
        b=dqj1YiHD9KhEyGNojZtiggFHE5t3sCjHUCZGrBnXuZD1uFaU4+k6igSAPnoAnz7WL8
         d5LeF0gra4nMwDNxWcBlXi03nIWyfIUh9g3fqDmpPXIRKrFt3/0xz5GyZ3n79/h3SZK4
         YsBNssE9XZLSSvx64FBKiVzxSRWddbwA0jsk3Z8iy434Ooh9uH8leeNKAeVKHC8Fd76C
         GKibP/sCde6LVBFUYKBjEFUkjStJbH0+OffXDi9bsPBagfm+vCnfuM4njtxHh9rFXvtA
         FYLzv7qtjICt5WPW3uDJkERYcLf7CMomfWTVz5C+eBmItCF+aU/qSeAriY0srvqED9Ik
         97BA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793825122; x=1794429922;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :content-type:mime-version:subject:date:from:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=EQwID2Oh8rCQ0gGKnGbAeXoCyD7h019Ha+hxH2LRHRI=;
        b=wihUXxmx1xoZrjmA7Xv9CixKQuTNNOyHW5ceocKoL2JvGZk6/l0Vfq9Bpaiq07XH4U
         5+EbFRY53NeHP/f6cfamYdQJZIP/bJZGxcIFE14F5ujhp3DZ0gXgOluj8EBetIcLbNjm
         IOdlFH9/j84v590DYJGHj3+/9pksq0MwAb44MOj8YlvImo/FE1foxyujcfR1FTKR2Sut
         vi9zw3FlUJ+z810AodGzBtG/lZYGIU8Po5dhIjfpldRN/wSflKknPsXgRSgIABVXTP4m
         H+IU98RTs/d+SEp63QmwtAXaXEnYqXv4uZDl3q5mz871Oe9WM4nbtZSdq7ID3BbnNRgN
         7pIg==
X-Forwarded-Encrypted: i=1; AKwUvByTztpDmuGnw+qRHHT20NUjUPgKUsDSCIbVxGR0W9MOrkD+qCGScYhQFobpuMHgGLR/en8mrAtILW20iQXP@vger.kernel.org
X-Gm-Message-State: APuU4Z8dZ/nsQcP+7afJpj3ecMWbvdVQ5qhQ/NgEtvXk8g/z5ftWNWH8
	pFa3su5Ym1/ZIV+vrObbvV447jBxigOKsTH2izUYGh3kC8pzoREbQQLGJ1vafxopIhI=
X-Gm-Gg: AYBFou2V4Kr1ob5xSX3M5KysN0Jmyn+akYfdIxyuC1EH1/1Qs+MJrnm9eE+MaoVfOKw
	ncGFykOd3YgkqCjYcphAFHsg2zqEA38+Y09HnXG7GF6b+1aOxeto43fG15n7Jh4WNBikwrSBiDo
	l7JxVFcy5i4woc1R0xQL3XD8RbpNyywvE280uL5AmrFa3jXQfP8g4oRty9bd6JV5tV5uIim6gn/
	xeKhkWQ7j45dgsNPZYjOOJCusiQ+gW7diy5JI8GWUny+xuRP/WrmW1vsmsg4g6TEdYbXjXB3h3N
	OJWNwdRrK+WYWt7Z1MTB8FoMSd8oIZAg+QIEOhfxjBNgHYxYZWSmuxP6AFww91JlFmVUXauNrSo
	YLNIYmkUvNRy6XdaEsoePRx2th0BAZvUw8ia4ukqKUwL6NGQRlSLR/iCry6MFTZbrRJbnXH4mmT
	OXf6DQTqECKVYhFRN9LeLd1dDGR3xIO4YeNQCLDwo5ctJDcBkyHHPXTk2h5RN9qRgzz4tn71qzj
	akeutV0Z7oci/DmMBqFs1Yc2WQHe58iekGATzobpGDisbgdSJ0ZlVCln63mkxC9EWu+j/Kdz5om
	CYiNSEXMf5dLxpuYSG54lZ9LG6irp8vp7tNrF+1/QTTQDQ==
X-Received: by 2002:a05:620a:44d1:b0:93e:d5c1:da49 with SMTP id af79cd13be357-9442176424fmr2847202785a.82.1793825122213;
        Wed, 04 Nov 2026 12:45:22 -0800 (PST)
Received: from toxicpanda.com ([153.61.196.241])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-945d4844991sm293202785a.28.2026.11.04.12.45.21
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 04 Nov 2026 12:45:21 -0800 (PST)
From: Josef Bacik <josef@toxicpanda.com>
Date: Wed, 04 Nov 2026 20:45:01 +0000
Subject: [PATCH v3 4/8] ovl: mark the overlay inode dirty on modification
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
Message-Id: <20261104-b4-ovl-containerized-sync-v3-4-8daa20144f53@toxicpanda.com>
References: <20261104-b4-ovl-containerized-sync-v3-0-8daa20144f53@toxicpanda.com>
In-Reply-To: <20261104-b4-ovl-containerized-sync-v3-0-8daa20144f53@toxicpanda.com>
To: Miklos Szeredi <miklos@szeredi.hu>, Amir Goldstein <amir73il@gmail.com>, 
 Christian Brauner <brauner@kernel.org>
Cc: Alexander Viro <viro@zeniv.linux.org.uk>, Jan Kara <jack@suse.cz>, 
 Christoph Hellwig <hch@infradead.org>, Chris Mason <mason@kernel.org>, 
 Chengguang Xu <cgxu519@mykernel.net>, linux-unionfs@vger.kernel.org, 
 linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org, 
 Josef Bacik <josef@toxicpanda.com>
X-Mailer: b4 0.15.2
X-Developer-Signature: v=1; a=openssh-sha256; t=1793825112; l=6381;
 i=josef@toxicpanda.com; h=from:subject:message-id;
 bh=QNBnU8ETCXOY18xuHvDpPba2xPcdvHhigZC7Ldteyno=;
 b=U1NIU0lHAAAAAQAAADMAAAALc3NoLWVkMjU1MTkAAAAgUBr36M/n0nWN0DNbnxwzIiCZez6MG
 JiruuNaSCI/zXsAAAAGcGF0YXR0AAAAAAAAAAZzaGE1MTIAAABTAAAAC3NzaC1lZDI1NTE5AAAA
 QO7JYt6A+Cj7eDx8/F+MAAONria6WMYHQbDTAiUrNxVJEx742Peq2x53lxilRL/G+MDsuSS5eNK
 ScglINEq7hAE=
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
index 0ef81c7a9701..bc68150ccf68 100644
--- a/fs/overlayfs/overlayfs.h
+++ b/fs/overlayfs/overlayfs.h
@@ -701,6 +701,25 @@ static inline bool ovl_tracks_dirty(struct ovl_fs *ofs)
 	return ovl_upper_mnt(ofs)->mnt_sb->s_bdi != &noop_backing_dev_info;
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
@@ -888,6 +907,7 @@ bool ovl_lookup_trap_inode(struct super_block *sb, struct dentry *dir);
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

