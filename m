From: Amir Goldstein <amir73il@gmail.com>
Subject: [PATCH] ovl: don't expose EOPENSTALE to userspace
Date: Tue, 25 Apr 2017 16:57:55 +0300
Message-ID: <1493128675-24331-1-git-send-email-amir73il@gmail.com>
Return-path: <linux-unionfs-owner@vger.kernel.org>
Received: from mail-wr0-f196.google.com ([209.85.128.196]:34891 "EHLO
        mail-wr0-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1947743AbdDYN5r (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Tue, 25 Apr 2017 09:57:47 -0400
Sender: linux-unionfs-owner@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: Trond Myklebust <trondmy@primarydata.com>, Jeff Layton <jlayton@poochiereds.net>, "J . Bruce Fields" <bfields@fieldses.org>, Tyler Hicks <tyhicks@canonical.com>, Al Viro <viro@zeniv.linux.org.uk>, linux-unionfs@vger.kernel.org, linux-fsdevel@vger.kernel.org, stable@vger.kernel.org

An overlay dentry holds a lower dentry that may belong to an NFS mount.

Overlayfs calls ovl_path_open() to get a file descriptor of a lower file
for copying up its data and for a lower directory for listing its
content.

If that lower dentry gets invalidated after ovl_dentry_revalidate() and
before ovl_path_open(), the internal error code 518 (EOPENSTALE), which
is not a POSIX error code, will be exposed to the user.

Check the internal return value -EOPENSTALE in ovl_path_open(), just
the same as it is checked in path_openat() and replace it with the POSIX
error code ESTALE.

Cc: <stable@vger.kernel.org>
Signed-off-by: Amir Goldstein <amir73il@gmail.com>
---
 fs/overlayfs/util.c | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

Miklos,

Following a similar bug report and a fix I posted for fanotify,
I realized that overlayfs can also expose EOPENSTALE to userspace.

I did not try to reproduce this with real lower NFS, only tested
patch correctness using a debug patch.

I guess a reproducer could work with ovl_copy_up_data() that is
delayed for a long time without concurrent copy up in kernel <= v4.10
and lower file is pulled underneath while copy up is pending.
However, with concurrent copy up in v4.11 that reproducer will be
of no use.

The only other suspect I found for dentry_open() of an NFS dentry
without checking -EOPENSTALE is ecryptfs.

David,
I think fscache won't be storing it local storage on NFS, right?

Added CC stable. Although I am not sure how important this fix is,
seems simple enough that breaking POSIX would justify patching stable.

Anyway, if you think this calls for a VFS helper I don't mind
doing it, I'm just terrible with names so please suggest one.
In that case, should we make dentry_open() static? non exportable?

Thanks,
Amir.

diff --git a/fs/overlayfs/util.c b/fs/overlayfs/util.c
index 89789bc..931d199 100644
--- a/fs/overlayfs/util.c
+++ b/fs/overlayfs/util.c
@@ -328,7 +328,11 @@ bool ovl_is_whiteout(struct dentry *dentry)
 
 struct file *ovl_path_open(struct path *path, int flags)
 {
-	return dentry_open(path, flags | O_NOATIME, current_cred());
+	struct file *f = dentry_open(path, flags | O_NOATIME, current_cred());
+
+	if (unlikely(IS_ERR(f) && PTR_ERR(f) == -EOPENSTALE))
+		return ERR_PTR(-ESTALE);
+	return f;
 }
 
 int ovl_copy_up_start(struct dentry *dentry)
-- 
2.7.4
