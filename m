From: Vivek Goyal <vgoyal@redhat.com>
Subject: [PATCH 5/7] selinux: Pass security pointer to determine_inode_label()
Date: Fri,  8 Jul 2016 12:19:40 -0400
Message-ID: <1467994782-26474-6-git-send-email-vgoyal@redhat.com>
References: <1467994782-26474-1-git-send-email-vgoyal@redhat.com>
Return-path: <linux-unionfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:44649 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755925AbcGHQUD (ORCPT <rfc822;linux-unionfs@vger.kernel.org>);
	Fri, 8 Jul 2016 12:20:03 -0400
In-Reply-To: <1467994782-26474-1-git-send-email-vgoyal@redhat.com>
Sender: linux-unionfs-owner@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org
To: miklos@szeredi.hu, sds@tycho.nsa.gov, pmoore@redhat.com, casey@schaufler-ca.com, linux-kernel@vger.kernel.org, linux-unionfs@vger.kernel.org, linux-security-module@vger.kernel.org
Cc: dwalsh@redhat.com, dhowells@redhat.com, viro@ZenIV.linux.org.uk, vgoyal@redhat.com, linux-fsdevel@vger.kernel.org

Right now selinux_determine_inode_label() works on security pointer of
current task. Soon I need this to work on a security pointer retrieved
from a set of creds. So start passing in a pointer and caller can decide
where to fetch security pointer from.

Signed-off-by: Vivek Goyal <vgoyal@redhat.com>
---
 security/selinux/hooks.c | 19 ++++++++++---------
 1 file changed, 10 insertions(+), 9 deletions(-)

diff --git a/security/selinux/hooks.c b/security/selinux/hooks.c
index 4fda548..ae11fd9 100644
--- a/security/selinux/hooks.c
+++ b/security/selinux/hooks.c
@@ -1785,13 +1785,13 @@ out:
 /*
  * Determine the label for an inode that might be unioned.
  */
-static int selinux_determine_inode_label(struct inode *dir,
-					 const struct qstr *name,
-					 u16 tclass,
-					 u32 *_new_isid)
+static int
+selinux_determine_inode_label(const struct task_security_struct *tsec,
+				 struct inode *dir,
+				 const struct qstr *name, u16 tclass,
+				 u32 *_new_isid)
 {
 	const struct superblock_security_struct *sbsec = dir->i_sb->s_security;
-	const struct task_security_struct *tsec = current_security();
 
 	if ((sbsec->flags & SE_SBINITIALIZED) &&
 	    (sbsec->behavior == SECURITY_FS_USE_MNTPOINT)) {
@@ -1834,8 +1834,8 @@ static int may_create(struct inode *dir,
 	if (rc)
 		return rc;
 
-	rc = selinux_determine_inode_label(dir, &dentry->d_name, tclass,
-					   &newsid);
+	rc = selinux_determine_inode_label(current_security(), dir,
+					   &dentry->d_name, tclass, &newsid);
 	if (rc)
 		return rc;
 
@@ -2815,7 +2815,8 @@ static int selinux_dentry_init_security(struct dentry *dentry, int mode,
 	u32 newsid;
 	int rc;
 
-	rc = selinux_determine_inode_label(d_inode(dentry->d_parent), name,
+	rc = selinux_determine_inode_label(current_security(),
+					   d_inode(dentry->d_parent), name,
 					   inode_mode_to_security_class(mode),
 					   &newsid);
 	if (rc)
@@ -2840,7 +2841,7 @@ static int selinux_inode_init_security(struct inode *inode, struct inode *dir,
 	sid = tsec->sid;
 	newsid = tsec->create_sid;
 
-	rc = selinux_determine_inode_label(
+	rc = selinux_determine_inode_label(current_security(),
 		dir, qstr,
 		inode_mode_to_security_class(inode->i_mode),
 		&newsid);
-- 
2.7.4
