From: Amir Goldstein <amir73il@gmail.com>
Subject: [PATCH] fs: fix access beyond unterminated strings in prints
Date: Fri, 28 Sep 2018 21:00:48 +0300
Message-ID: <20180928180048.14259-1-amir73il@gmail.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: linux-unionfs@vger.kernel.org, linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org, Jeff Layton <jlayton@kernel.org>, Jan Harkes <jaharkes@cs.cmu.edu>, Mark Fasheh <mark@fasheh.com>
List-Id: linux-unionfs@vger.kernel.org

KASAN detected slab-out-of-bounds access in printk from overlayfs,
because string format used %*s instead of %.*s.
Found and fixed 4 other places that use %*s incorrectly in filesystems.

> BUG: KASAN: slab-out-of-bounds in string+0x298/0x2d0 lib/vsprintf.c:604
> Read of size 1 at addr ffff8801c36c66ba by task syz-executor2/27811
>
> CPU: 0 PID: 27811 Comm: syz-executor2 Not tainted 4.19.0-rc5+ #36
...
>  printk+0xa7/0xcf kernel/printk/printk.c:1996
>  ovl_lookup_index.cold.15+0xe8/0x1f8 fs/overlayfs/namei.c:689

Reported-by: syzbot+376cea2b0ef340db3dd4@syzkaller.appspotmail.com
Cc: Jeff Layton <jlayton@kernel.org>
Cc: Jan Harkes <jaharkes@cs.cmu.edu>
Cc: Mark Fasheh <mark@fasheh.com>
Signed-off-by: Amir Goldstein <amir73il@gmail.com>
---

Miklos,

I chose not to split the patches per fs in the hope that maintainers
would quickly ack the patch and ask you to carry it for them.

If this doesn't happen, feel free to drop non-acked bits from the patch.

Thanks,
Amir.

 fs/coda/dir.c            | 2 +-
 fs/lockd/host.c          | 2 +-
 fs/ocfs2/super.c         | 2 +-
 fs/overlayfs/namei.c     | 2 +-
 fs/overlayfs/overlayfs.h | 2 +-
 5 files changed, 5 insertions(+), 5 deletions(-)

diff --git a/fs/coda/dir.c b/fs/coda/dir.c
index 00876ddadb43..23ee5de8b4be 100644
--- a/fs/coda/dir.c
+++ b/fs/coda/dir.c
@@ -47,7 +47,7 @@ static struct dentry *coda_lookup(struct inode *dir, struct dentry *entry, unsig
 	int type = 0;
 
 	if (length > CODA_MAXNAMLEN) {
-		pr_err("name too long: lookup, %s (%*s)\n",
+		pr_err("name too long: lookup, %s (%.*s)\n",
 		       coda_i2s(dir), (int)length, name);
 		return ERR_PTR(-ENAMETOOLONG);
 	}
diff --git a/fs/lockd/host.c b/fs/lockd/host.c
index d35cd6be0675..93fb7cf0b92b 100644
--- a/fs/lockd/host.c
+++ b/fs/lockd/host.c
@@ -341,7 +341,7 @@ struct nlm_host *nlmsvc_lookup_host(const struct svc_rqst *rqstp,
 	};
 	struct lockd_net *ln = net_generic(net, lockd_net_id);
 
-	dprintk("lockd: %s(host='%*s', vers=%u, proto=%s)\n", __func__,
+	dprintk("lockd: %s(host='%.*s', vers=%u, proto=%s)\n", __func__,
 			(int)hostname_len, hostname, rqstp->rq_vers,
 			(rqstp->rq_prot == IPPROTO_UDP ? "udp" : "tcp"));
 
diff --git a/fs/ocfs2/super.c b/fs/ocfs2/super.c
index 3415e0b09398..b74435dc85fd 100644
--- a/fs/ocfs2/super.c
+++ b/fs/ocfs2/super.c
@@ -259,7 +259,7 @@ static int ocfs2_osb_dump(struct ocfs2_super *osb, char *buf, int len)
 
 	if (cconn) {
 		out += snprintf(buf + out, len - out,
-				"%10s => Stack: %s  Name: %*s  "
+				"%10s => Stack: %s  Name: %.*s  "
 				"Version: %d.%d\n", "Cluster",
 				(*osb->osb_cluster_stack == '\0' ?
 				 "o2cb" : osb->osb_cluster_stack),
diff --git a/fs/overlayfs/namei.c b/fs/overlayfs/namei.c
index f28711846dd6..9c0ca6a7becf 100644
--- a/fs/overlayfs/namei.c
+++ b/fs/overlayfs/namei.c
@@ -686,7 +686,7 @@ struct dentry *ovl_lookup_index(struct ovl_fs *ofs, struct dentry *upper,
 			index = NULL;
 			goto out;
 		}
-		pr_warn_ratelimited("overlayfs: failed inode index lookup (ino=%lu, key=%*s, err=%i);\n"
+		pr_warn_ratelimited("overlayfs: failed inode index lookup (ino=%lu, key=%.*s, err=%i);\n"
 				    "overlayfs: mount with '-o index=off' to disable inodes index.\n",
 				    d_inode(origin)->i_ino, name.len, name.name,
 				    err);
diff --git a/fs/overlayfs/overlayfs.h b/fs/overlayfs/overlayfs.h
index f61839e1054c..c096f12657cd 100644
--- a/fs/overlayfs/overlayfs.h
+++ b/fs/overlayfs/overlayfs.h
@@ -152,7 +152,7 @@ static inline int ovl_do_setxattr(struct dentry *dentry, const char *name,
 				  const void *value, size_t size, int flags)
 {
 	int err = vfs_setxattr(dentry, name, value, size, flags);
-	pr_debug("setxattr(%pd2, \"%s\", \"%*s\", 0x%x) = %i\n",
+	pr_debug("setxattr(%pd2, \"%s\", \"%.*s\", 0x%x) = %i\n",
 		 dentry, name, (int) size, (char *) value, flags, err);
 	return err;
 }
-- 
2.17.1
