From: David Howells <dhowells@redhat.com>
Subject: [PATCH 15/15] VFS: Make pathwalk use d_is_reg() rather than
 S_ISREG()
Date: Wed, 25 Mar 2015 14:45:53 +0000
Message-ID: <20150325144553.17670.6183.stgit@warthog.procyon.org.uk>
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

Make pathwalk use d_is_reg() rather than S_ISREG() to determine whether to
honour O_TRUNC.  Since this occurs after complete_walk(), the dentry type
field cannot change and the inode pointer cannot change as we hold a ref on
the dentry, so this should be safe.

Signed-off-by: David Howells <dhowells@redhat.com>
---

 fs/namei.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/namei.c b/fs/namei.c
index 66234b836360..5a8dee5c333e 100644
--- a/fs/namei.c
+++ b/fs/namei.c
@@ -3079,7 +3079,7 @@ finish_open:
 	error = -ENOTDIR;
 	if ((nd->flags & LOOKUP_DIRECTORY) && !d_can_lookup(nd->path.dentry))
 		goto out;
-	if (!S_ISREG(nd->inode->i_mode))
+	if (!d_is_reg(nd->path.dentry))
 		will_truncate = false;
 
 	if (will_truncate) {
