Return-Path: <linux-unionfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 59DF6C433DB
	for <linux-unionfs@archiver.kernel.org>; Sat, 16 Jan 2021 17:09:30 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 2D4E62311F
	for <linux-unionfs@archiver.kernel.org>; Sat, 16 Jan 2021 17:09:30 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728016AbhAPRJN (ORCPT
        <rfc822;linux-unionfs@archiver.kernel.org>);
        Sat, 16 Jan 2021 12:09:13 -0500
Received: from mail-ej1-f41.google.com ([209.85.218.41]:39712 "EHLO
        mail-ej1-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727943AbhAPRJI (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Sat, 16 Jan 2021 12:09:08 -0500
Received: by mail-ej1-f41.google.com with SMTP id n26so17758144eju.6;
        Sat, 16 Jan 2021 09:08:52 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=RJfG7pg+lF3o2vHmOwx3NGS+XNFGTvNg7y9ruvorZDo=;
        b=Ye5y8KSnWof3++d4v7yt6jP0TRUFgJcqYzh11REo59mquug4YVJnYMt8xGpMbPPfAo
         DAvUCvqgxENIkRIkbXSk4lSBkkbLjd6nbCoFfro6RlqjLKWEd/PD2kJnhoQcm3jeORjD
         DPC0RTkarTuINBIudMQ5rt8Z9XLcz0Aqj8eb5hAAvVmfJHYaa/nBsFd6NI5oZypC8wZz
         7DNQ1jO6/fmcpRkCHCGF3uMwsXdhT35vxZstGkJBMGuKPjTzXuohqSOd0GpKpMwNLv7s
         f5Dc+oVYedOt6fudebVcGNiBdQgMkUzGhfMrooNOwzinuljCvbdP/bdr2KU3pu8fH3wX
         K5Nw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=RJfG7pg+lF3o2vHmOwx3NGS+XNFGTvNg7y9ruvorZDo=;
        b=igQ0vYcVDnLEaPSYWnZVUYX4PedRa+kFpkyNUFL4HS5cmecjyB52B5SryQg6fX5Hc2
         fCzDqeZ5DU6dZfaGoc7PCZOU8gYH21B40P4r21fZRt6kxrkMF/y+wtd87lWXYDxhy8e7
         hMJmsGWnojn4he/lfhMXIcnlhMKj43ZAN0hAu9cPJrGQFgWBh3BhnVOAP4np/TsVnzBm
         yqtERENEFE2NSPSzyzKVyR9ttwZzNqAj1zBfte6hCdWstTevevC1jr1jvlXVe9YcI56X
         6FL33doozKpU1txOoU2F7TSFEOP3T+vs3HYGZ6fjF05UDk/jCSc0R8u8drP/mD/2Elgw
         VptQ==
X-Gm-Message-State: AOAM532BGeDCR/5gaemKMbC0/W3qCOxqTxp9sBDFxtLknPXJFAatWorC
        LfAqofL95NTHNJIByjmpdBlOc4z7vH0=
X-Google-Smtp-Source: ABdhPJyjP9jTw9K7koDiyWVjlblNP6yNrZzbLuyemVHWD252up4U2U8GfWua0m66FfZ9g8N9UPsUpA==
X-Received: by 2002:a17:906:2a4c:: with SMTP id k12mr4291944eje.305.1610816183341;
        Sat, 16 Jan 2021 08:56:23 -0800 (PST)
Received: from localhost.localdomain ([31.210.181.203])
        by smtp.gmail.com with ESMTPSA id zn8sm7061063ejb.39.2021.01.16.08.56.21
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 16 Jan 2021 08:56:22 -0800 (PST)
From:   Amir Goldstein <amir73il@gmail.com>
To:     Eryu Guan <guaneryu@gmail.com>
Cc:     Icenowy Zheng <icenowy@aosc.io>,
        Chengguang Xu <cgxu519@mykernel.net>,
        Xiao Yang <yangx.jy@cn.fujitsu.com>,
        Miklos Szeredi <miklos@szeredi.hu>,
        linux-unionfs@vger.kernel.org, fstests@vger.kernel.org
Subject: [PATCH 0/4] Tests for overlayfs immutable/append-only files
Date:   Sat, 16 Jan 2021 18:56:15 +0200
Message-Id: <20210116165619.494265-1-amir73il@gmail.com>
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

This series improves the t_immutable test program and adds a new test
to cover lower files and directories - the test fails on upstream kernel.
Fixing this requires some VFS API changes that Miklos has proposed [1].

The new test covers two reported bug, one of them is a deadlock.
The deadlock trigger is commented out until we have a fix upstream.

Thanks,
Amir. 

[1] https://lore.kernel.org/linux-unionfs/20201123141207.GC327006@miu.piliscsaba.redhat.com/

Amir Goldstein (4):
  overlay/030: Update comment w.r.t upstream kernel
  src/t_immutable: factor out some helpers
  src/t_immutable: Allow setting flags on existing files
  overlay: Test lost immutable/append-only flags on copy-up

 src/t_immutable.c     | 241 +++++++++++++++++++++---------------------
 tests/overlay/030     |   7 +-
 tests/overlay/075     |  97 +++++++++++++++++
 tests/overlay/075.out |  11 ++
 tests/overlay/group   |   1 +
 5 files changed, 237 insertions(+), 120 deletions(-)
 create mode 100755 tests/overlay/075
 create mode 100644 tests/overlay/075.out

-- 
2.25.1

