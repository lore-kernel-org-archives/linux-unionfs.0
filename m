Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.219.45
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793972236;
	b=B+E7Oku3ZpNPUi9kvXwKpaPPuH0mlFDk+O9HNM3Uv6bdgxHWSSPxjoqM48HNKLLd8Cng
	 Zjid1co3Cz4sQnuQvp1E3tYt1DTY2mlVQLOh8ZYEuf9gDQDxjUS73WywKmTFmaWyGHgKT
	 2Rk4kfz1cBk7sQO/W6OJ4cR6kn2vwdRQ0kGFm8moghyt/CEvd2NoAjduMmhxN2uEA9Pve
	 TNcrHeeD5a4L9aekwcWjYGEMf/PErxOUuYuegeq4wIvdQZG4LTHg9maxG57Zjrv/4lh/s
	 NmW2HaoUNXm+IUSYdZ+wUQHVkH3hcCT0/rm1UmvlFQj0vZJ2Kn2dufIg07StFepm/3A==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793972236;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 From:Date:Subject:MIME-Version:Content-Type:Content-Transfer-Encoding:
	 Message-Id:References:In-Reply-To:To:Cc:X-Mailer:
	 X-Developer-Signature:X-Developer-Key;
	bh=xLV0NTItWVb6Of/QLnfvc3FL+Jzfuvj2EKq+VHcPs88=;
	b=n9Y1RIeo4LjbnAcJJGe0MYAvan+3m/DoxK1qzNh5hkhE/TxQg5szkxB6f+25q11eLKE9
	 MHWZS/0GyYS03LxgHmNtY6fs3GrJWdQdz8oPpcIQWj+j+2tgtIolS2mQmaN0KmLRvfcNy
	 yNhyHwBqaTPBGnXfIVO9Y67WTAO4MXC86ig2uHHmEyxufGIffDXAHqkoSMQs8cXNfX2VM
	 ppNPInpY4xMM8Onxh0PBVi7s8CV97/6MecETek/jwRlEnUEaw3dK7Nu0q9qkrhLBI7+To
	 WEVQFmlvSdR0zkz4uDFRowSNbCxiSIOBHudGC991YPTs4T3TPHt4oXYszK5SVuzbwCA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=none header.from=toxicpanda.com;
	spf=pass smtp.mailfrom=toxicpanda.com;
	dkim=pass header.d=toxicpanda.com header.i=@toxicpanda.com header.a=rsa-sha256 header.s=google header.b=U6kTvX5b;
	arc=none smtp.remote-ip=209.85.219.45
Received: from mail-qv1-f45.google.com (mail-qv1-f45.google.com [209.85.219.45])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D6A7D606A326
	for <linux-unionfs@vger.kernel.org>; Fri,  6 Nov 2026 13:37:10 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org D6A7D606A326
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=toxicpanda.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=toxicpanda.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=toxicpanda.com header.i=@toxicpanda.com header.a=rsa-sha256 header.s=google header.b=U6kTvX5b
Received: by mail-qv1-f45.google.com with SMTP id 6a1803df08f44-91791ec1b83so4583846d6.1
        for <linux-unionfs@vger.kernel.org>; Fri, 06 Nov 2026 05:37:10 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=toxicpanda.com; s=google; t=1793972230; x=1794577030; darn=vger.kernel.org;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :content-type:mime-version:subject:date:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=xLV0NTItWVb6Of/QLnfvc3FL+Jzfuvj2EKq+VHcPs88=;
        b=U6kTvX5bh/Ii+g6KaruNuhE9tu0zNCnZIF+M+hcRoKzjSTEBWhjv6XPCdk/+TET6aa
         9clPbFlhvS4IOPmLLY6pNi6fK4NGQ49f6JjpoboYdB/10+wH196nxQ+P+DmJPGUFwoNF
         ybI8NSupoP+4gSUvNOSCBbXDleW4+V5lMzInL2oepK4tysDt3LS9Uh28e824XOJz/ECd
         X5rWB1y91GrnyoVg8/gZXQ9JJjF+GPVZCkroSN3ToGUsc4tZkSTrQS0SJ4Db7t6Pm4Qd
         hTxFkMwt8WVEnBCs5VXYy/mVlhNNJptGFJpeDUQj+SxvM9+CoVBE5NdMLXmft7glqSLR
         aIpg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793972230; x=1794577030;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :content-type:mime-version:subject:date:from:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=xLV0NTItWVb6Of/QLnfvc3FL+Jzfuvj2EKq+VHcPs88=;
        b=PseKb/L2H0zsG/Qngpu1jImx+x77kvlH4uhOXzXolyZxg8Z5wmkpp7UtNTLCkfjO5d
         aV7oLVghBswzUIK3+FkM3NNb55/IYV6be186eoGTaRLKWOswWucY607aAOkLtm7I7UYc
         EsnTXSoz78msfcyKb4N/cFoF0Nx714sFs7+Aj0LbtdJeillC+8YBW6YIdRKjQ2NClidx
         c6Y7gVSVg0T3ayw8CgqKlviH+gTEaG33m9V12hc4szd3PuAlZYCV7MbsSywfk12vCY6z
         /fOqhYaR5Pvw6Iheud77dRRhuUT9iZSS5G2KfXsJR1ljWAF/J6PX9Pj+KPaKLmjpF6bE
         824Q==
