Return-Path: <linux-unionfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A7D7BC77B73
	for <linux-unionfs@archiver.kernel.org>; Thu, 20 Apr 2023 07:45:20 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229749AbjDTHpT (ORCPT
        <rfc822;linux-unionfs@archiver.kernel.org>);
        Thu, 20 Apr 2023 03:45:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51330 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234078AbjDTHpR (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Thu, 20 Apr 2023 03:45:17 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ACEFB4200
        for <linux-unionfs@vger.kernel.org>; Thu, 20 Apr 2023 00:44:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1681976668;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=wlIazMnz9pOTl1ymeBj6LcHkPUdAOxzUMXG5pIjT/Hw=;
        b=fHnXhNOFwlTKsGtOfymj4FziVnhmxYLrNo6ylrjKFEkSWGvxc8GUYRCYujvvoXV97ypwjd
        mhnRuE9HuPSh/0uUoB3+7tPdYRMs+LgUjOxgj6+YsJ3if8pWrZIQGbncENRrXhUGmRa8Is
        DaD0T6Dm4qgNrqs0FRou4slRUW5Lsq4=
Received: from mail-lf1-f70.google.com (mail-lf1-f70.google.com
 [209.85.167.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-176-xwAa7BemPuyRWJ2N3y6jIQ-1; Thu, 20 Apr 2023 03:44:26 -0400
X-MC-Unique: xwAa7BemPuyRWJ2N3y6jIQ-1
Received: by mail-lf1-f70.google.com with SMTP id 2adb3069b0e04-4edb884cdc3so182361e87.1
        for <linux-unionfs@vger.kernel.org>; Thu, 20 Apr 2023 00:44:26 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1681976665; x=1684568665;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=wlIazMnz9pOTl1ymeBj6LcHkPUdAOxzUMXG5pIjT/Hw=;
        b=h+2ZzRaeS8p+VNTEisnJlRyx+cPO4+OapgNbqD+7zzTX7arNn98buiggpEvDIUUjaE
         W3Ofus7WAJRQuweOUFtOHVsPTcsDVYdlv+ytjUntmugQgdm8HWdG5olvlaYCbyBP4kMy
         zhBhrws/sZHcx0QN3PMQAHqhSuro6Gz1qtGmAUxNybsv6yW8F7PnZxWw10L3tA+0uge8
         3XTubBfTc+ECyjurcEyCzSUH04Lg91S5DgjK9OstYG3ujTjcyrqiLEvmLU/0FPonSl/N
         CD1Pd488CgKoBy2EGy4edeS0s9rpbDvdi6WMliCYoXzYLAU7uKjWDuwPOHkhFEGl183a
         /4MA==
X-Gm-Message-State: AAQBX9euHpkIh3KSY/Zar96+G/BC7xiHNsjr3RLyqRvTqVQzDglHLKbs
        2WCjcogEVeUdaM3DAa4e7c4qUKyT31GuIOyUsZYGOU80jNyGDjpRx1xj+4uhP05UmLSP62okg/L
        RZW42/AM+338m63qKepu4svLCyA==
X-Received: by 2002:ac2:51b3:0:b0:4ec:8615:303e with SMTP id f19-20020ac251b3000000b004ec8615303emr153859lfk.33.1681976665501;
        Thu, 20 Apr 2023 00:44:25 -0700 (PDT)
X-Google-Smtp-Source: AKy350YEziSOqiyA9fM17QB4Y5n27W0I+mAplCATFDWAS0IAwiGx01XZ3yJ3qzZFw6GbH5+krOMaiQ==
X-Received: by 2002:ac2:51b3:0:b0:4ec:8615:303e with SMTP id f19-20020ac251b3000000b004ec8615303emr153849lfk.33.1681976665187;
        Thu, 20 Apr 2023 00:44:25 -0700 (PDT)
Received: from localhost.localdomain (c-e6a5e255.022-110-73746f36.bbcust.telenor.se. [85.226.165.230])
        by smtp.googlemail.com with ESMTPSA id x24-20020ac24898000000b004edc7247778sm129468lfc.79.2023.04.20.00.44.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 20 Apr 2023 00:44:24 -0700 (PDT)
From:   Alexander Larsson <alexl@redhat.com>
To:     miklos@szeredi.hu
Cc:     linux-unionfs@vger.kernel.org, amir73il@gmail.com,
        ebiggers@kernel.org, tytso@mit.edu, fsverity@lists.linux.dev,
        Alexander Larsson <alexl@redhat.com>
Subject: [PATCH 0/6] ovl: Add support for fs-verity checking of lowerdata
Date:   Thu, 20 Apr 2023 09:43:59 +0200
Message-Id: <cover.1681917551.git.alexl@redhat.com>
X-Mailer: git-send-email 2.39.2
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

This patch series is based on the lazy lowerdata patch series by Amir[1].

I have also added some tests for this feature to xfstests[2].

I'm also CC:ing the fsverity list and maintainers because there is one
(tiny) fsverity change, and there may be interest in this usecase.

[1] https://lore.kernel.org/linux-unionfs/20230412135412.1684197-1-amir73il@gmail.com/T/#m1bc31eb75dc9dd22204b8f0cfc67bad9b6c785a7
[2] https://github.com/alexlarsson/xfstests/commits/verity-tests

Alexander Larsson (6):
  fsverity: Export fsverity_get_digest
  ovl: Break out ovl_entry_path_real() from ovl_i_path_real()
  ovl: Break out ovl_entry_path_lowerdata() from ovl_path_lowerdata()
  ovl: Add framework for verity support
  ovl: Validate verity xattr when resolving lowerdata
  ovl: Handle verity during copy-up

 Documentation/filesystems/overlayfs.rst |  33 +++++
 fs/overlayfs/Kconfig                    |  14 ++
 fs/overlayfs/copy_up.c                  |  27 ++++
 fs/overlayfs/namei.c                    |  34 +++++
 fs/overlayfs/overlayfs.h                |  11 ++
 fs/overlayfs/ovl_entry.h                |   4 +
 fs/overlayfs/super.c                    |  49 +++++++
 fs/overlayfs/util.c                     | 167 ++++++++++++++++++++++--
 fs/verity/measure.c                     |   1 +
 9 files changed, 332 insertions(+), 8 deletions(-)

-- 
2.39.2

