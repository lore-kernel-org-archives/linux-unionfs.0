Received: from mail-ej1-f49.google.com (mail-ej1-f49.google.com [209.85.218.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 25970439F72
	for <linux-unionfs@vger.kernel.org>; Thu, 23 Jul 2026 11:48:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.49
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784807346; cv=none; b=k4GVpwIpBozNqgB5njoMwXVcNysnxqTUSrKKiUayoh86EXNC204rZyEIPvP1maHbOSI6Do2eEYT+5CqtIm7tKzH7HTc2Ky7sPkXpACr8i5VVgeQEp3Kgg0Lr6BVoc2AjwlGeIxxtLqTrEkHzSf2G5tx+XqKdpqMy3fYk12i+ueI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784807346; c=relaxed/simple;
	bh=0eZ44vRLmwXW+idA/DolwNy8TEUzAGtfC/q/hMtHyaY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=vE3BpGM5Jz5/Ied4o+0/Z1jmDNJLUTiF2HUNn5ZNAhvrIijFvv2005T/NtQUiLl/KdCFxZF5CwweS2nk4ey/+phPfDggKnak1yZz0hIs6Z36LeCgE1e4DEYbH+xa1ZhRflWvZyPJQATZUaBeWDut+XQflNbI9P+rAkfk9xJzLZc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=epANqQAp; arc=none smtp.client-ip=209.85.218.49
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="epANqQAp"
Received: by mail-ej1-f49.google.com with SMTP id a640c23a62f3a-c1691e4ec40so74214466b.3
        for <linux-unionfs@vger.kernel.org>; Thu, 23 Jul 2026 04:48:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1784807332; x=1785412132; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=binhsfVmJu1koFpPwWC5CdCKR21x/B43OyPE1y0ab6Q=;
        b=epANqQApLKuJ6qNNARfHzBGGgt4OWpHA66ugvKzcH/YduAmA3fFkm+qOt4+mGeB+um
         3erNWOsUg/SNlGYtrvVoRoXQ/OsrdzvCT6xu52ocBoQrn1wHH5sz1qWuyGO5c+gO4Ly6
         PqUsP75/s8y1+0hDMz4llg2K5W5u2EYo+Rar5hnZ03ISInO6nzY5rWpTOXQ/5302w6IG
         9tMA92pvlhOcYqZM9ZwWFkwDFxKkTEyzd0hs9btHS2Sdx82GzEMPF2ZbTfrfVxMlwFL1
         10TE4o0MlbK8n5USbeMZ9c/5AY4gzi/GJ94cJh2xeLkZY/F1M80KW1i0j2iRWEVlGmA2
         7oZg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1784807332; x=1785412132;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=binhsfVmJu1koFpPwWC5CdCKR21x/B43OyPE1y0ab6Q=;
        b=Yc6pnWJ0JGwg7uGQrFB0OBakBzW+iScFwmhDlYb+hneAq7yKl8b48gFK5jTraOrijV
         rfnHkK/AsczH1U5oFSHYCv7Ex43lNoqZCk9v8lwT+8AZu0DBay5dYTuLpsDLC5UqiCeY
         AU1BPd/4JAzyIbuebYutJE4mRZST1TgQeqNznLwF7o9HykqvZEV+UelfLJuzERKkV8LB
         gBoFiZnmzU2C8wHUDBY4CLh78MeH94EQUBED0WCrdaWBLSAXWuvkdF7DtvaPu4LjJ6b2
         c5aZISbM72lTdUBAzAC4a+phPDtbZZuYvP2XcrGdSAaDov27+XfLq1dBBi8kGvWCTaUh
         BPgQ==
X-Forwarded-Encrypted: i=1; AHgh+RrzwHEAgHpRlayMFWC+asml6aqA8mSYy52RSVpiL8sJf+zyrAxP1BkoewgoDKDdP6eztbfQQreeAjGuJBco@vger.kernel.org
X-Gm-Message-State: AOJu0Ywy7naIUau8pRh6oJOqMxD+SX7rB3JX6vgx9w0lxlGWB4Ebk8gr
	4jxs34Ld6OZGdehqIuNQaRaX9v8KVcNAbOzfRGoks/uArIhPM1lv7BEp
X-Gm-Gg: AR+sD10cyUlE+/I2b7yjnpELJbSqJIkMNaDQDWXE4iSZo52HYXeCl6dP+yA/AIdb9xx
	xpyZAc3keyZEk/3oQPKiR00LpcX+DCs3CBKIdaXl0mRgVIKieWZpW5SAiidymbEg6Py7KFTvqlC
	BDL5r/Vh6zsTUmb0LP93n5hOY0JB9JTQ7L9+EQFJbYltS1ZOvCIMZ5Tu7z8Fi2rcaOe1yQqlfOk
	mhJqUTgqZ/yE3b7/gXcHoY+iuGFPAhms7ECbpyjvTjXEkGJ6yk3C9rWbG3SVfOSqE2l8mVVfolj
	TX03o5/JA+MhzwQYTBZhy/iPuhLnI6VrWCoLBQbqZzT1cbC0F3hiifFFZBUDM1Ndz1v3+VZ5sSO
	5/IZmsBvu2rQ4JYN9ZJjzwieRcRuOHXX8IctQq59grNubOgBvrESnA9DtlPCmEuBGKNHPVeKR4S
	b24qjREGOTt3gYhyXfG1+5k7OpxQk=
X-Received: by 2002:a17:907:9806:b0:c08:417e:3696 with SMTP id a640c23a62f3a-c1c50b944a9mr129255466b.20.1784807332002;
        Thu, 23 Jul 2026 04:48:52 -0700 (PDT)
Received: from localhost (178-84-201-199.dynamic.upc.nl. [178.84.201.199])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-c1c32ebcc4dsm227109666b.49.2026.07.23.04.48.51
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 23 Jul 2026 04:48:51 -0700 (PDT)
From: Amir Goldstein <amir73il@gmail.com>
To: Christian Brauner <brauner@kernel.org>
Cc: Miklos Szeredi <miklos@szeredi.hu>,
	Daan De Meyer <daan.j.demeyer@gmail.com>,
	linux-unionfs@vger.kernel.org,
	linux-fsdevel@vger.kernel.org
Subject: [RFC][PATCH 2/5] fs: add support for copy file range from another fs
Date: Thu, 23 Jul 2026 13:48:45 +0200
Message-ID: <20260723114848.1212429-3-amir73il@gmail.com>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260723114848.1212429-1-amir73il@gmail.com>
References: <20260723114848.1212429-1-amir73il@gmail.com>
Precedence: bulk
X-Mailing-List: linux-unionfs@vger.kernel.org
List-Id: <linux-unionfs.vger.kernel.org>
List-Subscribe: <mailto:linux-unionfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-unionfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Add a declarative vfs flag FOP_CROSS_FS_COPY for filesystems that may
be able copy from/to other fs and implement the copy from another fs,
which is the easy side.

When filesystem is copying from another fs, it will typically call vfs
read helpers to read from the other fs, so avoid the double accounting
and double fsnotify read hooks in vfs_copy_file_range().

Implementation of copy to another fs is a bit more subtle and will be
handled by a followup patch.

Signed-off-by: Amir Goldstein <amir73il@gmail.com>
---
 fs/read_write.c    | 18 ++++++++++++++----
 include/linux/fs.h |  2 ++
 2 files changed, 16 insertions(+), 4 deletions(-)

diff --git a/fs/read_write.c b/fs/read_write.c
index d1565a56d089d..78596d9c89119 100644
--- a/fs/read_write.c
+++ b/fs/read_write.c
@@ -1477,6 +1477,7 @@ enum {
 	FS_COPY_SAME_SB = 1,
 	FS_COPY_SAME_FS = 2,
 	FS_COPY_CROSS_FS = 3,
+	FS_COPY_FROM_OTHER_FS = 4,
 };
 
 /*
@@ -1495,6 +1496,8 @@ static int copy_file_fs_cmp(struct file *f_in, struct file *f_out,
 	else if (f_out->f_op->copy_file_range &&
 		 f_out->f_op->copy_file_range == f_in->f_op->copy_file_range)
 		return FS_COPY_SAME_FS;
+	else if (f_out->f_op->fop_flags & FOP_CROSS_FS_COPY)
+		return FS_COPY_FROM_OTHER_FS;
 	else if (file_inode(f_in)->i_sb == file_inode(f_out)->i_sb)
 		return FS_COPY_SAME_SB;
 	else
@@ -1526,10 +1529,13 @@ static int generic_copy_file_checks(struct file *file_in, loff_t pos_in,
 	 * We allow some filesystems to handle cross sb copy, but passing
 	 * a file of the wrong filesystem type to filesystem driver can result
 	 * in an attempt to dereference the wrong type of ->private_data, so
-	 * avoid doing that until we really have a good reason.
+	 * avoid doing that unless at least one of the filesystems declares
+	 * cross fstype copy support with the FOP_CROSS_FS_COPY flag.
 	 */
 	if (fscmp == FS_COPY_SPLICE) {
 		/* cross sb splice is allowed */
+	} else if (fscmp == FS_COPY_FROM_OTHER_FS) {
+		/* Copy from other fs is allowed */
 	} else if (file_out->f_op->copy_file_range) {
 		if (fscmp != FS_COPY_SAME_FS)
 			return -EXDEV;
@@ -1619,6 +1625,7 @@ ssize_t vfs_copy_file_range(struct file *file_in, loff_t pos_in,
 	case FS_COPY_SPLICE:
 		break;
 	case FS_COPY_SAME_FS:
+	case FS_COPY_FROM_OTHER_FS:
 		ret = file_out->f_op->copy_file_range(file_in, pos_in,
 						      file_out, pos_out,
 						      len, flags);
@@ -1665,13 +1672,16 @@ ssize_t vfs_copy_file_range(struct file *file_in, loff_t pos_in,
 	ret = do_splice_direct(file_in, &pos_in, file_out, &pos_out, len, 0);
 done:
 	if (ret > 0) {
-		fsnotify_access(file_in);
-		add_rchar(current, ret);
+		if (fscmp != FS_COPY_FROM_OTHER_FS) {
+			fsnotify_access(file_in);
+			add_rchar(current, ret);
+		}
 		fsnotify_modify(file_out);
 		add_wchar(current, ret);
 	}
 
-	inc_syscr(current);
+	if (fscmp != FS_COPY_FROM_OTHER_FS)
+		inc_syscr(current);
 	inc_syscw(current);
 
 	return ret;
diff --git a/include/linux/fs.h b/include/linux/fs.h
index d10897b3a1e35..c7573e89557b9 100644
--- a/include/linux/fs.h
+++ b/include/linux/fs.h
@@ -1980,6 +1980,8 @@ struct file_operations {
 #define FOP_ASYNC_LOCK		((__force fop_flags_t)(1 << 6))
 /* File system supports uncached read/write buffered IO */
 #define FOP_DONTCACHE		((__force fop_flags_t)(1 << 7))
+/* Supports copy_file_range() to/from other fs types */
+#define FOP_CROSS_FS_COPY	((__force fop_flags_t)(1 << 8))
 
 /* Wrap a directory iterator that needs exclusive inode access */
 int wrap_directory_iterator(struct file *, struct dir_context *,
-- 
2.54.0

