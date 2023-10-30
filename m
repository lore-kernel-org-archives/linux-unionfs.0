Return-Path: <linux-unionfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3A368C4332F
	for <linux-unionfs@archiver.kernel.org>; Mon, 30 Oct 2023 12:04:30 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232492AbjJ3MEa (ORCPT
        <rfc822;linux-unionfs@archiver.kernel.org>);
        Mon, 30 Oct 2023 08:04:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57530 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229456AbjJ3MEa (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Mon, 30 Oct 2023 08:04:30 -0400
Received: from mail-lj1-x22c.google.com (mail-lj1-x22c.google.com [IPv6:2a00:1450:4864:20::22c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B4B2CC9
        for <linux-unionfs@vger.kernel.org>; Mon, 30 Oct 2023 05:04:27 -0700 (PDT)
Received: by mail-lj1-x22c.google.com with SMTP id 38308e7fff4ca-2c5087d19a6so61369881fa.0
        for <linux-unionfs@vger.kernel.org>; Mon, 30 Oct 2023 05:04:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1698667466; x=1699272266; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=IzSeGplfwQo7BBY80XmhaUnxDwUf6i+/BlZxFBW2UfA=;
        b=dGRcV3ACyhhQ595itvRCp8Q1iV+rkNRl6DSYxFWEWAE0haE7ynebIe5YWP3ttMm5RF
         cnNrMEt1naImDa19N5v8xkRwzAw4Omb0A7amg1oNECT37m5Xheob45T3zrYzZHTaMfGC
         UwqoWQNeQtSaitTAD8mZUDkSyB02nz19FH2zs4lhuJ12qfHODu417h/elfkT50KHgbT5
         5Dhey2+fGaUK57UuOKxiKNWyGXBCDKm1DKIjNAxyHwaIEk/b1suZO6WdkI97o3q+9CeO
         jjD7/JtQfJgYNM4DZgndpImHtZFXSZBbGpKT7hWvyDTl3D92yl5dfQ9Gi78nh3uahs8g
         lsgQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1698667466; x=1699272266;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=IzSeGplfwQo7BBY80XmhaUnxDwUf6i+/BlZxFBW2UfA=;
        b=f2Ay3ST5rhZ/In5n2DXvgcQvvj7ovmD/lNbj0X157yZGiGKLKFmwvBncsaYsQS1k59
         z3DYDgViF11cW/wqQhAbNV++HrtTLOylRsLYifsx8dNu0dVK7tHdeVKaMM1EuaEdlF3V
         n4ez2uoWXU5fO+lWcVLRwpEruLAS3BDblQVKm0ioE+sKSHLkqr4y/+IsSX2DzQY4I0Fa
         tt6B3+iPg0MammHCtAJcS/LsNcXYa/I0KwUyeYmNufWX4sOg5UJkxT9tAQCWBBQUax7Q
         R0yJb7jiFXwe6CNsASXjFt77oN5B+PVj1iHCOiTr2aQCX8fZlDIlr4O16NaULdtFsY+7
         aJng==
X-Gm-Message-State: AOJu0Yzv86zOmHP5etJBjJYIjPqDp2H57PgOH7lKN/n24vdDDeToSXYX
        1IW85VNQJbS6SzAOdXIX3hyOLUTkEhk=
X-Google-Smtp-Source: AGHT+IEasMAtnBTOPKKPC4BJX4Evzo8F15aRbkAQcbC67fPXOSdVJwpGNGXsIZlFri7VYsixecVFaA==
X-Received: by 2002:a2e:b7c7:0:b0:2bc:d6a8:1efd with SMTP id p7-20020a2eb7c7000000b002bcd6a81efdmr7261645ljo.39.1698667464931;
        Mon, 30 Oct 2023 05:04:24 -0700 (PDT)
Received: from amir-ThinkPad-T480.lan ([5.29.249.86])
        by smtp.gmail.com with ESMTPSA id l21-20020a2e7015000000b002b9e346a152sm1210753ljc.96.2023.10.30.05.04.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 30 Oct 2023 05:04:23 -0700 (PDT)
From:   Amir Goldstein <amir73il@gmail.com>
To:     Miklos Szeredi <miklos@szeredi.hu>
Cc:     Christian Brauner <brauner@kernel.org>,
        linux-unionfs@vger.kernel.org
Subject: [PATCH 0/4] ovl: new mount options lowerdir+,datadir+
Date:   Mon, 30 Oct 2023 14:04:15 +0200
Message-Id: <20231030120419.478228-1-amir73il@gmail.com>
X-Mailer: git-send-email 2.34.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-unionfs.vger.kernel.org>
X-Mailing-List: linux-unionfs@vger.kernel.org

Miklos,

As discussed, here are the patches for the new mount options.

- Only string format is supported
- Legacy lowerdir= cannot be mixed with new lowerdir+,datadir+
- lowerdir+,datadir+ are not escaped
- lowerdir,upperdir,workdir are escaped as always

I did not find a good reason to change escaping of upperdir,workdir.
We can skip escaping when we add support for path format.

Wrote some xfstests [1].

Thanks,
Amir.

[1] https://github.com/amir73il/xfstests/commits/ovl-lowerdir-add

Amir Goldstein (4):
  ovl: remove unused code in lowerdir param parsing
  ovl: store and show the user provided lowerdir mount option
  ovl: refactor layer parsing helpers
  ovl: add support for appending lowerdirs one by one

 fs/overlayfs/params.c | 317 ++++++++++++++++++++++--------------------
 fs/overlayfs/params.h |   1 +
 fs/overlayfs/super.c  |   5 +-
 3 files changed, 173 insertions(+), 150 deletions(-)

-- 
2.34.1

