From: David Howells <dhowells@redhat.com>
Subject: [PATCH 10/15] VFS: Fix up debugfs to use d_is_dir() in place of
 S_ISDIR()
Date: Wed, 25 Mar 2015 14:45:05 +0000
Message-ID: <20150325144505.17670.81926.stgit@warthog.procyon.org.uk>
References: <20150325144330.17670.6959.stgit@warthog.procyon.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20150325144330.17670.6959.stgit@warthog.procyon.org.uk>
Sender: linux-kernel-owner@vger.kernel.org
To: viro@ftp.linux.org.uk
Cc: dhowells@redhat.com, linux-unionfs@vger.kernel.org, linux-kernel@vger.kernel.org, miklos@szeredi.hu
List-Id: linux-unionfs@vger.kernel.org

Fix up debugfs to use d_is_dir(dentry) in place of
S_ISDIR(dentry->d_inode->i_mode).

Signed-off-by: David Howells <dhowells@redhat.com>
---

 fs/debugfs/inode.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/debugfs/inode.c b/fs/debugfs/inode.c
index 96400ab42d13..26856ecdea5e 100644
--- a/fs/debugfs/inode.c
+++ b/fs/debugfs/inode.c
@@ -521,7 +521,7 @@ static int __debugfs_remove(struct dentry *dentry, struct dentry *parent)
 
 	if (debugfs_positive(dentry)) {
 		dget(dentry);
-		if (S_ISDIR(dentry->d_inode->i_mode))
+		if (d_is_dir(dentry))
 			ret = simple_rmdir(parent->d_inode, dentry);
 		else
 			simple_unlink(parent->d_inode, dentry);
