Return-Path: <linux-unionfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B1D85C2FC1F
	for <linux-unionfs@archiver.kernel.org>; Thu, 17 Aug 2023 11:06:53 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1350103AbjHQLGW (ORCPT
        <rfc822;linux-unionfs@archiver.kernel.org>);
        Thu, 17 Aug 2023 07:06:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48996 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1350154AbjHQLGT (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Thu, 17 Aug 2023 07:06:19 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 56104269F
        for <linux-unionfs@vger.kernel.org>; Thu, 17 Aug 2023 04:05:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1692270330;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=3L8oWLA1Kz6Q8iRLRvwHq/BIfgd1yeVvI+Btw+Nybpg=;
        b=S8HnrdRvqZm+9feha7WYLq+6RPrruXzQw3gQP5pDCLc/lr4QitumBVDtBOFhAH+FeK8raJ
        XEZxGCQSxl7RV7427G7iTJUP3/akPR9X9LhEgpe9I30xnVgHJodaSZ6JYrV379JALjSh/K
        /MVdqo3ooHtAE6efWiC4nJNz3bfkv1M=
Received: from mail-lj1-f198.google.com (mail-lj1-f198.google.com
 [209.85.208.198]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-212-zmdPHamMP7yfumNGfwqfXw-1; Thu, 17 Aug 2023 07:05:29 -0400
X-MC-Unique: zmdPHamMP7yfumNGfwqfXw-1
Received: by mail-lj1-f198.google.com with SMTP id 38308e7fff4ca-2ba83b74a49so48156631fa.2
        for <linux-unionfs@vger.kernel.org>; Thu, 17 Aug 2023 04:05:28 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1692270327; x=1692875127;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=3L8oWLA1Kz6Q8iRLRvwHq/BIfgd1yeVvI+Btw+Nybpg=;
        b=UKvlywS8SWgW4+Yxk4q6AtDQy7VkaNEzB5sYJyVNuJ0bQqyh/4z2YVZY3dCKs2c79c
         UVYLap+mB2zoqQ/dxOx3LE+79xaWDpRVeMe00X7kO4UWWYFFNvrT6CbZ5PjHvjf/I3wR
         +h/L8Mebw+WuhhTIFEuMEbGLmPy52sQLVWRDH0AaZTOrWq1y3/KSBTd27DmgkoKQ9KNb
         bdfQdiiNZhEM3YDXBtRiINvxjyi8uG1Fwh17c7yyfZ3GRCiWHamrER24MKFogHS1jsBV
         M7kYUlbXV1KFU7YlXXItRaS/yOj1LEmD63BAmlYPa7dQRQN4bJMZ8xQGogR0Yr2HnvQl
         wTzw==
X-Gm-Message-State: AOJu0YwW9kmWEef6Wy4se1/OWdFG0hTLKI0E2Qee46n9ZDL66Qn1BjIi
        sU/lGjOLjy5cPJUmY4sDW1x1hO8YmYd+ZrwmpkVVIwUWKNj5u/YNS8C4HxAEg817xBajjOzcy8z
        nsEBRKSvuhURc2blRWyJEutHgVA==
X-Received: by 2002:a2e:87c6:0:b0:2b9:4aa1:71e1 with SMTP id v6-20020a2e87c6000000b002b94aa171e1mr3583848ljj.50.1692270327681;
        Thu, 17 Aug 2023 04:05:27 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IEcFhEKvjKY3FN+FwwgdGQK9pCtSuIIZKBcTcjdt45rlLu0dAaJBF2czUoapZPwEDQrRKw7QQ==
X-Received: by 2002:a2e:87c6:0:b0:2b9:4aa1:71e1 with SMTP id v6-20020a2e87c6000000b002b94aa171e1mr3583827ljj.50.1692270327271;
        Thu, 17 Aug 2023 04:05:27 -0700 (PDT)
Received: from greebo.redhat.com (c-e6a5e255.022-110-73746f36.bbcust.telenor.se. [85.226.165.230])
        by smtp.googlemail.com with ESMTPSA id l20-20020a2e8694000000b002ba15c272e8sm69010lji.71.2023.08.17.04.05.26
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 17 Aug 2023 04:05:26 -0700 (PDT)
From:   Alexander Larsson <alexl@redhat.com>
To:     miklos@szeredi.hu
Cc:     linux-unionfs@vger.kernel.org, amir73il@gmail.com,
        Alexander Larsson <alexl@redhat.com>
Subject: [PATCH v2 0/5] Support nested overlayfs mounts
Date:   Thu, 17 Aug 2023 13:05:19 +0200
Message-ID: <cover.1692270188.git.alexl@redhat.com>
X-Mailer: git-send-email 2.41.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-unionfs.vger.kernel.org>
X-Mailing-List: linux-unionfs@vger.kernel.org

There are cases where you want to use an overlayfs mount as a lowerdir for
another overlayfs mount. For example, if the system rootfs is on overlayfs due
to composefs, or to make it volatile (via tmps), then you cannot currently store
a lowerdir on the rootfs, becasue the inner overlayfs will eat all the whiteouts
and overlay xattrs. This means you can't e.g. store on the rootfs a prepared
container image for use using overlayfs.

This patch series adds support for nesting of overlayfs mounts by escaping the
problematic features on and unescaping them when exposing to the overlayfs user.

This series is also available here:
  https://github.com/alexlarsson/linux/tree/ovl-nesting

And xfstest to test it is available here:
  https://github.com/alexlarsson/xfstests/tree/overlayfs-nesting

Changes since v1:

 * Moved all xattr handling to xattr.c
 * Made creation of escaped whiteouts atomic

Alexander Larsson (5):
  ovl: Move xattr support to new xattrs.c file
  ovl: Add OVL_XATTR_TRUSTED/USER_PREFIX_LEN macros
  ovl: Support escaped overlay.* xattrs
  ovl: Support creation of whiteout files on overlayfs
  ovl: Add documentation on nesting of overlayfs mounts

 Documentation/filesystems/overlayfs.rst |  22 ++
 fs/overlayfs/Makefile                   |   2 +-
 fs/overlayfs/dir.c                      |  24 ++-
 fs/overlayfs/inode.c                    | 124 -----------
 fs/overlayfs/namei.c                    |  14 +-
 fs/overlayfs/overlayfs.h                |  40 +++-
 fs/overlayfs/readdir.c                  |   7 +-
 fs/overlayfs/super.c                    |  67 +-----
 fs/overlayfs/util.c                     |  20 ++
 fs/overlayfs/xattrs.c                   | 268 ++++++++++++++++++++++++
 10 files changed, 376 insertions(+), 212 deletions(-)
 create mode 100644 fs/overlayfs/xattrs.c

-- 
2.41.0

