Return-Path: <linux-unionfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.6 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B55E0C433ED
	for <linux-unionfs@archiver.kernel.org>; Fri, 30 Apr 2021 14:47:54 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 8E97D613EE
	for <linux-unionfs@archiver.kernel.org>; Fri, 30 Apr 2021 14:47:54 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233438AbhD3Osm (ORCPT
        <rfc822;linux-unionfs@archiver.kernel.org>);
        Fri, 30 Apr 2021 10:48:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50700 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233680AbhD3Osb (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Fri, 30 Apr 2021 10:48:31 -0400
Received: from mail-ed1-x52f.google.com (mail-ed1-x52f.google.com [IPv6:2a00:1450:4864:20::52f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D7419C06138C
        for <linux-unionfs@vger.kernel.org>; Fri, 30 Apr 2021 07:47:42 -0700 (PDT)
Received: by mail-ed1-x52f.google.com with SMTP id d14so19128376edc.12
        for <linux-unionfs@vger.kernel.org>; Fri, 30 Apr 2021 07:47:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=szeredi.hu; s=google;
        h=date:from:to:cc:subject:message-id:mime-version:content-disposition
         :content-transfer-encoding;
        bh=JQLmS5eHkwn6ByRBjLLlFMn3xy32m1iFJYz+x96wxCE=;
        b=PUkCAGlf1NCQAWJ1EjHeZR4YPIa7Co4t2eO8iAkTiWVfARHlRP9Q0hhUmJG+uRYK5n
         O5O246HDaOt9f+iN7Pn+xOVABnFDBz/G8NEcDPO4R7o3kPmvVj6p4jGOWq6dz6WGL2xZ
         2pZEKr5OgLY4shFybxxfaWmBt9oKyzbZi96eQ=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:mime-version
         :content-disposition:content-transfer-encoding;
        bh=JQLmS5eHkwn6ByRBjLLlFMn3xy32m1iFJYz+x96wxCE=;
        b=FOcaLmrRfs/FAhMHlJ0hLf/6pO1aJNsPSxpI0MJIlfipk5wpQOE3nmbQfPT83CyXDc
         JwEcDogsyuXeisC4PFw6QYfriySKLFTfSRHGFvHFt7pCRiRJ0HhONeGi5isBa+3UPyte
         Q3F/h+oLBbkRheytzSqGKg55J/GeIdCiCU594wh99hQfVJiCvpDvDwMHFH+objZRg42I
         ajQrzbhqrNLr/lVrw0dd3eI7SfAWShJ98Ue/QyCPWqwISML07r0bYV47TC9bfyDPz6uw
         ahILofLInNKVxTLwQpUgmniSWAeszOqpRBlJWrrREVecr/moakvibgE99lrN/LIqmEhY
         +M7w==
X-Gm-Message-State: AOAM533+aoMc1uUxp1JmJoIXvWodBxMZMLTJgDeCLiM2PEm2cGfupJ34
        gsrIU9RKjX17jG5LCep7g1WoHQ==
X-Google-Smtp-Source: ABdhPJzsab7bITvvSyivEQydDJ4lFuNpT2if0+5QPDVF06rOuKgGmlPrZVDMi7W45mEzy0vDX6pnkA==
X-Received: by 2002:aa7:c510:: with SMTP id o16mr6424915edq.310.1619794061649;
        Fri, 30 Apr 2021 07:47:41 -0700 (PDT)
Received: from miu.piliscsaba.redhat.com (catv-86-101-169-67.catv.broadband.hu. [86.101.169.67])
        by smtp.gmail.com with ESMTPSA id b22sm1424015edv.96.2021.04.30.07.47.40
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 30 Apr 2021 07:47:41 -0700 (PDT)
Date:   Fri, 30 Apr 2021 16:47:38 +0200
From:   Miklos Szeredi <miklos@szeredi.hu>
To:     Linus Torvalds <torvalds@linux-foundation.org>
Cc:     linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        linux-unionfs@vger.kernel.org
Subject: [GIT PULL] overlayfs update for 5.13
Message-ID: <YIwYirYCIdcVUjk6@miu.piliscsaba.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-unionfs.vger.kernel.org>
X-Mailing-List: linux-unionfs@vger.kernel.org

Hi Linus,

Please pull from:

  git://git.kernel.org/pub/scm/linux/kernel/git/mszeredi/vfs.git tags/ovl-update-5.13

- Fix a regression introduced in 5.2 that resulted in valid overlayfs
  mounts being rejected with ELOOP (Too many levels of symbolic links).

- Fix bugs found by various tools.

- Miscallenous improvements and cleanups.

Thanks,
Miklos

---
Amir Goldstein (4):
      ovl: check that upperdir path is not on a read-only mount
      ovl: restrict lower null uuid for "xino=auto"
      ovl: invalidate readdir cache on changes to dir with origin
      ovl: add debug print to ovl_do_getxattr()

Bhaskar Chowdhury (1):
      ovl: trivial typo fixes in the file inode.c

Chengguang Xu (2):
      ovl: fix error for ovl_fill_super()
      ovl: do not copy attr several times

Dan Carpenter (1):
      ovl: fix missing revert_creds() on error path

Giuseppe Scrivano (1):
      ovl: show "userxattr" in the mount data

Mickaël Salaün (1):
      ovl: fix leaked dentry

Miklos Szeredi (1):
      ovl: allow upperdir inside lowerdir

Sargun Dhillon (1):
      ovl: plumb through flush method

Xiong Zhenwu (1):
      ovl: fix misspellings using codespell tool

youngjun (1):
      ovl: remove ovl_map_dev_ino() return value

---
 Documentation/filesystems/overlayfs.rst | 26 ++++++-------
 fs/overlayfs/copy_up.c                  |  3 +-
 fs/overlayfs/file.c                     | 21 +++++++++++
 fs/overlayfs/inode.c                    | 18 ++++-----
 fs/overlayfs/namei.c                    |  1 +
 fs/overlayfs/overlayfs.h                | 37 ++++++++++++++++--
 fs/overlayfs/readdir.c                  | 12 ------
 fs/overlayfs/super.c                    | 66 +++++++++++++++++++++++++--------
 fs/overlayfs/util.c                     | 33 +++++------------
 9 files changed, 136 insertions(+), 81 deletions(-)
