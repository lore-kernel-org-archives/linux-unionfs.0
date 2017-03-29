From: Kees Cook <keescook@chromium.org>
Subject: [PATCH] ovl: Use designated initializers
Date: Wed, 29 Mar 2017 14:02:19 -0700
Message-ID: <20170329210219.GA39900@beast>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
To: linux-kernel@vger.kernel.org
Cc: Miklos Szeredi <miklos@szeredi.hu>, linux-unionfs@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org

Prepare to mark sensitive kernel structures for randomization by making
sure they're using designated initializers. These were identified during
allyesconfig builds of x86, arm, and arm64, with most initializer fixes
extracted from grsecurity.

For these cases, use { }, which will be zero-filled, instead of
undesignated NULLs.

Signed-off-by: Kees Cook <keescook@chromium.org>
---
 fs/overlayfs/super.c | 4 ++--
 fs/overlayfs/util.c  | 2 +-
 2 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/fs/overlayfs/super.c b/fs/overlayfs/super.c
index c9e70d39c1ea..07c8793efb1d 100644
--- a/fs/overlayfs/super.c
+++ b/fs/overlayfs/super.c
@@ -709,8 +709,8 @@ static const struct xattr_handler *ovl_xattr_handlers[] = {
 
 static int ovl_fill_super(struct super_block *sb, void *data, int silent)
 {
-	struct path upperpath = { NULL, NULL };
-	struct path workpath = { NULL, NULL };
+	struct path upperpath = { };
+	struct path workpath = { };
 	struct dentry *root_dentry;
 	struct inode *realinode;
 	struct ovl_entry *oe;
diff --git a/fs/overlayfs/util.c b/fs/overlayfs/util.c
index 6e610a205e15..590fb098f763 100644
--- a/fs/overlayfs/util.c
+++ b/fs/overlayfs/util.c
@@ -100,7 +100,7 @@ void ovl_path_lower(struct dentry *dentry, struct path *path)
 {
 	struct ovl_entry *oe = dentry->d_fsdata;
 
-	*path = oe->numlower ? oe->lowerstack[0] : (struct path) { NULL, NULL };
+	*path = oe->numlower ? oe->lowerstack[0] : (struct path) { };
 }
 
 enum ovl_path_type ovl_path_real(struct dentry *dentry, struct path *path)
-- 
2.7.4


-- 
Kees Cook
Pixel Security
