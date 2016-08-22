From: Andreas Gruenbacher <agruenba@redhat.com>
Subject: [PATCH v4 01/20] ovl: Fix OVL_XATTR_PREFIX
Date: Mon, 22 Aug 2016 23:21:49 +0200
Message-ID: <1471900928-21588-2-git-send-email-agruenba@redhat.com>
References: <1471900928-21588-1-git-send-email-agruenba@redhat.com>
Return-path: <ecryptfs-owner@vger.kernel.org>
In-Reply-To: <1471900928-21588-1-git-send-email-agruenba@redhat.com>
Sender: ecryptfs-owner@vger.kernel.org
To: Alexander Viro <viro@zeniv.linux.org.uk>
Cc: Andreas Gruenbacher <agruenba@redhat.com>, linux-fsdevel@vger.kernel.org, Tyler Hicks <tyhicks@canonical.com>, ecryptfs@vger.kernel.org, Miklos Szeredi <miklos@szeredi.hu>, linux-unionfs@vger.kernel.org, David Howells <dhowells@redhat.com>, Serge Hallyn <serge.hallyn@canonical.com>, Dmitry Kasatkin <dmitry.kasatkin@gmail.com>, linux-ima-devel@lists.sourceforge.net, Paul Moore <paul@paul-moore.com>, Stephen Smalley <sds@tycho.nsa.gov>, Eric Paris <eparis@parisplace.org>, Casey Schaufler <casey@schaufler-ca.com>, Oleg Drokin <oleg.drokin@intel.com>, Andreas Dilger <andreas.dilger@intel.com>
List-Id: linux-unionfs@vger.kernel.org

Make sure ovl_own_xattr_handler only matches attribute names starting
with "overlay.", not "overlayXXX".

Signed-off-by: Andreas Gruenbacher <agruenba@redhat.com>
---
 fs/overlayfs/inode.c     | 5 ++---
 fs/overlayfs/overlayfs.h | 4 ++--
 2 files changed, 4 insertions(+), 5 deletions(-)

diff --git a/fs/overlayfs/inode.c b/fs/overlayfs/inode.c
index 1b885c1..859e42c 100644
--- a/fs/overlayfs/inode.c
+++ b/fs/overlayfs/inode.c
@@ -193,9 +193,8 @@ static int ovl_readlink(struct dentry *dentry, char __user *buf, int bufsiz)
 
 static bool ovl_is_private_xattr(const char *name)
 {
-#define OVL_XATTR_PRE_NAME OVL_XATTR_PREFIX "."
-	return strncmp(name, OVL_XATTR_PRE_NAME,
-		       sizeof(OVL_XATTR_PRE_NAME) - 1) == 0;
+	return strncmp(name, OVL_XATTR_PREFIX,
+		       sizeof(OVL_XATTR_PREFIX) - 1) == 0;
 }
 
 int ovl_setxattr(struct dentry *dentry, struct inode *inode,
diff --git a/fs/overlayfs/overlayfs.h b/fs/overlayfs/overlayfs.h
index e4f5c95..77fd667 100644
--- a/fs/overlayfs/overlayfs.h
+++ b/fs/overlayfs/overlayfs.h
@@ -24,8 +24,8 @@ enum ovl_path_type {
 	(OVL_TYPE_MERGE(type) || !OVL_TYPE_UPPER(type))
 
 
-#define OVL_XATTR_PREFIX XATTR_TRUSTED_PREFIX "overlay"
-#define OVL_XATTR_OPAQUE OVL_XATTR_PREFIX ".opaque"
+#define OVL_XATTR_PREFIX XATTR_TRUSTED_PREFIX "overlay."
+#define OVL_XATTR_OPAQUE OVL_XATTR_PREFIX "opaque"
 
 #define OVL_ISUPPER_MASK 1UL
 
-- 
2.7.4
