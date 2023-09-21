Return-Path: <linux-unionfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E578AE7D0A4
	for <linux-unionfs@archiver.kernel.org>; Thu, 21 Sep 2023 17:31:21 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230285AbjIURbZ (ORCPT
        <rfc822;linux-unionfs@archiver.kernel.org>);
        Thu, 21 Sep 2023 13:31:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42112 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229586AbjIURbU (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Thu, 21 Sep 2023 13:31:20 -0400
Received: from mail-ed1-x529.google.com (mail-ed1-x529.google.com [IPv6:2a00:1450:4864:20::529])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EA74640665;
        Thu, 21 Sep 2023 10:25:04 -0700 (PDT)
Received: by mail-ed1-x529.google.com with SMTP id 4fb4d7f45d1cf-52c88a03f99so1374341a12.2;
        Thu, 21 Sep 2023 10:25:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1695317102; x=1695921902; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=/kJvuDPt/Lz9pXg7kBbuY8I16QHXW8zs+m8ssxV7DiY=;
        b=HuHb+QC0vwT7F2xTvE2blRZ3CAbCx3DAQURfs7xJm2FbXDX2IhVpJYUAK/mcZIcpwd
         f7fkmNlVj4ljKuFtaRO22unzDDACm0u1NViGNF/w+/3fCMYWCUuDvXx0ALQQFz+Bq1DS
         mWYK0f8FyAnnXpMSTbyefAFlbwAs4JqKCyvLJ3xdKY6XL26LT5Oz6EmIgaHnURBTEtEu
         J6yh5+WueF3YNZumTovMSTavG/GGaOy6VLwo4DAo69HIWqFF+2SKXFwlZ6GYAIJfqlJS
         SKwt5/kbfTAaR47lTmHu+i3dX3ecG//C9GC2VGE4NnMvsaI//Dm/b5d+LDW8gGffncb3
         UuvQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1695317102; x=1695921902;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=/kJvuDPt/Lz9pXg7kBbuY8I16QHXW8zs+m8ssxV7DiY=;
        b=kx9uWTkA3NZqKCwfMJd6znkCr60OU+YryxEqYen9cQ3nhwbJnFQrn3Leoe6W3VqsJy
         puerxoX68V/DuVi8lna2Q4UwlwO1n5W62QBLtCjO6uHvJbNT0VR6x2WpRGSUqqhyL67U
         jeI4CuddyhzXHCq2aiTMByvETtkUrvT1D+04Z7Z+znGjRPNnE7JKfaA6jPOq121lWTwy
         b644xuTtqhUSJff9VBUjXuXaBOZ5NvZR0wZUFytGUzPg/64+IWYAkCQr7GkELxioQEev
         esWG6QbMtGNVq5tL/ETIw0mKASHySsbcNzZ55CixuCHeax8wk7IffxNlpopeyD0b7yuz
         HOew==
X-Gm-Message-State: AOJu0YwKrAmLNNtDsEOyQOQkLanvBo8QKDGfzoH0Gmu6j1nf/STMacVi
        G5+1lpTOe0zZdu3Vz40zNyJ4sEFrXZw=
X-Google-Smtp-Source: AGHT+IGzNlxMZxOhDORS4z0FRdzg+bnkUzOcvheRRwYuvuFVxoqWbSfY1tl4BWbqWk1wFjzTCrEwrA==
X-Received: by 2002:a05:600c:5008:b0:405:3a63:6d12 with SMTP id n8-20020a05600c500800b004053a636d12mr271559wmr.17.1695306666223;
        Thu, 21 Sep 2023 07:31:06 -0700 (PDT)
Received: from amir-ThinkPad-T480.lan ([5.29.249.86])
        by smtp.gmail.com with ESMTPSA id y2-20020a7bcd82000000b00403bbe69629sm2099334wmj.31.2023.09.21.07.31.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 21 Sep 2023 07:31:05 -0700 (PDT)
From:   Amir Goldstein <amir73il@gmail.com>
To:     Zorro Lang <zlang@redhat.com>
Cc:     Miklos Szeredi <miklos@szeredi.hu>,
        Ruiwen Zhao <ruiwen@google.com>, linux-unionfs@vger.kernel.org,
        fstests@vger.kernel.org
Subject: [PATCH v2 0/2] Test for overlayfs fix in v6.6-rc2
Date:   Thu, 21 Sep 2023 17:31:00 +0300
Message-Id: <20230921143102.127526-1-amir73il@gmail.com>
X-Mailer: git-send-email 2.34.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-unionfs.vger.kernel.org>
X-Mailing-List: linux-unionfs@vger.kernel.org

Zorro,

This is a test for a regression in kernel v5.15.
The fix was merged for 6.6-rc2 and has been picked for
the upcoming LTS releases 5.15, 6.1, 6.5.

The reproducer only manifests the bug in fs that inherit noatime flag
on symlink namely ext4, btrfs, ... but not xfs.

The test does _notrun on overlayfs over xfs for that reason.

Thanks,
Amir.

Changes since v1:
- Create helper _require_chattr_inherit
- Improve documnetation of the regression

Amir Goldstein (2):
  common: add helper _require_chattr_inherit
  overlay: add test for rename of lower symlink with NOATIME attr

 common/rc             | 52 ++++++++++++++++++++++++++++------
 tests/overlay/082     | 66 +++++++++++++++++++++++++++++++++++++++++++
 tests/overlay/082.out |  2 ++
 3 files changed, 111 insertions(+), 9 deletions(-)
 create mode 100755 tests/overlay/082
 create mode 100644 tests/overlay/082.out

-- 
2.34.1

