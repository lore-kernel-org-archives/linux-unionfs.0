Return-Path: <SRS0=/kxx=73=vger.kernel.org=linux-unionfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.6 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 162ABC433E0
	for <linux-unionfs@archiver.kernel.org>; Sun, 14 Jun 2020 07:01:31 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id E2AEA2065C
	for <linux-unionfs@archiver.kernel.org>; Sun, 14 Jun 2020 07:01:30 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="ce7nELeN"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726641AbgFNHB3 (ORCPT
        <rfc822;linux-unionfs@archiver.kernel.org>);
        Sun, 14 Jun 2020 03:01:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59620 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726699AbgFNHBU (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Sun, 14 Jun 2020 03:01:20 -0400
Received: from mail-wm1-x343.google.com (mail-wm1-x343.google.com [IPv6:2a00:1450:4864:20::343])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 45AD0C03E96F;
        Sun, 14 Jun 2020 00:01:20 -0700 (PDT)
Received: by mail-wm1-x343.google.com with SMTP id j198so11814392wmj.0;
        Sun, 14 Jun 2020 00:01:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=KNOUh58ZYKkdywRNJuNAP9Gnco9V28qSMb2IBpqFfXo=;
        b=ce7nELeNymVjVrci6RM0qqyLo0M1xtVoLODTf5QwyWMgABnqXGR5+SIdUou5e1bsH8
         fJKs2iabp/UXMDdg9PChsKFn0ZhefpNQscGCxFuuC9erFpkeln2yzHFjh5z/5HGIl2K2
         PFxYUfVcNw4ZyH/iPkaOYcm8IY9vFKhlA1kUEMWOnI8jeFWVUcM94nrEvdSo4mnE2ZZK
         eM5RKoJ0ys/NdCi0PDMhPaoEzQx8C128tYzhNLiYswp0vzFGwxXY2ZW7fD9C/1RftDqO
         ydQAuSdm3X5zYN8W6LHvA7oWAYZa48yD69lvkMr5SjjV0ITS7Kui6+JPQcjK96sISMkr
         CfTQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=KNOUh58ZYKkdywRNJuNAP9Gnco9V28qSMb2IBpqFfXo=;
        b=qXfEEoGneLAS9ex4cp3YkncgruVd3QSezgyEFon08+N+viMwXtcu2CpxWwWAb88R8F
         cr/39m52BO/9WyKioX5azGXYNQZKdq5tt8uT/grPRY7mc3Db/eAVKXv3M4tjO7NDKhTU
         yq+2ulEoOe147WsVZEcsR5OCklxhd8zwlyTYOGRvRQrqagzh/+QMJV2gdLYArTAo1hrf
         MLXGSkTwDo0pHxwlbqcVBlAdlvraQ/qWcG9dwxPIqtcy5kYEm7H8adZTd2Fxcuv7gH7V
         sPcA6aBfk1P+MNBU3qHHbr0jvu0ZHTmHnjKs0uHXjy+Mdd55XNYQpzDGiW/nNl8jgP4x
         zjnA==
X-Gm-Message-State: AOAM5322sM54L+YEstobsuG6Zs0F7ZPy2hd+H/sJ8lfOfuX0mojTS0sR
        VsGtidnYIvENMctw+6ukR/U=
X-Google-Smtp-Source: ABdhPJzaDS/1pKKGAP5VlRSnUt49jKn5DjSEaJIniId/vl/fMLMND3eB2P/CNxh1EXIsAu7GK8ghQg==
X-Received: by 2002:a7b:cb99:: with SMTP id m25mr7060580wmi.0.1592118078461;
        Sun, 14 Jun 2020 00:01:18 -0700 (PDT)
Received: from localhost.localdomain ([5.102.204.95])
        by smtp.gmail.com with ESMTPSA id i10sm17951010wrw.51.2020.06.14.00.01.16
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 14 Jun 2020 00:01:17 -0700 (PDT)
From:   Amir Goldstein <amir73il@gmail.com>
To:     Eryu Guan <guaneryu@gmail.com>
Cc:     Miklos Szeredi <miklos@szeredi.hu>,
        Dan Carpenter <dan.carpenter@oracle.com>,
        Lubos Dolezel <lubos@dolezel.info>,
        linux-unionfs@vger.kernel.org, fstests@vger.kernel.org
Subject: [PATCH v2 0/2] Overlayfs tests for file handle bugs
Date:   Sun, 14 Jun 2020 10:01:07 +0300
Message-Id: <20200614070109.29842-1-amir73il@gmail.com>
X-Mailer: git-send-email 2.17.1
Sender: linux-unionfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-unionfs.vger.kernel.org>
X-Mailing-List: linux-unionfs@vger.kernel.org

Eryu,

Re-posting with final kernel commits now that fixes have been merged.

Thanks,
Amir.

Amir Goldstein (2):
  open_by_handle: add option -z to query file handle size
  overlay: regression test for two file handle bugs

 src/open_by_handle.c  | 27 +++++++++++--
 tests/overlay/074     | 92 +++++++++++++++++++++++++++++++++++++++++++
 tests/overlay/074.out |  2 +
 tests/overlay/group   |  1 +
 4 files changed, 119 insertions(+), 3 deletions(-)
 create mode 100755 tests/overlay/074
 create mode 100644 tests/overlay/074.out

-- 
2.17.1

