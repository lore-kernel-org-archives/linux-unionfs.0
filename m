Return-Path: <linux-unionfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:25948 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728021AbfBDSez (ORCPT <rfc822;linux-unionfs@vger.kernel.org>);
        Mon, 4 Feb 2019 13:34:55 -0500
Date: Mon, 4 Feb 2019 13:34:54 -0500
From: Vivek Goyal <vgoyal@redhat.com>
Subject: [PATCH] xfstest, overlayfs: Use falloc to make sure a meta copy file
 got copied up
Message-ID: <20190204183454.GA19549@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: linux-unionfs-owner@vger.kernel.org
To: fstests <fstests@vger.kernel.org>, linux-unionfs@vger.kernel.org
Cc: Amir Goldstein <amir73il@gmail.com>, Miklos Szeredi <miklos@szeredi.hu>
List-ID: <linux-unionfs@vger.kernel.org>

Overlayfs might copy up data of file on first write of file (and
not necessarily upon open of file). So call falloc file opened
with O_RDWR and after that data must have been copied up.

Signed-off-by: Vivek Goyal <vgoyal@redhat.com>
---
 tests/overlay/060 |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

Index: xfstests-dev/tests/overlay/060
===================================================================
--- xfstests-dev.orig/tests/overlay/060	2018-08-27 11:21:51.811847671 -0400
+++ xfstests-dev/tests/overlay/060	2019-02-04 11:28:09.023718690 -0500
@@ -170,7 +170,7 @@ test_common()
 
 	# Trigger data copy up and check absence of metacopy xattr.
 	mount_overlay $_lowerdir
-	$XFS_IO_PROG -c "open -a $SCRATCH_MNT/$_target"
+	$XFS_IO_PROG -c "falloc 0 1" $SCRATCH_MNT/$_target >> $seqres.full
 	echo "check properties of data copied up file"
 	check_file_size_contents $SCRATCH_MNT/$_target $_size "$_data"
 	umount_overlay
