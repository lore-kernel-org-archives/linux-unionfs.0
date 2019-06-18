From: Nicolas Schier <nicolas@fjasle.eu>
Subject: [PATCH v2] ovl: fix typo in MODULE_PARM_DESC
Date: Tue, 18 Jun 2019 09:50:29 +0200
Message-ID: <20190618075029.3996-1-nicolas@fjasle.eu>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: Amir Goldstein <amir73il@gmail.com>, Vivek Goyal <vgoyal@redhat.com>, linux-unionfs@vger.kernel.org, linux-kernel@vger.kernel.org, Nicolas Schier <n.schier@avm.de>
List-Id: linux-unionfs@vger.kernel.org

From: Nicolas Schier <n.schier@avm.de>

Change first argument of MODULE_PARM_DESC() calls, such that each of
them matches the actual module parameter name.  The patch results in
changing (the 'parm' section from) the output of `modinfo overlay`:

    parm: ovl_check_copy_up:Obsolete; does nothing
    parm: redirect_max:ushort
    parm: ovl_redirect_max:Maximum length of absolute redirect xattr value
    parm: redirect_dir:bool
    parm: ovl_redirect_dir_def:Default to on or off for the redirect_ [...]
    parm: redirect_always_follow:bool
    parm: ovl_redirect_always_follow:Follow redirects even if [...]
    parm: index:bool
    parm: ovl_index_def:Default to on or off for the inodes index [...]
    parm: nfs_export:bool
    parm: ovl_nfs_export_def:Default to on or off for the NFS export [...]
    parm: xino_auto:bool
    parm: ovl_xino_auto_def:Auto enable xino feature
    parm: metacopy:bool
    parm: ovl_metacopy_def:Default to on or off for the metadata only [...]

into:

    parm: check_copy_up:Obsolete; does nothing
    parm: redirect_max:Maximum length of absolute redirect xattr [...]
    parm: redirect_dir:Default to on or off for the redirect_dir [...]
    parm: redirect_always_follow:Follow redirects even if [...]
    parm: index:Default to on or off for the inodes index feature [...]
    parm: nfs_export:Default to on or off for the NFS export feature [...]
    parm: xino_auto:Auto enable xino feature (bool)
    parm: metacopy:Default to on or off for the metadata only copy up [...]

Signed-off-by: Nicolas Schier <n.schier@avm.de>
---

Changes since v1:
 - update/fix commit message wording (now completely checkpatch
   compliant)

 fs/overlayfs/copy_up.c |  2 +-
 fs/overlayfs/dir.c     |  2 +-
 fs/overlayfs/super.c   | 12 ++++++------
 3 files changed, 8 insertions(+), 8 deletions(-)

diff --git a/fs/overlayfs/copy_up.c b/fs/overlayfs/copy_up.c
index 9e62dcf06fc4..e9cdc453f247 100644
--- a/fs/overlayfs/copy_up.c
+++ b/fs/overlayfs/copy_up.c
@@ -37,7 +37,7 @@ static int ovl_ccup_get(char *buf, const struct kernel_param *param)
 }
 
 module_param_call(check_copy_up, ovl_ccup_set, ovl_ccup_get, NULL, 0644);
-MODULE_PARM_DESC(ovl_check_copy_up, "Obsolete; does nothing");
+MODULE_PARM_DESC(check_copy_up, "Obsolete; does nothing");
 
 int ovl_copy_xattr(struct dentry *old, struct dentry *new)
 {
diff --git a/fs/overlayfs/dir.c b/fs/overlayfs/dir.c
index 82c129bfe58d..dbcb3ff588aa 100644
--- a/fs/overlayfs/dir.c
+++ b/fs/overlayfs/dir.c
@@ -21,7 +21,7 @@
 
 static unsigned short ovl_redirect_max = 256;
 module_param_named(redirect_max, ovl_redirect_max, ushort, 0644);
-MODULE_PARM_DESC(ovl_redirect_max,
+MODULE_PARM_DESC(redirect_max,
 		 "Maximum length of absolute redirect xattr value");
 
 static int ovl_set_redirect(struct dentry *dentry, bool samedir);
diff --git a/fs/overlayfs/super.c b/fs/overlayfs/super.c
index 0116735cc321..eb32e68f1a83 100644
--- a/fs/overlayfs/super.c
+++ b/fs/overlayfs/super.c
@@ -31,29 +31,29 @@ struct ovl_dir_cache;
 
 static bool ovl_redirect_dir_def = IS_ENABLED(CONFIG_OVERLAY_FS_REDIRECT_DIR);
 module_param_named(redirect_dir, ovl_redirect_dir_def, bool, 0644);
-MODULE_PARM_DESC(ovl_redirect_dir_def,
+MODULE_PARM_DESC(redirect_dir,
 		 "Default to on or off for the redirect_dir feature");
 
 static bool ovl_redirect_always_follow =
 	IS_ENABLED(CONFIG_OVERLAY_FS_REDIRECT_ALWAYS_FOLLOW);
 module_param_named(redirect_always_follow, ovl_redirect_always_follow,
 		   bool, 0644);
-MODULE_PARM_DESC(ovl_redirect_always_follow,
+MODULE_PARM_DESC(redirect_always_follow,
 		 "Follow redirects even if redirect_dir feature is turned off");
 
 static bool ovl_index_def = IS_ENABLED(CONFIG_OVERLAY_FS_INDEX);
 module_param_named(index, ovl_index_def, bool, 0644);
-MODULE_PARM_DESC(ovl_index_def,
+MODULE_PARM_DESC(index,
 		 "Default to on or off for the inodes index feature");
 
 static bool ovl_nfs_export_def = IS_ENABLED(CONFIG_OVERLAY_FS_NFS_EXPORT);
 module_param_named(nfs_export, ovl_nfs_export_def, bool, 0644);
-MODULE_PARM_DESC(ovl_nfs_export_def,
+MODULE_PARM_DESC(nfs_export,
 		 "Default to on or off for the NFS export feature");
 
 static bool ovl_xino_auto_def = IS_ENABLED(CONFIG_OVERLAY_FS_XINO_AUTO);
 module_param_named(xino_auto, ovl_xino_auto_def, bool, 0644);
-MODULE_PARM_DESC(ovl_xino_auto_def,
+MODULE_PARM_DESC(xino_auto,
 		 "Auto enable xino feature");
 
 static void ovl_entry_stack_free(struct ovl_entry *oe)
@@ -66,7 +66,7 @@ static void ovl_entry_stack_free(struct ovl_entry *oe)
 
 static bool ovl_metacopy_def = IS_ENABLED(CONFIG_OVERLAY_FS_METACOPY);
 module_param_named(metacopy, ovl_metacopy_def, bool, 0644);
-MODULE_PARM_DESC(ovl_metacopy_def,
+MODULE_PARM_DESC(metacopy,
 		 "Default to on or off for the metadata only copy up feature");
 
 static void ovl_dentry_release(struct dentry *dentry)
-- 
2.20.1
