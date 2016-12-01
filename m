From: Miklos Szeredi <mszeredi@redhat.com>
Subject: [PATCH 3/8] mm: ovl: copy-up on MAP_SHARED
Date: Thu,  1 Dec 2016 11:14:58 +0100
Message-ID: <1480587303-25088-4-git-send-email-mszeredi@redhat.com>
References: <1480587303-25088-1-git-send-email-mszeredi@redhat.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1480587303-25088-1-git-send-email-mszeredi@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Al Viro <viro@zeniv.linux.org.uk>
Cc: linux-unionfs@vger.kernel.org, linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org

A corner case of a corner case is when

 - file opened for O_RDONLY
 - which is then memory mapped SHARED
 - file opened for O_WRONLY
 - contents modified
 - contents read back though the shared mapping

Unfortunately it looks very difficult to do anything about the established
shared map after the file is copied up.  Instead when a read-only file is
mapped shared overlayfs copies up the file before actually doing the map.
This may result in unnecessary copy-ups (but so may copy-up on open(O_RDWR)
for exampe).

We can revisit this later if it turns out to be a performance problem in
real life.

Signed-off-by: Miklos Szeredi <mszeredi@redhat.com>
---
 mm/util.c | 22 ++++++++++++++++++++++
 1 file changed, 22 insertions(+)

diff --git a/mm/util.c b/mm/util.c
index 1a41553db866..449272271840 100644
--- a/mm/util.c
+++ b/mm/util.c
@@ -300,6 +300,28 @@ unsigned long vm_mmap_pgoff(struct file *file, unsigned long addr,
 
 	ret = security_mmap_file(file, prot, flag);
 	if (!ret) {
+		/*
+		 * Special treatment for overlayfs:
+		 *
+		 * Take MAP_SHARED/PROT_READ as hint about future writes to the
+		 * file (through another file descriptor).  Caller might not
+		 * have had such an intent, but we hope MAP_PRIVATE will be used
+		 * in most such cases.
+		 *
+		 * If we don't copy up now and the file is modified, it becomes
+		 * really difficult to change the mapping to match that of the
+		 * file's content later.
+		 *
+		 * Copy up needs to be done without mmap_sem since it takes vfs
+		 * locks which would potentially deadlock under mmap_sem.
+		 */
+		if ((flag & MAP_SHARED) && !(prot & PROT_WRITE) && file) {
+			void *p = d_real(file->f_path.dentry, NULL, O_WRONLY);
+
+			if (IS_ERR(p))
+				return PTR_ERR(p);
+		}
+
 		if (down_write_killable(&mm->mmap_sem))
 			return -EINTR;
 		ret = do_mmap_pgoff(file, addr, len, prot, flag, pgoff,
-- 
2.5.5
