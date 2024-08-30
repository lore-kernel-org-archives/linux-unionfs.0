Received: from mail-wr1-f50.google.com (mail-wr1-f50.google.com [209.85.221.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 24E4B13A261
	for <linux-unionfs@vger.kernel.org>; Fri, 30 Aug 2024 09:56:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.50
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725011784; cv=none; b=TxheuFSp7tWBtVPbAdQdYXc09hOMBZwLWtScKsk2GXA18wFdu3ud3Y9oYn/zCN9YqS9ygXxrJbNa2DXzNiznUDEV5yO4BmF/g7c8Rr7HyXRPAqPQC9sJ4NE2HJniBeHuJEs377SFLAfMpDA2gqoj3/LVckuzgiQvVJxu0euGHDc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725011784; c=relaxed/simple;
	bh=jD28ayQ5Lpn/KjSFn+UGtrcm6XNHmtWWBVBuxKQu30o=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=T3Tpfjee8xshQMk/6Ej4D+sS8kugQyruZ+9Zt0BZy1vZab5KI622HV27Yj5FwNhyPBbA0xH0NTGyao4pQhFrB8OJQXPA6373QMdR0DLWUlJWZVVrUNHSZ2YhJCUvFFP27JwJbsSEVrtEhT9RurVuAKPTDISaJ3JUfqfGu+jJnFs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=juruQcHN; arc=none smtp.client-ip=209.85.221.50
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="juruQcHN"
Received: by mail-wr1-f50.google.com with SMTP id ffacd0b85a97d-3719f0758c6so1120166f8f.1
        for <linux-unionfs@vger.kernel.org>; Fri, 30 Aug 2024 02:56:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1725011781; x=1725616581; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=FgaNRnQ37OMZhQt+HTIv8Uz5jrPjexB9oxr4AcLO3DQ=;
        b=juruQcHNDuOAnbZX5f0DMvnQ5IMrM7k+MFiI2zrOStpMU8ouMVKxYZg+s6ang9qCGK
         8qPxgLCxxNigZQXWLF2rkUDI17A/jF5o0QHeBbvNjhXWLycJYPKPv0+x18TEN/gNxI+w
         aL1o2XtGuaXZ0kp9F9lWiYv0FRcFmWnBMQ7jRueM4GtDV0TY29AgJl5NHEbfsg4u3dth
         IPI5md3opsira3CkV5le9HuPcvYvP0+aIsBitX9Y9fxTsSx/o87Xpsxr8ZSgCimTOzfK
         z9H90EpUTrVi1vsL6b+qKBFNUFOc6xas7HiZz+7xVK6dgF+XtKxtfFpNax/b7ktvfL/r
         fHcA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1725011781; x=1725616581;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=FgaNRnQ37OMZhQt+HTIv8Uz5jrPjexB9oxr4AcLO3DQ=;
        b=F/gTI+R+Vx4kmEWJ+Go6bB08zMoX2w0IOgiomM0+cRKviLw3nruxGv43AVHrh77Q/r
         vH99WOBtIxXZMCzxlx2mJodo9qqzESR4fptrwgc9zm9RlHODpK9dWSqJpxgRgBJHtTWP
         E6G2apTzHrTX+TD6Cc9+T/DU7ADasB7mp3VL4/eI0y21Hl35PFd2ZPZTGNX4+fGM5k4/
         zDCUsoSLNAyRuxHghmi+/6X86A3RtH8Om9TkVrmgUzy/9F1aiSpz7dwkQImDRNY6SjTr
         EnljdJvebMnZ16o9gF1Il5ACQ7A9Zf/wkmfneSgD0+b0KxPj/U+vHKa1+NCAwLatH2Ev
         d3Ig==
X-Gm-Message-State: AOJu0YzLH5GRPcl/Ob9k2OJY49E78Nv664NoDLBRQhMjX8K3Wd79D15A
	f260sOup3HKeIg0OIpT5+U7E83u8DwSdsL1OzMvfk+yxnKOFVPZJqTg/m5no
X-Google-Smtp-Source: AGHT+IFZRkHuj/0tB37JODKz8OJJAkHGQTJSZquSLtpsKg9HO+MH0A5b/ZFaH8k7/XVVzQWRCvEylg==
X-Received: by 2002:a05:6000:1845:b0:374:b960:f847 with SMTP id ffacd0b85a97d-374b960f925mr333053f8f.41.1725011780890;
        Fri, 30 Aug 2024 02:56:20 -0700 (PDT)
Received: from amir-ThinkPad-T480.arnhem.chello.nl (92-109-99-123.cable.dynamic.v4.ziggo.nl. [92.109.99.123])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-42ba642593asm74996135e9.39.2024.08.30.02.56.20
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 30 Aug 2024 02:56:20 -0700 (PDT)
From: Amir Goldstein <amir73il@gmail.com>
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: linux-unionfs@vger.kernel.org,
	Fei Lv <feilv@asrmicro.com>
Subject: [PATCH] ovl: fsync after metadata copy-up
Date: Fri, 30 Aug 2024 11:56:02 +0200
Message-Id: <20240830095602.842849-1-amir73il@gmail.com>
X-Mailer: git-send-email 2.34.1
Precedence: bulk
X-Mailing-List: linux-unionfs@vger.kernel.org
List-Id: <linux-unionfs.vger.kernel.org>
List-Subscribe: <mailto:linux-unionfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-unionfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

For upper filesystems which do not use strict ordering of persisting
metadata changes (e.g. ubifs), when overlayfs file is modified for
the first time, copy up will create a copy of the lower file and
its parent directories in the upper layer. Permission lost of the
new upper parent directory was observed during power-cut stress test.

Fix by moving the fsync call to after metadata copy to make sure that the
metadata copied up directory and files persists to disk before renaming
from tmp to final destination.

With metacopy enabled, this change will hurt performance of workloads
such as chown -R, so we keep the legacy behavior of fsync only on copyup
of data.

Link: https://lore.kernel.org/linux-unionfs/CAOQ4uxj-pOvmw1-uXR3qVdqtLjSkwcR9nVKcNU_vC10Zyf2miQ@mail.gmail.com/
Reported-by: Fei Lv <feilv@asrmicro.com>
Signed-off-by: Amir Goldstein <amir73il@gmail.com>
---

Miklos,

This is the variant of Fei's patch as discussed on [1].
This changes the default behavior to always fsync directories
and has passed fstests.

Thanks,
Amir.

 fs/overlayfs/copy_up.c | 43 ++++++++++++++++++++++++++++++++++++++----
 1 file changed, 39 insertions(+), 4 deletions(-)

diff --git a/fs/overlayfs/copy_up.c b/fs/overlayfs/copy_up.c
index a5ef2005a2cc..051a802893a1 100644
--- a/fs/overlayfs/copy_up.c
+++ b/fs/overlayfs/copy_up.c
@@ -243,8 +243,24 @@ static int ovl_verify_area(loff_t pos, loff_t pos2, loff_t len, loff_t totlen)
 	return 0;
 }
 
+static int ovl_sync_file(struct path *path)
+{
+	struct file *new_file;
+	int err;
+
+	new_file = ovl_path_open(path, O_LARGEFILE | O_RDONLY);
+	if (IS_ERR(new_file))
+		return PTR_ERR(new_file);
+
+	err = vfs_fsync(new_file, 0);
+	fput(new_file);
+
+	return err;
+}
+
 static int ovl_copy_up_file(struct ovl_fs *ofs, struct dentry *dentry,
-			    struct file *new_file, loff_t len)
+			    struct file *new_file, loff_t len,
+			    bool datasync)
 {
 	struct path datapath;
 	struct file *old_file;
@@ -342,7 +358,8 @@ static int ovl_copy_up_file(struct ovl_fs *ofs, struct dentry *dentry,
 
 		len -= bytes;
 	}
-	if (!error && ovl_should_sync(ofs))
+	/* call fsync once, either now or later along with metadata */
+	if (!error && ovl_should_sync(ofs) && datasync)
 		error = vfs_fsync(new_file, 0);
 out_fput:
 	fput(old_file);
@@ -574,6 +591,7 @@ struct ovl_copy_up_ctx {
 	bool indexed;
 	bool metacopy;
 	bool metacopy_digest;
+	bool metadata_fsync;
 };
 
 static int ovl_link_up(struct ovl_copy_up_ctx *c)
@@ -634,7 +652,8 @@ static int ovl_copy_up_data(struct ovl_copy_up_ctx *c, const struct path *temp)
 	if (IS_ERR(new_file))
 		return PTR_ERR(new_file);
 
-	err = ovl_copy_up_file(ofs, c->dentry, new_file, c->stat.size);
+	err = ovl_copy_up_file(ofs, c->dentry, new_file, c->stat.size,
+			       !c->metadata_fsync);
 	fput(new_file);
 
 	return err;
@@ -701,6 +720,10 @@ static int ovl_copy_up_metadata(struct ovl_copy_up_ctx *c, struct dentry *temp)
 		err = ovl_set_attr(ofs, temp, &c->stat);
 	inode_unlock(temp->d_inode);
 
+	/* fsync metadata before moving it into upper dir */
+	if (!err && ovl_should_sync(ofs) && c->metadata_fsync)
+		err = ovl_sync_file(&upperpath);
+
 	return err;
 }
 