X-Forwarded-Encrypted: i=1; AL+hErHCXq+XwFPxetxa5A1/7iVkRy2P3LcSUOoUpEMq6TUwjsv4Y/c4MwB73jvSmRb7kdQa3G/9guKo0E91/vXu@vger.kernel.org
X-Gm-Message-State: APuU4Z9wwI6wnEnj5xqX9hfUgpqTjCIgIZ0VlOR+ly7AfHGUmLYtTGbE
	keFq2ECRMXIMs+qNeXCCasg8LAepu1y9Vv4RqxvE5VUb8U/2VmOZD017rNAQ05w3VjE=
X-Gm-Gg: AYBFou2XJ1mBp9PfJ2kyGGSx/bPpzHq/NdpUhVueMy8X3Hy0lSjGj/y4Cj1Wc/AciTa
	vm1R2cl+OXFKZAOIvpGyiQOuguV97xGViqihodjwBlXVe7cKPQGn8WhcoxSWieslDJmaKIQ+mkU
	lemQXLyJLOiv68LLpjl+fvNhbRPo4lGe30VqBjQYkcEPMAle03pX6J7gZItt3jSpwidx59T4RKa
	dPtshkeu5o44obZH9QLrxySlVUrY4/r22jbZTKtzOCo3CRcEF5s1GNvBMUzqKEQXvKij9slmh5I
	jvJAHFFdCN6lZUHhc4dJ0/q6sjuv7YJzhBl0ZnsgcSY6CwidBChO1Fn4fByX6bF3PotqnwaEJdX
	VbilzQQAfKrL3hr/EjQ4rItC5AeVfJXGRGNWvvgT7V7KsL8hae+dzDX1dXQGLi2AMhcYZeYrQs1
	18gfayqrhAlvx9VtNN28y3I9geBpllk0W55hUNFVSeP/oI92PwptbYwZ1B9SpuB2wvyBdmLSyI3
	VLEz3dyPVuTKDTIIrZJW8hhiRyEWiRXpiA1NMpgrngd0VDkNTgdrVVnBsXBZrKr3oKMznFM6S2V
	Q1dKGmHwfNVeOGmZ4X9KySKXAcaQjWkJLUtHp4+W+l+IPQ==
X-Received: by 2002:a05:6214:5c81:b0:91e:b505:c2c2 with SMTP id 6a1803df08f44-91eb505c7b5mr7561396d6.32.1793972229630;
        Fri, 06 Nov 2026 05:37:09 -0800 (PST)
