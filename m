From: David Howells <dhowells@redhat.com>
Subject: [PATCH] SELinux: Create a common helper to determine an inode label [ver #3]
Date: Thu, 18 Jun 2015 19:25:05 +0100
Message-ID: <6033.1434651905@warthog.procyon.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-security-module-owner@vger.kernel.org>
Content-ID: <6032.1434651905.1@warthog.procyon.org.uk>
Sender: linux-security-module-owner@vger.kernel.org
To: Stephen Smalley <sds@tycho.nsa.gov>
Cc: dhowells@redhat.com, linux-fsdevel@vger.kernel.org, linux-security-module@vger.kernel.org, linux-unionfs@vger.kernel.org, linux-kernel@vger.kernel.org, SELinux <selinux@tycho.nsa.gov>, Paul Moore <paul@paul-moore.com>
List-Id: linux-unionfs@vger.kernel.org

    
Create a common helper function to determine the label for a new inode.
This is then used by:

	- may_create()
	- selinux_dentry_init_security()
	- selinux_inode_init_security()

This will change the behaviour of the functions slightly, bringing them all
into line.

Suggested-by: Stephen Smalley <sds@tycho.nsa.gov>
Signed-off-by: David Howells <dhowells@redhat.com>
---
diff --git a/security/selinux/hooks.c b/security/selinux/hooks.c
index ffa5a642629a..ec30e599fb46 100644
--- a/security/selinux/hooks.c
+++ b/security/selinux/hooks.c
@@ -1684,6 +1684,32 @@ out:
 	return rc;
 }
 
+/*
+ * Determine the label for an inode that might be unioned.
+ */
+static int selinux_determine_inode_label(const struct inode *dir,
+					 const struct qstr *name,
+					 u16 tclass,
+					 u32 *_new_isid)
+{
+	const struct superblock_security_struct *sbsec = dir->i_sb->s_security;
+	const struct inode_security_struct *dsec = dir->i_security;
+	const struct task_security_struct *tsec = current_security();
+
+	if ((sbsec->flags & SE_SBINITIALIZED) &&
+	    (sbsec->behavior == SECURITY_FS_USE_MNTPOINT)) {
+		*_new_isid = sbsec->mntpoint_sid;
+	} else if ((sbsec->flags & SBLABEL_MNT) &&
+		   tsec->create_sid) {
+		*_new_isid = tsec->create_sid;
+	} else {
+		return security_transition_sid(tsec->sid, dsec->sid, tclass,
+					       name, _new_isid);
+	}
+
+	return 0;
+}
+
 /* Check whether a task can create a file. */
 static int may_create(struct inode *dir,
 		      struct dentry *dentry,
@@ -1700,7 +1726,6 @@ static int may_create(struct inode *dir,
 	sbsec = dir->i_sb->s_security;
 
 	sid = tsec->sid;
-	newsid = tsec->create_sid;
 
 	ad.type = LSM_AUDIT_DATA_DENTRY;
 	ad.u.dentry = dentry;
@@ -1711,12 +1736,10 @@ static int may_create(struct inode *dir,
 	if (rc)
 		return rc;
 
-	if (!newsid || !(sbsec->flags & SBLABEL_MNT)) {
-		rc = security_transition_sid(sid, dsec->sid, tclass,
-					     &dentry->d_name, &newsid);
-		if (rc)
-			return rc;
-	}
+	rc = selinux_determine_inode_label(dir, &dentry->d_name, tclass,
+					   &newsid);
+	if (rc)
+		return rc;
 
 	rc = avc_has_perm(sid, newsid, tclass, FILE__CREATE, &ad);
 	if (rc)
@@ -2723,32 +2746,14 @@ static int selinux_dentry_init_security(struct dentry *dentry, int mode,
 					struct qstr *name, void **ctx,
 					u32 *ctxlen)
 {
-	const struct cred *cred = current_cred();
-	struct task_security_struct *tsec;
-	struct inode_security_struct *dsec;
-	struct superblock_security_struct *sbsec;
-	struct inode *dir = d_backing_inode(dentry->d_parent);
 	u32 newsid;
 	int rc;
 
-	tsec = cred->security;
-	dsec = dir->i_security;
-	sbsec = dir->i_sb->s_security;
-
-	if (tsec->create_sid && sbsec->behavior != SECURITY_FS_USE_MNTPOINT) {
-		newsid = tsec->create_sid;
-	} else {
-		rc = security_transition_sid(tsec->sid, dsec->sid,
-					     inode_mode_to_security_class(mode),
-					     name,
-					     &newsid);
-		if (rc) {
-			printk(KERN_WARNING
-				"%s: security_transition_sid failed, rc=%d\n",
-			       __func__, -rc);
-			return rc;
-		}
-	}
+	rc = selinux_determine_inode_label(d_inode(dentry->d_parent), name,
+					   inode_mode_to_security_class(mode),
+					   &newsid);
+	if (rc)
+		return rc;
 
 	return security_sid_to_context(newsid, (char **)ctx, ctxlen);
 }
@@ -2771,22 +2776,12 @@ static int selinux_inode_init_security(struct inode *inode, struct inode *dir,
 	sid = tsec->sid;
 	newsid = tsec->create_sid;
 
-	if ((sbsec->flags & SE_SBINITIALIZED) &&
-	    (sbsec->behavior == SECURITY_FS_USE_MNTPOINT))
-		newsid = sbsec->mntpoint_sid;
-	else if (!newsid || !(sbsec->flags & SBLABEL_MNT)) {
-		rc = security_transition_sid(sid, dsec->sid,
-					     inode_mode_to_security_class(inode->i_mode),
-					     qstr, &newsid);
-		if (rc) {
-			printk(KERN_WARNING "%s:  "
-			       "security_transition_sid failed, rc=%d (dev=%s "
-			       "ino=%ld)\n",
-			       __func__,
-			       -rc, inode->i_sb->s_id, inode->i_ino);
-			return rc;
-		}
-	}
+	rc = selinux_determine_inode_label(
+		dir, qstr,
+		inode_mode_to_security_class(inode->i_mode),
+		&newsid);
+	if (rc)
+		return rc;
 
 	/* Possibly defer initialization to selinux_complete_init. */
 	if (sbsec->flags & SE_SBINITIALIZED) {
