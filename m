Return-Path: <linux-unionfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0D9D1CE7A81
	for <linux-unionfs@archiver.kernel.org>; Mon, 25 Sep 2023 06:23:36 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232174AbjIYGXk (ORCPT
        <rfc822;linux-unionfs@archiver.kernel.org>);
        Mon, 25 Sep 2023 02:23:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50084 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232177AbjIYGX2 (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Mon, 25 Sep 2023 02:23:28 -0400
Received: from mail-wm1-x32a.google.com (mail-wm1-x32a.google.com [IPv6:2a00:1450:4864:20::32a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 191D026A1
        for <linux-unionfs@vger.kernel.org>; Sun, 24 Sep 2023 23:21:39 -0700 (PDT)
Received: by mail-wm1-x32a.google.com with SMTP id 5b1f17b1804b1-40471c054f9so18560655e9.0
        for <linux-unionfs@vger.kernel.org>; Sun, 24 Sep 2023 23:21:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1695622897; x=1696227697; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:subject:from:to:content-language
         :user-agent:mime-version:date:message-id:from:to:cc:subject:date
         :message-id:reply-to;
        bh=lGoflC/MDGiByLKpoE4UCpKhG9wCXgC3jrpF9mnawmc=;
        b=ECMthtLkjF0hBBM6O/lZvvlfnDcHj5vR4Lxe+D45C7tZDbaykHERGtOEudoribQwOl
         Fte35//cCpWckzrS07O64yvry6jMO7VfOKtLeD/nXLDiv4Ysfkf+H89g1LNrj1z+yqOT
         2I18D6Y96LGQEkTX0YHq8CBhSFjxCwXQXdq3HR3fjFYO2ESM8TMMf2E8WFwpGpGwdPup
         XZLZmKwIZdtOhxGa5aszprHKFkSXUEiPr/yUWolFA3Ywh6qOHjxnGhu8WpG7cMtjaH2c
         2AkCOgUwfisfgx/0KcsWXaeaUjfgFWCRkxWW6LnHiDTfwMkT8kuRNTF18tyYP5NqQBI2
         LJzA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1695622897; x=1696227697;
        h=content-transfer-encoding:cc:subject:from:to:content-language
         :user-agent:mime-version:date:message-id:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=lGoflC/MDGiByLKpoE4UCpKhG9wCXgC3jrpF9mnawmc=;
        b=R5qKA0l4FNEviPajOWK2M5vXbontGeppg1llhMtnwP9h4FYO/4ojFvVdZZ3RIjIlkm
         6ulQXtqC5sdtFIP9Qwydsz6YVhtu7rWjr57T3GjfE1tmSU2Vp4Gj5tizWUQKF/HhNs54
         XWU86TeJFdainADZXiawxpKkv9Kf+zC7CoWvqwC4EOm12QuODva1jSz7TyO2vym5mfTk
         gCiWvWgUM2kg4YP6MIARyf7OQuLX5joK8g030VR8ZsPTcylVoZEJ6z6BDJWFk8/RJorP
         xwDAepuix/ZyLOy62mG2bJ0HLmi9uJbpbS4eTkwT8jLHC+6afkP9QGc9MG7VplvyvZLg
         xsrA==
X-Gm-Message-State: AOJu0YyhW2MAMCJnzuA50uaAuA4w+ZatLoUwma/ma9yw4j1vqZI+KPNi
        agBIDR5PJrf4wHYNaMDRmFaPNg==
X-Google-Smtp-Source: AGHT+IHHKt7P8p/soHCBdqvFETlHa38Td/2/3ju/wDTL8KeMQizTMtjs/G1nKdI1QABkE1BOVrDTEw==
X-Received: by 2002:a05:600c:4e05:b0:405:3cc1:e115 with SMTP id b5-20020a05600c4e0500b004053cc1e115mr5041954wmq.3.1695622896458;
        Sun, 24 Sep 2023 23:21:36 -0700 (PDT)
Received: from [172.20.13.88] ([45.147.210.162])
        by smtp.gmail.com with ESMTPSA id u23-20020a05600c211700b004042dbb8925sm14054942wml.38.2023.09.24.23.21.35
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 24 Sep 2023 23:21:35 -0700 (PDT)
Message-ID: <71897125-e570-46ce-946a-d4729725e28f@kernel.dk>
Date:   Mon, 25 Sep 2023 00:21:35 -0600
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Content-Language: en-US
To:     Amir Goldstein <amir73il@gmail.com>,
        LKML <linux-kernel@vger.kernel.org>,
        linux-unionfs@vger.kernel.org
From:   Jens Axboe <axboe@kernel.dk>
Subject: [PATCH] ovl: disable IOCB_DIO_CALLER_COMP
Cc:     Zorro Lang <zlang@redhat.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-unionfs.vger.kernel.org>
X-Mailing-List: linux-unionfs@vger.kernel.org

overlayfs copies the kiocb flags when it sets up a new kiocb to handle
a write, but it doesn't properly support dealing with the deferred
caller completions of the kiocb. This means it doesn't get the final
write completion value, and hence will complete the write with '0' as
the result.

We could support the caller completions in overlayfs, but for now let's
just disable them in the generated write kiocb.

Reported-by: Zorro Lang <zlang@redhat.com>
Link: https://lore.kernel.org/io-uring/20230924142754.ejwsjen5pvyc32l4@dell-per750-06-vm-08.rhts.eng.pek2.redhat.com/
Fixes: 8c052fb3002e ("iomap: support IOCB_DIO_CALLER_COMP")
Signed-off-by: Jens Axboe <axboe@kernel.dk>

---

diff --git a/fs/overlayfs/file.c b/fs/overlayfs/file.c
index 4193633c4c7a..693971d20280 100644
--- a/fs/overlayfs/file.c
+++ b/fs/overlayfs/file.c
@@ -391,6 +391,12 @@ static ssize_t ovl_write_iter(struct kiocb *iocb, struct iov_iter *iter)
 	if (!ovl_should_sync(OVL_FS(inode->i_sb)))
 		ifl &= ~(IOCB_DSYNC | IOCB_SYNC);
 
+	/*
+	 * Overlayfs doesn't support deferred completions, don't copy
+	 * this property in case it is set by the issuer.
+	 */
+	ifl &= ~IOCB_DIO_CALLER_COMP;
+
 	old_cred = ovl_override_creds(file_inode(file)->i_sb);
 	if (is_sync_kiocb(iocb)) {
 		file_start_write(real.file);

-- 
Jens Axboe

	
