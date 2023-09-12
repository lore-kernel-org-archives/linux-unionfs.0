Return-Path: <linux-unionfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9B2AFCA0ECA
	for <linux-unionfs@archiver.kernel.org>; Tue, 12 Sep 2023 09:56:48 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232917AbjILJ4v (ORCPT
        <rfc822;linux-unionfs@archiver.kernel.org>);
        Tue, 12 Sep 2023 05:56:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33098 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233057AbjILJ4v (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Tue, 12 Sep 2023 05:56:51 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id CCF7310CE
        for <linux-unionfs@vger.kernel.org>; Tue, 12 Sep 2023 02:56:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1694512568;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=BepCjTyKDBuMfPiRMkPfRUY6SOX6/lnxY5feg8LzzpI=;
        b=iIhHoI72wcSEwxI6dHLc8UD2Iftn+J/AyWBYRg9gpCwLssfohrnOfqEKIwTbONXvB0gRlX
        /U9gcShmCBtGZxV+4XgNKvHEcIHToxydAryGA2bTf1pM8/iS5tZO7YxEVgTYbbyaGipinF
        WVO7sjfHqs0W7iyozNlpjpgxxDA8hVA=
Received: from mail-lj1-f200.google.com (mail-lj1-f200.google.com
 [209.85.208.200]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-66-chK4Fw-gPJGMEE62PPd-KA-1; Tue, 12 Sep 2023 05:56:06 -0400
X-MC-Unique: chK4Fw-gPJGMEE62PPd-KA-1
Received: by mail-lj1-f200.google.com with SMTP id 38308e7fff4ca-2bcc1e0dfe5so58912081fa.1
        for <linux-unionfs@vger.kernel.org>; Tue, 12 Sep 2023 02:56:06 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1694512564; x=1695117364;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=BepCjTyKDBuMfPiRMkPfRUY6SOX6/lnxY5feg8LzzpI=;
        b=aty40JaRJvPEwz7DBWpjHH/ffhMKArT2BwUIGfSPiARBFyeUKeAjwbXahNRN3E88Dz
         h8Ui0bjavtbb3KmflVx9BbtprzUPcbGzoxWK0Kykezx54AyS1ZhVNsYd7sUb3bXCuS4L
         loa7e5KkjXpExHIBWEjfaFZftl5S0VC1qEa5xXFf+NvOBaj4X0Zs3BJ4UtnpxlwxB3Lv
         eMJNfAGucax/sV7wQZYEfxy+fK02N+ZHTcYItVhz3s+nDek6oioVen99qLtY0cjQH+4a
         HD3zr+wgD5h9HBg6HlrVupThfGuctICDWJjjyGEuqM9slWHuzHnEwH1KK/0+NnGniGMS
         KzKA==
X-Gm-Message-State: AOJu0Yza0DOtiEgiH/MoifUko0ZeLq8Z8JoxWrEbG1y90Bpvm8NpPD0Z
        I5Jfi4l1RGMYRc0Kqgo2l3RZA1B7fWk8GTo374IYJW6kUqD9aAHVQR72JwCHSi1RYB8v71d6L9s
        jtPSzov/LMHyhAgtwV9INJjhGtoXgHZ+WVw==
X-Received: by 2002:ac2:53ad:0:b0:500:7de4:300e with SMTP id j13-20020ac253ad000000b005007de4300emr8547444lfh.58.1694512564682;
        Tue, 12 Sep 2023 02:56:04 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IGYO1d6qdo5HHdDsRsukEZKdUAtI/al9ChHiXJIkacXGrO2LEPpJvaJn0Zei7Ycs/GQ+aDHaA==
X-Received: by 2002:ac2:53ad:0:b0:500:7de4:300e with SMTP id j13-20020ac253ad000000b005007de4300emr8547422lfh.58.1694512563713;
        Tue, 12 Sep 2023 02:56:03 -0700 (PDT)
Received: from greebo.redhat.com (c-e6a5e255.022-110-73746f36.bbcust.telenor.se. [85.226.165.230])
        by smtp.googlemail.com with ESMTPSA id t15-20020ac243af000000b004fdba93b92asm1691766lfl.252.2023.09.12.02.56.03
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 12 Sep 2023 02:56:03 -0700 (PDT)
From:   Alexander Larsson <alexl@redhat.com>
To:     miklos@szeredi.hu
Cc:     linux-unionfs@vger.kernel.org, amir73il@gmail.com,
        Alexander Larsson <alexl@redhat.com>
Subject: [PATCH v4 2/5] ovl: Add OVL_XATTR_TRUSTED/USER_PREFIX_LEN macros
Date:   Tue, 12 Sep 2023 11:55:56 +0200
Message-ID: <27e6555e59d4b19e864725313b966d5ce5716e35.1694512044.git.alexl@redhat.com>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <cover.1694512044.git.alexl@redhat.com>
References: <cover.1694512044.git.alexl@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-unionfs.vger.kernel.org>
X-Mailing-List: linux-unionfs@vger.kernel.org

These match the ones for e.g. XATTR_TRUSTED_PREFIX_LEN.

Signed-off-by: Alexander Larsson <alexl@redhat.com>
Reviewed-by: Amir Goldstein <amir73il@gmail.com>
---
 fs/overlayfs/overlayfs.h | 2 ++
 fs/overlayfs/xattrs.c    | 4 ++--
 2 files changed, 4 insertions(+), 2 deletions(-)

diff --git a/fs/overlayfs/overlayfs.h b/fs/overlayfs/overlayfs.h
index 7b2a309bd746..dff7232b7bf5 100644
--- a/fs/overlayfs/overlayfs.h
+++ b/fs/overlayfs/overlayfs.h
@@ -28,7 +28,9 @@ enum ovl_path_type {
 
 #define OVL_XATTR_NAMESPACE "overlay."
 #define OVL_XATTR_TRUSTED_PREFIX XATTR_TRUSTED_PREFIX OVL_XATTR_NAMESPACE
+#define OVL_XATTR_TRUSTED_PREFIX_LEN (sizeof(OVL_XATTR_TRUSTED_PREFIX) - 1)
 #define OVL_XATTR_USER_PREFIX XATTR_USER_PREFIX OVL_XATTR_NAMESPACE
+#define OVL_XATTR_USER_PREFIX_LEN (sizeof(OVL_XATTR_USER_PREFIX) - 1)
 
 enum ovl_xattr {
 	OVL_XATTR_OPAQUE,
diff --git a/fs/overlayfs/xattrs.c b/fs/overlayfs/xattrs.c
index edc7cc49a7c4..b8ea96606ea8 100644
--- a/fs/overlayfs/xattrs.c
+++ b/fs/overlayfs/xattrs.c
@@ -10,10 +10,10 @@ bool ovl_is_private_xattr(struct super_block *sb, const char *name)
 
 	if (ofs->config.userxattr)
 		return strncmp(name, OVL_XATTR_USER_PREFIX,
-			       sizeof(OVL_XATTR_USER_PREFIX) - 1) == 0;
+			       OVL_XATTR_USER_PREFIX_LEN) == 0;
 	else
 		return strncmp(name, OVL_XATTR_TRUSTED_PREFIX,
-			       sizeof(OVL_XATTR_TRUSTED_PREFIX) - 1) == 0;
+			       OVL_XATTR_TRUSTED_PREFIX_LEN) == 0;
 }
 
 static int ovl_xattr_set(struct dentry *dentry, struct inode *inode, const char *name,
-- 
2.41.0

