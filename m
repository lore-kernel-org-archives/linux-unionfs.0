Return-Path: <SRS0=taqF=7L=vger.kernel.org=linux-unionfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.6 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4D02DC433DF
	for <linux-unionfs@archiver.kernel.org>; Fri, 29 May 2020 16:41:08 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 298D92077D
	for <linux-unionfs@archiver.kernel.org>; Fri, 29 May 2020 16:41:08 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="QTKUaHDp"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725795AbgE2QlI (ORCPT
        <rfc822;linux-unionfs@archiver.kernel.org>);
        Fri, 29 May 2020 12:41:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32952 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725601AbgE2QlH (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Fri, 29 May 2020 12:41:07 -0400
Received: from mail-wm1-x329.google.com (mail-wm1-x329.google.com [IPv6:2a00:1450:4864:20::329])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CC69CC03E969
        for <linux-unionfs@vger.kernel.org>; Fri, 29 May 2020 09:41:06 -0700 (PDT)
Received: by mail-wm1-x329.google.com with SMTP id u26so7172926wmn.1
        for <linux-unionfs@vger.kernel.org>; Fri, 29 May 2020 09:41:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=sZaYiVXdVGhTQBZsVscXWXX7V33YU7aRGDaUT6Ulkn0=;
        b=QTKUaHDpNSG7OzHS98VM4O/acb156gTlE3NAb9McHwocHP7reXSGX8Z+Z2WE8I9cck
         f3kmxfihyvRgFbBSxEG6wc+oKhnRSmwxV7blgz+e9V7F0XTLXV8F7lGs+ZjXGk8tK1Xd
         y7XyjkYIBppMBXglfFHP9WlraMz8iGYXU5j2SwhudqFT/Zktd/BzOH7ud6W2r/ZMtoFV
         1F7JAET9yJEAIlgHnEloxp7AQpOv6NjOI/RDF0VeqWWp1NRvLAqilnmv37HCs5SwVoT/
         kCtfRYECd6q1zvBy4mXEdN1scmztVYSmNHLci2NlaUFlVw/rI/I3MbR0gVgyubaBtZRM
         m/JQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=sZaYiVXdVGhTQBZsVscXWXX7V33YU7aRGDaUT6Ulkn0=;
        b=tGL1nxwIm5Xt1ajkatEHH8+V3mOHDB7yqjeI5reLqysUxLZRcsI5Hs+MyCCrIF1LD4
         gXLfto/gdJQetoZTc047c19e0jCz6ZnPWBONeW/IDxpUPwcw3ogklL+oYkpGSjMhMjj/
         NFKvIQ8qr6ZDkMfUJ86Z960B0YCb1xH6OP2LQBLoEL9p/g4YBwTadOPRk2xjdrMCftUl
         rK8EXAlgJFNNXVn5kwhkJkriOOfgAalPU5RjPD0zxkgw73zrrRdt2Px+ngLv5kRpCnEg
         5kqCOsh+mrI7pDtVR3dRVaTpnIaaVyppx7WjhRCdl5kU5cwuITViep7p4FIY5iJ2yWPn
         3ztQ==
X-Gm-Message-State: AOAM5313OVxZru3mp88y/rNfA6dF4rWkQWVaoLZgfhkYcD3IgKZoDOj6
        v2lHjTu3pEvLZ3UErGSg8vo5e0PJ
X-Google-Smtp-Source: ABdhPJxNsjQ2WfPwZpFXUfwk8CBxbMfgLprjiQVyPHa+ZSvVXeihoiXUouMeqkTNRO343MIrlgqEnw==
X-Received: by 2002:a1c:5411:: with SMTP id i17mr9799220wmb.137.1590770464558;
        Fri, 29 May 2020 09:41:04 -0700 (PDT)
Received: from localhost.localdomain ([141.226.12.123])
        by smtp.gmail.com with ESMTPSA id 62sm11117056wrm.1.2020.05.29.09.41.03
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 29 May 2020 09:41:03 -0700 (PDT)
From:   Amir Goldstein <amir73il@gmail.com>
To:     linux-unionfs@vger.kernel.org
Cc:     Vivek Goyal <vgoyal@redhat.com>, Miklos Szeredi <miklos@szeredi.hu>
Subject: [ANNOUNCE] unionmount-testsuite: master branch updated to 9c60a9c
Date:   Fri, 29 May 2020 19:40:58 +0300
Message-Id: <20200529164058.4654-1-amir73il@gmail.com>
X-Mailer: git-send-email 2.17.1
Sender: linux-unionfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-unionfs.vger.kernel.org>
X-Mailing-List: linux-unionfs@vger.kernel.org

Hi All,

The master branch on the unionmount-testsuite tree [1] has been updated.

Changes in this update:
- Support user configurable underlying filesystem

So far, unionmount-testsuite used hardcoded paths for layers and
mount point.  Using underlying filesystem other than tmpfs was possible,
but not very easy to setup.

This update brings the ability for user to configure custom paths
with a custom filesystem for the underlying layers.
This is intended to be used for integration with xfstests [2].

Here is an excerpt from the README:
---
  The following environment variables are supported:

  UNIONMOUNT_BASEDIR  - parent dir of all samefs layers (default: /base)
  UNIONMOUNT_LOWERDIR - lower layer path for non samefs (default: /lower)
  UNIONMOUNT_MNTPOINT - mount point for executing tests (default: /mnt)

  When user provides UNIONMOUNT_LOWERDIR:

  1) Path should be an existing directory whose content will be deleted.
  2) Path is assumed to be on a different filesystem than base dir, so
     --samefs setup is not supported.

  When user provides UNIONMOUNT_BASEDIR:

  1) Path should be an existing directory whose content will be deleted.
  2) Upper layer and middle layers will be created under base dir.
  3) If UNIONMOUNT_MNTPOINT is not provided, the overlay mount point will
     be created under base dir.
  4) If UNIONMOUNT_LOWERDIR is not provided, the lower layer dir will be
     created under base dir.
  5) If UNIONMOUNT_LOWERDIR is not provided, the test setup defaults to
     --samefs (i.e. lower and upper layers are on the same base fs).
     However, if --maxfs=<M> is specified, a tmpfs instance will be
     mounted on the lower layer dir that was created under base dir.
---

Many thanks to Vivek for review and testing.

Thanks,
Amir.

[1] https://github.com/amir73il/unionmount-testsuite
[2] https://github.com/amir73il/xfstests/commits/unionmount

The head of the master branch is commit:

9c60a9c Configure custom layers via environment variables

New commits:

Amir Goldstein (3):
  Add command run --clean-up to cleanup old test mounts
  Stop using bind mounts for --samefs
  Configure custom layers via environment variables

 README           |  26 ++++++++++
 mount_union.py   |  13 +----
 run              |  32 +++++-------
 set_up.py        | 127 +++++++++++++++++++++++++----------------------
 settings.py      |  85 +++++++++++++++++++++++++------
 unmount_union.py |  15 +++---
 6 files changed, 187 insertions(+), 111 deletions(-)

-- 
2.17.1

