From: "zhangyi (F)" <yi.zhang@huawei.com>
Subject: [PATCH v2 17/18] fsck.overlay: not enforce overlayfs is offline in 'no changes' mode
Date: Thu, 14 Dec 2017 14:47:46 +0800
Message-ID: <20171214064747.20999-18-yi.zhang@huawei.com>
References: <20171214064747.20999-1-yi.zhang@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-unionfs-owner@vger.kernel.org>
Received: from szxga05-in.huawei.com ([45.249.212.191]:11992 "EHLO
        szxga05-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751399AbdLNGmI (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Thu, 14 Dec 2017 01:42:08 -0500
In-Reply-To: <20171214064747.20999-1-yi.zhang@huawei.com>
Sender: linux-unionfs-owner@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org
To: linux-unionfs@vger.kernel.org, fstests@vger.kernel.org
Cc: miklos@szeredi.hu, amir73il@gmail.com, eguan@redhat.com, darrick.wong@oracle.com, yi.zhang@huawei.com, miaoxie@huawei.com

Signed-off-by: zhangyi (F) <yi.zhang@huawei.com>
---
 fsck.c  |  4 ++--
 mount.c | 14 ++++++--------
 2 files changed, 8 insertions(+), 10 deletions(-)

diff --git a/fsck.c b/fsck.c
index 56a5286..d7321fb 100644
--- a/fsck.c
+++ b/fsck.c
@@ -260,7 +260,7 @@ void fsck_status_check(int *val)
 
 int main(int argc, char *argv[])
 {
-	bool mounted;
+	bool mounted = false;
 	int err = 0;
 	int exit_value = 0;
 
@@ -271,7 +271,7 @@ int main(int argc, char *argv[])
 	/* Ensure overlay filesystem not mounted */
 	if ((err = ovl_check_mount(&mounted)))
 		goto out;
-	if (!mounted) {
+	if (mounted && !(flags & FL_OPT_NO)) {
 		set_st_abort(&status);
 		goto out;
 	}
diff --git a/mount.c b/mount.c
index 10970d5..a4bf492 100644
--- a/mount.c
+++ b/mount.c
@@ -280,12 +280,11 @@ static void ovl_scan_mount_exit(struct ovl_mnt_entry *ovl_mnt_entries,
  * Note: fsck may modify lower layers, so even match only one directory
  *       is triggered as mounted.
  */
-int ovl_check_mount(bool *pass)
+int ovl_check_mount(bool *mounted)
 {
 	struct ovl_mnt_entry *ovl_mnt_entries = NULL;
 	int ovl_mnt_entry_count = 0;
 	char *mounted_path = NULL;
-	bool mounted = false;
 	int i,j,k;
 	int ret;
 
@@ -301,7 +300,7 @@ int ovl_check_mount(bool *pass)
 				if (!strcmp(lowerdir[k],
 					    ovl_mnt_entries[i].lowerdir[j])) {
 					mounted_path = lowerdir[k];
-					mounted = true;
+					*mounted = true;
 					goto out;
 				}
 			}
@@ -310,23 +309,22 @@ int ovl_check_mount(bool *pass)
 		/* Check upper */
 		if (!(strcmp(upperdir, ovl_mnt_entries[i].upperdir))) {
 			mounted_path = upperdir;
-			mounted = true;
+			*mounted = true;
 			goto out;
 		}
 
 		/* Check worker */
 		if (workdir[0] != '\0' && !(strcmp(workdir, ovl_mnt_entries[i].workdir))) {
 			mounted_path = workdir;
-			mounted = true;
+			*mounted = true;
 			goto out;
 		}
 	}
 out:
 	ovl_scan_mount_exit(ovl_mnt_entries, ovl_mnt_entry_count);
 
-	if (mounted)
-		print_info(_("Dir %s is mounted\n"), mounted_path);
-	*pass = !mounted;
+	if (*mounted)
+		print_info(_("WARNING: Dir %s is mounted\n"), mounted_path);
 
 	return 0;
 }
-- 
2.9.5
