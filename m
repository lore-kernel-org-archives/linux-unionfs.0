From: Miklos Szeredi <mszeredi@redhat.com>
Subject: [PATCH 3/7] mm: ovl: copy-up on MAP_SHARED
Date: Thu, 24 Nov 2016 11:55:40 +0100
Message-ID: <1479984944-1017-5-git-send-email-mszeredi@redhat.com>
References: <1479984944-1017-1-git-send-email-mszeredi@redhat.com>
Return-path: <linux-unionfs-owner@vger.kernel.org>
Received: from mail-wm0-f47.google.com ([74.125.82.47]:38094 "EHLO
        mail-wm0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S964905AbcKXKzz (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Thu, 24 Nov 2016 05:55:55 -0500
Received: by mail-wm0-f47.google.com with SMTP id f82so56380820wmf.1
        for <linux-unionfs@vger.kernel.org>; Thu, 24 Nov 2016 02:55:54 -0800 (PST)
In-Reply-To: <1479984944-1017-1-git-send-email-mszeredi@redhat.com>
Sender: linux-unionfs-owner@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org
To: linux-unionfs@vger.kernel.org
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org

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
index 1a41553db866..09a179f92d18 100644
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
+		if ((flag & MAP_SHARED) && !(prot & PROT_WRITE)) {
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
