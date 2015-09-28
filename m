From: David Howells <dhowells@redhat.com>
Subject: [PATCH 2/5] Overlayfs: Use copy-up security hooks
Date: Mon, 28 Sep 2015 21:00:41 +0100
Message-ID: <20150928200041.8141.21790.stgit@warthog.procyon.org.uk>
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

Use the copy-up security hooks previously provided to allow an LSM to adjust
the security on a newly created copy and to filter the xattrs copied to that
file copy.

Signed-off-by: David Howells <dhowells@redhat.com>
---

 fs/overlayfs/copy_up.c |   12 ++++++++++++
 1 file changed, 12 insertions(+)

diff --git a/fs/overlayfs/copy_up.c b/fs/overlayfs/copy_up.c
index 871fcb67be97..865f80aa7e44 100644
--- a/fs/overlayfs/copy_up.c
+++ b/fs/overlayfs/copy_up.c
@@ -58,6 +58,14 @@ int ovl_copy_xattr(struct dentry *old, struct dentry *new)
 			error = size;
 			goto out_free_value;
 		}
+		error = security_inode_copy_up_xattr(old, new,
+						     name, value, &size);
+		if (error < 0)
+			goto out_free_value;
+		if (error == 1) {
+			error = 0;
+			continue; /* Discard */
+		}
 		error = vfs_setxattr(new, name, value, size, 0);
 		if (error)
 			goto out_free_value;
@@ -223,6 +231,10 @@ static int ovl_copy_up_locked(struct dentry *workdir, struct dentry *upperdir,
 	if (err)
 		goto out2;
 
+	err = security_inode_copy_up(lowerpath->dentry, newdentry);
+	if (err < 0)
+		goto out_cleanup;
+
 	if (S_ISREG(stat->mode)) {
 		struct path upperpath;
 		ovl_path_upper(dentry, &upperpath);
