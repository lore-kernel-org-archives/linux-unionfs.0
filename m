From: oc <oc@yunify.com>
Subject: [PATCH] overlayfs: Make dir inode always point to the underlay
Date: Fri, 12 Aug 2016 15:34:51 +0800
Message-ID: <4b4580e4-8bec-bfba-cd94-1d531a2f06cc@yunify.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-unionfs-owner@vger.kernel.org>
Received: from m97136.qiye.163.com ([220.181.97.136]:4611 "EHLO
	m97136.qiye.163.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751258AbcHLHlx (ORCPT
	<rfc822;linux-unionfs@vger.kernel.org>);
	Fri, 12 Aug 2016 03:41:53 -0400
Sender: linux-unionfs-owner@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org
To: linux-unionfs@vger.kernel.org, miklos@szeredi.hu, dhowells@redhat.com, trivial@kernel.org

Since file inode points to the underlay from ovl_path_real method, the dir
inode should also point to the one from underlay. This issue introduced
problem when live migrates a container instance using criu, which need to
convert inotify inode entry to file path, because inotify point to the real
inode in underlay.

Signed-off-by: Chen Haiquan <oc@yunify.com>
---
  fs/overlayfs/dir.c | 3 ---
  1 file changed, 3 deletions(-)

diff --git a/fs/overlayfs/dir.c b/fs/overlayfs/dir.c
index 12bcd07b9e32..a06f23d325ec 100644
--- a/fs/overlayfs/dir.c
+++ b/fs/overlayfs/dir.c
@@ -147,9 +147,6 @@ static int ovl_dir_getattr(struct vfsmount *mnt, 
struct dentry *dentry,
         if (err)
                 return err;

-       stat->dev = dentry->d_sb->s_dev;
-       stat->ino = dentry->d_inode->i_ino;
-
         /*
          * It's probably not worth it to count subdirs to get the
          * correct link count.  nlink=1 seems to pacify 'find' and
-- 
2.7.4
