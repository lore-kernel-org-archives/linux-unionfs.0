Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=185.205.69.214
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793090138;
	b=ddOz2s/dRGGLMQCoL3H0gMZe/cAC0EnC/vhSJ2xiZzh+OPwA+N2nRoHfM/kiWcFUN7Lt
	 IhCx3Ia3EdqMRj+gJqIhjgBegqsGHmzO9j3gffXdTAVTl0cVCFyuMBJql6vWIkfhwqLrg
	 qThvFdFM5NTZ6VkvGem06qLUgGLd+NtcOsUBRE5T+7o75RZk/qJLa1R57UWco1fMhi49h
	 s37zCrICtrjwPiP3vMheUsCZCyKnKVWiHyT9GoJ7lu/BBM9555/yynp24ExYRLnoJM89Q
	 K18JvTHdl1rGS/hZysIbUWSPeUM6abQJFh9ptILu2SIlI7Jf+DbvLpf4aQqzWU5PwOQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793090138;
	h=DMARC-Filter:Received:DKIM-Signature:Date:From:To:Cc:Message-ID:
	 Subject:MIME-Version:Content-Type:Content-Transfer-Encoding:
	 Feedback-ID;
	bh=kBQt+F7iOZ8YH6/ApY3K40GDAVQvlXQhLzLdJhXqOno=;
	b=s6Mbu4YmlXBUkhhf28AEsFkxFd2fAEdkuV2A+ykuOz8Akw4kfMqekKKBvNJ/+C0sizWR
	 W74p6sOWnvpQvZAvRA6a9zbJ4h6Md4A/XlgvWXzqNV7ePEfmC552DV+TZqdqizsiMY3Kb
	 pVMNNJbtum+U34XOMxYa+COTfkZq7N8hkJdYPqzYplkEU+yH7hB8Ndzm2QWjslEEGfjbJ
	 2BIl2nYPBgwjFhO47FgC37XmxCZLBho+2edn8/kydJUSXGIBoJb5Nq7DEV/CFpbamHQ5L
	 /PFirL8p4HYbmK8cM15O/N6xgaahrAxgJwq6mYrHs13227Piu3aWfQNqTvlfk6vyQfQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=tuta.io;
	spf=pass smtp.mailfrom=tuta.io;
	dkim=pass header.d=tuta.io header.i=@tuta.io header.a=rsa-sha256 header.s=s1 header.b=FK5y9jUY;
	arc=none smtp.remote-ip=185.205.69.214
Received: from mail.w14.tutanota.de (mail.w14.tutanota.de [185.205.69.214])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5B7D2606A31E
	for <linux-unionfs@vger.kernel.org>; Tue, 27 Oct 2026 08:35:37 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 5B7D2606A31E
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=tuta.io
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=tuta.io
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=tuta.io header.i=@tuta.io header.a=rsa-sha256 header.s=s1 header.b=FK5y9jUY
Received: from tutadb.w10.tutanota.de (w10.api.tuta.com [IPv6:fd:ac::d:10])
	by mail.w14.tutanota.de (Postfix) with ESMTP id CFC8E19D20DEB
	for <linux-unionfs@vger.kernel.org>; Tue, 27 Oct 2026 09:35:35 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; t=1793090135;
	s=s1; d=tuta.io;
	h=From:From:To:To:Subject:Subject:Content-Description:Content-ID:Content-Type:Content-Type:Content-Transfer-Encoding:Content-Transfer-Encoding:Cc:Cc:Date:Date:In-Reply-To:MIME-Version:MIME-Version:Message-ID:Message-ID:Reply-To:References:Sender;
	bh=kBQt+F7iOZ8YH6/ApY3K40GDAVQvlXQhLzLdJhXqOno=;
	b=FK5y9jUYVOPrMWZpC3WSbPfM8+cjaoFF+sIxsDLo9+joCoStxApKCn2HlXLeTBnD
	wojQUFjBRL5GDuVrIsdWbmyGFmt1BCJObPrwbGFTLALAc76By/RK1QkHSQ6CKLipdc/
	BLJowq8ztjb706bqGuAvCrwSwtQ6T0wNiBILn24rFldzB9hyf9sIgT7OEjePKGoG6Z8
	AFgF0c4W5NWLyXUNPtDeyOt7aDkExa5XNrt9gX64S+T37KqJWS0RPOQy1fr2mqAvfsG
	PDb/x9mNpkrmoXKPoOq6nDhr+xeTjp73CqqZFFGuXhKk4xtoICSEODp1B2qshXWQYLW
	D/HlCfGsqw==
