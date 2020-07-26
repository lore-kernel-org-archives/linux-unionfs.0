Return-Path: <SRS0=prAY=BF=vger.kernel.org=linux-unionfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-11.9 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E04BBC433E1
	for <linux-unionfs@archiver.kernel.org>; Sun, 26 Jul 2020 17:11:09 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id BFCC420714
	for <linux-unionfs@archiver.kernel.org>; Sun, 26 Jul 2020 17:11:09 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="pX+8sEn/"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726427AbgGZRLJ (ORCPT
        <rfc822;linux-unionfs@archiver.kernel.org>);
        Sun, 26 Jul 2020 13:11:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38772 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726117AbgGZRLJ (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Sun, 26 Jul 2020 13:11:09 -0400
Received: from mail-wm1-x341.google.com (mail-wm1-x341.google.com [IPv6:2a00:1450:4864:20::341])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AF273C0619D2;
        Sun, 26 Jul 2020 10:11:08 -0700 (PDT)
Received: by mail-wm1-x341.google.com with SMTP id f18so12518443wml.3;
        Sun, 26 Jul 2020 10:11:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=7K2A6e4kjdccKYC2DSixqcBQBkYbLUfuMeVBSI+i1II=;
        b=pX+8sEn/A3awvUuAOiIEWfe9w8+TQt+NopCLSRI+rKJFsoHAPO1u1vIl4k/DbTo3z1
         nsYKwaAeLpm06OO5O8FyM70ALeD/8kFeHXiu6kEAJoOqELozye+4K2AB/01+ozJjODMN
         2WAbJJTLtB2wRVE9R9I2xrGeTjJDltE0UQth9SxKGwJ6SfmjCRwHXRX93qVwNhoNK2Pa
         4pr7oUBqiyLIekKk9fyWhT9U0XpBVGwRUpCHlppHw+bJfRptU8dxoBJB/lnQzVhIDmp0
         3iEuMMYDyxJi9k4dUX25l27KZmKZe3dHLLCfD2ZYvKDkayZjjmh4kaV8sJOmJ2xF8UED
         Jd9Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=7K2A6e4kjdccKYC2DSixqcBQBkYbLUfuMeVBSI+i1II=;
        b=djqub5lmwtEVlt7HimqqwTPlW67yBQjo6rBMN8RDJTlTIEcdh098TBeUFX+SvHhR8Z
         Hlude7YGM6bWMw3rTiCwd414TYmBG1YIEZLaUyBVz1fjbEy/6gcZzYALMkCmXDb7PceH
         QtmTa2nFGGqhBh1PUh7YvSSvsswLpTzT7O7tDdvqzjhvs2O3S7veLvJ/pRQVzsWtdLcM
         khZruXQ3vCIuy2lpeShV9drFOr1YwS3iMC5GUAs/z50hJ/R4ykBvhNkjSZQGiVbXGl+4
         oaHMTAroszPMcPbhuFnCfhyBtsaeJlETLtC0LFjvUigUxJWWH5ArEyjdMXnhK+b3g0rp
         rBGQ==
X-Gm-Message-State: AOAM532uNgc2MgN0jTKjbjdjdGLXxpbyjMcorrp4K2BhT8+E3VjFmVJh
        q0/5eVBfOgekKXzT0C41LaZvqiKR
X-Google-Smtp-Source: ABdhPJxkj0kIxtnUh9MlyD7cbLGNT6sSNmnBLRQePMYdri7b1EvJenyu4yxo/mWFO62mUTuvEVyE6A==
X-Received: by 2002:a1c:4d10:: with SMTP id o16mr4180687wmh.33.1595783467036;
        Sun, 26 Jul 2020 10:11:07 -0700 (PDT)
Received: from localhost.localdomain ([31.210.180.214])
        by smtp.gmail.com with ESMTPSA id t141sm15367006wmt.26.2020.07.26.10.11.05
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 26 Jul 2020 10:11:06 -0700 (PDT)
From:   Amir Goldstein <amir73il@gmail.com>
To:     linux-unionfs@vger.kernel.org
Cc:     fstests@vger.kernel.org, Miklos Szeredi <miklos@szeredi.hu>,
        Vivek Goyal <vgoyal@redhat.com>, Eryu Guan <guaneryu@gmail.com>
Subject: [ANNOUNCE] unionmount-testsuite: master branch updated to 7e2a4db
Date:   Sun, 26 Jul 2020 20:10:58 +0300
Message-Id: <20200726171058.17331-1-amir73il@gmail.com>
X-Mailer: git-send-email 2.17.1
Sender: linux-unionfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-unionfs.vger.kernel.org>
X-Mailing-List: linux-unionfs@vger.kernel.org

Hi All,

The master branch on the unionmount-testsuite tree [1] has been updated.

This update has only one small change:
- Support metacopy with nested overlay configuration

A more significant change to announce is a change outside this project -
Thanks to Eryu for merging my patches to enable running unionmount tests
from xfstests [2].

unionmount-testsuite will now be maintained as a sort of a sub-module of
xfstests, but it can still be run independently as before.

For now, we agreed not to enforce any explicit dependency checks between
the projects, so it is the responsibility of the tester to update to the
latest version of unionmount-testsuite when running the xfstests harness.
This decision may be revised in the future should testers complain.

The purpose of this small update is to prepare for posting a patch to
xfstests for running the unionmount test cases with metacopy enabled,
per Vivek's request.

Thanks,
Amir.

[1] https://github.com/amir73il/unionmount-testsuite
[2] https://lore.kernel.org/fstests/5f1da17c.1c69fb81.10c70.3d58@mx.google.com/

Amir Goldstein (1):
  Support metacopy with nested overlay configuration

 mount_union.py | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

-- 
2.17.1