@@ -860,7 +883,8 @@ static int ovl_copy_up_tmpfile(struct ovl_copy_up_ctx *c)
 
 	temp = tmpfile->f_path.dentry;
 	if (!c->metacopy && c->stat.size) {
-		err = ovl_copy_up_file(ofs, c->dentry, tmpfile, c->stat.size);
+		err = ovl_copy_up_file(ofs, c->dentry, tmpfile, c->stat.size,
+				       !c->metadata_fsync);
 		if (err)
 			goto out_fput;
 	}
@@ -1135,6 +1159,17 @@ static int ovl_copy_up_one(struct dentry *parent, struct dentry *dentry,
 	    !kgid_has_mapping(current_user_ns(), ctx.stat.gid))
 		return -EOVERFLOW;
 
+	/*
+	 * With metacopy disabled, we fsync after final metadata copyup, for
+	 * both regular files and directories to get atomic copyup semantics
+	 * on filesystems that do not use strict metadata ordering (e.g. ubifs).
+	 *
+	 * With metacopy enabled we want to avoid fsync on all meta copyup
+	 * that will hurt performance of workloads such as chown -R, so we
+	 * only fsync on data copyup as legacy behavior.
+	 */
+	ctx.metadata_fsync = !OVL_FS(dentry->d_sb)->config.metacopy &&
+			     (S_ISREG(ctx.stat.mode) || S_ISDIR(ctx.stat.mode));
 	ctx.metacopy = ovl_need_meta_copy_up(dentry, ctx.stat.mode, flags);
 
 	if (parent) {
-- 
2.34.1

