Received: from mail-ed1-f43.google.com (mail-ed1-f43.google.com [209.85.208.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A071F3A4F23
	for <linux-unionfs@vger.kernel.org>; Sun, 12 Jul 2026 12:24:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.43
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783859066; cv=none; b=Yx0C9R5FG/Heum+FzzQrmp+RygTKvTbmagcPi5SDnreTlHRAUwx562wLFvtoMeagL04krJtWaB9V732Cn/wTfJnhBNx8AY2G9N/z8Npx+Gsbwt29Hf8MWpzmAwQzwGbm5e7HmKDkc+CZTkbPwAsuS3nQTkG46dZGTOuKX2vXXFY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783859066; c=relaxed/simple;
	bh=KFEh1PHZXjZn5B6U/ju5cvbBd+QnU5QCQZZjOyrckbM=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=WETpFzteXhZ0FbLvVb1EGYdGiS7q1BkzC0anJ6nEvP3r2CVJhGbGEl+oGlwOh5p7IpUx4vee+QQA/jluxqCnpbI1fHPcszJ46SXkmRx4nVFvUISl4o8V7VGaB3c/rPEaYMBBY1TGtCGmTu+YhNhQMZxeOOgkP0acuCfeFDyngLg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=QpkoVoly; arc=none smtp.client-ip=209.85.208.43
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="QpkoVoly"
Received: by mail-ed1-f43.google.com with SMTP id 4fb4d7f45d1cf-699fbcd23ccso3212032a12.1
        for <linux-unionfs@vger.kernel.org>; Sun, 12 Jul 2026 05:24:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1783859063; x=1784463863; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=eQ1JDM66k0TFLHCRuDdKDddxOWaCzRzzijLyXFQufg4=;
        b=QpkoVolyniTWkaDuAt7T9/0+n8ZcJ8IRDcLufcS8tH4izuhFKr4lY9r4LyEB9QZp8R
         d2oSA0+U7DzMsr0/PBqoT4pLIu2rQiGzhx+531RvKrhNngFVD7atpgQZe9/r4S8eqS1K
         LTDjOKOBup2GSGqVs++gHb4C9GnLM9zLxg1OQNtlnR4hMBpYTAvM119E9p8t9PFy9VGS
         FEtK/UTtdlZCULpKfx4UT7a33xzFooWnJq4ptBt7Jm0HXZtqx3Vs9VTzbMlNDq+ZXRSP
         G0RTyOQVwSEKs2HrnBHQ3LnnkgWMvbAtLcahr1tE+nfzs0Pp6gu6gPAuyO2ilL5Vh1SZ
         biCQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1783859063; x=1784463863;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=eQ1JDM66k0TFLHCRuDdKDddxOWaCzRzzijLyXFQufg4=;
        b=d9xQYUqcjFiMCR8X5+toNUNeoos1IdZWv4cM8EJ7SyI/gH5+EWLsrrXrfn0QAEIqFc
         ze7XU8tCKatpyurWVZP6kTIPG3GLeP9DQL5DU69fo8ZkEJ1zEElzYScjjefJmmrGG3jC
         tNP1RIe0GO+DlPqJ/6ggdPCNFrFMkigEnxk33kNtPnJq4DMTNz2c0eMn1XShtRe0B565
         mvlSihZ5nB9N4JHpIWBmi0BF8W/0Wp8ICBQa+AlA9zYpWv2jw7KgmILg164VeDB7VpzX
         ECZgMpBgrb3AMwxksnd8pdx+99/ZxtFaVuGWn6m2wyel/sErzy2c5nE4c3zHyGYbRm7v
         N3Vg==
X-Forwarded-Encrypted: i=1; AHgh+Ro23y5EodtmaDM65TAVATqYfkT6jDQ740yaSvdO0jE5yz0ZGpxwnbqQ6HSMa8szFM7ZgS+X3xKC0BPKo+2A@vger.kernel.org
X-Gm-Message-State: AOJu0Yyvj1YmmF3DjqTAnA0d5XcEyuWpQEeMAl2LKQ3i7K5ZgG3l6SzI
	FM/j95IVRUqqbK3RhYkI4BEqgF2P91zBdKGaF5YsflBFw+zRBAgUm1w4
X-Gm-Gg: AfdE7cnR+0Qk3a9N+6XOVk5uG7K4I8ysN9yO49YmHVIaY+UHTMOyP6hR+44x5yBvx7X
	DdHqQZLtu1FnD2RhQfeHzXIHcnUiyf+D5otjtFRaUoP5SRVt8aq7wBv4lAPPCTvWV2ISW09dhxp
	hGfJEVmmFuGBxxvTFTvEOzx6r8dDq15KbhEf52p0lfW2pFomFEdfy7rdH//6xksW6R4AxHtbld4
	5TTOt4WChiujhF55ZV5B7XMShlxqp8D0R6MqhWkcCy4l4CE7AAQ1rOqpYgKNceUr9O4iNcVp6z5
	u9cVXsyeWXS7Ejan1lcMXX73GTb5wqF0hBsuknKbKAnzL+ZkRsB5qRGNZ0NBPZEISkHbl86/gmk
	d6N+apJfXYA/xuoBP63Zih54Lmz5XIc5m2zzpHWkIOtNvo4+Kz7x73DTAJoFmD37IYxqS3J3Qxr
	dJhufJGZUTYzNxEM46klfOzeP943LIUXINVMGdGQ==
X-Received: by 2002:a05:6402:2346:b0:69a:a827:7483 with SMTP id 4fb4d7f45d1cf-69c5f0eae44mr2448709a12.25.1783859062731;
        Sun, 12 Jul 2026 05:24:22 -0700 (PDT)
Received: from localhost (178-84-201-199.dynamic.upc.nl. [178.84.201.199])
        by smtp.gmail.com with ESMTPSA id 4fb4d7f45d1cf-69aa6dba523sm8106061a12.0.2026.07.12.05.24.21
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 12 Jul 2026 05:24:22 -0700 (PDT)
From: Amir Goldstein <amir73il@gmail.com>
To: Christian Brauner <brauner@kernel.org>
Cc: Miklos Szeredi <miklos@szeredi.hu>,
	Daan De Meyer <daan.j.demeyer@gmail.com>,
	linux-unionfs@vger.kernel.org,
	linux-fsdevel@vger.kernel.org
Subject: [PATCH] ovl: check access to copy_file_range source with src mounter creds
Date: Sun, 12 Jul 2026 14:24:21 +0200
Message-ID: <20260712122421.203113-1-amir73il@gmail.com>
X-Mailer: git-send-email 2.54.0
Precedence: bulk
X-Mailing-List: linux-unionfs@vger.kernel.org
List-Id: <linux-unionfs.vger.kernel.org>
List-Subscribe: <mailto:linux-unionfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-unionfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Commit 5dae222a5ff0c ("vfs: allow copy_file_range to copy across devices")
allowed filesystems that implement the copy_file_range() f_op to decide
if they want to access cross-sb copy from/to the same fs type.

The same commit added checks to verify same sb copy for filesystems that
implement ->copy_file_range() and do not support cross-sb copy at the
time, namely, to ceph, fuse and nfs.

The two remaining fs which implement ->copy_file_range(), cifs and
overlayfs started to support cross-sb copy from this time.

While overlayfs does support cross-sb copy when the two underlying files
are on the same base fs, the copy operation on the two real files from
two different overalyfs filesystems is performed with the mounter
creds of the destination overlayfs and the read permission access hook
for the source file was called with the wrong creds.

This could cause either deny of access to copy which would otherwise be
allowed (e.g. with splice) or allow read access to file which would
otherwise be denied.

Fix the latter case by explicitly verifying read access to source file
with the source overlayfs mounter creds.

The former case remains a quirk of cross-sb overlayfs copy, but
userspace could fall back to regular copy so no harm done.

Fixes: 5dae222a5ff0c ("vfs: allow copy_file_range to copy across devices")
Signed-off-by: Amir Goldstein <amir73il@gmail.com>
---

Christian,

I am no longer surprised finding more things that are wrong with
copy_file_range().

I have a feeling this is not the last time either.

Thanks,
Amir.

 fs/overlayfs/file.c | 16 +++++++++++++++-
 1 file changed, 15 insertions(+), 1 deletion(-)

diff --git a/fs/overlayfs/file.c b/fs/overlayfs/file.c
index 27cc07738f33b..f3d97eb146e85 100644
--- a/fs/overlayfs/file.c
+++ b/fs/overlayfs/file.c
@@ -528,6 +528,7 @@ static loff_t ovl_copyfile(struct file *file_in, loff_t pos_in,
 			    struct file *file_out, loff_t pos_out,
 			    loff_t len, unsigned int flags, enum ovl_copyop op)
 {
+	struct inode *inode_in = file_inode(file_in);
 	struct inode *inode_out = file_inode(file_out);
 	struct file *realfile_in, *realfile_out;
 	loff_t ret;
@@ -551,7 +552,20 @@ static loff_t ovl_copyfile(struct file *file_in, loff_t pos_in,
 	if (IS_ERR(realfile_in))
 		goto out_unlock;
 
-	with_ovl_creds(file_inode(file_out)->i_sb) {
+	/*
+	 * For cross-sb copy, vfs_copy_file_range() will verify read access with
+	 * the mounter creds of the dest fs mounter, so we need to explicitly
+	 * verify read access with the source mounter creds.
+	 */
+	if (unlikely(inode_in->i_sb != inode_out->i_sb)) {
+		with_ovl_creds(inode_in->i_sb) {
+			ret = rw_verify_area(READ, realfile_in, &pos_in, len);
+			if (unlikely(ret))
+				goto out_unlock;
+		}
+	}
+
+	with_ovl_creds(inode_out->i_sb) {
 		switch (op) {
 		case OVL_COPY:
 			ret = vfs_copy_file_range(realfile_in, pos_in,
-- 
2.54.0

