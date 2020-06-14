Return-Path: <SRS0=/kxx=73=vger.kernel.org=linux-unionfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.6 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 83982C433E0
	for <linux-unionfs@archiver.kernel.org>; Sun, 14 Jun 2020 13:09:49 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 5C4B5206D7
	for <linux-unionfs@archiver.kernel.org>; Sun, 14 Jun 2020 13:09:49 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="K0NpbXCN"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727025AbgFNNJt (ORCPT
        <rfc822;linux-unionfs@archiver.kernel.org>);
        Sun, 14 Jun 2020 09:09:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59272 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726939AbgFNNJs (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Sun, 14 Jun 2020 09:09:48 -0400
Received: from mail-wr1-x443.google.com (mail-wr1-x443.google.com [IPv6:2a00:1450:4864:20::443])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DCD4BC05BD43
        for <linux-unionfs@vger.kernel.org>; Sun, 14 Jun 2020 06:09:47 -0700 (PDT)
Received: by mail-wr1-x443.google.com with SMTP id x13so14380474wrv.4
        for <linux-unionfs@vger.kernel.org>; Sun, 14 Jun 2020 06:09:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=CjjGRuVzjjGtMSbsG+YItSmjb7fimRYuP+yDSmPAEnw=;
        b=K0NpbXCNQw/cEqwsf6z58ZI7HBu/XEIPKIO/yOXsTgpU/aI8tg1glOSTzfpgnh5w+D
         Yd99Qjpx9aBcShe4r7TrQaJlfrmLlUKAdxfxKPOD6q6+kG7GM5rVnjMzx7W1Cv/eJyIJ
         jgu/UAOabfuqVo/LNN9T/NkxkHxs9nQsz0RRT1RImgFaffhg4TOjmLmNliJqZSyyij+c
         sBIkXiZ/3Y6zIb405vcxFKWdy+3rWeXN5i+NMkd6BQ1Hyn7n0AfzFAci+8zxFHbiVJLO
         +4U0MygJmaSCyh7R/ShAK8mCNHS+iR9FnLcWhOXcG2WjznLJBKcBDP0wUSIqPPO2bS2B
         1KuA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=CjjGRuVzjjGtMSbsG+YItSmjb7fimRYuP+yDSmPAEnw=;
        b=FCLspOkVV8m9OU6HmCb/60sW9Zyz6TvHmD6uZ1M/7UQurCZxquy1V8WTCYg7We5NOw
         AyGtCldmt0rrmsOPyqOkRu1MAmFrVjhfh5TPqOWFScwxIKBtR7d6mxhuuouMLWiCly82
         ODIqxMN1cIOVBwbSVYKeShRF51G/CNHf0T3ygQp7MamGGH1NPXt8OgNuudQwh7dLyTG3
         bb2Q+AxmWlmtM+BXryG1Qgflq3Gu2OJqS/vWhuiZLKERKFSG/wBwIkGYfXXMEjt+5dkF
         Bw5C0GxE6Uvs2jHHYzk3A7IlfSZsRM4HuUxexI8ROhq0MPn94rwAUhaluD0uMAbLET3j
         edtA==
X-Gm-Message-State: AOAM5333t5PHf4sbjSpKEs8FrpfxSb9VTl+Ht4VkSHtozGHCOAhMYXJr
        xGf6r+SJLXlf8xiBqwYNFAQPKDr6
X-Google-Smtp-Source: ABdhPJxfsA5Gv69bw8c9iTL0cGWe1zZMziFbhF92up9ra91vGXGK2mFQRmQCWNQneLgO5bzO466Mcw==
X-Received: by 2002:a5d:554a:: with SMTP id g10mr24968967wrw.334.1592140186364;
        Sun, 14 Jun 2020 06:09:46 -0700 (PDT)
Received: from localhost.localdomain ([5.102.204.95])
        by smtp.gmail.com with ESMTPSA id g82sm18458283wmf.1.2020.06.14.06.09.45
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 14 Jun 2020 06:09:45 -0700 (PDT)
From:   Amir Goldstein <amir73il@gmail.com>
To:     Miklos Szeredi <miklos@szeredi.hu>
Cc:     Mike Kravetz <mike.kravetz@oracle.com>,
        linux-unionfs@vger.kernel.org
Subject: [PATCH 0/2] Propagate overlay f_mode from underlying file
Date:   Sun, 14 Jun 2020 16:09:37 +0300
Message-Id: <20200614130939.7702-1-amir73il@gmail.com>
X-Mailer: git-send-email 2.17.1
Sender: linux-unionfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-unionfs.vger.kernel.org>
X-Mailing-List: linux-unionfs@vger.kernel.org

Miklos,

Following the discussions on hugetlbfs-overlayfs, I wanted to see
if we can do better to emulate the underlying file supported ops.

Those patches don't actually help the hugetlbfs issue at all and
I am not sure they improve anything, but I though it would be better
if you had a look to say if there is anything interesting we can
get from this.

Thanks,
Amir.

Amir Goldstein (2):
  ovl: inherit supported ops f_mode flags from final real file
  ovl: warn about unsupported file operations on upper fs

 fs/overlayfs/copy_up.c   | 11 ++++++++
 fs/overlayfs/file.c      | 11 ++++++++
 fs/overlayfs/overlayfs.h |  5 ++++
 fs/overlayfs/super.c     | 60 ++++++++++++++++++++++++++--------------
 4 files changed, 66 insertions(+), 21 deletions(-)

-- 
2.17.1

