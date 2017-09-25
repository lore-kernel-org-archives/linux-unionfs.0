From: Amir Goldstein <amir73il@gmail.com>
Subject: [PATCH 2/4] ovl: fix error value printed in ovl_lookup_index()
Date: Mon, 25 Sep 2017 12:36:19 +0300
Message-ID: <1506332181-19319-3-git-send-email-amir73il@gmail.com>
References: <1506332181-19319-1-git-send-email-amir73il@gmail.com>
Return-path: <stable-owner@vger.kernel.org>
In-Reply-To: <1506332181-19319-1-git-send-email-amir73il@gmail.com>
Sender: stable-owner@vger.kernel.org
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: linux-unionfs@vger.kernel.org, "# v4 . 13" <stable@vger.kernel.org>
List-Id: linux-unionfs@vger.kernel.org

Fixes: 359f392ca53e ("ovl: lookup index entry for copy up origin")
Cc: <stable@vger.kernel.org> # v4.13
Signed-off-by: Amir Goldstein <amir73il@gmail.com>
---
 fs/overlayfs/namei.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/fs/overlayfs/namei.c b/fs/overlayfs/namei.c
index c3addd1114f1..654bea1a5ac9 100644
--- a/fs/overlayfs/namei.c
+++ b/fs/overlayfs/namei.c
@@ -506,6 +506,7 @@ static struct dentry *ovl_lookup_index(struct dentry *dentry,
 
 	index = lookup_one_len_unlocked(name.name, ofs->indexdir, name.len);
 	if (IS_ERR(index)) {
+		err = PTR_ERR(index);
 		pr_warn_ratelimited("overlayfs: failed inode index lookup (ino=%lu, key=%*s, err=%i);\n"
 				    "overlayfs: mount with '-o index=off' to disable inodes index.\n",
 				    d_inode(origin)->i_ino, name.len, name.name,
-- 
2.7.4
