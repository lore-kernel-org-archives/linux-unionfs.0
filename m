Return-Path: <linux-unionfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C6602C4332F
	for <linux-unionfs@archiver.kernel.org>; Tue, 14 Nov 2023 15:33:03 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233647AbjKNPdF (ORCPT
        <rfc822;linux-unionfs@archiver.kernel.org>);
        Tue, 14 Nov 2023 10:33:05 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51266 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232277AbjKNPdE (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Tue, 14 Nov 2023 10:33:04 -0500
Received: from mail-wm1-x334.google.com (mail-wm1-x334.google.com [IPv6:2a00:1450:4864:20::334])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6E9AEED
        for <linux-unionfs@vger.kernel.org>; Tue, 14 Nov 2023 07:33:01 -0800 (PST)
Received: by mail-wm1-x334.google.com with SMTP id 5b1f17b1804b1-4083f61312eso47586515e9.3
        for <linux-unionfs@vger.kernel.org>; Tue, 14 Nov 2023 07:33:01 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1699975980; x=1700580780; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=7nqa9o4c+gpu0UWvrG+3y9dNQVSnLE0jJX9P0bwTtOI=;
        b=DY/lzXWyGCnYl0jHSB11rgCxLuECcsIw+uOaPErnS1e0NoU8WUC12uaPoUfkB0MtBW
         yp6sa84Ehb8Id6hX3ueE8HdlM3y9Tz67Mf/6LeYagMKpepLs1v2nRRXm5ON3OCnogz+b
         ncibvHTIrOFKNtse6ywMGR2dZDWoPSJnvnj/Qv8LESsoZw2yg3jdNy8Wjm6tsl8+KCWy
         h1VpG0aZ8j214qP7DH4cbjeEwRNtlPtZ3TzQhEKOxNg8NOTA+0gS13xHnMFvU0H9C4Nv
         Gi15UU/xTD+fDuQdlnZgZrI+/aVcaHMJ9CQhzm2GZw1xOGMM8sJUyAERHCEkeHd7lroU
         tMnw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1699975980; x=1700580780;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=7nqa9o4c+gpu0UWvrG+3y9dNQVSnLE0jJX9P0bwTtOI=;
        b=eJtkvand71NK3NMBz0NLPer6W+ZQPviQVgRu1PkonOYWL+v5qtCh7rlAa5Nih9J0H3
         aTa0L6ftQqqewsmRuIh2lyWnoC/W40KnQoz98ZI7v+CYe0VByRDiDQ8S4ui7MG325xX7
         us7Nk4/ebiJHo8JAh6pf3mzHHJcGLoaY9GCdLhkYc+qa9dDBZz347QAjZjkOQgesmUHa
         hnEoOOU/bi8GVHX2fIgqfkBXazw3ookBYoOkSPiIGGqf4PEjjkC4G7tHTJuniLTsG9x/
         Mmgs6i1NwGMIdWxMQ9WVwvL0Hzz2jujhAGbTopTq44sisLQ60xmwjWSJI7ixttIJAVgU
         1pJg==
X-Gm-Message-State: AOJu0YzdH9P55u/wH24Wu19REEVZWEcQqLYYh0+VKyWl9PNgxZHOd0LQ
        xXHWMIC9BF0e+ffMb+kMgtA=
X-Google-Smtp-Source: AGHT+IG749IaXrE4BZvAMHrIXU6p+aHFgHfOnG1LPFv1SSnXoNrfeFBg9+hWixi2xyDQToWk0pIWDA==
X-Received: by 2002:a05:600c:4689:b0:402:f5c4:2e5a with SMTP id p9-20020a05600c468900b00402f5c42e5amr8496957wmo.37.1699975979535;
        Tue, 14 Nov 2023 07:32:59 -0800 (PST)
Received: from amir-ThinkPad-T480.lan ([5.29.249.86])
        by smtp.gmail.com with ESMTPSA id i10-20020a05600c354a00b004053e9276easm17824505wmq.32.2023.11.14.07.32.58
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 14 Nov 2023 07:32:59 -0800 (PST)
From:   Amir Goldstein <amir73il@gmail.com>
To:     Miklos Szeredi <miklos@szeredi.hu>
Cc:     Christian Brauner <brauner@kernel.org>,
        linux-unionfs@vger.kernel.org
Subject: [PATCH 00/15] Tidy up file permission hooks
Date:   Tue, 14 Nov 2023 17:32:39 +0200
Message-Id: <20231114153254.1715969-1-amir73il@gmail.com>
X-Mailer: git-send-email 2.34.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-unionfs.vger.kernel.org>
X-Mailing-List: linux-unionfs@vger.kernel.org

Hi Christian,

I realize you won't have time to review this week, but wanted to get
this series out for review for a wider audience soon.

During my work on fanotify "pre content" events [1], Jan and I noticed
some inconsistencies in the call sites of security_file_permission()
hooks inside rw_verify_area() and remap_verify_area().

The majority of call sites are before file_start_write(), which is how
we want them to be for fanotify "pre content" events.

For splice code, there are many duplicate calls to rw_verify_area()
for the entire range as well as for partial ranges inside iterator.

This cleanup series, mostly following Jan's suggestions, moves all
the security_file_permission() hooks before file_start_write() and
eliminates duplicate permission hook calls in the same call chain.

The last 3 patches are helpers that I used in fanotify patches to
assert that permission hooks are called with expected locking scope.

My hope is to get this work reviewed and staged in the vfs tree
for the 6.8 cycle, so that I can send Jan fanotify patches for
"pre content" events based on a stable branch in the vfs tree.

Thanks,
Amir.

[1] https://github.com/amir73il/linux/commits/fan_pre_content

Amir Goldstein (15):
  ovl: add permission hooks outside of do_splice_direct()
  splice: remove permission hook from do_splice_direct()
  splice: move permission hook out of splice_direct_to_actor()
  splice: move permission hook out of splice_file_to_pipe()
  splice: remove permission hook from iter_file_splice_write()
  remap_range: move permission hooks out of do_clone_file_range()
  remap_range: move file_start_write() to after permission hook
  btrfs: move file_start_write() to after permission hook
  fs: move file_start_write() into vfs_iter_write()
  fs: move permission hook out of do_iter_write()
  fs: move permission hook out of do_iter_read()
  fs: move kiocb_start_write() into vfs_iocb_iter_write()
  fs: create __sb_write_started() helper
  fs: create file_write_started() helper
  fs: create {sb,file}_write_not_started() helpers

 drivers/block/loop.c   |   2 -
 fs/btrfs/ioctl.c       |  12 +--
 fs/cachefiles/io.c     |   2 -
 fs/coda/file.c         |   4 +-
 fs/internal.h          |   8 +-
 fs/nfsd/vfs.c          |   7 +-
 fs/overlayfs/copy_up.c |  26 ++++++-
 fs/overlayfs/file.c    |   3 -
 fs/read_write.c        | 164 +++++++++++++++++++++++++++--------------
 fs/remap_range.c       |  48 ++++++------
 fs/splice.c            |  78 ++++++++++++--------
 include/linux/fs.h     |  62 +++++++++++++++-
 12 files changed, 279 insertions(+), 137 deletions(-)

-- 
2.34.1

