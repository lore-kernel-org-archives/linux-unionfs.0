Return-Path: <linux-unionfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 04378C77B73
	for <linux-unionfs@archiver.kernel.org>; Wed, 24 May 2023 18:27:46 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237204AbjEXS1p (ORCPT
        <rfc822;linux-unionfs@archiver.kernel.org>);
        Wed, 24 May 2023 14:27:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55678 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236268AbjEXS1o (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Wed, 24 May 2023 14:27:44 -0400
Received: from mail-wm1-x336.google.com (mail-wm1-x336.google.com [IPv6:2a00:1450:4864:20::336])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1F460B6;
        Wed, 24 May 2023 11:27:43 -0700 (PDT)
Received: by mail-wm1-x336.google.com with SMTP id 5b1f17b1804b1-3f607059b4eso11165405e9.0;
        Wed, 24 May 2023 11:27:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1684952861; x=1687544861;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=pHXQkVB90UDj9V2HKd5/QPYiL1p0MQajhxW4cDsU6zw=;
        b=RJU5wRG18um80lmUGvAi8hzorJVUI+bexS44JVYyX3gabTA4/d+cc8vW6vsYKJ7SOQ
         vYjFHLPknu9IStN4hMMrIG9bxP41F99voFbkVIrCwZQNFOehe2k2Ga1i9bxIbHQ1vgKq
         s47MM7fnpmGIRXVYTTEOssNSJ30+dNHQOParAs1Tm3PGjjAUVFC/23Clq2kU5wm1xWpG
         2/D8Ck3yKNGGcKho5sT2V8Sd354cek9TZX9XOgXDbc+UMHtsQAnHO/1E80ijqgtlukYY
         1JWOaOyUD8EFFt/0pms/BGtaR/oIIDfoVBs1oSFTRYIcUkzlFbEKlpOuBn+jBmbG2L0t
         n/GQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1684952861; x=1687544861;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=pHXQkVB90UDj9V2HKd5/QPYiL1p0MQajhxW4cDsU6zw=;
        b=Fo2l7HFLU5hNdzeQ03PPBEAszuDGf4YHCy33bkc5Kw3KKKzLlVqXsiwdGBaXUIdSaV
         W56la8MMCgxahp/s3tEkvTMdQTWTPFbRFw0/nYVQZ/Ebhx3sO0wBKoS2H0b125YMOmSi
         lcND9EnMtEEgoyhnS0ru2MexJZxavxyCnqEkrHQZKXLTMPcKwGWUzWCrYaKDIqRAFn7P
         SWyavsNVZhEjRgLhQyaCD1c0Zeeg9eosWCvl2HAE6NoyIBPzekWDx4TXqYTvsk/QqTdE
         78PdXof4cN9nZZGlOUXYW8cuWZslHLRtWRgC4jcavB3UY/Co5g8CqzaDajUhJPovGWUJ
         Ssrg==
X-Gm-Message-State: AC+VfDxcgCmNAToRrCl2kLCBelpQO3e7SE692ZkX1Y/SGYwYhP3lnbRV
        VMFolud9L2Q2WuvpRrDg1jO9EhnD+/0=
X-Google-Smtp-Source: ACHHUZ7yI2JIt/2FkHZf5VIRmiSh1MdDjrCtgLPUPmh+qzkY9tnaPeOS+/98OxHDLNx5jpMq+/nfvg==
X-Received: by 2002:a05:600c:2195:b0:3f4:28db:f5ff with SMTP id e21-20020a05600c219500b003f428dbf5ffmr404385wme.35.1684952861153;
        Wed, 24 May 2023 11:27:41 -0700 (PDT)
Received: from amir-ThinkPad-T480.lan ([5.29.249.86])
        by smtp.gmail.com with ESMTPSA id m5-20020a7bca45000000b003f42d8dd7ffsm3159862wml.19.2023.05.24.11.27.40
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 24 May 2023 11:27:40 -0700 (PDT)
From:   Amir Goldstein <amir73il@gmail.com>
To:     linux-unionfs@vger.kernel.org
Cc:     fstests@vger.kernel.org, Christian Brauner <brauner@kernel.org>,
        Miklos Szeredi <miklos@szeredi.hu>
Subject: [PATCH] Skip weird open dir tests
Date:   Wed, 24 May 2023 21:27:36 +0300
Message-Id: <20230524182736.953960-1-amir73il@gmail.com>
X-Mailer: git-send-email 2.34.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-unionfs.vger.kernel.org>
X-Mailing-List: linux-unionfs@vger.kernel.org

After kernel commit 43b450632676 ("open: return EINVAL for O_DIRECTORY
 | O_CREAT") the results of this test depends on the tested kernel
version.

This is not an overlayfs specific test, so skip it.

Signed-off-by: Amir Goldstein <amir73il@gmail.com>
---

For whoever is testing overlayfs with fstests/unionmount,
unionmount broke in kernel v6.4-rc.

I pushed this patch to unionmount master branch.
Please update your test setups.

Thanks,
Amir.

 run | 1 -
 1 file changed, 1 deletion(-)

diff --git a/run b/run
index bda6177..3a6efc3 100755
--- a/run
+++ b/run
@@ -256,7 +256,6 @@ tests = [
     "dir-open",
     "dir-weird-open",
     "dir-open-dir",
-    "dir-weird-open-dir",
     "dir-sym1-open",
     "dir-sym1-weird-open",
     "dir-sym2-open",
-- 
2.34.1

