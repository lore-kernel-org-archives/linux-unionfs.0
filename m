Return-Path: <linux-unionfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 808BBC00140
	for <linux-unionfs@archiver.kernel.org>; Mon,  8 Aug 2022 12:20:18 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242339AbiHHMUR (ORCPT
        <rfc822;linux-unionfs@archiver.kernel.org>);
        Mon, 8 Aug 2022 08:20:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45842 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239232AbiHHMUQ (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Mon, 8 Aug 2022 08:20:16 -0400
Received: from mail-wr1-x42f.google.com (mail-wr1-x42f.google.com [IPv6:2a00:1450:4864:20::42f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 384B2250
        for <linux-unionfs@vger.kernel.org>; Mon,  8 Aug 2022 05:20:12 -0700 (PDT)
Received: by mail-wr1-x42f.google.com with SMTP id j7so10710712wrh.3
        for <linux-unionfs@vger.kernel.org>; Mon, 08 Aug 2022 05:20:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=szeredi.hu; s=google;
        h=date:from:to:cc:subject:message-id:mime-version:content-disposition;
        bh=EGJh6H4Q+/4Jo4xNeP066GXEwQs4C4KMootOF9X7m5E=;
        b=m0qzJA/eP/VqrChusdQ4L8wxmlBRjqB1YRFbmJndfdkiQbKMoJKc+AEViatMKM3Png
         9E3SiqQXL6dLmfKG65A9rBnCsuEipXMZ7mmzY6C0vA0prs4C+YMj+qBIVJDr1oAZgNGi
         OmrhFHKz7YCVGe6CNhJzWTUM0EQVbEWv6FMS4=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:mime-version
         :content-disposition;
        bh=EGJh6H4Q+/4Jo4xNeP066GXEwQs4C4KMootOF9X7m5E=;
        b=VObX9oE7cGRuVSS2GhIOTb3/zit+I/nFLFxmA7PRVE6ZIifmMHroQaWwX4c0HTQeJR
         gX7XhoX8gyFoB/hpHQEbHGjfab79httn1uyMhiEYY1Hl7PoYBjywssTSfjsdLItZN8JY
         0L4tfFkGZRyPCblpc9uzqOB8rB3O6hygk+2KJvTkOrIWEFOJNHMOqt8RAtzZj+KPeDA5
         BZnIeqa+kqH1xbN96++hI6/+7ub6RL/WtP6cg+firkIEEdbWPFI5dQWttLyWCVX1TVLO
         kJO6qXNWEH1WqLtPHmK8Ud+/UU1fkw1vhqEZ+prgl+nU+8SZUnIWmLBC4ynK/lvaLwqA
         MPSw==
X-Gm-Message-State: ACgBeo0OA3JrkLzRBO3maCx8sl82/fsdnl0+v/Dp4fp/MasPQpIs3tiw
        kAB/0bFpHZ6a512z8542Tlt2Twy038y5ow==
X-Google-Smtp-Source: AA6agR60elkz35zB7183HO8LE91+Te3/f/Ds1v/OD1bLTXqK+UVHlZSUlbrlcejfmICbANVtDEPA3A==
X-Received: by 2002:adf:fc47:0:b0:220:5f01:6a10 with SMTP id e7-20020adffc47000000b002205f016a10mr11672087wrs.7.1659961210759;
        Mon, 08 Aug 2022 05:20:10 -0700 (PDT)
Received: from miu.piliscsaba.redhat.com (87-97-117-187.pool.digikabel.hu. [87.97.117.187])
        by smtp.gmail.com with ESMTPSA id f7-20020a5d6647000000b002217aed23b4sm8150586wrw.12.2022.08.08.05.20.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 08 Aug 2022 05:20:09 -0700 (PDT)
Date:   Mon, 8 Aug 2022 14:20:02 +0200
From:   Miklos Szeredi <miklos@szeredi.hu>
To:     Linus Torvalds <torvalds@linux-foundation.org>
Cc:     linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        linux-unionfs@vger.kernel.org
Subject: [GIT PULL] overlayfs update for 6.0
Message-ID: <YvD/cnBLsE8P8sWS@miu.piliscsaba.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Precedence: bulk
List-ID: <linux-unionfs.vger.kernel.org>
X-Mailing-List: linux-unionfs@vger.kernel.org

Hi Linus,

Please pull from:

  git://git.kernel.org/pub/scm/linux/kernel/git/mszeredi/vfs.git tags/ovl-update-6.0

This is just a small update.

There's a merge conflict with the mnt-userns series from Christian.  This should
be resolved by moving the "#ifdef CONFIG_FS_POSIX_ACL" up, to include the newly
introduced ovl_idmap_posix_acl() helper.

Thanks,
Miklos

---
Jiachen Zhang (1):
      ovl: drop WARN_ON() dentry is NULL in ovl_encode_fh()

Miklos Szeredi (1):
      ovl: warn if trusted xattr creation fails

William Dean (1):
      ovl: fix spelling mistakes

Yang Li (1):
      ovl: fix some kernel-doc comments

Yang Xu (1):
      ovl: improve ovl_get_acl() if POSIX ACL support is off

---
 fs/overlayfs/export.c    |  2 +-
 fs/overlayfs/inode.c     |  4 +++-
 fs/overlayfs/namei.c     |  4 ++--
 fs/overlayfs/overlayfs.h |  6 ++++++
 fs/overlayfs/super.c     | 13 +++++++++----
 5 files changed, 21 insertions(+), 8 deletions(-)
