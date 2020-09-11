Return-Path: <SRS0=kt3Y=CU=vger.kernel.org=linux-unionfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.6 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E2101C43461
	for <linux-unionfs@archiver.kernel.org>; Fri, 11 Sep 2020 02:18:24 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id A4E6121941
	for <linux-unionfs@archiver.kernel.org>; Fri, 11 Sep 2020 02:18:24 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="CIUMVGG1"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725385AbgIKCSY (ORCPT
        <rfc822;linux-unionfs@archiver.kernel.org>);
        Thu, 10 Sep 2020 22:18:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53506 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725300AbgIKCSX (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Thu, 10 Sep 2020 22:18:23 -0400
Received: from mail-pg1-x52c.google.com (mail-pg1-x52c.google.com [IPv6:2607:f8b0:4864:20::52c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 12A3AC061573;
        Thu, 10 Sep 2020 19:18:22 -0700 (PDT)
Received: by mail-pg1-x52c.google.com with SMTP id v15so5493972pgh.6;
        Thu, 10 Sep 2020 19:18:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:mime-version:content-disposition
         :in-reply-to;
        bh=9COwpGPUTtYFhNsODwjx7n06JVCAVuNB72tBEEjeDqo=;
        b=CIUMVGG1vOmSOZqqWXmMKnn2A7B7WLsizbhu/KD2dPlXlt0eOWAlG5F0IZ8ZcLNnei
         AKB7k1eLRh2QxbzTKOkkMbehuzWywQ/PLEktW75jScEmX3fb0sYOvADYz/Lmlwhljzmr
         tC4FHC6XSV/eqnrFWs3VImXeIjq//d6ey4897h17f2XOFoQ+D3GZTGjU7EOo2binqGuJ
         4CioVcj596IctufjMEW5qbTnekXIuLLNDI3dmWxLUYk2eoa6sR0VZiRn0qC24vRcgC7E
         SYa56E6hSsuZ6qaWeHBQGTpBvtNQnAUj4YM2gNT3GJMuMWHV7hGym4YcrwlSUQoDrLNf
         0H1Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:mime-version
         :content-disposition:in-reply-to;
        bh=9COwpGPUTtYFhNsODwjx7n06JVCAVuNB72tBEEjeDqo=;
        b=pzP0o99PkayDpmQ0ZEGI43vBV4Qa35APzQMzC3yTE+g/pQjEjuFv/+p3nNtaTwbPcG
         NywtgrM+jaiE7X2m5MHO9jyQ/YfbMWypaHaRr4riSFBIfA5Y/KQxm+UFAd721OlS40aL
         pR+sH7o0hmkftL7rAAVL7UvP/tGqAiAD1qKdPJYvjhPMvZK3Lf4gjiJn83aGh6Zzy+H/
         Rk9X8Rjq3b7TD5dHvOzQqtz9lAZX61BIzdsKeFvE949Cs+Szl35fJmBEjSFoyRg3pJ6D
         bHcbFXxG7O6OBGfl/4ozgWmMab9m9xI96v0ZwD2kcaEzLlXlRkZD9BlGvPPnjnEt4Bv+
         KYWg==
X-Gm-Message-State: AOAM531ksWtY8ZOCMvlqYguQQ5USAbMLpdiK0cJUagq1PSDktgfo/zaN
        m4bI4KvilS7Tq4NCnujhers=
X-Google-Smtp-Source: ABdhPJyRxv+l0c86YWswOlvQttk9BndOq4Pl/WAKL/ZVwyi9R/xdb3D+wiFor9UrYty9uKw7kpGaQQ==
X-Received: by 2002:a17:902:aa01:: with SMTP id be1mr3360741plb.93.1599790701579;
        Thu, 10 Sep 2020 19:18:21 -0700 (PDT)
Received: from localhost ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id l9sm298790pgg.29.2020.09.10.19.18.20
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 10 Sep 2020 19:18:21 -0700 (PDT)
Date:   Fri, 11 Sep 2020 10:18:13 +0800
From:   Murphy Zhou <jencce.kernel@gmail.com>
To:     Amir Goldstein <amir73il@gmail.com>,
        fstests <fstests@vger.kernel.org>
Cc:     Murphy Zhou <jencce.kernel@gmail.com>,
        Chengguang Xu <cgxu519@mykernel.net>,
        Miklos Szeredi <miklos@szeredi.hu>,
        overlayfs <linux-unionfs@vger.kernel.org>
Subject: [PATCH v2] overlay/073: test with nfs_export being off
Message-ID: <20200911021813.o6vtueabupevfgab@xzhoux.usersys.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAOQ4uxh+ppPMOSeAZU3sdwxwb_ixMHEpHLF9ZO_MTiedNJRgsw@mail.gmail.com>
Sender: linux-unionfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-unionfs.vger.kernel.org>
X-Mailing-List: linux-unionfs@vger.kernel.org

When nfs_export is enabled, the link count of upper dir
objects are more then the expected number in this testcase.
Because extra index entries are linked to upper inodes.

Signed-off-by: Murphy Zhou <jencce.kernel@gmail.com>
---
 tests/overlay/073 | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/tests/overlay/073 b/tests/overlay/073
index 37860c92..c5deccc6 100755
--- a/tests/overlay/073
+++ b/tests/overlay/073
@@ -99,7 +99,9 @@ run_test_case()
 {
 	_scratch_mkfs
 	make_lower_files ${1}
-	_scratch_mount -o "index=on"
+	# There will be extra hard links with nfs_export enabled which
+	# is expected. Turn it off explicitly to avoid the false alarm.
+	_scratch_mount -o "index=on,nfs_export=off"
 	make_whiteout_files
 	check_whiteout_files ${1} ${2}
 	_scratch_unmount
-- 
2.20.1

