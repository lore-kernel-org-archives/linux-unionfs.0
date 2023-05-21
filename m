Return-Path: <linux-unionfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2156EC77B7C
	for <linux-unionfs@archiver.kernel.org>; Sun, 21 May 2023 08:31:31 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229481AbjEUIb3 (ORCPT
        <rfc822;linux-unionfs@archiver.kernel.org>);
        Sun, 21 May 2023 04:31:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49210 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230095AbjEUI2Z (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Sun, 21 May 2023 04:28:25 -0400
Received: from smtp-relay-internal-1.canonical.com (smtp-relay-internal-1.canonical.com [185.125.188.123])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F359B18D
        for <linux-unionfs@vger.kernel.org>; Sun, 21 May 2023 01:28:23 -0700 (PDT)
Received: from mail-ed1-f71.google.com (mail-ed1-f71.google.com [209.85.208.71])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (No client certificate requested)
        by smtp-relay-internal-1.canonical.com (Postfix) with ESMTPS id D9FFE3F11A
        for <linux-unionfs@vger.kernel.org>; Sun, 21 May 2023 08:28:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=canonical.com;
        s=20210705; t=1684657701;
        bh=JDxwondAh/OUHugni3ivKWRUI1pwMRnCsBuB/co2xpE=;
        h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
         MIME-Version;
        b=tzO+lGm3EmaDmI2T9uQaihMGZ1HWlcavGFIOBCKkue/IoMM27TvtI88Yw4deFMmBX
         bQZw6crI96a7MgemCX6gLeWveU6FZIXfy8kXI/GM1Uk8Zd26axHQnHDwdGrUS/Y2j3
         dVKYGjmzo1UuWk3w3/4jyCD5v7gMRiValKV3Kk6+KmUNvq1NVJ2JAD0lcHnyvnZlCC
         w1i6ktxizM1QJIS4jMfgc1h3V6oKW0IW1EkPMZ0lSvay3kBNOqm85rztHjgL6H00kd
         iN3kgn7NDbuNwsh91y1Toz5lpMLlKWJM3K+ii7yQyrEtZlre1Tbt6kRtAWw7BMyiMu
         gqlunG9dr9dsw==
Received: by mail-ed1-f71.google.com with SMTP id 4fb4d7f45d1cf-510b714821fso3139023a12.1
        for <linux-unionfs@vger.kernel.org>; Sun, 21 May 2023 01:28:21 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1684657698; x=1687249698;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=JDxwondAh/OUHugni3ivKWRUI1pwMRnCsBuB/co2xpE=;
        b=aGVCYkYq1jIH2AA8RXItPeNIcFgckGqfKxyXU4ZGuLpt1hPbKc7SPxZSoyJxFNnOLz
         ERIo32eo468KviDfTVYYpMm0uIMUKiKPHkj5176fu+a1Ubpy+q45ZZS2VRQEDtMJtuEv
         wdhIkPZHAXRd0DNFee6vwu5pvmWoeSUN6Nc87mWEigHkMjo4TlJcQOznX58IVHhrDHxV
         oTi2QWDdEU3cbNKBZ8UB9ZukMzaUHpM585P7q82d8GSx/vW9SyXvmGY4VriGwZ868KiF
         L+D2QDIn8PI4XlvILA6c3EnF5DKg+6rNFsF9U7ZTXBYA3QeucZrNKTMS51Jq+bLW4pP8
         fEFw==
X-Gm-Message-State: AC+VfDw508znh/R3eXRlZnp44QxnIRnj0Xea5KAMkfbdgiU1kOpHXUTI
        OsKrZET/gTLDU4CXkM7qD8hzA7TuVvPcqFuToSO6QB+p3VXmXlU444FXdlrbt3vTpnIha6C7pPv
        LpdwRVvTxgZzxMJEWqpADMyE3fl+6OGhYN6VPyJjNXh8=
X-Received: by 2002:a50:ed09:0:b0:50c:161b:9154 with SMTP id j9-20020a50ed09000000b0050c161b9154mr6988437eds.11.1684657698395;
        Sun, 21 May 2023 01:28:18 -0700 (PDT)
X-Google-Smtp-Source: ACHHUZ6ZOrhcJoW7hdR/JwsluZvVPpD3I9c6Xd7IgooNQQzahawcWHebG+MovffeT+18V5hGxmKYpQ==
X-Received: by 2002:a50:ed09:0:b0:50c:161b:9154 with SMTP id j9-20020a50ed09000000b0050c161b9154mr6988428eds.11.1684657698143;
        Sun, 21 May 2023 01:28:18 -0700 (PDT)
Received: from righiandr-XPS-13-7390.homenet.telecomitalia.it (host-87-10-127-160.retail.telecomitalia.it. [87.10.127.160])
        by smtp.gmail.com with ESMTPSA id z17-20020aa7cf91000000b004c2158e87e6sm1656646edx.97.2023.05.21.01.28.17
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 21 May 2023 01:28:17 -0700 (PDT)
From:   Andrea Righi <andrea.righi@canonical.com>
To:     Miklos Szeredi <miklos@szeredi.hu>
Cc:     Amir Goldstein <amir73il@gmail.com>, linux-unionfs@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH v3 3/3] ovl: validate superblock in OVL_FS()
Date:   Sun, 21 May 2023 10:28:13 +0200
Message-Id: <20230521082813.17025-4-andrea.righi@canonical.com>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230521082813.17025-1-andrea.righi@canonical.com>
References: <20230521082813.17025-1-andrea.righi@canonical.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-unionfs.vger.kernel.org>
X-Mailing-List: linux-unionfs@vger.kernel.org

When CONFIG_OVERLAY_FS_DEBUG is enabled add an explicit check to make
sure that OVL_FS() is always used with a valid overlayfs superblock.
Otherwise trigger a WARN_ON_ONCE().

Reviewed-by: Amir Goldstein <amir73il@gmail.com>
Signed-off-by: Andrea Righi <andrea.righi@canonical.com>
---
 fs/overlayfs/ovl_entry.h | 12 ++++++++++++
 1 file changed, 12 insertions(+)

diff --git a/fs/overlayfs/ovl_entry.h b/fs/overlayfs/ovl_entry.h
index b32c38fdf3c7..e156649d9c71 100644
--- a/fs/overlayfs/ovl_entry.h
+++ b/fs/overlayfs/ovl_entry.h
@@ -97,8 +97,20 @@ static inline struct mnt_idmap *ovl_upper_mnt_idmap(struct ovl_fs *ofs)
 
 extern struct file_system_type ovl_fs_type;
 
+static inline bool is_ovl_fs_sb(struct super_block *sb)
+{
+	return sb->s_type == &ovl_fs_type;
+}
+
+#ifdef CONFIG_OVERLAY_FS_DEBUG
+#define OVL_VALIDATE_SB(__sb)	WARN_ON_ONCE(!is_ovl_fs_sb(__sb))
+#else
+#define OVL_VALIDATE_SB(__sb)
+#endif
+
 static inline struct ovl_fs *OVL_FS(struct super_block *sb)
 {
+	OVL_VALIDATE_SB(sb);
 	return (struct ovl_fs *)sb->s_fs_info;
 }
 
-- 
2.39.2

