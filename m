Return-Path: <linux-unionfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.6 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 152C7C433DB
	for <linux-unionfs@archiver.kernel.org>; Thu,  4 Feb 2021 09:20:40 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id B683F64F4D
	for <linux-unionfs@archiver.kernel.org>; Thu,  4 Feb 2021 09:20:39 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234874AbhBDJUf (ORCPT
        <rfc822;linux-unionfs@archiver.kernel.org>);
        Thu, 4 Feb 2021 04:20:35 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44392 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234755AbhBDJUd (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Thu, 4 Feb 2021 04:20:33 -0500
Received: from mail-ej1-x62a.google.com (mail-ej1-x62a.google.com [IPv6:2a00:1450:4864:20::62a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A558BC061573
        for <linux-unionfs@vger.kernel.org>; Thu,  4 Feb 2021 01:19:52 -0800 (PST)
Received: by mail-ej1-x62a.google.com with SMTP id p20so4102224ejb.6
        for <linux-unionfs@vger.kernel.org>; Thu, 04 Feb 2021 01:19:52 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=szeredi.hu; s=google;
        h=date:from:to:cc:subject:message-id:mime-version:content-disposition;
        bh=8lxogqlMZgpD9J7gbgqwGDjE7NKX9NOMGrM6eS5WeBQ=;
        b=QdCtg961nF58oQwzzj/FzDEuBgWW7M25dZnVjXoEgymQXTCxy0678cMv6XetCZpUaZ
         qGUlVnZB3LpsWGlT71eX2hazbFGUU2pF0XcdLR33Ivk89k8hrz5XdRrgSaJhJCaZhyfT
         OdwMZ5PMaqR3dd5Kq5eizc2wWsP0JYooM+DK4=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:mime-version
         :content-disposition;
        bh=8lxogqlMZgpD9J7gbgqwGDjE7NKX9NOMGrM6eS5WeBQ=;
        b=LZg7xCQNpnAzpETISX7Airnr1W/umbMYEO+t0VScOrVsw6ou5CypUsHMSYSI1j7Kb9
         snz1Idihg7NQEEiqz4J7qb394bjf/Ij+wJ+SNP86w4UGC5Y8l9Is3XvStfBRB9FV4Gl/
         5AkS9cdkOCf6y78aRO2doDioywperJNlPNWpj6aqH3vtDdNK08NhIXR9n8SbmkTo8jqO
         sm+4iZqTYBe0HzNxWRqnKrqGqovQhAlSpkn/P+RvG2+pnSrnKSx3/AybHE8ob7lQroWC
         1QxNzK4QlkLZD7ayR3fbxckzV1vRlYoOyhQalDfGKHWQ2xbYNED2SyTKI6PgDvuLa7C3
         dXcQ==
X-Gm-Message-State: AOAM532MuXbBEXiVaJ5xB+UpcfrToLu7oBclpgEdQQszx9JRwsu68i6z
        Ym5IYwLLDw/m1lkbYP7DTa2vaA==
X-Google-Smtp-Source: ABdhPJzueTAe+j4RnxD8AuLmdsIejqrJgdfclHJVHYp18QuH68ItotqE3diVPpuh2mkrAQoj3CScEw==
X-Received: by 2002:a17:906:2d0:: with SMTP id 16mr7353415ejk.373.1612430391385;
        Thu, 04 Feb 2021 01:19:51 -0800 (PST)
Received: from miu.piliscsaba.redhat.com (catv-86-101-169-67.catv.broadband.hu. [86.101.169.67])
        by smtp.gmail.com with ESMTPSA id k26sm2255486eds.41.2021.02.04.01.19.50
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 04 Feb 2021 01:19:50 -0800 (PST)
Date:   Thu, 4 Feb 2021 10:19:43 +0100
From:   Miklos Szeredi <miklos@szeredi.hu>
To:     Linus Torvalds <torvalds@linux-foundation.org>
Cc:     linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        linux-unionfs@vger.kernel.org
Subject: [GIT PULL] overlayfs fixes for 5.11-rc7
Message-ID: <20210204091943.GA1208880@miu.piliscsaba.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Precedence: bulk
List-ID: <linux-unionfs.vger.kernel.org>
X-Mailing-List: linux-unionfs@vger.kernel.org

Hi Linus,

Please pull from:

  git://git.kernel.org/pub/scm/linux/kernel/git/mszeredi/vfs.git tags/ovl-fixes-5.11-rc7

- Fix capability conversion and minor overlayfs bugs that are related to
  the unprivileged overlay mounts introduced in this cycle.

- Fix two recent (v5.10) and one old (v4.10) bug.

- Clean up security xattr copy-up (related to a SELinux regression).

Thanks,
Miklos

---
Amir Goldstein (1):
      ovl: skip getxattr of security labels

Liangyan (1):
      ovl: fix dentry leak in ovl_get_redirect

Miklos Szeredi (4):
      ovl: add warning on user_ns mismatch
      ovl: perform vfs_getxattr() with mounter creds
      cap: fix conversions on getxattr
      ovl: avoid deadlock on directory ioctl

Sargun Dhillon (1):
      ovl: implement volatile-specific fsync error behaviour

---
 Documentation/filesystems/overlayfs.rst |  8 ++++
 fs/overlayfs/copy_up.c                  | 15 ++++----
 fs/overlayfs/dir.c                      |  2 +-
 fs/overlayfs/file.c                     |  5 ++-
 fs/overlayfs/inode.c                    |  2 +
 fs/overlayfs/overlayfs.h                |  1 +
 fs/overlayfs/ovl_entry.h                |  2 +
 fs/overlayfs/readdir.c                  | 28 +++++---------
 fs/overlayfs/super.c                    | 38 +++++++++++++++----
 fs/overlayfs/util.c                     | 27 +++++++++++++
 security/commoncap.c                    | 67 +++++++++++++++++++++------------
 11 files changed, 136 insertions(+), 59 deletions(-)
