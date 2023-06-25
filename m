Return-Path: <linux-unionfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 769EAC001DC
	for <linux-unionfs@archiver.kernel.org>; Sun, 25 Jun 2023 13:50:48 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229613AbjFYNur (ORCPT
        <rfc822;linux-unionfs@archiver.kernel.org>);
        Sun, 25 Jun 2023 09:50:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41808 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229619AbjFYNup (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Sun, 25 Jun 2023 09:50:45 -0400
Received: from mail-wr1-x435.google.com (mail-wr1-x435.google.com [IPv6:2a00:1450:4864:20::435])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1D498E43;
        Sun, 25 Jun 2023 06:50:44 -0700 (PDT)
Received: by mail-wr1-x435.google.com with SMTP id ffacd0b85a97d-3112f5ab0b1so2024485f8f.0;
        Sun, 25 Jun 2023 06:50:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1687701042; x=1690293042;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=P7VbWMcVfLlMGS294VQBKxs+cceTb60lOKU6u9n6d5M=;
        b=INja7tWaDJF4bTH8g1ETMVbH2hoOfKq69Du3tAasFbWM/8B4Q599VsBsAXD6dAjgmZ
         VCXsEX5JiTway541SQdbg3EaotldI0aBknICrU0WURaqsZ1hMTOgZfbgxquhdFe+2Lur
         VGrStqdeJbNfFgnx/BA6b2WfAzNeGeOyZdbCptZNxHEEE01p4/vKWlA8TMN1aTRxp060
         8FGNSxeiK4A8wLXlaK50WYTaa/M/2t6HgOA/4xZRmuJA0HMO1iu4oFH3ydJt5nnqSPFt
         a9Cy8l7271/8c6FNgBC6NLk4TLWdid7BPlLq/wEUycSplAp7fbMYhJhXqBtaH0HRe26y
         QIBg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1687701042; x=1690293042;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=P7VbWMcVfLlMGS294VQBKxs+cceTb60lOKU6u9n6d5M=;
        b=DsSq5lOeWlC0ciBnxj5RctMKn1TZRl3+QuExdVWxMKf/Xf3nXW5ZKUJJ+I1c++svnl
         Vuy2rk3Y3LhZbctciNBU+ryVdJ1eXscSkUIhK9lEhV/jKVGGqBWX3oh1NplD6LND03pC
         vzSrfmwC9Tg1O6L60Cc+1uoglXgHxqRS1Pob+akHNwx4l6Nll6r9Ag2JkNp5/RUezvhk
         R+quSFI1jqRnY2SZO4u1nkvpQtQcQTX4Bjt+IcZ4i3FNxR0zpOSdMKngUwM8zjV1Ei01
         LJv8wM7tZXdqhsjvMog554bPLBox3By8nUccrt4pMWbR5slVV/MbTEGumMWByIIFreQx
         4OZw==
X-Gm-Message-State: AC+VfDwD18zVNsg4mIipG7mO2usfvM/7sYsFo91H1sGX+5GvqI/tBVDe
        UqzacDdRnIOw487P3M8uE5M=
X-Google-Smtp-Source: ACHHUZ5iI8CTLxPU/CsgLy0G3o6rGvNrcQpSOkh+Z+absLtZKWtZDr43zwitnWx5FxuVWfbZp1AF0g==
X-Received: by 2002:adf:f203:0:b0:311:19df:dac7 with SMTP id p3-20020adff203000000b0031119dfdac7mr18687225wro.28.1687701042562;
        Sun, 25 Jun 2023 06:50:42 -0700 (PDT)
Received: from amir-ThinkPad-T480.lan ([5.29.249.86])
        by smtp.gmail.com with ESMTPSA id b3-20020adff243000000b003112b38fe90sm4667166wrp.79.2023.06.25.06.50.41
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 25 Jun 2023 06:50:42 -0700 (PDT)
From:   Amir Goldstein <amir73il@gmail.com>
To:     Theodore Ts'o <tytso@mit.edu>
Cc:     Eric Biggers <ebiggers@google.com>,
        Alexander Larsson <alexl@redhat.com>,
        Leah Rumancik <leah.rumancik@gmail.com>,
        fstests@vger.kernel.org, linux-unionfs@vger.kernel.org
Subject: [PATCH 3/3] test-appliance: skip overlayfs tests from base fs exclude list
Date:   Sun, 25 Jun 2023 16:50:33 +0300
Message-Id: <20230625135033.3205742-4-amir73il@gmail.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20230625135033.3205742-1-amir73il@gmail.com>
References: <20230625135033.3205742-1-amir73il@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-unionfs.vger.kernel.org>
X-Mailing-List: linux-unionfs@vger.kernel.org

when running overlayfs test with syntax "-c ext4:overlay/small"
skip tests that are listed in the base fs exclude list (ext4/exclude).

Signed-off-by: Amir Goldstein <amir73il@gmail.com>
---
 test-appliance/files/root/runtests.sh | 1 +
 1 file changed, 1 insertion(+)

diff --git a/test-appliance/files/root/runtests.sh b/test-appliance/files/root/runtests.sh
index c4ddb73..4052481 100755
--- a/test-appliance/files/root/runtests.sh
+++ b/test-appliance/files/root/runtests.sh
@@ -544,6 +544,7 @@ do
 	    files=()
 	    for i in "/root/fs/global_exclude" \
 			"/root/fs/$FS/exclude" \
+			"/root/fs/$BASE_FSTYPE/exclude" \
 			"/root/fs/$FS/cfg/$TC.exclude" \
 			"/root/fs/exclude.$XFSTESTS_FLAVOR" ; do
 		test -f "$i" && files+=("$i")
-- 
2.34.1

