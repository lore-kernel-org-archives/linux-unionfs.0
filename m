Return-Path: <linux-unionfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EC302CA0ECA
	for <linux-unionfs@archiver.kernel.org>; Tue, 12 Sep 2023 09:56:51 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233065AbjILJ4y (ORCPT
        <rfc822;linux-unionfs@archiver.kernel.org>);
        Tue, 12 Sep 2023 05:56:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33090 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230345AbjILJ4y (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Tue, 12 Sep 2023 05:56:54 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id CEE8510DF
        for <linux-unionfs@vger.kernel.org>; Tue, 12 Sep 2023 02:56:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1694512565;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=21+5Tv3wnoJkl/6e3ut9/P+hjFMML4aVkno1i0U9K+g=;
        b=AtFTyXg09AzBeQHPT7SOFDD39RYK+q14nEvWx1AqsYCm9VOlaFkUrf4tNUYs/ctacm8zKT
        5C1DZkLxd3UemOaQszzRxzgqXJfiFSKnz05VN5Z+IbMKGic0gooqehnrFXRXkHXi0EKRUI
        07QCn5pReALepZE9TZWY3Nnf5O86xZ4=
Received: from mail-lf1-f69.google.com (mail-lf1-f69.google.com
 [209.85.167.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-530--CLHmBCjMXO_TR70uv6vSA-1; Tue, 12 Sep 2023 05:56:04 -0400
X-MC-Unique: -CLHmBCjMXO_TR70uv6vSA-1
Received: by mail-lf1-f69.google.com with SMTP id 2adb3069b0e04-5029c5f4285so4648841e87.3
        for <linux-unionfs@vger.kernel.org>; Tue, 12 Sep 2023 02:56:03 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1694512562; x=1695117362;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=21+5Tv3wnoJkl/6e3ut9/P+hjFMML4aVkno1i0U9K+g=;
        b=OuCjI8VoxA9inmjfBnSD+It0gk149DX1mbgN5t51sb/1IC2+GpUyw3MS4QlPduaeS0
         w0+Ca/Cu6YuqlS2MG/7kiATIrPTkaVSz+t9hyurb1aUNH6pn2UXy3EEosT11SYPg+vrT
         StMuTrQEGLn2KYwjZ6uOjVQP+nTynSbw5+3UvFHHYv3/Oj0PpyPamKhY0XOnwDKHlBwW
         u6rmUqeYzTEuHR/vLSM2DbVAvD8eRJUfrnEqwv029VFRUrWkIyabMN0t50Q9kZe90pqQ
         WCHhTHAm8zawlnIKFtP4mm766eqSF+hTJxVUrZuMUCT8YRldL1yjxhjCgjXV1zlf0xHE
         cHCw==
X-Gm-Message-State: AOJu0YyBFJ4jc2iQk7ZabUMeuzKOn/qa5p3AGrSNnZ/JTVbDI32Skv5U
        MjnzAqacOLgW+rte0IGjmPmsu7qsUcxrPfLJIsr8PSIEKPCdBxBL1iJxQ4veTKXs7YR1q77TyNR
        519lJDu/81mn5ZC8CBKfEsTyUtw==
X-Received: by 2002:a19:8c10:0:b0:4ff:87f2:2236 with SMTP id o16-20020a198c10000000b004ff87f22236mr8499338lfd.37.1694512562564;
        Tue, 12 Sep 2023 02:56:02 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IE0Rn1iQkzFgn8zoNZwBkaQPR1cHxuFsX9/BXwwLF85vqT6PRNn/HDXkh5UAsbIwuxLGexuOw==
X-Received: by 2002:a19:8c10:0:b0:4ff:87f2:2236 with SMTP id o16-20020a198c10000000b004ff87f22236mr8499329lfd.37.1694512562250;
        Tue, 12 Sep 2023 02:56:02 -0700 (PDT)
Received: from greebo.redhat.com (c-e6a5e255.022-110-73746f36.bbcust.telenor.se. [85.226.165.230])
        by smtp.googlemail.com with ESMTPSA id t15-20020ac243af000000b004fdba93b92asm1691766lfl.252.2023.09.12.02.56.01
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 12 Sep 2023 02:56:01 -0700 (PDT)
From:   Alexander Larsson <alexl@redhat.com>
To:     miklos@szeredi.hu
Cc:     linux-unionfs@vger.kernel.org, amir73il@gmail.com,
        Alexander Larsson <alexl@redhat.com>
Subject: [PATCH v4 0/5] Support nested overlayfs mounts with xattrs and whiteous
Date:   Tue, 12 Sep 2023 11:55:54 +0200
Message-ID: <cover.1694512044.git.alexl@redhat.com>
X-Mailer: git-send-email 2.41.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-unionfs.vger.kernel.org>
X-Mailing-List: linux-unionfs@vger.kernel.org

There are cases where you want to use an overlayfs mount as a lowerdir for
another overlayfs mount. For example, if the system rootfs is on overlayfs due
to composefs, or to make it volatile (via tmpfs), then you cannot currently store
a lowerdir on the rootfs, because the inner overlayfs will eat all the whiteouts
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

Changes since v3:
 * Dropped the handling of whiteout xattrs across layers.
 * Copy-up escaped overlayfs xattrs.
 * Minor code cleanups.
 
Changes since v2:
 * Uses a new approach for escaping whiteouts with a regular file with an
   overlay.whiteout xattr in a lower directory with an overlay.whiteouts
   xattr.

Changes since v1:

 * Moved all xattr handling to xattr.c
 * Made creation of escaped whiteouts atomic

Alexander Larsson (5):
  ovl: Move xattr support to new xattrs.c file
  ovl: Add OVL_XATTR_TRUSTED/USER_PREFIX_LEN macros
  ovl: Support escaped overlay.* xattrs
  ovl: Add an alternative type of whiteout
  ovl: Add documentation on nesting of overlayfs mounts

 Documentation/filesystems/overlayfs.rst |  23 ++
 fs/overlayfs/Makefile                   |   2 +-
 fs/overlayfs/dir.c                      |   4 +-
 fs/overlayfs/inode.c                    | 124 -----------
 fs/overlayfs/namei.c                    |  15 +-
 fs/overlayfs/overlayfs.h                |  42 +++-
 fs/overlayfs/readdir.c                  |  27 ++-
 fs/overlayfs/super.c                    |  67 +-----
 fs/overlayfs/util.c                     |  40 ++++
 fs/overlayfs/xattrs.c                   | 273 ++++++++++++++++++++++++
 10 files changed, 404 insertions(+), 213 deletions(-)
 create mode 100644 fs/overlayfs/xattrs.c

-- 
2.41.0