Received: from toxicpanda.com ([153.61.196.245])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-91ea6ab9ba7sm20723976d6.40.2026.11.06.05.37.08
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 06 Nov 2026 05:37:08 -0800 (PST)
From: Josef Bacik <josef@toxicpanda.com>
Date: Fri, 06 Nov 2026 13:36:49 +0000
Subject: [PATCH v4 7/8] ovl: handle lazytime on the upper filesystem
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
Message-Id: <20261106-b4-ovl-containerized-sync-v4-7-6ddde0b7dd8a@toxicpanda.com>
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
X-Developer-Signature: v=1; a=openssh-sha256; t=1793972217; l=5683;
 i=josef@toxicpanda.com; h=from:subject:message-id;
 bh=yvlq657zwsc3/H0ga+5OlfjJGR58bqI8IsDA8XBZIvA=;
 b=U1NIU0lHAAAAAQAAADMAAAALc3NoLWVkMjU1MTkAAAAgUBr36M/n0nWN0DNbnxwzIiCZez6MG
 JiruuNaSCI/zXsAAAAGcGF0YXR0AAAAAAAAAAZzaGE1MTIAAABTAAAAC3NzaC1lZDI1NTE5AAAA
 QEQrtYMpnj4SKGNUkqBkMKo0YWZ0+s2IMSSqe9GROOaXH7o9w4OU5FJrjfK0es1bTMaWTVaZjg8
 gGwM4F04bSgY=
X-Developer-Key: i=josef@toxicpanda.com; a=openssh;
 fpr=SHA256:C8kOX2QUJCMqnCX+KEeoqRAjLo9L+ELOSH2NSAJHqGA

With lazytime on the upper filesystem the flusher leaves timestamps in
memory for up to 12 hours.  The overlay inode must not be clean during that
time, or syncfs() would miss them.  It cannot stay dirty either, because
the flusher would visit it on every pass and it could not be reclaimed.

When deferred timestamps are all that is left to write, set I_DIRTY_TIME on
the overlay inode, like the VFS does on the upper inode.  Implement
->sync_lazytime() to pass the request on to the upper inode.

The VFS writes deferred timestamps on the last iput().  The upper inode
does not see that while the overlay inode holds it, so the last iput() of
the overlay inode stands in for it.

Signed-off-by: Josef Bacik <josef@toxicpanda.com>
---
 fs/overlayfs/dir.c       |  1 +
 fs/overlayfs/inode.c     | 19 +++++++++++++++++++
 fs/overlayfs/overlayfs.h |  1 +
 fs/overlayfs/super.c     | 27 +++++++++++++++++++++++++++
 4 files changed, 48 insertions(+)

diff --git a/fs/overlayfs/dir.c b/fs/overlayfs/dir.c
index 1194ccf981c3..fc47beffa67e 100644
--- a/fs/overlayfs/dir.c
+++ b/fs/overlayfs/dir.c
@@ -1489,6 +1489,7 @@ const struct inode_operations ovl_dir_inode_operations = {
 	.get_acl	= ovl_get_acl,
 	.set_acl	= ovl_set_acl,
 	.update_time	= ovl_update_time,
+	.sync_lazytime	= ovl_sync_lazytime,
 	.fileattr_get	= ovl_fileattr_get,
 	.fileattr_set	= ovl_fileattr_set,
 	.tmpfile	= ovl_tmpfile,
diff --git a/fs/overlayfs/inode.c b/fs/overlayfs/inode.c
index 9a4bf7c2502b..5895ee5aa771 100644
--- a/fs/overlayfs/inode.c
+++ b/fs/overlayfs/inode.c
@@ -743,6 +743,22 @@ int ovl_fileattr_get(struct dentry *dentry, struct file_kattr *fa)
 	return err;
 }
 
