From: "zhangyi (F)" <yi.zhang@huawei.com>
Subject: [PATCH v2 02/18] fsck.overlay: fix uninitialized variable
Date: Thu, 14 Dec 2017 14:47:31 +0800
Message-ID: <20171214064747.20999-3-yi.zhang@huawei.com>
References: <20171214064747.20999-1-yi.zhang@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-unionfs-owner@vger.kernel.org>
Received: from szxga05-in.huawei.com ([45.249.212.191]:11986 "EHLO
        szxga05-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751035AbdLNGmE (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Thu, 14 Dec 2017 01:42:04 -0500
In-Reply-To: <20171214064747.20999-1-yi.zhang@huawei.com>
Sender: linux-unionfs-owner@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org
To: linux-unionfs@vger.kernel.org, fstests@vger.kernel.org
Cc: miklos@szeredi.hu, amir73il@gmail.com, eguan@redhat.com, darrick.wong@oracle.com, yi.zhang@huawei.com, miaoxie@huawei.com

Signed-off-by: zhangyi (F) <yi.zhang@huawei.com>
---
 fsck.c  | 8 ++++----
 mount.c | 8 ++++----
 2 files changed, 8 insertions(+), 8 deletions(-)

diff --git a/fsck.c b/fsck.c
index cbcb8e9..7f704c8 100644
--- a/fsck.c
+++ b/fsck.c
@@ -25,12 +25,12 @@
 
 char *program_name;
 
-char **lowerdir;
+char **lowerdir = NULL;
 char upperdir[PATH_MAX] = {0};
 char workdir[PATH_MAX] = {0};
-unsigned int lower_num;
-int flags;		/* user input option flags */
-int status;		/* fsck scan status */
+unsigned int lower_num = 0;
+int flags = 0;		/* user input option flags */
+int status = 0;		/* fsck scan status */
 
 /* Cleanup lower directories buf */
 static void ovl_clean_lowerdirs(void)
diff --git a/mount.c b/mount.c
index 28ce8e5..768c7aa 100644
--- a/mount.c
+++ b/mount.c
@@ -269,10 +269,10 @@ static void ovl_scan_mount_exit(struct ovl_mnt_entry *ovl_mnt_entries,
  */
 int ovl_check_mount(bool *pass)
 {
-	struct ovl_mnt_entry *ovl_mnt_entries;
-	int ovl_mnt_entry_count;
-	char *mounted_path;
-	bool mounted;
+	struct ovl_mnt_entry *ovl_mnt_entries = NULL;
+	int ovl_mnt_entry_count = 0;
+	char *mounted_path = NULL;
+	bool mounted = false;
 	int i,j,k;
 	int ret;
 
-- 
2.9.5
