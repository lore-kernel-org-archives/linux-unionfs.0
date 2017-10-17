From: Amir Goldstein <amir73il@gmail.com>
Subject: [PATCH 14/14] ovl: document NFS export
Date: Tue, 17 Oct 2017 19:44:31 +0300
Message-ID: <1508258671-10800-15-git-send-email-amir73il@gmail.com>
References: <1508258671-10800-1-git-send-email-amir73il@gmail.com>
Return-path: <linux-unionfs-owner@vger.kernel.org>
Received: from mail-wm0-f65.google.com ([74.125.82.65]:56281 "EHLO
        mail-wm0-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S937051AbdJQQoQ (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Tue, 17 Oct 2017 12:44:16 -0400
In-Reply-To: <1508258671-10800-1-git-send-email-amir73il@gmail.com>
Sender: linux-unionfs-owner@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: Jeff Layton <jlayton@poochiereds.net>, "J . Bruce Fields" <bfields@fieldses.org>, linux-unionfs@vger.kernel.org, linux-fsdevel@vger.kernel.org

Signed-off-by: Amir Goldstein <amir73il@gmail.com>
---
 Documentation/filesystems/overlayfs.txt | 61 +++++++++++++++++++++++++++++++++
 1 file changed, 61 insertions(+)

diff --git a/Documentation/filesystems/overlayfs.txt b/Documentation/filesystems/overlayfs.txt
index d89041baceb9..dbd829b0b12b 100644
--- a/Documentation/filesystems/overlayfs.txt
+++ b/Documentation/filesystems/overlayfs.txt
@@ -285,6 +285,67 @@ merged with the upper directory instead.  The "verify_dir" feature,
 therefore, makes an overlay mount cope better with the situations of
 lower directory rename and delete.
 
+
+NFS export
+----------
+
+An overlay filesystem may be exported to NFS when:
+- All underlying filesystems support NFS file handles
+- overlay is mounted with the mount options "index=all,verify_dir"
+- overlay is not using multiple lower layers
+
+With the "index=all" feature, on copy_up of any lower object, an index
+entry is created under the index directory.  The index entry name is the
+hexadecimal representation of the copy up origin file handle.  For a
+non-directory object, the index entry is a hard link to the upper inode.
+For a directory object, the index entry has an extended attribute
+"trusted.overlay.origin" with an encoded file handle of the upper
+directory inode.
+
+When encoding a file handle from an overlay filesystem object, the
+following rules apply:
+
+1. For a non-upper object, encode a lower file handle from lower inode
+2. For a pure-upper object, encode an upper file handle from upper inode
+3. For an indexed object, encode a lower file handle from copy_up origin
+
+Encoding a lower directory file handle will copy up and index that
+directory, so the index can be use on decode to find the upper directory.
+An existing non-indexed merged directory cannot be encoded with current
+NFS export implementation.
+
+The encoded overlay file handle includes:
+ - Header including path type information (e.g. lower/upper)
+ - UUID of the underlying filesystem
+ - Underlying filesystem encoding of underlying inode
+
+This encoding is identical to the encoding of copy_up origin stored in
+"trusted.overlay.origin".
+
+When decoding an overlay file handle, the following steps are followed:
+
+1. Find underlying layer by UUID and path type information.
+2. Decode the underlying filesystem file handle to underlying dentry.
+3. Lookup the file handle in index directory by name.
+4. If not found in index, instantiate an overlay dentry from the decoded
+   lower dentry.
+6. If a non-directory is found in index, instantiate a disconnected overlay
+   dentry from the upper index dentry and the decoded lower dentry.
+5. If a directory is found in index, decode upper dentry from file handle
+   stored in extended attribute "trusted.overlay.origin" in the index and
+   instantiate an overlay dentry from the decoded upper and lower dentries.
+7. If a whiteout is found in index, return ESTALE. This represents an
+   overlay object that was deleted after its file handle was encoded.
+
+The "verify_dir" mount option and no multiple lower layer requirements,
+ensure that a decoded overlay directory object will be equivalent to the
+object that was used to encode the file handle.
+
+Decoding a non-directory file handle may return a disconnected dentry.
+copy_up of that disconnected dentry will create an upper index entry with
+no upper alias.
+
+
 Testsuite
 ---------
 
-- 
2.7.4
