Return-Path: <SRS0=r5kD=AY=vger.kernel.org=linux-unionfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.1 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6D5A0C433E2
	for <linux-unionfs@archiver.kernel.org>; Mon, 13 Jul 2020 14:19:56 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 4B6D52072D
	for <linux-unionfs@archiver.kernel.org>; Mon, 13 Jul 2020 14:19:56 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="a7laz5Dk"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730021AbgGMOTz (ORCPT
        <rfc822;linux-unionfs@archiver.kernel.org>);
        Mon, 13 Jul 2020 10:19:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56354 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729659AbgGMOTz (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Mon, 13 Jul 2020 10:19:55 -0400
Received: from mail-wm1-x342.google.com (mail-wm1-x342.google.com [IPv6:2a00:1450:4864:20::342])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6AACAC061755
        for <linux-unionfs@vger.kernel.org>; Mon, 13 Jul 2020 07:19:55 -0700 (PDT)
Received: by mail-wm1-x342.google.com with SMTP id o2so13346686wmh.2
        for <linux-unionfs@vger.kernel.org>; Mon, 13 Jul 2020 07:19:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=CF35P0ICQFNHJuAP+TJn7xyU+B+CjPxp5kEDL7YU3E8=;
        b=a7laz5DkOXzA/wVkc6AsBRncd/Bj1DaHYGyLS07MAfYPtid4TyHtEQxNM+KGwZQEie
         I2E++7rpVL4JvQeSd8+7FZuHV+xSsjF/FQPAP/4qANvL2mQSc+UTNOqg+K7HSEyksrob
         BfJYzCTP04TjapuKMZKRGUg8W4D9naNCawYKyu45t+4a60gWYdKPrVCHLLheHos/AENk
         VCGm2LV4ecG5naPZbMvLqzhogXMchAF02Q1XZOP5l8cFd3YQPaPnfPNDgNKr+NJV74qJ
         wkFsr/TUEn+oUda2ozUFUHX3pStiMb8KyOwRXl+ImuPdJLum8gRa5m4x5KsQdQ9JG2NI
         SgRQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=CF35P0ICQFNHJuAP+TJn7xyU+B+CjPxp5kEDL7YU3E8=;
        b=oT//zLlQGTYvJVZ4VxSDx4PgfSvO5asOwyVC5SAsrERGX/l0d3aSFEIOZuHQtWtJYB
         z8ZxiNJSKH66bKfBXc5KYfQcoTB4DZYVlD3xgK+lb91crybmj/OJKR8f+HTL3l3ISHeZ
         KgK7FJN71KbGfNLVnrurZckOvMByrqRDUJEewvWLUQRJ75mpQSQlyxEL6d8BFAc0BnnE
         K1GeqvgVx9ONh179rV7WTsHlny+ki2Ab0hjdzlSLlon3rGI6c6P9TDHeytSm85kblsyX
         voHhDJAfJSzgfZZvfP+eVUVT7Fq/wQQaI7c4Y6bGPkOeKEyNq0Jgm1T1zRp3T6EPSldZ
         3JjQ==
X-Gm-Message-State: AOAM533/lSx1HZjTJqu0uHmol6rCfCCGbJ/dORUBfOuhflrOnHzYKOoi
        Ttl0gPq7BH35xA4fyc7y3nhmH18r
X-Google-Smtp-Source: ABdhPJzHKH4BLTGqnSx6TlIpUFSqrM9IB/BiBXs7Eqknjamk1YzczxoKzGrL3vxvbV9fkImCCJMi4A==
X-Received: by 2002:a7b:c208:: with SMTP id x8mr176876wmi.49.1594649994191;
        Mon, 13 Jul 2020 07:19:54 -0700 (PDT)
Received: from localhost.localdomain ([141.226.183.23])
        by smtp.gmail.com with ESMTPSA id 1sm21681024wmf.21.2020.07.13.07.19.52
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 13 Jul 2020 07:19:53 -0700 (PDT)
From:   Amir Goldstein <amir73il@gmail.com>
To:     Miklos Szeredi <miklos@szeredi.hu>
Cc:     Vivek Goyal <vgoyal@redhat.com>, linux-unionfs@vger.kernel.org
Subject: [PATCH 0/3] Misc. redirect_dir=nofollow fixes
Date:   Mon, 13 Jul 2020 17:19:42 +0300
Message-Id: <20200713141945.11719-1-amir73il@gmail.com>
X-Mailer: git-send-email 2.17.1
Sender: linux-unionfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-unionfs.vger.kernel.org>
X-Mailing-List: linux-unionfs@vger.kernel.org

Miklos, Vivek,

Following discussion on following an unsafe non-dir origin [1]
and in a addition to a fix for the reported null uuid case [2] and to
Vivek's doc clarification [3], I am proposing to piggy back existing
config redirect_dir=nofollow to also not follow non-dir origin.

Like in the case of non-dir origin, following redirects behavior was
added with no opt-out option in kernel v4.10.  Later security concerns
about following malformed redirects resulted in the redirect_dir=nofollow
config option.

Without giving too much thought into how unsafe it can be to follow
a bad origin, there is very low motication IMO to follow non-dir origin
with redirect_dir=nofollow, because it is a configuration that prefers
safety over correctness, so it just seems like the right thing to do.

The first two patches are independent bug fixes related to read-only
NFS export, which can be taken regardless of non-dir origin nofollow.
FYI, I found those bugs because I am using ro,index=off NFS export
configuration for the new overlay fsnotify snaphsot series.

Thanks,
Amir.

[1] https://lore.kernel.org/linux-unionfs/CAJfpegv9h7ubuGy_6K4OCdZd3R7Z4HGmCDB2L7mO5bVoGd6MSA@mail.gmail.com/
[2] https://lore.kernel.org/linux-unionfs/20200708131613.30038-1-amir73il@gmail.com/
[3] https://lore.kernel.org/linux-unionfs/20200709140220.GC150543@redhat.com/

Amir Goldstein (3):
  ovl: force read-only sb on failure to create index dir
  ovl: fix mount option checks for nfs_export with no upperdir
  ovl: do not follow non-dir origin with redirect_dir=nofollow

 Documentation/filesystems/overlayfs.rst |  4 +--
 fs/overlayfs/namei.c                    |  2 +-
 fs/overlayfs/super.c                    | 42 ++++++++++++++-----------
 3 files changed, 27 insertions(+), 21 deletions(-)

-- 
2.17.1

