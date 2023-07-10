Return-Path: <linux-unionfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3A283C001DF
	for <linux-unionfs@archiver.kernel.org>; Mon, 10 Jul 2023 09:09:01 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230141AbjGJJI7 (ORCPT
        <rfc822;linux-unionfs@archiver.kernel.org>);
        Mon, 10 Jul 2023 05:08:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40456 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231443AbjGJJIZ (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Mon, 10 Jul 2023 05:08:25 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 106C3100
        for <linux-unionfs@vger.kernel.org>; Mon, 10 Jul 2023 02:07:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1688980056;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=9VOuhKioCo5AkZuRaPzcdh6vRoP6HW/j1lcD+EG9Wss=;
        b=f6l6/bF9oA+7OQ+1Cc7Np2oSkMCLVkv6/q1t9Ri7QCo68hg+sjYM7dJEg9nPSGKzrkKVhY
        GtgzRo37geDo/EzX6GO3u1R7CdQTxBkWZJo80z9fubtsZe6BMoFBkGLcuCiD1T1PEddQWq
        g0XOix8uo9M3Yo1v1eWoZUrvbQOBEnE=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-588-XI_ujepNPOSgkDuX_sb2qg-1; Mon, 10 Jul 2023 05:07:32 -0400
X-MC-Unique: XI_ujepNPOSgkDuX_sb2qg-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.rdu2.redhat.com [10.11.54.5])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 4D86838008A7;
        Mon, 10 Jul 2023 09:07:32 +0000 (UTC)
Received: from greebo.redhat.com (unknown [10.39.193.57])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 7E14DF66A8;
        Mon, 10 Jul 2023 09:07:31 +0000 (UTC)
From:   alexl@redhat.com
To:     fstests@vger.kernel.org
Cc:     linux-unionfs@vger.kernel.org, amir73il@gmail.com, alexl@redhat.com
Subject: [PATCH v2 2/4] overlay/060: add test cases of follow to lowerdata
Date:   Mon, 10 Jul 2023 11:07:11 +0200
Message-Id: <c084f47d1093e8c01ec001822596c528cb1fcf79.1688979643.git.alexl@redhat.com>
In-Reply-To: <cover.1688979643.git.alexl@redhat.com>
References: <cover.1688979643.git.alexl@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.5
Precedence: bulk
List-ID: <linux-unionfs.vger.kernel.org>
X-Mailing-List: linux-unionfs@vger.kernel.org

From: Amir Goldstein <amir73il@gmail.com>

Add test coverage for following metacopy from lower layer to
lower data with absolute, relative and no redirect.

Signed-off-by: Amir Goldstein <amir73il@gmail.com>
Signed-off-by: Alexander Larsson <alexl@redhat.com>
---
 tests/overlay/060     | 43 ++++++++++++++++++++++++++++++++++++++-----
 tests/overlay/060.out | 18 ++++++++++++++++++
 2 files changed, 56 insertions(+), 5 deletions(-)

diff --git a/tests/overlay/060 b/tests/overlay/060
index 363207ba..f37755da 100755
--- a/tests/overlay/060
+++ b/tests/overlay/060
@@ -7,7 +7,7 @@
 # Test metadata only copy up functionality.
 #
 . ./common/preamble
-_begin_fstest auto quick metacopy prealloc
+_begin_fstest auto quick metacopy redirect prealloc
 
 # Import common functions.
 . ./common/filter
@@ -123,6 +123,13 @@ mount_overlay()
 	_overlay_scratch_mount_dirs "$_lowerdir" $upperdir $workdir -o redirect_dir=on,index=on,metacopy=on
 }
 
