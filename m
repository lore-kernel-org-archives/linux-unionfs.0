Return-Path: <linux-unionfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.6 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 26537C4338F
	for <linux-unionfs@archiver.kernel.org>; Mon,  9 Aug 2021 17:00:20 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 004D160F8F
	for <linux-unionfs@archiver.kernel.org>; Mon,  9 Aug 2021 17:00:19 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233408AbhHIRAj (ORCPT
        <rfc822;linux-unionfs@archiver.kernel.org>);
        Mon, 9 Aug 2021 13:00:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51716 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233075AbhHIRAj (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Mon, 9 Aug 2021 13:00:39 -0400
Received: from mail-ej1-x62c.google.com (mail-ej1-x62c.google.com [IPv6:2a00:1450:4864:20::62c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E002EC061798
        for <linux-unionfs@vger.kernel.org>; Mon,  9 Aug 2021 10:00:18 -0700 (PDT)
Received: by mail-ej1-x62c.google.com with SMTP id u3so30221910ejz.1
        for <linux-unionfs@vger.kernel.org>; Mon, 09 Aug 2021 10:00:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=szeredi.hu; s=google;
        h=date:from:to:cc:subject:message-id:mime-version:content-disposition;
        bh=ml8YWeKENdHttM1M37Ea6CjN02UFHxweJafrawItaBc=;
        b=ln5imeQ87VkBFUlqtYVfWXqdJetMsvLgTtfMiqAEN8nh1jVvxqWZkV7Fpa8UaVvCUU
         Zrm60uxKIc1jrGXyA6Vsjw5DzOqVR3FkcD2YdlRU/EdJa6Q/BB7IIQax8Kok+0cPG44o
         kGpmStxWa91MVQx4aePEhkdLsRjSmA32pumZw=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:mime-version
         :content-disposition;
        bh=ml8YWeKENdHttM1M37Ea6CjN02UFHxweJafrawItaBc=;
        b=YYJn36+KIwnjEzDLJ8Tbi/RuDWCbUM2gmcvroZK/b6M/e3/jgBEpSq7FWO7bhYHBo7
         uL1BWlGjLWje0c7ZnYlwa4XIEi1+FnMpND2pe2oMRfDWgDPPgglTFK2VXHgJLoRyMvX6
         V+4/lZ4r7MM8O3BDiug3A5dZfOFssNL4VzwFLgTJHb4DxKdJwvjGRfN1QjpPOzV6yVb2
         0vEV/MOhF9Js2KnBQxwF4GTjz8g9bQlOSuDsVrnEVJQR0EVIoqemRDsG4fNaXRsPpQIV
         E5zRRdMn+YRwiWeABf60JvanwUCZv5daP+JaeZ4Gn3gcaRRqQPe1wskgb+BkCjIjIfDd
         sQ/Q==
X-Gm-Message-State: AOAM530AIMDrWTpnDNZNEAs98GwBKJr55+kh7dIazq3+hreu73bPPfum
        q5MlwTLvSBodQgAaqifgzagLNA==
X-Google-Smtp-Source: ABdhPJzZ8H3OPD8jmRICfWorFIzvInFqHIYHkom1mfksGHpupWKEL6M6eINvJBub13WD3yVvcgdzjA==
X-Received: by 2002:a17:906:4808:: with SMTP id w8mr4857408ejq.56.1628528417320;
        Mon, 09 Aug 2021 10:00:17 -0700 (PDT)
Received: from miu.piliscsaba.redhat.com (catv-86-101-169-16.catv.broadband.hu. [86.101.169.16])
        by smtp.gmail.com with ESMTPSA id q14sm8465317edr.0.2021.08.09.10.00.16
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 09 Aug 2021 10:00:16 -0700 (PDT)
Date:   Mon, 9 Aug 2021 19:00:10 +0200
From:   Miklos Szeredi <miklos@szeredi.hu>
To:     Linus Torvalds <torvalds@linux-foundation.org>
Cc:     linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        linux-unionfs@vger.kernel.org
Subject: [GIT PULL] overlayfs fixes for 5.14-rc6
Message-ID: <YRFfGk5lHL0W27oU@miu.piliscsaba.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Precedence: bulk
List-ID: <linux-unionfs.vger.kernel.org>
X-Mailing-List: linux-unionfs@vger.kernel.org

Hi Linus,

Please pull from:

  git://git.kernel.org/pub/scm/linux/kernel/git/mszeredi/vfs.git tags/ovl-fixes-5.14-rc6

Fix several bugs in overlayfs.

Thanks,
Miklos

---
Amir Goldstein (1):
      ovl: skip stale entries in merge dir cache iteration

Miklos Szeredi (4):
      ovl: fix mmap denywrite
      ovl: fix deadlock in splice write
      ovl: fix uninitialized pointer read in ovl_lookup_real_one()
      ovl: prevent private clone if bind mount is not allowed

---
 fs/namespace.c         | 42 +++++++++++++++++++++++++++--------------
 fs/overlayfs/export.c  |  2 +-
 fs/overlayfs/file.c    | 51 ++++++++++++++++++++++++++++++++++++++++++++++++--
 fs/overlayfs/readdir.c |  5 +++++
 include/linux/mm.h     |  2 +-
 mm/mmap.c              |  2 +-
 mm/util.c              | 27 +++++++++++++++++++++++++-
 7 files changed, 111 insertions(+), 20 deletions(-)
