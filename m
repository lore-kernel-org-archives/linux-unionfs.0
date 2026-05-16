Received: from mail-yx1-f52.google.com (mail-yx1-f52.google.com [74.125.224.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7BAE92E414
	for <linux-unionfs@vger.kernel.org>; Sat, 16 May 2026 00:52:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.125.224.52
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778892775; cv=none; b=f3eyfGrBbZNlp3SoeHmdIeb2Xd91fT47PS9MCcCfmhKe/Ho7rRZWw9lWczjuT8XX7rFm84yX/Gp3EE6564W1jCIg73TErTb72PWUAzta8neIOIAM1KL1XaibtSh6tcKp2uNiSgI4xADtnqlQShiJquBesqEjwHqvaviD/s3JxXk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778892775; c=relaxed/simple;
	bh=A4VZ8s0O9JOoQGYWdt1DG7u85Nb5xzy3TUQ7X6PhLd4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=nHXL7Xp1iR/DKb0hPPmVikN+0PuJMPHIEAjBguRAUKcW0/J5VBelEWuHAnPvJFiVCTaV7htz9qW+9W5pmfinrvgHksu4MCjUjcQAfKFIrwzsNoNI3rvuh3PVKwQIuRp1ZCzRQ6ov/qXHAXI9Y6R+xQQdSTdt+lnSMbiwk0pppSs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=PSLtafly; arc=none smtp.client-ip=74.125.224.52
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="PSLtafly"
Received: by mail-yx1-f52.google.com with SMTP id 956f58d0204a3-65c3ea2ebf7so1030969d50.0
        for <linux-unionfs@vger.kernel.org>; Fri, 15 May 2026 17:52:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1778892770; x=1779497570; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=HIHa5DTBrFVKAuYTCoVTJzIz4u/zcSZ9wJ/ywTEStD8=;
        b=PSLtaflyrw8ORqmt10V5KzwWo82LgxIeCZysv3tKmmZ9TDnGeZumN/MZCyucXI+ZLZ
         U/EItyPRVKkx7yUGu+FUnDUDFoi5B+hZ6B48/POxKA50YjbfEw8Zh3sL0dJq/POlB7Ho
         m5qgbrB6Y1INfJqHvV/mYRgOU/TpbcPRmsvuHOXNXiiaxCUg1pASRcRf06LrDzIlCx1A
         iuM6nj6tvyGEru5SYA37HkDLNlmC35WAfkM7WqerUG1xPcsHzlE7ft6hFEvyPb7Yaku+
         dNgp8vyAmJnIAfZ7P3mRyjqkU9EFGcduxjFYpA4amsFWsqPgwG4iY1p1znhE4uv0FKp+
         3tug==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1778892770; x=1779497570;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=HIHa5DTBrFVKAuYTCoVTJzIz4u/zcSZ9wJ/ywTEStD8=;
        b=DIAgljTHnw9vCLerQ2X675+qMkqNztVt1MMKHgtUc8EctwgXxpX711VOy060Sy6Nhk
         U9/W4zrinIRHRI9aaK1W87qmSM+sMa9FAX5Qz+lUrFR4rOyYe+0h30EuTrT4h8/IGPKL
         Ty5SsEb2kxvEiH1ctU28kjxuvQISXgSPovf0vgQ92mQ8SQWCVxRZfPQVHX81Egxo+4QT
         8vwKhz4ln9UtHbgTKSMYzRADwxbhtcxzpShbTPPTnbtTTQAvDS+TzQ4WVhAUhlYZUsYP
         25ArZxYX1fug+7hbNmTSmEx0ezXbOKEqhQrr51Z58UvsUqUsyyaQKNeq3z71brBYAC9F
         mmLA==
X-Forwarded-Encrypted: i=1; AFNElJ/ziuEHblRWM7/C23GPN2yseWxG5+irNIf2h9cQNoApATOuwlRfJBhB/YyZ7A5ROv6nHAEsy1E+RcBYTMWZ@vger.kernel.org
X-Gm-Message-State: AOJu0YzM1sOtyhcCakT18+1GxH0RISgu5flK+3ymcWJX7zlCsgfDbrtU
	cKn8tFZOvZlVBLmqyy5ZWeXFfMKEhdY3kBi4xEuG5HnSt9LeFWUrJjihaK0rPoVX
X-Gm-Gg: Acq92OHZ9WiMUUKU6RiEmDknV3DQcZLbuCvBsCTxJ3eZ83+R21OTnTUJg0pV8gAIuOb
	G4HI/YCbWfoCurwkhLxjd5X8nh6y+r+gslIF4M7KnLV+dpNCz+o8gBLSUk8EPnltGAullwDY6Gb
	zotS/swdsGcXai2u8+c0twojPriQW0Gzoq8TnndW6/O1EC0TBIxZbD2u/Il943CwOIUcGbKYNzI
	zL/x0w7pyFFsd1E21OsYllxatmhVCeBoqLzDtm42TzAJkZcW+9cpdUQoYOTK6dxEcHPSNp9acTm
	eSTuzcq7ArqYKo4OPf3Nr4F4EdLX9NolD3/xvgNCy+p5lItpVvRfW1QYoustqAHW2B72Z05jJkP
	lwg8MCX8ilOi+Ad2QqFAmwtD8i+oieqxnXbNp9JTg1KdeD9C2HbA50uEUZSEZnrrbvuZ1bVwgBx
	YM5ieo12FUqWSWY5dtZ/M2LFp3uagpwg0=
X-Received: by 2002:a05:690e:14c4:b0:65c:5e34:7343 with SMTP id 956f58d0204a3-65e2283524fmr6390550d50.44.1778892770438;
        Fri, 15 May 2026 17:52:50 -0700 (PDT)
Received: from localhost ([2a03:2880:f806:16::])
        by smtp.gmail.com with ESMTPSA id 956f58d0204a3-65e3aa93cdasm45020d50.21.2026.05.15.17.52.49
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 15 May 2026 17:52:49 -0700 (PDT)
From: Joanne Koong <joannelkoong@gmail.com>
To: amir73il@gmail.com,
	miklos@szeredi.hu
Cc: fuse-devel@lists.linux.dev,
	linux-unionfs@vger.kernel.org
Subject: [PATCH v2 13/21] fuse: add passthrough lookup
Date: Fri, 15 May 2026 17:39:56 -0700
Message-ID: <20260516004004.1455526-14-joannelkoong@gmail.com>
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

Use the new/extended struct fuse_entry2_out for lookups. If a backing id
is set, associate the fuse inode with the backing inode that should be
used for passthrough operations.

If no backing id was set, cache the statx attributes from the reply.

Signed-off-by: Joanne Koong <joannelkoong@gmail.com>
---
 fs/fuse/dir.c | 66 ++++++++++++++++++++++++++++++++++++++++-----------
 1 file changed, 52 insertions(+), 14 deletions(-)

diff --git a/fs/fuse/dir.c b/fs/fuse/dir.c
index b7a9d2b0476a..3a6adae530da 100644
--- a/fs/fuse/dir.c
+++ b/fs/fuse/dir.c
@@ -420,10 +420,10 @@ static void fuse_entry2_to_entry(struct fuse_entry2_out *outarg2,
 	outarg->attr.flags = outarg2->flags;
 }
 
-static __maybe_unused int fuse_process_entry2(struct fuse_conn *fc,
-					      struct fuse_entry2_out *outarg2,
-					      struct fuse_entry_out *outarg,
-					      struct fuse_statx **sxp)
+static int fuse_process_entry2(struct fuse_conn *fc,
+			       struct fuse_entry2_out *outarg2,
+			       struct fuse_entry_out *outarg,
+			       struct fuse_statx **sxp)
 {
 	if (!fuse_use_entry2(fc))
 		return 0;
@@ -469,7 +469,9 @@ static int fuse_dentry_revalidate(struct inode *dir, const struct qstr *name,
 	struct fuse_entry_out outarg;
 	struct fuse_entry2_out outarg2;
 	struct fuse_forget_link *forget;
+	struct fuse_statx *sx = NULL;
 	FUSE_ARGS(args);
+	int backing_id = 0;
 	u64 attr_version;
 	bool need_reval;
 	int ret;
@@ -512,15 +514,27 @@ static int fuse_dentry_revalidate(struct inode *dir, const struct qstr *name,
 
 	fuse_lookup_init(fc, &args, get_node_id(dir), name, &outarg, &outarg2);
 	ret = fuse_simple_request(get_fuse_mount(inode), &args);
+	if (!ret)
+		backing_id = fuse_process_entry2(fc, &outarg2, &outarg, &sx);
 	if (ret || !outarg.nodeid) {
 		kfree(forget);
 		return (ret == -ENOMEM || ret == -EINTR) ? ret : 0;
 	}
 
+	if (backing_id < 0) {
+		ret = backing_id;
+		goto forget;
+	}
+
+	ret = 0;
 	if (outarg.nodeid != get_node_id(inode) ||
-	    !!IS_AUTOMOUNT(inode) != !!(outarg.attr.flags & FUSE_ATTR_SUBMOUNT)) {
-		fuse_chan_queue_forget(fc->chan, forget, outarg.nodeid, 1);
-		return 0;
+	    !!IS_AUTOMOUNT(inode) != !!(outarg.attr.flags & FUSE_ATTR_SUBMOUNT))
+		goto forget;
+
+	if (backing_id) {
+		ret = fuse_inode_set_passthrough(inode, backing_id);
+		if (ret)
+			goto forget;
 	}
 
 	kfree(forget);
@@ -534,10 +548,14 @@ static int fuse_dentry_revalidate(struct inode *dir, const struct qstr *name,
 		return 0;
 
 	forget_all_cached_acls(inode);
-	fuse_change_attributes(inode, &outarg.attr, NULL, ATTR_TIMEOUT(&outarg),
+	fuse_change_attributes(inode, &outarg.attr, sx, ATTR_TIMEOUT(&outarg),
 			       attr_version);
 	fuse_change_entry_timeout(entry, &outarg);
 	return 1;
+
+forget:
+	fuse_chan_queue_forget(fc->chan, forget, outarg.nodeid, 1);
+	return ret;
 }
 
 static int fuse_dentry_init(struct dentry *dentry)
@@ -631,6 +649,8 @@ int fuse_lookup_name(struct super_block *sb, u64 nodeid, const struct qstr *name
 	struct fuse_forget_link *forget;
 	u64 attr_version, evict_ctr;
 	struct fuse_entry2_out outarg2;
+	struct fuse_statx *sx = NULL;
+	int backing_id;
 	int err;
 
 	*inode = NULL;
@@ -649,9 +669,18 @@ int fuse_lookup_name(struct super_block *sb, u64 nodeid, const struct qstr *name
 
 	fuse_lookup_init(fm->fc, &args, nodeid, name, outarg, &outarg2);
 	err = fuse_simple_request(fm, &args);
+	if (err)
+		goto out_put_forget;
+
+	backing_id = fuse_process_entry2(fm->fc, &outarg2, outarg, &sx);
+
 	/* Zero nodeid is same as -ENOENT, but with valid timeout */
-	if (err || !outarg->nodeid)
+	if (!outarg->nodeid)
 		goto out_put_forget;
+	if (backing_id < 0) {
+		err = backing_id;
+		goto out_send_forget;
+	}
 
 	err = -EIO;
 	if (fuse_invalid_attr(&outarg->attr))
@@ -662,19 +691,28 @@ int fuse_lookup_name(struct super_block *sb, u64 nodeid, const struct qstr *name
 	}
 
 	*inode = fuse_iget(sb, outarg->nodeid, outarg->generation,
-			   &outarg->attr, NULL, ATTR_TIMEOUT(outarg),
+			   &outarg->attr, sx, ATTR_TIMEOUT(outarg),
 			   attr_version, evict_ctr);
 	err = -ENOMEM;
-	if (!*inode) {
-		fuse_chan_queue_forget(fm->fc->chan, forget, outarg->nodeid, 1);
-		goto out;
-	}
+	if (!*inode)
+		goto out_send_forget;
+
 	err = 0;
+	if (backing_id) {
+		err = fuse_inode_set_passthrough(*inode, backing_id);
+		if (err) {
+			iput(*inode);
+			*inode = NULL;
+		}
+	}
 
  out_put_forget:
 	kfree(forget);
  out:
 	return err;
+ out_send_forget:
+	fuse_chan_queue_forget(fm->fc->chan, forget, outarg->nodeid, 1);
+	return err;
 }
 
 static struct dentry *fuse_lookup(struct inode *dir, struct dentry *entry,
-- 
2.52.0

