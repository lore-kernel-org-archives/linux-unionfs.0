From: Arnd Bergmann <arnd@arndb.de>
Subject: [PATCH] ovl: fix bogus -Wmaybe-unitialized warning
Date: Mon, 17 Jun 2019 14:39:29 +0200
Message-ID: <20190617123947.941417-1-arnd@arndb.de>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: Arnd Bergmann <arnd@arndb.de>, syzbot+9c69c282adc4edd2b540@syzkaller.appspotmail.com, Amir Goldstein <amir73il@gmail.com>, Miklos Szeredi <mszeredi@redhat.com>, Vivek Goyal <vgoyal@redhat.com>, linux-unionfs@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org

gcc gets a bit confused by the logic in ovl_setup_trap() and
can't figure out whether the local 'trap' variable in the caller
was initialized or not:

fs/overlayfs/super.c: In function 'ovl_fill_super':
fs/overlayfs/super.c:1333:4: error: 'trap' may be used uninitialized in this function [-Werror=maybe-uninitialized]
    iput(trap);
    ^~~~~~~~~~
fs/overlayfs/super.c:1312:17: note: 'trap' was declared here

Reword slightly to make it easier for the compiler to understand.

Fixes: 146d62e5a586 ("ovl: detect overlapping layers")
Signed-off-by: Arnd Bergmann <arnd@arndb.de>
---
 fs/overlayfs/super.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/fs/overlayfs/super.c b/fs/overlayfs/super.c
index 746ea36f3171..d150ad6dba94 100644
--- a/fs/overlayfs/super.c
+++ b/fs/overlayfs/super.c
@@ -995,8 +995,8 @@ static int ovl_setup_trap(struct super_block *sb, struct dentry *dir,
 	int err;
 
 	trap = ovl_get_trap_inode(sb, dir);
-	err = PTR_ERR(trap);
-	if (IS_ERR(trap)) {
+	err = PTR_ERR_OR_ZERO(trap);
+	if (err) {
 		if (err == -ELOOP)
 			pr_err("overlayfs: conflicting %s path\n", name);
 		return err;
-- 
2.20.0
