From: David Howells <dhowells@redhat.com>
Subject: [PATCH 09/15] VFS: Fix up some ->d_inode accesses in the chelsio
 driver
Date: Wed, 25 Mar 2015 14:44:56 +0000
Message-ID: <20150325144456.17670.35507.stgit@warthog.procyon.org.uk>
References: <20150325144330.17670.6959.stgit@warthog.procyon.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-unionfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:37400 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932769AbbCYOpA (ORCPT <rfc822;linux-unionfs@vger.kernel.org>);
	Wed, 25 Mar 2015 10:45:00 -0400
In-Reply-To: <20150325144330.17670.6959.stgit@warthog.procyon.org.uk>
Sender: linux-unionfs-owner@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org
To: viro@ftp.linux.org.uk
Cc: dhowells@redhat.com, linux-unionfs@vger.kernel.org, linux-kernel@vger.kernel.org, miklos@szeredi.hu

Fix up some ->d_inode accesses in the chelsio driver.

 (1) FILE_DATA() should just be replaced with file_inode().

 (2) set_debugfs_file_size() should be removed and debugfs_create_file_size()
     should be used to create the file.

Signed-off-by: David Howells <dhowells@redhat.com>
---

 drivers/net/ethernet/chelsio/cxgb4/cxgb4_debugfs.c |   21 +++++++-------------
 drivers/net/ethernet/chelsio/cxgb4/cxgb4_debugfs.h |    2 --
 2 files changed, 7 insertions(+), 16 deletions(-)

diff --git a/drivers/net/ethernet/chelsio/cxgb4/cxgb4_debugfs.c b/drivers/net/ethernet/chelsio/cxgb4/cxgb4_debugfs.c
index 78854ceb0870..d3476b72f3ae 100644
--- a/drivers/net/ethernet/chelsio/cxgb4/cxgb4_debugfs.c
+++ b/drivers/net/ethernet/chelsio/cxgb4/cxgb4_debugfs.c
@@ -538,7 +538,7 @@ static ssize_t tp_la_write(struct file *file, const char __user *buf,
 	char s[32];
 	unsigned long val;
 	size_t size = min(sizeof(s) - 1, count);
-	struct adapter *adap = FILE_DATA(file)->i_private;
+	struct adapter *adap = file_inode(file)->i_private;
 
 	if (copy_from_user(s, buf, size))
 		return -EFAULT;
@@ -647,7 +647,7 @@ static int pm_stats_open(struct inode *inode, struct file *file)
 static ssize_t pm_stats_clear(struct file *file, const char __user *buf,
 			      size_t count, loff_t *pos)
 {
-	struct adapter *adap = FILE_DATA(file)->i_private;
+	struct adapter *adap = file_inode(file)->i_private;
 
 	t4_write_reg(adap, PM_RX_STAT_CONFIG_A, 0);
 	t4_write_reg(adap, PM_TX_STAT_CONFIG_A, 0);
@@ -999,7 +999,7 @@ static ssize_t mbox_write(struct file *file, const char __user *buf,
 		   &data[7], &c) < 8 || c != '\n')
 		return -EINVAL;
 
-	ino = FILE_DATA(file);
+	ino = file_inode(file);
 	mbox = (uintptr_t)ino->i_private & 7;
 	adap = ino->i_private - mbox;
 	addr = adap->regs + PF_REG(mbox, CIM_PF_MAILBOX_DATA_A);
@@ -1028,7 +1028,7 @@ static ssize_t flash_read(struct file *file, char __user *buf, size_t count,
 			  loff_t *ppos)
 {
 	loff_t pos = *ppos;
-	loff_t avail = FILE_DATA(file)->i_size;
+	loff_t avail = file_inode(file)->i_size;
 	struct adapter *adap = file->private_data;
 
 	if (pos < 0)
@@ -1473,7 +1473,7 @@ static ssize_t rss_key_write(struct file *file, const char __user *buf,
 	int i, j;
 	u32 key[10];
 	char s[100], *p;
-	struct adapter *adap = FILE_DATA(file)->i_private;
+	struct adapter *adap = file_inode(file)->i_private;
 
 	if (count > sizeof(s) - 1)
 		return -EINVAL;
@@ -1941,12 +1941,6 @@ static const struct file_operations mem_debugfs_fops = {
 	.llseek  = default_llseek,
 };
 
-static void set_debugfs_file_size(struct dentry *de, loff_t size)
-{
-	if (!IS_ERR(de) && de->d_inode)
-		de->d_inode->i_size = size;
-}
-
 static void add_debugfs_mem(struct adapter *adap, const char *name,
 			    unsigned int idx, unsigned int size_mb)
 {
@@ -2062,9 +2056,8 @@ int t4_setup_debugfs(struct adapter *adap)
 		}
 	}
 
-	de = debugfs_create_file("flash", S_IRUSR, adap->debugfs_root, adap,
-				 &flash_debugfs_fops);
-	set_debugfs_file_size(de, adap->params.sf_size);
+	de = debugfs_create_file_size("flash", S_IRUSR, adap->debugfs_root, adap,
+				      &flash_debugfs_fops, adap->params.sf_size);
 
 	return 0;
 }
diff --git a/drivers/net/ethernet/chelsio/cxgb4/cxgb4_debugfs.h b/drivers/net/ethernet/chelsio/cxgb4/cxgb4_debugfs.h
index 8f418ba868bd..23f43a0f8950 100644
--- a/drivers/net/ethernet/chelsio/cxgb4/cxgb4_debugfs.h
+++ b/drivers/net/ethernet/chelsio/cxgb4/cxgb4_debugfs.h
@@ -37,8 +37,6 @@
 
 #include <linux/export.h>
 
-#define FILE_DATA(_file) ((_file)->f_path.dentry->d_inode)
-
 #define DEFINE_SIMPLE_DEBUGFS_FILE(name) \
 static int name##_open(struct inode *inode, struct file *file) \
 { \

