From: Mark Salyzyn <salyzyn@android.com>
Subject: [PATCH v14 3/5] overlayfs: handle XATTR_NOSECURITY flag for get xattr method
Date: Tue, 22 Oct 2019 13:44:48 -0700
Message-ID: <20191022204453.97058-4-salyzyn@android.com>
References: <20191022204453.97058-1-salyzyn@android.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20191022204453.97058-1-salyzyn@android.com>
Sender: linux-kernel-owner@vger.kernel.org
To: linux-kernel@vger.kernel.org
Cc: kernel-team@android.com, Mark Salyzyn <salyzyn@android.com>, Miklos Szeredi <miklos@szeredi.hu>, Jonathan Corbet <corbet@lwn.net>, Vivek Goyal <vgoyal@redhat.com>, "Eric W . Biederman" <ebiederm@xmission.com>, Amir Goldstein <amir73il@gmail.com>, Randy Dunlap <rdunlap@infradead.org>, Stephen Smalley <sds@tycho.nsa.gov>, linux-unionfs@vger.kernel.org, linux-doc@vger.kernel.org, linux-security-module@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org

Because of the overlayfs getxattr recursion, the incoming inode fails
to update the selinux sid resulting in avc denials being reported
against a target context of u:object_r:unlabeled:s0.

Solution is to respond to the XATTR_NOSECURITY flag in get xattr
method that calls the __vfs_getxattr handler instead so that the
context can be read in, rather than being denied with an -EACCES
when vfs_getxattr handler is called.

For the use case where access is to be blocked by the security layer.

The path then would be security(dentry) ->
__vfs_getxattr({dentry...XATTR_NOSECURITY}) ->
handler->get({dentry...XATTR_NOSECURITY}) ->
__vfs_getxattr({realdentry...XATTR_NOSECURITY}) ->
lower_handler->get({realdentry...XATTR_NOSECURITY}) which
would report back through the chain data and success as expected,
the logging security layer at the top would have the data to
determine the access permissions and report back to the logs and
the caller that the target context was blocked.

For selinux this would solve the cosmetic issue of the selinux log
and allow audit2allow to correctly report the rule needed to address
the access problem.

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
Cc: linux-security-module@vger.kernel.org

---
v14 - rebase to use xattr_gs_args.

v13 - rebase to use __vfs_getxattr flags option.

v12 - Added back to patch series as get xattr with flag option.

v11 - Squashed out of patch series and replaced with per-thread flag
      solution.

v10 - Added to patch series as __get xattr method.

---
 fs/overlayfs/inode.c | 7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

diff --git a/fs/overlayfs/inode.c b/fs/overlayfs/inode.c
index 5fb7608647a4..2eb037c325bf 100644
--- a/fs/overlayfs/inode.c
+++ b/fs/overlayfs/inode.c
@@ -367,12 +367,15 @@ int ovl_xattr_get(struct xattr_gs_args *args)
 {
 	ssize_t res;
 	const struct cred *old_cred;
-	struct dentry *realdentry =
+	struct xattr_gs_args my_args = *args;
+
+	my_args.dentry =
 		ovl_i_dentry_upper(args->inode) ?:
 		ovl_dentry_lower(args->dentry);
+	my_args.inode = d_inode(my_args.dentry);
 
 	old_cred = ovl_override_creds(args->dentry->d_sb);
-	res = vfs_getxattr(realdentry, args->name, args->buffer, args->size);
+	res = __vfs_getxattr(&my_args);
 	revert_creds(old_cred);
 	return res;
 }
-- 
2.23.0.866.gb869b98d4c-goog
