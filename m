Received: from mail-ej1-f41.google.com (mail-ej1-f41.google.com [209.85.218.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CD86F473C9D
	for <linux-unionfs@vger.kernel.org>; Thu, 23 Jul 2026 11:49:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.41
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784807354; cv=none; b=HDS0LGWumWCy72lmYW/1qxqhjZaY8kwcLawljAWKH9SUkWYxLQQI5YNMXEx0g0N7ckrXlEoel1CBEJd3LryKQe0r7nw0ZMSPxXfrUmlbrdkp2O04OROWkLbWJP9SkQ2nplxG42XN3kWj3dD0UERaHKXCPuYeBd5kYO1N6VMoMn8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784807354; c=relaxed/simple;
	bh=u4WSZn8LpVoSFoR0j9C7HWeJrRajMHbArA1zRGf20q4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Up2BX85Q+MqbT/TCHO5lgtXhboGI+oXXEk0Ci5Kxm3Pp69ocZmNL1yMCScHP+mLnIO91hOPzMnMXyPGXnbXCvWVoIa3c01q4I8+G3uwsEiQzn8uKM/tY7Mz1iKsAcQf/p+x5uqMROnqBQ3nOZHnvBq6uSIG8A2MxyqyVxXBor2g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=sBXjoQz8; arc=none smtp.client-ip=209.85.218.41
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="sBXjoQz8"
Received: by mail-ej1-f41.google.com with SMTP id a640c23a62f3a-c1671ec8692so71465766b.0
        for <linux-unionfs@vger.kernel.org>; Thu, 23 Jul 2026 04:48:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1784807334; x=1785412134; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=nxorIkgqPrrBq5Tfe/wFMye9q74MZOclMs+Fvsmlsac=;
        b=sBXjoQz8VCpbqgBHzdkCiEAczjtvcvXTjH9x/ENtIXA2a3Iads4Vh5Wl2Crb0nWLRw
         1UgLcOWqxlE+I2lOAnKdJDER4f14YizTyO3ed1Rq67c8oKdJe73sp7D32kpdpNjauFnW
         RveitxC98nY5v4ZMtXnyolhb8/8Nq6jHlO0AagxL24qEPrscQcYMBnUAZSDMW10YvbD7
         Noy+3HSijndhK3BDdTk2jsssAe+/OEGoP5UCZeTKw0Ma1CZRnHgm3crwb/uajp/5R0Tg
         tgvyjGa0USjwcgrPq24w3E88CnQhiwSnhHlFheeehWCoUzDLmNYI4oCAbdwgnYNWvNR6
         Mv7A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1784807334; x=1785412134;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=nxorIkgqPrrBq5Tfe/wFMye9q74MZOclMs+Fvsmlsac=;
        b=LFukQaF/HWoYzA1+P8kGQOdmcnELQz/EeNfIyGs6E0mQir9npwnNUAz0R9q3g1uTSg
         xwRyIux2vjCvVgQeXIEF9JI6qIrZijCHvYIpUlHfwHPhZp6ehvtfiapsiqRCM1WnFS2N
         yQrydnYqPi7bora3QW3uWlmO1oNA2xIYcL2XV6YFj0oE+uY5wn8VTzkV/B7jromX44em
         J2UByh11IoW25iBU6AULymSLI+jE4iM4TEYENmb/AMMSpDcLYTpBsnz3/iNKlAKIQ4TH
         l14ZnRvG25gjOT3UYslD4Tw6mYVGmI0RDNhBiAQP/q2wcZGx2cKUo8h42hQIskpoQ3AZ
         YzZQ==
X-Forwarded-Encrypted: i=1; AHgh+Rr9cHq9eKcGOzp9ttEiiyMD+RRPucDowTqaWOVNuw/TyW7z7cCe380z2JOe0Mq8y7DN0ZUk5oF88DWdN5Yy@vger.kernel.org
X-Gm-Message-State: AOJu0Yx5kFlC4TtZbxv9oB12VsVD2L9vVxUK6mqF2QiqU5gnOarPSkVK
	iqCI1dYIkOo/zy0gBc8R5uW8f+UwW/J6jqARTDIpVFtM78oox7Oz79sf
X-Gm-Gg: AR+sD11gfaXmqpvqwXvny3xIfNw/Bj4f5Ai0GPackAwTbXwQdzCdx+8bNoDUya3V7dp
	yq2FmeQv/Aa36Pdi2ZE66yfcwmvFBuQeXjgUxi4Zinx7mzcHVb7KZGptSGj+VU4DAdz+EF5Rs7p
	/yW1+T/qdF2rbUL7ztJwnyVHQB/xWR19guNeTk32N89FuBJFI8ayISgED+nR6xG7aeACjqtwBTc
	MVvJ72Kfn6htzkJNFNxotOQUkVXVM85vubvTQSWhTrZZzBsqfaLa4Jers225VseRRegTegnqoPT
	y/eW7WBd4MAcx+oooArLch9g20NXrzwNVLaTpE+Z23c3CQMWvDBcTE7Cad8oYqEd8ifWL5FEHHm
	jWIWsr10tWJ3svlUgN8dZyYtL7PAKzTLzgmAEJwwRBYA06aRaCms6VOOusfOF3F5QhIgKNR5sSy
	ChA3J9mg9CMAZPnFLVG+kzLP8NbVI=
X-Received: by 2002:a17:907:2683:b0:c12:8664:6aec with SMTP id a640c23a62f3a-c1c5099c554mr122814666b.53.1784807334342;
        Thu, 23 Jul 2026 04:48:54 -0700 (PDT)
Received: from localhost (178-84-201-199.dynamic.upc.nl. [178.84.201.199])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-c1c32ac7eacsm225125066b.17.2026.07.23.04.48.53
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 23 Jul 2026 04:48:53 -0700 (PDT)
From: Amir Goldstein <amir73il@gmail.com>
To: Christian Brauner <brauner@kernel.org>
Cc: Miklos Szeredi <miklos@szeredi.hu>,
	Daan De Meyer <daan.j.demeyer@gmail.com>,
	linux-unionfs@vger.kernel.org,
	linux-fsdevel@vger.kernel.org
Subject: [RFC][PATCH 4/5] ovl: add support for copy file range from another fs
Date: Thu, 23 Jul 2026 13:48:47 +0200
Message-ID: <20260723114848.1212429-5-amir73il@gmail.com>
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

It is technically possible for overlayfs to copy_file_range() from
the base fs of the real layer.

Set the vfs flag FOP_CROSS_FS_COPY and implement copy from another fs.

Implementation of copy to another fs is a bit more subtle and will be
handled by a followup patch.

Signed-off-by: Amir Goldstein <amir73il@gmail.com>
---
 fs/overlayfs/file.c      | 22 ++++++++++++++++++++++
 fs/overlayfs/ovl_entry.h |  7 ++++++-
 2 files changed, 28 insertions(+), 1 deletion(-)

diff --git a/fs/overlayfs/file.c b/fs/overlayfs/file.c
index f3d97eb146e85..169a48de565e9 100644
--- a/fs/overlayfs/file.c
+++ b/fs/overlayfs/file.c
@@ -533,6 +533,13 @@ static loff_t ovl_copyfile(struct file *file_in, loff_t pos_in,
 	struct file *realfile_in, *realfile_out;
 	loff_t ret;
 
+	/*
+	 * Overlayfs may be able to copy to a non overlayfs dst which is on the
+	 * same sb or same fs type as real file_in fs, but not implemented yet.
+	 */
+	if (WARN_ON_ONCE(!is_ovl_fs(inode_out->i_sb)))
+		return -EXDEV;
+
 	inode_lock(inode_out);
 	if (op != OVL_DEDUPE) {
 		/* Update mode */
@@ -547,6 +554,19 @@ static loff_t ovl_copyfile(struct file *file_in, loff_t pos_in,
 	if (IS_ERR(realfile_out))
 		goto out_unlock;
 
+	/*
+	 * Overlayfs may be able to copy from a non overlayfs src which is on
+	 * the same sb or same fs type as upper fs.
+	 */
+	if (unlikely(!is_ovl_fs(inode_in->i_sb))) {
+		if (WARN_ON_ONCE(op != OVL_COPY)) {
+			ret = -EXDEV;
+			goto out_unlock;
+		}
+		realfile_in = file_in;
+		goto do_copy;
+	}
+
 	realfile_in = ovl_real_file(file_in);
 	ret = PTR_ERR(realfile_in);
 	if (IS_ERR(realfile_in))
@@ -565,6 +585,7 @@ static loff_t ovl_copyfile(struct file *file_in, loff_t pos_in,
 		}
 	}
 
+do_copy:
 	with_ovl_creds(inode_out->i_sb) {
 		switch (op) {
 		case OVL_COPY:
@@ -660,6 +681,7 @@ const struct file_operations ovl_file_operations = {
 	.splice_read    = ovl_splice_read,
 	.splice_write   = ovl_splice_write,
 
+	.fop_flags		= FOP_CROSS_FS_COPY,
 	.copy_file_range	= ovl_copy_file_range,
 	.remap_file_range	= ovl_remap_file_range,
 	.setlease		= generic_setlease,
diff --git a/fs/overlayfs/ovl_entry.h b/fs/overlayfs/ovl_entry.h
index 80cad4ea96a3e..8a1862cf87d78 100644
--- a/fs/overlayfs/ovl_entry.h
+++ b/fs/overlayfs/ovl_entry.h
@@ -112,10 +112,15 @@ static inline struct mnt_idmap *ovl_upper_mnt_idmap(struct ovl_fs *ofs)
 
 extern struct file_system_type ovl_fs_type;
 
+static inline bool is_ovl_fs(const struct super_block *sb)
+{
+	return sb->s_type == &ovl_fs_type;
+}
+
 static inline struct ovl_fs *OVL_FS(struct super_block *sb)
 {
 	if (IS_ENABLED(CONFIG_OVERLAY_FS_DEBUG))
-		WARN_ON_ONCE(sb->s_type != &ovl_fs_type);
+		WARN_ON_ONCE(!is_ovl_fs(sb));
 
 	return (struct ovl_fs *)sb->s_fs_info;
 }
-- 
2.54.0

