From: Miklos Szeredi <miklos@szeredi.hu>
Subject: Re: [PATCH 0/2] ovl: support NFS as lower layer
Date: Mon, 29 Jun 2015 16:35:58 +0200
Message-ID: <20150629143558.GA6605@tucsk.suse.de>
References: <1433424586-7771-1-git-send-email-miklos@szeredi.hu>
 <559006EB.605@rainbow.by>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-unionfs-owner@vger.kernel.org>
Received: from mail-wi0-f169.google.com ([209.85.212.169]:35927 "EHLO
	mail-wi0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751343AbbF2Of4 (ORCPT
	<rfc822;linux-unionfs@vger.kernel.org>);
	Mon, 29 Jun 2015 10:35:56 -0400
Received: by widjy10 with SMTP id jy10so5391019wid.1
        for <linux-unionfs@vger.kernel.org>; Mon, 29 Jun 2015 07:35:54 -0700 (PDT)
Content-Disposition: inline
In-Reply-To: <559006EB.605@rainbow.by>
Sender: linux-unionfs-owner@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org
To: sa <sa-dev@rainbow.by>
Cc: linux-unionfs@vger.kernel.org

On Sun, Jun 28, 2015 at 05:38:35PM +0300, sa wrote:
> On 04.06.2015 16:29, Miklos Szeredi wrote:
> 
> >Two small patches implementing this follow.  Comments and testing welcome.
> >   git://git.kernel.org/pub/scm/linux/kernel/git/mszeredi/vfs.git overlayfs-next
> >---
> >  fs/overlayfs/super.c | 81 +++++++++++++++++++++++++++++++++++++++++++++++-----
> >  1 file changed, 74 insertions(+), 7 deletions(-)
> 
> Thank you, it works in our environment mostly as expected, except
> of the following:
> files already existing in readonly NFS lowerdir can't be opened
> for writing (but can be deleted). Newly created files are writable
> as expected. The same lowerdir works with aufs without problem.
> Is it a bug or am I missing something?

Is the lower fs exported read-only on the NFS server?

If so, can you please apply the following patch and specify
'default_permissions' mount option?

Thanks,
Miklos

---
 fs/overlayfs/inode.c     |   23 +++++++++++++++++++++++
 fs/overlayfs/overlayfs.h |    3 +++
 fs/overlayfs/super.c     |   28 ++++++++++++++++++++++++++++
 3 files changed, 54 insertions(+)

--- a/fs/overlayfs/overlayfs.h
+++ b/fs/overlayfs/overlayfs.h
@@ -142,7 +142,10 @@ struct dentry *ovl_dentry_upper(struct d
 struct dentry *ovl_dentry_lower(struct dentry *dentry);
 struct dentry *ovl_dentry_real(struct dentry *dentry);
 struct dentry *ovl_entry_real(struct ovl_entry *oe, bool *is_upper);
+struct vfsmount *ovl_entry_mnt_real(struct ovl_entry *oe, struct inode *inode,
+				    bool is_upper);
 struct ovl_dir_cache *ovl_dir_cache(struct dentry *dentry);
+bool ovl_is_default_permissions(struct inode *inode);
 void ovl_set_dir_cache(struct dentry *dentry, struct ovl_dir_cache *cache);
 struct dentry *ovl_workdir(struct dentry *dentry);
 int ovl_want_write(struct dentry *dentry);
--- a/fs/overlayfs/super.c
+++ b/fs/overlayfs/super.c
@@ -30,6 +30,7 @@ struct ovl_config {
 	char *lowerdir;
 	char *upperdir;
 	char *workdir;
+	bool default_permissions;
 };
 
 /* private information held for overlayfs's superblock */
@@ -154,6 +155,18 @@ struct dentry *ovl_entry_real(struct ovl
 	return realdentry;
 }
 
+struct vfsmount *ovl_entry_mnt_real(struct ovl_entry *oe, struct inode *inode,
+				    bool is_upper)
+{
+	if (is_upper) {
+		struct ovl_fs *ofs = inode->i_sb->s_fs_info;
+
+		return ofs->upper_mnt;
+	} else {
+		return oe->numlower ? oe->lowerstack[0].mnt : NULL;
+	}
+}
+
 struct ovl_dir_cache *ovl_dir_cache(struct dentry *dentry)
 {
 	struct ovl_entry *oe = dentry->d_fsdata;
@@ -161,6 +174,13 @@ struct ovl_dir_cache *ovl_dir_cache(stru
 	return oe->cache;
 }
 
+bool ovl_is_default_permissions(struct inode *inode)
+{
+	struct ovl_fs *ofs = inode->i_sb->s_fs_info;
+
+	return ofs->config.default_permissions;
+}
+
 void ovl_set_dir_cache(struct dentry *dentry, struct ovl_dir_cache *cache)
 {
 	struct ovl_entry *oe = dentry->d_fsdata;
@@ -592,6 +612,8 @@ static int ovl_show_options(struct seq_f
 		seq_printf(m, ",upperdir=%s", ufs->config.upperdir);
 		seq_printf(m, ",workdir=%s", ufs->config.workdir);
 	}
+	if (ufs->config.default_permissions)
+		seq_puts(m, ",default_permissions");
 	return 0;
 }
 
@@ -616,6 +638,7 @@ enum {
 	OPT_LOWERDIR,
 	OPT_UPPERDIR,
 	OPT_WORKDIR,
+	OPT_DEFAULT_PERMISSIONS,
 	OPT_ERR,
 };
 
@@ -623,6 +646,7 @@ static const match_table_t ovl_tokens =
 	{OPT_LOWERDIR,			"lowerdir=%s"},
 	{OPT_UPPERDIR,			"upperdir=%s"},
 	{OPT_WORKDIR,			"workdir=%s"},
+	{OPT_DEFAULT_PERMISSIONS,	"default_permissions"},
 	{OPT_ERR,			NULL}
 };
 
@@ -683,6 +707,10 @@ static int ovl_parse_opt(char *opt, stru
 				return -ENOMEM;
 			break;
 
+		case OPT_DEFAULT_PERMISSIONS:
+			config->default_permissions = true;
+			break;
+
 		default:
 			pr_err("overlayfs: unrecognized mount option \"%s\" or missing value\n", p);
 			return -EINVAL;
--- a/fs/overlayfs/inode.c
+++ b/fs/overlayfs/inode.c
@@ -98,6 +98,29 @@ int ovl_permission(struct inode *inode,
 
 	realdentry = ovl_entry_real(oe, &is_upper);
 
+	if (ovl_is_default_permissions(inode)) {
+		struct kstat stat;
+		struct path realpath = { .dentry = realdentry };
+
+		if (mask & MAY_NOT_BLOCK)
+			return -ECHILD;
+
+		realpath.mnt = ovl_entry_mnt_real(oe, inode, is_upper);
+
+		err = vfs_getattr(&realpath, &stat);
+		if (err)
+			return err;
+
+		if ((stat.mode ^ inode->i_mode) & S_IFMT)
+			return -ESTALE;
+
+		inode->i_mode = stat.mode;
+		inode->i_uid = stat.uid;
+		inode->i_gid = stat.gid;
+
+		return generic_permission(inode, mask);
+	}
+
 	/* Careful in RCU walk mode */
 	realinode = ACCESS_ONCE(realdentry->d_inode);
 	if (!realinode) {
