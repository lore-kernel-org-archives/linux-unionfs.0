Return-Path: <linux-unionfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D38DCC77B61
	for <linux-unionfs@archiver.kernel.org>; Thu, 27 Apr 2023 13:05:47 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243492AbjD0NFr (ORCPT
        <rfc822;linux-unionfs@archiver.kernel.org>);
        Thu, 27 Apr 2023 09:05:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34830 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243367AbjD0NFq (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Thu, 27 Apr 2023 09:05:46 -0400
Received: from mail-wr1-x434.google.com (mail-wr1-x434.google.com [IPv6:2a00:1450:4864:20::434])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 532102D72
        for <linux-unionfs@vger.kernel.org>; Thu, 27 Apr 2023 06:05:45 -0700 (PDT)
Received: by mail-wr1-x434.google.com with SMTP id ffacd0b85a97d-2f87c5b4635so7636114f8f.1
        for <linux-unionfs@vger.kernel.org>; Thu, 27 Apr 2023 06:05:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1682600744; x=1685192744;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=sZJh/gJ4iqyXHCOWDpuQVQJzNZE9BNtqZM/CW+tuXGU=;
        b=Vd0ZM6p5RgX3uCI3cjcJUyLJdj+Y6WkyxsFy6ZgX7KLeICZcFH4/amX9vOQB/3E4jE
         7B3HuMJOSQBmIlL9gyrRSprt3BOux4aWF/mfjIwznc5tq16UTEwFfs2FzoIbcpIPM7hU
         0GqJLh+QnhnvesAlJIQ0iCyaTQ02RyIwJ4ysCoCaMIMSyx4fdLHTp86MFi0CQmjGrWg3
         QrGuaHEshGOYWpFcW2GD+8gBkz1cw3XsCnOB8m+vfsOwjhAwXRcHJXZPDdH+3FJdxoHV
         bujsh7RseN4EKnb21XZ2jffaUgrnsROaduWT2kD1oJqsYU+tMY/gFLKr9LJS3C7YgVLG
         Zm8A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1682600744; x=1685192744;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=sZJh/gJ4iqyXHCOWDpuQVQJzNZE9BNtqZM/CW+tuXGU=;
        b=eKmquNnXJMAA0NB2Bc/IGHLGMRdzUYPOyLm8+61OvpwQYiEMUxNJFKaMAX+1IXQKL5
         051+YFe1tHxMsw9PelQFYvBKNwZ608oMLxJFQPnUMNgnpD3A5qabF8x4QdDhn2RT5I0d
         24anI5SLd3AarRGDi3Ncwx4fgLSAvPs2ComU3gbNSLDhAxd+kvjT6sU+8wxGAw5sUSab
         CU7fg9tmtY/kVCmST9LUngOUP1qqQPkbQmXk5yeSM3jA7o3d7E/Fp0j2GBVnz+MmZEms
         bfxiON/BzH2U6WAe/Q1Y0uz386U0XgRDxyxDv0+H+CUh45wEshlORmuNCgfEnHPfpa4j
         WY2w==
X-Gm-Message-State: AC+VfDysaNrQP61Y0NHIvs6N2/qZ4vsEaYNGo1xS3syqM5pB87nN68U+
        Ewheoe8l4fXgFC2HkKMSCwU=
X-Google-Smtp-Source: ACHHUZ4KSl+EedWk4B2EDHuOnMvaELZt7r3S5uMB3Irik7l2l70N0SW+tp2qj4Dmr36xziiMcghgXA==
X-Received: by 2002:adf:edd0:0:b0:300:6473:e33b with SMTP id v16-20020adfedd0000000b003006473e33bmr1364590wro.53.1682600743431;
        Thu, 27 Apr 2023 06:05:43 -0700 (PDT)
Received: from amir-ThinkPad-T480.lan ([5.29.249.86])
        by smtp.gmail.com with ESMTPSA id k17-20020a5d6291000000b002c561805a4csm18533426wru.45.2023.04.27.06.05.41
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 27 Apr 2023 06:05:43 -0700 (PDT)
From:   Amir Goldstein <amir73il@gmail.com>
To:     Miklos Szeredi <miklos@szeredi.hu>
Cc:     Alexander Larsson <alexl@redhat.com>, linux-unionfs@vger.kernel.org
Subject: [PATCH v2 00/13] Overlayfs lazy lookup of lowerdata
Date:   Thu, 27 Apr 2023 16:05:26 +0300
Message-Id: <20230427130539.2798797-1-amir73il@gmail.com>
X-Mailer: git-send-email 2.34.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-unionfs.vger.kernel.org>
X-Mailing-List: linux-unionfs@vger.kernel.org

Miklos,

This v2 combines the prep patch set [1] and lazy lookup patch set [2].

This work is motivated by Alexander's composefs use case.
Alexander has been developing and testing his fsverity patches over
my lazy-lowerdata-lookup branch [3].

Alexander has also written tests for lazy lowerdata lookup [4].

Note that patch #1 is a Fixes patch for stable.
Gao commented that the fix may not be complete, but I think it is better
than no fix at all.

Regarding lazy lookup in d_real(), I am not sure if the best effort
lookup is the best solution, but in any case, none of this code kicks in
without explicit opt-in to data-only layers, so the risk of breaking
existing setups is quite low.

Thanks,
Amir.

Changes since v1:
- Include the prep patch set
- Split remove lowerdata from add lowerdata_redirect patch
- Remove embedded ovl_entry stack optimization
- Add lazy lookup and comment in d_real_inode()
- Improve documentation of :: data-only layers syntax
- Added RVBs

[1] https://lore.kernel.org/linux-unionfs/20230408164302.1392694-1-amir73il@gmail.com/
[2] https://lore.kernel.org/linux-unionfs/20230412135412.1684197-1-amir73il@gmail.com/
[3] https://github.com/amir73il/linux/commits/ovl-lazy-lowerdata
[4] https://github.com/amir73il/xfstests/commits/ovl-lazy-lowerdata

Amir Goldstein (13):
  ovl: update of dentry revalidate flags after copy up
  ovl: use OVL_E() and OVL_E_FLAGS() accessors
  ovl: use ovl_numlower() and ovl_lowerstack() accessors
  ovl: factor out ovl_free_entry() and ovl_stack_*() helpers
  ovl: move ovl_entry into ovl_inode
  ovl: deduplicate lowerpath and lowerstack[]
  ovl: deduplicate lowerdata and lowerstack[]
  ovl: remove unneeded goto instructions
  ovl: introduce data-only lower layers
  ovl: implement lookup in data-only layers
  ovl: prepare to store lowerdata redirect for lazy lowerdata lookup
  ovl: prepare for lazy lookup of lowerdata inode
  ovl: implement lazy lookup of lowerdata in data-only layers

 Documentation/filesystems/overlayfs.rst |  36 +++++
 fs/overlayfs/copy_up.c                  |  11 ++
 fs/overlayfs/dir.c                      |   3 +-
 fs/overlayfs/export.c                   |  41 +++---
 fs/overlayfs/file.c                     |  21 ++-
 fs/overlayfs/inode.c                    |  38 +++--
 fs/overlayfs/namei.c                    | 185 +++++++++++++++++++-----
 fs/overlayfs/overlayfs.h                |  20 ++-
 fs/overlayfs/ovl_entry.h                |  73 ++++++++--
 fs/overlayfs/super.c                    | 132 ++++++++++-------
 fs/overlayfs/util.c                     | 165 ++++++++++++++++-----
 11 files changed, 534 insertions(+), 191 deletions(-)

-- 
2.34.1