+mount_ro_overlay()
+{
+	local _lowerdir=$1
+
+	_overlay_scratch_mount_dirs "$_lowerdir" "-" "-" -o ro,redirect_dir=follow,metacopy=on
+}
+
 umount_overlay()
 {
 	$UMOUNT_PROG $SCRATCH_MNT
@@ -146,7 +153,8 @@ test_common()
 	check_file_size_contents $SCRATCH_MNT/$_target $_size "$_data"
 	check_file_blocks $SCRATCH_MNT/$_target $_blocks
 
-	# Make sure copied up file is a metacopy file.
+	# Trigger metadata copy up and check existence of metacopy xattr.
+	chmod 400 $SCRATCH_MNT/$_target
 	umount_overlay
 	check_metacopy $upperdir/$_target "y"
 	check_file_size_contents $upperdir/$_target $_size ""
@@ -165,7 +173,7 @@ test_common()
 create_basic_files()
 {
 	_scratch_mkfs
-	mkdir -p $lowerdir $lowerdir2 $upperdir $workdir $workdir2
+	mkdir -p $lowerdir/subdir $lowerdir2 $upperdir $workdir $workdir2
 	mkdir -p $upperdir/$udirname
 	echo "$lowerdata" > $lowerdir/$lowername
 	chmod 600 $lowerdir/$lowername
@@ -184,12 +192,19 @@ create_lower_link()
 
 prepare_midlayer()
 {
+	local _redirect=$1
+
 	_scratch_mkfs
 	create_basic_files
+	[ -n "$_redirect" ] && mv "$lowerdir/$lowername" "$lowerdir/$_redirect"
 	# Create midlayer
 	_overlay_scratch_mount_dirs $lowerdir $lowerdir2 $workdir2 -o redirect_dir=on,index=on,metacopy=on
-	# Trigger a metacopy
-	chmod 400 $SCRATCH_MNT/$lowername
+	# Trigger a metacopy with or without redirect
+	if [ -n "$_redirect" ]; then
+		mv "$SCRATCH_MNT/$_redirect" "$SCRATCH_MNT/$lowername"
+	else
+		chmod 400 $SCRATCH_MNT/$lowername
+	fi
 	umount_overlay
 }
 
@@ -254,6 +269,24 @@ mount_overlay $lowerdir
 mv $SCRATCH_MNT/$lowerlink $SCRATCH_MNT/$ufile
 test_common $lowerdir $ufile $lowersize $lowerblocks "$lowerdata" "/$lowerlink"
 
+echo -e "\n== Check follow to lowerdata without redirect =="
+prepare_midlayer
+mount_ro_overlay "$lowerdir2:$lowerdir"
+test_common "$lowerdir2:$lowerdir" $lowername $lowersize $lowerblocks \
+		"$lowerdata"
+
+echo -e "\n== Check follow to lowerdata with relative redirect =="
+prepare_midlayer "$lowername.renamed"
+mount_ro_overlay "$lowerdir2:$lowerdir"
+test_common "$lowerdir2:$lowerdir" "$lowername" $lowersize $lowerblocks \
+		"$lowerdata"
+
+echo -e "\n== Check follow to lowerdata with absolute redirect =="
+prepare_midlayer "/subdir/$lowername"
+mount_ro_overlay "$lowerdir2:$lowerdir"
+test_common "$lowerdir2:$lowerdir" "$lowername" $lowersize $lowerblocks \
+		"$lowerdata"
+
 # success, all done
 status=0
 exit
diff --git a/tests/overlay/060.out b/tests/overlay/060.out
index a4790d31..f4ce0244 100644
--- a/tests/overlay/060.out
+++ b/tests/overlay/060.out
@@ -40,3 +40,21 @@ check properties of metadata copied up file
 Unmount and Mount again
 check properties of metadata copied up file
 check properties of data copied up file
+
+== Check follow to lowerdata without redirect ==
+check properties of metadata copied up file
+Unmount and Mount again
+check properties of metadata copied up file
+check properties of data copied up file
+
+== Check follow to lowerdata with relative redirect ==
+check properties of metadata copied up file
+Unmount and Mount again
+check properties of metadata copied up file
+check properties of data copied up file
+
+== Check follow to lowerdata with absolute redirect ==
+check properties of metadata copied up file
+Unmount and Mount again
+check properties of metadata copied up file
+check properties of data copied up file
-- 
2.40.1

