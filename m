Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793282439;
	b=YE7E61BGpUhxlB56oXz2FB39EUtUkLkldPEooj6iQkYf5YkvdklKxzLNuht5cITWKrHA
	 v85dgmHbcnd2gIbW/L4QorTHRcGlgsS2njxBFleMM8Zly9XIaCyPs76M2T7Fu4e65jMdk
	 ks4GwYADELp3v3XPO+CoJSuR1GaHSxg0uBkupJZvbFylOGJl5sIV1tvX1OgGpYMRw+RRZ
	 FILzBxmier+2REd01RxEi/fxVPS4MSKNgYhqcVDMOzRaeazUoRvwMY80uXcXs0RvumyDw
	 YpZxMJ4z9uaUyyqzkllUmGY0SloC+16tTQ2WoRFwH57Ry/b3wDbVI8/T+UqcsXA3yrg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793282439;
	h=Received:DKIM-Signature:From:Date:Subject:MIME-Version:Content-Type:
	 Content-Transfer-Encoding:Message-Id:References:In-Reply-To:To:Cc:
	 X-Mailer:X-Developer-Signature:X-Developer-Key;
	bh=kAyDrYE7RpTtFPTxBrE2K3IqpTZFf/hH7lRkMaYR9bA=;
	b=m6Bfsf1dSZQv3x12y968M8LdAe4ZZ8whyBFfeC2nm7UGOfCIzHUT45XTeAhljgDEKLem
	 GAYrgBMhbBxfn1qDBCaYNv30ETDEt+zC0Ip3GEAE3gIiHncGe4Et92cn+Vg2JCq66Qhuh
	 HoXZyB4mrYCGwymoTC97kNCn94iv/38eLTRyZcq1FCpTveac9qOYGlrbFAQ/UPzocc6zQ
	 2ktTJUiOIuDvuAIZtQIlLPC86zdg1cluHZHc6OOTRKAm4nH/tEjeYEKgAwoXab5iK26oN
	 5u6DBVkksxxOurSp1ztLEjKy2ieYZkrsmRB/f2MhyUARSsYVU2TC/qR3ka/7MKYVU4A==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=FmYD9GEE;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4ECC8606A327;
	Thu, 29 Oct 2026 14:00:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=FmYD9GEE
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 50E461F031E3;
	Thu, 29 Oct 2026 14:00:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793282438;
	bh=kAyDrYE7RpTtFPTxBrE2K3IqpTZFf/hH7lRkMaYR9bA=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=FmYD9GEE91U3m6PcHJMIbwcegIRvXzpYrRAkemw+g3sbvlivsgsmFOVm/IfGh7PIO
	 tYA+fDF20wIZAlDVUfKTJ0lOaFiIkKWNVPLyGplxy9FO9lAEHGgdQpa9aAkWwQHAfb
	 Dn2iXHUaqRjpoZyaXlj2YAM/fl9Tn8lsR5e3pU59WoG8KLkWkb8iBM2v8581Q5cNVn
	 rz4UddH0retdizlkrKj5DN92iKV3sJ3czuN8wK8tvX7g5G/LpOw8/8HZJwVwykftYH
	 JZUkUsq/7T1h/Jiutf55DL+HevlAB7yKJXxWA1eYfshA3EQ/n/y8ZsO+ws2fJp7v21
	 S3KI+ZN34Oiew==
From: Christian Brauner <brauner@kernel.org>
Date: Thu, 29 Oct 2026 15:00:21 +0100
Subject: [PATCH 2/3] backing-file: enforce append-only and immutable
 backing inodes
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
Message-Id: <20261029-work-fs-ai-fixes-v1-2-88f22792f6f7@kernel.org>
References: <20261029-work-fs-ai-fixes-v1-0-88f22792f6f7@kernel.org>
In-Reply-To: <20261029-work-fs-ai-fixes-v1-0-88f22792f6f7@kernel.org>
To: linux-fsdevel@vger.kernel.org
Cc: Alexander Viro <viro@zeniv.linux.org.uk>, Jan Kara <jack@suse.cz>, 
 Chris Mason <mason@kernel.org>, Josef Bacik <josef@toxicpanda.com>, 
 Amir Goldstein <amir73il@gmail.com>, Jens Axboe <axboe@kernel.dk>, 
 linux-aio@kvack.org, linux-unionfs@vger.kernel.org, 
 "Christian Brauner (Amutable)" <brauner@kernel.org>, stable@vger.kernel.org
X-Mailer: b4 0.17-dev-ce4c1
X-Developer-Signature: v=1; a=openpgp-sha256; l=4871; i=brauner@kernel.org;
 h=from:subject:message-id; bh=tdC6ezyjnTK85c+LCoyxgsZbIDknoZuzgAVAd6bTWfY=;
 b=owGbwMvMwCU28Zj0gdSKO4sYT6slMWQ9DqyeLbJ+6tvviTq3azkDq1PWzHiun218q+E0f+mh7
 LOn90x43VHKwiDGxSArpsji0G4SLrecp2KzUaYGzBxWJpAhDFycAjCRidyMDDPrZNZZMPxXWfel
 ZaO48531mobrfbawlV3dvHPGjj0dHxsY/vuwr1vzfbG63NGk2Qct4zjTHZ5yyE/Tk5s5VTLq1+L
 gDQwA
