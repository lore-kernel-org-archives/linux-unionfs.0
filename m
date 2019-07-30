From: Mark Salyzyn <salyzyn@android.com>
Subject: [PATCH v11 2/4] fs: __vfs_getxattr nesting paradigm
Date: Tue, 30 Jul 2019 08:52:23 -0700
Message-ID: <20190730155227.41468-3-salyzyn@android.com>
References: <20190730155227.41468-1-salyzyn@android.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20190730155227.41468-1-salyzyn@android.com>
Sender: linux-kernel-owner@vger.kernel.org
To: linux-kernel@vger.kernel.org
Cc: kernel-team@android.com, Mark Salyzyn <salyzyn@android.com>, Miklos Szeredi <miklos@szeredi.hu>, Jonathan Corbet <corbet@lwn.net>, Vivek Goyal <vgoyal@redhat.com>, "Eric W . Biederman" <ebiederm@xmission.com>, Amir Goldstein <amir73il@gmail.com>, Randy Dunlap <rdunlap@infradead.org>, Stephen Smalley <sds@tycho.nsa.gov>, linux-unionfs@vger.kernel.org, linux-doc@vger.kernel.org, Alexander Viro <viro@zeniv.linux.org.uk>, Ingo Molnar <mingo@redhat.com>, Peter Zijlstra <peterz@infradead.org>, linux-fsdevel@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org

Add a per-thread PF_NO_SECURITY flag that ensures that nested calls
that result in vfs_getxattr do not fall under security framework
scrutiny.  Use cases include selinux when acquiring the xattr data
to evaluate security, and internal trusted xattr data soleley managed
by the filesystem drivers.

This handles the case of a union filesystem driver that is being
requested by the security layer to report back the data that is the
target label or context embedded into wrapped filesystem's xattr.

For the use case where access is to be blocked by the security layer.

The path then could be security(dentry) -> __vfs_getxattr(dentry) ->
handler->get(dentry) -> __vfs_getxattr(lower_dentry) ->
lower_handler->get(lower_dentry) which would report back through the
chain data and success as expected, but the logging security layer at
the top would have the data to determine the access permissions and
report back the target context that was blocked.

Without the nesting check, the path on a union filesystem would be
the errant security(dentry) -> __vfs_getxattr(dentry) ->
handler->get(dentry) -> vfs_getxattr(lower_dentry) -> *nested*
security(lower_dentry, log off) -> lower_handler->get(lower_dentry)
which would report back through the chain no data, and -EACCES.

For selinux for both cases, this would translate to a correctly
determined blocked access. In the first corrected case a correct avc
log would be reported, in the second legacy case an incorrect avc log
would be reported against an uninitialized u:object_r:unlabeled:s0
context making the logs cosmetically useless for audit2allow.

Signed-off-by: Mark Salyzyn <salyzyn@android.com>
Cc: Miklos Szeredi <miklos@szeredi.hu>
Cc: Jonathan Corbet <corbet@lwn.net>
Cc: Vivek Goyal <vgoyal@redhat.com>
Cc: Eric W. Biederman <ebiederm@xmission.com>
Cc: Amir Goldstein <amir73il@gmail.com>
Cc: Randy Dunlap <rdunlap@infradead.org>
Cc: Stephen Smalley <sds@tycho.nsa.gov>
Cc: linux-unionfs@vger.kernel.org
Cc: linux-doc@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
Cc: kernel-team@android.com
---
v11 - squish out v10 introduced patch 2 and 3 in the series,
      then use per-thread flag instead for nesting.
---
 fs/xattr.c            | 10 +++++++++-
 include/linux/sched.h |  1 +
 2 files changed, 10 insertions(+), 1 deletion(-)

diff --git a/fs/xattr.c b/fs/xattr.c
index 90dd78f0eb27..46ebd5014e01 100644
--- a/fs/xattr.c
+++ b/fs/xattr.c
@@ -302,13 +302,19 @@ __vfs_getxattr(struct dentry *dentry, struct inode *inode, const char *name,
 	       void *value, size_t size)
 {
 	const struct xattr_handler *handler;
+	ssize_t ret;
+	unsigned int flags;
 
 	handler = xattr_resolve_name(inode, &name);
 	if (IS_ERR(handler))
 		return PTR_ERR(handler);
 	if (!handler->get)
 		return -EOPNOTSUPP;
-	return handler->get(handler, dentry, inode, name, value, size);
+	flags = current->flags;
+	current->flags |= PF_NO_SECURITY;
+	ret = handler->get(handler, dentry, inode, name, value, size);
+	current_restore_flags(flags, PF_NO_SECURITY);
+	return ret;
 }
 EXPORT_SYMBOL(__vfs_getxattr);
 
@@ -318,6 +324,8 @@ vfs_getxattr(struct dentry *dentry, const char *name, void *value, size_t size)
 	struct inode *inode = dentry->d_inode;
 	int error;
 
+	if (unlikely(current->flags & PF_NO_SECURITY))
+		goto nolsm;
 	error = xattr_permission(inode, name, MAY_READ);
 	if (error)
 		return error;
diff --git a/include/linux/sched.h b/include/linux/sched.h
index 8dc1811487f5..5cda3ff89d4e 100644
--- a/include/linux/sched.h
+++ b/include/linux/sched.h
@@ -1468,6 +1468,7 @@ extern struct pid *cad_pid;
 #define PF_NO_SETAFFINITY	0x04000000	/* Userland is not allowed to meddle with cpus_mask */
 #define PF_MCE_EARLY		0x08000000      /* Early kill for mce process policy */
 #define PF_MEMALLOC_NOCMA	0x10000000	/* All allocation request will have _GFP_MOVABLE cleared */
+#define PF_NO_SECURITY		0x20000000	/* nested security context */
 #define PF_FREEZER_SKIP		0x40000000	/* Freezer should not count it as freezable */
 #define PF_SUSPEND_TASK		0x80000000      /* This thread called freeze_processes() and should not be frozen */
 
-- 
2.22.0.770.g0f2c4a37fd-goog
