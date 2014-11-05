From: David Howells <dhowells@redhat.com>
Subject: [PATCH 2/7] Overlayfs: Use copy-up security hooks
Date: Wed, 05 Nov 2014 15:42:38 +0000
Message-ID: <20141105154238.2555.85960.stgit@warthog.procyon.org.uk>
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

Use the copy-up security hooks previously provided to allow an LSM to adjust
the security on a newly created copy and to filter the xattrs copied to that
file copy.

Signed-off-by: David Howells <dhowells@redhat.com>
---

 fs/overlayfs/copy_up.c |   12 ++++++++++++
 1 file changed, 12 insertions(+)

diff --git a/fs/overlayfs/copy_up.c b/fs/overlayfs/copy_up.c
index ea10a8719107..53a357d0a214 100644
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
@@ -224,6 +232,10 @@ static int ovl_copy_up_locked(struct dentry *workdir, struct dentry *upperdir,
 	if (err)
 		goto out2;
 
+	err = security_inode_copy_up(lowerpath->dentry, newdentry);
+	if (err < 0)
+		goto out_cleanup;
+
 	if (S_ISREG(stat->mode)) {
 		struct path upperpath;
 		ovl_path_upper(dentry, &upperpath);
