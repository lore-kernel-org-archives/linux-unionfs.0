From: David Howells <dhowells@redhat.com>
Subject: [PATCH 05/15] VFS: Fix up missed bits of ecryptfs to use d_inode()
Date: Wed, 25 Mar 2015 14:44:17 +0000
Message-ID: <20150325144417.17670.33844.stgit@warthog.procyon.org.uk>
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

Fix up missed bits of ecryptfs to use d_inode() where the clause didn't match
the autoconversion script RE because of brackets.

Signed-off-by: David Howells <dhowells@redhat.com>
---

 fs/ecryptfs/inode.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/fs/ecryptfs/inode.c b/fs/ecryptfs/inode.c
index b08b5187f662..99e3b589edf8 100644
--- a/fs/ecryptfs/inode.c
+++ b/fs/ecryptfs/inode.c
@@ -681,8 +681,8 @@ static void *ecryptfs_follow_link(struct dentry *dentry, struct nameidata *nd)
 	char *buf = ecryptfs_readlink_lower(dentry, &len);
 	if (IS_ERR(buf))
 		goto out;
-	fsstack_copy_attr_atime(dentry->d_inode,
-				ecryptfs_dentry_to_lower(dentry)->d_inode);
+	fsstack_copy_attr_atime(d_inode(dentry),
+				d_inode(ecryptfs_dentry_to_lower(dentry)));
 	buf[len] = '\0';
 out:
 	nd_set_link(nd, buf);
