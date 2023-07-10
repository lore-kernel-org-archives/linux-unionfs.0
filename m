Return-Path: <linux-unionfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9A344EB64DC
	for <linux-unionfs@archiver.kernel.org>; Mon, 10 Jul 2023 09:09:02 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230264AbjGJJJA (ORCPT
        <rfc822;linux-unionfs@archiver.kernel.org>);
        Mon, 10 Jul 2023 05:09:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40310 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230496AbjGJJIK (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Mon, 10 Jul 2023 05:08:10 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DDCCBEC
        for <linux-unionfs@vger.kernel.org>; Mon, 10 Jul 2023 02:07:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1688980049;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=0q1N+KdGgbcn7sWWxv1wc0IDT0uUUrSHOTo56c4NlAo=;
        b=LjLKfAFJe+zqX4H4ElsLoSGIf3rOfplvsQM5bX04Qi88EWQASqDBLvjT+c/vHaVO+FRhog
        yhsRkUBlhfkJe9ItFwH6DU9tALGBIi9wtLyOU/mey7o0EdGUH6p21Zch5qRQ1u+E1V8Ou8
        z0twFut6JASRGIBJmh6drRb2E2zwpHQ=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-573-JSY_sC8MPIqnQqGUgAwNNQ-1; Mon, 10 Jul 2023 05:07:25 -0400
X-MC-Unique: JSY_sC8MPIqnQqGUgAwNNQ-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.rdu2.redhat.com [10.11.54.5])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id D5B93803B25;
        Mon, 10 Jul 2023 09:07:24 +0000 (UTC)
Received: from greebo.redhat.com (unknown [10.39.193.57])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 11552F5CED;
        Mon, 10 Jul 2023 09:07:23 +0000 (UTC)
From:   alexl@redhat.com
To:     fstests@vger.kernel.org
Cc:     linux-unionfs@vger.kernel.org, amir73il@gmail.com, alexl@redhat.com
Subject: [PATCH v2 1/4] overlay: add helper for mounting rdonly overlay
Date:   Mon, 10 Jul 2023 11:07:10 +0200
Message-Id: <d1be127cafcbbc7b25798d220e8c568bb7972a7c.1688979643.git.alexl@redhat.com>
In-Reply-To: <cover.1688979643.git.alexl@redhat.com>
References: <cover.1688979643.git.alexl@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.5
Precedence: bulk
List-ID: <linux-unionfs.vger.kernel.org>
X-Mailing-List: linux-unionfs@vger.kernel.org

From: Amir Goldstein <amir73il@gmail.com>

Allow passing empty upperdir to _overlay_mount_dirs().

Signed-off-by: Amir Goldstein <amir73il@gmail.com>
Signed-off-by: Alexander Larsson <alexl@redhat.com>
---
 common/overlay | 8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

diff --git a/common/overlay b/common/overlay
index 20cafeb1..452b3b09 100644
--- a/common/overlay
+++ b/common/overlay
@@ -17,15 +17,19 @@ if [ -n "$OVL_BASE_FSTYP" ];then
 fi
 
 # helper function to do the actual overlayfs mount operation
+# accepts "-" as upperdir for non-upper overlayfs
 _overlay_mount_dirs()
 {
 	local lowerdir=$1
 	local upperdir=$2
 	local workdir=$3
 	shift 3
+	local diropts="-olowerdir=$lowerdir"
 
-	$MOUNT_PROG -t overlay -o lowerdir=$lowerdir -o upperdir=$upperdir \
-		    -o workdir=$workdir `_common_dev_mount_options $*`
+	[ -n "$upperdir" ] && [ "$upperdir" != "-" ] && \
+		diropts+=",upperdir=$upperdir,workdir=$workdir"
+
+	$MOUNT_PROG -t overlay $diropts `_common_dev_mount_options $*`
 }
 
 # Mount with same options/mnt/dev of scratch mount, but optionally
-- 
2.40.1

