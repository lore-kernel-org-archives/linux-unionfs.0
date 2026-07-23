Received: from mail-ed1-f53.google.com (mail-ed1-f53.google.com [209.85.208.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AE2D54746A2
	for <linux-unionfs@vger.kernel.org>; Thu, 23 Jul 2026 11:48:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.53
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784807345; cv=none; b=n1cXS6oYZaS7AZC1w+pIYarah8DJc+WzoVZ20ZiQ2gcw+odpVyFF8Nep7e7Otwze4bkyeWsHCvfgz0rg8+Lu0bcOXi5yyM4BfA4r3E1p/TGoD5jE/c0mK/XiGMGq95/3jEtp3IQxh/xUZvQugFyyGs7WJ/98CbUaRNVtvKDiFZA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784807345; c=relaxed/simple;
	bh=Kt1hCqrqQM/bckgN4lFfrytum0aHe7wnFG6iCEtQeXY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=YLXY69cMrK4UcW9dnB3eAChAPurcEeYT3RliAGZ2P5VXU7HlLup9XXft6eyjzUNZIk27ecRsCBFrlGp985TDTOyZAA2k98iQXs0LjyC48KYei+uk3iQSS1yqf6zejvVEC2OFqwSoEeR/Q77jZHe71VJL2zI+KgyaXMqnRIan260=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=k7crwoQg; arc=none smtp.client-ip=209.85.208.53
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="k7crwoQg"
Received: by mail-ed1-f53.google.com with SMTP id 4fb4d7f45d1cf-698ae09e356so671261a12.2
        for <linux-unionfs@vger.kernel.org>; Thu, 23 Jul 2026 04:48:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1784807331; x=1785412131; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=q/MQeRks0wSOXitJI8AnJaZEFhJZHq3MAOM6m19ooxw=;
        b=k7crwoQgCQuKVrxKBOtS5hTFrJme7toQL5gXZF7GSo+IHwvDkK98yQ32EBN/SoiSbj
         iGJbG30381M7hgycL056rIxVpmhC3vKojj+3G7WKin6HZXrO8h6yWTJR93jMqk0a6fyk
         9jRzNnE7T0yoZ7dwGmoDpa99Ia4DWvx03gf51jZczvGP0vUF4m3auprfEGMxroiHHrUp
         fL4uxBZQsBChJ8xy1gvLZ34FQHT8WK2gHpB2CF7nx/WbEElaRut3NP74h7CY8uYsv5W2
         D5WaV8lZeuJhbZJnbV8hmw/ugpGvnfLopSbkx7TVtlRDBFmnGiFJoUPXt5xSjG1YK/1/
         4XXw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1784807331; x=1785412131;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=q/MQeRks0wSOXitJI8AnJaZEFhJZHq3MAOM6m19ooxw=;
        b=AtdP7/edH30inwN9CaE+pIKkToKhYv2DruvBxr6QgfnyytlNf+jpHWVtJpGs+PNxvH
         K8Erl0SasHmekWy+GiQ9dnilv6HSJ2+jgCghnyJYJU74ZoKCU8sW6VHsEGijW3FcKWjC
         nz6mgANCVdjolDxZZ1FhyrOA2voHvCelfKD1/dOnbJQ8A4xV2l/mnq4XzljSpGeqwRrF
         nGwewUuVFp1G9b6cOg3rXEUEsUhf91/sGA85hKRW1Zjo8g4VF5HPimZN02FDJGPQkbFt
         agnKhnFIbabHaWxbF1K34ITQ+kBmwljPoHYdKg3JiDdxzzcm6WApk0505UlQOgBfjDN1
         EFsg==
X-Forwarded-Encrypted: i=1; AHgh+RpEyTRU30chz9ZWxPbdeSpct+HTlJFk2n/sEx9ShuUgUuS6cANrEvbzuZnDicyqe/gl5Piq323xnI8E21Kc@vger.kernel.org
X-Gm-Message-State: AOJu0Yw95c6P4bJe+bBz6ismK5ukgxXFrbgYMQT//RRan//yt7lHgTlj
	VsZLVC4uqbku7ZdnT/bHXKfZ+tnME/vvdoz6jjX41ZpoG2tCIJJ/a22M
X-Gm-Gg: AR+sD10UizFZVgsyp31LRHj6R80ZyWZfbf1bpSMR7SKPAsFv+zprKoCS2CsR1hro38I
	fgtWjv5ySMBiSraIasdrO1akBoPlJPrfJu/JxG3WWlEZdgbpAGSMh33hKKaS02ItPDaKKspQtai
	bWlINwbPwxMpzdApAAX/Mt269IZegPMynZteBCWHlupqk7DpTMWe/0aaEcS1T84Is06nMPg2k6O
	6hS+XgLJ6k4i9Q6zfAgpHYodO/N0nnJ8ZJg9X+dLf+EpkBlhmPXetmhJx/LA+r9DNuH6hPhDQnf
	CgTAAy1OV72gdmheAdFLXsZ1JszjDQx87Gjz2xCZN97gOpCn3/7kv++a2xpt/hPbYOis/eF5B69
	UBqXufqq6SrPCFYZVNH8knOHscldD2VPYs+liDAeSYNF2Hm5+YV3WKWrH+49X4eH4XgbJITU7vj
	MyM8USi8JEKCi99HNU996QJs0O+cQ=
X-Received: by 2002:a05:6402:21da:b0:698:52b4:c2c9 with SMTP id 4fb4d7f45d1cf-69f6ab2452bmr1012692a12.31.1784807330916;
        Thu, 23 Jul 2026 04:48:50 -0700 (PDT)
Received: from localhost (178-84-201-199.dynamic.upc.nl. [178.84.201.199])
        by smtp.gmail.com with ESMTPSA id 4fb4d7f45d1cf-69f35039aa1sm1956131a12.30.2026.07.23.04.48.50
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 23 Jul 2026 04:48:50 -0700 (PDT)
From: Amir Goldstein <amir73il@gmail.com>
To: Christian Brauner <brauner@kernel.org>
Cc: Miklos Szeredi <miklos@szeredi.hu>,
	Daan De Meyer <daan.j.demeyer@gmail.com>,
	linux-unionfs@vger.kernel.org,
	linux-fsdevel@vger.kernel.org
Subject: [RFC][PATCH 1/5] fs: clarify cross-sb copy_file_range() code
Date: Thu, 23 Jul 2026 13:48:44 +0200
Message-ID: <20260723114848.1212429-2-amir73il@gmail.com>
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

The cross-sb copy file range code is a bit complicated and spreads across
two different functions.

Use a helper copy_file_fs_cmp() an enum and switch statement to clarify
the mutual exclusive types of copy.

Signed-off-by: Amir Goldstein <amir73il@gmail.com>
---
 fs/read_write.c | 70 +++++++++++++++++++++++++++++++++++--------------
 1 file changed, 51 insertions(+), 19 deletions(-)

diff --git a/fs/read_write.c b/fs/read_write.c
index e8c14e2760b20..d1565a56d089d 100644
--- a/fs/read_write.c
+++ b/fs/read_write.c
@@ -1472,6 +1472,35 @@ COMPAT_SYSCALL_DEFINE4(sendfile64, int, out_fd, int, in_fd,
 }
 #endif
 
+enum {
+	FS_COPY_SPLICE = 0,
+	FS_COPY_SAME_SB = 1,
+	FS_COPY_SAME_FS = 2,
+	FS_COPY_CROSS_FS = 3,
+};
+
+/*
+ * Check if src and dst file are on the same filesystem.
+ * nfs and cifs define several different file_system_type structures
+ * and several different sets of file_operations, but they all end up
+ * using the same ->copy_file_range() function pointer.
+ * COPY_FILE_SPLICE is an opt-in flag for cross-fs copy (e.g. from nfsd),
+ * so do not compare src<->dst filesystems in this case.
+ */
+static int copy_file_fs_cmp(struct file *f_in, struct file *f_out,
+			    unsigned int flags)
+{
+	if (flags & COPY_FILE_SPLICE)
+		return FS_COPY_SPLICE;
+	else if (f_out->f_op->copy_file_range &&
+		 f_out->f_op->copy_file_range == f_in->f_op->copy_file_range)
+		return FS_COPY_SAME_FS;
+	else if (file_inode(f_in)->i_sb == file_inode(f_out)->i_sb)
+		return FS_COPY_SAME_SB;
+	else
+		return FS_COPY_CROSS_FS;
+}
+
 /*
  * Performs necessary checks before doing a file copy
  *
@@ -1481,7 +1510,7 @@ COMPAT_SYSCALL_DEFINE4(sendfile64, int, out_fd, int, in_fd,
  */
 static int generic_copy_file_checks(struct file *file_in, loff_t pos_in,
 				    struct file *file_out, loff_t pos_out,
-				    size_t *req_count, unsigned int flags)
+				    size_t *req_count, int fscmp)
 {
 	struct inode *inode_in = file_inode(file_in);
 	struct inode *inode_out = file_inode(file_out);
@@ -1498,18 +1527,13 @@ static int generic_copy_file_checks(struct file *file_in, loff_t pos_in,
 	 * a file of the wrong filesystem type to filesystem driver can result
 	 * in an attempt to dereference the wrong type of ->private_data, so
 	 * avoid doing that until we really have a good reason.
-	 *
-	 * nfs and cifs define several different file_system_type structures
-	 * and several different sets of file_operations, but they all end up
-	 * using the same ->copy_file_range() function pointer.
 	 */
-	if (flags & COPY_FILE_SPLICE) {
+	if (fscmp == FS_COPY_SPLICE) {
 		/* cross sb splice is allowed */
 	} else if (file_out->f_op->copy_file_range) {
-		if (file_in->f_op->copy_file_range !=
-		    file_out->f_op->copy_file_range)
+		if (fscmp != FS_COPY_SAME_FS)
 			return -EXDEV;
-	} else if (file_inode(file_in)->i_sb != file_inode(file_out)->i_sb) {
+	} else if (fscmp != FS_COPY_SAME_SB) {
 		return -EXDEV;
 	}
 
@@ -1556,13 +1580,13 @@ ssize_t vfs_copy_file_range(struct file *file_in, loff_t pos_in,
 {
 	ssize_t ret;
 	bool splice = flags & COPY_FILE_SPLICE;
-	bool samesb = file_inode(file_in)->i_sb == file_inode(file_out)->i_sb;
+	int fscmp = copy_file_fs_cmp(file_in, file_out, flags);
 
 	if (flags & ~COPY_FILE_SPLICE)
 		return -EINVAL;
 
 	ret = generic_copy_file_checks(file_in, pos_in, file_out, pos_out, &len,
-				       flags);
+				       fscmp);
 	if (unlikely(ret))
 		return ret;
 
@@ -1591,19 +1615,27 @@ ssize_t vfs_copy_file_range(struct file *file_in, loff_t pos_in,
 	 * same sb using clone, but for filesystems where both clone and copy
 	 * are supported (e.g. nfs,cifs), we only call the copy method.
 	 */
-	if (!splice && file_out->f_op->copy_file_range) {
+	switch (fscmp) {
+	case FS_COPY_SPLICE:
+		break;
+	case FS_COPY_SAME_FS:
 		ret = file_out->f_op->copy_file_range(file_in, pos_in,
 						      file_out, pos_out,
 						      len, flags);
-	} else if (!splice && file_in->f_op->remap_file_range && samesb) {
-		ret = file_in->f_op->remap_file_range(file_in, pos_in,
-				file_out, pos_out, len, REMAP_FILE_CAN_SHORTEN);
-		/* fallback to splice */
+		break;
+	case FS_COPY_SAME_SB:
+		if (file_in->f_op->remap_file_range)
+			ret = file_in->f_op->remap_file_range(file_in, pos_in,
+							file_out, pos_out, len,
+							REMAP_FILE_CAN_SHORTEN);
+		/* Fallback to splice for same sb copy for backward compat */
 		if (ret <= 0)
 			splice = true;
-	} else if (samesb) {
-		/* Fallback to splice for same sb copy for backward compat */
-		splice = true;
+		break;
+	case FS_COPY_CROSS_FS:
+		/* This should have failed in generic_copy_file_checks() */
+		ret = -EXDEV;
+		break;
 	}
 
 	file_end_write(file_out);
-- 
2.54.0