Date: Tue, 27 Oct 2026 09:35:35 +0100 (CET)
From: Edvard Conrad <edvard@tuta.io>
To: Miklos Szeredi <miklos@szeredi.hu>, Amir Goldstein <amir73il@gmail.com>,
	Alexander Viro <viro@zeniv.linux.org.uk>,
	Christian Brauner <brauner@kernel.org>
Cc: Jan Kara <jack@suse.cz>,
	"linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>,
	"linux-unionfs@vger.kernel.org" <linux-unionfs@vger.kernel.org>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	Edvard Conrad <edvard@tuta.io>,
	"stable@vger.kernel.org" <stable@vger.kernel.org>
Message-ID: <P4wV1J9--F-9@tuta.io>
Subject: [PATCH v2] fs: let backing files inherit FMODE_NONOTIFY from the
 user file
X-Mailing-List: linux-unionfs@vger.kernel.org
List-Id: <linux-unionfs.vger.kernel.org>
List-Post: <mailto:linux-unionfs@vger.kernel.org>
List-Help: <mailto:linux-unionfs+help@vger.kernel.org>
List-Subscribe: <mailto:linux-unionfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-unionfs+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-unionfs+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Feedback-ID: 0127f977f5e13e8051b46c6e7f57d0f95a0470d24b79d7c31d07fdf611cc427ab823e0f4692a810119c92d8768973a9281:TurnOnPrivacy!:tutamail

