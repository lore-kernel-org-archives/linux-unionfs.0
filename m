Return-Path: <linux-unionfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 24951C001B1
	for <linux-unionfs@archiver.kernel.org>; Sun, 25 Jun 2023 13:50:47 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229456AbjFYNup (ORCPT
        <rfc822;linux-unionfs@archiver.kernel.org>);
        Sun, 25 Jun 2023 09:50:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41792 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229480AbjFYNun (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Sun, 25 Jun 2023 09:50:43 -0400
Received: from mail-wr1-x42c.google.com (mail-wr1-x42c.google.com [IPv6:2a00:1450:4864:20::42c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2D31CE44;
        Sun, 25 Jun 2023 06:50:42 -0700 (PDT)
Received: by mail-wr1-x42c.google.com with SMTP id ffacd0b85a97d-313e23d0a28so2111196f8f.3;
        Sun, 25 Jun 2023 06:50:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1687701040; x=1690293040;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=GBM/EWhwMuZ1XRJmi/1V0Z9WYMWNQhMD5ksKEQBVpfY=;
        b=Z4amqywiMvgpG3vNE6U125NRBlqxowHBM8Clph1D/BngSOgqGsc0tiZMgHKmCeP0Iy
         a4v5hNSE7Y1/eLanAAk0hupk14RvY3a266OmeRiVQpO/lBRpksiUTARGH0r7V2NT3CAs
         A/+yvbzGZ1Wq/8peC0GgDajQeR1TKLLa240Dutki+j0+SRgmtkc5hd93Fetb4vIgGooY
         1rWbr/4fYnEyRwFdYRWD0v46qHOI9qrK/Gad3BJPlR9bVMhb0s70QL+xJuo1+taqzfxM
         MLPaM+nrg4oY4Mle/yYS2p0G25623a4UWIc1FzS1zjmjZ0G1XfQ2ktGfLVGz+RArUPEs
         gUIQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1687701040; x=1690293040;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=GBM/EWhwMuZ1XRJmi/1V0Z9WYMWNQhMD5ksKEQBVpfY=;
        b=NXsw3EvTJp2ykndI5oNHgHrEN59rMNsjn/ruBeaq/32DyOIbQKVLZXf2zqX4XntcV6
         3p42k8gRXOTcqwZIbVw4HbOqWsFo8zbYZk/jkZd1DCtjC1N9CX47+u75R3j2MhmClA2O
         LkvhXDPqSGIxFxehfh9qYJFdyHPhUKypzWQEBq+JNO4ZPZUtZI7AhOjWN7REiAncLOcw
         ZsdGlPw4MhDAye2iNVW5IiMKnVo+CmmeAlC5mP3HKfchcvQ9ptRCVS05zBGjScyRg7i2
         JF7HQio/4TW3FifaEBH+kTJZHw5WP3hpPwpbf11d0Ypc5TX7v6An/kCFDRAmJuizg98C
         jZCA==
X-Gm-Message-State: AC+VfDxRq2l59XkmdkXB4ZHTDJmPTKvl8OKJof0My/ynfFs85pV0QkBa
        nW9r4V/yQTxOik/OqhviYNc=
X-Google-Smtp-Source: ACHHUZ6Y89YMOkyJMla3mePKPk8UF65qyn6Y7DBAOI16Sw39REE2qo2BgmDoGkLBd3+zddfKgi53sA==
X-Received: by 2002:a5d:6889:0:b0:30f:ba36:ea41 with SMTP id h9-20020a5d6889000000b0030fba36ea41mr27658468wru.34.1687701040254;
        Sun, 25 Jun 2023 06:50:40 -0700 (PDT)
Received: from amir-ThinkPad-T480.lan ([5.29.249.86])
        by smtp.gmail.com with ESMTPSA id b3-20020adff243000000b003112b38fe90sm4667166wrp.79.2023.06.25.06.50.39
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 25 Jun 2023 06:50:39 -0700 (PDT)
From:   Amir Goldstein <amir73il@gmail.com>
To:     Theodore Ts'o <tytso@mit.edu>
Cc:     Eric Biggers <ebiggers@google.com>,
        Alexander Larsson <alexl@redhat.com>,
        Leah Rumancik <leah.rumancik@gmail.com>,
        fstests@vger.kernel.org, linux-unionfs@vger.kernel.org
Subject: [PATCH 1/3] test-appliance: enable verity for testing overlay over ext4
Date:   Sun, 25 Jun 2023 16:50:31 +0300
Message-Id: <20230625135033.3205742-2-amir73il@gmail.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20230625135033.3205742-1-amir73il@gmail.com>
References: <20230625135033.3205742-1-amir73il@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-unionfs.vger.kernel.org>
X-Mailing-List: linux-unionfs@vger.kernel.org

Add -O verity for ext4 formatted for overlay tests, so that overlay
verity feature could be tested.

Signed-off-by: Amir Goldstein <amir73il@gmail.com>
---
 test-appliance/files/root/fs/overlay/config | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/test-appliance/files/root/fs/overlay/config b/test-appliance/files/root/fs/overlay/config
index 7c50b19..f252a70 100644
--- a/test-appliance/files/root/fs/overlay/config
+++ b/test-appliance/files/root/fs/overlay/config
@@ -55,7 +55,7 @@ function __mkfs()
 
 	case "$BASE_FSTYPE" in
 	    ext4)
-		/sbin/mke2fs -F -q -t ext4 "$dev"
+		/sbin/mke2fs -F -q -t ext4 -O verity "$dev"
 		;;
 	    xfs)
 		mkfs.xfs -f -m rmapbt=1,reflink=1 "$dev"
-- 
2.34.1

