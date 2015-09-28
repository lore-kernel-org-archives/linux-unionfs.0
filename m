From: David Howells <dhowells@redhat.com>
Subject: [PATCH 3/5] SELinux: Stub in copy-up handling
Date: Mon, 28 Sep 2015 21:00:52 +0100
Message-ID: <20150928200052.8141.64045.stgit@warthog.procyon.org.uk>
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

Provide stubs for union/overlay copy-up handling.  The xattr copy up stub
discards lower SELinux xattrs rather than letting them be copied up so that
the security label on the copy doesn't get corrupted.

Signed-off-by: David Howells <dhowells@redhat.com>
---

 security/selinux/hooks.c |   20 ++++++++++++++++++++
 1 file changed, 20 insertions(+)

diff --git a/security/selinux/hooks.c b/security/selinux/hooks.c
index e4369d86e588..7c1a44d9fac3 100644
--- a/security/selinux/hooks.c
+++ b/security/selinux/hooks.c
@@ -3190,6 +3190,24 @@ static void selinux_inode_getsecid(const struct inode *inode, u32 *secid)
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
+	/* The copy_up hook above sets the initial context on an inode, but we
+	 * don't then want to overwrite it by blindly copying all the lower
+	 * xattrs up.  Instead, we have to filter out SELinux-related xattrs.
+	 */
+	if (strcmp(name, XATTR_NAME_SELINUX) == 0)
+		return 1; /* Discard */
+	return 0;
+}
+
 /* file security operations */
 
 static int selinux_revalidate_file_permission(struct file *file, int mask)
@@ -5919,6 +5937,8 @@ static struct security_hook_list selinux_hooks[] = {
 	LSM_HOOK_INIT(inode_setsecurity, selinux_inode_setsecurity),
 	LSM_HOOK_INIT(inode_listsecurity, selinux_inode_listsecurity),
 	LSM_HOOK_INIT(inode_getsecid, selinux_inode_getsecid),
+	LSM_HOOK_INIT(inode_copy_up, selinux_inode_copy_up),
+	LSM_HOOK_INIT(inode_copy_up_xattr, selinux_inode_copy_up_xattr),
 
 	LSM_HOOK_INIT(file_permission, selinux_file_permission),
 	LSM_HOOK_INIT(file_alloc_security, selinux_file_alloc_security),
