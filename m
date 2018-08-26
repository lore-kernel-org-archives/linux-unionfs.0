Return-Path: <linux-fsdevel-owner@vger.kernel.org>
From: Amir Goldstein <amir73il@gmail.com>
Subject: [PATCH v2 4/6] vfs: fix readahead syscall on an overlayfs file
Date: Sun, 26 Aug 2018 19:25:15 +0300
Message-Id: <1535300717-26686-5-git-send-email-amir73il@gmail.com>
In-Reply-To: <1535300717-26686-1-git-send-email-amir73il@gmail.com>
References: <1535300717-26686-1-git-send-email-amir73il@gmail.com>
Sender: linux-fsdevel-owner@vger.kernel.org
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: Al Viro <viro@zeniv.linux.org.uk>, Dave Chinner <david@fromorbit.com>, linux-unionfs@vger.kernel.org, linux-fsdevel@vger.kernel.org
List-ID: <linux-unionfs@vger.kernel.org>

Overlayfs implements stacked file operations, but does not implement
stacked a_ops, so passing an overlayfs file to do_readahead() results
in an error.

Fix this by passing the real underlying file to do_readahead().

Fixes: d1d04ef8572b ("ovl: stack file ops")
Signed-off-by: Amir Goldstein <amir73il@gmail.com>
---
 mm/readahead.c | 9 +++++++--
 1 file changed, 7 insertions(+), 2 deletions(-)

diff --git a/mm/readahead.c b/mm/readahead.c
index a59ea70527b9..dc9c64ce6094 100644
--- a/mm/readahead.c
+++ b/mm/readahead.c
@@ -602,11 +602,16 @@ ssize_t ksys_readahead(int fd, loff_t offset, size_t count)
 	f = fdget(fd);
 	if (f.file) {
 		if (f.file->f_mode & FMODE_READ) {
-			struct address_space *mapping = f.file->f_mapping;
+			/*
+			 * XXX: We need to use file_real(), because overlayfs
+			 * stacked file/inode do not implement page io.
+			 */
+			struct file *file = file_real(f.file);
+			struct address_space *mapping = file->f_mapping;
 			pgoff_t start = offset >> PAGE_SHIFT;
 			pgoff_t end = (offset + count - 1) >> PAGE_SHIFT;
 			unsigned long len = end - start + 1;
-			ret = do_readahead(mapping, f.file, start, len);
+			ret = do_readahead(mapping, file, start, len);
 		}
 		fdput(f);
 	}
-- 
2.7.4
