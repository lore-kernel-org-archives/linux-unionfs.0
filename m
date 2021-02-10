Return-Path: <linux-unionfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_GIT autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AE5FDC433E6
	for <linux-unionfs@archiver.kernel.org>; Wed, 10 Feb 2021 19:05:00 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 81F1B64E38
	for <linux-unionfs@archiver.kernel.org>; Wed, 10 Feb 2021 19:05:00 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234290AbhBJTEl (ORCPT
        <rfc822;linux-unionfs@archiver.kernel.org>);
        Wed, 10 Feb 2021 14:04:41 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44220 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233940AbhBJTES (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Wed, 10 Feb 2021 14:04:18 -0500
Received: from mail-ej1-x634.google.com (mail-ej1-x634.google.com [IPv6:2a00:1450:4864:20::634])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8E8B6C061574;
        Wed, 10 Feb 2021 11:03:38 -0800 (PST)
Received: by mail-ej1-x634.google.com with SMTP id hs11so6126568ejc.1;
        Wed, 10 Feb 2021 11:03:38 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=KFfbKaC/1iBgwD3dVuP410DXgW00Uvj9flLaJMQKNDA=;
        b=R3lfkRs4WmjYM68wc6sg2KI/6n6kS7pulTgwV4Ytm5HrpQw+loCu/11jyNpvR/ILhi
         9wbyAG3smdcYBveg+PAzCl/HFCcLSLI7CxuWNt2aSOTw6zeWQvS5GAsFmU4YWYzQIbQe
         rCyg8q4MohXEBU1vGc4iDI/NFQHn3xZhvqxNw1LOsHuU2U4WUDCNEcrFjOBoNDwcIjYh
         TpX7KwWIs7MVwgflWrandDg8d62+vT6W3sU68cM9bG8SgIVIR0tZ3npV0cjvo5ofgMZc
         JBh/ysO8o5S9medhZygopBwMerSEyoNbIYPsrOEj0YihrfdpOwO38kHCSj/TWNLjpb5F
         44kg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=KFfbKaC/1iBgwD3dVuP410DXgW00Uvj9flLaJMQKNDA=;
        b=cSfK0pwjavzunXPGmujDAdfWmOdFrnv42E+sNV1SW6MD5NWD5s7wpGGHoBb8dO32Ls
         msG7n867KQF+AHorapXGazfrWC7sgdcH+lm7DIA0uVFjDtKKpE5xygKBdLXvuDZx60mE
         AlUKGgss9BuiZwWmZL/DRWrbwKUhHTLwe2bTWqCws2SwCklHuJK5KCqZQkpp8XCLWGGv
         0y7/ngPEOKZNWhLib2iWdmSZk7JW2nKGNee5OCjMC9c+0+nX/dMgCHodLHBH3H7w6g5v
         06HZCLxyCXTgF9rLLC1t5iioC12Mvp3QWUF7anj4mNnCpuoqbXTYcfuX52ZtVIavQnty
         VTvw==
X-Gm-Message-State: AOAM5324zbAdggMpk3WtqId3tUaiBSQFAMdPizOFU1FVIe/im8P/s1rY
        KOHjLAe9bLyPe0Rxm9Gk0RY=
X-Google-Smtp-Source: ABdhPJwdv0SCOgZ7ooBnyb2NOKuGkahSJbiE6I2eS3RNPbJDqUNd9Y+I8su/o4EM6Qt+xxgB8FxHkA==
X-Received: by 2002:a17:906:a246:: with SMTP id bi6mr4440479ejb.267.1612983817244;
        Wed, 10 Feb 2021 11:03:37 -0800 (PST)
Received: from localhost.localdomain ([141.226.162.179])
        by smtp.gmail.com with ESMTPSA id m19sm1743617edq.81.2021.02.10.11.03.35
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 10 Feb 2021 11:03:36 -0800 (PST)
From:   Amir Goldstein <amir73il@gmail.com>
To:     Eryu Guan <guaneryu@gmail.com>
Cc:     Miklos Szeredi <miklos@szeredi.hu>,
        Icenowy Zheng <icenowy@aosc.io>,
        Chengguang Xu <cgxu519@mykernel.net>,
        linux-unionfs@vger.kernel.org, fstests@vger.kernel.org
Subject: [PATCH v2 0/5] Tests for overlayfs immutable/append-only files
Date:   Wed, 10 Feb 2021 21:03:29 +0200
Message-Id: <20210210190334.1212210-1-amir73il@gmail.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-unionfs.vger.kernel.org>
X-Mailing-List: linux-unionfs@vger.kernel.org

Eryu,

Overlayfs never had full support for immutable/append-only files.
Whatever works is covered by generic/079 and overlay/030 tests.
Both tests cover only upper files and directories.
generic/079 is notrun on kernel < 5.10 and passes on >= 5.10.

This series improves the t_immutable test program and adds two new
tests.

overlay/075 tests immutable/append-only lower files and directories -
the test fails on upstream kernel.  Fixing this requires some VFS API
changes that Miklos has proposed [1].

overlay/076 is a "dangerous" test that triggers a deadlock.
The deadlock was fixed in master and in stable kernel v5.10.15.

Thanks,
Amir. 

Changes since v1:
- Split the dangerous test
- Document fix commit
- Fix Eryu's minor review comments on t_immutable

[1] https://lore.kernel.org/linux-fsdevel/20210203124112.1182614-1-mszeredi@redhat.com/

Amir Goldstein (5):
  overlay/030: Update comment w.r.t upstream kernel
  src/t_immutable: factor out some helpers
  src/t_immutable: Allow setting flags on existing files
  overlay: Test lost immutable/append-only flags on copy-up
  overlay: Regression test for deadlock on directory ioctl

 src/t_immutable.c     | 241 +++++++++++++++++++++---------------------
 tests/overlay/030     |   7 +-
 tests/overlay/075     |  92 ++++++++++++++++
 tests/overlay/075.out |  11 ++
 tests/overlay/076     |  66 ++++++++++++
 tests/overlay/076.out |   2 +
 tests/overlay/group   |   2 +
 7 files changed, 301 insertions(+), 120 deletions(-)
 create mode 100755 tests/overlay/075
 create mode 100644 tests/overlay/075.out
 create mode 100644 tests/overlay/076
 create mode 100644 tests/overlay/076.out

-- 
2.25.1

