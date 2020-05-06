Return-Path: <SRS0=Z7uo=6U=vger.kernel.org=linux-unionfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.6 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 016C5C28CBC
	for <linux-unionfs@archiver.kernel.org>; Wed,  6 May 2020 10:23:08 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id CCD1E2068E
	for <linux-unionfs@archiver.kernel.org>; Wed,  6 May 2020 10:23:07 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="MzQNDG0P"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728306AbgEFKXH (ORCPT
        <rfc822;linux-unionfs@archiver.kernel.org>);
        Wed, 6 May 2020 06:23:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39798 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726354AbgEFKXH (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Wed, 6 May 2020 06:23:07 -0400
Received: from mail-wr1-x444.google.com (mail-wr1-x444.google.com [IPv6:2a00:1450:4864:20::444])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ECB55C061A0F;
        Wed,  6 May 2020 03:23:06 -0700 (PDT)
Received: by mail-wr1-x444.google.com with SMTP id g13so1525458wrb.8;
        Wed, 06 May 2020 03:23:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=WhZ+QB+BfLhyhNnqmfxjIwRjYgsd4ySitHHJUruM53Q=;
        b=MzQNDG0PbUewhX7v19BHTggFBFIJNgTNMPnCgEQe0Uf2nutLMYz7eEUVjo01QH9y6D
         GFYm2KDW1jN8olx1TtuPjXpaeEm5Dj/zEizmDzZ8JEDuBsWzR6ZDZT+9hk4a52LqzsxV
         bpJX5+UY14zuvN0oiS/LluP4tCxQIn9pQ3c8ZCvkGq8hIFsfB4wbQM9sOnxoeonf7QCr
         AdRol0NnMeVBBJtTE1AvVWVbY3w0MrstDc0/rDdZ9XwPEtwMeiIaPTnhyDhOVXL6YMkM
         KDEyaFm/ZhEoif2qDoAq3uVKqEREWNtNg1oRFaWXy3ZSihUhIjNaE0p1oqI/oxcK7CLC
         mhFA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=WhZ+QB+BfLhyhNnqmfxjIwRjYgsd4ySitHHJUruM53Q=;
        b=UQ6G9z8FZ2p0dDTCz42anq4OrjoP4k1sCHLe4EZoKXza1a+DZXUU3fEkG2YPKViQXY
         5TyINSaFgjx6x2cUBhjl4tdE1J5PhjYDkE1tP2PaXsE68o22NNAhpykAcfUNp+0Iv2oL
         bvndrUD6Y0YoeL/sw0pXB/Z1ZtSsgLbe3N9N62sYL9Ox3+VPLcdTkPZYC747Y+gDNalR
         XVHY9Mqc5up8xoN6NQP4RWJ4z3KtvhXLa1CNlfgHA61uUHA3L/rVZve9xdxguMRMHfMo
         xRZCC4SyqrE9m2m1/5/H5ABpwe8glVU5RQGBvbdpPgNhjnG9NzL9HdKJHOFNFA+akasZ
         ePwg==
X-Gm-Message-State: AGi0PubCjAjVEFFzO6FEY2pEJxHGde080gZRspjR7SkPrepyylCpihkT
        BiqENoy5CiOt0WVRHhPEAVLo5yJV
X-Google-Smtp-Source: APiQypLr9rxBLrWofszrgi0MwGrhDIquqa2+ENgOZuwr8MCNoZzq1yfeJ2fXiNwq62SxLbX6umJo8Q==
X-Received: by 2002:a5d:650c:: with SMTP id x12mr8346974wru.425.1588760585734;
        Wed, 06 May 2020 03:23:05 -0700 (PDT)
Received: from localhost.localdomain ([141.226.12.123])
        by smtp.gmail.com with ESMTPSA id u2sm2421379wrd.40.2020.05.06.03.23.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 06 May 2020 03:23:05 -0700 (PDT)
From:   Amir Goldstein <amir73il@gmail.com>
To:     Eryu Guan <guaneryu@gmail.com>
Cc:     Miklos Szeredi <miklos@szeredi.hu>,
        Lubos Dolezel <lubos@dolezel.info>,
        Dan Carpenter <dan.carpenter@oracle.com>,
        linux-unionfs@vger.kernel.org, fstests@vger.kernel.org
Subject: [PATCH 0/2] Overlayfs tests for file handle bugs
Date:   Wed,  6 May 2020 13:22:57 +0300
Message-Id: <20200506102259.28107-1-amir73il@gmail.com>
X-Mailer: git-send-email 2.17.1
Sender: linux-unionfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-unionfs.vger.kernel.org>
X-Mailing-List: linux-unionfs@vger.kernel.org

Eryu,

Recently, two independent bugs have been reported by Lubos Dolezel
and Dan Carpenter.

The first bug was there since overlayfs nfs_export support.  The second
bug is a regression introduced in v5.5 that can crash the kernel.

The fix patches have just been posted, so the purpose of this posting
it to test the fixes pre merge.

Thanks,
Amir.

Amir Goldstein (2):
  open_by_handle: add option -z to query file handle size
  overlay: regression test for two file handle bugs

 src/open_by_handle.c  | 27 +++++++++++++--
 tests/overlay/073     | 80 +++++++++++++++++++++++++++++++++++++++++++
 tests/overlay/073.out |  2 ++
 tests/overlay/group   |  1 +
 4 files changed, 107 insertions(+), 3 deletions(-)
 create mode 100755 tests/overlay/073
 create mode 100644 tests/overlay/073.out

-- 
2.17.1

