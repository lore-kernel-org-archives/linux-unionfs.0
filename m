From: Sohom Bhattacharjee <soham.bhattacharjee15@gmail.com>
Subject: [PATCH] fs: overlayfs:  fixed coding style warning
Date: Tue, 15 Mar 2016 20:57:59 +0530
Message-ID: <20160315152759.GA10382@sam>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: linux-unionfs@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org

This patch fixes a newline warning found by the checkpatch.pl tool

Signed-off-by: Sohom-Bhattacharjee <soham.bhattacharjee15@gmail.com>
---
 fs/overlayfs/copy_up.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/fs/overlayfs/copy_up.c b/fs/overlayfs/copy_up.c
index d894e7c..8a8a5ce 100644
--- a/fs/overlayfs/copy_up.c
+++ b/fs/overlayfs/copy_up.c
@@ -235,6 +235,7 @@ static int ovl_copy_up_locked(struct dentry *workdir, struct dentry *upperdir,
 
 	if (S_ISREG(stat->mode)) {
 		struct path upperpath;
+
 		ovl_path_upper(dentry, &upperpath);
 		BUG_ON(upperpath.dentry != NULL);
 		upperpath.dentry = newdentry;
-- 
2.5.0
