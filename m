Return-Path: <linux-unionfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-14.5 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 78B38C4338F
	for <linux-unionfs@archiver.kernel.org>; Wed, 18 Aug 2021 13:34:11 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 6116860F4C
	for <linux-unionfs@archiver.kernel.org>; Wed, 18 Aug 2021 13:34:11 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237716AbhHRNeo (ORCPT
        <rfc822;linux-unionfs@archiver.kernel.org>);
        Wed, 18 Aug 2021 09:34:44 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:34832 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S237534AbhHRNem (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Wed, 18 Aug 2021 09:34:42 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1629293647;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=9atu5PWpeWQekmjZpl8cMY0yO4zwVLTKAR4uiWOjOtw=;
        b=S5tOJG9vW8rPVAPpLjZj8bz995YpuMkZ/UcMvVb9d9DzyqqR5C4OfBgf8RXlquDE95cqOn
        fUEZofueTleWMSBc7wC0rdiZan6iTYvkzxT46HrnRyGsEFT0r2bPujJEzHcGpxgRrAqGo9
        ih2Y0W4LYzn72vNqrhVkYfHcS0Vhr2I=
Received: from mail-ed1-f72.google.com (mail-ed1-f72.google.com
 [209.85.208.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-423-T7wYy2_JNsqG_H39viBYSw-1; Wed, 18 Aug 2021 09:34:04 -0400
X-MC-Unique: T7wYy2_JNsqG_H39viBYSw-1
Received: by mail-ed1-f72.google.com with SMTP id u4-20020a50eac40000b02903bddc52675eso1052521edp.4
        for <linux-unionfs@vger.kernel.org>; Wed, 18 Aug 2021 06:34:04 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=9atu5PWpeWQekmjZpl8cMY0yO4zwVLTKAR4uiWOjOtw=;
        b=qnsXxhBiX6cY0Xif9vVSkj6WQM0ddLT/Ov7p2NqW+UV7pDspI29BfFoP5qdPDWNgeP
         tZHYVk61AxTjEE2HfpJN9gOAlJuEJD6smvhyV9SW+xrdKkpTz4bLNYH7zl6N9bCJs03q
         n7axo5ljy7K9dkMtwYJHuxcxOtgLqxdKu0KQ3/TyLIpKoPC2cLiR/+F+DYFzJVDisQse
         aO8lnUT7tI4hlCh6EzHe/5zbQXiPr2mQQBwQ2EeHQKFmGdz8vi7dcmf5/mUuG+9prG2u
         NjHC3IT3dH8C/ZGqL4Vsp7I7QHG7ci5hkOYShS6yP061HArVaNXWUPBk0rLyldEx7e9v
         dYmw==
X-Gm-Message-State: AOAM532PbXg1DhOS//gdcKcSeCTaRFHEVvlu65vkjLsOQXsulzKCpS2N
        debnO3+V3HvJhkRm3jOngyLYL7xPY/57LHwxK1gw5hlLUiP/F1PHDkNa77SdQELbMbcaQt7am/S
        9q9Zbq0mtcw7psIND9aGkOrX0MQ==
X-Received: by 2002:aa7:d319:: with SMTP id p25mr10394134edq.197.1629293643216;
        Wed, 18 Aug 2021 06:34:03 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJyRQYRpxw2Qhgc/ZAxOVdRSo4vUAvMeMIWE5ubx7bGW0c4xOeoVYQTT6WJ6FOemMkD1YFUpUQ==
X-Received: by 2002:aa7:d319:: with SMTP id p25mr10394085edq.197.1629293642713;
        Wed, 18 Aug 2021 06:34:02 -0700 (PDT)
Received: from miu.piliscsaba.redhat.com (catv-86-101-169-16.catv.broadband.hu. [86.101.169.16])
        by smtp.gmail.com with ESMTPSA id kg18sm2090922ejc.9.2021.08.18.06.34.01
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 18 Aug 2021 06:34:02 -0700 (PDT)
From:   Miklos Szeredi <mszeredi@redhat.com>
To:     Al Viro <viro@zeniv.linux.org.uk>,
        Linus Torvalds <torvalds@linux-foundation.org>
Cc:     linux-unionfs@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Andreas Gruenbacher <agruenba@redhat.com>
Subject: [PATCH v2 0/2] allow overlayfs to do RCU lookups
Date:   Wed, 18 Aug 2021 15:33:58 +0200
Message-Id: <20210818133400.830078-1-mszeredi@redhat.com>
X-Mailer: git-send-email 2.31.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-unionfs.vger.kernel.org>
X-Mailing-List: linux-unionfs@vger.kernel.org

I'd really like to fix this in some form, but not getting any response
[1][2][3].

Al, Linus, can you please comment?

I'm happy to take this through the overlayfs tree, just need an ACK for the
VFS API change.

Thanks,
Miklos

[1] https://lore.kernel.org/linux-fsdevel/20210323160629.228597-1-mszeredi@redhat.com/
[2] https://lore.kernel.org/linux-fsdevel/CAJfpegv4ttfCZY0DPm+SSc85eL5m3jqhdOS_avu1+WMZhdg7iA@mail.gmail.com/
[3] https://lore.kernel.org/linux-fsdevel/20210810120807.456788-1-mszeredi@redhat.com/

v2: just a minor fix for the CONFIG_FS_POSIX_ACL=n case.
---
Miklos Szeredi (2):
  vfs: add flags argument to ->get_acl() callback
  ovl: enable RCU'd ->get_acl()

 Documentation/filesystems/locking.rst |  2 +-
 Documentation/filesystems/vfs.rst     |  2 +-
 fs/9p/acl.c                           |  5 ++++-
 fs/9p/acl.h                           |  2 +-
 fs/bad_inode.c                        |  2 +-
 fs/btrfs/acl.c                        |  5 ++++-
 fs/btrfs/ctree.h                      |  2 +-
 fs/ceph/acl.c                         |  5 ++++-
 fs/ceph/super.h                       |  2 +-
 fs/erofs/xattr.c                      |  5 ++++-
 fs/erofs/xattr.h                      |  2 +-
 fs/ext2/acl.c                         |  5 ++++-
 fs/ext2/acl.h                         |  2 +-
 fs/ext4/acl.c                         |  5 ++++-
 fs/ext4/acl.h                         |  2 +-
 fs/f2fs/acl.c                         |  5 ++++-
 fs/f2fs/acl.h                         |  2 +-
 fs/fuse/acl.c                         |  5 ++++-
 fs/fuse/fuse_i.h                      |  2 +-
 fs/gfs2/acl.c                         |  5 ++++-
 fs/gfs2/acl.h                         |  2 +-
 fs/jffs2/acl.c                        |  5 ++++-
 fs/jffs2/acl.h                        |  2 +-
 fs/jfs/acl.c                          |  5 ++++-
 fs/jfs/jfs_acl.h                      |  2 +-
 fs/nfs/nfs3_fs.h                      |  2 +-
 fs/nfs/nfs3acl.c                      |  5 ++++-
 fs/ocfs2/acl.c                        |  5 ++++-
 fs/ocfs2/acl.h                        |  2 +-
 fs/orangefs/acl.c                     |  5 ++++-
 fs/orangefs/orangefs-kernel.h         |  2 +-
 fs/overlayfs/inode.c                  |  6 +++++-
 fs/overlayfs/overlayfs.h              |  2 +-
 fs/posix_acl.c                        | 10 ++++++++--
 fs/reiserfs/acl.h                     |  2 +-
 fs/reiserfs/xattr_acl.c               |  5 ++++-
 fs/xfs/xfs_acl.c                      |  5 ++++-
 fs/xfs/xfs_acl.h                      |  4 ++--
 include/linux/fs.h                    |  7 ++++++-
 include/linux/posix_acl.h             |  3 ++-
 40 files changed, 106 insertions(+), 42 deletions(-)

-- 
2.31.1

