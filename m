Return-Path: <linux-unionfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D618CEB64D9
	for <linux-unionfs@archiver.kernel.org>; Thu,  6 Jul 2023 09:52:19 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231948AbjGFJwT (ORCPT
        <rfc822;linux-unionfs@archiver.kernel.org>);
        Thu, 6 Jul 2023 05:52:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48966 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232217AbjGFJwS (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Thu, 6 Jul 2023 05:52:18 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C5AE81998
        for <linux-unionfs@vger.kernel.org>; Thu,  6 Jul 2023 02:51:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1688637087;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=7yVjrlxUhz99StDXOXpa96qJFsL+9P6tDZxK2+uoii0=;
        b=OrxK58as7B2KMNwiOe9NfnmOT3bs4lLovOVJA879GAm4N9yzDxnsiUjf8jKtud7j6ZHuFa
        eGzPtOoTYmvhTjCfNVhKNmhHSa20qO1utY7SQcb9K34S0njzHCYZ9SO/dYirGQvlXJR9P5
        7f71fRYTv314+YEr2ikklCsvPD7JBIU=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-497-LkgINJwrPWCj4ROEpaYMpw-1; Thu, 06 Jul 2023 05:51:23 -0400
X-MC-Unique: LkgINJwrPWCj4ROEpaYMpw-1
Received: from smtp.corp.redhat.com (int-mx10.intmail.prod.int.rdu2.redhat.com [10.11.54.10])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 696E981DA29;
        Thu,  6 Jul 2023 09:51:23 +0000 (UTC)
Received: from greebo.redhat.com (unknown [10.39.193.57])
        by smtp.corp.redhat.com (Postfix) with ESMTP id C40284CD0CD;
        Thu,  6 Jul 2023 09:51:22 +0000 (UTC)
From:   alexl@redhat.com
To:     fstests@vger.kernel.org
Cc:     linux-unionfs@vger.kernel.org, amir73il@gmail.com
Subject: [PATCH 2/4] overlay/060: add test cases of follow to lowerdata
Date:   Thu,  6 Jul 2023 11:50:59 +0200
Message-Id: <669007608d711c1c4f6b8f835affc2660084f76c.1688634271.git.alexl@redhat.com>
In-Reply-To: <cover.1688634271.git.alexl@redhat.com>
References: <cover.1688634271.git.alexl@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.10
Precedence: bulk
List-ID: <linux-unionfs.vger.kernel.org>
X-Mailing-List: linux-unionfs@vger.kernel.org

From: Amir Goldstein <amir73il@gmail.com>

Add test coverage for following metacopy from lower layer to
lower data with absolute, relative and no redirect.

Signed-off-by: Amir Goldstein <amir73il@gmail.com>
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

