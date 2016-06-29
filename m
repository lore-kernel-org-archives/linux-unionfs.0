From: Miklos Szeredi <miklos@szeredi.hu>
Subject: Re: =?utf-8?B?cmV0cnnvvJpbUEFUQ0hdIGZpeCBl?= =?utf-8?Q?rror?=
 =?utf-8?Q?=3A?= a bin file can truncate itself while running on overlayfs
Date: Wed, 29 Jun 2016 16:03:18 +0200
Message-ID: <20160629140318.GA3936@veci.piliscsaba.szeredi.hu>
References: <1466590388-4914-1-git-send-email-zhangaihua1@huawei.com>
 <57707C2E.2080500@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-fsdevel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <57707C2E.2080500@huawei.com>
Sender: linux-fsdevel-owner@vger.kernel.org
To: Zhang AiHua <zhangaihua1@huawei.com>
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org, linux-unionfs@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org

Hi,

Thanks for the report and the testcase.

Here's a patch using a different approach (overlayfs philosophy is to minimize
VFS footprint).

Thanks,
Miklos
---

From: Miklos Szeredi <mszeredi@redhat.com>
Subject: ovl: get_write_access() in truncate

When truncating a file we should check write access on the underlying
inode.  And we should do so on the lower file as well (before copy-up) for
consistency.

Original patch and test case by Aihua Zhang.

 - - >o >o - - test.c - - >o >o - -
#include <stdio.h>
#include <errno.h>
#include <unistd.h>

int main(int argc, char *argv[])
{
	int ret;

	ret = truncate(argv[0], 4096);
	if (ret != -1) {
		fprintf(stderr, "truncate(argv[0]) should have failed\n");
		return 1;
	}
	if (errno != ETXTBSY) {
		perror("truncate(argv[0])");
		return 1;
	}

	return 0;
}
 - - >o >o - - >o >o - - >o >o - -

Reported-by: Aihua Zhang <zhangaihua1@huawei.com>
Signed-off-by: Miklos Szeredi <mszeredi@redhat.com>
Cc: <stable@vger.kernel.org>
---
 fs/overlayfs/inode.c |   21 +++++++++++++++++++++
 1 file changed, 21 insertions(+)

--- a/fs/overlayfs/inode.c
+++ b/fs/overlayfs/inode.c
@@ -59,16 +59,37 @@ int ovl_setattr(struct dentry *dentry, s
 	if (err)
 		goto out;
 
+	if (attr->ia_valid & ATTR_SIZE) {
+		struct inode *realinode = d_inode(ovl_dentry_real(dentry));
+
+		err = -ETXTBSY;
+		if (atomic_read(&realinode->i_writecount) < 0)
+			goto out_drop_write;
+	}
+
 	err = ovl_copy_up(dentry);
 	if (!err) {
+		struct inode *winode = NULL;
+
 		upperdentry = ovl_dentry_upper(dentry);
 
+		if (attr->ia_valid & ATTR_SIZE) {
+			winode = d_inode(upperdentry);
+			err = get_write_access(winode);
+			if (err)
+				goto out_drop_write;
+		}
+
 		inode_lock(upperdentry->d_inode);
 		err = notify_change(upperdentry, attr, NULL);
 		if (!err)
 			ovl_copyattr(upperdentry->d_inode, dentry->d_inode);
 		inode_unlock(upperdentry->d_inode);
+
+		if (winode)
+			put_write_access(winode);
 	}
+out_drop_write:
 	ovl_drop_write(dentry);
 out:
 	return err;
