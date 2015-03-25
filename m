From: David Howells <dhowells@redhat.com>
Subject: [PATCH 14/15] VFS: Combine inode checks with d_is_negative() and
 d_is_positive() in pathwalk
Date: Wed, 25 Mar 2015 14:45:44 +0000
Message-ID: <20150325144544.17670.40558.stgit@warthog.procyon.org.uk>
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

Where we have:

    	if (!dentry->d_inode || d_is_negative(dentry)) {

type constructions in pathwalk we should be able to eliminate the check of
d_inode and rely solely on the result of d_is_negative() or d_is_positive().

What we do have to take care to do is to read d_inode after calling a
d_is_xxx() typecheck function to get the barriering right.

Signed-off-by: David Howells <dhowells@redhat.com>
---

 fs/namei.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/fs/namei.c b/fs/namei.c
index c83145af4bfc..66234b836360 100644
--- a/fs/namei.c
+++ b/fs/namei.c
@@ -1586,7 +1586,7 @@ static inline int walk_component(struct nameidata *nd, struct path *path,
 		inode = path->dentry->d_inode;
 	}
 	err = -ENOENT;
-	if (!inode || d_is_negative(path->dentry))
+	if (d_is_negative(path->dentry))
 		goto out_path_put;
 
 	if (should_follow_link(path->dentry, follow)) {
@@ -2313,7 +2313,7 @@ mountpoint_last(struct nameidata *nd, struct path *path)
 	mutex_unlock(&dir->d_inode->i_mutex);
 
 done:
-	if (!dentry->d_inode || d_is_negative(dentry)) {
+	if (d_is_negative(dentry)) {
 		error = -ENOENT;
 		dput(dentry);
 		goto out;
@@ -3040,7 +3040,7 @@ retry_lookup:
 finish_lookup:
 	/* we _can_ be in RCU mode here */
 	error = -ENOENT;
-	if (!inode || d_is_negative(path->dentry)) {
+	if (d_is_negative(path->dentry)) {
 		path_to_nameidata(path, nd);
 		goto out;
 	}
