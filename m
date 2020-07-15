Return-Path: <SRS0=S/v9=A2=vger.kernel.org=linux-unionfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.1 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 908ABC433E6
	for <linux-unionfs@archiver.kernel.org>; Wed, 15 Jul 2020 13:38:19 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 7222220658
	for <linux-unionfs@archiver.kernel.org>; Wed, 15 Jul 2020 13:38:19 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Bn5T8yew"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731931AbgGONiS (ORCPT
        <rfc822;linux-unionfs@archiver.kernel.org>);
        Wed, 15 Jul 2020 09:38:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43458 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731376AbgGONiR (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Wed, 15 Jul 2020 09:38:17 -0400
Received: from mail-wr1-x442.google.com (mail-wr1-x442.google.com [IPv6:2a00:1450:4864:20::442])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DBC3DC08C5C1
        for <linux-unionfs@vger.kernel.org>; Wed, 15 Jul 2020 06:38:16 -0700 (PDT)
Received: by mail-wr1-x442.google.com with SMTP id o11so2744056wrv.9
        for <linux-unionfs@vger.kernel.org>; Wed, 15 Jul 2020 06:38:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=4DUXyhcHa9rgH3Wd2u41FeGhKXa8aQYaWz+M4G+yJfk=;
        b=Bn5T8yewsHQahzgvrnWnSxaqyAM/Dtcocw6sesLFKjkj7n37SUQXuio4hV0Bsv85JO
         fsEA89k2g1tfvyyZAuYUUpaYfr7K2yhqgy15j5azLDydaLd5M1Ie/GkbIjk0k78ZH4R5
         M+gOwcWWdqYT4ls8tXnIFL2rY57dtZDx8Po0aJvk/M/Uig9EkwZ7ZU1lO2aaiHOP1MM8
         JJyDqsFn+dIHmhcE5SyQmSnGiYPnCxRkIYa9oNPyKdZ5j8XyM8F33uWB+ccYPLGw3688
         Ys0SIyR5yDQxnH6WblT/to1a0N9npAZlacHMryouMmoEC0G3WjFY3Gd2pYYSxb+z7E7s
         ekzw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=4DUXyhcHa9rgH3Wd2u41FeGhKXa8aQYaWz+M4G+yJfk=;
        b=cHIAEImaFlaIWngRu9jRsYZvMwUWawz9JzaYpernU7KERC4uT1iOh2CnI/GWRiBfKY
         2GtXAu5vM6lAkX59dhHC2ToiqFcMcF0QwLK15h20ho9HwxkDX2mE2+oLYWQxX570isQA
         UAoRpqXxh9OV4R0q8OP45wW7gp3kTyrkHOJAygsEaJY7qFrvq0E7Y19MJMTTvR9cpZWY
         8EeA7T/nSuGke/FjnSn1JgiTDXzBi0K9GCDplQXEPe4vr9YES3Yn0QqFo1xMGqMzEenf
         +I7DjzOFJhkPDyamciUxkX3Vl4UTlV8803qLSm9Mz8icFtA6SKR+0hyhXkh/NEjX7JP3
         9ctw==
X-Gm-Message-State: AOAM531Zib3/G87vgo3csIhzEfqZDEA2v5cw6ajXg9gB2akALDBn3o1l
        BIczZJchuMDBJFID06c0E94=
X-Google-Smtp-Source: ABdhPJxiB9K6L4N3Iw2Ltf/lkfiHdKKQsk95pYvAXhECee3aUkTTgA7EIbcEmuouTu4t8qm/sh2n6w==
X-Received: by 2002:adf:e6cb:: with SMTP id y11mr11165462wrm.282.1594820295564;
        Wed, 15 Jul 2020 06:38:15 -0700 (PDT)
Received: from localhost.localdomain ([141.226.183.23])
        by smtp.gmail.com with ESMTPSA id c194sm3431839wme.8.2020.07.15.06.38.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 15 Jul 2020 06:38:14 -0700 (PDT)
From:   Amir Goldstein <amir73il@gmail.com>
To:     Miklos Szeredi <miklos@szeredi.hu>
Cc:     Vivek Goyal <vgoyal@redhat.com>, linux-unionfs@vger.kernel.org
Subject: [PATCH] ovl: fix lookup of indexed hardlinks with metacopy
Date:   Wed, 15 Jul 2020 16:38:08 +0300
Message-Id: <20200715133808.7146-1-amir73il@gmail.com>
X-Mailer: git-send-email 2.17.1
Sender: linux-unionfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-unionfs.vger.kernel.org>
X-Mailing-List: linux-unionfs@vger.kernel.org

We recently moved setting inode flag OVL_UPPERDATA to ovl_lookup().

When looking up an overlay dentry, upperdentry may be found by index
and not by name.  In that case, we fail to read the metacopy xattr
and falsly set the OVL_UPPERDATA on the overlay inode.

This caused a regression in xfstest overlay/033 when run with
OVERLAY_MOUNT_OPTIONS="-o metacopy=on".

Fixes: 28166ab3c875 ("ovl: initialize OVL_UPPERDATA in ovl_lookup()")
Signed-off-by: Amir Goldstein <amir73il@gmail.com>
---

Miklos,

I just ran xfstests -g overlay/quick tests with metacopy enabled
and one test failed.

Vivek,

Do you by any chance run this sort of test regularly?

You have asked about running unionmount tests with metacopy before.
I just pushed a commit to my xfstests 'unionmount' branch:
  7859f22b ovl: test unionmount tests with metacopy

It allows you to run xfstests -g overlay/union with
OVERLAY_MOUNT_OPTIONS="-o metacopy=on", to excercise all the unionmount
test configurations I created with metacopy enabled.

Maybe not so surprising that the sub-group overlay/union.nested tests
fail with metacopy enabled. This is just a test setup bug and I pushed
a fix commit to unionmount overlayfs-devel branch to fix it.

Thanks,
Amir.

 fs/overlayfs/namei.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/fs/overlayfs/namei.c b/fs/overlayfs/namei.c
index 3566282a9199..0c5a624600c1 100644
--- a/fs/overlayfs/namei.c
+++ b/fs/overlayfs/namei.c
@@ -1073,6 +1073,10 @@ struct dentry *ovl_lookup(struct inode *dir, struct dentry *dentry,
 			upperredirect = NULL;
 			goto out_free_oe;
 		}
+		err = ovl_check_metacopy_xattr(upperdentry);
+		if (err < 0)
+			goto out_free_oe;
+		uppermetacopy = err;
 	}
 
 	if (upperdentry || ctr) {
-- 
2.17.1

