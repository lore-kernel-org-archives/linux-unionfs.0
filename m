Return-Path: <linux-unionfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5491CEC874C
	for <linux-unionfs@archiver.kernel.org>; Thu,  7 Sep 2023 18:21:16 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229882AbjIGSVS (ORCPT
        <rfc822;linux-unionfs@archiver.kernel.org>);
        Thu, 7 Sep 2023 14:21:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53128 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238396AbjIGSVR (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Thu, 7 Sep 2023 14:21:17 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 89260171F
        for <linux-unionfs@vger.kernel.org>; Thu,  7 Sep 2023 11:20:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1694110806;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=NP7Wa0RScN6YMs1Im2Oo3v0GIpwA5kDlD7BuhnRw2B8=;
        b=TN5SfN0r9GhkhFv4PN5/hHrxFdS2hdfAuDYRTHQhoX2vMUYkmLehl8Qhe8B9mxGaS9YRjB
        MOMf5ErR2yDssHgRtL2VykhUcYoSatFuawy7sjydgSvmKEAA1ENmnONvttOlUI1ywBVoSL
        kU+6dIDh2C95t/PbapbXzgcf9BH7sGM=
Received: from mail-lj1-f200.google.com (mail-lj1-f200.google.com
 [209.85.208.200]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-230-eLkLbfgPOkueQHukRcG6tQ-1; Thu, 07 Sep 2023 04:44:18 -0400
X-MC-Unique: eLkLbfgPOkueQHukRcG6tQ-1
Received: by mail-lj1-f200.google.com with SMTP id 38308e7fff4ca-2bcbac80966so8450831fa.2
        for <linux-unionfs@vger.kernel.org>; Thu, 07 Sep 2023 01:44:17 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1694076256; x=1694681056;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=NP7Wa0RScN6YMs1Im2Oo3v0GIpwA5kDlD7BuhnRw2B8=;
        b=IDAdGIjZDZe9ddxwCBmtGj5/Ajf94OfpTDCGuYkqfwOHFeim5ucMPNvSn5dHzGlOo2
         4odyjP7SjNwtft3pHMDtcZFRWwA9wpUeW3uPgoZJbHpB/Egp1VfytkNAm3CMScKpf9BV
         iWc7bpH00CG2/g7L4hxZOCk0ZuJeq9tDBZM/NqPKA8ju5tH+Uw5CfsCcfxcEZSiL4r9L
         /nXuQqk9XqC2V9Qh+yO3x2pYSpnV1tflV8laFh57INULJczvHJLP5ysTvuSqq+cyb6Lz
         uELIo37zyJz+J++IQzI4vSxxjlaELVCZQOv53hlZdq3rNkdHzZpe2Fis3SxPTMcuCwJr
         tteA==
X-Gm-Message-State: AOJu0Yx3+yXU7kqh8caVj9mVwh1yX/XdXHtNxH374zaAd90pFguEfgDf
        i3i+qBajvFcb6u9QWfUamIJF/0u7OW5mn2VSy4c6kmukuMHh7ws0iR/rghbRIxLH+x9oxyfJC8u
        y24SMjKvMINHGW5k4DWCDemIo4g==
X-Received: by 2002:a2e:854e:0:b0:2bc:b9c7:7ba3 with SMTP id u14-20020a2e854e000000b002bcb9c77ba3mr4054293ljj.12.1694076256710;
        Thu, 07 Sep 2023 01:44:16 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IH863+jD1xImLQwzoYKLFTXwRTvG/3XWl3BQc+asVMWZUGiFv6AfznxFbRCZ0e+1GJcbeEA5A==
X-Received: by 2002:a2e:854e:0:b0:2bc:b9c7:7ba3 with SMTP id u14-20020a2e854e000000b002bcb9c77ba3mr4054279ljj.12.1694076256378;
        Thu, 07 Sep 2023 01:44:16 -0700 (PDT)
Received: from greebo.redhat.com (c-e6a5e255.022-110-73746f36.bbcust.telenor.se. [85.226.165.230])
        by smtp.googlemail.com with ESMTPSA id o6-20020a2e9b46000000b002b70a64d4desm3812828ljj.46.2023.09.07.01.44.15
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 07 Sep 2023 01:44:15 -0700 (PDT)
From:   Alexander Larsson <alexl@redhat.com>
To:     miklos@szeredi.hu
Cc:     linux-unionfs@vger.kernel.org, amir73il@gmail.com,
        Alexander Larsson <alexl@redhat.com>
Subject: [PATCH v3 0/6] Support nested overlayfs mounts
Date:   Thu,  7 Sep 2023 10:44:05 +0200
Message-ID: <cover.1694075674.git.alexl@redhat.com>
X-Mailer: git-send-email 2.41.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-unionfs.vger.kernel.org>
X-Mailing-List: linux-unionfs@vger.kernel.org

There are cases where you want to use an overlayfs mount as a lowerdir for
another overlayfs mount. For example, if the system rootfs is on overlayfs due
to composefs, or to make it volatile (via tmpfs), then you cannot currently store
a lowerdir on the rootfs, becasue the inner overlayfs will eat all the whiteouts
and overlay xattrs. This means you can't e.g. store on the rootfs a prepared
container image for use with overlayfs.

This patch series adds support for nesting of overlayfs mounts by escaping the
problematic features and unescaping them when exposing to the overlayfs user.

This series is also available here:
  https://github.com/alexlarsson/linux/tree/ovl-nesting

And xfstest to test it is available here:
  https://github.com/alexlarsson/xfstests/tree/overlayfs-nesting

The overlay/083 test checks both xattr escaping, the new whiteouts as well as
actual nesting of overlayfs.

Note that this series breaks the overlay/026 test which validates that
writing overlay.* xattrs is not supported, but it now is. I'm not sure
if we should fix this test to not fail, or if we should make this an
opt-in mount feature.

Changes since v2:
 * Uses a new approach for escaping whiteouts with a regular file with an
   overlay.whiteout xattr in a lower directory with an overlay.whiteouts
   xattr.

Changes since v1:

 * Moved all xattr handling to xattr.c
 * Made creation of escaped whiteouts atomic

Alexander Larsson (6):
  ovl: Move xattr support to new xattrs.c file
  ovl: Add OVL_XATTR_TRUSTED/USER_PREFIX_LEN macros
  ovl: Support escaped overlay.* xattrs
  ovl: Add an alternative type of whiteout
  ovl: Handle escaped xwhiteouts across layers
  ovl: Add documentation on nesting of overlayfs mounts

 Documentation/filesystems/overlayfs.rst |  23 ++
 fs/overlayfs/Makefile                   |   2 +-
 fs/overlayfs/dir.c                      |   4 +-
 fs/overlayfs/inode.c                    | 124 ----------
 fs/overlayfs/namei.c                    |  15 +-
 fs/overlayfs/overlayfs.h                |  42 +++-
 fs/overlayfs/readdir.c                  |  27 +-
 fs/overlayfs/super.c                    |  67 +----
 fs/overlayfs/util.c                     |  40 +++
 fs/overlayfs/xattrs.c                   | 312 ++++++++++++++++++++++++
 10 files changed, 443 insertions(+), 213 deletions(-)
 create mode 100644 fs/overlayfs/xattrs.c

-- 
2.41.0

