From: David Howells <dhowells@redhat.com>
Subject: [PATCH 8/8] SELinux: Check against union label for file operations
Date: Thu, 18 Jun 2015 14:33:18 +0100
Message-ID: <20150618133318.12722.64999.stgit@warthog.procyon.org.uk>
References: <20150618133215.12722.70352.stgit@warthog.procyon.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-fsdevel-owner@vger.kernel.org>
In-Reply-To: <20150618133215.12722.70352.stgit@warthog.procyon.org.uk>
Sender: linux-fsdevel-owner@vger.kernel.org
To: sds@tycho.nsa.gov, viro@zeniv.linux.org.uk, miklos@szeredi.hu
Cc: linux-fsdevel@vger.kernel.org, dhowells@redhat.com, linux-security-module@vger.kernel.org, linux-unionfs@vger.kernel.org, linux-kernel@vger.kernel.org
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
index 7eef1032c11a..9d954ad8b510 100644
--- a/security/selinux/hooks.c
+++ b/security/selinux/hooks.c
@@ -1657,6 +1657,7 @@ static int file_has_perm(const struct cred *cred,
 			 struct file *file,
 			 u32 av)
 {
+	struct inode_security_struct *isec;
 	struct file_security_struct *fsec = file->f_security;
 	struct inode *inode = file_inode(file);
 	struct common_audit_data ad;
@@ -1677,8 +1678,15 @@ static int file_has_perm(const struct cred *cred,
 
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

