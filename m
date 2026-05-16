Received: from mail-yw1-f176.google.com (mail-yw1-f176.google.com [209.85.128.176])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2893C2E414
	for <linux-unionfs@vger.kernel.org>; Sat, 16 May 2026 00:52:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.176
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778892764; cv=none; b=LDCRvIHc+HVtc665gB7/OKQQswQShS2k4LYKONtXBhFIJj73/IY9L1I1+y1eRc6un5F5a/n5RHK4ixsHWbJPCt1VwBx+D5UGA47z7enNOzCaKAEqPsQEUdYdteUWT96kMwQ+vBcoySoSTe0e2uFPpl5Zr63vpo8RRDBNoHUEyAA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778892764; c=relaxed/simple;
	bh=zSJkALzDqGKukVQxTZaJiqRxx6oxqqmIOxTG3xaoZfg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=g0SOVhknfyuyFtQRuEesYMsyXurRc2QbSNkw89o0TjD3g/0yl5EuQaUVElbKFPDbX67g6RmWpb9oEEILeOBXd9TImjqeWV7mERR/Mo/rtbooU2PsJ2datPbfAYRk2qt1nhEZ4kJWCwU1sSznUnqZYLk0WL2wIJKudOW5t5PN9oQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=hZJ6SHwc; arc=none smtp.client-ip=209.85.128.176
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="hZJ6SHwc"
Received: by mail-yw1-f176.google.com with SMTP id 00721157ae682-7bde9d73678so555837b3.0
        for <linux-unionfs@vger.kernel.org>; Fri, 15 May 2026 17:52:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1778892762; x=1779497562; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=sX7MssyZLaYfDJYTzs3MFepTBP0DFDIJ3NryOJvrQuw=;
        b=hZJ6SHwcgqGLngCde375FZKO5ty269vAaiorP3KfU1llNr1b0CVFMiCOz+1AR6aKvk
         h+QzzyelqgqoQltUUUdwXMePpzJZViZrwg//mbATRK+fmLzWoU8f8XTWPon+3fEoBoFX
         1+dqtJgOAU56a12MIQVkQ0w6HDLlsNiKH9Wj+YSS5acfnsZHzmViNdA1R/x8KjuP+ri2
         wczNKMDyB8kX4AqnOs2ud9GMxnmjcE6lsGkW29HTBVrs81r9c5QhGSU780QvRfw0mzfl
         7Y7DsTgLJ80ZM1OO+PD1yO1pUEHiJG3b17B9t/jzYcVqgfomR9deXj9GlsARGQJFVsjm
         zTuA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1778892762; x=1779497562;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=sX7MssyZLaYfDJYTzs3MFepTBP0DFDIJ3NryOJvrQuw=;
        b=sLL6I9d+ZhxcJ2w4xl2nPAjPePhttujZaVFkx427X4fX/07PL4VQXrX/oqF2bWTkJi
         +L8IK6x0Jz9KRpjFlD/3ehYS6L/nXQ2VC3kEguvcs3IAtdc/df2DturkUb1HMJXA8TgR
         mYGKd/oEjQmgcH6jWo80nUnjLLrDOPLdd/doAjyPtTdPwdIvsIA67+7vJob+VVmUD3UR
         mLMUcZ1rmceVlsrQMJNwc+y1QGFyQhqFIcz7AG9vQMAI9k7C27K2B4kWMuEeVaUM4Me4
         +b3jxpqZt7YzHcC/5lGEpgmpQ1cDQ6X2lFQXArcZp0BjXegyNcCfkIGQdFub3Cq8Acr+
         1MBQ==
X-Forwarded-Encrypted: i=1; AFNElJ8QQ8HfFrVBBFOB/a/MHaehGZtK0Tm18zRnVNW4E0MrOMXTXfprW5ZqMPGvOvezzzG0eeG0oUYXiOp1tiJF@vger.kernel.org
X-Gm-Message-State: AOJu0YwdMGtkiwH+8+7B2zoITE7ig5KmVgfGIhZu0iGMAz00M8VMDc1d
	//AfJ9YbeodH90UoGwGNG3uy+pnR3/TzNPGQV7sfKdFeXWtahWEZgorK
