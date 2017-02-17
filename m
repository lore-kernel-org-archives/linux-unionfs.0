From: Miklos Szeredi <mszeredi@redhat.com>
Subject: [PATCH 6/9] mm: use helper for calling f_op->mmap()
Date: Fri, 17 Feb 2017 17:09:35 +0100
Message-ID: <1487347778-18596-7-git-send-email-mszeredi@redhat.com>
References: <1487347778-18596-1-git-send-email-mszeredi@redhat.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1487347778-18596-1-git-send-email-mszeredi@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Al Viro <viro@zeniv.linux.org.uk>
Cc: linux-unionfs@vger.kernel.org, linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org

Signed-off-by: Miklos Szeredi <mszeredi@redhat.com>
---
 drivers/gpu/drm/i915/i915_gem_dmabuf.c | 2 +-
 drivers/gpu/drm/vgem/vgem_drv.c        | 2 +-
 fs/coda/file.c                         | 2 +-
 include/linux/fs.h                     | 5 +++++
 ipc/shm.c                              | 2 +-
 mm/mmap.c                              | 2 +-
 mm/nommu.c                             | 4 ++--
 7 files changed, 12 insertions(+), 7 deletions(-)

diff --git a/drivers/gpu/drm/i915/i915_gem_dmabuf.c b/drivers/gpu/drm/i915/i915_gem_dmabuf.c
index 5e38299b5df6..84fc9f001576 100644
--- a/drivers/gpu/drm/i915/i915_gem_dmabuf.c
+++ b/drivers/gpu/drm/i915/i915_gem_dmabuf.c
@@ -141,7 +141,7 @@ static int i915_gem_dmabuf_mmap(struct dma_buf *dma_buf, struct vm_area_struct *
 	if (!obj->base.filp)
 		return -ENODEV;
 
-	ret = obj->base.filp->f_op->mmap(obj->base.filp, vma);
+	ret = call_mmap(obj->base.filp, vma);
 	if (ret)
 		return ret;
 
diff --git a/drivers/gpu/drm/vgem/vgem_drv.c b/drivers/gpu/drm/vgem/vgem_drv.c
index 477e07f0ecb6..9f7e222b3e89 100644
--- a/drivers/gpu/drm/vgem/vgem_drv.c
+++ b/drivers/gpu/drm/vgem/vgem_drv.c
@@ -287,7 +287,7 @@ static int vgem_prime_mmap(struct drm_gem_object *obj,
 	if (!obj->filp)
 		return -ENODEV;
 
-	ret = obj->filp->f_op->mmap(obj->filp, vma);
+	ret = call_mmap(obj->filp, vma);
 	if (ret)
 		return ret;
 
diff --git a/fs/coda/file.c b/fs/coda/file.c
index 6e0154eb6fcc..9d956cd6d46f 100644
--- a/fs/coda/file.c
+++ b/fs/coda/file.c
@@ -96,7 +96,7 @@ coda_file_mmap(struct file *coda_file, struct vm_area_struct *vma)
 	cfi->cfi_mapcount++;
 	spin_unlock(&cii->c_lock);
 
-	return host_file->f_op->mmap(host_file, vma);
+	return call_mmap(host_file, vma);
 }
 
 int coda_open(struct inode *coda_inode, struct file *coda_file)
diff --git a/include/linux/fs.h b/include/linux/fs.h
index d186d5390e99..4728c5178f3f 100644
--- a/include/linux/fs.h
+++ b/include/linux/fs.h
@@ -1737,6 +1737,11 @@ static inline ssize_t call_write_iter(struct file *file, struct kiocb *kio,
 	return file->f_op->write_iter(kio, iter);
 }
 
+static inline int call_mmap(struct file *file, struct vm_area_struct *vma)
+{
+	return file->f_op->mmap(file, vma);
+}
+
 ssize_t rw_copy_check_uvector(int type, const struct iovec __user * uvector,
 			      unsigned long nr_segs, unsigned long fast_segs,
 			      struct iovec *fast_pointer,
diff --git a/ipc/shm.c b/ipc/shm.c
index 81203e8ba013..4329fe3ef594 100644
--- a/ipc/shm.c
+++ b/ipc/shm.c
@@ -423,7 +423,7 @@ static int shm_mmap(struct file *file, struct vm_area_struct *vma)
 	if (ret)
 		return ret;
 
-	ret = sfd->file->f_op->mmap(sfd->file, vma);
+	ret = call_mmap(sfd->file, vma);
 	if (ret) {
 		shm_close(vma);
 		return ret;
diff --git a/mm/mmap.c b/mm/mmap.c
index dc4291dcc99b..3714aa4e6f81 100644
--- a/mm/mmap.c
+++ b/mm/mmap.c
@@ -1668,7 +1668,7 @@ unsigned long mmap_region(struct file *file, unsigned long addr,
 		 * new file must not have been exposed to user-space, yet.
 		 */
 		vma->vm_file = get_file(file);
-		error = file->f_op->mmap(file, vma);
+		error = call_mmap(file, vma);
 		if (error)
 			goto unmap_and_free_vma;
 
diff --git a/mm/nommu.c b/mm/nommu.c
index 24f9f5f39145..e366354f777d 100644
--- a/mm/nommu.c
+++ b/mm/nommu.c
@@ -1084,7 +1084,7 @@ static int do_mmap_shared_file(struct vm_area_struct *vma)
 {
 	int ret;
 
-	ret = vma->vm_file->f_op->mmap(vma->vm_file, vma);
+	ret = call_mmap(vma->vm_file, vma);
 	if (ret == 0) {
 		vma->vm_region->vm_top = vma->vm_region->vm_end;
 		return 0;
@@ -1115,7 +1115,7 @@ static int do_mmap_private(struct vm_area_struct *vma,
 	 * - VM_MAYSHARE will be set if it may attempt to share
 	 */
 	if (capabilities & NOMMU_MAP_DIRECT) {
-		ret = vma->vm_file->f_op->mmap(vma->vm_file, vma);
+		ret = call_mmap(vma->vm_file, vma);
 		if (ret == 0) {
 			/* shouldn't return success if we're not sharing */
 			BUG_ON(!(vma->vm_flags & VM_MAYSHARE));
-- 
2.5.5
