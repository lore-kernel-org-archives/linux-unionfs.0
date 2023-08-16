Return-Path: <linux-unionfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 242C1C41513
	for <linux-unionfs@archiver.kernel.org>; Wed, 16 Aug 2023 15:31:26 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1343661AbjHPPaz (ORCPT
        <rfc822;linux-unionfs@archiver.kernel.org>);
        Wed, 16 Aug 2023 11:30:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60416 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1343805AbjHPPag (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Wed, 16 Aug 2023 11:30:36 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C9D311FE2
        for <linux-unionfs@vger.kernel.org>; Wed, 16 Aug 2023 08:29:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1692199788;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=EVdlKlOKJEeMnnvtESnMFS8N3AqfN4k1XR4GvkO/0oM=;
        b=VX7rIc1kysnppCbdlq7x27ClSQNBldOuC0c+9V7U8m09b7v9hSX/BIneSaO0n3R8/nU8ov
        XO23WumVSAc3kXafS/vhuDfEaXh0WvH7wzuDGfmO7I9ZcxYeopoHx1cNnEuTYS7LBRxqEP
        OXg6MT+yXBdQYFD0W1W2E7fWSMMdWJk=
Received: from mail-lj1-f199.google.com (mail-lj1-f199.google.com
 [209.85.208.199]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-296-gXuVyUVhNQSwmofG-nfVDg-1; Wed, 16 Aug 2023 11:29:47 -0400
X-MC-Unique: gXuVyUVhNQSwmofG-nfVDg-1
Received: by mail-lj1-f199.google.com with SMTP id 38308e7fff4ca-2ba83b74a49so39221021fa.2
        for <linux-unionfs@vger.kernel.org>; Wed, 16 Aug 2023 08:29:47 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1692199786; x=1692804586;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=EVdlKlOKJEeMnnvtESnMFS8N3AqfN4k1XR4GvkO/0oM=;
        b=jPUuV2NMIgfAUwyn4/CJNhfJpwtUUL4SyJ1G7b5d5sZCHS9x3Sy5L5+/rJRiWd0e3t
         UA8MspVvEjNS2hOD9t4tmJHOxKPR/b8pn1Se8/h/KS6dQk3+w3QMYeplQ2Rtj9LfiLoh
         +BWC1iQuVkUq93K7lSnXdSPFX2w1fYkjcudG/WxvrlH3QFcE53hd1q0A1XpRQW7vY6kc
         72tpRzZnipoOzVfQ68IQbSfruFB9r9Qk5gffjHTBp1jmdPAha4+u02LsS2kgNavEW0yi
         XfKKt2VLqDG8BRgZgdq09fW7nAD/410tw7cx5VcPMrsbFWsBD+IKlAekC8Hmz6xpf7Vk
         LL8A==
X-Gm-Message-State: AOJu0YzyjePY0Px34pDRBOnqx5K3oZpjhGFx6/xzfo6UVd3fV+4Yvz0g
        QhQEmFGU5MjVVq1BexRgbUgYe83lMbaS20kxcVaFnBq4UsaMSYCCmnPQZYvHbFNbFSs8YfIe9xj
        ftEr0kUYB15I40a6lK6tX2qhOGQ==
X-Received: by 2002:a2e:8012:0:b0:2b9:df49:b818 with SMTP id j18-20020a2e8012000000b002b9df49b818mr1735542ljg.53.1692199786319;
        Wed, 16 Aug 2023 08:29:46 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IEQEGGuNjBAiljnu3lFrJe30uusmDff7dLpDouEJS5Pin2b5ofQY7f7eKayckOLp5YaHk402g==
X-Received: by 2002:a2e:8012:0:b0:2b9:df49:b818 with SMTP id j18-20020a2e8012000000b002b9df49b818mr1735527ljg.53.1692199785991;
        Wed, 16 Aug 2023 08:29:45 -0700 (PDT)
Received: from greebo.redhat.com (c-e6a5e255.022-110-73746f36.bbcust.telenor.se. [85.226.165.230])
        by smtp.googlemail.com with ESMTPSA id c13-20020a2e9d8d000000b002b9f03729e2sm3523160ljj.36.2023.08.16.08.29.45
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 16 Aug 2023 08:29:45 -0700 (PDT)
From:   Alexander Larsson <alexl@redhat.com>
To:     miklos@szeredi.hu
Cc:     linux-unionfs@vger.kernel.org, amir73il@gmail.com,
        Alexander Larsson <alexl@redhat.com>
Subject: [PATCH 0/4] Support nested overlayfs mounts
Date:   Wed, 16 Aug 2023 17:29:38 +0200
Message-ID: <cover.1692198910.git.alexl@redhat.com>
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

Alexander Larsson (4):
  ovl: Add OVL_XATTR_TRUSTED/USER_PREFIX_LEN macros
  ovl: Support escaped overlay.* xattrs
  ovl: Support creation of whiteout files on overlayfs
  ovl: Add documentation on nesting of overlayfs mounts

 Documentation/filesystems/overlayfs.rst | 22 ++++++++++
 fs/overlayfs/dir.c                      | 14 ++++---
 fs/overlayfs/inode.c                    | 31 +++++++++++++--
 fs/overlayfs/namei.c                    | 14 ++++---
 fs/overlayfs/overlayfs.h                | 22 ++++++++++
 fs/overlayfs/readdir.c                  |  7 +++-
 fs/overlayfs/super.c                    | 53 +++++++++++++++++++++++--
 fs/overlayfs/util.c                     | 20 ++++++++++
 8 files changed, 164 insertions(+), 19 deletions(-)

-- 
2.41.0