X-Gm-Gg: Acq92OEb3pNYhzMkp+ywKpsh6ABoAYZbdvFhWk0NYz8IajSJTEJrKZ0TDUpWqmM+x9o
	v8aeOyOhMJhZRbYS+ghfteg4NH1RaREHfk11faXqc32HgD7pxW4p/pO7l5ik6w/IP4WC+M2I07z
	Yev3rJ98tXtnhBDlu0RWxr4Kw0A6NZBGi1FQp6byR6XQvSPixKoMDRQGMFo/FTZ1+ZOwZhA/YgW
	cJ0b2N6tzIUODSjLXY9dIK8q0h9IePknHykPr6GtBurSJuiQx0aw2muQS42xRgPwW8+d1VWBxTA
	N3BMthfGlGZe5cJKm8Wr4hJPKTjh5KW3uams5eJ9KBSQhm6hUUyYtE21lf2cAciq00XH9lGfJsj
	MQ96KESI8ssgzI5cNKDkXkqwxqiw86w0UBpcifJQQvSuzOQvluYFQ7UjiNaFDtllV36r3mo0SmT
	w9kszaa+ic7kpJLziXpEewDVcSVlMP7p0=
X-Received: by 2002:a05:690c:9d:b0:7bd:956c:336a with SMTP id 00721157ae682-7c7e6680aa4mr90425957b3.13.1778892762230;
        Fri, 15 May 2026 17:52:42 -0700 (PDT)
Received: from localhost ([2a03:2880:f806:1c::])
        by smtp.gmail.com with ESMTPSA id 00721157ae682-7c7f2e9324csm37482117b3.22.2026.05.15.17.52.41
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 15 May 2026 17:52:41 -0700 (PDT)
From: Joanne Koong <joannelkoong@gmail.com>
To: amir73il@gmail.com,
	miklos@szeredi.hu
Cc: fuse-devel@lists.linux.dev,
	linux-unionfs@vger.kernel.org
Subject: [PATCH v2 10/21] fuse: prepare to cache statx attributes from entry replies
Date: Fri, 15 May 2026 17:39:53 -0700
Message-ID: <20260516004004.1455526-11-joannelkoong@gmail.com>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260516004004.1455526-1-joannelkoong@gmail.com>
References: <20260516004004.1455526-1-joannelkoong@gmail.com>
Precedence: bulk
X-Mailing-List: linux-unionfs@vger.kernel.org
List-Id: <linux-unionfs.vger.kernel.org>
List-Subscribe: <mailto:linux-unionfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-unionfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Add an arg for a struct fuse_statx pointer to fuse_iget() and pass it
through to fuse_change_attributes_i() so the statx attributes get
persisted in cache.

All existing callers pass in NULL for the arg. This change is in
preparation for a new struct fuse_entry2_out outarg which will contain
filled out statx information from the server returned on
LOOKUP/MKDIR/MKNOD/etc requests.

Reviewed-by: Amir Goldstein <amir73il@gmail.com>
Signed-off-by: Joanne Koong <joannelkoong@gmail.com>
---
 fs/fuse/dir.c     |  6 +++---
 fs/fuse/fuse_i.h  |  7 +++----
 fs/fuse/inode.c   | 12 ++++++------
 fs/fuse/readdir.c |  2 +-
 4 files changed, 13 insertions(+), 14 deletions(-)

