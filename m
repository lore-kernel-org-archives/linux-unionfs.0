Received: from mail-ej1-f49.google.com (mail-ej1-f49.google.com [209.85.218.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 64D7F352FAA
	for <linux-unionfs@vger.kernel.org>; Wed, 28 Jan 2026 13:24:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.49
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769606654; cv=none; b=pjFg8B+N3jUIh74FBSKYYv1n5iRuTUuAew0LngRS5XMutaewGkO+04Ad6OyR6+FK9J1IDfbFJSABbH/UivmfHu0sIM0b6SulVMo8Ui9QMspRPy9hpBhOVY+Vs1+JaKFDYipARm+/zREBLpHmQXJjPqlBFmb4wIVnqQkjTsjlYGI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769606654; c=relaxed/simple;
	bh=EQ6xjIKKxZ/+kfnV28PEIV4QC0DLWFLQkkQrvKLGotA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=dA8gDl4Lkje/hRMy5DoU8CzD4+Fvbqu9Lfs33brJmRHROxM3pm6pyGDjwiwDk0q6BdFYqb73bQdWqfx58VsaWj+OqvRbG/8eonB5y/U4IzLR9g2dLAGKoeK+BUecOJCTIslVjmN2Jsn8jxuMLsclAIZKGkgZe4wOgdSMxd4cgp8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=YSHGxRiR; arc=none smtp.client-ip=209.85.218.49
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="YSHGxRiR"
Received: by mail-ej1-f49.google.com with SMTP id a640c23a62f3a-b87003e998bso150351866b.1
        for <linux-unionfs@vger.kernel.org>; Wed, 28 Jan 2026 05:24:12 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1769606651; x=1770211451; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=N/LolTXFODfbuJ+5F5mGXiGbzlqsn3yLlZ2LXubqGdM=;
        b=YSHGxRiRiwxWQiH8gT7Hyml7OKzK3vY4vXxgtinmIVnVCOxot4rAWJfkmPjbrFyltk
         ZUTIA/kPi41Gv0Fz/be4hal4W3nCd2CMWzT61v3VQDfMLuQe9PlmEl8Kbpm8iqUTymHS
         tqIyIhxHFZwP3Y1fwmwgMJCoQxjtzVajBoDBdynZspM/yb0MeoE3EpAsvKoa3AOStnEj
         Kg6Ihk2vgcFrXAx+A7dQKSxTumFDxg0X3IRF6uzyqBMwWEBWYHM8TVqZ29xgP+mjCmlk
         KLoBVgvwnDwNkK3GvB2c9yoGGfKee9V4E20mjXTEExPcnTBy/5Z3fIZdDjaV0Y3zbshR
         nLJA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1769606651; x=1770211451;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=N/LolTXFODfbuJ+5F5mGXiGbzlqsn3yLlZ2LXubqGdM=;
        b=dizomquqWBx4SSMLxcLrrXd/yl+2rfYdW10Ft8lNncj+i7oTL3jwuvcoNKKlsg60C1
         bauARBYin3C3WheAbl8gCWxZr1fZceGdmedxDqvTFPPVSzq/pqFzaZxGE9r0ob3ZzWyt
         N7tgh2d8Ncgk4QvvB+A7SiVi816PVokepXqZuIXDLRXHrFl9K6RFBY7cCpwoaBPtE+Q0
         R8h07qPHRB86BZIm4FVfQQWZU0awYRo2dFTQauGcLD+IYO7H8OzqVj6Af2DWQjQdEp8Z
         JdUfTJ49nYCrJsJfHUgRi/JSCITh+5Wgp/3uLKoqyalQU5itvKVO6gbedJkQoECRcYp7
         x6Bg==
X-Forwarded-Encrypted: i=1; AJvYcCX5qxrEufhETnEpfbknqfZiNoAJoXEGCZuUIGZw1x3jONMr1t2HOQyVtgdNn/PCzrtMbp2p2RLsaKGzZ1Oi@vger.kernel.org
X-Gm-Message-State: AOJu0YxPlhDixmCeVYKAp1QjdebxKh1r8SewyPbZQf05A7om6zP2x+w+
	NrjB0tYIteunLCM+VXup1RnVYncLMm6Lx0sCzla0hGznQdGUIyxwDs/u
X-Gm-Gg: AZuq6aIsGB0qtbvHa3eDJLeoYBzxlXOf7P0Suhwiz6yYcn/Vq8BULaFlibWAF1ds3FZ
	px6reAoNWe7TDZju8+3ucrzJ2j0XSvW60BJvB+WcvlOiKGCGVuFytx/BfYDnnjuYP9lXUBgHb61
	t7a/8m0ye03uekHZH4JhbBmt+JjHIrKN5jHsLB/Fwg6ZiRucBL1+3QeSgVVepK+GDXGIydyx39A
	ADzIntbj9K9FrgAJbMUuSMRcC2ElLAFnGsQmmpzfSToIySAbB0mEShqg4rGn2wjiwJBsnVdf53V
	g73ou4w60lLkK38VIl6QHMuFz6nXZzQ88vax/wWqqinNmp525f9DDrRcu86DGkgozdRZ/0HEVhO
	CBRreHPLZczoIV8xqZqZbCNPh9jc9pyX1AiXEphwJpI1oFJy1jjFG35F4tXEZNoQoOuJCk+21Ue
	SVbdz7/eKsgVfxTOPPLoLVYIgHb3i+OM+LPyUejmZ4r6niA9eP5iWw1rHE1fHTDbN1UATVwtyKK
	OwRNtIvs3QYUvrgaGDQPrJyTHQ=
X-Received: by 2002:a17:907:7243:b0:b87:19ae:eb36 with SMTP id a640c23a62f3a-b8dac848d61mr381339366b.7.1769606650262;
        Wed, 28 Jan 2026 05:24:10 -0800 (PST)
Received: from localhost (2001-1c00-570d-ee00-c84e-f30e-bdab-df5a.cable.dynamic.v6.ziggo.nl. [2001:1c00:570d:ee00:c84e:f30e:bdab:df5a])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-b8dbf1c0126sm129880466b.47.2026.01.28.05.24.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 28 Jan 2026 05:24:09 -0800 (PST)
From: Amir Goldstein <amir73il@gmail.com>
To: Miklos Szeredi <miklos@szeredi.hu>,
	Christian Brauner <brauner@kernel.org>
Cc: Qing Wang <wangqing7171@gmail.com>,
	linux-fsdevel@vger.kernel.org,
	linux-unionfs@vger.kernel.org
Subject: [PATCH 2/3] fs: add helpers name_is_dot{,dot,_dotdot}
Date: Wed, 28 Jan 2026 14:24:05 +0100
Message-ID: <20260128132406.23768-3-amir73il@gmail.com>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260128132406.23768-1-amir73il@gmail.com>
References: <20260128132406.23768-1-amir73il@gmail.com>
Precedence: bulk
X-Mailing-List: linux-unionfs@vger.kernel.org
List-Id: <linux-unionfs.vger.kernel.org>
List-Subscribe: <mailto:linux-unionfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-unionfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Rename the helper is_dot_dotdot() into the name_ namespace
and add complementary helpers to check for dot and dotdot
names individually.

Signed-off-by: Amir Goldstein <amir73il@gmail.com>
---
 fs/crypto/fname.c      |  2 +-
 fs/ecryptfs/crypto.c   |  2 +-
 fs/exportfs/expfs.c    |  3 ++-
 fs/f2fs/dir.c          |  2 +-
 fs/f2fs/hash.c         |  2 +-
 fs/namei.c             |  2 +-
 fs/overlayfs/readdir.c |  3 ++-
 fs/smb/server/vfs.c    |  2 +-
 include/linux/fs.h     | 14 ++++++++++++--
 9 files changed, 22 insertions(+), 10 deletions(-)

diff --git a/fs/crypto/fname.c b/fs/crypto/fname.c
index a9a4432d12ba1..629eb0d72e860 100644
--- a/fs/crypto/fname.c
+++ b/fs/crypto/fname.c
@@ -76,7 +76,7 @@ struct fscrypt_nokey_name {
 
 static inline bool fscrypt_is_dot_dotdot(const struct qstr *str)
 {
-	return is_dot_dotdot(str->name, str->len);
+	return name_is_dot_dotdot(str->name, str->len);
 }
 
 /**
diff --git a/fs/ecryptfs/crypto.c b/fs/ecryptfs/crypto.c
index 260f8a4938b01..3c89f06c74532 100644
--- a/fs/ecryptfs/crypto.c
+++ b/fs/ecryptfs/crypto.c
@@ -1904,7 +1904,7 @@ int ecryptfs_decode_and_decrypt_filename(char **plaintext_name,
 
 	if ((mount_crypt_stat->flags & ECRYPTFS_GLOBAL_ENCRYPT_FILENAMES) &&
 	    !(mount_crypt_stat->flags & ECRYPTFS_ENCRYPTED_VIEW_ENABLED)) {
-		if (is_dot_dotdot(name, name_size)) {
+		if (name_is_dot_dotdot(name, name_size)) {
 			rc = ecryptfs_copy_filename(plaintext_name,
 						    plaintext_name_size,
 						    name, name_size);
diff --git a/fs/exportfs/expfs.c b/fs/exportfs/expfs.c
index d3e55de4a2a2a..6c9be60a3e48d 100644
--- a/fs/exportfs/expfs.c
+++ b/fs/exportfs/expfs.c
@@ -253,7 +253,8 @@ static bool filldir_one(struct dir_context *ctx, const char *name, int len,
 		container_of(ctx, struct getdents_callback, ctx);
 
 	buf->sequence++;
-	if (buf->ino == ino && len <= NAME_MAX && !is_dot_dotdot(name, len)) {
+	if (buf->ino == ino && len <= NAME_MAX &&
+	    !name_is_dot_dotdot(name, len)) {
 		memcpy(buf->name, name, len);
 		buf->name[len] = '\0';
 		buf->found = 1;
diff --git a/fs/f2fs/dir.c b/fs/f2fs/dir.c
index 48f4f98afb013..29412e6e078d0 100644
--- a/fs/f2fs/dir.c
+++ b/fs/f2fs/dir.c
@@ -67,7 +67,7 @@ int f2fs_init_casefolded_name(const struct inode *dir,
 	int len;
 
 	if (IS_CASEFOLDED(dir) &&
-	    !is_dot_dotdot(fname->usr_fname->name, fname->usr_fname->len)) {
+	    !name_is_dot_dotdot(fname->usr_fname->name, fname->usr_fname->len)) {
 		buf = f2fs_kmem_cache_alloc(f2fs_cf_name_slab,
 					    GFP_NOFS, false, F2FS_SB(sb));
 		if (!buf)
diff --git a/fs/f2fs/hash.c b/fs/f2fs/hash.c
index 049ce50cec9b0..14082fe5e6b29 100644
--- a/fs/f2fs/hash.c
+++ b/fs/f2fs/hash.c
@@ -100,7 +100,7 @@ void f2fs_hash_filename(const struct inode *dir, struct f2fs_filename *fname)
 
 	WARN_ON_ONCE(!name);
 
-	if (is_dot_dotdot(name, len)) {
+	if (name_is_dot_dotdot(name, len)) {
 		fname->hash = 0;
 		return;
 	}
diff --git a/fs/namei.c b/fs/namei.c
index b3fe9d4a7037e..63bbcea75bbd3 100644
--- a/fs/namei.c
+++ b/fs/namei.c
@@ -3050,7 +3050,7 @@ int lookup_noperm_common(struct qstr *qname, struct dentry *base)
 	if (!len)
 		return -EACCES;
 
-	if (is_dot_dotdot(name, len))
+	if (name_is_dot_dotdot(name, len))
 		return -EACCES;
 
 	while (len--) {
diff --git a/fs/overlayfs/readdir.c b/fs/overlayfs/readdir.c
index 724ec9d93fc82..9f6b36f3d4cf8 100644
--- a/fs/overlayfs/readdir.c
+++ b/fs/overlayfs/readdir.c
@@ -76,7 +76,8 @@ static int ovl_casefold(struct ovl_readdir_data *rdd, const char *str, int len,
 	char *cf_name;
 	int cf_len;
 
-	if (!IS_ENABLED(CONFIG_UNICODE) || !rdd->map || is_dot_dotdot(str, len))
+	if (!IS_ENABLED(CONFIG_UNICODE) || !rdd->map ||
+	    name_is_dot_dotdot(str, len))
 		return 0;
 
 	cf_name = kmalloc(NAME_MAX, GFP_KERNEL);
diff --git a/fs/smb/server/vfs.c b/fs/smb/server/vfs.c
index b8e648b8300f6..b38eb8e0b3eb7 100644
--- a/fs/smb/server/vfs.c
+++ b/fs/smb/server/vfs.c
@@ -1052,7 +1052,7 @@ static bool __dir_empty(struct dir_context *ctx, const char *name, int namlen,
 	struct ksmbd_readdir_data *buf;
 
 	buf = container_of(ctx, struct ksmbd_readdir_data, ctx);
-	if (!is_dot_dotdot(name, namlen))
+	if (!name_is_dot_dotdot(name, namlen))
 		buf->dirent_count++;
 
 	return !buf->dirent_count;
diff --git a/include/linux/fs.h b/include/linux/fs.h
index b1310648bb585..43f9baef4dd36 100644
--- a/include/linux/fs.h
+++ b/include/linux/fs.h
@@ -2846,12 +2846,22 @@ u64 vfsmount_to_propagation_flags(struct vfsmount *mnt);
 
 extern char *file_path(struct file *, char *, int);
 
+static inline bool name_is_dot(const char *name, size_t len)
+{
+	return unlikely(len == 1 && name[0] == '.');
+}
+
+static inline bool name_is_dotdot(const char *name, size_t len)
+{
+	return unlikely(len == 2 && name[0] == '.' && name[1] == '.');
+}
+
 /**
- * is_dot_dotdot - returns true only if @name is "." or ".."
+ * name_is_dot_dotdot - returns true only if @name is "." or ".."
  * @name: file name to check
  * @len: length of file name, in bytes
  */
-static inline bool is_dot_dotdot(const char *name, size_t len)
+static inline bool name_is_dot_dotdot(const char *name, size_t len)
 {
 	return len && unlikely(name[0] == '.') &&
 		(len == 1 || (len == 2 && name[1] == '.'));
-- 
2.52.0

