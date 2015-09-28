From: David Howells <dhowells@redhat.com>
Subject: [PATCH 5/5] SELinux: Check against union label for file operations
Date: Mon, 28 Sep 2015 21:01:13 +0100
Message-ID: <20150928200113.8141.56806.stgit@warthog.procyon.org.uk>
References: <20150928200018.8141.2982.stgit@warthog.procyon.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20150928200018.8141.2982.stgit@warthog.procyon.org.uk>
Sender: linux-kernel-owner@vger.kernel.org
To: linux-unionfs@vger.kernel.org, selinux@tycho.nsa.gov
Cc: mjg59@srcf.ucam.org, dwalsh@redhat.com, linux-kernel@vger.kernel.org, eparis@redhat.com, dhowells@redhat.com, linux-security-module@vger.kernel.org, linux-fsdevel@vger.kernel.org, sds@tycho.nsa.gov
List-Id: linux-unionfs@vger.kernel.org

File operations (eg. read, write) issued against a file that is attached to
the lower layer of a union file needs to be checked against the union-layer
label not the lower layer label.

The union label is stored in the file_security_struct rather than being
retrieved from one of the inodes.

Signed-off-by: David Howells <dhowells@redhat.com>
---

 security/selinux/hooks.c |   12 ++++++++++--
 1 file changed, 10 insertions(+), 2 deletions(-)

diff --git a/security/selinux/hooks.c b/security/selinux/hooks.c
index 522b070d9e2b..ecc883b6d463 100644
--- a/security/selinux/hooks.c
+++ b/security/selinux/hooks.c
@@ -1682,6 +1682,7 @@ static int file_has_perm(const struct cred *cred,
 			 struct file *file,
 			 u32 av)
 {
+	struct inode_security_struct *isec;
 	struct file_security_struct *fsec = file->f_security;
 	struct inode *inode = file_inode(file);
 	struct common_audit_data ad;
@@ -1702,8 +1703,15 @@ static int file_has_perm(const struct cred *cred,
 
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
