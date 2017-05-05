From: Amir Goldstein <amir73il@gmail.com>
Subject: [PATCH] tmpfs: generate random sb->s_uuid
Date: Fri,  5 May 2017 12:44:28 +0300
Message-ID: <1493977468-21143-1-git-send-email-amir73il@gmail.com>
Return-path: <linux-unionfs-owner@vger.kernel.org>
Received: from mail-wr0-f193.google.com ([209.85.128.193]:33177 "EHLO
        mail-wr0-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751235AbdEEJoY (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Fri, 5 May 2017 05:44:24 -0400
Sender: linux-unionfs-owner@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: Al Viro <viro@zeniv.linux.org.uk>, linux-unionfs@vger.kernel.org, linux-fsdevel@vger.kernel.org, Hugh Dickins <hughd@google.com>, Andrew Morton <akpm@linux-foundation.org>

This is used by overlayfs to encode intrasystem unique file handles.

Suggested-by: Miklos Szeredi <mszeredi@redhat.com>
Cc: Hugh Dickins <hughd@google.com>
Cc: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Amir Goldstein <amir73il@gmail.com>
---
 mm/shmem.c | 1 +
 1 file changed, 1 insertion(+)

Miklos,

Attached the simple patch you suggested.
With this patch the unionmount-testsuite run:
./run --ov=0 --samefs

Passes with (default) tmpfs as samefs.

Hugh,

Can you please Ack.

FYI, both xfs and ubifs have patches queued to export thier on-disk
uuid to sb->s_uuid.

Thanks,
Amir.

diff --git a/mm/shmem.c b/mm/shmem.c
index e67d6ba..b73f832 100644
--- a/mm/shmem.c
+++ b/mm/shmem.c
@@ -3761,6 +3761,7 @@ int shmem_fill_super(struct super_block *sb, void *data, int silent)
 #ifdef CONFIG_TMPFS_POSIX_ACL
 	sb->s_flags |= MS_POSIXACL;
 #endif
+	generate_random_uuid(sb->s_uuid);
 
 	inode = shmem_get_inode(sb, NULL, S_IFDIR | sbinfo->mode, 0, VM_NORESERVE);
 	if (!inode)
-- 
2.7.4
