From: David Howells <dhowells@redhat.com>
Subject: [PATCH 5/8] SELinux: Stub in copy-up handling
Date: Thu, 18 Jun 2015 14:32:54 +0100
Message-ID: <20150618133254.12722.33339.stgit@warthog.procyon.org.uk>
References: <20150618133215.12722.70352.stgit@warthog.procyon.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-unionfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:42580 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755723AbbFRNc7 (ORCPT <rfc822;linux-unionfs@vger.kernel.org>);
	Thu, 18 Jun 2015 09:32:59 -0400
In-Reply-To: <20150618133215.12722.70352.stgit@warthog.procyon.org.uk>
Sender: linux-unionfs-owner@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org
To: sds@tycho.nsa.gov, viro@zeniv.linux.org.uk, miklos@szeredi.hu
Cc: linux-fsdevel@vger.kernel.org, dhowells@redhat.com, linux-security-module@vger.kernel.org, linux-unionfs@vger.kernel.org, linux-kernel@vger.kernel.org

Provide stubs for union/overlay copy-up handling.  The xattr copy up stub
discards lower SELinux xattrs rather than letting them be copied up so that
the security label on the copy doesn't get corrupted.

Signed-off-by: David Howells <dhowells@redhat.com>
---

 security/selinux/hooks.c |   16 ++++++++++++++++
 1 file changed, 16 insertions(+)

diff --git a/security/selinux/hooks.c b/security/selinux/hooks.c
index ffa5a642629a..c5d893e2ff23 100644
--- a/security/selinux/hooks.c
+++ b/security/selinux/hooks.c
@@ -3200,6 +3200,20 @@ static void selinux_inode_getsecid(const struct inode *inode, u32 *secid)
 	*secid = isec->sid;
 }
 
+static int selinux_inode_copy_up(struct dentry *src, struct dentry *dst)
+{
+	return 0;
+}
+
+static int selinux_inode_copy_up_xattr(struct dentry *src, struct dentry *dst,
+				       const char *name, void *value,
+				       size_t *size)
+{
+	if (strcmp(name, XATTR_NAME_SELINUX) == 0)
+		return 1; /* Discard */
+	return 0;
+}
+
 /* file security operations */
 
 static int selinux_revalidate_file_permission(struct file *file, int mask)
@@ -5917,6 +5931,8 @@ static struct security_operations selinux_ops = {
 	.inode_setsecurity =		selinux_inode_setsecurity,
 	.inode_listsecurity =		selinux_inode_listsecurity,
 	.inode_getsecid =		selinux_inode_getsecid,
+	.inode_copy_up =		selinux_inode_copy_up,
+	.inode_copy_up_xattr =		selinux_inode_copy_up_xattr,
 
 	.file_permission =		selinux_file_permission,
 	.file_alloc_security =		selinux_file_alloc_security,
