Return-Path: <linux-unionfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id ABE06EE3F08
	for <linux-unionfs@archiver.kernel.org>; Tue, 12 Sep 2023 17:37:01 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232791AbjILRhE (ORCPT
        <rfc822;linux-unionfs@archiver.kernel.org>);
        Tue, 12 Sep 2023 13:37:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60566 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233902AbjILRhE (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Tue, 12 Sep 2023 13:37:04 -0400
Received: from mail-ej1-x62a.google.com (mail-ej1-x62a.google.com [IPv6:2a00:1450:4864:20::62a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2316710E9
        for <linux-unionfs@vger.kernel.org>; Tue, 12 Sep 2023 10:37:00 -0700 (PDT)
Received: by mail-ej1-x62a.google.com with SMTP id a640c23a62f3a-99bdcade7fbso736821666b.1
        for <linux-unionfs@vger.kernel.org>; Tue, 12 Sep 2023 10:37:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1694540218; x=1695145018; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=I/5aFDsLYUwSMU10MaTGaZcOmj+aAe0Fk5WnPc2t5I0=;
        b=cwFsL0wrajnlXgTW0d+8N/6DepI+pu4Df/HDV8p76LEmVzNsdYe6CxKLIpk/qIbqO2
         m84iI+DC2OFAmjkEcEg/xiRXEF6Z11Ok5cBDwF+x4opvC8rNImVWrpmms6yctF6rNL3/
         rTQtAiVTHe/aBN3LHueyABDtZYHTEGl6+rtKkkbSs63HhGo1Gf6dgerVfSFUo8JGQYU5
         Iz4VwGkgXbmzAAbsCjrOC0/BI+ukR9CMA5qeqqn8HYXcCR2DTTHx/pDwvNccK1asuvcI
         b/mImjyYw56r103JJ1aJWdFCuXKaJ1TMmX1oAxjqIb2XFc9X9DJrtpSUbsy0YmWT2hx/
         QctQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1694540218; x=1695145018;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=I/5aFDsLYUwSMU10MaTGaZcOmj+aAe0Fk5WnPc2t5I0=;
        b=e6+qATB3XFCzVA+Ms+L0CV/qM1hjxfNGyy2FJWgdP6VJHfwDI8B9eQrqY0aMkjxYzT
         XMEE0KCH1rE4Z8p4L5vb8WFC0WQrM8IITkrtwuBcWBexqehHHT3VlRurEpE7B3X2sd8/
         NL7pkLrfcEaILHfN+DW4ZuP4NzYEe7EjZaO5QUmNRnx3shPeMn6BjGrRBigrYPHAsQun
         H2FuinbtfdMezEihlTpMMH5VzhVU6Qfr/9plzrtWFkUeEM5EeKNpP8CMQMxQIFldmMp5
         /AAI+bFveXfRChJtT44/Nlg7oc8gDFArKF6gov+rfSpXtxIC2382TEd9C6ww86yg1pS3
         o0CA==
X-Gm-Message-State: AOJu0Yyhiqxq3rS63GGbyVbZ4L7+jhRD649BnYB4EUJP67rXNCTSj1NN
        3JhuZeHWigw/R2ygQJG1zMstATXvy34=
X-Google-Smtp-Source: AGHT+IF2BJJLZY3omOeaD8cWsTFqI6vXkZug5UvCbfuO0fR3TI/IHfnvZ4gIUKUy54YPHIE5t2yMvw==
X-Received: by 2002:a17:907:7751:b0:9a9:e5a8:3dd8 with SMTP id kx17-20020a170907775100b009a9e5a83dd8mr9686ejc.9.1694540218373;
        Tue, 12 Sep 2023 10:36:58 -0700 (PDT)
Received: from amir-ThinkPad-T480.lan ([5.29.249.86])
        by smtp.gmail.com with ESMTPSA id s3-20020a170906060300b0099ce188be7fsm7115978ejb.3.2023.09.12.10.36.57
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 12 Sep 2023 10:36:58 -0700 (PDT)
From:   Amir Goldstein <amir73il@gmail.com>
To:     Miklos Szeredi <miklos@szeredi.hu>
Cc:     linux-unionfs@vger.kernel.org
Subject: [PATCH 0/4] Overlayfs aio cleanups
Date:   Tue, 12 Sep 2023 20:36:49 +0300
Message-Id: <20230912173653.3317828-1-amir73il@gmail.com>
X-Mailer: git-send-email 2.34.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-unionfs.vger.kernel.org>
X-Mailing-List: linux-unionfs@vger.kernel.org

Miklos,

Following are the cleanups and minor fixes I did in preparation for
factoring out of read/write passthrough code.

There are very minor fixes, which do not desreve backporting IMO.
The only meaningful fix (fd leak) was already merged to master.

I will send out the re-factoring patch separately to fsdevel, but
I've split those prep patches for lack of wider audience interest.

Thanks,
Amir.


Amir Goldstein (4):
  ovl: protect copying of realinode attributes to ovl inode
  ovl: use simpler function to convert iocb to rw flags
  ovl: propagate IOCB_APPEND flag on writes to realfile
  ovl: move ovl_file_accessed() to aio completion

 fs/overlayfs/file.c | 75 +++++++++++++++++++++++++--------------------
 fs/overlayfs/util.c |  2 ++
 2 files changed, 44 insertions(+), 33 deletions(-)

-- 
2.34.1

