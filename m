Return-Path: <linux-unionfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E71B1C433DB
	for <linux-unionfs@archiver.kernel.org>; Thu, 18 Mar 2021 11:31:17 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id A446C64F24
	for <linux-unionfs@archiver.kernel.org>; Thu, 18 Mar 2021 11:31:17 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229824AbhCRLap (ORCPT
        <rfc822;linux-unionfs@archiver.kernel.org>);
        Thu, 18 Mar 2021 07:30:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44074 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229996AbhCRLae (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Thu, 18 Mar 2021 07:30:34 -0400
Received: from mail-pj1-x1041.google.com (mail-pj1-x1041.google.com [IPv6:2607:f8b0:4864:20::1041])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9E8C7C06174A;
        Thu, 18 Mar 2021 04:30:34 -0700 (PDT)
Received: by mail-pj1-x1041.google.com with SMTP id nh23-20020a17090b3657b02900c0d5e235a8so2988064pjb.0;
        Thu, 18 Mar 2021 04:30:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=r0+LWaiI+7JNgJzeKBry91AR/nmK5GCftG7bhYfqr7s=;
        b=BmBbpcOqLpSMNS8YW+9ovbbeSU6H2uEAicyBLPIQyqTO/tevnL+rwOtpOkuGKE5e1B
         H0udYkcshnm32g55HzD2Ja3dFEoADJfpvv4/meKWRe2OAVbuAwDjqdu7lUuUj+9VUbHI
         TKEMaxFeM3p7fwujGtn8jOHOXvc97CP5a664TFqwdn9j2kcJ7GMDKP6TvRXNzTKGDvSd
         AwREgXN2hjpsdoLxPoh7MqtHcXL/8tzOnyvspF5Gw4hfSgYYkSM5yNJ7CsTKAs52YmEe
         +km0pBCqDr0nXczpvb2fbYAgtK904StfZn3DIiESnZSvP8Zw49djLMFxJoFd4Cps28ZD
         NaAw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=r0+LWaiI+7JNgJzeKBry91AR/nmK5GCftG7bhYfqr7s=;
        b=XwM+eMpdlEL0lrnFXeh4mXEWRRy6thA2nqpVO9cGT6lCV0XtHi59CU5o6hf7pEmWze
         F01a1w+T3t9AoNOnkAnuZWFU3t8pejWPRLkd6ACKpeFXHL7SlnXW12mwEPZZxpVqRVqb
         FuJZwOnWwxaJObWjR9xQBYZ1uIRUDgBjBdEtYTf0QAGO7csenhMlu3NVgEauFOlk1FeM
         UUhFFdkV/NAfMOPJQy9GTInvMgFTUaf9kQnOXaNDf44mc7OfylHTH/vpvmJZvO02DK4D
         w9+wR/p8dAgs0iD7geToHZ4/tF/tlYVDU/D/Le6thEruyYfuuA4XbIlC76jSGq7MoDbk
         JRjw==
X-Gm-Message-State: AOAM532I4na3NChk/QIWjzOIA9aKWcA1CdZyeOhBYyt9J/rq0v4hmmZ3
        VbdSG91mvSlaE/sqzJZ/4PkU8ONQwxs=
X-Google-Smtp-Source: ABdhPJw8imGq3kc0DSej1SQn9Usr6fAtBtk9AH4UesoocWPAdZIXaUfFpzglQXWGFhVFbyl+kpKlCQ==
X-Received: by 2002:a17:90b:4d0c:: with SMTP id mw12mr4006765pjb.216.1616067034109;
        Thu, 18 Mar 2021 04:30:34 -0700 (PDT)
Received: from localhost.localdomain ([178.236.46.205])
        by smtp.gmail.com with ESMTPSA id z27sm2146657pff.111.2021.03.18.04.30.32
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 18 Mar 2021 04:30:33 -0700 (PDT)
From:   menglong8.dong@gmail.com
X-Google-Original-From: xiong.zhenwu@zte.com.cn
To:     miklos@szeredi.hu
Cc:     linux-unionfs@vger.kernel.org, linux-kernel@vger.kernel.org,
        Xiong Zhenwu <xiong.zhenwu@zte.com.cn>
Subject: [PATCH] /fs/overlayfs/: fix misspellings using codespell tool
Date:   Thu, 18 Mar 2021 04:30:27 -0700
Message-Id: <20210318113027.473158-1-xiong.zhenwu@zte.com.cn>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-unionfs.vger.kernel.org>
X-Mailing-List: linux-unionfs@vger.kernel.org

From: Xiong Zhenwu <xiong.zhenwu@zte.com.cn>

A typo is found out by codespell tool:

$ codespell ./fs/overlayfs/
./fs/overlayfs/util.c:217: dependig  ==> depending

Fix a typo found by codespell.

Signed-off-by: Xiong Zhenwu <xiong.zhenwu@zte.com.cn>
---
 fs/overlayfs/util.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/overlayfs/util.c b/fs/overlayfs/util.c
index 7f5a01a11f97..2544694d40b9 100644
--- a/fs/overlayfs/util.c
+++ b/fs/overlayfs/util.c
@@ -214,7 +214,7 @@ const struct ovl_layer *ovl_layer_lower(struct dentry *dentry)
 
 /*
  * ovl_dentry_lower() could return either a data dentry or metacopy dentry
- * dependig on what is stored in lowerstack[0]. At times we need to find
+ * depending on what is stored in lowerstack[0]. At times we need to find
  * lower dentry which has data (and not metacopy dentry). This helper
  * returns the lower data dentry.
  */
-- 
2.25.1

