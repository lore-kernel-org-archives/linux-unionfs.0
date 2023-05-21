Return-Path: <linux-unionfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F3F7DC7EE29
	for <linux-unionfs@archiver.kernel.org>; Sun, 21 May 2023 08:31:32 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229732AbjEUIba (ORCPT
        <rfc822;linux-unionfs@archiver.kernel.org>);
        Sun, 21 May 2023 04:31:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49176 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230037AbjEUI2T (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Sun, 21 May 2023 04:28:19 -0400
Received: from smtp-relay-internal-0.canonical.com (smtp-relay-internal-0.canonical.com [185.125.188.122])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A689C18F
        for <linux-unionfs@vger.kernel.org>; Sun, 21 May 2023 01:28:18 -0700 (PDT)
Received: from mail-ej1-f69.google.com (mail-ej1-f69.google.com [209.85.218.69])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (No client certificate requested)
        by smtp-relay-internal-0.canonical.com (Postfix) with ESMTPS id 5AE8E3F4A6
        for <linux-unionfs@vger.kernel.org>; Sun, 21 May 2023 08:28:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=canonical.com;
        s=20210705; t=1684657697;
        bh=Tv9SP0tP+8DRjLTNt8sd7O2hc074o3ygEuc+rvxGi5M=;
        h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
         MIME-Version;
        b=B2np6/42mdslIvsIz/AUbtKnejLsEHxvj1UOw6KmBS/Ta48DhDz2j4JvvklOznnLT
         mPkeOIyWbL4B/QRQfBBsYPkGzkaaG+XgbruvhbESXtjYopzkV56ZxCPPxsAM5f+wiV
         hxWbuit6wu+iTb0v/Pzmeux2by3trT85gWPFAWVf2OMZrIRmdBWJHrnJeP79aczMBF
         WI+BtN1iKDvpC7UNpQUik5CH4hMCxKk4Tr7Njr4Ow+WVkCqiKld0aR1tQx2+lalUmv
         +zNbTSZTYJd3+kMXtG+kEQl9nyGXcRoLZYIzBQ7MNQMgl96ftZjJcvRLqq9S2CQS2z
         svf3lys3oLPFA==
Received: by mail-ej1-f69.google.com with SMTP id a640c23a62f3a-965c6f849b9so576116266b.2
        for <linux-unionfs@vger.kernel.org>; Sun, 21 May 2023 01:28:17 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1684657697; x=1687249697;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=Tv9SP0tP+8DRjLTNt8sd7O2hc074o3ygEuc+rvxGi5M=;
        b=eJSL43AdWvzqmo30dOUqta+mRdOgNzcyLIlXmVX5MGJ4tOoH4XCL1VSx2gVWCUS3XP
         33yKeZee+os0+rU7nV48ufrtN97Khz1LGBNdgER3Z2jYVW+1L/cXgRW0iujgMaB+AHfj
         SxVA2C+VkwXpsIypj8wV33dtU8y1+4+7In9xf6M02oqYPd+pSDfxv0Vfx9aFJ+afEs8K
         o6E2c8HGHhBtfhPyQnmS67J+5N+ohEU1r+sG0DHTRHuPRxoT7FhlqOU1IZKFGIRrSeGW
         1xou5KHMlk49vhw6rFtLX6q90mkpMo/qsy9BfI1M3Kx5hfNZgQb9cj/GyuIrYS431dVO
         bpNg==
X-Gm-Message-State: AC+VfDw1Uj4nRALGovgY62bwZzNqfDX4/pH4SLsls4V4VnW4IJYFzmHZ
        i84mRlveGWezbWfWCtgjRyq5B85nw20Vem9sCLgsseJSiVgz+GW+XZ7gWh0nOpY+ug4Y5OiQyJi
        FYeNB0peHKq3r2yAV5zjTMhO6F6K9KhekYHZJ3TxppWPRMzCTguY=
X-Received: by 2002:a17:907:ea8:b0:96f:d63a:9508 with SMTP id ho40-20020a1709070ea800b0096fd63a9508mr408831ejc.33.1684657697001;
        Sun, 21 May 2023 01:28:17 -0700 (PDT)
X-Google-Smtp-Source: ACHHUZ5zjmpQLazlg4eQAFXZI5Rr2SSRNw/GT8/EqlXK/VXX1kP9qh5iIckYIkjPiO0SfPZjdVdQXQ==
X-Received: by 2002:a17:907:ea8:b0:96f:d63a:9508 with SMTP id ho40-20020a1709070ea800b0096fd63a9508mr408823ejc.33.1684657696828;
        Sun, 21 May 2023 01:28:16 -0700 (PDT)
Received: from righiandr-XPS-13-7390.homenet.telecomitalia.it (host-87-10-127-160.retail.telecomitalia.it. [87.10.127.160])
        by smtp.gmail.com with ESMTPSA id z17-20020aa7cf91000000b004c2158e87e6sm1656646edx.97.2023.05.21.01.28.16
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 21 May 2023 01:28:16 -0700 (PDT)
From:   Andrea Righi <andrea.righi@canonical.com>
To:     Miklos Szeredi <miklos@szeredi.hu>
Cc:     Amir Goldstein <amir73il@gmail.com>, linux-unionfs@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH v3 1/3] ovl: Kconfig: introduce CONFIG_OVERLAY_FS_DEBUG
Date:   Sun, 21 May 2023 10:28:11 +0200
Message-Id: <20230521082813.17025-2-andrea.righi@canonical.com>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230521082813.17025-1-andrea.righi@canonical.com>
References: <20230521082813.17025-1-andrea.righi@canonical.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-unionfs.vger.kernel.org>
X-Mailing-List: linux-unionfs@vger.kernel.org

Provide a Kconfig option to enable extra debugging checks for overlayfs.

Reviewed-by: Amir Goldstein <amir73il@gmail.com>
Signed-off-by: Andrea Righi <andrea.righi@canonical.com>
---
 fs/overlayfs/Kconfig | 9 +++++++++
 1 file changed, 9 insertions(+)

diff --git a/fs/overlayfs/Kconfig b/fs/overlayfs/Kconfig
index 6708e54b0e30..fec5020c3495 100644
--- a/fs/overlayfs/Kconfig
+++ b/fs/overlayfs/Kconfig
@@ -124,3 +124,12 @@ config OVERLAY_FS_METACOPY
 	  that doesn't support this feature will have unexpected results.
 
 	  If unsure, say N.
+
+config OVERLAY_FS_DEBUG
+	bool "Overlayfs: turn on extra debugging checks"
+	default n
+	depends on OVERLAY_FS
+	help
+	  Say Y here to enable extra debugging checks in overlayfs.
+
+	  If unsure, say N.
-- 
2.39.2

