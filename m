Return-Path: <viro@ftp.linux.org.uk>
Date: Fri, 18 May 2018 16:40:42 +0100
From: Al Viro <viro@ZenIV.linux.org.uk>
Subject: Re: [PATCH v4 9/9] ovl: use iget5_prealloc() to hash a newly created
 inode
Message-ID: <20180518154042.GT30522@ZenIV.linux.org.uk>
References: <1526632177-28832-1-git-send-email-amir73il@gmail.com>
 <1526632177-28832-10-git-send-email-amir73il@gmail.com>
 <20180518150353.GS30522@ZenIV.linux.org.uk>
 <CAJfpegvAx1yNkDJNcCa-YZOCpz1OgeWK8SE341-iE8L5E8wsKw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAJfpegvAx1yNkDJNcCa-YZOCpz1OgeWK8SE341-iE8L5E8wsKw@mail.gmail.com>
Sender: Al Viro <viro@ftp.linux.org.uk>
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: Amir Goldstein <amir73il@gmail.com>, Vivek Goyal <vgoyal@redhat.com>, overlayfs <linux-unionfs@vger.kernel.org>
List-ID: <linux-unionfs@vger.kernel.org>

On Fri, May 18, 2018 at 05:11:20PM +0200, Miklos Szeredi wrote:
> On Fri, May 18, 2018 at 5:03 PM, Al Viro <viro@zeniv.linux.org.uk> wrote:
> > On Fri, May 18, 2018 at 11:29:37AM +0300, Amir Goldstein wrote:
> >> Currently, there is a small window where ovl_obtain_alias() can
> >> race with ovl_instantiate() and create two different overlay inodes
> >> with the same underlying real non-dir non-hardlink inode.
> >>
> >> The race requires an adversary to guess the file handle of the
> >> yet to be created upper inode and decode the guessed file handle
> >> after ovl_creat_real(), but before ovl_instantiate().
> >> This race does not affect overlay directory inodes, because those
> >> are decoded via ovl_lookup_real() and not with ovl_obtain_alias().
> >>
> >> This patch fixes the race, by using iget5_prealloc() to add a newly
> >> created inode to cache.
> >
> > Mind explaining what the hell is wrong with insert_inode_locked4()?
> 
> That it doesn't return the old inode if found.
> 
> Btw, these functions are eerily similar, and it'd be nice to reduce
> the number of them.

IMO you are using the wrong model; just create the underlying object,
then do what lookup would for overlayfs inode creation, then
d_splice_alias() + dput() of return value (if non-IS_ERR).

Local filesystems are not a good match for what you have there; something
like NFS fits better.  FWIW, NFS patch I've got here is

diff --git a/fs/nfs/dir.c b/fs/nfs/dir.c
index 73f8b43d988c..8aff171a680a 100644
--- a/fs/nfs/dir.c
+++ b/fs/nfs/dir.c
@@ -1625,6 +1625,7 @@ int nfs_instantiate(struct dentry *dentry, struct nfs_fh *fhandle,
 	struct dentry *parent = dget_parent(dentry);
 	struct inode *dir = d_inode(parent);
 	struct inode *inode;
+	struct dentry *d;
 	int error = -EACCES;
 
 	d_drop(dentry);
@@ -1645,10 +1646,12 @@ int nfs_instantiate(struct dentry *dentry, struct nfs_fh *fhandle,
 			goto out_error;
 	}
 	inode = nfs_fhget(dentry->d_sb, fhandle, fattr, label);
-	error = PTR_ERR(inode);
-	if (IS_ERR(inode))
+	d = d_splice_alias(inode, dentry);
+	if (IS_ERR(d)) {
+		error = PTR_ERR(d);
 		goto out_error;
-	d_add(dentry, inode);
+	}
+	dput(d);
 out:
 	dput(parent);
 	return 0;
