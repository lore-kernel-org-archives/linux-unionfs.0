From: Konstantin Khlebnikov <khlebnikov@yandex-team.ru>
Subject: [PATCH] ovl: check dentry positiveness in ovl_cleanup_whiteouts()
Date: Mon, 16 Nov 2015 18:44:11 +0300
Message-ID: <20151116154411.6862.28435.stgit@buzz>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: David Howells <dhowells@redhat.com>, Miklos Szeredi <miklos@szeredi.hu>
Cc: Al Viro <viro@zeniv.linux.org.uk>, linux-kernel@vger.kernel.org, stable@vger.kernel.org, linux-unionfs@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org

This patch fixes kernel crash at removing directory which contains
whiteouts from lower layers.

Cache of directory content passed as "list" contains entries from all
layers, including whiteouts from lower layers. So, lookup in upper dir
(moved into work at this stage) will return negative entry. Plus this
cache is filled long before and we can race with external removal.

Example:
 mkdir -p lower0/dir lower1/dir upper work overlay
 touch lower0/dir/a lower0/dir/b
 mknod lower1/dir/a c 0 0
 mount -t overlay none overlay -o lowerdir=lower1:lower0,upperdir=upper,workdir=work
 rm -fr overlay/dir

Signed-off-by: Konstantin Khlebnikov <khlebnikov@yandex-team.ru>
Cc: Stable <stable@vger.kernel.org> # 3.18+
---
 fs/overlayfs/readdir.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/fs/overlayfs/readdir.c b/fs/overlayfs/readdir.c
index 70e9af551600..adcb1398c481 100644
--- a/fs/overlayfs/readdir.c
+++ b/fs/overlayfs/readdir.c
@@ -571,7 +571,8 @@ void ovl_cleanup_whiteouts(struct dentry *upper, struct list_head *list)
 			       (int) PTR_ERR(dentry));
 			continue;
 		}
-		ovl_cleanup(upper->d_inode, dentry);
+		if (dentry->d_inode)
+			ovl_cleanup(upper->d_inode, dentry);
 		dput(dentry);
 	}
 	mutex_unlock(&upper->d_inode->i_mutex);
