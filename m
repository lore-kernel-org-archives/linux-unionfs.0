Return-Path: <linux-unionfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 33FA8C001E0
	for <linux-unionfs@archiver.kernel.org>; Wed, 16 Aug 2023 15:31:26 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344075AbjHPPa5 (ORCPT
        <rfc822;linux-unionfs@archiver.kernel.org>);
        Wed, 16 Aug 2023 11:30:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60462 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344181AbjHPPak (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Wed, 16 Aug 2023 11:30:40 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 913A42102
        for <linux-unionfs@vger.kernel.org>; Wed, 16 Aug 2023 08:29:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1692199793;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=YsVwatcA8F8IoIMuTPo1xBbXr7+nkypKa8fX71cqWb0=;
        b=P1lI4ePtu3yGnc+ASscNufx+dSF2kn3a5DSr8s0elGi0dSVFE4doUkowelmfdjXp3BxO7U
        sArw4aEYqnu+ZV35NqLGmv0rc+CpJrb1r8kJWcR7xzw9jcnuyOmAUA4kwYXE7Vt22bFBh9
        4pBuBjM+zinnlRpvNbCHd0P9So7SlXI=
Received: from mail-lj1-f200.google.com (mail-lj1-f200.google.com
 [209.85.208.200]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-546-mLHt8Jc6MY2gFADrdZ5WrQ-1; Wed, 16 Aug 2023 11:29:52 -0400
X-MC-Unique: mLHt8Jc6MY2gFADrdZ5WrQ-1
Received: by mail-lj1-f200.google.com with SMTP id 38308e7fff4ca-2bb8ab25c51so19147641fa.0
        for <linux-unionfs@vger.kernel.org>; Wed, 16 Aug 2023 08:29:51 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1692199790; x=1692804590;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=YsVwatcA8F8IoIMuTPo1xBbXr7+nkypKa8fX71cqWb0=;
        b=DIZDfLtkqIVKNoFfzccPtkdzO9fbTPAHY5rcn2e/hlj0qz4H+B7KkCVe0oK8Ya5vUG
         uKK2ZsVpP9QZXl3mZdT3mhqpKsk7tw5aRzqFLxX70JDT6IJbyF0QX2oxevbne/9JLp78
         p1r79i1n6h09pI6fjjncO9VL9EWwi3LLvwWw7fM/gIxeL3HgHYqy/mWiiBhLNlmUvYTY
         edSgD/JY4Skv6NG22pP8pJ+InX97QQ20aKGKYQqD3B+IC2eB8JZv+GtUNfgbP3fND7UU
         wBx0XrNBmBC0f6bzPhyBZo9ekKTGIzOqPuRoFrvdFeF9kO/KwrpZTcHk939BbgvMx2yd
         PJag==
X-Gm-Message-State: AOJu0Yx6kgmBOo6Ysl10QGb6hmFs4ccmm5R2tBg5loLQ4oV22Z847zfi
        rCDIPH1/z//sqM34uDp1zwIiedBAVDCwcLQbRg6STVDwbMGuxlN+I/wWoPGCWdhdEyRX74X9QWC
        U3M8S0clIIIsiw3MYJBXVm12n6Q==
X-Received: by 2002:a2e:9c86:0:b0:2b7:3656:c594 with SMTP id x6-20020a2e9c86000000b002b73656c594mr1991008lji.3.1692199790047;
        Wed, 16 Aug 2023 08:29:50 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IGMalznuD1aMqsqyGJSc8aToYrw4apo4xBU7DUXRa0uf2+Sce9xgsp6wbbWZZ9hwF3DS+MnTg==
X-Received: by 2002:a2e:9c86:0:b0:2b7:3656:c594 with SMTP id x6-20020a2e9c86000000b002b73656c594mr1990999lji.3.1692199789806;
        Wed, 16 Aug 2023 08:29:49 -0700 (PDT)
Received: from greebo.redhat.com (c-e6a5e255.022-110-73746f36.bbcust.telenor.se. [85.226.165.230])
        by smtp.googlemail.com with ESMTPSA id c13-20020a2e9d8d000000b002b9f03729e2sm3523160ljj.36.2023.08.16.08.29.49
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 16 Aug 2023 08:29:49 -0700 (PDT)
From:   Alexander Larsson <alexl@redhat.com>
To:     miklos@szeredi.hu
Cc:     linux-unionfs@vger.kernel.org, amir73il@gmail.com,
        Alexander Larsson <alexl@redhat.com>
Subject: [PATCH 4/4] ovl: Add documentation on nesting of overlayfs mounts
Date:   Wed, 16 Aug 2023 17:29:42 +0200
Message-ID: <4b7c9e6ab73021d09f5047ec2b6d8e36b4386f51.1692198910.git.alexl@redhat.com>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <cover.1692198910.git.alexl@redhat.com>
References: <cover.1692198910.git.alexl@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-unionfs.vger.kernel.org>
X-Mailing-List: linux-unionfs@vger.kernel.org

Signed-off-by: Alexander Larsson <alexl@redhat.com>
---
 Documentation/filesystems/overlayfs.rst | 22 ++++++++++++++++++++++
 1 file changed, 22 insertions(+)

diff --git a/Documentation/filesystems/overlayfs.rst b/Documentation/filesystems/overlayfs.rst
index 35853906accb..e38b2f5fadaf 100644
--- a/Documentation/filesystems/overlayfs.rst
+++ b/Documentation/filesystems/overlayfs.rst
@@ -492,6 +492,28 @@ directory tree on the same or different underlying filesystem, and even
 to a different machine.  With the "inodes index" feature, trying to mount
 the copied layers will fail the verification of the lower root file handle.
 
+Nesting overlayfs mounts
+------------------------
+
+It is possible to use a lower directory that is stored on an overlayfs
+mount. For regular files this does not need any special care. However, files
+that have overlayfs attributes, such as whiteouts or `overlay.*` xattrs will
+be interpreted by the underlying overlayfs mount and stripped out. In order to
+allow the second overlayfs mount to see the attributes they must be escaped.
+
+Overlayfs specific xattrs are escaped by using a special prefix of
+`overlay.overlay.`. So, a file with a `trusted.overlay.overlay.metacopy` xattr
+in the lower dir will be exposed as a regular file with a
+`trusted.overlay.metacopy` xattr in the overlayfs mount. This can be nested
+by repeating the prefix multiple time, as each instance only removes one
+prefix.
+
+Whiteouts files marked with a `overlay.nowhiteout` xattr will cause overlayfs
+not to treat them as a whiteout. Since this xattr is then stripped out, the
+next layer will instead apply the whiteout.
+
+Files created via overlayfs will automatically be created with the right
+escapes in the upper directory.
 
 Non-standard behavior
 ---------------------
-- 
2.41.0

