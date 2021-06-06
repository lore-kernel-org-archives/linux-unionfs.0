Return-Path: <linux-unionfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7C0D0C47096
	for <linux-unionfs@archiver.kernel.org>; Sun,  6 Jun 2021 15:18:33 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 4EE9A6142A
	for <linux-unionfs@archiver.kernel.org>; Sun,  6 Jun 2021 15:18:33 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230088AbhFFPUW (ORCPT
        <rfc822;linux-unionfs@archiver.kernel.org>);
        Sun, 6 Jun 2021 11:20:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60684 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230085AbhFFPUV (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Sun, 6 Jun 2021 11:20:21 -0400
Received: from mail-wm1-x329.google.com (mail-wm1-x329.google.com [IPv6:2a00:1450:4864:20::329])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 10A78C061766;
        Sun,  6 Jun 2021 08:18:16 -0700 (PDT)
Received: by mail-wm1-x329.google.com with SMTP id v206-20020a1cded70000b02901a586d3fa23so4185571wmg.4;
        Sun, 06 Jun 2021 08:18:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=kVJxOHCc0zoPMF6J//FTh8EeOmh3wfs6Og+zVa6EDSM=;
        b=cjBv7s03663VD7AV8+eAGbc+VZ1xRLgRjDpSi9E+qn4HfDCAf9vzthf4bkR7ATZ918
         XDbu7lOzjJh2vYygQguf0tbrNXd4eQ6Q6lJMCKEYg+pBTTX/A/QZ5QC9aMdt73gEPmiV
         hbL7Snu6SRrI3S24wwsdCybImQz/Q6h2XhMS1tFEJ/EF0K2WnY39PDY6l5nrnHCWOEEa
         PcOeq+xNHglnIYCVxGvYRRqdRjO74ewnF40xMCnv5ozNYnCYVFyqSqjV4qIdSaEImHp6
         V7NC7ciLdWMuOH96Q48/CrnQyDZLms4ZAXspqpSPdhCBK2DyKVYcPVD5HGUVO5VJ8WwV
         z9xA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=kVJxOHCc0zoPMF6J//FTh8EeOmh3wfs6Og+zVa6EDSM=;
        b=KH/hHUeLa2QAZ2YaViCKjp0qoEA6eB6iCxOJRfU5EJbAu87ShgANdQIp80yFYwAtGr
         j9+vRCb9Cvl+eJjvMqjHg7teJbzuVEITuAcJUIxOhmZ50e+Haya/CYOdZ2EbgYt5VzF2
         3iAbwoRpfAuZMI0dP58q/Qq1MD199dXstnPDQcVGS9z0K/obPyquZSQrfJjAD6Dv5BJF
         TBlSnMRidH4XQel2mFaOe1JZuxNlotZro0UiSLKsMW6UW0pfhZKHi2z52NWGte+lFJBs
         DVH1np1uulazRIEXzIhI8CVuiIjmU4rLKsUaQekkpICy6pH4AsGp6dK650JW0liGJUN+
         IqlA==
X-Gm-Message-State: AOAM533vMPy/bTSdNeES+WmRkDktQodInadF7f2igByq/YCT/qQXVYst
        8uYllQs8FpEUNs4Pivxm8L8=
X-Google-Smtp-Source: ABdhPJx3A8V/O7kNxdFMBb3OAM0JLPpmB3CieftYYbkPsa8H/F6rRcdeyvvSkYk9GxjxAxYEmZlEYw==
X-Received: by 2002:a7b:c304:: with SMTP id k4mr12881983wmj.68.1622992694018;
        Sun, 06 Jun 2021 08:18:14 -0700 (PDT)
Received: from localhost.localdomain ([185.240.143.244])
        by smtp.gmail.com with ESMTPSA id n9sm14996207wrt.81.2021.06.06.08.18.12
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 06 Jun 2021 08:18:13 -0700 (PDT)
From:   Amir Goldstein <amir73il@gmail.com>
To:     Eryu Guan <guaneryu@gmail.com>
Cc:     Miklos Szeredi <miklos@szeredi.hu>, linux-unionfs@vger.kernel.org,
        fstests@vger.kernel.org
Subject: [PATCH v2 0/2] Fixes to overlayfs immutable files tests
Date:   Sun,  6 Jun 2021 18:18:09 +0300
Message-Id: <20210606151811.420788-1-amir73il@gmail.com>
X-Mailer: git-send-email 2.31.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-unionfs.vger.kernel.org>
X-Mailing-List: linux-unionfs@vger.kernel.org

Eryu,

Test overlay/075 was written and merged to track a known overlayfs issue
which exists in current upstream.

The introduction of fileattr operations in kernel v5.13-rc1 by Miklos
has paved the way for the fix patch that I recently posted [1].

Patch #1 fixes a test bug that was hiding behind the known issue in
upstream kernel.

Patch #2 add test coverage to part of the kernel fix patch that is not
covered by the current test.

Thanks,
Amir.

[1] https://lore.kernel.org/linux-unionfs/20210606144641.419138-1-amir73il@gmail.com/

Amir Goldstein (2):
  overlay/075: fix wrong invocation of t_immutable
  overlay/075: add test coverage for clearing immutable/append-only
    flags

 tests/overlay/075 | 23 +++++++++++++++++++----
 1 file changed, 19 insertions(+), 4 deletions(-)

-- 
2.31.1

