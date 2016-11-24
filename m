From: Miklos Szeredi <mszeredi@redhat.com>
Subject: [PATCH 6/7] ovl: intercept mmap
Date: Thu, 24 Nov 2016 11:55:43 +0100
Message-ID: <1479984944-1017-8-git-send-email-mszeredi@redhat.com>
References: <1479984944-1017-1-git-send-email-mszeredi@redhat.com>
Return-path: <linux-unionfs-owner@vger.kernel.org>
Received: from mail-wj0-f169.google.com ([209.85.210.169]:33686 "EHLO
        mail-wj0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S964954AbcKXKz7 (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Thu, 24 Nov 2016 05:55:59 -0500
Received: by mail-wj0-f169.google.com with SMTP id xy5so30538792wjc.0
        for <linux-unionfs@vger.kernel.org>; Thu, 24 Nov 2016 02:55:58 -0800 (PST)
In-Reply-To: <1479984944-1017-1-git-send-email-mszeredi@redhat.com>
Sender: linux-unionfs-owner@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org
To: linux-unionfs@vger.kernel.org
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org

... in order to handle the corner case when the file is copied up after
being opened read-only and mapped shared.

Can be verified with the following script:

 - 8< - - - - - 8< - - - - - 8< - - - - - 8< - - - -
cd /
rm -rf /tmp/ovl-rorw-test
mkdir /tmp/ovl-rorw-test
cd /tmp/ovl-rorw-test
cat << EOF > rorw-map.c
#include <fcntl.h>
#include <unistd.h>
#include <string.h>
#include <err.h>
#include <sys/mman.h>

int main(int argc, char *argv[])
{
        int rofd, rwfd;
        int ret;
        char buf[4];
        char *addr;

        rofd = open(argv[1], O_RDONLY);
        if (rofd == -1)
                err(1, "ro open");

        addr = mmap(NULL, 4, PROT_READ, MAP_SHARED, rofd, 0);
        if (addr == MAP_FAILED)
                err(1, "ro mmap");

        if (memcmp(addr, "bubu", 4) == 0)
                errx(1, "identical startup data");

        rwfd = open(argv[1], O_WRONLY);
        if (rwfd == -1)
                err(1, "rw open");

        ret = write(rwfd, "bubu", 4);
        if (ret == -1)
                err(1, "write");
        if (ret < 4)
                errx(1, "short write");

        if (memcmp(addr, "bubu", 4) != 0)
                errx(1, "bad mmap data");

        ret = read(rofd, buf, 4);
        if (ret == -1)
                err(1, "read");
        if (ret < 4)
                errx(1, "short read");
        if (memcmp(buf, "bubu", 4) != 0)
                errx(1, "bad read data");

        return 0;
}
EOF
gcc -o rorw-map rorw-map.c
mkdir -p mnt lower upper work
echo baba > lower/foo
mount -t overlay overlay -olowerdir=lower,upperdir=upper,workdir=work mnt
./rorw-map mnt/foo
umount mnt
 - 8< - - - - - 8< - - - - - 8< - - - - - 8< - - - -

No output means success, "rorw-map: bad mmap data" means failure.

Signed-off-by: Miklos Szeredi <mszeredi@redhat.com>
---
 fs/overlayfs/inode.c | 23 ++++++++++++++++++++++-
 1 file changed, 22 insertions(+), 1 deletion(-)

diff --git a/fs/overlayfs/inode.c b/fs/overlayfs/inode.c
index 09c6f99bd5db..25b31c6ebe9e 100644
--- a/fs/overlayfs/inode.c
+++ b/fs/overlayfs/inode.c
@@ -11,6 +11,7 @@
 #include <linux/slab.h>
 #include <linux/xattr.h>
 #include <linux/posix_acl.h>
+#include <linux/mm.h>
 #include <linux/module.h>
 #include <linux/file.h>
 #include <linux/hashtable.h>
@@ -392,6 +393,25 @@ static ssize_t ovl_read_iter(struct kiocb *iocb, struct iov_iter *to)
 	return ret;
 }
 
+static int ovl_mmap(struct file *file, struct vm_area_struct *vma)
+{
+	if (likely(ovl_file_is_lower(file)))
+		return OVL_CALL_REAL_FOP(file, mmap(file, vma));
+
+	file = filp_clone_open(file);
+	if (IS_ERR(file))
+		return PTR_ERR(file);
+
+	fput(vma->vm_file);
+	/* transfer ref: */
+	vma->vm_file = file;
+
+	if (!file->f_op->mmap)
+		return -ENODEV;
+
+	return file->f_op->mmap(file, vma);
+}
+
 static struct ovl_fops *ovl_fops_find(const struct file_operations *orig)
 {
 	struct ovl_fops *ofop;
@@ -431,9 +451,10 @@ static struct ovl_fops *ovl_fops_get(struct file *file)
 		/* Intercept these: */
 		if (orig->read_iter)
 			ofop->fops.read_iter = ovl_read_iter;
+		if (orig->mmap)
+			ofop->fops.mmap = ovl_mmap;
 
 		/* These will need to be intercepted: */
-		ofop->fops.mmap = orig->mmap;
 		ofop->fops.fsync = orig->fsync;
 
 		/*
-- 
2.5.5
