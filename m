Return-Path: <linux-unionfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 27983C77B75
	for <linux-unionfs@archiver.kernel.org>; Wed,  3 May 2023 08:52:49 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229571AbjECIws (ORCPT
        <rfc822;linux-unionfs@archiver.kernel.org>);
        Wed, 3 May 2023 04:52:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39892 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229449AbjECIwr (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Wed, 3 May 2023 04:52:47 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0DDF8420B
        for <linux-unionfs@vger.kernel.org>; Wed,  3 May 2023 01:51:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1683103918;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=w0VxTZdYvYJJpJt4f1CWhQCMN6thwfx97+dJKO1TgUg=;
        b=NlSy9cg0JxLym4XQwyqRt6h/ofpc5H2AbwMnrdR+iQdW9QOdd7Mm+eHm/rtpiM5wjWtaL8
        YtLz8LuxgQOQac4xeLYHZyQOuSZ2leQRaKIwLMsRvjGViBjhkBhJfP4fJHhN7y0BxsyB2g
        xYtubV3GGYBRcy0uRM/HSOTLWTuC7AQ=
Received: from mail-lj1-f199.google.com (mail-lj1-f199.google.com
 [209.85.208.199]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-460-XqTwETgxN-KYrbX1qHZW0w-1; Wed, 03 May 2023 04:51:57 -0400
X-MC-Unique: XqTwETgxN-KYrbX1qHZW0w-1
Received: by mail-lj1-f199.google.com with SMTP id 38308e7fff4ca-2a8c3314d18so24112671fa.0
        for <linux-unionfs@vger.kernel.org>; Wed, 03 May 2023 01:51:56 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1683103915; x=1685695915;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=w0VxTZdYvYJJpJt4f1CWhQCMN6thwfx97+dJKO1TgUg=;
        b=lOMYPouEpStYtDzqbROSY3QHToPD7cAuVx6kAYmY05G7NN1+/2MVto7hxwJtstXVoi
         5BqtkPbu8qvU8E7NraEFjokrgFXL7Rl82fJkyCHMfw5VA9Q3miyY3iDrMOhYsspFIkMv
         hfRHvJXEYVshlMutuUcAS2v5Ah42qzi6AZLWo+Y1QB2CNvcszd8qDdTt4IIyA80RifSh
         7aeh+k5jR/avMd/RhK5Tfrnuevy5o27vKDOeRNvMDF5WjL1cJXOI2WLX+x7zMATpig+f
         sWWLT0X5/ICGbjkv1e9+cCOYxt5EDYzbjs64RJJY+GZTM++vAuJruqz2PgyOEfNWnnMk
         wd4A==
X-Gm-Message-State: AC+VfDy+uC0x00jjcv4AghNh3OICbjYcvt8G93Iy/3MYM+3eslkEM3em
        n6CcV0uwKB955u7Lp0RA65b+GOtOX2NO8VTLgtTrnsP/JSTnrmgCxm5PFt1KbQBnhEwuxtW1Bgu
        qf48OkgbMPAmOmlPljh7BE4HqrA==
X-Received: by 2002:ac2:410b:0:b0:4ec:8596:918b with SMTP id b11-20020ac2410b000000b004ec8596918bmr769945lfi.24.1683103915597;
        Wed, 03 May 2023 01:51:55 -0700 (PDT)
X-Google-Smtp-Source: ACHHUZ7s2nioBDBre/9YYc1rxWYzSkRPrtaIAepxt562IrVn/o804+eY82qdLC3B2qSUScqlyA+z5A==
X-Received: by 2002:ac2:410b:0:b0:4ec:8596:918b with SMTP id b11-20020ac2410b000000b004ec8596918bmr769937lfi.24.1683103915310;
        Wed, 03 May 2023 01:51:55 -0700 (PDT)
Received: from localhost.localdomain (c-e6a5e255.022-110-73746f36.bbcust.telenor.se. [85.226.165.230])
        by smtp.googlemail.com with ESMTPSA id j6-20020ac24546000000b004ed4fa5f20fsm5907089lfm.25.2023.05.03.01.51.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 03 May 2023 01:51:54 -0700 (PDT)
From:   Alexander Larsson <alexl@redhat.com>
To:     miklos@szeredi.hu
Cc:     linux-unionfs@vger.kernel.org, amir73il@gmail.com,
        ebiggers@kernel.org, tytso@mit.edu, fsverity@lists.linux.dev,
        Alexander Larsson <alexl@redhat.com>
Subject: [PATCH v2 1/6] fsverity: Export fsverity_get_digest
Date:   Wed,  3 May 2023 10:51:34 +0200
Message-Id: <ff458c6bcf6bd9ab10dbcb80894ea24d34f9f7c6.1683102959.git.alexl@redhat.com>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <cover.1683102959.git.alexl@redhat.com>
References: <cover.1683102959.git.alexl@redhat.com>
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

