From: Miklos Szeredi <miklos@szeredi.hu>
Subject: Re: [PATCH] ovl: don't expose EOPENSTALE to userspace
Date: Wed, 26 Apr 2017 15:47:31 +0200
Message-ID: <20170426134731.GB5214@veci.piliscsaba.szeredi.hu>
References: <1493128675-24331-1-git-send-email-amir73il@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-fsdevel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1493128675-24331-1-git-send-email-amir73il@gmail.com>
Sender: linux-fsdevel-owner@vger.kernel.org
To: Amir Goldstein <amir73il@gmail.com>
Cc: Trond Myklebust <trondmy@primarydata.com>, Jeff Layton <jlayton@poochiereds.net>, "J . Bruce Fields" <bfields@fieldses.org>, Tyler Hicks <tyhicks@canonical.com>, Al Viro <viro@zeniv.linux.org.uk>, linux-unionfs@vger.kernel.org, linux-fsdevel@vger.kernel.org, stable@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org

On Tue, Apr 25, 2017 at 04:57:55PM +0300, Amir Goldstein wrote:
> An overlay dentry holds a lower dentry that may belong to an NFS mount.
> 
> Overlayfs calls ovl_path_open() to get a file descriptor of a lower file
> for copying up its data and for a lower directory for listing its
> content.
> 
> If that lower dentry gets invalidated after ovl_dentry_revalidate() and
> before ovl_path_open(), the internal error code 518 (EOPENSTALE), which
> is not a POSIX error code, will be exposed to the user.
> 
> Check the internal return value -EOPENSTALE in ovl_path_open(), just
> the same as it is checked in path_openat() and replace it with the POSIX
> error code ESTALE.

I'm looking at the EOPENSTALE story and it very much looks like we can just
replace the single use with ESTALE and handle the lookup retry logic nuances
inside the lookup code...

Below is untested patch.

Thanks,
Miklos


diff --git a/Documentation/filesystems/path-lookup.md b/Documentation/filesystems/path-lookup.md
index 1b39e084a2b2..41f2b25b6ac3 100644
--- a/Documentation/filesystems/path-lookup.md
+++ b/Documentation/filesystems/path-lookup.md
@@ -1,4 +1,4 @@
-<head>
+\<head>
 <style> p { max-width:50em} ol, ul {max-width: 40em}</style>
 </head>
 
@@ -1150,11 +1150,10 @@ code.
  created file will be performed by `vfs_open()`, just as if the name
  were found in the dcache.
 
-2. `vfs_open()` can fail with `-EOPENSTALE` if the cached information
- wasn't quite current enough.  Rather than restarting the lookup from
- the top with `LOOKUP_REVAL` set, `lookup_open()` is called instead,
- giving the filesystem a chance to resolve small inconsistencies.
- If that doesn't work, only then is the lookup restarted from the top.
+2. `vfs_open()` can fail with `-ESTALE` if the cached information wasn't
+ quite current enough.  The lookup will be restarted first without
+ LOOKUP_REVAL and then with.
+
 
 3. An open with O_CREAT **does** follow a symlink in the final component,
      unlike other creation system calls (like `mkdir`).  So the sequence:
diff --git a/fs/namei.c b/fs/namei.c
index d41fab78798b..af0b31340ada 100644
--- a/fs/namei.c
+++ b/fs/namei.c
@@ -3187,7 +3187,7 @@ static int lookup_open(struct nameidata *nd, struct path *path,
  */
 static int do_last(struct nameidata *nd,
 		   struct file *file, const struct open_flags *op,
-		   int *opened)
+		   int *opened, bool firstpass)
 {
 	struct dentry *dir = nd->path.dentry;
 	int open_flag = op->open_flag;
@@ -3342,8 +3342,16 @@ static int do_last(struct nameidata *nd,
 		goto out;
 	BUG_ON(*opened & FILE_OPENED); /* once it's opened, it's opened */
 	error = vfs_open(&nd->path, file, current_cred());
-	if (error)
+	if (error) {
+		/*
+		 * If we got ESTALE here it likely means that only need to
+		 * revalidate the last component.  So first restart without
+		 * LOOKUP_REVAL.
+		 */
+		if (error == -ESTALE && firstpass)
+			error = -ECHILD;
 		goto out;
+	}
 	*opened |= FILE_OPENED;
 opened:
 	error = open_check_o_direct(file);
@@ -3458,6 +3466,7 @@ static struct file *path_openat(struct nameidata *nd,
 	struct file *file;
 	int opened = 0;
 	int error;
+	bool firstpass = flags & LOOKUP_RCU;
 
 	file = get_empty_filp();
 	if (IS_ERR(file))
@@ -3483,7 +3492,7 @@ static struct file *path_openat(struct nameidata *nd,
 		return ERR_CAST(s);
 	}
 	while (!(error = link_path_walk(s, nd)) &&
-		(error = do_last(nd, file, op, &opened)) > 0) {
+	       (error = do_last(nd, file, op, &opened, firstpass)) > 0) {
 		nd->flags &= ~(LOOKUP_OPEN|LOOKUP_CREATE|LOOKUP_EXCL);
 		s = trailing_symlink(nd);
 		if (IS_ERR(s)) {
@@ -3497,15 +3506,9 @@ static struct file *path_openat(struct nameidata *nd,
 		BUG_ON(!error);
 		put_filp(file);
 	}
-	if (unlikely(error)) {
-		if (error == -EOPENSTALE) {
-			if (flags & LOOKUP_RCU)
-				error = -ECHILD;
-			else
-				error = -ESTALE;
-		}
+	if (unlikely(error))
 		file = ERR_PTR(error);
-	}
+
 	return file;
 }
 
diff --git a/fs/nfs/nfs4file.c b/fs/nfs/nfs4file.c
index 0efba77789b9..ecd2e1b165b1 100644
--- a/fs/nfs/nfs4file.c
+++ b/fs/nfs/nfs4file.c
@@ -39,7 +39,7 @@ nfs4_file_open(struct inode *inode, struct file *filp)
 	 *
 	 * We only get this far for a cached positive dentry.  We skipped
 	 * revalidation, so handle it here by dropping the dentry and returning
-	 * -EOPENSTALE.  The VFS will retry the lookup/create/open.
+	 * -ESTALE.  The VFS will retry the lookup/create/open.
 	 */
 
 	dprintk("NFS: open file(%pd2)\n", dentry);
@@ -99,7 +99,7 @@ nfs4_file_open(struct inode *inode, struct file *filp)
 
 out_drop:
 	d_drop(dentry);
-	err = -EOPENSTALE;
+	err = -ESTALE;
 	goto out_put_ctx;
 }
 
diff --git a/include/linux/errno.h b/include/linux/errno.h
index 7ce9fb1b7d28..28a979008af2 100644
--- a/include/linux/errno.h
+++ b/include/linux/errno.h
@@ -16,7 +16,6 @@
 #define ENOIOCTLCMD	515	/* No ioctl command */
 #define ERESTART_RESTARTBLOCK 516 /* restart by calling sys_restart_syscall */
 #define EPROBE_DEFER	517	/* Driver requests probe retry */
-#define EOPENSTALE	518	/* open found a stale dentry */
 
 /* Defined for the NFSv3 protocol */
 #define EBADHANDLE	521	/* Illegal NFS file handle */
