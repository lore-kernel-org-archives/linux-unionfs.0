From: Amir Goldstein <amir73il@gmail.com>
Subject: [PATCH v2] tmpfs: generate random sb->s_uuid
Date: Thu, 18 May 2017 15:29:33 +0300
Message-ID: <1495110573-9473-1-git-send-email-amir73il@gmail.com>
Return-path: <linux-fsdevel-owner@vger.kernel.org>
Sender: linux-fsdevel-owner@vger.kernel.org
To: Christoph Hellwig <hch@lst.de>
Cc: Andy Shevchenko <andriy.shevchenko@linux.intel.com>, Miklos Szeredi <miklos@szeredi.hu>, linux-unionfs@vger.kernel.org, linux-fsdevel@vger.kernel.org, Hugh Dickins <hughd@google.com>, Andrew Morton <akpm@linux-foundation.org>
List-Id: linux-unionfs@vger.kernel.org

This is used by overlayfs to encode intrasystem unique file handles.

Suggested-by: Miklos Szeredi <mszeredi@redhat.com>
Cc: Hugh Dickins <hughd@google.com>
Cc: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Amir Goldstein <amir73il@gmail.com>
---
 mm/shmem.c | 2 ++
 1 file changed, 2 insertions(+)

Christoph,

Please apply to your uuid branch.

Thanks,
Amir.

diff --git a/mm/shmem.c b/mm/shmem.c
index e67d6ba..cbd4521 100644
--- a/mm/shmem.c
+++ b/mm/shmem.c
@@ -75,6 +75,7 @@ static struct vfsmount *shm_mnt;
 #include <uapi/linux/memfd.h>
 #include <linux/userfaultfd_k.h>
 #include <linux/rmap.h>
+#include <linux/uuid.h>
 
 #include <linux/uaccess.h>
 #include <asm/pgtable.h>
@@ -3761,6 +3762,7 @@ int shmem_fill_super(struct super_block *sb, void *data, int silent)
 #ifdef CONFIG_TMPFS_POSIX_ACL
 	sb->s_flags |= MS_POSIXACL;
 #endif
+	uuid_gen(&sb->s_uuid);
 
 	inode = shmem_get_inode(sb, NULL, S_IFDIR | sbinfo->mode, 0, VM_NORESERVE);
 	if (!inode)
-- 
2.7.4
