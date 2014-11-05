From: David Howells <dhowells@redhat.com>
Subject: [PATCH 7/7] SELinux: Check against union and lower labels for file
 ops on lower files
Date: Wed, 05 Nov 2014 15:43:29 +0000
Message-ID: <20141105154328.2555.98013.stgit@warthog.procyon.org.uk>
References: <20141105154217.2555.578.stgit@warthog.procyon.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20141105154217.2555.578.stgit@warthog.procyon.org.uk>
Sender: linux-kernel-owner@vger.kernel.org
To: linux-unionfs@vger.kernel.org, selinux@tycho.nsa.gov
Cc: dhowells@redhat.com, linux-fsdevel@vger.kernel.org, linux-security-module@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org

File operations (eg. read, write) issued against a file that is attached to
the lower layer of a union file needs to be checked against the union-layer
label as well as the lower-layer label.

Signed-off-by: David Howells <dhowells@redhat.com>
---

 security/selinux/hooks.c |   14 +++++++++++---
 1 file changed, 11 insertions(+), 3 deletions(-)

diff --git a/security/selinux/hooks.c b/security/selinux/hooks.c
index 57f9c641779f..7084ccb1321c 100644
--- a/security/selinux/hooks.c
+++ b/security/selinux/hooks.c
@@ -1673,6 +1673,7 @@ static int file_has_perm(const struct cred *cred,
 			 struct file *file,
 			 u32 av)
 {
+	struct inode_security_struct *isec;
 	struct file_security_struct *fsec = file->f_security;
 	struct inode *inode = file_inode(file);
 	struct common_audit_data ad;
@@ -1681,7 +1682,7 @@ static int file_has_perm(const struct cred *cred,
 
 	ad.type = LSM_AUDIT_DATA_PATH;
 	ad.u.path = file->f_path;
-
+	
 	if (sid != fsec->sid) {
 		rc = avc_has_perm(sid, fsec->sid,
 				  SECCLASS_FD,
@@ -1693,8 +1694,15 @@ static int file_has_perm(const struct cred *cred,
 
 	/* av is zero if only checking access to the descriptor. */
 	rc = 0;
-	if (av)
-		rc = inode_has_perm(cred, inode, av, &ad);
+	if (av && likely(!IS_PRIVATE(inode))) {
+		if (fsec->union_isid) {
+			isec = inode->i_security;
+			rc = avc_has_perm(sid, fsec->union_isid, isec->sclass,
+					  av, &ad);
+		}
+		if (!rc)
+			rc = inode_has_perm(cred, inode, av, &ad);
+	}
 
 out:
 	return rc;
