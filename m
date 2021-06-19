Return-Path: <linux-unionfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 83232C2B9F4
	for <linux-unionfs@archiver.kernel.org>; Sat, 19 Jun 2021 09:26:27 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 5BD1B608FC
	for <linux-unionfs@archiver.kernel.org>; Sat, 19 Jun 2021 09:26:27 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230318AbhFSJ2h (ORCPT
        <rfc822;linux-unionfs@archiver.kernel.org>);
        Sat, 19 Jun 2021 05:28:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43170 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230107AbhFSJ2g (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Sat, 19 Jun 2021 05:28:36 -0400
Received: from mail-wr1-x430.google.com (mail-wr1-x430.google.com [IPv6:2a00:1450:4864:20::430])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B5850C061574
        for <linux-unionfs@vger.kernel.org>; Sat, 19 Jun 2021 02:26:23 -0700 (PDT)
Received: by mail-wr1-x430.google.com with SMTP id m18so13552251wrv.2
        for <linux-unionfs@vger.kernel.org>; Sat, 19 Jun 2021 02:26:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=lLrSRhugB61+0CyX02SwYcu4Rpe5V6pO+sc6tYdkvxo=;
        b=Yd3+JIseejlOQQMWqHFnm/R8bwWna2pCO4/2cVpQyoSbPy7DgsZGKp4b16pAgHmd7K
         yoCrm/X74tqKBcCAkRWRwW+dEfaMrkmezl6as9vET7rcPBErssuxi6naG1FAaWeGDqwh
         we+32fHqL0IyOvVyEAF3Mj9t5aG5Few4lvk8IdkzzHNTlE82D/Q+fUMimN/Fy/2cou1v
         ATUFT665Ecgpb+p+76ar8QcRAy7yWo4Y1O29gUEb/3oRRYUHX6fRYCl4IkMtICxJcmkh
         aroF5xC1+8wOhMzV2grBXMZpGPZ5mY1mdlCbwwMf4NS9B8BOAPyq3BKcqFYJSjg2/kmu
         kqEg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=lLrSRhugB61+0CyX02SwYcu4Rpe5V6pO+sc6tYdkvxo=;
        b=bM5jK2T/R7jAP+DxE6hJzP8q0xohCbgpfp5g+PeW4Yg0v6KVjz4K90PLRw37Cfra0f
         cbh5EaosAFLTtwsuVO96F0u0WoLx/s68kAPSpw8x6dy+oD8+w/faacxwvdU+KQx8kv5e
         8KEEhX92EvUpJ6TO4HNtF5alodDqFIthPuPIGFSjqCadHZVh5uVux6mlw02hI21c73o+
         9Oofc1Axnx4q59c1JljEwM5IJPN29bYvwSf9jcGaVU1AJkOar2kk6TZ40Fz1OpjxglUb
         FMX/Mb+/KL4gVbj9jboNAsj30JHrxYfbzQhgW2VFylUd7EUhK3zGUp8Fy/Olz9PnuYQ9
         WhsA==
X-Gm-Message-State: AOAM530arANsfLHJclJMHXEiHCXwR1jc2u2XncPlsd++3SkGmK67480I
        XhZ26WOr2UN71DPfIF6Set0G0MdQSqk=
X-Google-Smtp-Source: ABdhPJxMztlNCUIbFCQIuPpUmdKg8QIoIRqnxlWMAOhnTb8SQ9sbIUfVwk34KMDnXTJWHeMR2mIM4g==
X-Received: by 2002:a5d:6945:: with SMTP id r5mr17091080wrw.249.1624094782264;
        Sat, 19 Jun 2021 02:26:22 -0700 (PDT)
Received: from localhost.localdomain ([141.226.245.169])
        by smtp.gmail.com with ESMTPSA id 2sm10904445wrz.87.2021.06.19.02.26.21
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 19 Jun 2021 02:26:21 -0700 (PDT)
From:   Amir Goldstein <amir73il@gmail.com>
To:     Miklos Szeredi <miklos@szeredi.hu>
Cc:     Chengguang Xu <cgxu519@mykernel.net>, linux-unionfs@vger.kernel.org
Subject: [PATCH v3 0/4] Overlayfs fileattr related fixes
Date:   Sat, 19 Jun 2021 12:26:15 +0300
Message-Id: <20210619092619.1107608-1-amir73il@gmail.com>
X-Mailer: git-send-email 2.32.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-unionfs.vger.kernel.org>
X-Mailing-List: linux-unionfs@vger.kernel.org

Miklos,

Following patch set addresses your comments to v2.
It passed all the old and new xfstests [3].

Thanks,
Amir.

Changes since v2 [2]:
- Rename overlay.xflags => overlay.protected
- Generic vfs helper for filling statx flags
- Un-generalize flag conversion helpers
- Do not be forgiving with noxattr upper fs

Changes since v1 [1]:
- Store (i),(a) flags in xattr text format
- Copy up (A),(S) flags to upper fileattr
- Fixes the problems with setting ovl dirs and hardlinks immutable

[1] https://lore.kernel.org/linux-unionfs/CAJfpeguMQca-+vTdzoDdDWNJraWyqMa3vYRFDWPMk_R6-L7Obw@mail.gmail.com/
[2] https://lore.kernel.org/linux-unionfs/CAOQ4uxgdWwrOa79BRzZ1PS6SxmLtywQCAr3+WLRZPx38aHHyQw@mail.gmail.com/
[3] https://github.com/amir73il/xfstests/commits/ovl-xflags

Amir Goldstein (4):
  fs: add generic helper for filling statx attribute flags
  ovl: pass ovl_fs to ovl_check_setxattr()
  ovl: copy up sync/noatime fileattr flags
  ovl: consistent behavior for immutable/append-only inodes

 fs/orangefs/inode.c      |   7 +--
 fs/overlayfs/copy_up.c   |  72 +++++++++++++++++++----
 fs/overlayfs/dir.c       |   6 +-
 fs/overlayfs/inode.c     |  74 +++++++++++++++++++-----
 fs/overlayfs/namei.c     |   2 +-
 fs/overlayfs/overlayfs.h |  44 ++++++++++++--
 fs/overlayfs/util.c      | 122 +++++++++++++++++++++++++++++++++++++--
 fs/stat.c                |  18 ++++++
 include/linux/fs.h       |   1 +
 include/linux/stat.h     |   4 ++
 10 files changed, 307 insertions(+), 43 deletions(-)

-- 
2.32.0

