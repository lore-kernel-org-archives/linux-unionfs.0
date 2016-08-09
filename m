From: Zhang AiHua <zhangaihua1@huawei.com>
Subject: =?UTF-8?Q?retry=ef=bc=9a_[PATCH]_ovl:_fix_inode_in_utimes=5fcommon_?=
 =?UTF-8?Q?on_overlayfs.?=
Date: Tue, 9 Aug 2016 11:00:03 +0800
Message-ID: <57A94733.8090502@huawei.com>
References: <1469779579-28423-1-git-send-email-zhangaihua1@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="gbk"; format=flowed
Content-Transfer-Encoding: 8bit
Return-path: <linux-unionfs-owner@vger.kernel.org>
Received: from szxga02-in.huawei.com ([119.145.14.65]:60169 "EHLO
	szxga02-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752345AbcHIDAp (ORCPT
	<rfc822;linux-unionfs@vger.kernel.org>);
	Mon, 8 Aug 2016 23:00:45 -0400
In-Reply-To: <1469779579-28423-1-git-send-email-zhangaihua1@huawei.com>
Sender: linux-unionfs-owner@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org
To: linux-unionfs@vger.kernel.org




-------- 转发的消息 --------
主题: [PATCH] ovl: fix inode in utimes_common on overlayfs.
日期: Fri, 29 Jul 2016 16:06:19 +0800
发件人: zhangaihua1@huawei.com
收件人: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org, linux-unionfs@vger.kernel.org
抄送: Aihua Zhang <zhangaihua1@huawei.com>

From: Aihua Zhang <zhangaihua1@huawei.com>

the check IS_IMMUTABLE(inode) is invalid in utimes_commmon,
the inode should point to upper rather than merge.

the patch also fix the error in LTP(utimensat01).

Signed-off-by: Aihua Zhang <zhangaihua1@huawei.com>
---
  fs/utimes.c |    3 ++-
  1 files changed, 2 insertions(+), 1 deletions(-)

diff --git a/fs/utimes.c b/fs/utimes.c
index 85c40f4..1813a62 100644
--- a/fs/utimes.c
+++ b/fs/utimes.c
@@ -53,6 +53,7 @@ static int utimes_common(struct path *path, struct timespec *times)
  	int error;
  	struct iattr newattrs;
  	struct inode *inode = path->dentry->d_inode;
+	struct inode *real_inode = d_real(path->dentry)->d_inode;
  	struct inode *delegated_inode = NULL;

  	error = mnt_want_write(path->mnt);
@@ -93,7 +94,7 @@ static int utimes_common(struct path *path, struct timespec *times)
  		 * inode_change_ok() won't do it.
  		 */
  		error = -EACCES;
-                if (IS_IMMUTABLE(inode))
+                if (IS_IMMUTABLE(real_inode))
  			goto mnt_drop_write_and_out;

  		if (!inode_owner_or_capable(inode)) {
-- 
1.7.1


.
