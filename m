Return-Path: <linux-unionfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 01E05EE3F0A
	for <linux-unionfs@archiver.kernel.org>; Tue, 12 Sep 2023 17:37:04 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231201AbjILRhH (ORCPT
        <rfc822;linux-unionfs@archiver.kernel.org>);
        Tue, 12 Sep 2023 13:37:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60592 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235260AbjILRhH (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Tue, 12 Sep 2023 13:37:07 -0400
Received: from mail-ed1-x533.google.com (mail-ed1-x533.google.com [IPv6:2a00:1450:4864:20::533])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 53D4B10E9
        for <linux-unionfs@vger.kernel.org>; Tue, 12 Sep 2023 10:37:03 -0700 (PDT)
Received: by mail-ed1-x533.google.com with SMTP id 4fb4d7f45d1cf-52a49a42353so7634524a12.2
        for <linux-unionfs@vger.kernel.org>; Tue, 12 Sep 2023 10:37:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1694540222; x=1695145022; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Uan3b0LpHEqkpZBi3mQQLzsP17K0gMOWhF4TTelp5ho=;
        b=ehjwxI/wVFyVcKiAeGPDtdC6bda40AJIsqgssH7nSoH/btZn9++RMQXIsNrRuIY2lL
         WluNnb1Ww5yo3oZE6ODAEBpUhGgm+2oaqIbQRNtQB8NHCC4yE46Y4+Li3NzV9ynJo2pg
         JzankKTodEw+y3L5DXKzTC3GkA8IorcyQ4pxzMRC8gtbcvMIH8xFh9EG2N4RuTIb4dud
         8UwkFR7stLW5Z7qG49bv3hpF/96l6zXnWoE8stvBoq8gyPTBBEhY/c+psJAyNvcx1flQ
         QZnRlRTdTwYfYhtukA8xv20F9TOn6FFo/NkXoXCk+NpzpnLy0JC9VWcU+coS+aFeATS4
         RBAw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1694540222; x=1695145022;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=Uan3b0LpHEqkpZBi3mQQLzsP17K0gMOWhF4TTelp5ho=;
        b=jXOh00MkpTHJoaLIaE1qPE7z9mEvkAzSWUmurZStjawipJffawHvD/BM0DRjmdEBNt
         N2f1UMjwkxmNZtL8Mi0lN2FC5D4DFlPra2aXimfWvxqgo4atDxVUmJeFUsnDDeRTDj13
         jLP6yXoLnabpnS08dZQ2mt7sqCshMH8725JCy4NhNvCc6A9J2UNYVkMUYOfwFxmS/5+w
         4zs4JVkPhYKB2kZlvOk3KnL+Knvq+siYBQ+jXgGARTLU6ygFDXd0PLxJ7BXxd4yz+Gcp
         sAvEiE6bv0RrdbshMguZOK+Em72jCKKsqbmXfNQj7LOTPHwoi8hR4VCv6KWud4S6ASH6
         50kA==
X-Gm-Message-State: AOJu0YzwgbWp7k1xelvk+Df5YnuNM1f3JR3knRTQTm8Z6G6U1M0lzlu1
        NcTNqcD2eQkoeWppF1dpggk=
X-Google-Smtp-Source: AGHT+IGu1e+s4pXDQkXxhKXMb9nbVySXCeI9XdsUH8o9ywcYMxy2g/1A9q6aIlAtoIf0usK8xtdgFQ==
X-Received: by 2002:a17:907:7758:b0:9a2:143e:a061 with SMTP id kx24-20020a170907775800b009a2143ea061mr7214ejc.28.1694540221791;
        Tue, 12 Sep 2023 10:37:01 -0700 (PDT)
Received: from amir-ThinkPad-T480.lan ([5.29.249.86])
        by smtp.gmail.com with ESMTPSA id s3-20020a170906060300b0099ce188be7fsm7115978ejb.3.2023.09.12.10.37.00
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 12 Sep 2023 10:37:01 -0700 (PDT)
From:   Amir Goldstein <amir73il@gmail.com>
To:     Miklos Szeredi <miklos@szeredi.hu>
Cc:     linux-unionfs@vger.kernel.org
Subject: [PATCH 3/4] ovl: propagate IOCB_APPEND flag on writes to realfile
Date:   Tue, 12 Sep 2023 20:36:52 +0300
Message-Id: <20230912173653.3317828-4-amir73il@gmail.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20230912173653.3317828-1-amir73il@gmail.com>
References: <20230912173653.3317828-1-amir73il@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-unionfs.vger.kernel.org>
X-Mailing-List: linux-unionfs@vger.kernel.org

If ovl file is opened O_APPEND, the underlying realfile is also
opened O_APPEND, so it makes sense to propagate the IOCB_APPEND flags
on sync writes to realfile, just as we do with aio writes.

Effectively, because sync ovl writes are protected by inode lock,
this change only makes a difference if the realfile is written to (size
extending writes) from underneath overlayfs.  The behavior in this case
is undefined, so it is ok if we change the behavior (to fail the ovl
IOCB_APPEND write).

Signed-off-by: Amir Goldstein <amir73il@gmail.com>
---
 fs/overlayfs/file.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/overlayfs/file.c b/fs/overlayfs/file.c
index 98f0dedffc0f..ffebffa710b5 100644
--- a/fs/overlayfs/file.c
+++ b/fs/overlayfs/file.c
@@ -263,7 +263,7 @@ static void ovl_file_accessed(struct file *file)
 }
 
 #define OVL_IOCB_MASK \
-	(IOCB_NOWAIT | IOCB_HIPRI | IOCB_DSYNC | IOCB_SYNC)
+	(IOCB_NOWAIT | IOCB_HIPRI | IOCB_DSYNC | IOCB_SYNC | IOCB_APPEND)
 
 static rwf_t iocb_to_rw_flags(int flags)
 {
-- 
2.34.1

