Return-Path: <linux-unionfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B34CAC4167B
	for <linux-unionfs@archiver.kernel.org>; Mon, 12 Dec 2022 11:08:12 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231260AbiLLLIK (ORCPT
        <rfc822;linux-unionfs@archiver.kernel.org>);
        Mon, 12 Dec 2022 06:08:10 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52570 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231536AbiLLLHY (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Mon, 12 Dec 2022 06:07:24 -0500
Received: from mail-ej1-x62e.google.com (mail-ej1-x62e.google.com [IPv6:2a00:1450:4864:20::62e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 91A3F11C0E
        for <linux-unionfs@vger.kernel.org>; Mon, 12 Dec 2022 02:56:15 -0800 (PST)
Received: by mail-ej1-x62e.google.com with SMTP id vv4so26940449ejc.2
        for <linux-unionfs@vger.kernel.org>; Mon, 12 Dec 2022 02:56:15 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=szeredi.hu; s=google;
        h=content-disposition:mime-version:message-id:subject:cc:to:from:date
         :from:to:cc:subject:date:message-id:reply-to;
        bh=sUJ5cvuCsGK8YGIL2fUMIgBzFaSAkYgBHiJvuOvGsag=;
        b=UzwWO/goR1hVNGn165QBf2OGcAY+wwDHNMH9vgOU7ZEDy0WMopnshPMZW5BWLKcZls
         zDx5YjKL3tqHm2U0ki5mvpUZUpEmAcl5WYNKWbLJ6E41F3l5JvTq8U7Mxebo9Kg1kDMh
         mfylwJ5mKFk/DcVAgwCVMSqsJvWMH802dmTZA=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-disposition:mime-version:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=sUJ5cvuCsGK8YGIL2fUMIgBzFaSAkYgBHiJvuOvGsag=;
        b=NZui774cV8uCCgnHkJbhnYZ1BD3fyrmCmBt9UtAMUNYC1FiSKjYYbYYYjsuXDyqAoK
         GGdN1jxEF8X5MSoqBZGtBf31DPy+WI4HpJmLy1rI30KKDw0LzJjr9SKtL3JElDf3/f3y
         nJh9NoLJZVExH4vb6jTBFFz0y/Z+tuXP2FIRe6jLHwjT88P11yXyHfqN5Y7fOxerTa+f
         u/vxA8EEpvOjxiNRJdXsOVsCtCdJ/VXbC/w4tv059AwRIoTIsHS9vJJsenlYum6d9ENL
         pg3RM5fuaIgqhmDxMOJmdW5kTHvhYEPv19uGYUsIWqgJYFX/dPj7pSA3J7Y+SPB7MDYF
         eDFQ==
X-Gm-Message-State: ANoB5plzaj81v6Xt6gcHv5hhvDy4nSbuAUbR3NGmzF7qf9n5G3nikxjg
        NZVAiNVF5C7jY7p3Dg/jCBOPMQ==
X-Google-Smtp-Source: AA0mqf6QIcYu5BUKcyXNA3ylKVdp/HuLErE5ZfNLmUTMoY4QP0E3qyfe4lWhXF+OkPxUAAlhXbiWHQ==
X-Received: by 2002:a17:906:71c2:b0:7ba:9c18:1205 with SMTP id i2-20020a17090671c200b007ba9c181205mr9922913ejk.50.1670842574188;
        Mon, 12 Dec 2022 02:56:14 -0800 (PST)
Received: from miu.piliscsaba.redhat.com (193-226-215-206.pool.digikabel.hu. [193.226.215.206])
        by smtp.gmail.com with ESMTPSA id k4-20020a170906970400b007aea1dc1840sm3141236ejx.111.2022.12.12.02.56.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 12 Dec 2022 02:56:13 -0800 (PST)
Date:   Mon, 12 Dec 2022 11:56:06 +0100
From:   Miklos Szeredi <miklos@szeredi.hu>
To:     Linus Torvalds <torvalds@linux-foundation.org>
Cc:     linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        linux-unionfs@vger.kernel.org
Subject: [GIT PULL] overlayfs update for 6.2
Message-ID: <Y5cIxrmoeQSCJMlQ@miu.piliscsaba.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Precedence: bulk
List-ID: <linux-unionfs.vger.kernel.org>
X-Mailing-List: linux-unionfs@vger.kernel.org

Hi Linus,

Please pull from:

  git://git.kernel.org/pub/scm/linux/kernel/git/mszeredi/vfs.git tags/ovl-update-6.2

 - Fix a couple of bugs found by syzbot

 - Don't ingore some open flags set by fcntl(F_SETFL)

 - Fix failure to create a hard link in certain cases

 - Use type safe helpers for some mnt_userns transformations

 - Improve performance of mount

 - Misc cleanups

Thanks,
Miklos

---
Al Viro (1):
      ovl: update ->f_iocb_flags when ovl_change_flags() modifies ->f_flags

Amir Goldstein (2):
      ovl: do not reconnect upper index records in ovl_indexdir_cleanup()
      ovl: use plain list filler in indexdir and workdir cleanup

Chen Zhongjin (1):
      ovl: fix use inode directly in rcu-walk mode

Christian Brauner (1):
      ovl: port to vfs{g,u}id_t and associated helpers

Colin Ian King (1):
      ovl: Kconfig: Fix spelling mistake "undelying" -> "underlying"

Jiangshan Yi (1):
      ovl: fix comment typos

Kees Cook (1):
      ovl: Use "buf" flexible array for memcpy() destination

Miklos Szeredi (1):
      ovl: use inode instead of dentry where possible

Stanislav Goriainov (1):
      ovl: Add comment on upperredirect reassignment

Zhang Tianci (1):
      ovl: Use ovl mounter's fsuid and fsgid in ovl_link()

---
 fs/overlayfs/Kconfig     |  2 +-
 fs/overlayfs/dir.c       | 46 +++++++++++++++++++++++++-------------
 fs/overlayfs/export.c    |  8 +++----
 fs/overlayfs/file.c      |  3 ++-
 fs/overlayfs/namei.c     | 12 +++++++---
 fs/overlayfs/overlayfs.h | 11 ++++-----
 fs/overlayfs/readdir.c   | 58 ++++++++++++++++++++++--------------------------
 fs/overlayfs/super.c     |  7 +++++-
 fs/overlayfs/util.c      | 15 ++++++++-----
 9 files changed, 93 insertions(+), 69 deletions(-)
