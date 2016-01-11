From: Vivek Goyal <vgoyal@redhat.com>
Subject: [PATCH] ovl: Do not leave whiteout during unlink/rmdir if parent
 does not have merge property
Date: Mon, 11 Jan 2016 08:55:18 -0500
Message-ID: <20160111135518.GB21233@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-unionfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:52560 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932984AbcAKNzU (ORCPT <rfc822;linux-unionfs@vger.kernel.org>);
	Mon, 11 Jan 2016 08:55:20 -0500
Content-Disposition: inline
Sender: linux-unionfs-owner@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org
To: linux-unionfs@vger.kernel.org
Cc: miklos@szeredi.hu, David Howells <dhowells@redhat.com>, linux-fsdevel@vger.kernel.org

I am trying to fix following bug
https://bugzilla.kernel.org/show_bug.cgi?id=109611

Do following.

$ mkdir upper lower work merged upper/dir/
$ touch lower/test
$ sudo mount -t overlay overlay -olowerdir=lower,upperdir=upper,workdir=work merged
$ mv merged/test merged/dir/
$ rm merged/dir/test
$ ls -l merged/dir/
/usr/bin/ls: cannot access merged/dir/test: No such file or directory
total 0
c????????? ? ? ? ?            ? test

Basic problem seems to be that once a file has been unlinked, a
whiteout has been left behind and doing ls makes that whiteout visible.

whiteout is visible because parent dir is of not type MERGE, hence od->is_real
is set during ovl_dir_open(). And that means ovl_iterate() passes on iterate
handling directly to underlying fs. Underlying fs does not know/filter
whiteouts so it becomes visible to user.

Why did we leave a whiteout to begin with when we should not have.
ovl_do_remove() checks for OVL_TYPE_PURE_UPPER() and does not leave
whiteout if file is pure upper. In this case file is not found to be
pure upper hence whiteout is left.

So why file was not PURE_UPPER in this case? I think because dentry is
still carrying some leftover state which was valid before rename. For example,
od->numlower was set to 1 as it was a lower file. After rename, this state
is not valid anymore as there is no such file in lower.

Also during rename, we first copied up the file and set oe->opaque=1. That
means this file will never be characterized as PURE.

And hence we leave a whiteout when we should not have to. So I have put a
temporary hack to check if parent is type MERGE or not. If it is not then
looks like we might not have to leave a whiteout.

This seems like a hack fix to me. Real problem seems to be that during rename
some ovl_entry state got stale. Not sure how to take care of that. So
sending this hack fix out and hoping somebody can suggest what's a better
way to fix it.

Signed-off-by: Vivek Goyal <vgoyal@redhat.com>
---
 fs/overlayfs/dir.c | 13 +++++++++++--
 1 file changed, 11 insertions(+), 2 deletions(-)

diff --git a/fs/overlayfs/dir.c b/fs/overlayfs/dir.c
index 692ceda..a2fd06b 100644
--- a/fs/overlayfs/dir.c
+++ b/fs/overlayfs/dir.c
@@ -637,7 +637,7 @@ static inline int ovl_check_sticky(struct dentry *dentry)
 
 static int ovl_do_remove(struct dentry *dentry, bool is_dir)
 {
-	enum ovl_path_type type;
+	enum ovl_path_type type, parent_type;
 	int err;
 
 	err = ovl_check_sticky(dentry);
@@ -653,7 +653,16 @@ static int ovl_do_remove(struct dentry *dentry, bool is_dir)
 		goto out_drop_write;
 
 	type = ovl_path_type(dentry);
-	if (OVL_TYPE_PURE_UPPER(type)) {
+	parent_type = ovl_path_type(dentry->d_parent);
+
+	/*
+	 * After rename if a file is removed, it could have out of sync
+	 * numlower and forced "opaque" set which means file will not be
+	 * categorized as pure upper. So if parent is not type merge, then
+	 * it is not present in any of the lower so there should not be
+	 * any need to leave whiteout.
+	 */
+	if (OVL_TYPE_PURE_UPPER(type) || !OVL_TYPE_MERGE(parent_type)) {
 		err = ovl_remove_upper(dentry, is_dir);
 	} else {
 		const struct cred *old_cred;
-- 
2.1.0