+/*
+ * The overlay inode has I_DIRTY_TIME set because the upper inode has deferred
+ * timestamps, see ovl_park_inode().  The VFS calls this when the timestamps
+ * have to be written.  Mark the upper inode dirty, which hands the timestamps
+ * to the upper filesystem, and mark the overlay inode dirty, so that
+ * ovl_write_inode() writes the upper inode.
+ */
+void ovl_sync_lazytime(struct inode *inode)
+{
+	struct inode *upper = ovl_inode_upper(inode);
+
+	if (upper && (inode_state_read_once(upper) & I_DIRTY_TIME))
+		mark_inode_dirty_sync(upper);
+	ovl_mark_inode_dirty(inode);
+}
+
 static const struct inode_operations ovl_file_inode_operations = {
 	.setattr	= ovl_setattr,
 	.permission	= ovl_permission,
@@ -752,6 +768,7 @@ static const struct inode_operations ovl_file_inode_operations = {
 	.get_acl	= ovl_get_acl,
 	.set_acl	= ovl_set_acl,
 	.update_time	= ovl_update_time,
+	.sync_lazytime	= ovl_sync_lazytime,
 	.fiemap		= ovl_fiemap,
 	.fileattr_get	= ovl_fileattr_get,
 	.fileattr_set	= ovl_fileattr_set,
@@ -763,6 +780,7 @@ static const struct inode_operations ovl_symlink_inode_operations = {
 	.getattr	= ovl_getattr,
 	.listxattr	= ovl_listxattr,
 	.update_time	= ovl_update_time,
+	.sync_lazytime	= ovl_sync_lazytime,
 };
 
 static const struct inode_operations ovl_special_inode_operations = {
@@ -774,6 +792,7 @@ static const struct inode_operations ovl_special_inode_operations = {
 	.get_acl	= ovl_get_acl,
 	.set_acl	= ovl_set_acl,
 	.update_time	= ovl_update_time,
+	.sync_lazytime	= ovl_sync_lazytime,
 };
 
 static const struct address_space_operations ovl_aops = {
diff --git a/fs/overlayfs/overlayfs.h b/fs/overlayfs/overlayfs.h
index 1cc682f28cc3..2ef4b4b23990 100644
--- a/fs/overlayfs/overlayfs.h
+++ b/fs/overlayfs/overlayfs.h
@@ -891,6 +891,7 @@ static inline struct posix_acl *ovl_get_acl_path(const struct path *path,
 
 int ovl_update_time(struct inode *inode, enum fs_update_time type,
 		unsigned int flags);
+void ovl_sync_lazytime(struct inode *inode);
 bool ovl_is_private_xattr(struct super_block *sb, const char *name);
 
 struct ovl_inode_params {
diff --git a/fs/overlayfs/super.c b/fs/overlayfs/super.c
index 87773b73f228..27e30d0ace80 100644
--- a/fs/overlayfs/super.c
+++ b/fs/overlayfs/super.c
@@ -364,6 +364,31 @@ static enum ovl_write_mode ovl_write_mode(struct inode *inode,
 	return OVL_WRITE_COMMIT;
 }
 
+/*
+ * All that is left to write for @inode are timestamps that lazytime has
+ * deferred on the upper inode.  The flusher leaves those alone for up to 12
+ * hours.  Set I_DIRTY_TIME on the overlay inode, like the VFS did on the upper
+ * inode.  This takes the overlay inode off the list that the flusher walks,
+ * syncfs() still finds it, and the VFS calls ovl_sync_lazytime() when the
+ * timestamps have to be written.
+ *
+ * One of those occasions is when the last reference to an inode goes away.  The
+ * upper inode never loses its last reference while the overlay inode exists, so
+ * the overlay inode has to stand in for it.  The last reference to the overlay
+ * inode may already be gone at this point.  iput() checks for I_DIRTY_TIME
+ * under i_lock before it drops the last reference, so either iput() sees the
+ * flag, or the reference count is zero here.
+ */
+static void ovl_park_inode(struct inode *inode)
+{
+	if (!ovl_tracks_dirty(OVL_FS(inode->i_sb)))
+		return;
+
+	__mark_inode_dirty(inode, I_DIRTY_TIME);
+	if (!icount_read_once(inode))
+		mark_inode_dirty_sync(inode);
+}
+
 static int ovl_write_inode(struct inode *inode, struct writeback_control *wbc)
 {
 	struct inode *upper = ovl_inode_upper(inode);
@@ -384,6 +409,8 @@ static int ovl_write_inode(struct inode *inode, struct writeback_control *wbc)
 
 	if (ovl_upper_unfinished(upper))
 		ovl_mark_inode_dirty(inode);
+	else if (inode_state_read_once(upper) & I_DIRTY_TIME)
+		ovl_park_inode(inode);
 
 	return ret;
 }

-- 
2.55.0

