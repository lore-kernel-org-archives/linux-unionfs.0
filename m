From: Miklos Szeredi <miklos@szeredi.hu>
Subject: Re: [PATCH] ovl: fix sgid inhertance over whiteout
Date: Fri, 26 Aug 2016 11:50:49 +0200
Message-ID: <20160826095049.GJ25404@veci.piliscsaba.szeredi.hu>
References: <1472112902-11767-1-git-send-email-guaneryu@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-fsdevel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1472112902-11767-1-git-send-email-guaneryu@gmail.com>
Sender: linux-fsdevel-owner@vger.kernel.org
To: Eryu Guan <guaneryu@gmail.com>
Cc: linux-unionfs@vger.kernel.org, linux-fsdevel@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org

On Thu, Aug 25, 2016 at 04:15:02PM +0800, Eryu Guan wrote:
> In commit bb0d2b8ad296 ("ovl: fix sgid on directory"), mode of newly
> created files & dirs over whiteout was updated to pickup sgid bit. But
> it used stat->mode directly, which could not be the correct mode,
> because stat->mode could be tailored against umask.
> 
> This can be demonstrated by the following script:
> 
> umask 022
> mkdir -p lower/dir upper work mnt
> chown test:test lower/dir
> chmod 2775 lower/dir
> touch lower/dir/testdir
> touch lower/dir/testfile
> 
> mount -t overlay -olowerdir=lower,upperdir=upper,workdir=work none mnt
> rm -f mnt/dir/testdir
> mkdir mnt/dir/testdir
> rm -f mnt/dir/testfile
> touch mnt/dir/testfile
> touch mnt/dir/newfile
> ls -l mnt/dir
> 
> -rw-r--r--. 1 root test 0 Aug 25 15:45 newfile
> drwxrwsrwx. 2 root test 6 Aug 25 15:45 testdir
> -rw-rw-rw-. 1 root test 0 Aug 25 15:45 testfile
> 
> testdir and testfile are created over whiteout, the modes contain write
> permission for group and other, but they shouldn't, like 'newfile'.

Hi Eryu,

Yeah, the reson is that we fail to take umask into account.  And that's due to

+       sb->s_flags |= MS_POSIXACL;

in 39a25b2b3762 ("ovl: define ->get_acl() for overlay inodes").

Your patch works around this by relying on the mode of the file created in
workdir, but this only solves part of the problem, and is also not very clean,
since inode_init_owner() should only be called inode of the filesystem itself,
not for foreign inodes.

The below patch should fix this together with the default posix acl inheritance,
which also has an effect on mode of created inode.

It would be nice to get complete test coverage for file creation which is quite
complicated and apparently bug prone.  Variables to test for:

1) create over whiteout or not

   - behavior shouldn't change but different codepaths are taken

2) creating directory, nodirectory, symlink or hard link

   - hard link: no new inode is created, attributes, ACL, etc. of old inode are
     not changed

   - symlink has fix mode

   - if neither sgid or default ACL on parent then create mode calculated based
     on supplied mode and umask

   - otherwise see below

3) parent has sgid or not

   - if sgid is set AND creating directory then inherit sgid

   - if sgid is set then inherit group

4) parent has default ACL or not

   - if parent has default ACL and creating a directory then inherit default ACL

   - if parent has default ACL then set mode and access ACL based on default ACL
     of parent

5) underlying filsystem sets MS_POSIXACL or not

   - codepaths might differ; shouldn't change behavior

   - unfrortunately I don't think there's a filesystem that supports overlayfs
     upperdir but not POSIX ACL, so this needs separate kernel configs to test.

So that's quite a few independent parameters, resulting in lots of cases.  I
guess it's easier to write a generic test case which can test all combinations
above, than to write individual test cases by hand.

Thanks,
Miklos
----

From: Miklos Szeredi <mszeredi@redhat.com>
Subject: ovl: handle umask and posix_acl_default correctly on creation

Setting MS_POSIXACL in sb->s_flags has the side effect of passing mode to
create functions without masking against umask.

Another problem when creating over a whiteout is that the default posix acl
is not inherited from the parent dir (because the real parent dir at the
time of creation is the work directory).

