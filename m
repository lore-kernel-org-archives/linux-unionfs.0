Return-Path: <olga.kornievskaia@gmail.com>
Return-Path: <olga.kornievskaia@gmail.com>
From: Olga Kornievskaia <olga.kornievskaia@gmail.com>
Subject: [PATCH 1/1] man-page: copy_file_range(2) allow for cross-device copies
Date: Tue, 30 Oct 2018 16:56:04 -0400
Message-Id: <20181030205614.40754-3-olga.kornievskaia@gmail.com>
In-Reply-To: <20181030205614.40754-1-olga.kornievskaia@gmail.com>
References: <20181030205614.40754-1-olga.kornievskaia@gmail.com>
To: trond.myklebust@hammerspace.com, anna.schumaker@netapp.com, viro@zeniv.linux.org.uk, smfrench@gmail.com, miklos@szeredi.hu
Cc: linux-nfs@vger.kernel.org, linux-fsdevel@vger.kernel.org, linux-cifs@vger.kernel.org, linux-unionfs@vger.kernel.org, linux-man@vger.kernel.org
List-ID: <linux-unionfs@vger.kernel.org>

From: Olga Kornievskaia <kolga@netapp.com>

A proposed VFS change removes the check for the files to reside
under the same file system prior to attempting a copy. Instead,
a file system driver implementation of the destination file
is allowed to perform a cross-device copy_file_range(). If
that filesystem does not support cross device copy, it returns
-EXDEV.

Signed-off-by: Olga Kornievskaia <kolga@netapp.com>
---
 man2/copy_file_range.2 | 9 +++++----
 1 file changed, 5 insertions(+), 4 deletions(-)

diff --git a/man2/copy_file_range.2 b/man2/copy_file_range.2
index 20374ab..03750c5 100644
--- a/man2/copy_file_range.2
+++ b/man2/copy_file_range.2
@@ -39,7 +39,8 @@ The
 .BR copy_file_range ()
 system call performs an in-kernel copy between two file descriptors
 without the additional cost of transferring data from the kernel to user space
-and then back into the kernel.
+and then back into the kernel. Starting kernel version 4.21 passed in
+file descriptors are not required to be under the same mounted file system.
 It copies up to
 .I len
 bytes of data from file descriptor
@@ -129,9 +130,9 @@ Out of memory.
 There is not enough space on the target filesystem to complete the copy.
 .TP
 .B EXDEV
-The files referred to by
-.IR file_in " and " file_out
-are not on the same mounted filesystem.
+The file system of the 
+.I file_out
+does not support cross device file copy.
 .SH VERSIONS
 The
 .BR copy_file_range ()
-- 
1.8.3.1
