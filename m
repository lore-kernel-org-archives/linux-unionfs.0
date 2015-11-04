From: Stephen Hemminger <stephen-OTpzqLSitTUnbdJkjeBofR2eb7JE58TQ@public.gmane.org>
Subject: [PATCH] overlayfs: move super block magic number to magic.h
Date: Wed, 4 Nov 2015 10:59:52 -0800
Message-ID: <20151104105952.7232543a@xeon-e3>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Miklos Szeredi <miklos-sUDqSbJrdHQHWmgEVkV9KA@public.gmane.org>, Hannes Frederic Sowa <hannes-tFNcAqjVMyqKXQKiL6tip0B+6BGkLq7r@public.gmane.org>, Steven Rostedt <rostedt-nx8X9YLhiw1AfugRpC6u6w@public.gmane.org>, Al Viro <viro-3bDd1+5oDREiFSDQTTA3OLVCufUGDwFn@public.gmane.org>, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: linux-unionfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-unionfs@vger.kernel.org

The overlayfs file system is not recognized by programs
like tail because the magic number is not in standard header location.

Move it so that the value will propagate on for the GNU library
and utilities. Needs to go in the fstatfs manual page as well.

Signed-off-by: Stephen Hemminger <stephen-OTpzqLSitTUnbdJkjeBofR2eb7JE58TQ@public.gmane.org>
---
 fs/overlayfs/super.c       | 2 --
 include/uapi/linux/magic.h | 1 +
 2 files changed, 1 insertion(+), 2 deletions(-)

diff --git a/fs/overlayfs/super.c b/fs/overlayfs/super.c
index e38ee0f..a389675 100644
--- a/fs/overlayfs/super.c
+++ b/fs/overlayfs/super.c
@@ -24,8 +24,6 @@ MODULE_AUTHOR("Miklos Szeredi <miklos-sUDqSbJrdHQHWmgEVkV9KA@public.gmane.org>");
 MODULE_DESCRIPTION("Overlay filesystem");
 MODULE_LICENSE("GPL");
 
-#define OVERLAYFS_SUPER_MAGIC 0x794c7630
-
 struct ovl_config {
 	char *lowerdir;
 	char *upperdir;
diff --git a/include/uapi/linux/magic.h b/include/uapi/linux/magic.h
index accb036..63ccb03 100644
--- a/include/uapi/linux/magic.h
+++ b/include/uapi/linux/magic.h
@@ -31,6 +31,7 @@
 #define PSTOREFS_MAGIC		0x6165676C
 #define EFIVARFS_MAGIC		0xde5e81e4
 #define HOSTFS_SUPER_MAGIC	0x00c0ffee
+#define OVERLAYFS_SUPER_MAGIC	0x794c7630
 
 #define MINIX_SUPER_MAGIC	0x137F		/* minix v1 fs, 14 char names */
 #define MINIX_SUPER_MAGIC2	0x138F		/* minix v1 fs, 30 char names */
-- 
2.1.4
