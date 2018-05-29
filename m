From: Miklos Szeredi <mszeredi@redhat.com>
Subject: [PATCH 07/11] ovl: make ovl_create_real() cope with vfs_mkdir() safely
Date: Tue, 29 May 2018 16:41:39 +0200
Message-ID: <20180529144143.16378-8-mszeredi@redhat.com>
References: <20180529144143.16378-1-mszeredi@redhat.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20180529144143.16378-1-mszeredi@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
To: linux-unionfs@vger.kernel.org
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org

From: Amir Goldstein <amir73il@gmail.com>

vfs_mkdir() may succeed and leave the dentry passed to it unhashed and
negative.  ovl_create_real() is the last caller breaking when that
happens.

[amir: split re-factoring of ovl_create_temp() to prep patch
       add comment about unhashed dir after mkdir
       add pr_warn() if mkdir succeeds and lookup fails]

Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>
Signed-off-by: Amir Goldstein <amir73il@gmail.com>
Signed-off-by: Miklos Szeredi <mszeredi@redhat.com>
---
 fs/overlayfs/dir.c | 35 +++++++++++++++++++++++++++++++++--
 1 file changed, 33 insertions(+), 2 deletions(-)

diff --git a/fs/overlayfs/dir.c b/fs/overlayfs/dir.c
index 1b181292a624..b33d37d1a87c 100644
--- a/fs/overlayfs/dir.c
+++ b/fs/overlayfs/dir.c
@@ -114,6 +114,37 @@ int ovl_cleanup_and_whiteout(struct dentry *workdir, struct inode *dir,
 	goto out;
 }
 
+static struct dentry *ovl_mkdir_real(struct inode *dir, struct dentry *dentry,
+				     umode_t mode)
+{
+	int err;
+
+	err = ovl_do_mkdir(dir, dentry, mode);
+	if (err) {
+		dput(dentry);
+		return ERR_PTR(err);
+	}
+
+	/*
+	 * vfs_mkdir() may succeed and leave the dentry passed
+	 * to it unhashed and negative. If that happens, try to
+	 * lookup a new hashed and positive dentry.
+	 */
+	if (unlikely(d_unhashed(dentry))) {
+		struct dentry *d;
+
+		d = lookup_one_len(dentry->d_name.name, dentry->d_parent,
+				   dentry->d_name.len);
+		if (IS_ERR(d)) {
+			pr_warn("overlayfs: failed lookup after mkdir (%pd2, err=%i).\n",
+				dentry, err);
+		}
+		dput(dentry);
+		dentry = d;
+	}
+	return dentry;
+}
+
 struct dentry *ovl_create_real(struct inode *dir, struct dentry *newdentry,
 			       struct ovl_cattr *attr)
 {
@@ -135,8 +166,8 @@ struct dentry *ovl_create_real(struct inode *dir, struct dentry *newdentry,
 			break;
 
 		case S_IFDIR:
-			err = ovl_do_mkdir(dir, newdentry, attr->mode);
-			break;
+			/* mkdir is special... */
+			return ovl_mkdir_real(dir, newdentry, attr->mode);
 
 		case S_IFCHR:
 		case S_IFBLK:
-- 
2.14.3
