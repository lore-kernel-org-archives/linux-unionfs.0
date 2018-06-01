From: Miklos Szeredi <miklos@szeredi.hu>
Subject: Re: [GIT PULL] overlayfs update for 4.18
Date: Fri, 1 Jun 2018 17:26:25 +0200
Message-ID: <20180601152625.GD23785@veci.piliscsaba.redhat.com>
References: <20180529132148.GC23785@veci.piliscsaba.redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20180529132148.GC23785@veci.piliscsaba.redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Al Viro <viro@zeniv.linux.org.uk>
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org, linux-unionfs@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org

On Tue, May 29, 2018 at 03:21:48PM +0200, Miklos Szeredi wrote:
> Hi Al,
> 
> I'm sending this pull request to you instead of Linus, because a bigger than
> usual chunk involves the VFS.
> 
> Please pull from:
> 
>   git://git.kernel.org/pub/scm/linux/kernel/git/mszeredi/vfs.git for-viro
> 
> This update contains the following:
> 
>  - Deal with vfs_mkdir() not instantiating dentry.
> 
>  - Stack file operations.  This solves the ro/rw file descriptor inconsistency,
>    weirdness with ioctl, as well as removing a bunch of overlay specific hacks
>    from the VFS.
> 
>  - Allow metadata-only copy-up when data is unchanged.
> 
>  - Various cleanups in VFS and overlayfs.

Updated tree pushed to same place.

Incremental patch against previous pull and posted patchset.

Thanks,
Miklos
---

diff --git a/Documentation/filesystems/overlayfs.txt b/Documentation/filesystems/overlayfs.txt
index 0a8e3c4543d1..79be4a77ca08 100644
--- a/Documentation/filesystems/overlayfs.txt
+++ b/Documentation/filesystems/overlayfs.txt
@@ -280,7 +280,7 @@ parameter metacopy=on/off. Lastly, there is also a per mount option
 metacopy=on/off to enable/disable this feature per mount.
 
 Do not use metacopy=on with untrusted upper/lower directories. Otherwise
-it is possible that an attacker can create a handcrafted file with
+it is possible that an attacker can create an handcrafted file with
 appropriate REDIRECT and METACOPY xattrs, and gain access to file on lower
 pointed by REDIRECT. This should not be possible on local system as setting
 "trusted." xattrs will require CAP_SYS_ADMIN. But it should be possible
@@ -318,7 +318,7 @@ does not support NFS export, lower filesystem does not have a valid UUID or
 if the upper filesystem does not support extended attributes.
 
 For "metadata only copy up" feature there is no verification mechanism at
-mount time. So if same upper is mounted with different set of lower, mount
+mount time. So if same upper is mouted with different set of lower, mount
 probably will succeed but expect the unexpected later on. So don't do it.
 
 It is quite a common practice to copy overlay layers to a different
diff --git a/fs/overlayfs/Kconfig b/fs/overlayfs/Kconfig
index 08b04d9fd6e6..e0a090eca65e 100644
--- a/fs/overlayfs/Kconfig
+++ b/fs/overlayfs/Kconfig
@@ -11,7 +11,7 @@ config OVERLAY_FS
 	  For more information see Documentation/filesystems/overlayfs.txt
 
 config OVERLAY_FS_REDIRECT_DIR
-	bool "Overlayfs: turn on redirect directory feature by default"
+	bool "Overlayfs: turn on redirect dir feature by default"
 	depends on OVERLAY_FS
 	help
 	  If this config option is enabled then overlay filesystems will use
@@ -46,7 +46,7 @@ config OVERLAY_FS_INDEX
 	depends on OVERLAY_FS
 	help
 	  If this config option is enabled then overlay filesystems will use
-	  the index directory to map lower inodes to upper inodes by default.
+	  the inodes index dir to map lower inodes to upper inodes by default.
 	  In this case it is still possible to turn off index globally with the
 	  "index=off" module option or on a filesystem instance basis with the
 	  "index=off" mount option.
@@ -67,7 +67,7 @@ config OVERLAY_FS_NFS_EXPORT
 	depends on !OVERLAY_FS_METACOPY
 	help
 	  If this config option is enabled then overlay filesystems will use
-	  the index directory to decode overlay NFS file handles by default.
+	  the inodes index dir to decode overlay NFS file handles by default.
 	  In this case, it is still possible to turn off NFS export support
 	  globally with the "nfs_export=off" module option or on a filesystem
 	  instance basis with the "nfs_export=off" mount option.
