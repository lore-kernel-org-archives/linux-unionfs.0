Return-Path: <linux-unionfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B6274C7EE2E
	for <linux-unionfs@archiver.kernel.org>; Mon, 12 Jun 2023 10:44:09 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232321AbjFLKoH (ORCPT
        <rfc822;linux-unionfs@archiver.kernel.org>);
        Mon, 12 Jun 2023 06:44:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48022 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234830AbjFLKnv (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Mon, 12 Jun 2023 06:43:51 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 708CAA87A
        for <linux-unionfs@vger.kernel.org>; Mon, 12 Jun 2023 03:27:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1686565657;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=MOlfdaPnMmUP9g7vcnNIn0Q1D7Ns0mSoof416/Dem7s=;
        b=J3sdl6aRPpDSr9LoIH2nAy/sGwf7T40sG8KDIsiFrJj0zWRjGbsCeen93z7VmrHWO61T/z
        VqXJ8yH8tOHmcb7YjrmPLKZskcouVtAnOyligEMe4c87RVhj/p1rF0hroU5BrjKFjlq1NF
        OtICn0JW6hmhzKhNr8IxTQeMz1reUuQ=
Received: from mail-lf1-f72.google.com (mail-lf1-f72.google.com
 [209.85.167.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-211-aak52lFBNTmqvFW0qNVt4g-1; Mon, 12 Jun 2023 06:27:36 -0400
X-MC-Unique: aak52lFBNTmqvFW0qNVt4g-1
Received: by mail-lf1-f72.google.com with SMTP id 2adb3069b0e04-4f61f59c230so2807889e87.2
        for <linux-unionfs@vger.kernel.org>; Mon, 12 Jun 2023 03:27:36 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1686565655; x=1689157655;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=MOlfdaPnMmUP9g7vcnNIn0Q1D7Ns0mSoof416/Dem7s=;
        b=WkP5IaGLWscc+O4PXvSMMJwVCc+cuWCQg4YlHDbLHd3K6UL706xQLKj6l6rbITbtKe
         E/S2iyqONq4luXuULd5+g7hA4/luxdI0uGCAOF93gnelFU72sKBD2ojhmvhQ7xPQlW6R
         qrrk/+p6qd5mzkecAzis3vEGCgjT0PQRtkVC4wSZXBJwsG6MdHAHDcHqd60Hngj4k6JB
         Vj2FBkimV7qB2yysaUGyn5mLHpowpGh7eu32Sg8t69pWelNJdbK7ZfV+JRsnvo6bxfQm
         bhz/ZmQZHomMS23bfBomF0rQHGIvup+Rj5ckEqUWNSEFVmUk2uoJFs7d28ydEEIPrZxu
         VBhA==
X-Gm-Message-State: AC+VfDxfCO58+/uh7HKYVpt4n+A3neqztdczeh21sPSnI9mACmlW6ZCJ
        bbQ1EQ8WKH0Kl9u+2Gbo6sWNCvkbope/vQLJfN8IEKJ/NWt8WUmTSbyB1LSAtZjSIVv3U7AIGFj
        2TxWTBo54mPv3QSwpyTloiGVGQA==
X-Received: by 2002:a2e:7202:0:b0:2b2:10e2:af0a with SMTP id n2-20020a2e7202000000b002b210e2af0amr2396405ljc.33.1686565654818;
        Mon, 12 Jun 2023 03:27:34 -0700 (PDT)
X-Google-Smtp-Source: ACHHUZ6Tlb2tgmCHslDPEzeAtOL6Icrk3GS4shFBMdzO/O//Sb0hXSor67hV+FKKKU9/Vvd1R6p5OQ==
X-Received: by 2002:a2e:7202:0:b0:2b2:10e2:af0a with SMTP id n2-20020a2e7202000000b002b210e2af0amr2396391ljc.33.1686565654453;
        Mon, 12 Jun 2023 03:27:34 -0700 (PDT)
Received: from localhost.localdomain (c-e6a5e255.022-110-73746f36.bbcust.telenor.se. [85.226.165.230])
        by smtp.googlemail.com with ESMTPSA id m25-20020a2e8719000000b002b1fc6e70a1sm1709095lji.21.2023.06.12.03.27.33
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 12 Jun 2023 03:27:34 -0700 (PDT)
From:   Alexander Larsson <alexl@redhat.com>
To:     miklos@szeredi.hu
Cc:     linux-unionfs@vger.kernel.org, amir73il@gmail.com,
        ebiggers@kernel.org, tytso@mit.edu, fsverity@lists.linux.dev,
        Alexander Larsson <alexl@redhat.com>
Subject: [PATCH v3 1/4] fsverity: Export fsverity_get_digest
Date:   Mon, 12 Jun 2023 12:27:16 +0200
Message-Id: <ead88201cfbf072f429a9db24fd7e4a86ea38e99.1686565330.git.alexl@redhat.com>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <cover.1686565330.git.alexl@redhat.com>
References: <cover.1686565330.git.alexl@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-unionfs.vger.kernel.org>
X-Mailing-List: linux-unionfs@vger.kernel.org

Overlayfs needs to call this when built in module form, so
we need to export the symbol. This uses EXPORT_SYMBOL_GPL
like the other fsverity functions do.

Signed-off-by: Alexander Larsson <alexl@redhat.com>
---
 fs/verity/measure.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/fs/verity/measure.c b/fs/verity/measure.c
index 5c79ea1b2468..875d143e0c7e 100644
--- a/fs/verity/measure.c
+++ b/fs/verity/measure.c
@@ -85,3 +85,4 @@ int fsverity_get_digest(struct inode *inode,
 	*alg = hash_alg->algo_id;
 	return 0;
 }
+EXPORT_SYMBOL_GPL(fsverity_get_digest);
-- 
2.40.1

