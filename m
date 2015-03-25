From: David Howells <dhowells@redhat.com>
Subject: [PATCH 06/15] VFS: Fix up missed bits of reiserfs to use d_inode()
Date: Wed, 25 Mar 2015 14:44:27 +0000
Message-ID: <20150325144427.17670.41442.stgit@warthog.procyon.org.uk>
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

Fix up missed bits of reiserfs to use d_inode() where the clause didn't match
the autoconversion script RE because of brackets.

Signed-off-by: David Howells <dhowells@redhat.com>
---

 fs/reiserfs/xattr.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/reiserfs/xattr.h b/fs/reiserfs/xattr.h
index f620e9678dd5..15dde6262c00 100644
--- a/fs/reiserfs/xattr.h
+++ b/fs/reiserfs/xattr.h
@@ -78,7 +78,7 @@ static inline size_t reiserfs_xattr_jcreate_nblocks(struct inode *inode)
 
 	if ((REISERFS_I(inode)->i_flags & i_has_xattr_dir) == 0) {
 		nblocks += JOURNAL_BLOCKS_PER_OBJECT(inode->i_sb);
-		if (!REISERFS_SB(inode->i_sb)->xattr_root->d_inode)
+		if (d_really_is_negative(REISERFS_SB(inode->i_sb)->xattr_root))
 			nblocks += JOURNAL_BLOCKS_PER_OBJECT(inode->i_sb);
 	}
 
