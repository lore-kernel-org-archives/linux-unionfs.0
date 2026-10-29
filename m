Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.222.181
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793236184;
	b=vxwuZfYK2Yg7qGmqPT+KBRngX/OybGUhBYzDCvc9h1UysCnsMyWGWANb3anFinKkozbC
	 x4ZAI1FyQ9TAjcsFHch/SZwnkH7bDraN4yhTpg+wjFcwd337UKbJ6XJ/KbcfCxjUi5bHo
	 rFi41ldd5Aja/7Z6i85jjJ322m1fC/9boUrdE/1PMdcZ+MeZzg+/+/bV34BTqSSCZ8yl/
	 2F43Djah8eQU2wqj7jJLJr1+oKZKAj4wfKbITX3y/P6jL8FV1COaLQK/ERXotMCCCcC9s
	 t3ImOLw8s1z67v09bgkZ4XfeKjBKeWCiin+lk1URLCLzJ6TBdcfkYUOaHg288NkOdow==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793236184;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 From:Date:Subject:MIME-Version:Content-Type:Content-Transfer-Encoding:
	 Message-Id:References:In-Reply-To:To:Cc:X-Mailer:
	 X-Developer-Signature:X-Developer-Key;
	bh=tpLGrLGauDgDl9yW0M4lNB40Ai17F4E6qRNBG6GWEPM=;
	b=qudWs4CBWQomp0JMTgdDVVbvMs8qgNLnQ9/Y6p4pLFayn8I4IsnVK4yx6BmO4NNvuQKS
	 TZTV3NerOhsA1orMTD29iPUMeZlQihY/xkg2xdlvWhUJhkTE8ZoX/LH897zLoqxZ36upd
	 eYZZagNZY3aoCj29bu0NU16330tfCFKBOq5uaSv9naSCRgzjN3thamdc1ZkROhYIbh/hP
	 mGtc+pExP8UD8RYXol8j50fh9KZ0WGvAvO6pz7gxmVMp82ZOYfWd3JgxsRUDIfSv/OXbY
	 k6OD0qQb40gxpjhE+cbAx5kasgrnOshJP32XvMKF8iBv5pRh6c2WAvVP4MHRUH+R1IQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=none header.from=toxicpanda.com;
	spf=pass smtp.mailfrom=toxicpanda.com;
	dkim=pass header.d=toxicpanda.com header.i=@toxicpanda.com header.a=rsa-sha256 header.s=google header.b=snBeTqYB;
	arc=none smtp.remote-ip=209.85.222.181
Received: from mail-qk1-f181.google.com (mail-qk1-f181.google.com [209.85.222.181])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5417260A2618
	for <linux-unionfs@vger.kernel.org>; Thu, 29 Oct 2026 01:09:44 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 5417260A2618
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=toxicpanda.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=toxicpanda.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=toxicpanda.com header.i=@toxicpanda.com header.a=rsa-sha256 header.s=google header.b=snBeTqYB
Received: by mail-qk1-f181.google.com with SMTP id af79cd13be357-93f22a8515eso133394785a.2
        for <linux-unionfs@vger.kernel.org>; Wed, 28 Oct 2026 18:09:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=toxicpanda.com; s=google; t=1793236183; x=1793840983; darn=vger.kernel.org;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :content-type:mime-version:subject:date:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=tpLGrLGauDgDl9yW0M4lNB40Ai17F4E6qRNBG6GWEPM=;
        b=snBeTqYBJH41K4SmZEQXMR4sJriIuR6UHXzT/pzqBt0DTgo4l0yd9IycrSoO1Z77b0
         sVCLInl6O7ZcZRgJ3GFe24hILU8nZmMXD2zHZ2hKojGchvX1/gs2zIHP0V9F/UBSwFzJ
         +PNqZTTmgqWM/KQ0Om4XUn5nB2jYgTbJar9PUtwU43e572P9u/9zOAmO5URFTGaoCJge
         oTAMBTKHymdFtuuwFAcSdOsgjNo4bieZ3Wt70dGJRXLxzhpwB4Y+AgicL1s/11G+pue1
         MuKtI52AwNBOt7ScuyCfftS0gxwrthI+Vfye1WomYbSNd+OoEovfw8LCujIikN5twJ2J
         qjOA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793236183; x=1793840983;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :content-type:mime-version:subject:date:from:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=tpLGrLGauDgDl9yW0M4lNB40Ai17F4E6qRNBG6GWEPM=;
        b=NZEEyrOaVBmQwGWGjATwR9HcDbV03GwPO3TQGTZVaMqpMwdgnFIfw6HosSf+7DXqaA
         +pDwptUhQRB25AwfkOicuY30g99R0sJggSjutTcM5QMMLD4Yo4VjQ+7Pt1qcymoMhbd4
         I5vYPc7HozwsKoLPBVkj/pHA6X6PT/ZIhywspBTPYCayr0AAbD63k0fVAy6XAqi6TZ/n
         60XAZsaBHEZveYnyp5yaA0JKp/9Q4ZIs2VHckEp22uAhcAUAwSiHP2/sgtGnUbJp1Y1B
         juxAjL4+gW3loibA9uCx/IzP9YBp3pVabmEWw83lP80VHTkYnv82i/Lr/T7MQCCKImGT
         zhcg==
