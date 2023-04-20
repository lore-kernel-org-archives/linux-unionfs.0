Return-Path: <linux-unionfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4C9F7C77B72
	for <linux-unionfs@archiver.kernel.org>; Thu, 20 Apr 2023 07:45:21 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234122AbjDTHpU (ORCPT
        <rfc822;linux-unionfs@archiver.kernel.org>);
        Thu, 20 Apr 2023 03:45:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51346 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234018AbjDTHpR (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Thu, 20 Apr 2023 03:45:17 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AFF784681
        for <linux-unionfs@vger.kernel.org>; Thu, 20 Apr 2023 00:44:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1681976670;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=w0VxTZdYvYJJpJt4f1CWhQCMN6thwfx97+dJKO1TgUg=;
        b=AUUcGfg23YDFpyFSEkdM4sQRCNqcfoW9zR6c9DxmyaMFgI3TLePTytrAWnvne8cwFXZwDf
        MBgdAylb0ceqN1i/hxl/did0SnhmRJ3unr4PE4gYN5EuxybNg2Ezmyx1muRF7sVS3S0zjJ
        4uiO0ehGuchquvA5FQfMbD46XoJvIHg=
Received: from mail-lf1-f70.google.com (mail-lf1-f70.google.com
 [209.85.167.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-358-8LEYsxj7OESQZ_QizWr-Tw-1; Thu, 20 Apr 2023 03:44:29 -0400
X-MC-Unique: 8LEYsxj7OESQZ_QizWr-Tw-1
Received: by mail-lf1-f70.google.com with SMTP id 2adb3069b0e04-4edd608fa5cso195226e87.3
        for <linux-unionfs@vger.kernel.org>; Thu, 20 Apr 2023 00:44:29 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1681976668; x=1684568668;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=w0VxTZdYvYJJpJt4f1CWhQCMN6thwfx97+dJKO1TgUg=;
        b=lt1eUwgiU5DsEzqM8gSxOqYYdLVlmrfY0N0aDj6QJwL8DmEgq6XuJ0AOAv/QmkrG3A
         J6/YfwrCPsRECxAVWb/yMlAUAZj+mVSCgmvcJoX2//JYFQ3MvZp/69r26VEdT3ZGp6Pa
         v+DydDwQAubBgyzYFyvfRPKVpZ07yq1/h0R2W6Der6cwnMFVhVH3FmHjqch+KrzIkg5K
         XROMD+8hK10PB62nEGAn+f1Ntdh3u4akZnj1oY9xC7Yyp7I5p6vy66ND4TiwtSnC/UBl
         HwGZyejAddzofxPCT9z3dCrdzjeGIS0Vwbzm0H+8cxxXPQe0ByoDmCFcUQK001WjWuq9
         KF/A==
X-Gm-Message-State: AAQBX9evuSHKChyZdtezIZX3z2+uOOw/0dHIFaRXn5dPXZUoCKKVp/sB
        w4OVxmxvjA06lP6hW0gWMQ/IKwZ0294e1Y9W58TTC7lASMuRWV/T/elbz93ds+6wGhmn5xAWTaq
        VGs2olliL2Bdn8wEjMEWv/DEYvQ==
X-Received: by 2002:a19:ac0d:0:b0:4e9:59cd:416c with SMTP id g13-20020a19ac0d000000b004e959cd416cmr167071lfc.0.1681976668157;
        Thu, 20 Apr 2023 00:44:28 -0700 (PDT)
X-Google-Smtp-Source: AKy350Z7IEfs0fAM7ebAg8DXVOr8q6egC2Kzod/k8cQl1IYX07gfmo+OuSG7Na72Eh/GwKepAXSnkg==
X-Received: by 2002:a19:ac0d:0:b0:4e9:59cd:416c with SMTP id g13-20020a19ac0d000000b004e959cd416cmr167067lfc.0.1681976668012;
        Thu, 20 Apr 2023 00:44:28 -0700 (PDT)
Received: from localhost.localdomain (c-e6a5e255.022-110-73746f36.bbcust.telenor.se. [85.226.165.230])
        by smtp.googlemail.com with ESMTPSA id x24-20020ac24898000000b004edc7247778sm129468lfc.79.2023.04.20.00.44.27
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 20 Apr 2023 00:44:27 -0700 (PDT)
From:   Alexander Larsson <alexl@redhat.com>
To:     miklos@szeredi.hu
Cc:     linux-unionfs@vger.kernel.org, amir73il@gmail.com,
        ebiggers@kernel.org, tytso@mit.edu, fsverity@lists.linux.dev,
        Alexander Larsson <alexl@redhat.com>
Subject: [PATCH 1/6] fsverity: Export fsverity_get_digest
Date:   Thu, 20 Apr 2023 09:44:00 +0200
Message-Id: <9602bc96aff2506906d5d7ac4f67b137f16bc95a.1681917551.git.alexl@redhat.com>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <cover.1681917551.git.alexl@redhat.com>
References: <cover.1681917551.git.alexl@redhat.com>
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
2.39.2

