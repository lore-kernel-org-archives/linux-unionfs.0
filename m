From: Amir Goldstein <amir73il@gmail.com>
Subject: [PATCH 1/4] ovl: fix memory leak on unlink of indexed file
Date: Tue, 18 Sep 2018 16:34:31 +0300
Message-ID: <20180918133434.27437-2-amir73il@gmail.com>
References: <20180918133434.27437-1-amir73il@gmail.com>
Return-path: <stable-owner@vger.kernel.org>
In-Reply-To: <20180918133434.27437-1-amir73il@gmail.com>
Sender: stable-owner@vger.kernel.org
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: Al Viro <viro@zeniv.linux.org.uk>, linux-unionfs@vger.kernel.org, linux-fsdevel@vger.kernel.org, stable@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org

Fixes: caf70cb2ba5d ("ovl: cleanup orphan index entries")
Cc: <stable@vger.kernel.org> # v4.13
Signed-off-by: Amir Goldstein <amir73il@gmail.com>
---
 fs/overlayfs/util.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/fs/overlayfs/util.c b/fs/overlayfs/util.c
index 8cfb62cc8672..ace4fe4c39a9 100644
--- a/fs/overlayfs/util.c
+++ b/fs/overlayfs/util.c
@@ -683,7 +683,7 @@ static void ovl_cleanup_index(struct dentry *dentry)
 	struct dentry *upperdentry = ovl_dentry_upper(dentry);
 	struct dentry *index = NULL;
 	struct inode *inode;
-	struct qstr name;
+	struct qstr name = { };
 	int err;
 
 	err = ovl_get_index_name(lowerdentry, &name);
@@ -726,6 +726,7 @@ static void ovl_cleanup_index(struct dentry *dentry)
 		goto fail;
 
 out:
+	kfree(name.name);
 	dput(index);
 	return;
 
-- 
2.17.1
