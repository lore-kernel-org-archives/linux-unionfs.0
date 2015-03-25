From: David Howells <dhowells@redhat.com>
Subject: [PATCH 07/15] VFS: AF_UNIX sockets should call mknod on the top
 layer only
Date: Wed, 25 Mar 2015 14:44:37 +0000
Message-ID: <20150325144437.17670.59599.stgit@warthog.procyon.org.uk>
References: <20150325144330.17670.6959.stgit@warthog.procyon.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-unionfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:43593 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932304AbbCYOol (ORCPT <rfc822;linux-unionfs@vger.kernel.org>);
	Wed, 25 Mar 2015 10:44:41 -0400
In-Reply-To: <20150325144330.17670.6959.stgit@warthog.procyon.org.uk>
Sender: linux-unionfs-owner@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org
To: viro@ftp.linux.org.uk
Cc: dhowells@redhat.com, linux-unionfs@vger.kernel.org, linux-kernel@vger.kernel.org, miklos@szeredi.hu

AF_UNIX sockets should call mknod on the top layer only and should not attempt
to modify the lower layer in a layered filesystem such as overlayfs.

Signed-off-by: David Howells <dhowells@redhat.com>
---

 net/unix/af_unix.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/unix/af_unix.c b/net/unix/af_unix.c
index 526b6edab018..bd3a1cfd4b73 100644
--- a/net/unix/af_unix.c
+++ b/net/unix/af_unix.c
@@ -844,7 +844,7 @@ static int unix_mknod(const char *sun_path, umode_t mode, struct path *res)
 	 */
 	err = security_path_mknod(&path, dentry, mode, 0);
 	if (!err) {
-		err = vfs_mknod(path.dentry->d_inode, dentry, mode, 0);
+		err = vfs_mknod(d_inode(path.dentry), dentry, mode, 0);
 		if (!err) {
 			res->mnt = mntget(path.mnt);
 			res->dentry = dget(dentry);

