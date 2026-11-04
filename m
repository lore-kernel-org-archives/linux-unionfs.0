Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.222.178
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793825127;
	b=xpO21w/K3dN9JMfqO9i3mST19kGgyS3jRKaNF8fBc7xtWXl9K67WEOU0i8+H82h2ITiM
	 SlbgjYLR44cJVVaqrwpLPixU8EtPHd053GeJOz27afgx/DqSMANDgAahyeWXi5ph7Ogmz
	 XKotsOetKC+sInOZxeNBg1/BUgYxE22PeIPFVLbk/lBk5tuEBskPIhySjORdfgGyeqhSc
	 zj17mZXsrjYMakCDhoZIwhZzCENp6m4yqWQG5iZM9m7pZQ4fzYy3zde89CNPILcjlHpsf
	 vzspbLp20rq6aalFIFBttfJQZpOF5lKkZDG/XA4rYcC9+BFd2VNMgfS4zZucWFYSfGA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793825127;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 From:Date:Subject:MIME-Version:Content-Type:Content-Transfer-Encoding:
	 Message-Id:References:In-Reply-To:To:Cc:X-Mailer:
	 X-Developer-Signature:X-Developer-Key;
	bh=rzmt5Hz3K4kVCI7Fq2Ze1MrmxPTBuObA36LwwUri/gg=;
	b=2x8ASNtNRkPB28tuwjhTLD5ntuchyXY7PQ4j3/Skqo9pVBh4q/xDammGx27+ug1OQZQG
	 mcX3p2nb9W0GbFoB0nI0rUNQnLuNTLimVIDzlp8Osico7afXmXIiWRkXd/3TiorO4Nm0l
	 QirTtBGUUtl8PDtsSSsw6ofKnj5qmH5wjBSbjfh/mtl9cR6cnSUcwaTm0dyWAmASoNg/d
	 0rDfSATS1AQ/ndUvB9bwSNu8RyzLKJU2X6wH6s0e1nRIsMrv6uW5Ebipev5HQWll5FtIE
	 sQY2J4d3mrn6MyqWRVN+D2pLs7DZ7OGh1usETM4lF1q3eoyYugWK9DUWyIV2cDuZHpg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=none header.from=toxicpanda.com;
	spf=pass smtp.mailfrom=toxicpanda.com;
	dkim=pass header.d=toxicpanda.com header.i=@toxicpanda.com header.a=rsa-sha256 header.s=google header.b=sSNfABAx;
	arc=none smtp.remote-ip=209.85.222.178
Received: from mail-qk1-f178.google.com (mail-qk1-f178.google.com [209.85.222.178])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E014C6083632
	for <linux-unionfs@vger.kernel.org>; Wed,  4 Nov 2026 20:45:26 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org E014C6083632
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=toxicpanda.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=toxicpanda.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=toxicpanda.com header.i=@toxicpanda.com header.a=rsa-sha256 header.s=google header.b=sSNfABAx
Received: by mail-qk1-f178.google.com with SMTP id af79cd13be357-93f3c8958d5so126829185a.2
        for <linux-unionfs@vger.kernel.org>; Wed, 04 Nov 2026 12:45:26 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=toxicpanda.com; s=google; t=1793825126; x=1794429926; darn=vger.kernel.org;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :content-type:mime-version:subject:date:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=rzmt5Hz3K4kVCI7Fq2Ze1MrmxPTBuObA36LwwUri/gg=;
        b=sSNfABAxnIK0HnaztekNKF9rwj946WP3Vo6/D17hJujePfuouEEIo16mHn9XeiKZM1
         f4nrjv/07Yroo7pa3I+SNhEBpYzAcc15Ld/kq7VBluexp2nWwkwWsARvscTasAFOd93j
         T3xsDfKDCJlycR2WMJFmLqutx7ZiLqFYO3yBlV4RAG0Ngm+R4z9rQdNjOv8alxpxvcoT
         vp8mOuKvsqgqF9cz/WmCMX/2VKC+hUNQSFANY+lZDHKtLfI62fEHJcTlHBE7ioh8z0KN
         h8OrEQSqz+c106g1+yOpleDKnda9lxSp3WAoMU65YVQY7dxT/R2Moj1e4qVLjido+ERI
         Mr6A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793825126; x=1794429926;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :content-type:mime-version:subject:date:from:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=rzmt5Hz3K4kVCI7Fq2Ze1MrmxPTBuObA36LwwUri/gg=;
        b=fBO3PdoLSja3aAphApXGa4KKmaZFAb85Lsk/bY6WgVPVIFsj+I96StJ9XRPOGKiZwf
         6LRLBi5DQWYb5wn8Hdf5dT5GHJSBNqU0L17nIeQycoV01NsLubKXoPBTa34ga9Lfq3Ln
         e5FNCRMUdrrcCtw/cexLKu8smn700coAN4qxqf+WLixOcUiiEVMz+iCc6ooZuePnJHXN
         I1umoLc1eKjzGSX8f9hVycqTYhzYwlH3194vcQJu+okNL5qiHghhdYiKHz5KY6fNLF50
         ghM0LvNj1fd1PNcInj1d5eQqo13T+CMvrSJldpELADeQxuTYyv0Idsp88J5jO8SuQLHA
         p4xQ==