When fanotify reports a permission event, copy_event_to_user() creates
the event fd with dentry_open_nonotify(), so that the listener's use of
that fd does not generate further events. If the event's path is on a
stacked filesystem, the stacked filesystem's ->open() opens the real
file with backing_file_open(). Since commit ebe559609d78 ("fs: get rid
of __FMODE_NONOTIFY kludge"), FMODE_NONOTIFY lives in f_mode only and
the backing file does not inherit it: it is allocated with the default
fsnotify mode, and fsnotify_open_perm_and_set_mode() raises FS_OPEN_PERM
on the real path if the backing filesystem has permission event
watchers.

Before that commit __FMODE_NONOTIFY travelled in f_flags, and overlayfs
copies the user file's f_flags into the backing open
(ovl_open_realfile()), so the backing file was exempt implicitly. Commit
bc2473c90fca ("ovl: enable fsnotify events on underlying real files")
relied on that when it dropped FMODE_NONOTIFY from OVL_OPEN_FLAGS.

The nested event is queued to the same group, from inside the
listener's read(2), and can only be answered by another reader thread
of that group. A listener holding filesystem marks on both the stacked
and the backing filesystem therefore deadlocks as soon as all of its
reader threads are inside such a read(2) at the same time, and every
other task that touches a marked filesystem queues up behind it.

Observed with a commercial anti-malware agent (16 reader threads) on an
ostree/composefs host: / is an overlayfs whose data layer is the ostree
object store on the same btrfs that holds /etc and /home, and a
systemd-sysext overlay sits on /usr. Every on-demand scan of /usr wedged
the whole machine until the group was killed. Stack of a blocked reader
thread on 7.2.7:

  fanotify_get_response
  fanotify_handle_event
  send_to_group
  fsnotify
  __fsnotify_parent
  do_dentry_open
  vfs_open
  backing_file_open
  ovl_open_realfile [overlay]
  ovl_open [overlay]
  do_dentry_open
  vfs_open
  backing_file_open
  ovl_open_realfile [overlay]
  ovl_open [overlay]
  do_dentry_open
  vfs_open
  dentry_open_nonotify
  copy_event_to_user
  fanotify_read
  vfs_read
  ksys_read

Userspace cannot avoid this: the backing open happens while the kernel
builds the fd, before the event is reported, and fid reporting is not
available for permission event classes.

Give init_file() an @fmode argument and have alloc_empty_backing_file()
pass the fsnotify mode its backing file inherits from the user file,
alongside FMODE_BACKING | FMODE_NOACCOUNT, which no longer have to be
assigned after init_file() returns. The fsnotify bits have to be applied
through file_set_fsnotify_mode(), because it clears FMODE_FSNOTIFY_MASK
in f_mode.

Only the "no events at all" mode is inherited. A user file in any other
fsnotify mode leaves the backing file at the default, so events on the
real file keep being generated as intended by bc2473c90fca.

This covers both backing_file_open() and backing_tmpfile_open(), and
restores the pre-6.14 behaviour for the fds that fanotify creates.

Verified with a self-contained reproducer (private tmpfs lower layers,
an overlayfs over them, FAN_OPEN_PERM filesystem marks on the overlay
and on one lower layer, a child opening a file through the overlay) in
a qemu VM on this tree built with defconfig plus OVERLAY_FS, FANOTIFY
and FANOTIFY_ACCESS_PERMISSIONS: without this patch the listener's
read(2) never returns and the child's open is released only by the
listener's death; with it read(2) returns, the event is answered and
the open completes.

Fixes: ebe559609d78 ("fs: get rid of __FMODE_NONOTIFY kludge")
Cc: stable@vger.kernel.org
Suggested-by: Amir Goldstein <amir73il@gmail.com>
Assisted-by: LLM
Signed-off-by: Edvard Conrad <edvard@tuta.io>
---
v2:
 - Move the fix into alloc_empty_backing_file() the way Amir suggested:
   init_file() takes the f_mode to start from, so FMODE_BACKING and
   FMODE_NOACCOUNT no longer have to be assigned after it returns, and
   backing_tmpfile_open() is covered as well.
 - Amir's version as posted does not fix the deadlock. init_file() calls
   file_set_fsnotify_mode(f, FMODE_NONOTIFY_PERM) five lines after
   f_mode is assigned, and that helper clears FMODE_FSNOTIFY_MASK, so
   the inherited FMODE_NONOTIFY is dropped again. The fsnotify part of
   the mode is therefore passed through file_set_fsnotify_mode() here.
 - Inherit only the "no events at all" mode rather than masking
   FMODE_NONOTIFY out of any mode: a user file in the HSM mode
   (FMODE_NONOTIFY | FMODE_NONOTIFY_PERM) would otherwise silence
   regular events on the backing file, which commit bc2473c90fca
   deliberately enabled.
 - Verified in the same qemu VM as v1, and with an LTP test posted
   separately as "syscalls/fanotify26: Add test for nested permission
   events" (marked STAGING until this lands): the second test case fails
   without this patch and passes with it.

Tool disclosure (Documentation/process/generated-content.rst): the stack
analysis, the git-history search for the regressing commit, the patch
text, the commit message and the reproducer were produced with an AI
coding assistant (Anthropic Claude Code) under my direction over
interactive sessions; I reviewed, built and tested the result. No static
analysis tools beyond checkpatch were used.

 fs/file_table.c | 43 +++++++++++++++++++++++++++++++++----------
 1 file changed, 33 insertions(+), 10 deletions(-)

diff --git a/fs/file_table.c b/fs/file_table.c
index 666104f6ef4..519a886c8ab 100644
--- a/fs/file_table.c
+++ b/fs/file_table.c
@@ -176,8 +176,10 @@ static int __init init_fs_stat_sysctls(void)
 fs_initcall(init_fs_stat_sysctls);
 #endif
 
-static int init_file(struct file *f, int flags, const struct cred *cred)
+static int init_file(struct file *f, int flags, const struct cred *cred,
+		     fmode_t fmode)
 {
+	fmode_t fsnotify_mode = fmode & FMODE_FSNOTIFY_MASK;
 	int error;
 
 	f->f_cred = get_cred(cred);
@@ -200,12 +202,16 @@ static int init_file(struct file *f, int flags, const struct cred *cred)
 	memset(&f->f_ra, 0, sizeof(f->f_ra));
 
 	f->f_flags	= flags;
-	f->f_mode	= OPEN_FMODE(flags);
+	f->f_mode	= OPEN_FMODE(flags) | fmode;
 	/*
 	 * Disable permission and pre-content events for all files by default.
 	 * They may be enabled later by fsnotify_open_perm_and_set_mode().
+	 * A caller passing an fsnotify mode in @fmode overrides the default;
+	 * it has to be applied here, because file_set_fsnotify_mode() clears
+	 * the fsnotify bits that f_mode was just assigned.
 	 */
-	file_set_fsnotify_mode(f, FMODE_NONOTIFY_PERM);
+	file_set_fsnotify_mode(f, fsnotify_mode ? fsnotify_mode :
+						  FMODE_NONOTIFY_PERM);
 
 	f->f_op		= NULL;
 	f->f_mapping	= NULL;
@@ -263,7 +269,7 @@ struct file *alloc_empty_file(int flags, const struct cred *cred)
 	if (unlikely(!f))
 		return ERR_PTR(-ENOMEM);
 
-	error = init_file(f, flags, cred);
+	error = init_file(f, flags, cred, 0);
 	if (unlikely(error)) {
 		kmem_cache_free(filp_cache, f);
 		return ERR_PTR(error);
@@ -297,14 +303,12 @@ struct file *alloc_empty_file_noaccount(int flags, const struct cred *cred)
 	if (unlikely(!f))
 		return ERR_PTR(-ENOMEM);
 
-	error = init_file(f, flags, cred);
+	error = init_file(f, flags, cred, FMODE_NOACCOUNT);
 	if (unlikely(error)) {
 		kmem_cache_free(filp_cache, f);
 		return ERR_PTR(error);
 	}
 
-	f->f_mode |= FMODE_NOACCOUNT;
-
 	return f;
 }
 
@@ -316,6 +320,25 @@ static int init_backing_file(struct backing_file *ff,
 	return security_backing_file_alloc(&ff->file, user_file);
 }
 
+/*
+ * The fsnotify mode a backing file inherits from the user file it is opened
+ * for.
+ *
+ * A user file that must not generate fsnotify events at all (e.g. the fd that
+ * fanotify creates for a permission event with dentry_open_nonotify()) must
+ * not generate them through its backing file either. Otherwise a listener
+ * watching the backing filesystem gets a nested permission event from its own
+ * read(2), which only another reader of the same group can answer.
+ *
+ * Every other mode is not inherited: events on the real file are intentional,
+ * see commit bc2473c90fca ("ovl: enable fsnotify events on underlying real
+ * files").
+ */
+static fmode_t backing_file_fsnotify_mode(const struct file *user_file)
+{
+	return FMODE_FSNOTIFY_NONE(user_file->f_mode) ? FMODE_NONOTIFY : 0;
+}
+
 /*
  * Variant of alloc_empty_file() that allocates a backing_file container
  * and doesn't check and modify nr_files.
@@ -333,14 +356,14 @@ struct file *alloc_empty_backing_file(int flags, const struct cred *cred,
 	if (unlikely(!ff))
 		return ERR_PTR(-ENOMEM);
 
-	error = init_file(&ff->file, flags, cred);
+	error = init_file(&ff->file, flags, cred,
+			  backing_file_fsnotify_mode(user_file) |
+			  FMODE_BACKING | FMODE_NOACCOUNT);
 	if (unlikely(error)) {
 		kmem_cache_free(bfilp_cache, ff);
 		return ERR_PTR(error);
 	}
 
-	/* The f_mode flags must be set before fput(). */
-	ff->file.f_mode |= FMODE_BACKING | FMODE_NOACCOUNT;
 	error = init_backing_file(ff, user_file);
 	if (unlikely(error)) {
 		fput(&ff->file);
-- 
2.56.0

