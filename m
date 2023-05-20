Return-Path: <linux-unionfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D1DAEC7EE23
	for <linux-unionfs@archiver.kernel.org>; Sat, 20 May 2023 18:41:25 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231450AbjETSlX (ORCPT
        <rfc822;linux-unionfs@archiver.kernel.org>);
        Sat, 20 May 2023 14:41:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60840 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231639AbjETSlW (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Sat, 20 May 2023 14:41:22 -0400
Received: from smtp-relay-internal-0.canonical.com (smtp-relay-internal-0.canonical.com [185.125.188.122])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 41B109C
        for <linux-unionfs@vger.kernel.org>; Sat, 20 May 2023 11:41:21 -0700 (PDT)
Received: from mail-ed1-f70.google.com (mail-ed1-f70.google.com [209.85.208.70])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (No client certificate requested)
        by smtp-relay-internal-0.canonical.com (Postfix) with ESMTPS id 074803F443
        for <linux-unionfs@vger.kernel.org>; Sat, 20 May 2023 18:41:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=canonical.com;
        s=20210705; t=1684608079;
        bh=7AI0vj2c5KjlogOZSOLiFXVCyd1H7zjU9pr3GTen1KY=;
        h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
         MIME-Version;
        b=lfhPTABWXMm0M9QNxz+/HOYxEo1u4P33YiDMYkDXS0l97vSvEl47OQy9++FwNGMar
         Io+vcxclfmPPHirbNN9diyZ6aDmHrfhPv5or27s9ZnRSRNDOjQ1iA9weoXgvsQdixq
         h/xs8bUAoNYfgp/A5r+YiU7IkVehQ4vk91r11z9hNqUP1yh8yJhmm2+LmxhKktbQE6
         YV0OZW6wOO/xtU67J36w7rAQgDJMzrS2iFA9p4T1G1GEKHzaqc/5efsWGfwPCkR2PD
         suVGHU7mmg+C9/0qOSdokP8PCfQD1LgDLTNQ8dlz+6WBbuz6Uj5/Jqw6ZE9VLjQeOE
         3mpgOkRmpOXzg==
Received: by mail-ed1-f70.google.com with SMTP id 4fb4d7f45d1cf-511b509b55bso1798659a12.0
        for <linux-unionfs@vger.kernel.org>; Sat, 20 May 2023 11:41:19 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1684608078; x=1687200078;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=7AI0vj2c5KjlogOZSOLiFXVCyd1H7zjU9pr3GTen1KY=;
        b=XdkyYkqhUlel+1+Zeqes42t4eFvY9t4ulXD2zc27iOy1uk74Js/F+gBSq/1b6HsqY6
         8pqpQdqeu1ep5NldFeqZZMkKPh9zj1+v+y4bmad/+9kzongIHANogtJriu/yEUrLwoON
         cV733uhRdPnDMpbLIxIXEhHlKSRZSc/f/9lXi6VK5ZArJuiqmisBHVfyw2oI0l9TXPoN
         kuhuvuHxG6/OMcEKUVSLH2s5yEed/5T+AoKoV79MO6W5rq51B73XCQfXq8xNWY93ZqZ1
         olPw0yCK5X1cuT00b6vzueBKqy2HlQcmvuDLLh4tgWUyKhI/KHJkm9Uqj+R60AUK3JJG
         dtSw==
X-Gm-Message-State: AC+VfDzqefWxH9/HMrD1X9YpzcRRh9h59mJxUs0BbAlhzBP+pxWjsfd5
        m8hJKqaFR4j/sccRH+vIC7h2oiijLW5ALaSUaKLbpRLHHQzF/99AljTIMfkbfQEGYmbl988zxIa
        WBdChg9HKY4Hz7nviGB00L1p7aZzcW8KPg7z+SywZmwo=
X-Received: by 2002:a17:907:628f:b0:961:b0:3dfd with SMTP id nd15-20020a170907628f00b0096100b03dfdmr5768125ejc.7.1684608078662;
        Sat, 20 May 2023 11:41:18 -0700 (PDT)
X-Google-Smtp-Source: ACHHUZ7bU8KiThmUSU1gkKkVsLgEdjohmQGXC442Dp0W428jbmv6EizvNqpf3UWtdJVTxqXZWABedg==
X-Received: by 2002:a17:907:628f:b0:961:b0:3dfd with SMTP id nd15-20020a170907628f00b0096100b03dfdmr5768105ejc.7.1684608078291;
        Sat, 20 May 2023 11:41:18 -0700 (PDT)
Received: from righiandr-XPS-13-7390.homenet.telecomitalia.it (host-87-10-127-160.retail.telecomitalia.it. [87.10.127.160])
        by smtp.gmail.com with ESMTPSA id x6-20020a1709065ac600b009663115c8f8sm1046294ejs.152.2023.05.20.11.41.17
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 20 May 2023 11:41:18 -0700 (PDT)
From:   Andrea Righi <andrea.righi@canonical.com>
To:     Miklos Szeredi <miklos@szeredi.hu>
Cc:     Amir Goldstein <amir73il@gmail.com>, linux-unionfs@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH v2 1/2] ovl: Kconfig: introduce CONFIG_OVERLAY_FS_DEBUG
Date:   Sat, 20 May 2023 20:41:13 +0200
Message-Id: <20230520184114.77725-2-andrea.righi@canonical.com>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230520184114.77725-1-andrea.righi@canonical.com>
References: <20230520184114.77725-1-andrea.righi@canonical.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-unionfs.vger.kernel.org>
X-Mailing-List: linux-unionfs@vger.kernel.org

Provide a Kconfig option to enable extra debugging checks for overlayfs.

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

