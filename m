From: Miklos Szeredi <miklos@szeredi.hu>
Subject: [PATCH] ovl: set I_CREATING on inode being created
Date: Wed, 22 Aug 2018 10:55:22 +0200
Message-ID: <20180822085522.GA14354@veci.piliscsaba.redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org, linux-unionfs@vger.kernel.org, viro@zeniv.linux.org.uk
List-Id: linux-unionfs@vger.kernel.org

...otherwise there will be list corruption due to inode_sb_list_add() being
called for inode already on the sb list.

Signed-off-by: Miklos Szeredi <mszeredi@redhat.com>
Fixes: e950564b97fd ("vfs: don't evict uninitialized inode")
---
This missed the 4.19 overlay pull request, because it fixes a bug
introduced by patch not in said pull (buggy patch is also mine,
incidentally).

 fs/overlayfs/dir.c |    4 ++++
 1 file changed, 4 insertions(+)

--- a/fs/overlayfs/dir.c
+++ b/fs/overlayfs/dir.c
@@ -603,6 +603,10 @@ static int ovl_create_object(struct dent
 	if (!inode)
 		goto out_drop_write;
 
+	spin_lock(&inode->i_lock);
+	inode->i_state |= I_CREATING;
+	spin_unlock(&inode->i_lock);
+
 	inode_init_owner(inode, dentry->d_parent->d_inode, mode);
 	attr.mode = inode->i_mode;
 
