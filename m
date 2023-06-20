Return-Path: <linux-unionfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8D6DDEB64D7
	for <linux-unionfs@archiver.kernel.org>; Tue, 20 Jun 2023 10:16:22 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231231AbjFTKQV (ORCPT
        <rfc822;linux-unionfs@archiver.kernel.org>);
        Tue, 20 Jun 2023 06:16:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45002 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230526AbjFTKQU (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Tue, 20 Jun 2023 06:16:20 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E463910F1
        for <linux-unionfs@vger.kernel.org>; Tue, 20 Jun 2023 03:15:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1687256134;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=4kAOgXpY7nv0aA6tKuGnVIvTOJljbCAPrQYz8VNVmek=;
        b=VnxBeNBtMOk8ANtdxcR+9Jhd2azP7lrozHLwMSvnb8GVqCXECoHYpVru9VXpaOnvpd6o01
        EpK2H5Fa0TSFxHJmCO/gcbvq36mxqhhhRa4LOqCk75Qj5umoFtuh4sfDpkL3GBpJ7/d0gW
        eIHOx9vUWiAYdpc216RaIY4QHVql5hY=
Received: from mail-lj1-f198.google.com (mail-lj1-f198.google.com
 [209.85.208.198]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-247-EnxQTFdzNlqELD34BpTv2g-1; Tue, 20 Jun 2023 06:15:31 -0400
X-MC-Unique: EnxQTFdzNlqELD34BpTv2g-1
Received: by mail-lj1-f198.google.com with SMTP id 38308e7fff4ca-2b46d6a2e75so17997361fa.1
        for <linux-unionfs@vger.kernel.org>; Tue, 20 Jun 2023 03:15:30 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1687256129; x=1689848129;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=4kAOgXpY7nv0aA6tKuGnVIvTOJljbCAPrQYz8VNVmek=;
        b=EZgjq1ZuxLr7jZeXhYWzr0fOHAnz7dlDbsjJqFqwJMyYfV5LFCuDc0CUo6rGVR6nrQ
         99mcqmiFqzWkjyTgZTKtaAt+1yP9hE+AZL8glI2qR/oeAvAi6Hpmp6E60v8nUACv08aH
         qt2dNLd+8JvwVNXEDz4ZpsRBrV33oOB1vU5fSR4uasKWOjtgeViMcPy/6x3wrrCwwnVL
         Nt6pZ9dMpdLhekjaZmjojc9HdArCWFAjmLRAXWRhwNZ8MT5gLEfoz2f7tFlIoeFKk8DX
         8j50e2C2XQ7583SVL7vW4oKLFrqb+bemzxQ8XIyN79sjgO+VIvD7CKHay2LNKb8A5CSO
         pRnw==
X-Gm-Message-State: AC+VfDwpTkcgMZnFwjEJ4kkA4AfirvtCrTbjTX/OHrYmqCX6otPYLMt6
        pPGKy068+ieLMZ7aOUzYNkltJgruzmz1K5L3KtGx8gXgyFu1zATst6SLebtxFXYiVBFoafCrzLw
        HgUHkv/E6Z3QeUcCegoih/Ycx31AU8/tnqQ==
X-Received: by 2002:a05:651c:115:b0:2b5:7fd2:ec36 with SMTP id a21-20020a05651c011500b002b57fd2ec36mr579747ljb.21.1687256129300;
        Tue, 20 Jun 2023 03:15:29 -0700 (PDT)
X-Google-Smtp-Source: ACHHUZ6HU11F2Aqa+nlbBU5hBNijgW9gOPsUiuovV0S1O91k3qJT1L4n1XJZMhOwkyniYeEYQx/zFA==
X-Received: by 2002:a05:651c:115:b0:2b5:7fd2:ec36 with SMTP id a21-20020a05651c011500b002b57fd2ec36mr579733ljb.21.1687256128958;
        Tue, 20 Jun 2023 03:15:28 -0700 (PDT)
Received: from localhost.localdomain (c-e6a5e255.022-110-73746f36.bbcust.telenor.se. [85.226.165.230])
        by smtp.googlemail.com with ESMTPSA id h9-20020a2e9009000000b002b326e7e76csm337280ljg.64.2023.06.20.03.15.28
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 20 Jun 2023 03:15:28 -0700 (PDT)
From:   Alexander Larsson <alexl@redhat.com>
To:     miklos@szeredi.hu
Cc:     linux-unionfs@vger.kernel.org, amir73il@gmail.com,
        ebiggers@kernel.org, tytso@mit.edu, fsverity@lists.linux.dev,
        Alexander Larsson <alexl@redhat.com>
Subject: [PATCH v4 0/3] ovl: Add support for fs-verity checking of lowerdata
Date:   Tue, 20 Jun 2023 12:15:15 +0200
Message-Id: <cover.1687255035.git.alexl@redhat.com>
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

This series depends on the commit
  fsverity: rework fsverity_get_digest() again
Which is in the "for-next" branch of 
  https://git.kernel.org/pub/scm/fs/fsverity/linux.git/

This series, plus the above commit are also in git here:
  https://github.com/alexlarsson/linux/tree/overlay-verity

I would love to see this go into 6.5. So Eric, could you maybe Ack the
implementation patches separately from the documentation patches? Then
maybe we can get this in early, and I promise to try to get the
documentation up to standard during the 6.5 cycle as needed.

Changes since v3:
 * Instead of using a overlay.digest xattr we extend the current
   overlay.metacopy xattr with version, flags and digest. This makes
   it flexible for later changes and allows us to use the existing
   xattr lookup to know ahead of time whether a file needs to have
   verity validated.

   I've done some performance checks on this new layout, and the
   results are essentially the same as before.

 * This is rebased on top of the latest overlayfs-next, which includes
   the changes to the new mount API, so that part has been redone.

 * The documentation changes have been rewritten to try to be more
   clear about the behaviour of i/o verification when verity is used.

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

Alexander Larsson (3):
  ovl: Add framework for verity support
  ovl: Validate verity xattr when resolving lowerdata
  ovl: Handle verity during copy-up

 Documentation/filesystems/fsverity.rst  |   2 +
 Documentation/filesystems/overlayfs.rst |  48 ++++++++
 fs/overlayfs/copy_up.c                  |  47 ++++++-
 fs/overlayfs/file.c                     |   8 +-
 fs/overlayfs/namei.c                    |  97 +++++++++++++--
 fs/overlayfs/overlayfs.h                |  53 ++++++--
 fs/overlayfs/ovl_entry.h                |   1 +
 fs/overlayfs/super.c                    |  69 +++++++++--
 fs/overlayfs/util.c                     | 156 +++++++++++++++++++++++-
 9 files changed, 448 insertions(+), 33 deletions(-)

-- 
2.40.1

