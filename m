From: Miklos Szeredi <mszeredi@redhat.com>
Subject: [PATCH 7/9] ovl: intercept mmap on overlay files
Date: Fri, 17 Feb 2017 17:09:36 +0100
Message-ID: <1487347778-18596-8-git-send-email-mszeredi@redhat.com>
References: <1487347778-18596-1-git-send-email-mszeredi@redhat.com>
Return-path: <linux-unionfs-owner@vger.kernel.org>
Received: from mail-wm0-f52.google.com ([74.125.82.52]:36809 "EHLO
        mail-wm0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S934329AbdBQQJx (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Fri, 17 Feb 2017 11:09:53 -0500
Received: by mail-wm0-f52.google.com with SMTP id c85so19395165wmi.1
        for <linux-unionfs@vger.kernel.org>; Fri, 17 Feb 2017 08:09:52 -0800 (PST)
In-Reply-To: <1487347778-18596-1-git-send-email-mszeredi@redhat.com>
Sender: linux-unionfs-owner@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org
To: Al Viro <viro@zeniv.linux.org.uk>
Cc: linux-unionfs@vger.kernel.org, linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org

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
 fs/overlay_util.c            | 19 +++++++++++++++++++
 include/linux/fs.h           |  3 +++
 include/linux/overlay_util.h |  2 ++
 mm/mmap.c                    |  3 +++
 4 files changed, 27 insertions(+)

diff --git a/fs/overlay_util.c b/fs/overlay_util.c
index 0daff19bad0b..063f8c5719d1 100644
--- a/fs/overlay_util.c
+++ b/fs/overlay_util.c
@@ -10,6 +10,7 @@
 #include <linux/overlay_util.h>
 #include <linux/fs.h>
 #include <linux/file.h>
+#include <linux/mm.h>
 #include "internal.h"
 
 static bool overlay_file_consistent(struct file *file)
@@ -36,4 +37,22 @@ ssize_t overlay_read_iter(struct file *file, struct kiocb *kio,
 }
 EXPORT_SYMBOL(overlay_read_iter);
 
+int overlay_mmap(struct file *file, struct vm_area_struct *vma)
+{
+	if (unlikely(!overlay_file_consistent(file))) {
+		file = filp_clone_open(file);
+		if (IS_ERR(file))
+			return PTR_ERR(file);
+
+		fput(vma->vm_file);
+		/* transfer ref: */
+		vma->vm_file = file;
+
+		if (!file->f_op->mmap)
+			return -ENODEV;
+	}
+	return file->f_op->mmap(file, vma);
+}
+EXPORT_SYMBOL(overlay_mmap);
+
 #endif /* IS_ENABLED(CONFIG_OVERLAY_FS) */
diff --git a/include/linux/fs.h b/include/linux/fs.h
index 4728c5178f3f..6e74b726c3ca 100644
--- a/include/linux/fs.h
+++ b/include/linux/fs.h
@@ -1739,6 +1739,9 @@ static inline ssize_t call_write_iter(struct file *file, struct kiocb *kio,
 
 static inline int call_mmap(struct file *file, struct vm_area_struct *vma)
 {
+	if (unlikely(is_overlay_file(file)))
+		return overlay_mmap(file, vma);
+
 	return file->f_op->mmap(file, vma);
 }
 
diff --git a/include/linux/overlay_util.h b/include/linux/overlay_util.h
index 886be9003bf3..2cd66bc316cc 100644
--- a/include/linux/overlay_util.h
+++ b/include/linux/overlay_util.h
@@ -6,8 +6,10 @@
 struct file;
 struct kiocb;
 struct iov_iter;
+struct vm_area_struct;
 
 extern ssize_t overlay_read_iter(struct file *file, struct kiocb *kio,
 				 struct iov_iter *iter);
+extern int overlay_mmap(struct file *file, struct vm_area_struct *vma);
 
 #endif /* _LINUX_OVERLAY_FS_H */
diff --git a/mm/mmap.c b/mm/mmap.c
index 3714aa4e6f81..c43dfe1846d1 100644
--- a/mm/mmap.c
+++ b/mm/mmap.c
@@ -1746,6 +1746,9 @@ unsigned long mmap_region(struct file *file, unsigned long addr,
 	return error;
 }
 
+/*
+ * Overlay needs special handling after copy-up
+ */
 unsigned long unmapped_area(struct vm_unmapped_area_info *info)
 {
 	/*
-- 
2.5.5