Fix these problems by:

 a) If upper fs does not have MS_POSIXACL, then mask mode with umask.

 b) If creating over a whiteout, call posix_acl_create() to get the
 inherited acls.  After creation (but before moving to the final
 destination) set these acls on the created file.  posix_acl_create() also
 updates the file creation mode as appropriate.

Fixes: 39a25b2b3762 ("ovl: define ->get_acl() for overlay inodes")
Signed-off-by: Miklos Szeredi <mszeredi@redhat.com>
---
 fs/overlayfs/dir.c |   56 +++++++++++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 56 insertions(+)

--- a/fs/overlayfs/dir.c
+++ b/fs/overlayfs/dir.c
@@ -12,6 +12,8 @@
 #include <linux/xattr.h>
 #include <linux/security.h>
 #include <linux/cred.h>
+#include <linux/posix_acl.h>
+#include <linux/posix_acl_xattr.h>
 #include "overlayfs.h"
 
 void ovl_cleanup(struct inode *wdir, struct dentry *wdentry)
@@ -186,6 +188,9 @@ static int ovl_create_upper(struct dentr
 	struct dentry *newdentry;
 	int err;
 
+	if (!hardlink && !IS_POSIXACL(udir))
+		stat->mode &= ~current_umask();
+
 	inode_lock_nested(udir, I_MUTEX_PARENT);
 	newdentry = lookup_one_len(dentry->d_name.name, upperdir,
 				   dentry->d_name.len);
@@ -335,6 +340,32 @@ static struct dentry *ovl_check_empty_an
 	return ret;
 }
 
+static int ovl_set_upper_acl(struct dentry *upperdentry, const char *name,
+			     const struct posix_acl *acl)
+{
+	void *buffer;
+	size_t size;
+	int err;
+
+	if (!IS_ENABLED(CONFIG_FS_POSIX_ACL) || !acl)
+		return 0;
+
+	size = posix_acl_to_xattr(NULL, acl, NULL, 0);
+	buffer = kmalloc(size, GFP_KERNEL);
+	if (!buffer)
+		return -ENOMEM;
+
+	size = posix_acl_to_xattr(&init_user_ns, acl, buffer, size);
+	err = size;
+	if (err < 0)
+		goto out_free;
+
+	err = vfs_setxattr(upperdentry, name, buffer, size, XATTR_CREATE);
+out_free:
+	kfree(buffer);
+	return err;
+}
+
 static int ovl_create_over_whiteout(struct dentry *dentry, struct inode *inode,
 				    struct kstat *stat, const char *link,
 				    struct dentry *hardlink)
@@ -346,10 +377,20 @@ static int ovl_create_over_whiteout(stru
 	struct dentry *upper;
 	struct dentry *newdentry;
 	int err;
+	struct posix_acl *acl, *default_acl;
 
 	if (WARN_ON(!workdir))
 		return -EROFS;
 
+	if (!hardlink) {
+		if (!IS_POSIXACL(udir))
+			stat->mode &= ~current_umask();
+
+		err = posix_acl_create(udir, &stat->mode, &default_acl, &acl);
+		if (err)
+			return err;
+	}
+
 	err = ovl_lock_rename_workdir(workdir, upperdir);
 	if (err)
 		goto out;
@@ -384,6 +425,17 @@ static int ovl_create_over_whiteout(stru
 		if (err)
 			goto out_cleanup;
 	}
+	if (!hardlink) {
+		err = ovl_set_upper_acl(newdentry, XATTR_NAME_POSIX_ACL_ACCESS,
+					acl);
+		if (err)
+			goto out_cleanup;
+
+		err = ovl_set_upper_acl(newdentry, XATTR_NAME_POSIX_ACL_DEFAULT,
+					default_acl);
+		if (err)
+			goto out_cleanup;
+	}
 
 	if (!hardlink && S_ISDIR(stat->mode)) {
 		err = ovl_set_opaque(newdentry);
@@ -410,6 +462,10 @@ static int ovl_create_over_whiteout(stru
 out_unlock:
 	unlock_rename(workdir, upperdir);
 out:
+	if (!hardlink) {
+		posix_acl_release(acl);
+		posix_acl_release(default_acl);
+	}
 	return err;
 
 out_cleanup:


