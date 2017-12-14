From: "zhangyi (F)" <yi.zhang@huawei.com>
Subject: [PATCH v2 18/18] fsck.overlay: use relative path when checking lowers
Date: Thu, 14 Dec 2017 14:47:47 +0800
Message-ID: <20171214064747.20999-19-yi.zhang@huawei.com>
References: <20171214064747.20999-1-yi.zhang@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-unionfs-owner@vger.kernel.org>
Received: from szxga06-in.huawei.com ([45.249.212.32]:60206 "EHLO huawei.com"
        rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org with ESMTP
        id S1751523AbdLNGmK (ORCPT <rfc822;linux-unionfs@vger.kernel.org>);
        Thu, 14 Dec 2017 01:42:10 -0500
In-Reply-To: <20171214064747.20999-1-yi.zhang@huawei.com>
Sender: linux-unionfs-owner@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org
To: linux-unionfs@vger.kernel.org, fstests@vger.kernel.org
Cc: miklos@szeredi.hu, amir73il@gmail.com, eguan@redhat.com, darrick.wong@oracle.com, yi.zhang@huawei.com, miaoxie@huawei.com

Signed-off-by: zhangyi (F) <yi.zhang@huawei.com>
---
 README.md | 56 +++++++++++++++++++++++++++++++++-----------------------
 1 file changed, 33 insertions(+), 23 deletions(-)

diff --git a/README.md b/README.md
index 8de69cd..1d759b0 100644
--- a/README.md
+++ b/README.md
@@ -20,11 +20,12 @@ Opaque directories
 ------------------
 
 An opaque directory is a directory with "trusted.overlay.opaque" xattr valued
-"y". There are two legal situations of making opaque directory: 1) create
-directory over whiteout 2) creat directory in merged directory. If an opaque
-directory is found, corresponding matching name in lower layers might exist or
-parent directory might merged, If not, the opaque xattr will be treated as
-invalid and remove.
+"y". There are two legal situations of making opaque directory:
+1) Create directory over whiteout,
+2) Creat directory in merged directory.
+If an opaque directory is found, either corresponding matching name in lower
+layers is exist or parent directory is merged, If not, the opaque xattr will be
+treated as invalid and remove.
 
 
 Redirect directories
@@ -35,17 +36,21 @@ valued to the path of the original location from the root of the overlay. It
 is only used when renaming a directory and "redirect dir" feature is enabled.
 If an redirect directory is found, the following must be met:
 
-1) The directory store in redirect xattr should exist in one of lower layers.
+1) The directory path pointed by redirect xattr should exist in one of lower
+   layers.
 2) The origin directory should be redirected only once in one layer, which mean
    there is only one redirect xattr point to this origin directory in the
    specified layer.
-3) A whiteout or an opaque directory with the same name to origin should exist
-   in the same directory as the redirect directory.
+3) A whiteout or an opaque directory or another redirect directory with the
+   same name to origin should exist in the same directory as the redirect
+   directory.
 
 If not, 1) The redirect xattr is invalid and need to remove 2) One of the
-redirect xattr is redundant but not sure which one is, ask user 3) Create a
-whiteout device or set opaque xattr to an existing directory if the parent
-directory was meregd or remove xattr if not.
+redirect xattr is redundant but not sure which one is, ask user by default or
+remove in 'yes' mode 3) Check and fix the missing whiteout or opaque in redierct
+parent directory if there is no another redirected upper directory covering the
+redirect lower target.
+
 
 Usage
 =====
@@ -58,14 +63,17 @@ Usage
    fsck.overlay [-l lowerdir] [-u upperdir] [-w workdir] [-avhV]
 
    Options:
-   -l, --lowerdir=LOWERDIR   specify lower directories of overlayfs,
-                             multiple lower use ':' as separator.
-   -u, --upperdir=UPPERDIR   specify upper directory of overlayfs
-   -w, --workdir=WORKDIR     specify work directory of overlayfs
-   -a, --auto                repair automatically (no questions)
-   -v, --verbose             print more messages of overlayfs
-   -h, --help                display this usage of overlayfs
-   -V, --version             display version information
+   -l, --lowerdir=LOWERDIR	specify lower directories of overlayfs,
+				multiple lower use ':' as separator,
+				the leftmost one is the toppest
+   -u, --upperdir=UPPERDIR	specify upper directory of overlayfs
+   -w, --workdir=WORKDIR	specify work directory of overlayfs
+   -p,				automatic repair (no questions)
+   -n,				make no changes to the filesystem
+   -y,				assume "yes" to all questions
+   -v, --verbose		print more messages of overlayfs
+   -h, --help			display this usage of overlayfs
+   -V, --version		display version information
 
 3. Exit value:
    0      No errors
@@ -82,7 +90,9 @@ Todo
 
 1. Overlay filesystem mounted check. Prevent fscking when overlay is
    online. Now, We cannot distinguish mounted directories if overlayfs was
-   mounted with relative path.
-2. Symbolic link check.
-3. Check origin/impure/nlink xattr.
-4. ...
+   mounted with relative path. Should modify kernel together to support.
+2. Check and fix invalid redirect xattr through origin xattr.
+3. Symbolic link check.
+4. Check origin/impure/nlink xattr.
+5. Check index feature consistency.
+6. ...
-- 
2.9.5
