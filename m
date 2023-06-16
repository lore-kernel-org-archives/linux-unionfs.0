Return-Path: <linux-unionfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DE9EDEB64DA
	for <linux-unionfs@archiver.kernel.org>; Fri, 16 Jun 2023 14:19:49 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229770AbjFPOTt (ORCPT
        <rfc822;linux-unionfs@archiver.kernel.org>);
        Fri, 16 Jun 2023 10:19:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35540 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235100AbjFPOTs (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Fri, 16 Jun 2023 10:19:48 -0400
Received: from mail-wm1-x32d.google.com (mail-wm1-x32d.google.com [IPv6:2a00:1450:4864:20::32d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A4EB930D3
        for <linux-unionfs@vger.kernel.org>; Fri, 16 Jun 2023 07:19:47 -0700 (PDT)
Received: by mail-wm1-x32d.google.com with SMTP id 5b1f17b1804b1-3f8cc042e2bso5959205e9.2
        for <linux-unionfs@vger.kernel.org>; Fri, 16 Jun 2023 07:19:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1686925186; x=1689517186;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=zycsjxQgDEHYrtGuk2CwAMtI1Q+ONQvj4wgXhuxt6/8=;
        b=qFE4pkKK/9vWVaZnwHcpud26F2ww4KlHxF5v1w1TUL0PSp4qh+3UrF91L904Onjpa4
         zPlih+dE74u8WmA5VLsM1AmodrjpZ3LGLKjXbra+WFkcxihUtm83IMh5GkWld3CeKEaM
         r/zpHpVyeUmqQnD7q9wnzVy1h7mr2vSA+0IvwMhs8Jv3j6D5uoAgNYJtjI44Gtx/jImi
         SgGej5Z55p5NSz1twylFE4rguw9ZTdeC1m7CuW4BVsJYLRfy2BnESpTu+egRtCXdUW+A
         rLHxR5DgziMHyvZFY/EYN7QFF6OEXSQxpybeobWARAGu4h4B18HOZzK5JzIOcyhN7OG4
         fkqA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1686925186; x=1689517186;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=zycsjxQgDEHYrtGuk2CwAMtI1Q+ONQvj4wgXhuxt6/8=;
        b=VDrZIBzkzegVbNIHh3JeNjjVfLPd24c139Ucb5PJoLGICMJxkzCWydKjiMSBmwGIX5
         RZLwsZzjZ1m+YScyHmHvYojfIRvqSAs+s+BDLKOp1V4/GoJlIyXrLZQFV576e0FUVVO+
         6HnAZHcxWDIgQ6X6a13T473i/uMVkRQljeBt5rGCzvW71CTxIPaXqKysYPAr+Vz+LyqZ
         CG+HQTsSRoedKrscHASuB7Bhkkb/VQQHuBb87HkepESHF4z/5IKX/9tipR0+lQt6vE0R
         gP+ZEGCnDp8Z7OU5K/AndsLlm17Kjr9EP9/Y/Qmb4Z3taQDlyufNmI4G+rXzZPVtdC2K
         sRgw==
X-Gm-Message-State: AC+VfDzpimJQTnfk997uP05GLuGNV/PPOkqQWR1Ne7Kh2dzwqe5Xlyn4
        LIfj0xSTPKU0l6Lb3mfubXcy9QUIz4I=
X-Google-Smtp-Source: ACHHUZ5qF+nCYNaI/xQ30llLdKOELZunQuiNDobbBqu5wPkumnLIBfssUkcl04KWKXYdu1xJSjyVCg==
X-Received: by 2002:a7b:c014:0:b0:3f8:f1db:d206 with SMTP id c20-20020a7bc014000000b003f8f1dbd206mr1506737wmb.25.1686925185723;
        Fri, 16 Jun 2023 07:19:45 -0700 (PDT)
Received: from amir-ThinkPad-T480.lan ([5.29.249.86])
        by smtp.gmail.com with ESMTPSA id k17-20020a05600c0b5100b003f7ec896cefsm2399269wmr.8.2023.06.16.07.19.44
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 16 Jun 2023 07:19:45 -0700 (PDT)
From:   Amir Goldstein <amir73il@gmail.com>
To:     Miklos Szeredi <miklos@szeredi.hu>
Cc:     Christian Brauner <brauner@kernel.org>,
        linux-unionfs@vger.kernel.org
Subject: [PATCH 0/2] Prep patches for porting overlayfs to new mount api
Date:   Fri, 16 Jun 2023 17:19:39 +0300
Message-Id: <20230616141941.2402664-1-amir73il@gmail.com>
X-Mailer: git-send-email 2.34.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-unionfs.vger.kernel.org>
X-Mailing-List: linux-unionfs@vger.kernel.org

Miklos,

Following two cleanup patches that make Christian's new mount api
patches smaller and easier to review.

I had already rebased Christain's patches over these cleanups
and pushed to github branch fs-overlayfs-mount_api [1], which I am
running tests on.

Thanks.
Amir.

[1] https://github.com/amir73il/linux/commits/fs-overlayfs-mount_api

Amir Goldstein (2):
  ovl: store enum redirect_mode in config instead of a string
  ovl: factor out ovl_parse_options() helper

 fs/overlayfs/dir.c       |   2 +-
 fs/overlayfs/namei.c     |   6 +-
 fs/overlayfs/overlayfs.h |  28 ++-
 fs/overlayfs/ovl_entry.h |   4 +-
 fs/overlayfs/super.c     | 355 +++++++++++++++++++++------------------
 fs/overlayfs/util.c      |   7 -
 6 files changed, 224 insertions(+), 178 deletions(-)

-- 
2.34.1

