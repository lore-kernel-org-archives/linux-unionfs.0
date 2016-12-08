From: Amir Goldstein <amir73il@gmail.com>
Subject: [PATCH] ovl: fix reStructuredText syntax errors in documentation
Date: Thu,  8 Dec 2016 09:49:51 +0200
Message-ID: <1481183391-30405-1-git-send-email-amir73il@gmail.com>
Return-path: <linux-unionfs-owner@vger.kernel.org>
Received: from mail-wm0-f65.google.com ([74.125.82.65]:36389 "EHLO
        mail-wm0-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750822AbcLHHuO (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Thu, 8 Dec 2016 02:50:14 -0500
Sender: linux-unionfs-owner@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: NeilBrown <neilb@suse.com>, Jonathan Corbet <corbet@lwn.net>, linux-unionfs@vger.kernel.org, linux-doc@vger.kernel.org

- Fix broken long line block quote
- Fix missing newline before bullets list
- Use correct numbered list syntax

Signed-off-by: Amir Goldstein <amir73il@gmail.com>
---
 Documentation/filesystems/overlayfs.txt | 7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

diff --git a/Documentation/filesystems/overlayfs.txt b/Documentation/filesystems/overlayfs.txt
index fb6f307..634d03e 100644
--- a/Documentation/filesystems/overlayfs.txt
+++ b/Documentation/filesystems/overlayfs.txt
@@ -66,7 +66,7 @@ At mount time, the two directories given as mount options "lowerdir" and
 "upperdir" are combined into a merged directory:
 
   mount -t overlay overlay -olowerdir=/lower,upperdir=/upper,\
-workdir=/work /merged
+  workdir=/work /merged
 
 The "workdir" needs to be an empty directory on the same filesystem
 as upperdir.
@@ -118,6 +118,7 @@ programs.
 
 seek offsets are assigned sequentially when the directories are read.
 Thus if
+
   - read part of a directory
   - remember an offset, and close the directory
   - re-open the directory some time later
@@ -137,12 +138,12 @@ When renaming a directory that is on the lower layer or merged (i.e. the
 directory was not created on the upper layer to start with) overlayfs can
 handle it in two different ways:
 
-1) return EXDEV error: this error is returned by rename(2) when trying to
+1. return EXDEV error: this error is returned by rename(2) when trying to
    move a file or directory across filesystem boundaries.  Hence
    applications are usually prepared to hande this error (mv(1) for example
    recursively copies the directory tree).  This is the default behavior.
 
-2) If the "redirect_dir" feature is enabled, then the directory will be
+2. If the "redirect_dir" feature is enabled, then the directory will be
    copied up (but not the contents).  Then the "trusted.overlay.redirect"
    extended attribute is set to the path of the original location from the
    root of the overlay.  Finally the directory is moved to the new
-- 
2.7.4