diff --git a/fs/fuse/dir.c b/fs/fuse/dir.c
index 9a8e525f4d2b..7d3c9878b833 100644
--- a/fs/fuse/dir.c
+++ b/fs/fuse/dir.c
@@ -590,7 +590,7 @@ int fuse_lookup_name(struct super_block *sb, u64 nodeid, const struct qstr *name
 	}
 
 	*inode = fuse_iget(sb, outarg->nodeid, outarg->generation,
-			   &outarg->attr, ATTR_TIMEOUT(outarg),
+			   &outarg->attr, NULL, ATTR_TIMEOUT(outarg),
 			   attr_version, evict_ctr);
 	err = -ENOMEM;
 	if (!*inode) {
@@ -890,7 +890,7 @@ static int fuse_create_open(struct mnt_idmap *idmap, struct inode *dir,
 	ff->nodeid = outentry.nodeid;
 	ff->open_flags = outopenp->open_flags;
 	inode = fuse_iget(dir->i_sb, outentry.nodeid, outentry.generation,
-			  &outentry.attr, ATTR_TIMEOUT(&outentry), 0, 0);
+			  &outentry.attr, NULL, ATTR_TIMEOUT(&outentry), 0, 0);
 	if (!inode) {
 		flags &= ~(O_CREAT | O_EXCL | O_TRUNC);
 		fuse_sync_release(NULL, ff, flags, false);
@@ -1017,7 +1017,7 @@ static struct dentry *create_new_entry(struct mnt_idmap *idmap, struct fuse_moun
 		goto out_put_forget_req;
 
 	inode = fuse_iget(dir->i_sb, outarg.nodeid, outarg.generation,
-			  &outarg.attr, ATTR_TIMEOUT(&outarg), 0, 0);
+			  &outarg.attr, NULL, ATTR_TIMEOUT(&outarg), 0, 0);
 	if (!inode) {
 		fuse_chan_queue_forget(fm->fc->chan, forget, outarg.nodeid, 1);
 		return ERR_PTR(-ENOMEM);
diff --git a/fs/fuse/fuse_i.h b/fs/fuse/fuse_i.h
index a1034533ce60..1f2c849ea4e3 100644
--- a/fs/fuse/fuse_i.h
+++ b/fs/fuse/fuse_i.h
@@ -912,10 +912,9 @@ extern const struct dentry_operations fuse_dentry_operations;
 /*
  * Get a filled in inode
  */
-struct inode *fuse_iget(struct super_block *sb, u64 nodeid,
-			int generation, struct fuse_attr *attr,
-			u64 attr_valid, u64 attr_version,
-			u64 evict_ctr);
+struct inode *fuse_iget(struct super_block *sb, u64 nodeid, int generation,
+			struct fuse_attr *attr, struct fuse_statx *sx,
+			u64 attr_valid, u64 attr_version, u64 evict_ctr);
 
 int fuse_lookup_name(struct super_block *sb, u64 nodeid, const struct qstr *name,
 		     struct fuse_entry_out *outarg, struct inode **inode);
diff --git a/fs/fuse/inode.c b/fs/fuse/inode.c
index 9e9c20e846e7..8757c01e3bb2 100644
--- a/fs/fuse/inode.c
+++ b/fs/fuse/inode.c
@@ -457,8 +457,8 @@ static int fuse_inode_set(struct inode *inode, void *_nodeidp)
 
 struct inode *fuse_iget(struct super_block *sb, u64 nodeid,
 			int generation, struct fuse_attr *attr,
-			u64 attr_valid, u64 attr_version,
-			u64 evict_ctr)
+			struct fuse_statx *sx, u64 attr_valid,
+			u64 attr_version, u64 evict_ctr)
 {
 	struct inode *inode;
 	struct fuse_inode *fi;
@@ -520,7 +520,7 @@ struct inode *fuse_iget(struct super_block *sb, u64 nodeid,
 	fi->nlookup++;
 	spin_unlock(&fi->lock);
 done:
-	fuse_change_attributes_i(inode, attr, NULL, attr_valid, attr_version,
+	fuse_change_attributes_i(inode, attr, sx, attr_valid, attr_version,
 				 evict_ctr);
 	if (is_new_inode)
 		unlock_new_inode(inode);
@@ -1049,7 +1049,7 @@ static struct inode *fuse_get_root_inode(struct super_block *sb, unsigned int mo
 	attr.mode = mode;
 	attr.ino = FUSE_ROOT_ID;
 	attr.nlink = 1;
-	return fuse_iget(sb, FUSE_ROOT_ID, 0, &attr, 0, 0, 0);
+	return fuse_iget(sb, FUSE_ROOT_ID, 0, &attr, NULL, 0, 0, 0);
 }
 
 struct fuse_inode_handle {
@@ -1652,8 +1652,8 @@ static int fuse_fill_super_submount(struct super_block *sb,
 		return -ENOMEM;
 
 	fuse_fill_attr_from_inode(&root_attr, parent_fi);
-	root = fuse_iget(sb, parent_fi->nodeid, 0, &root_attr, 0, 0,
-			 fuse_get_evict_ctr(fm->fc));
+	root = fuse_iget(sb, parent_fi->nodeid, 0, &root_attr, NULL, 0,
+			 0, fuse_get_evict_ctr(fm->fc));
 	/*
 	 * This inode is just a duplicate, so it is not looked up and
 	 * its nlookup should not be incremented.  fuse_iget() does
diff --git a/fs/fuse/readdir.c b/fs/fuse/readdir.c
index 49226f022339..0dcb2d75d50f 100644
--- a/fs/fuse/readdir.c
+++ b/fs/fuse/readdir.c
@@ -234,7 +234,7 @@ static int fuse_direntplus_link(struct file *file,
 		 */
 	} else {
 		inode = fuse_iget(dir->i_sb, o->nodeid, o->generation,
-				  &o->attr, ATTR_TIMEOUT(o),
+				  &o->attr, NULL, ATTR_TIMEOUT(o),
 				  attr_version, evict_ctr);
 		if (!inode)
 			inode = ERR_PTR(-ENOMEM);
-- 
2.52.0

