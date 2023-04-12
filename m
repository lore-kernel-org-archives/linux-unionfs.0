Return-Path: <linux-unionfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 23352C7619A
	for <linux-unionfs@archiver.kernel.org>; Wed, 12 Apr 2023 13:54:24 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230526AbjDLNyX (ORCPT
        <rfc822;linux-unionfs@archiver.kernel.org>);
        Wed, 12 Apr 2023 09:54:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56838 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230355AbjDLNyV (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Wed, 12 Apr 2023 09:54:21 -0400
Received: from mail-wm1-x329.google.com (mail-wm1-x329.google.com [IPv6:2a00:1450:4864:20::329])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 869A35BB0
        for <linux-unionfs@vger.kernel.org>; Wed, 12 Apr 2023 06:54:20 -0700 (PDT)
Received: by mail-wm1-x329.google.com with SMTP id gw13so6587267wmb.3
        for <linux-unionfs@vger.kernel.org>; Wed, 12 Apr 2023 06:54:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1681307659; x=1683899659;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=5XXzUwusjcMmUg7110uIkoo5dM5+1F/X0Olg64CiUxg=;
        b=sk+BQrM9RGuQJcy9M467MY1klDTrTPAXvzGlPT8P5Lxj4yMua+Wude5BZaKf2EmPu2
         H6RZmqiHFliwK7W8i+VKOqLmozJkqXrlPjyx5Y5DDMoynMhQPytsGgtK8KBvkZ2rE+G7
         Bg4uTXfxSJyOCV+71XfjBY+mm53Rle/B5COhiYuuPhcAjB6sj7XfNrapFhKuQOgk0vuT
         d0du7WBQh6boonBvjUF1KkrbRrJtD1kIXJdx2s/BjJCJfRnDFJex5Z6Ar917YprcpL10
         dLODypqjdu9i00mizpJCTOTqxo6zHBi2R/gUBd8Exyfm5OkrcGnux7XctRFFwl5vu30/
         gSkA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1681307659; x=1683899659;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=5XXzUwusjcMmUg7110uIkoo5dM5+1F/X0Olg64CiUxg=;
        b=umQaPQGdVZ4PDbO4s32aBTSjykbRKBGwzptCTJan0VYBzvjH55ocStttwplQQ/SF2s
         vaz/tMCxYeTJWoBqBXZleqh5sRbVX4pP3gclBK//HgC6YXgd+hk5Bfuk1nLyzWt6FRZg
         L8Lj9RImbSp2PvtNf2udO6QoMSlGYKz7HwazTyKDMtZGdJZsQpAUejMMsqY6p56STkVZ
         zI1VU96mX2UleRtZA58MsCoYZND1Vj8tBBOoejM9iZxSHK/C/U9h6rX3QxoeZDk7GN++
         ALYG05kin0QhhXuZteURdynCJZ9RehFJDSzFNOx3a47KYPThwqda3YlROri7Vzu8QRa5
         m3yw==
X-Gm-Message-State: AAQBX9cqUzEqnybz7b/F0jWne6kkuNinrT82TDsXu6L2jru3MN7oWZZa
        7LdmuUOOKK+g2dynA9otLJlTVScSc7M=
X-Google-Smtp-Source: AKy350Yb/rbXmk78cw2eyDbWvw4MEpD5VEegYgtbRQngBzT4ceDPiWK7tJaB1+sMA2qZjL/JqQu7Jg==
X-Received: by 2002:a05:600c:21cb:b0:3ee:814b:9c39 with SMTP id x11-20020a05600c21cb00b003ee814b9c39mr11962341wmj.18.1681307658856;
        Wed, 12 Apr 2023 06:54:18 -0700 (PDT)
Received: from amir-ThinkPad-T480.lan ([5.29.249.86])
        by smtp.gmail.com with ESMTPSA id fc12-20020a05600c524c00b003f0a0315ce4sm1395405wmb.47.2023.04.12.06.54.17
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 12 Apr 2023 06:54:18 -0700 (PDT)
From:   Amir Goldstein <amir73il@gmail.com>
To:     Miklos Szeredi <miklos@szeredi.hu>
Cc:     Alexander Larsson <alexl@redhat.com>, linux-unionfs@vger.kernel.org
Subject: [PATCH 0/5] Overlayfs lazy lookup of lowerdata
Date:   Wed, 12 Apr 2023 16:54:07 +0300
Message-Id: <20230412135412.1684197-1-amir73il@gmail.com>
X-Mailer: git-send-email 2.34.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-unionfs.vger.kernel.org>
X-Mailing-List: linux-unionfs@vger.kernel.org

Miklos,

Here are the patches discussed earlier at [1].
They are based on the already posted cleanup series [2].

This work is motivated by Alexander's composefs use case.
Alexander has been developing and testing his fsverity patches over
my lazy-lowerdata-lookup branch [3].

Alexander has also written tests for lazy lowerdata lookup [4].

Thanks,
Amir.

[1] https://lore.kernel.org/linux-unionfs/CAOQ4uxich227fP7bGSCNqx-JX5h36O-MLwqPoy0r33tuH=z2cA@mail.gmail.com/
[2] https://lore.kernel.org/linux-unionfs/20230408164302.1392694-1-amir73il@gmail.com/
[3] https://github.com/amir73il/linux/commits/ovl-lazy-lowerdata
[4] https://github.com/amir73il/xfstests/commits/ovl-lazy-lowerdata


Amir Goldstein (5):
  ovl: remove unneeded goto instructions
  ovl: introduce data-only lower layers
  ovl: implement lookup in data-only layers
  ovl: prepare for lazy lookup of lowerdata inode
  ovl: implement lazy lookup of lowerdata in data-only layers

 Documentation/filesystems/overlayfs.rst |  32 +++++++
 fs/overlayfs/copy_up.c                  |   9 ++
 fs/overlayfs/export.c                   |   2 +-
 fs/overlayfs/file.c                     |  21 +++-
 fs/overlayfs/inode.c                    |  18 +++-
 fs/overlayfs/namei.c                    | 121 +++++++++++++++++++++++-
 fs/overlayfs/overlayfs.h                |   2 +
 fs/overlayfs/ovl_entry.h                |  11 ++-
 fs/overlayfs/super.c                    |  68 +++++++++----
 fs/overlayfs/util.c                     |  33 ++++++-
 10 files changed, 286 insertions(+), 31 deletions(-)

-- 
2.34.1

