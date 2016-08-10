From: Miklos Szeredi <miklos@szeredi.hu>
Subject: Re: =?utf-8?Q?retry?= =?utf-8?B?77ya?= [PATCH] ovl: fix inode in
 utimes_common on overlayfs.
Date: Wed, 10 Aug 2016 10:01:16 +0200
Message-ID: <20160810080116.GF25404@veci.piliscsaba.szeredi.hu>
References: <1469779579-28423-1-git-send-email-zhangaihua1@huawei.com>
 <57A94733.8090502@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-unionfs-owner@vger.kernel.org>
Received: from mail-wm0-f45.google.com ([74.125.82.45]:35350 "EHLO
	mail-wm0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932994AbcHJTOG (ORCPT
	<rfc822;linux-unionfs@vger.kernel.org>);
	Wed, 10 Aug 2016 15:14:06 -0400
Received: by mail-wm0-f45.google.com with SMTP id f65so108118545wmi.0
        for <linux-unionfs@vger.kernel.org>; Wed, 10 Aug 2016 12:14:05 -0700 (PDT)
Content-Disposition: inline
In-Reply-To: <57A94733.8090502@huawei.com>
Sender: linux-unionfs-owner@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org
To: Zhang AiHua <zhangaihua1@huawei.com>
Cc: linux-unionfs@vger.kernel.org

On Tue, Aug 09, 2016 at 11:00:03AM +0800, Zhang AiHua wrote:

> From: Aihua Zhang <zhangaihua1@huawei.com>
> 
> the check IS_IMMUTABLE(inode) is invalid in utimes_commmon,
> the inode should point to upper rather than merge.
> 
> the patch also fix the error in LTP(utimensat01).
> 
> Signed-off-by: Aihua Zhang <zhangaihua1@huawei.com>

Can you please try this alternative patch?

Thanks,
Miklos

---
 fs/attr.c          |   15 +++++++++++++++
 fs/utimes.c        |   17 +----------------
 include/linux/fs.h |    1 +
 3 files changed, 17 insertions(+), 16 deletions(-)

--- a/fs/attr.c
+++ b/fs/attr.c
@@ -202,6 +202,21 @@ int notify_change(struct dentry * dentry
 			return -EPERM;
 	}
 
+	/*
+	 * If utimes(2) and friends are called with times == NULL (or both
+	 * times are UTIME_NOW), then we need to check for write permission
+	 */
+	if (ia_valid & ATTR_TOUCH) {
+                if (IS_IMMUTABLE(inode))
+			return -EPERM;
+
+		if (!inode_owner_or_capable(inode)) {
+			error = inode_permission(inode, MAY_WRITE);
+			if (error)
+				return error;
+		}
+	}
+
 	if ((ia_valid & ATTR_MODE)) {
 		umode_t amode = attr->ia_mode;
 		/* Flag setting protected by i_mutex */
--- a/fs/utimes.c
+++ b/fs/utimes.c
@@ -87,21 +87,7 @@ static int utimes_common(struct path *pa
 		 */
 		newattrs.ia_valid |= ATTR_TIMES_SET;
 	} else {
-		/*
-		 * If times is NULL (or both times are UTIME_NOW),
-		 * then we need to check permissions, because
-		 * inode_change_ok() won't do it.
-		 */
-		error = -EPERM;
-                if (IS_IMMUTABLE(inode))
-			goto mnt_drop_write_and_out;
-
-		error = -EACCES;
-		if (!inode_owner_or_capable(inode)) {
-			error = inode_permission(inode, MAY_WRITE);
-			if (error)
-				goto mnt_drop_write_and_out;
-		}
+		newattrs.ia_valid |= ATTR_TOUCH;
 	}
 retry_deleg:
 	inode_lock(inode);
@@ -113,7 +99,6 @@ static int utimes_common(struct path *pa
 			goto retry_deleg;
 	}
 
-mnt_drop_write_and_out:
 	mnt_drop_write(path->mnt);
 out:
 	return error;
--- a/include/linux/fs.h
+++ b/include/linux/fs.h
@@ -224,6 +224,7 @@ typedef int (dio_iodone_t)(struct kiocb
 #define ATTR_KILL_PRIV	(1 << 14)
 #define ATTR_OPEN	(1 << 15) /* Truncating from open(O_TRUNC) */
 #define ATTR_TIMES_SET	(1 << 16)
+#define ATTR_TOUCH	(1 << 17)
 
 /*
  * Whiteout is represented by a char device.  The following constants define the