X-Forwarded-Encrypted: i=1; AKwUvBzHhdrvP+tyysHGmrE5QnuhT1/754pLljUvjQkUKLDYhQZjDUInTvhrRGZF0+47iJ34XreQNOBxAHRElHOV@vger.kernel.org
X-Gm-Message-State: AFq9FYL6IThg13cjzTO9krs+2s19LQ6RWV/ao9ZTXq2hPQKqeo4mCAaP
	ZIZZ7Csupsgg+4tJ8f0FwUnpISJXwR3qtAXrG3rcFBaHHoHGctkHNc3/YttUyKzHhMY=
X-Gm-Gg: AYBFou0yZMkLSxZfJ7Kj64lQhKKB1w8g76S/mGqpiNhHB3EqkfBNsEEFGSXsW7sb+eG
	uurihtrjqRUBALno6UYAad53LP3rH4ojs2QXI6HRsj2ozhI6ZV/XoTCCmCQvHX9wRvlyJ2lwneC
	JvEvN75SL/VBGe1r+Pf6uAAowFmkr/tYktUvmzfiq2BkELQlg9YfO17qGnDaDL0LEiV3zqvUVga
	3LKp2gGKSJw2Sq0SHpCHJ4udUUnPanx8af4qeRPTppXoNgMEH9sSBeyZ4ltgovFfaMRgu9l9qnj
	LDj1O0OqRUcYGy9WCSCUlGaULE5YpSI6TMW9Jidf+HjbkQtYO8nw3R3pLu6+Wzo7B0tQeURZbgD
	yAPUtC07c3oOVBgSG7qVZT28LWC/zmni5cxDtrUTGM/tml4DjsrCtufoPX9bNwuEjl/JMqO8m4S
	UviZAwmoqavBWB+emgSsAxt0ouXUfe/keS4f7kqbbsyIZkqFquWuuEsLtvit8/nGHlJnqQZ2aGh
	l7AVGBFI47VVwXpBkbHCWwlyiRnpYeU6gJJHLN2ng/mDQvF2CMcKm8jIBRE1sMzGjrbl4mPaCQw
	Mag+ZxwnqCWvqUzpcoekLfcE0BgkHbNCCo2SK540yTFfaRc=
X-Received: by 2002:a05:620a:2849:b0:93e:5821:2c5c with SMTP id af79cd13be357-94408cf1bf6mr614312185a.60.1793236183125;
        Wed, 28 Oct 2026 18:09:43 -0700 (PDT)
Received: from toxicpanda.com ([153.61.196.253])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-940f0a78c06sm1393247685a.35.2026.10.28.18.09.42
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 28 Oct 2026 18:09:42 -0700 (PDT)
From: Josef Bacik <josef@toxicpanda.com>
Date: Thu, 29 Oct 2026 01:09:20 +0000
Subject: [PATCH v2 06/10] ovl: handle lazytime on the upper filesystem
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
Message-Id: <20261029-b4-ovl-containerized-sync-v2-6-4e9f08e4a052@toxicpanda.com>
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
X-Developer-Signature: v=1; a=openssh-sha256; t=1793236166; l=5683;
 i=josef@toxicpanda.com; h=from:subject:message-id;
 bh=eSliQDWathldjP0ntiY67Ro+PGXXgDddabaaxFAzW2I=;
 b=U1NIU0lHAAAAAQAAADMAAAALc3NoLWVkMjU1MTkAAAAgUBr36M/n0nWN0DNbnxwzIiCZez6MG
 JiruuNaSCI/zXsAAAAGcGF0YXR0AAAAAAAAAAZzaGE1MTIAAABTAAAAC3NzaC1lZDI1NTE5AAAA
 QJ8x16Vjf8JcNJXDO4uG8vDEJU3JRltGOVRdMbyzc29w6t/9VmkmtO1mzIZyUyluu4UFqRn+3a6
 34qDNoy7FgA0=
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
index 8f83325ec359..d3a897e46ccb 100644
--- a/fs/overlayfs/overlayfs.h
+++ b/fs/overlayfs/overlayfs.h
@@ -890,6 +890,7 @@ static inline struct posix_acl *ovl_get_acl_path(const struct path *path,
 
 int ovl_update_time(struct inode *inode, enum fs_update_time type,
 		unsigned int flags);
+void ovl_sync_lazytime(struct inode *inode);
 bool ovl_is_private_xattr(struct super_block *sb, const char *name);
 
 struct ovl_inode_params {
diff --git a/fs/overlayfs/super.c b/fs/overlayfs/super.c
index a68eb78a9061..de3e2d0b29ee 100644
--- a/fs/overlayfs/super.c
+++ b/fs/overlayfs/super.c
@@ -368,6 +368,31 @@ static enum ovl_write_mode ovl_write_mode(struct inode *inode,
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
@@ -388,6 +413,8 @@ static int ovl_write_inode(struct inode *inode, struct writeback_control *wbc)
 
 	if (ovl_upper_unfinished(upper))
 		ovl_mark_inode_dirty(inode);
+	else if (inode_state_read_once(upper) & I_DIRTY_TIME)
+		ovl_park_inode(inode);
 
 	return ret;
 }

-- 
2.55.0