X-Forwarded-Encrypted: i=1; AKwUvByZmSqKuQld9N+cZgrkNujkhNP8Pmu4/CJVGtuJb2UKcGi3AwZKRrwsmgH82bK9xsDiScQZa20JnkxoZ6sk@vger.kernel.org
X-Gm-Message-State: APuU4Z8X9P0qfatRUPxLE6bFX8BiUmJs+RmpghSPKYtLI8hABGNoo6W8
	xN6e3Hw5cKqFNIQFPwlIDY9+DBx8xgdhiaWN2BYire0mJjfKuNvpKdWjG/VW/yjI/UE=
X-Gm-Gg: AYBFou36F+CmgiG4cNPGcBvB30GUogF3UbTr2f9GLurH8an8iD3FhXWT6YBFGgEPFEI
	0uKgjZEK7VK9xXjvd4DRXY0OQU7Xx6E0mtquJuhKsGOpXBwV+DW39rbVifQkZDezuXisv/lBnuF
	DElNG+rAzNSouJjKiGS7glYFVAx+ZLAu0m6NJlty3G2fIPepKvkwAQgf1lgCsovJO4K85PHDKdk
	VJb3gWmBtcJuVqQ+8iOfltUseRMUA/LG6kXdwb/zygjbh2YRuyFKmiWrT9Ht3KxViXjy9oK9x8D
	yDYydBWcbYNH8XiI0VUZu7AOPMOR9/wMol9Oqr//1CFxn+cGZ81NgJVDlcoD2hBvR6vTolN9zlz
	bj/Oi1f9c/CdLkyPmW9Ap6uwSTftUhDN5J8WsrplHviW5bM4WS7qit1svS7T0ecH5hf7bcu3d65
	Ir+My+g031T29pIZP6RmqvZ07bVjnZYdm6M9quV2bybT1EZRKt2QrpfEoBgMCXZmHTb+Z2M1H50
	xY2n7Y0ee2ICZZPG7sMI/OQRUTkdk02pkMAxr0pKfaAQs9a7ck85CYf7keSrjaYAXh1GO5WXNk+
	R9LS5S+Qs5IG8Pa8U5TWG5Jo7WXodQ8uKvrMgQ8Vvt01KQ==
X-Received: by 2002:a05:620a:444c:b0:93e:4d60:d389 with SMTP id af79cd13be357-9442163032amr3103157085a.25.1793825125871;
        Wed, 04 Nov 2026 12:45:25 -0800 (PST)
Received: from toxicpanda.com ([153.61.196.246])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-945d4898a06sm291414185a.42.2026.11.04.12.45.25
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 04 Nov 2026 12:45:25 -0800 (PST)
From: Josef Bacik <josef@toxicpanda.com>
Date: Wed, 04 Nov 2026 20:45:04 +0000
Subject: [PATCH v3 7/8] ovl: handle lazytime on the upper filesystem
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
Message-Id: <20261104-b4-ovl-containerized-sync-v3-7-8daa20144f53@toxicpanda.com>
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
X-Developer-Signature: v=1; a=openssh-sha256; t=1793825112; l=5683;
 i=josef@toxicpanda.com; h=from:subject:message-id;
 bh=lAJTbUM7nvdyV8CL9S/lP19B0RrQ2NzBxFBQvu0+Y/0=;
 b=U1NIU0lHAAAAAQAAADMAAAALc3NoLWVkMjU1MTkAAAAgUBr36M/n0nWN0DNbnxwzIiCZez6MG
 JiruuNaSCI/zXsAAAAGcGF0YXR0AAAAAAAAAAZzaGE1MTIAAABTAAAAC3NzaC1lZDI1NTE5AAAA
 QHmibJDFeLY8enJF9c72DMbQ8RkyqGnQfRKIK+QC7z3nNFlLlZ9M4q76f8Kc08ipA67wckhiRha
 W7uFWpKQ22wo=
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
index bbe1a5bb8e97..f7292e23bb28 100644
--- a/fs/overlayfs/overlayfs.h
+++ b/fs/overlayfs/overlayfs.h
@@ -901,6 +901,7 @@ static inline struct posix_acl *ovl_get_acl_path(const struct path *path,
 
 int ovl_update_time(struct inode *inode, enum fs_update_time type,
 		unsigned int flags);
+void ovl_sync_lazytime(struct inode *inode);
 bool ovl_is_private_xattr(struct super_block *sb, const char *name);
 
 struct ovl_inode_params {
diff --git a/fs/overlayfs/super.c b/fs/overlayfs/super.c
index fe626e9d78a8..420cd166748a 100644
--- a/fs/overlayfs/super.c
+++ b/fs/overlayfs/super.c
@@ -363,6 +363,31 @@ static enum ovl_write_mode ovl_write_mode(struct inode *inode,
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
@@ -383,6 +408,8 @@ static int ovl_write_inode(struct inode *inode, struct writeback_control *wbc)
 
 	if (ovl_upper_unfinished(upper))
 		ovl_mark_inode_dirty(inode);
+	else if (inode_state_read_once(upper) & I_DIRTY_TIME)
+		ovl_park_inode(inode);
 
 	return ret;
 }

-- 
2.55.0

