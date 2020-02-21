Return-Path: <SRS0=Fd6Y=4J=vger.kernel.org=linux-unionfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.6 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A7B79C35656
	for <linux-unionfs@archiver.kernel.org>; Fri, 21 Feb 2020 14:34:56 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 79BF4222C4
	for <linux-unionfs@archiver.kernel.org>; Fri, 21 Feb 2020 14:34:56 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="YxY0KUE3"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728068AbgBUOe4 (ORCPT
        <rfc822;linux-unionfs@archiver.kernel.org>);
        Fri, 21 Feb 2020 09:34:56 -0500
Received: from mail-wm1-f68.google.com ([209.85.128.68]:35296 "EHLO
        mail-wm1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727096AbgBUOe4 (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Fri, 21 Feb 2020 09:34:56 -0500
Received: by mail-wm1-f68.google.com with SMTP id b17so2141710wmb.0
        for <linux-unionfs@vger.kernel.org>; Fri, 21 Feb 2020 06:34:54 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=fUcbFrPQZRCJvjd/tM9PNxvqr/Sk2jicB9eKVju7TZQ=;
        b=YxY0KUE3kYBBKD9TI4oa2/LAHVwGZf4aNzdig/Md0Dxxi/3cTHy/YjNFVK13uSHGSb
         N9nQJbJBOzr0YXE9hZy+DOrve6/y6iz44m1HQO48rATFd28qLXKvv0lQpf3C11Uv88lw
         KPIiYeEpdkkvF/+/Sc9DwKID0+n8RPtl89Nk+ifWj/JvjhELDqnIYuCMhVkuJhs0E8St
         Ud0RNot4ioTmq5NZqMch5I+zpMKT1w6I40KvNlZmWardnDsLTPkG1jSvEJPt9H+u4aeg
         2s7nvEoDkZ8wRT5CSORrdd3goP+hvRxd7mr7fgoSvxFlm104sZZK6k0xP17gMrYrLpWu
         eboA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=fUcbFrPQZRCJvjd/tM9PNxvqr/Sk2jicB9eKVju7TZQ=;
        b=h68SIeCqkk8GA3c5yem8JWwZN03WF/iwpBj5G+SYF+YUtFk2uza80D1EiNKBx1pRSa
         fz4l0OW71/FvOFaJ7qvatOWAqmc7clwSmN6fhRYrSfjLUF9nen1nEwLSVJBriMrgEx2x
         myP+bIugE20fmayOocShdJr79IBPVnNDfoMyWwQt2tEo5+vkUaOlAgk1wUiOIto+H0TV
         2a3bEU7IpB+O/175NSIhjf00NI94D/wQ2F/+xpYX4rBy2H2Qn7/+9kGHIyAJgEw67FHL
         ZYo8FbeLoakY5KCuHr6rlMWzPoekqEQye9gCHLLuaESABi9+xB9VNkUvOPXrH/m/75Kg
         FccA==
X-Gm-Message-State: APjAAAV2Q4yFb+q9S6e7TyledTVbVCiUpTOdLfsLqBSjADj8CzbrrtaT
        3/JxBDnKCM9MY4sThzXWBA0=
X-Google-Smtp-Source: APXvYqyfmUiSO8FgYOZx1iprZxCUShZHM8Y2kjBnUzX98uumVZuiCysQiMorpb2JPXrp1HdkCGu44g==
X-Received: by 2002:a7b:c759:: with SMTP id w25mr4183036wmk.15.1582295693895;
        Fri, 21 Feb 2020 06:34:53 -0800 (PST)
Received: from localhost.localdomain ([141.226.9.174])
        by smtp.gmail.com with ESMTPSA id a184sm4109014wmf.29.2020.02.21.06.34.52
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 21 Feb 2020 06:34:53 -0800 (PST)
From:   Amir Goldstein <amir73il@gmail.com>
To:     Miklos Szeredi <miklos@szeredi.hu>
Cc:     linux-unionfs@vger.kernel.org
Subject: [PATCH v2 0/5] Misc overlay ino issues
Date:   Fri, 21 Feb 2020 16:34:41 +0200
Message-Id: <20200221143446.9099-1-amir73il@gmail.com>
X-Mailer: git-send-email 2.17.1
Sender: linux-unionfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-unionfs.vger.kernel.org>
X-Mailing-List: linux-unionfs@vger.kernel.org

Miklos,

This is v2 of the ino patches.
v1 is here [1]. I reabsed to overlayfs-next and addressed
your comments on the ino collision patch.

The branch passes overlay xfstests including the new tests 07[01]
that I wrote to test this series.

Note that i_ino uses the private atomic counter not only for xino
overflow case, but also for non-samefs with xino disabled, but it is
only used for directory inodes. I don't think that should cause any
performance regressions and the kernel gets rid of a potentially
massive abuser of the global get_next_ino() pool.

Thanks,
Amir.

Changes since v1:
- Cleanup patches merged
- Use private atomic counter for non-persistent ino
- Don't abuse i_generation
- Keep fsid an index to fs array (fewer magic shifts)
- Added xino_mode fix patch (for v5.6), which includes disabling xino
  on 32bit kernel

[1] https://lore.kernel.org/linux-unionfs/20200101175814.14144-1-amir73il@gmail.com/

Amir Goldstein (5):
  ovl: fix some xino configurations
  ovl: use a private non-persistent ino pool
  ovl: avoid possible inode number collisions with xino=on
  ovl: enable xino automatically in more cases
  ovl: document xino expected behavior

 Documentation/filesystems/overlayfs.rst | 38 +++++++++++++++-
 fs/overlayfs/Kconfig                    |  1 +
 fs/overlayfs/inode.c                    | 58 ++++++++++++++++++-------
 fs/overlayfs/overlayfs.h                | 16 +++++++
 fs/overlayfs/ovl_entry.h                |  2 +
 fs/overlayfs/readdir.c                  | 25 ++++++++---
 fs/overlayfs/super.c                    | 35 ++++++++-------
 7 files changed, 136 insertions(+), 39 deletions(-)

-- 
2.17.1

