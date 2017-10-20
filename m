From: Amir Goldstein <amir73il@gmail.com>
Subject: [PATCH v2] ovl: handle ENOENT on index lookup
Date: Fri, 20 Oct 2017 17:19:06 +0300
Message-ID: <1508509146-9697-1-git-send-email-amir73il@gmail.com>
Return-path: <stable-owner@vger.kernel.org>
Sender: stable-owner@vger.kernel.org
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: linux-unionfs@vger.kernel.org, "# v4 . 13" <stable@vger.kernel.org>
List-Id: linux-unionfs@vger.kernel.org

Treat ENOENT from index entry lookup the same way as treating a returned
negative dentry. Apparently, either could be returned if file is not
found, depending on the underlying file system.

Fixes: 359f392ca53e ("ovl: lookup index entry for copy up origin")
Cc: <stable@vger.kernel.org> # v4.13
Signed-off-by: Amir Goldstein <amir73il@gmail.com>
---

Miklos,

Please apply or squash this patch with with "ovl: fix EIO from lookup
of non-indexed upper".

Changes from v1:
- Print the warning also for ENOENT case
- Add body to commit messaage

 fs/overlayfs/namei.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/fs/overlayfs/namei.c b/fs/overlayfs/namei.c
index 49441e8be722..0a72b855f4aa 100644
--- a/fs/overlayfs/namei.c
+++ b/fs/overlayfs/namei.c
@@ -507,6 +507,10 @@ static struct dentry *ovl_lookup_index(struct dentry *dentry,
 	index = lookup_one_len_unlocked(name.name, ofs->indexdir, name.len);
 	if (IS_ERR(index)) {
 		err = PTR_ERR(index);
+		if (err == -ENOENT) {
+			index = NULL;
+			goto notfound;
+		}
 		pr_warn_ratelimited("overlayfs: failed inode index lookup (ino=%lu, key=%*s, err=%i);\n"
 				    "overlayfs: mount with '-o index=off' to disable inodes index.\n",
 				    d_inode(origin)->i_ino, name.len, name.name,
@@ -516,6 +520,7 @@ static struct dentry *ovl_lookup_index(struct dentry *dentry,
 
 	inode = d_inode(index);
 	if (d_is_negative(index)) {
+notfound:
 		if (upper && d_inode(origin)->i_nlink > 1) {
 			pr_warn_ratelimited("overlayfs: hard link with origin but no index (%pd2).\n",
 					    upper);
-- 
2.7.4
