Return-Path: <linux-unionfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 013DBC77B75
	for <linux-unionfs@archiver.kernel.org>; Wed,  3 May 2023 08:52:42 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229526AbjECIwm (ORCPT
        <rfc822;linux-unionfs@archiver.kernel.org>);
        Wed, 3 May 2023 04:52:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39886 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229449AbjECIwl (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Wed, 3 May 2023 04:52:41 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5883010D9
        for <linux-unionfs@vger.kernel.org>; Wed,  3 May 2023 01:51:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1683103917;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=4a+f8Fz30tFWUstPUy0HitI6O2dH+5DYRSPePkoVA7E=;
        b=cibz2IIRo8D3cm+6MLMqprI4OLbupm1AEywFfgbQDE8rZ/55rQWlFl3mJQo6g7mnhYbqWa
        nXTIM+XzTGdwrbP9seV0r5uUPa/GHjMCMM2fWY7Y+U/gx4Tj1SbCxNd4y2SKpIybtcDRCI
        JCi+SBhdHjq/oZGjMLR96LZ6qyTYju4=
Received: from mail-lf1-f72.google.com (mail-lf1-f72.google.com
 [209.85.167.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-411-1Fe_3vMmMXGptLseMH28TQ-1; Wed, 03 May 2023 04:51:56 -0400
X-MC-Unique: 1Fe_3vMmMXGptLseMH28TQ-1
Received: by mail-lf1-f72.google.com with SMTP id 2adb3069b0e04-4edc5d704bbso2760376e87.2
        for <linux-unionfs@vger.kernel.org>; Wed, 03 May 2023 01:51:55 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1683103915; x=1685695915;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=4a+f8Fz30tFWUstPUy0HitI6O2dH+5DYRSPePkoVA7E=;
        b=PMBw/DRpIc7SmkRd6Kx/Ia9bzCm7TH9Ym12aq2bV3LbZUPZVIU06zDB0Cvg5eAs/YV
         D+YaQXYlZVU+XBcvwoEDkZYXKvpO9R8tEBBgj4R8I/Pcx/HbAamdOkSofWONt/DoYImH
         S3lVbQLoOOUlwHfW03AlThVSyQmdZFqfQmGTs0ie7zI4YsW9JU/uVCKmMnteuehuh2z7
         lrDE/Afekw+YMJj/xNThJqPXYSlp/gn78yBnleYUZhRZXPw4LnP8NnMn8VG6AYd4PuNB
         6h6pVOEgPpIrx4WBX/IGFrhsrwBbL0JL95s23Dn6dcNWnnjBZoPXuaVPzZ/y9OL9+fVE
         QxKQ==
X-Gm-Message-State: AC+VfDxeBlb23tmFX/AAL5HTex9SUU9nbK+iig7+FpGBInNF7Zl0bZGo
        7YO5cYjVv4SGKU7TdS/FH/iWganU0wOVgbZt3hApj97UMi2Aeytx5vK2lfWz5QNjwko/++uRGNX
        xoWJA4NucWm7IZzLF+wFvqZ9rhw==
X-Received: by 2002:ac2:4468:0:b0:4dc:82b0:4c68 with SMTP id y8-20020ac24468000000b004dc82b04c68mr640874lfl.50.1683103914864;
        Wed, 03 May 2023 01:51:54 -0700 (PDT)
X-Google-Smtp-Source: ACHHUZ6Xzkn0lqidzGMiyCQRL8W1ti01Ujxk2+TA/bge7mKgJluQVT0T2m86kotF44T0gebhvbFgdg==
X-Received: by 2002:ac2:4468:0:b0:4dc:82b0:4c68 with SMTP id y8-20020ac24468000000b004dc82b04c68mr640867lfl.50.1683103914526;
        Wed, 03 May 2023 01:51:54 -0700 (PDT)
Received: from localhost.localdomain (c-e6a5e255.022-110-73746f36.bbcust.telenor.se. [85.226.165.230])
        by smtp.googlemail.com with ESMTPSA id j6-20020ac24546000000b004ed4fa5f20fsm5907089lfm.25.2023.05.03.01.51.53
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 03 May 2023 01:51:53 -0700 (PDT)
From:   Alexander Larsson <alexl@redhat.com>
To:     miklos@szeredi.hu
Cc:     linux-unionfs@vger.kernel.org, amir73il@gmail.com,
        ebiggers@kernel.org, tytso@mit.edu, fsverity@lists.linux.dev,
        Alexander Larsson <alexl@redhat.com>
Subject: [PATCH v2 0/6] ovl: Add support for fs-verity checking of lowerdata
Date:   Wed,  3 May 2023 10:51:33 +0200
Message-Id: <cover.1683102959.git.alexl@redhat.com>
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

[1] https://lore.kernel.org/linux-unionfs/20230427130539.2798797-1-amir73il@gmail.com/T/#m3968bf64a31946e77bdba8e3d07688a34cf79982
[2] https://github.com/alexlarsson/xfstests/commits/verity-tests

Alexander Larsson (6):
  fsverity: Export fsverity_get_digest
  ovl: Break out ovl_e_path_real() from ovl_i_path_real()
  ovl: Break out ovl_e_path_lowerdata() from ovl_path_lowerdata()
  ovl: Add framework for verity support
  ovl: Validate verity xattr when resolving lowerdata
  ovl: Handle verity during copy-up

 Documentation/filesystems/overlayfs.rst |  27 ++++
 fs/overlayfs/copy_up.c                  |  31 +++++
 fs/overlayfs/namei.c                    |  42 +++++-
 fs/overlayfs/overlayfs.h                |  12 ++
 fs/overlayfs/ovl_entry.h                |   3 +
 fs/overlayfs/super.c                    |  74 ++++++++++-
 fs/overlayfs/util.c                     | 165 ++++++++++++++++++++++--
 fs/verity/measure.c                     |   1 +
 8 files changed, 343 insertions(+), 12 deletions(-)

-- 
2.39.2