@@ -133,7 +133,7 @@ config OVERLAY_FS_METACOPY
 	help
 	  If this config option is enabled then overlay filesystems will
 	  copy up only metadata where appropriate and data copy up will
-	  happen when a file is opened for WRITE operation. It is still
+	  happen when a file is opended for WRITE operation. It is still
 	  possible to turn off this feature globally with the "metacopy=off"
 	  module option or on a filesystem instance basis with the
 	  "metacopy=off" mount option.
diff --git a/fs/overlayfs/copy_up.c b/fs/overlayfs/copy_up.c
index 296037afecdb..bdadedf73e51 100644
--- a/fs/overlayfs/copy_up.c
+++ b/fs/overlayfs/copy_up.c
@@ -27,7 +27,7 @@
 
 static int ovl_ccup_set(const char *buf, const struct kernel_param *param)
 {
-	pr_warn("overlayfs: \"check_copy_up\" module option is obsolete\n");
+	WARN(1, "overlayfs: \"check_copy_up\" module option is obsolete\n");
 	return 0;
 }
 
diff --git a/fs/overlayfs/dir.c b/fs/overlayfs/dir.c
index ec350d4d921c..7063e0f588cc 100644
--- a/fs/overlayfs/dir.c
+++ b/fs/overlayfs/dir.c
@@ -116,35 +116,35 @@ int ovl_cleanup_and_whiteout(struct dentry *workdir, struct inode *dir,
 	goto out;
 }
 
-static int ovl_mkdir_real(struct inode *dir, struct dentry **newdentry,
-			  umode_t mode)
+static struct dentry *ovl_mkdir_real(struct inode *dir, struct dentry *dentry,
+				     umode_t mode)
 {
 	int err;
-	struct dentry *d, *dentry = *newdentry;
 
 	err = ovl_do_mkdir(dir, dentry, mode);
-	if (err)
-		return err;
-
-	if (likely(!d_unhashed(dentry)))
-		return 0;
+	if (err) {
+		dput(dentry);
+		return ERR_PTR(err);
+	}
 
 	/*
 	 * vfs_mkdir() may succeed and leave the dentry passed
 	 * to it unhashed and negative. If that happens, try to
 	 * lookup a new hashed and positive dentry.
 	 */
-	d = lookup_one_len(dentry->d_name.name, dentry->d_parent,
-			   dentry->d_name.len);
-	if (IS_ERR(d)) {
-		pr_warn("overlayfs: failed lookup after mkdir (%pd2, err=%i).\n",
-			dentry, err);
-		return PTR_ERR(d);
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
 	}
-	dput(dentry);
-	*newdentry = d;
-
-	return 0;
+	return dentry;
 }
 
 struct dentry *ovl_create_real(struct inode *dir, struct dentry *newdentry,
@@ -169,8 +169,7 @@ struct dentry *ovl_create_real(struct inode *dir, struct dentry *newdentry,
 
 		case S_IFDIR:
 			/* mkdir is special... */
-			err =  ovl_mkdir_real(dir, &newdentry, attr->mode);
-			break;
+			return ovl_mkdir_real(dir, newdentry, attr->mode);
 
 		case S_IFCHR:
 		case S_IFBLK:
@@ -193,7 +192,7 @@ struct dentry *ovl_create_real(struct inode *dir, struct dentry *newdentry,
 		 * Not quite sure if non-instantiated dentry is legal or not.
 		 * VFS doesn't seem to care so check and warn here.
 		 */
-		err = -EIO;
+		err = -ENOENT;
 	}
 out:
 	if (err) {
diff --git a/fs/overlayfs/file.c b/fs/overlayfs/file.c
index ca7c3461e424..31f32fc1004b 100644
--- a/fs/overlayfs/file.c
+++ b/fs/overlayfs/file.c
@@ -128,7 +128,7 @@ static int ovl_open(struct inode *inode, struct file *file)
 	/* No longer need these flags, so don't pass them on to underlying fs */
 	file->f_flags &= ~(O_CREAT | O_EXCL | O_NOCTTY | O_TRUNC);
 
-	realfile = ovl_open_realfile(file, ovl_inode_realdata(inode));
+	realfile = ovl_open_realfile(file, ovl_inode_real(file_inode(file)));
 	if (IS_ERR(realfile))
 		return PTR_ERR(realfile);
 
