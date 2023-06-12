Return-Path: <linux-unionfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8E096C7EE25
	for <linux-unionfs@archiver.kernel.org>; Mon, 12 Jun 2023 10:44:10 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234830AbjFLKoI (ORCPT
        <rfc822;linux-unionfs@archiver.kernel.org>);
        Mon, 12 Jun 2023 06:44:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47006 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234808AbjFLKnv (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Mon, 12 Jun 2023 06:43:51 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E3F34A86C
        for <linux-unionfs@vger.kernel.org>; Mon, 12 Jun 2023 03:27:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1686565654;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=nIopUTyQC6au4qt8cPbc4MGLTADYeT6LypbQFqATEMA=;
        b=FVG8XOrYWHonEvRMQNxUbGXArvwB77smxteEcb0usSOjHy5JQh5R3O/a+Q+EC/kbMq7HxU
        txY8ELH/RQR0rPvMRHCUxPycOUyIidiuXOcRJvzXg5rdXnRuDrpXFLfAcykUwl7I4igt03
        PRfFxf13SbdhG0YoDdlkrUK2q6mqe3k=
Received: from mail-lj1-f198.google.com (mail-lj1-f198.google.com
 [209.85.208.198]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-633--qWJFKOjO2eWSPxolB2-GQ-1; Mon, 12 Jun 2023 06:27:33 -0400
X-MC-Unique: -qWJFKOjO2eWSPxolB2-GQ-1
Received: by mail-lj1-f198.google.com with SMTP id 38308e7fff4ca-2b1d8fa45a6so29698231fa.0
        for <linux-unionfs@vger.kernel.org>; Mon, 12 Jun 2023 03:27:32 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1686565651; x=1689157651;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=nIopUTyQC6au4qt8cPbc4MGLTADYeT6LypbQFqATEMA=;
        b=VOOBP6vNY6wU3LxZgzKOh/0RJEl06mdD/n3Q0cGaUopTF/GazWrM+gip/y6bfjtJrW
         K9xjDG+sSMcChJoStUkvQv3dT/Wa2egRySYjbfnWSvMktySLIFWQsSHW/17b17vU9XG/
         xEzvotckxP28FiJ2/l8FF89SzKHVJ5VL11ey11m8QZ5Zf9lPM5w5C7+WZqCvsR6xzAZX
         0acQSuwvPAYUu3Cmb1fVAI0z4LZJN7ATV3FrG0O8ZXYY956Q2NiywTofoqU4nO82nWag
         VTS0NrnJw+wqklTMe2z9PfYhbYjLCq5TUcmvYMY9NaimsNB3LIUd1xko5fgZuqitrnEp
         errg==
X-Gm-Message-State: AC+VfDw8bTWvS7YIloF2SYX8xLwmIARCqJ4x/XBg6lua5aH/xBR7VmjT
        hUY9VS1oZyUXyUKFy415jB0Jb/RwGgNvy/W8+RypPx1fUCyhRdIf1cLlxWM3o+iAEaANkgJ5a6A
        jqzdTe4GKQsdYoGP+rad/7ZFC5Q==
X-Received: by 2002:a2e:a0d6:0:b0:2b2:5d2:ce63 with SMTP id f22-20020a2ea0d6000000b002b205d2ce63mr2284402ljm.35.1686565651463;
        Mon, 12 Jun 2023 03:27:31 -0700 (PDT)
X-Google-Smtp-Source: ACHHUZ4nQkV7krvCUS5noWSCi/+YY7Mpv3aM8Bw9QBw1jPHWqpiUiKRpBdNmLX5+v5jh05Zn0VTOPQ==
X-Received: by 2002:a2e:a0d6:0:b0:2b2:5d2:ce63 with SMTP id f22-20020a2ea0d6000000b002b205d2ce63mr2284389ljm.35.1686565651045;
        Mon, 12 Jun 2023 03:27:31 -0700 (PDT)
Received: from localhost.localdomain (c-e6a5e255.022-110-73746f36.bbcust.telenor.se. [85.226.165.230])
        by smtp.googlemail.com with ESMTPSA id m25-20020a2e8719000000b002b1fc6e70a1sm1709095lji.21.2023.06.12.03.27.30
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 12 Jun 2023 03:27:30 -0700 (PDT)
From:   Alexander Larsson <alexl@redhat.com>
To:     miklos@szeredi.hu
Cc:     linux-unionfs@vger.kernel.org, amir73il@gmail.com,
        ebiggers@kernel.org, tytso@mit.edu, fsverity@lists.linux.dev,
        Alexander Larsson <alexl@redhat.com>
Subject: [PATCH v3 0/4] ovl: Add support for fs-verity checking of lowerdata
Date:   Mon, 12 Jun 2023 12:27:15 +0200
Message-Id: <cover.1686565330.git.alexl@redhat.com>
X-Mailer: git-send-email 2.40.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-unionfs.vger.kernel.org>
X-Mailing-List: linux-unionfs@vger.kernel.org

This patchset adds support for using fs-verity to validate lowerdata
files by specifying an overlay.verity xattr on the metacopy
files.

This is primarily motivated by the Composefs usecase, where there will
be a read-only EROFS layer that contains redirect into a base data
layer which has fs-verity enabled on all files. However, it is also
useful in general if you want to ensure that the lowerdata files
matches the expected content over time.

I have also added some tests for this feature to xfstests[1].

I'm also CC:ing the fsverity list and maintainers because there is one
(tiny) fsverity change, and there may be interest in this usecase.

Changes since v2:
 * Rebased on top of overlayfs-next
 * We now alway do verity verification the first time the file content
   is used, rather than doing it at lookup time for the non-lazy lookup
   case.

Changes since v1:
 * Rebased on v2 lazy lowerdata series
 * Dropped the "validate" mount option variant. We now only support
   "off", "on" and "require", where "off" is the default.
 * We now store the digest algorithm used in the overlay.verity xattr.
 * Dropped ability to configure default verity options, as this could
   cause problems moving layers between machines.
 * We now properly resolve dependent mount options by automatically
   enabling metacopy and redirect_dir if verity is on, or failing
   if the specified options conflict.
 * Streamlined and fixed the handling of creds in ovl_ensure_verity_loaded().
 * Renamed new helpers from ovl_entry_path_ to ovl_e_path_

[1] https://github.com/alexlarsson/xfstests/commits/verity-tests

Alexander Larsson (4):
  fsverity: Export fsverity_get_digest
  ovl: Add framework for verity support
  ovl: Validate verity xattr when resolving lowerdata
  ovl: Handle verity during copy-up

 Documentation/filesystems/overlayfs.rst |  27 +++++
 fs/overlayfs/copy_up.c                  |  33 +++++-
 fs/overlayfs/file.c                     |   8 +-
 fs/overlayfs/namei.c                    |  54 +++++++++-
 fs/overlayfs/overlayfs.h                |  12 ++-
 fs/overlayfs/ovl_entry.h                |   3 +
 fs/overlayfs/super.c                    |  79 +++++++++++++-
 fs/overlayfs/util.c                     | 133 ++++++++++++++++++++++++
 fs/verity/measure.c                     |   1 +
 9 files changed, 340 insertions(+), 10 deletions(-)

-- 
2.40.1