X-Developer-Key: i=brauner@kernel.org; a=openpgp;
 fpr=4880B8C9BD0E5106FC070F4F7B3C391EFEA93624

FUSE passthrough opens the backing file anew whenever the FUSE file is
opened. fuse_passthrough_open() passes the flags of that open to
backing_file_open() which opens the backing file with vfs_open() and the
credentials of the server. But vfs_open() doesn't go through may_open().
So the backing inode is never checked for S_APPEND and S_IMMUTABLE. The
checks that did run were done on the FUSE inode and that one never has
either flag.

So anyone who may open the FUSE file for writing can overwrite an
append-only backing file anywhere or write to an immutable one. The
server only has to register the file and a read-only or even an O_PATH
file descriptor is enough for that. Registering requires CAP_SYS_ADMIN
but the writer can be any user that the server lets open the file.

The FUSE inode is checked instead of the backing inode in a few more
places:

- do_mmap() refuses a shared mapping of an append-only file that was
  opened for writing. A FUSE file opened with O_RDWR | O_APPEND passes
  the open check and can then be mapped shared and written to at any
  offset.

- fcntl(F_SETFL) and RWF_NOAPPEND refuse to take append mode away from a
  file on an append-only inode. On the FUSE file both succeed. A
  synchronous write still appends because the backing file was opened
  with O_APPEND. But an asynchronous write is submitted with the flags
  of the user's kiocb and lands at the given offset.

Do the checks on the backing inode. backing_file_open() refuses to open
an immutable inode for writing and an append-only inode for writing
without O_APPEND, just like may_open(). backing_file_mmap() refuses a
shared mapping of an append-only inode, just like do_mmap(). And writes
and splices to a backing file in append mode fail if append mode was
taken away from the user file.

A FUSE file that was opened before the backing file became append-only
can still write anywhere. That's what happens on the native filesystem
as well and the backing file of such a file isn't in append mode. Two
differences remain. F_SETFL succeeds and the next write fails. And FUSE
reports EIO for a refused open because it turns every error from opening
the backing file into EIO.

overlayfs uses the same helpers but it mirrors S_APPEND and S_IMMUTABLE
in its own inode and a chattr through the overlay never sets them on the
upper inode. So for overlayfs this only changes something if the upper
inode is changed behind the overlay's back.

Fixes: 4a90451bbc7f ("fuse: implement open in passthrough mode")
Reported-by: Chris Mason <mason@kernel.org>
Cc: stable@vger.kernel.org # v6.9+
Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>
---
 fs/backing-file.c | 28 ++++++++++++++++++++++++++++
 1 file changed, 28 insertions(+)

diff --git a/fs/backing-file.c b/fs/backing-file.c
index 5614cb7801e1..2424dc38d21a 100644
--- a/fs/backing-file.c
+++ b/fs/backing-file.c
@@ -36,9 +36,21 @@ struct file *backing_file_open(const struct file *user_file, int flags,
 			       const struct cred *cred)
 {
 	const struct path *user_path = file_user_path(user_file);
+	struct inode *real_inode = d_inode(real_path->dentry);
 	struct file *f;
 	int error;
 
+	/*
+	 * may_open() checked the inode of the user file, which need not carry
+	 * S_APPEND and S_IMMUTABLE of the backing inode.
+	 */
+	if ((flags & O_ACCMODE) != O_RDONLY) {
+		if (IS_IMMUTABLE(real_inode))
+			return ERR_PTR(-EPERM);
+		if (IS_APPEND(real_inode) && !(flags & O_APPEND))
+			return ERR_PTR(-EPERM);
+	}
+
 	f = alloc_empty_backing_file(flags, cred, user_file);
 	if (IS_ERR(f))
 		return f;
@@ -263,6 +275,14 @@ ssize_t backing_file_write_iter(struct file *file, struct iov_iter *iter,
 	if (!iov_iter_count(iter))
 		return 0;
 
+	/*
+	 * F_SETFL and RWF_NOAPPEND can take append mode away from the user
+	 * file. They checked its inode, not the backing one.
+	 */
+	if ((file->f_flags & O_APPEND) && !(flags & IOCB_APPEND) &&
+	    IS_APPEND(file_inode(file)))
+		return -EPERM;
+
 	ret = file_remove_privs(iocb->ki_filp);
 	if (ret)
 		return ret;
@@ -309,6 +329,10 @@ ssize_t backing_file_splice_write(struct pipe_inode_info *pipe,
 	if (!out->f_op->splice_write)
 		return -EINVAL;
 
+	/* splice refuses a user file in append mode, so F_SETFL cleared it */
+	if ((out->f_flags & O_APPEND) && IS_APPEND(file_inode(out)))
+		return -EPERM;
+
 	ret = file_remove_privs(iocb->ki_filp);
 	if (ret)
 		return ret;
@@ -338,6 +362,10 @@ int backing_file_mmap(struct file *file, struct vm_area_struct *vma,
 	if (!can_mmap_file(file))
 		return -ENODEV;
 
+	/* do_mmap() checked the inode of the user file */
+	if ((vma->vm_flags & VM_SHARED) && IS_APPEND(file_inode(file)))
+		return -EACCES;
+
 	vma_set_file(vma, file);
 
 	scoped_with_creds(ctx->cred) {

-- 
2.53.0

