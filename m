Return-Path: <linux-unionfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8C9A3C001B0
	for <linux-unionfs@archiver.kernel.org>; Mon, 14 Aug 2023 14:06:24 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231322AbjHNOFy (ORCPT
        <rfc822;linux-unionfs@archiver.kernel.org>);
        Mon, 14 Aug 2023 10:05:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59768 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231532AbjHNOF1 (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Mon, 14 Aug 2023 10:05:27 -0400
Received: from mail-wr1-x42b.google.com (mail-wr1-x42b.google.com [IPv6:2a00:1450:4864:20::42b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 56FF8E6D
        for <linux-unionfs@vger.kernel.org>; Mon, 14 Aug 2023 07:05:26 -0700 (PDT)
Received: by mail-wr1-x42b.google.com with SMTP id ffacd0b85a97d-31977ace1c8so882970f8f.1
        for <linux-unionfs@vger.kernel.org>; Mon, 14 Aug 2023 07:05:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1692021925; x=1692626725;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=z3vxaar6S0TG0ma9dQEds7wPD0UBbFdbug+vtfS7Zt8=;
        b=Tj00b2whFNbBeSkc4eBYllsaumWCCRyCNBMs9kh0NS3XBmfc6/PZwL4bJhJ+9N7+F9
         r9/CCGymff2E5CCduLscoZGOlODwsfbGdHHUSs1hd77HRBUN1vrrKHtz1G0dWwQ7Cm/C
         vAEspUlAT5QwdJWXKmqcGdOt8abr8gdvb25Yty/74RewYsTxAnNxO8q5C6LSZDgeoE83
         +YWUIkxnBamEYsmygUR9YLBK1l2nPEGQNS8FykpQTH4qNNVB1P0VIkBYp6YfIZhzswcN
         fMasdYxUAaaT3F/OsDa6ZyGMpDyFWtWBjmVmHAGLTYUGmSn/LKynbJ35ku2+VjKjpvlc
         p1Ug==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1692021925; x=1692626725;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=z3vxaar6S0TG0ma9dQEds7wPD0UBbFdbug+vtfS7Zt8=;
        b=M/la5QZS04ose3YzKzl1Y61VVMedhU7XWVRfxykKur2RWnpfC2SF8Z2uJUtF9ZysMj
         fAKvoSMBXQo4u7PyGTwT+1H60MVGkh8jHANTd4a+7hxZENOghomBvL2YcKOG1oR1+jmS
         V/gMMnJmJrAhsqgtSc8PHrLOuEyWkUUMxZb16t44umyTY1V8aiF8fRcqlsnpCV61/Z0m
         jVq1SRhl05PliuvByswl/LmXgxccvBBQikaWOagCy+PqL6ihhV2TNcpes9v5pEv4mloh
         jaLIN6eNl4bRCJkvCgr8jInoep/Lax7EqKEvV6STjol0SMbi52OqpAzZ7oMC/xuqMOqK
         tVuA==
X-Gm-Message-State: AOJu0Yx2EdWBQ7su9fJl/LiaCSBoPYygldpJbnKHJ8BoQ7uqRxV8RFHL
        NcDGnYwbaE9zEjZ2wKd1+oxV8TNEc/8=
X-Google-Smtp-Source: AGHT+IFUjAAHrJnCqNJjH+pUpC6tLuCEU9NYhb+y1wZKlbrK9E79KGtK0jAw1+ErXzRgJIAGukvPUg==
X-Received: by 2002:adf:e44f:0:b0:319:522a:17f5 with SMTP id t15-20020adfe44f000000b00319522a17f5mr7168112wrm.10.1692021924594;
        Mon, 14 Aug 2023 07:05:24 -0700 (PDT)
Received: from amir-ThinkPad-T480.ctera.local (bzq-166-168-31-246.red.bezeqint.net. [31.168.166.246])
        by smtp.gmail.com with ESMTPSA id j4-20020adfff84000000b003142ea7a661sm14609901wrr.21.2023.08.14.07.05.23
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 14 Aug 2023 07:05:24 -0700 (PDT)
From:   Amir Goldstein <amir73il@gmail.com>
To:     Miklos Szeredi <miklos@szeredi.hu>
Cc:     Jan Kara <jack@suse.cz>, linux-unionfs@vger.kernel.org
Subject: [PATCH v2 2/3] ovl: do not open/llseek lower file with upper sb_writers held
Date:   Mon, 14 Aug 2023 17:05:17 +0300
Message-Id: <20230814140518.763674-3-amir73il@gmail.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20230814140518.763674-1-amir73il@gmail.com>
References: <20230814140518.763674-1-amir73il@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-unionfs.vger.kernel.org>
X-Mailing-List: linux-unionfs@vger.kernel.org

overlayfs file open (ovl_maybe_lookup_lowerdata) and overlay file llseek
take the ovl_inode_lock, without holding upper sb_writers.

In case of nested lower overlay that uses same upper fs as this overlay,
lockdep will warn about (possibly false positive) circular lock
dependency when doing open/llseek of lower ovl file during copy up with
our upper sb_writers held, because the locking ordering seems reverse to
the locking order in ovl_copy_up_start():

- lower ovl_inode_lock
- upper sb_writers

Take upper sb_writers only when we actually need it, so we won't hold it
during lower file open and lower file llseek to avoid the lockdep warning.

Minimizing the scope of ovl_want_write() during copy up is also needed
for fixing other possible deadlocks by following patches.

Signed-off-by: Amir Goldstein <amir73il@gmail.com>
---
 fs/overlayfs/copy_up.c | 117 +++++++++++++++++++++++++++++++----------
 1 file changed, 88 insertions(+), 29 deletions(-)

diff --git a/fs/overlayfs/copy_up.c b/fs/overlayfs/copy_up.c
index c998dab440f8..f2a31ff790fb 100644
--- a/fs/overlayfs/copy_up.c
+++ b/fs/overlayfs/copy_up.c
@@ -251,8 +251,13 @@ static int ovl_copy_up_file(struct ovl_fs *ofs, struct dentry *dentry,
 	if (IS_ERR(old_file))
 		return PTR_ERR(old_file);
 
+	error = ovl_want_write(dentry);
+	if (error)
+		goto out_fput;
+
 	/* Try to use clone_file_range to clone up within the same fs */
 	cloned = do_clone_file_range(old_file, 0, new_file, 0, len, 0);
+	ovl_drop_write(dentry);
 	if (cloned == len)
 		goto out_fput;
 	/* Couldn't clone, so now we try to copy the data */
@@ -287,8 +292,12 @@ static int ovl_copy_up_file(struct ovl_fs *ofs, struct dentry *dentry,
 		 * it may not recognize all kind of holes and sometimes
 		 * only skips partial of hole area. However, it will be
 		 * enough for most of the use cases.
+		 *
+		 * We do not hold upper sb_writers throughout the loop to avert
+		 * lockdep warning with llseek of lower file in nested overlay:
+		 * - upper sb_writers
+		 * -- lower ovl_inode_lock (ovl_llseek)
 		 */
-
 		if (skip_hole && data_pos < old_pos) {
 			data_pos = vfs_llseek(old_file, old_pos, SEEK_DATA);
 			if (data_pos > old_pos) {
@@ -303,9 +312,14 @@ static int ovl_copy_up_file(struct ovl_fs *ofs, struct dentry *dentry,
 			}
 		}
 
+		error = ovl_want_write(dentry);
+		if (error)
+			break;
+
 		bytes = do_splice_direct(old_file, &old_pos,
 					 new_file, &new_pos,
 					 this_len, SPLICE_F_MOVE);
+		ovl_drop_write(dentry);
 		if (bytes <= 0) {
 			error = bytes;
 			break;
@@ -555,14 +569,18 @@ static int ovl_link_up(struct ovl_copy_up_ctx *c)
 	struct ovl_fs *ofs = OVL_FS(c->dentry->d_sb);
 	struct inode *udir = d_inode(upperdir);
 
+	err = ovl_want_write(c->dentry);
+	if (err)
+		return err;
+
 	/* Mark parent "impure" because it may now contain non-pure upper */
 	err = ovl_set_impure(c->parent, upperdir);
 	if (err)
-		return err;
+		goto out_drop_write;
 
 	err = ovl_set_nlink_lower(c->dentry);
 	if (err)
-		return err;
+		goto out_drop_write;
 
 	inode_lock_nested(udir, I_MUTEX_PARENT);
 	upper = ovl_lookup_upper(ofs, c->dentry->d_name.name, upperdir,
@@ -581,10 +599,12 @@ static int ovl_link_up(struct ovl_copy_up_ctx *c)
 	}
 	inode_unlock(udir);
 	if (err)
-		return err;
+		goto out_drop_write;
 
 	err = ovl_set_nlink_upper(c->dentry);
 
+out_drop_write:
+	ovl_drop_write(c->dentry);
 	return err;
 }
 
@@ -710,7 +730,7 @@ static int ovl_copy_up_workdir(struct ovl_copy_up_ctx *c)
 	struct path path = { .mnt = ovl_upper_mnt(ofs) };
 	struct dentry *temp, *upper;
 	struct ovl_cu_creds cc;
-	int err;
+	int err, err2;
 	struct ovl_cattr cattr = {
 		/* Can't properly set mode on creation because of the umask */
 		.mode = c->stat.mode & S_IFMT,
@@ -718,21 +738,22 @@ static int ovl_copy_up_workdir(struct ovl_copy_up_ctx *c)
 		.link = c->link
 	};
 
-	/* workdir and destdir could be the same when copying up to indexdir */
-	err = -EIO;
-	if (lock_rename(c->workdir, c->destdir) != NULL)
-		goto unlock;
-
 	err = ovl_prep_cu_creds(c->dentry, &cc);
 	if (err)
-		goto unlock;
+		return err;
 
-	temp = ovl_create_temp(ofs, c->workdir, &cattr);
+	err = ovl_want_write(c->dentry);
+	if (!err) {
+		inode_lock(d_inode(c->workdir));
+		temp = ovl_create_temp(ofs, c->workdir, &cattr);
+		inode_unlock(d_inode(c->workdir));
+		ovl_drop_write(c->dentry);
+		if (IS_ERR(temp))
+			err = PTR_ERR(temp);
+	}
 	ovl_revert_cu_creds(&cc);
-
-	err = PTR_ERR(temp);
-	if (IS_ERR(temp))
-		goto unlock;
+	if (err)
+		return err;
 
 	/*
 	 * Copy up data first and then xattrs. Writing data after
@@ -740,6 +761,21 @@ static int ovl_copy_up_workdir(struct ovl_copy_up_ctx *c)
 	 */
 	path.dentry = temp;
 	err = ovl_copy_up_data(c, &path);
+	/*
+	 * Request write access, lock workdir and destdir and make sure that
+	 * temp wasn't moved before copy up completion or cleanup.
+	 * workdir and destdir could be the same when copying up to indexdir.
+	 */
+	err2 = ovl_want_write(c->dentry);
+	if (err2)
+		return err ?: err2;
+
+	if (lock_rename(c->workdir, c->destdir) != NULL ||
+	    temp->d_parent != c->workdir) {
+		err = err ?: -EIO;
+		goto unlock;
+	}
+
 	if (err)
 		goto cleanup;
 
@@ -778,6 +814,7 @@ static int ovl_copy_up_workdir(struct ovl_copy_up_ctx *c)
 		ovl_set_flag(OVL_WHITEOUTS, inode);
 unlock:
 	unlock_rename(c->workdir, c->destdir);
+	ovl_drop_write(c->dentry);
 
 	return err;
 
@@ -801,11 +838,16 @@ static int ovl_copy_up_tmpfile(struct ovl_copy_up_ctx *c)
 	if (err)
 		return err;
 
-	tmpfile = ovl_do_tmpfile(ofs, c->workdir, c->stat.mode);
+	err = ovl_want_write(c->dentry);
+	if (!err) {
+		tmpfile = ovl_do_tmpfile(ofs, c->workdir, c->stat.mode);
+		ovl_drop_write(c->dentry);
+		if (IS_ERR(tmpfile))
+			err = PTR_ERR(tmpfile);
+	}
 	ovl_revert_cu_creds(&cc);
-
-	if (IS_ERR(tmpfile))
-		return PTR_ERR(tmpfile);
+	if (err)
+		return err;
 
 	temp = tmpfile->f_path.dentry;
 	if (!c->metacopy && c->stat.size) {
@@ -814,10 +856,14 @@ static int ovl_copy_up_tmpfile(struct ovl_copy_up_ctx *c)
 			goto out_fput;
 	}
 
-	err = ovl_copy_up_metadata(c, temp);
+	err = ovl_want_write(c->dentry);
 	if (err)
 		goto out_fput;
 
+	err = ovl_copy_up_metadata(c, temp);
+	if (err)
+		goto out_drop_write;
+
 	inode_lock_nested(udir, I_MUTEX_PARENT);
 
 	upper = ovl_lookup_upper(ofs, c->destname.name, c->destdir,
@@ -830,7 +876,7 @@ static int ovl_copy_up_tmpfile(struct ovl_copy_up_ctx *c)
 	inode_unlock(udir);
 
 	if (err)
-		goto out_fput;
+		goto out_drop_write;
 
 	if (c->metacopy_digest)
 		ovl_set_flag(OVL_HAS_DIGEST, d_inode(c->dentry));
@@ -842,6 +888,8 @@ static int ovl_copy_up_tmpfile(struct ovl_copy_up_ctx *c)
 		ovl_set_upperdata(d_inode(c->dentry));
 	ovl_inode_update(d_inode(c->dentry), dget(temp));
 
+out_drop_write:
+	ovl_drop_write(c->dentry);
 out_fput:
 	fput(tmpfile);
 	return err;
@@ -892,7 +940,12 @@ static int ovl_do_copy_up(struct ovl_copy_up_ctx *c)
 		 * Mark parent "impure" because it may now contain non-pure
 		 * upper
 		 */
+		err = ovl_want_write(c->dentry);
+		if (err)
+			return err;
+
 		err = ovl_set_impure(c->parent, c->destdir);
+		ovl_drop_write(c->dentry);
 		if (err)
 			return err;
 	}
@@ -908,6 +961,10 @@ static int ovl_do_copy_up(struct ovl_copy_up_ctx *c)
 	if (c->indexed)
 		ovl_set_flag(OVL_INDEX, d_inode(c->dentry));
 
+	err = ovl_want_write(c->dentry);
+	if (err)
+		goto out;
+
 	if (to_index) {
 		/* Initialize nlink for copy up of disconnected dentry */
 		err = ovl_set_nlink_upper(c->dentry);
@@ -923,6 +980,7 @@ static int ovl_do_copy_up(struct ovl_copy_up_ctx *c)
 		ovl_dentry_update_reval(c->dentry, ovl_dentry_upper(c->dentry));
 	}
 
+	ovl_drop_write(c->dentry);
 out:
 	if (to_index)
 		kfree(c->destname.name);
@@ -1006,6 +1064,10 @@ static int ovl_copy_up_meta_inode_data(struct ovl_copy_up_ctx *c)
 	if (err)
 		goto out_free;
 
+	err = ovl_want_write(c->dentry);
+	if (err)
+		goto out_free;
+
 	/*
 	 * Writing to upper file will clear security.capability xattr. We
 	 * don't want that to happen for normal copy-up operation.
@@ -1014,17 +1076,19 @@ static int ovl_copy_up_meta_inode_data(struct ovl_copy_up_ctx *c)
 		err = ovl_do_setxattr(ofs, upperpath.dentry, XATTR_NAME_CAPS,
 				      capability, cap_size, 0);
 		if (err)
-			goto out_free;
+			goto out_drop_write;
 	}
 
 
 	err = ovl_removexattr(ofs, upperpath.dentry, OVL_XATTR_METACOPY);
 	if (err)
-		goto out_free;
+		goto out_drop_write;
 
 	ovl_clear_flag(OVL_HAS_DIGEST, d_inode(c->dentry));
 	ovl_clear_flag(OVL_VERIFIED_DIGEST, d_inode(c->dentry));
 	ovl_set_upperdata(d_inode(c->dentry));
+out_drop_write:
+	ovl_drop_write(c->dentry);
 out_free:
 	kfree(capability);
 out:
@@ -1088,17 +1152,12 @@ static int ovl_copy_up_one(struct dentry *parent, struct dentry *dentry,
 		goto out;
 	}
 
-	err = ovl_want_write(dentry);
-	if (err)
-		goto out;
-
 	if (!ovl_dentry_upper(dentry))
 		err = ovl_do_copy_up(&ctx);
 	if (!err && parent && !ovl_dentry_has_upper_alias(dentry))
 		err = ovl_link_up(&ctx);
 	if (!err && ovl_dentry_needs_data_copy_up_locked(dentry, flags))
 		err = ovl_copy_up_meta_inode_data(&ctx);
-	ovl_drop_write(dentry);
 	ovl_copy_up_end(dentry);
 out:
 	do_delayed_call(&done);
-- 
2.34.1

