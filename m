Return-Path: <linux-unionfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_GIT autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6A54EC433ED
	for <linux-unionfs@archiver.kernel.org>; Wed, 21 Apr 2021 09:23:36 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 4591C61448
	for <linux-unionfs@archiver.kernel.org>; Wed, 21 Apr 2021 09:23:36 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238119AbhDUJYB (ORCPT
        <rfc822;linux-unionfs@archiver.kernel.org>);
        Wed, 21 Apr 2021 05:24:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45954 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238106AbhDUJX5 (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Wed, 21 Apr 2021 05:23:57 -0400
Received: from mail-wr1-x431.google.com (mail-wr1-x431.google.com [IPv6:2a00:1450:4864:20::431])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1800BC06174A;
        Wed, 21 Apr 2021 02:23:22 -0700 (PDT)
Received: by mail-wr1-x431.google.com with SMTP id p6so33902527wrn.9;
        Wed, 21 Apr 2021 02:23:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=lrd3z/TAw6Opewof+ye4zaEEL7WxSuPfQcZpnCDp0l0=;
        b=roNGBdajiSyYWUTEqv7kgGPb3U7dR2vfw/5t+il2JA0jxpsP52DMmjh+fIZWrB+jer
         OOal67/Kz+ZnuKMhD964SMNgCPvc3V1GijZmKWuFX6AkjTKWDGUNwpUx0e+GGcS9Y0ur
         WTRigglU7Uxp4TvOkE/Dt30Kqe0bwHF/TPAETep61haP7lk9bAAsvhaPPd1bvt+8Hgv4
         3i/LTdPW32gve6tUVoeGIed6NfBNFLaxzE1Hi4CZHh4SVh9QGB5JW+hDY/znxcOZhCLg
         9MTfKFFedhKQW14QP7Fr+nEIhOroSMLVpbB59hGomUMufc4/b9pE7cpAL4J7BPjGOeu5
         RQsw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=lrd3z/TAw6Opewof+ye4zaEEL7WxSuPfQcZpnCDp0l0=;
        b=mC5Cs+B6HtWqTf568I1aet9hdU7HecSW9Vi6eyvtLAMw/YNw428pnXYqEvD48uETaY
         lmQ4fttiAj92pK5BJguEcJTQajx9Z+4X1uh7mzFOD4jf189+Rf7r0CELxMzkfXk8pvic
         vTnMBAhMpH+Fn3YFk5MYg3nxqTWmVJMIRDPeK1JEBRIMmRH+W65Ym4PMmdqhchRxR6DX
         jJFn/t3u2oV/0/SaPXM2Nu/fHMXV0HW2RfLIT72uD4isuucBjwVThwMAaM8CBzuPB7+U
         YT5bJR4D1CzNZHi68vlQI/6y2KL0f7mbS0MoXYhJjdNQO0Kv0Wm5MiudH7gyBkDEw/YX
         lA8g==
X-Gm-Message-State: AOAM531H1ahYUIa7d1MMkp8IxUcbbBGFJ8C/1vbPEprSEl7tjWNPcVea
        PMdkqlQq5n247AWAVoO2UUt2MRASBOI=
X-Google-Smtp-Source: ABdhPJy3w5XPz1AvgrZL4JMZJ65C19kKVWv6YHbpfWdNMZRlRiwT+fRgYnplDx7M4qYcq5S5ARfFYA==
X-Received: by 2002:adf:ce0c:: with SMTP id p12mr25557797wrn.59.1618997000884;
        Wed, 21 Apr 2021 02:23:20 -0700 (PDT)
Received: from localhost.localdomain ([82.114.44.37])
        by smtp.gmail.com with ESMTPSA id p3sm1551754wmq.31.2021.04.21.02.23.19
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 21 Apr 2021 02:23:20 -0700 (PDT)
From:   Amir Goldstein <amir73il@gmail.com>
To:     Eryu Guan <guaneryu@gmail.com>
Cc:     Miklos Szeredi <miklos@szeredi.hu>, linux-unionfs@vger.kernel.org,
        fstests@vger.kernel.org
Subject: [PATCH 0/2] Test overlayfs readdir cache
Date:   Wed, 21 Apr 2021 12:23:15 +0300
Message-Id: <20210421092317.68716-1-amir73il@gmail.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-unionfs.vger.kernel.org>
X-Mailing-List: linux-unionfs@vger.kernel.org

Eryu,

This extends the generic t_dir_offset2 test to verify
some more test cases and adds a new generic test which
passes on overlayfs (and other fs) on upstream kernel.

The overlayfs specific test fails on upstream kernel
and the fix commit is currently in linux-next.
As usual, you may want to wait with merging until the fix
commit hits upstream.

Miklos,

I had noticed in the test full logs that readdir of
a merged dir behaves strangely - when seeking backwards
to offsets > 0, readdir returns unlinked entries in results.
The test does not fail on that behavior because the test
only asserts that this is not allowed after seek to offset 0.

Knowing the implementation of overlayfs readdir cache this is
not surprising to me, but I wonder if this behavior is POSIX
compliant, and if not, whether we should document it and/or
add a failing test for it.

Thanks,
Amir.

Amir Goldstein (2):
  generic: Test readdir of modified directrory
  overlay: Test invalidate of readdir cache

 src/t_dir_offset2.c   |  63 +++++++++++++++++++++++--
 tests/generic/700     |  60 ++++++++++++++++++++++++
 tests/generic/700.out |   2 +
 tests/generic/group   |   1 +
 tests/overlay/077     | 105 ++++++++++++++++++++++++++++++++++++++++++
 tests/overlay/077.out |   2 +
 tests/overlay/group   |   1 +
 7 files changed, 231 insertions(+), 3 deletions(-)
 create mode 100755 tests/generic/700
 create mode 100644 tests/generic/700.out
 create mode 100755 tests/overlay/077
 create mode 100644 tests/overlay/077.out

-- 
2.25.1

