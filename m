Return-Path: <linux-unionfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 439ACEB64D9
	for <linux-unionfs@archiver.kernel.org>; Sat, 17 Jun 2023 08:47:14 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232456AbjFQIrN (ORCPT
        <rfc822;linux-unionfs@archiver.kernel.org>);
        Sat, 17 Jun 2023 04:47:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38912 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229506AbjFQIrM (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Sat, 17 Jun 2023 04:47:12 -0400
Received: from mail-wr1-x436.google.com (mail-wr1-x436.google.com [IPv6:2a00:1450:4864:20::436])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C8EF3B5
        for <linux-unionfs@vger.kernel.org>; Sat, 17 Jun 2023 01:47:10 -0700 (PDT)
Received: by mail-wr1-x436.google.com with SMTP id ffacd0b85a97d-30c4775d05bso1022125f8f.2
        for <linux-unionfs@vger.kernel.org>; Sat, 17 Jun 2023 01:47:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1686991629; x=1689583629;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=Eo1lHuPjlSgc3ifC6FP7M1M0DBi189VZzH465ICJfe0=;
        b=a6Qe02mTLImL3wVj0z0tSrbuBiDx67D3vw8dcWuOC6mOoMdAkyiqYSLFWoUOM6XZja
         4NZ9Cxm7sHDuCr8rS5NECY3oZnIr5zzMoVBF0jgVsdxaXXjmZCfszIrngfv0ByhaE96g
         PedQuuDMv4JN3guYXXp9fHyef/1ggzXkmVdkjxi/IdI/UH5Vdz0yokJ1yoFu3rcjvmaB
         L/HrghHIUc8/TbIImIF/BZvb9RqMhHOVMnEoIvuAabNJ+gBCj68q5QnTX2N7IVHBZq95
         O3q+lKIkIzhF0/H6/kKwcilJ3PJ++Qe5c91pvOcWt4cOt3M8iWYgsmqSViJU9JnSqz52
         j+RA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1686991629; x=1689583629;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=Eo1lHuPjlSgc3ifC6FP7M1M0DBi189VZzH465ICJfe0=;
        b=eNcD9z5ExZrV/6C2gGcyjf7R6SFlY2vyJPom56XFIpI8s7AJg8bfcvTg+4yI1zkhTi
         43IcLreiCDDCpFdogm4DFukBtcUpgMZ4ikiXFx1OUtet189p9ZitcZiMcOFEgDasw+Tu
         UaxbI6lkglf/+x5XlWDIGt1p5yx4LPSB9Y750wHg8yUQKCKe7EnHeo5q96n+EMLlYCfx
         3mRiTkgkq1Uu7cZFYM8XwvdO/B5rVKv8yXm3+ADx4QM99vkJHYK3fXtsgleK7kD8kkCd
         e0xuC3Py2V73uYeAqzUVkqlW5FQbb6trgj4f0ptiE5O7pUy4ssApjFtg3jbChLSCEZ7A
         5LCw==
X-Gm-Message-State: AC+VfDxAfUhqtlEsPolryDxh61iAc1nHbSciuLAcP/W1Io6Eui/4x2iq
        ZnBpUytDio2K75AUbYtk86o=
X-Google-Smtp-Source: ACHHUZ7s1gcJP0TTiY9OgDwmkLpneGGtkHy/4IgpNoei0rjOSRI3M5ixxcu3y+6/BXGRvHrobSIk6A==
X-Received: by 2002:adf:e489:0:b0:311:d3c:df0 with SMTP id i9-20020adfe489000000b003110d3c0df0mr2453287wrm.43.1686991628965;
        Sat, 17 Jun 2023 01:47:08 -0700 (PDT)
Received: from amir-ThinkPad-T480.lan ([5.29.249.86])
        by smtp.gmail.com with ESMTPSA id t12-20020adfe10c000000b00307acec258esm25630481wrz.3.2023.06.17.01.47.08
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 17 Jun 2023 01:47:08 -0700 (PDT)
From:   Amir Goldstein <amir73il@gmail.com>
To:     Miklos Szeredi <miklos@szeredi.hu>
Cc:     Christian Brauner <brauner@kernel.org>,
        linux-unionfs@vger.kernel.org
Subject: [PATCH v2 0/5] Prep patches for porting overlayfs to new mount api
Date:   Sat, 17 Jun 2023 11:46:57 +0300
Message-Id: <20230617084702.2468470-1-amir73il@gmail.com>
X-Mailer: git-send-email 2.34.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-unionfs.vger.kernel.org>
X-Mailing-List: linux-unionfs@vger.kernel.org

Miklos,

Following some more cleanup patches that make Christian's new mount api
patches smaller and easier to review.

I had rebased Christain's patches over these cleanups and pushed the
result to github branch fs-overlayfs-mount_api [1].

The v1 prep patches had a bug with xino option parsing that resulted in
some tests being skipped (not failing) and I had only noticed the
skipped test after posting v1.

The v2 prep patches + new mount api patches have passed all the tests
with no new tests skipped.

In addition to running the tests with the default kernel config, I also
ran the tests with the following non-default configs (individually):

1) CONFIG_OVERLAY_FS_REDIRECT_DIR=y
2) CONFIG_OVERLAY_FS_REDIRECT_ALWAYS_FOLLOW=n
3) CONFIG_OVERLAY_FS_XINO_AUTO=y


Thanks.
Amir.

Changes since v1:
- Fix xino opt name table vs. enum order
- Add cleanup patch for xino
- Add cleanup of share_whiteout state
- Add cleanup patch for ovl_get_root()

[1] https://github.com/amir73il/linux/commits/fs-overlayfs-mount_api

Amir Goldstein (5):
  ovl: negate the ofs->share_whiteout boolean
  ovl: clarify ovl_get_root() semantics
  ovl: pass ovl_fs to xino helpers
  ovl: store enum redirect_mode in config instead of a string
  ovl: factor out ovl_parse_options() helper

 Documentation/filesystems/overlayfs.rst |   9 +-
 fs/overlayfs/dir.c                      |   6 +-
 fs/overlayfs/inode.c                    |  18 +-
 fs/overlayfs/namei.c                    |   6 +-
 fs/overlayfs/overlayfs.h                |  63 ++--
 fs/overlayfs/ovl_entry.h                |   8 +-
 fs/overlayfs/readdir.c                  |  19 +-
 fs/overlayfs/super.c                    | 364 +++++++++++++-----------
 fs/overlayfs/util.c                     |   7 -
 9 files changed, 274 insertions(+), 226 deletions(-)

-- 
2.34.1

