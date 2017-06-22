From: Amir Goldstein <amir73il@gmail.com>
Subject: [PATCH v4 26/25] ovl: document copying layers restrictions with inodes index
Date: Thu, 22 Jun 2017 13:18:21 +0300
Message-ID: <1498126701-4849-1-git-send-email-amir73il@gmail.com>
References: <1498048136-28218-1-git-send-email-amir73il@gmail.com>
Return-path: <linux-fsdevel-owner@vger.kernel.org>
In-Reply-To: <1498048136-28218-1-git-send-email-amir73il@gmail.com>
Sender: linux-fsdevel-owner@vger.kernel.org
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: linux-unionfs@vger.kernel.org, linux-fsdevel@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org

The inodes index feature introduces a behavior change - on mount,
upper root origin file handle is verified to match the lower root dir.
This implies that copied layers cannot be mounted with the inodes index
feature enabled, without explicitly removing the upper dir origin xattr
and the index dir.

The inodes index feature is required to support:
- Prevent breaking hardlinks on copy up
- NFS export support (upcoming)
- Overlayfs snapshots (POC)

Signed-off-by: Amir Goldstein <amir73il@gmail.com>
---
 Documentation/filesystems/overlayfs.txt | 34 +++++++++++++++++++++++++++++++++
 1 file changed, 34 insertions(+)

Miklos,

I wrote in v4 posting that I updated the documentation, but forgot to send
out the documentation patch, so here goes.

There is one more behavior change that is related to indexing of directories
in v4.14, which we should consider including in v4.13, so v4.14 won't change
behavior of index enabled lookup.

The change is to verify lower of merge dir by origin and is available
on the following commit along with updated documentation [1]. I will post
this extra patch for your consideration after I am done running some more
tests.

Thanks,
Amir.

[1] https://github.com/amir73il/linux/commits/ovl-verify-dir

diff --git a/Documentation/filesystems/overlayfs.txt b/Documentation/filesystems/overlayfs.txt
index 8599fc9addbb..f63a8552bb81 100644
--- a/Documentation/filesystems/overlayfs.txt
+++ b/Documentation/filesystems/overlayfs.txt
@@ -201,6 +201,40 @@ rightmost one and going left.  In the above example lower1 will be the
 top, lower2 the middle and lower3 the bottom layer.
 
 
+Sharing and copying layers
+--------------------------
+
+Lower layers may be shared among several overlay mounts and that is indeed
+a very common practice.  An overlay mount may use the same lower layer
+path as another overlay mount and it may use a lower layer path that is
+beneath or above the path of another overlay lower layer path.
+
+Using an upper layer path and/or a workdir path that are already used by
+another overlay mount is not allowed and will fail with EBUSY.  Using
+partially overlapping paths is not allowed but will not fail with EBUSY.
+
+Mounting an overlay using an upper layer path, where the upper layer path
+was previously used by another mounted overlay in combination with a
+different lower layer path, is allowed, unless the "inodes index" feature
+is enabled.
+
+With the "inodes index" feature, on the first time mount, an NFS file
+handle of the lower layer root directory, along with the UUID of the lower
+filesystem, are encoded and stored in the "trusted.overlay.origin" extended
+attribute on the upper layer root directory.  On subsequent mount attempts,
+the lower root directory file handle and lower filesystem UUID are compared
+to the stored origin in upper root directory.  On failure to verify the
+lower root origin, mount will fail with ESTALE.  An overlayfs mount with
+"inodes index" enabled will fail with EOPNOTSUPP if the lower filesystem
+does not support NFS export, lower filesystem does not have a valid UUID or
+if the upper filesystem does not support extended attributes.
+
+It is quite a common practice to copy overlay layers to a different
+directory tree on the same or different underlying filesystem, and even
+to a different machine.  With the "inodes index" feature, trying to mount
+the copied layers will fail the verification of the lower root file handle.
+
+
 Non-standard behavior
 ---------------------
 
-- 
2.7.4
