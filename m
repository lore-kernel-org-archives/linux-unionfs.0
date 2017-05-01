From: Amir Goldstein <amir73il@gmail.com>
Subject: [PATCH v4 14/15] ovl: update documentation w.r.t. constant inode numbers
Date: Mon,  1 May 2017 16:42:05 +0300
Message-ID: <1493646126-10101-15-git-send-email-amir73il@gmail.com>
References: <1493646126-10101-1-git-send-email-amir73il@gmail.com>
Return-path: <linux-unionfs-owner@vger.kernel.org>
Received: from mail-wr0-f195.google.com ([209.85.128.195]:34146 "EHLO
        mail-wr0-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1424497AbdEANmX (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Mon, 1 May 2017 09:42:23 -0400
In-Reply-To: <1493646126-10101-1-git-send-email-amir73il@gmail.com>
Sender: linux-unionfs-owner@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: Vivek Goyal <vgoyal@redhat.com>, Al Viro <viro@zeniv.linux.org.uk>, linux-unionfs@vger.kernel.org, linux-fsdevel@vger.kernel.org

Signed-off-by: Amir Goldstein <amir73il@gmail.com>
---
 Documentation/filesystems/overlayfs.txt | 9 ++++++++-
 1 file changed, 8 insertions(+), 1 deletion(-)

diff --git a/Documentation/filesystems/overlayfs.txt b/Documentation/filesystems/overlayfs.txt
index 634d03e..c9e884b 100644
--- a/Documentation/filesystems/overlayfs.txt
+++ b/Documentation/filesystems/overlayfs.txt
@@ -21,12 +21,19 @@ from accessing the corresponding object from the original filesystem.
 This is most obvious from the 'st_dev' field returned by stat(2).
 
 While directories will report an st_dev from the overlay-filesystem,
-all non-directory objects will report an st_dev from the lower or
+non-directory objects may report an st_dev from the lower filesystem or
 upper filesystem that is providing the object.  Similarly st_ino will
 only be unique when combined with st_dev, and both of these can change
 over the lifetime of a non-directory object.  Many applications and
 tools ignore these values and will not be affected.
 
+In the special case of all overlay layers on the same underlying
+filesystem, all objects will report an st_dev from the overlay
+filesystem and st_ino from the underlying filesystem.  This will
+make the overlay mount more compliant with filesystem scanners and
+overlay objects will be distinguishable from the corresponding
+objects in the original filesystem.
+
 Upper and Lower
 ---------------
 
-- 
2.7.4
