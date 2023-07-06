Return-Path: <linux-unionfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 62DE5EB64DD
	for <linux-unionfs@archiver.kernel.org>; Thu,  6 Jul 2023 09:52:20 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232217AbjGFJwT (ORCPT
        <rfc822;linux-unionfs@archiver.kernel.org>);
        Thu, 6 Jul 2023 05:52:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48950 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232225AbjGFJwS (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Thu, 6 Jul 2023 05:52:18 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 85AE3199E
        for <linux-unionfs@vger.kernel.org>; Thu,  6 Jul 2023 02:51:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1688637084;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=xR6FYz9KiyHMY7f5n4bMn5lrZ5rRrOAX+WF4meDMBGA=;
        b=CVmwtrWzZF5CmkOtMtY+XBmwerX0lLLm3gm2EZp7Jl9tmTYjmx9eKFz2ydO9soHGz2a4OB
        BUrQ4N+XFDSn8PfOyXoo81Sfy9VpTUkgUfM4/i/eIKies4QT2NbI55hCI8aHAlzxklPAj3
        MFUkO62/rVAc9J1DHXbmFCFtIpIBiuo=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-596-qR2NdBzXNlacRybXfv1Gig-1; Thu, 06 Jul 2023 05:51:21 -0400
X-MC-Unique: qR2NdBzXNlacRybXfv1Gig-1
Received: from smtp.corp.redhat.com (int-mx10.intmail.prod.int.rdu2.redhat.com [10.11.54.10])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 4CC7E88D4E1;
        Thu,  6 Jul 2023 09:51:21 +0000 (UTC)
Received: from greebo.redhat.com (unknown [10.39.193.57])
        by smtp.corp.redhat.com (Postfix) with ESMTP id A5C994CD0CE;
        Thu,  6 Jul 2023 09:51:20 +0000 (UTC)
From:   alexl@redhat.com
To:     fstests@vger.kernel.org
Cc:     linux-unionfs@vger.kernel.org, amir73il@gmail.com
Subject: [PATCH 1/4] overlay: add helper for mounting rdonly overlay
Date:   Thu,  6 Jul 2023 11:50:58 +0200
Message-Id: <76c983397d13212ff3105ae05fe4240d830440a9.1688634271.git.alexl@redhat.com>
In-Reply-To: <cover.1688634271.git.alexl@redhat.com>
References: <cover.1688634271.git.alexl@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.10
Precedence: bulk
List-ID: <linux-unionfs.vger.kernel.org>
X-Mailing-List: linux-unionfs@vger.kernel.org

From: Amir Goldstein <amir73il@gmail.com>

Allow passing empty upperdir to _overlay_mount_dirs().

Signed-off-by: Amir Goldstein <amir73il@gmail.com>
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

