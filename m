Return-Path: <linux-unionfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4A0BFC7EE2E
	for <linux-unionfs@archiver.kernel.org>; Sun, 21 May 2023 08:31:33 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229833AbjEUIba (ORCPT
        <rfc822;linux-unionfs@archiver.kernel.org>);
        Sun, 21 May 2023 04:31:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49184 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230063AbjEUI2U (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Sun, 21 May 2023 04:28:20 -0400
Received: from smtp-relay-internal-1.canonical.com (smtp-relay-internal-1.canonical.com [185.125.188.123])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8A0B1185
        for <linux-unionfs@vger.kernel.org>; Sun, 21 May 2023 01:28:19 -0700 (PDT)
Received: from mail-ed1-f72.google.com (mail-ed1-f72.google.com [209.85.208.72])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (No client certificate requested)
        by smtp-relay-internal-1.canonical.com (Postfix) with ESMTPS id 4C3B13F22B
        for <linux-unionfs@vger.kernel.org>; Sun, 21 May 2023 08:28:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=canonical.com;
        s=20210705; t=1684657697;
        bh=7LprU92WxJEFR19aNB0l9iIcuodaVl/7HZinT6/rqlw=;
        h=From:To:Cc:Subject:Date:Message-Id:MIME-Version;
        b=ar8tNzhNU/aFFX55WkHrC78CC/qsUkn192vmmvxiRfBvd/72ZwUMbajvz84mXAKsa
         XXqI1mSan26BjVuq6lMeKgNukabR3msz/aTRREn7R2pOzLj7GGWhpvZG7qhFfKpLZY
         xhFlCrxeJwcWfDRM0wmcCY3rErr0RE39TEig9u5LHzj5XDmV2g7U0xyCBmGKbtLwYx
         +GC42dPqHZdd4S/XpcufcFFqn2Y6ptrE15mZEskvniA99RFVXD/EWAx1sswbbb9B0E
         0JIRB7dGFwZ9XXIZUPnnwC5wBGEfChZQUOoeSzw9RzRmt/qe5rbHj6CRoQfN6XPKnX
         BCZC77p8wnM7w==
Received: by mail-ed1-f72.google.com with SMTP id 4fb4d7f45d1cf-510b714821fso3139008a12.1
        for <linux-unionfs@vger.kernel.org>; Sun, 21 May 2023 01:28:17 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1684657696; x=1687249696;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=7LprU92WxJEFR19aNB0l9iIcuodaVl/7HZinT6/rqlw=;
        b=e2RytinbiJC54mA26gvxXrIgdVedQJ8bCRO4atqoxhYI6myy6oXIDuckqVwHmmlnqN
         2kKwSzea/4OSL5iuZTw7r7wpwVfxrnoSByNj9IT+Laj+RTiZl5iYwPfW1KXv9cjGc+w9
         KAJlJXpWcbhFRFoNyozbs1xsGuTb7pWgJJqpa/hHakfQ/GVk+507dpDMI0OyRR0Xnk5j
         tTVaRba9k/Do9FLcTchQbNmdQpuTa9KI6yDVVfIIhtJ4wulFIyqk0iUeYLc38uCOLB88
         EfIrW/70jsuBvXLNSfuks9mDnDzbF2GzH36PFTjQAzA9/ES1Wnt+nhNU9memSPi7jDh6
         6PdA==
X-Gm-Message-State: AC+VfDy+/DCTEfPOpLdzN3HiT2rbKoRfF5jLkuyvYuJQUxRIgg+KuJeC
        0YDlYWE0JsgNU1gDx9R9n1GCoN1ozNlrttJ7KaUdpTnJ6woY8cT2cgXU4StCueqUuVj2l+Y7llA
        ezYS3I4YUgmlDqqE0b6Nfx2MRNEP9YmNh1CrkzgWLJq4=
X-Received: by 2002:a05:6402:348e:b0:510:f14d:78eb with SMTP id v14-20020a056402348e00b00510f14d78ebmr7695892edc.18.1684657696504;
        Sun, 21 May 2023 01:28:16 -0700 (PDT)
X-Google-Smtp-Source: ACHHUZ6YiaVtDTOUKe5lAcQsfGZKVUN/gNqPTMRLhLjXgvA+r+jmeFCsJnN9P9LYtx64f3J7Oir7/Q==
X-Received: by 2002:a05:6402:348e:b0:510:f14d:78eb with SMTP id v14-20020a056402348e00b00510f14d78ebmr7695887edc.18.1684657696256;
        Sun, 21 May 2023 01:28:16 -0700 (PDT)
Received: from righiandr-XPS-13-7390.homenet.telecomitalia.it (host-87-10-127-160.retail.telecomitalia.it. [87.10.127.160])
        by smtp.gmail.com with ESMTPSA id z17-20020aa7cf91000000b004c2158e87e6sm1656646edx.97.2023.05.21.01.28.15
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 21 May 2023 01:28:16 -0700 (PDT)
From:   Andrea Righi <andrea.righi@canonical.com>
To:     Miklos Szeredi <miklos@szeredi.hu>
Cc:     Amir Goldstein <amir73il@gmail.com>, linux-unionfs@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH v3 0/3] overlayfs: debugging check for valid superblock
Date:   Sun, 21 May 2023 10:28:10 +0200
Message-Id: <20230521082813.17025-1-andrea.righi@canonical.com>
X-Mailer: git-send-email 2.39.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-unionfs.vger.kernel.org>
X-Mailing-List: linux-unionfs@vger.kernel.org

OVL_FS() is used to get a struct ovl_fs from a sturct super_block, but
we don't have any check to determine if the superblock is valid or not.

This can lead to unexpected behaviors or bugs that are pretty hard to
track down.

Add an explicit WARN_ON_ONCE() check to OVL_FS() to make sure it's
always used with a valid overlayfs superblock.

To avoid enabling this additional pendatic check everywhere, introduce
the new config option CONFIG_OVERLAY_FS_DEBUG, that can be used in the
future also for other additional debugging checks.

Maybe a nicer solution could be to return an error from OVL_FS() when
it's used with an invalid superblock and propagate the error in the rest
of overlayfs code, but for now having at least the possibility to
trigger a warning can help to catch potential bugs in advance.

Changelog (v2 -> v3):
 - do not hide is_ovl_fs_sb() under CONFIG_OVERLAY_FS_DEBUG
 - split consistent use of OVL_FS() and superblock validation in two
   separate patches

Changelog (v1 -> v2):
 - replace BUG_ON() with WARN_ON_ONCE()
 - introduce CONFIG_OVERLAY_FS_DEBUG

Andrea Righi (3):
      ovl: Kconfig: introduce CONFIG_OVERLAY_FS_DEBUG
      ovl: make consistent use of OVL_FS()
      ovl: validate superblock in OVL_FS()

 fs/overlayfs/Kconfig     |  9 +++++++++
 fs/overlayfs/copy_up.c   |  2 +-
 fs/overlayfs/export.c    | 10 +++++-----
 fs/overlayfs/inode.c     |  8 ++++----
 fs/overlayfs/namei.c     |  2 +-
 fs/overlayfs/ovl_entry.h | 14 ++++++++++++++
 fs/overlayfs/super.c     | 12 ++++++------
 fs/overlayfs/util.c      | 18 +++++++++---------
 8 files changed, 49 insertions(+), 26 deletions(-)

