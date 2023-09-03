Return-Path: <linux-unionfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 58EF3C83F2D
	for <linux-unionfs@archiver.kernel.org>; Sun,  3 Sep 2023 11:16:09 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234890AbjICLQL (ORCPT
        <rfc822;linux-unionfs@archiver.kernel.org>);
        Sun, 3 Sep 2023 07:16:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41214 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236578AbjICLQK (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Sun, 3 Sep 2023 07:16:10 -0400
Received: from mail-wm1-x334.google.com (mail-wm1-x334.google.com [IPv6:2a00:1450:4864:20::334])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DD1F9127
        for <linux-unionfs@vger.kernel.org>; Sun,  3 Sep 2023 04:16:06 -0700 (PDT)
Received: by mail-wm1-x334.google.com with SMTP id 5b1f17b1804b1-401ec23be82so5904575e9.0
        for <linux-unionfs@vger.kernel.org>; Sun, 03 Sep 2023 04:16:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1693739765; x=1694344565; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=MOSMOfJkm95HqZ+oR17svgKVSt1ZRz2Ck1qxs9N8/dk=;
        b=Adof8gylEYBFB0eFWTIpX1yYI1NjM6coTWlWRvIugsAx7OmfaxjDDN0CD2/AJobECy
         70PDZeCP5lX05OGuEciO5M0DXUuJR5+oHfPGWs7VVCgea+WiLiLq5vDYjFBJVcbLVPxS
         bcctm9dARonOcKd1X2tdc4GF6ZuVWBcnpdweUFnY59zJBdSy7cjHKe5IMb+cd5gifSmp
         W9dD3eNput0FwnKSM60ZkfJN63qxoZ6+8wCq+LJZqH/7lLzfTd6F6uAEq5Xe7EW8wkmX
         gTK4rP1tq42bvCFUXfm/5RqHqX6CDpf4jY2GBDP24A8OwDMb+YFiRHJSXUtyko//5GfV
         YxVA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1693739765; x=1694344565;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=MOSMOfJkm95HqZ+oR17svgKVSt1ZRz2Ck1qxs9N8/dk=;
        b=KeMwmPye5cxAgiIdRjT7HMqH5WSYHyka/7QR86aJSVRs3RnOaPv5E+Gm1tiUV4xtV7
         UAg5UVhkDdu2rDkRqo8DbN+9K9kWXk5+N4QPSm5P6Nq55vR2hiwd1G4ppe74QBDGbedG
         QYewtmRXU3skbn9DK9hVx78RplJgB+VM/aUMrGU9tDqwv6iy5ynTDdsscIwksQVRReRw
         lJQuULmZOx9jQxhYb5rDq2EhODzO3dkzjfuzjj7lGCjI8pZjPkyqXnTcak/D1JRM91V0
         k/x/Q7bf782o8Skrdb7toCGONk9Zv8aUXHL2aD1H4i9kG0gjzCDEt22xtUChYYw6r2wh
         vlmA==
X-Gm-Message-State: AOJu0YydRToKy9FXqUfCA102dZzuemfu4rlqzPjGAbOkJLzicjfZbr49
        oO+LhIUizw5r8KDCbFt+j9s=
X-Google-Smtp-Source: AGHT+IE2id2RYENoL/o5YvIsarDyNaawi+1iHnpkxfbgj9QkZyH0bp50b3hFvC/CwADEqqeevvLFPg==
X-Received: by 2002:a05:600c:220b:b0:3fe:5501:d284 with SMTP id z11-20020a05600c220b00b003fe5501d284mr5145081wml.11.1693739765050;
        Sun, 03 Sep 2023 04:16:05 -0700 (PDT)
Received: from amir-ThinkPad-T480.lan ([5.29.249.86])
        by smtp.gmail.com with ESMTPSA id 9-20020a05600c228900b003fc080acf68sm13899065wmf.34.2023.09.03.04.16.03
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 03 Sep 2023 04:16:04 -0700 (PDT)
From:   Amir Goldstein <amir73il@gmail.com>
To:     Petr Vorel <pvorel@suse.cz>
Cc:     Cyril Hrubis <chrubis@suse.cz>, Jan Kara <jack@suse.cz>,
        Christian Brauner <brauner@kernel.org>,
        Miklos Szeredi <miklos@szeredi.hu>,
        linux-unionfs@vger.kernel.org, ltp@lists.linux.it
Subject: [PATCH 0/3] Tests for fanotify and overlayfs
Date:   Sun,  3 Sep 2023 14:15:55 +0300
Message-Id: <20230903111558.2603332-1-amir73il@gmail.com>
X-Mailer: git-send-email 2.34.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-unionfs.vger.kernel.org>
X-Mailing-List: linux-unionfs@vger.kernel.org

Hi Petr,

Kernel 6.5 and upcoming kernel 6.6 have several improvements
to the integration of fanotify and overlayfs.

Kernel 6.5 includes the fix to generate fanotify events on watched
overlayfs underlying filesystem (tst_variant 1).

Kernel 6.5 also added support for the new AT_HANDLE_FID flag,
which is used in this test.

Kernel 6.6 brings overlayfs support for AT_HANDLE_FID and with it
better support for watching overlayfs with fanotify (tst_variant 2).

tst_variant 2 is duely skipped on kernel 6.5 and tst_variant 1
is skipped on older kernels.

Since the overlayfs changes are not in a release kernel yet, and
since this is not a new test that can go to staging tests, I will
leave it to you to decide how and when you want to merge these new
test variants.

Thanks,
Amir.

Amir Goldstein (3):
  fanotify13: Test watching overlayfs upper fs
  fanotify13: Test watching overlayfs with FAN_REPORT_FID
  fanotify13: Test unique overlayfs fsid

 lib/tst_fs_setup.c                            |  2 +-
 testcases/kernel/syscalls/fanotify/fanotify.h | 36 ++++++++-
 .../kernel/syscalls/fanotify/fanotify13.c     | 77 +++++++++++++++++--
 3 files changed, 105 insertions(+), 10 deletions(-)

-- 
2.34.1

