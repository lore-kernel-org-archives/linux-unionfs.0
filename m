Return-Path: <SRS0=9nie=3Y=vger.kernel.org=linux-unionfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.6 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,
	SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BCCF0C2D0B1
	for <linux-unionfs@archiver.kernel.org>; Tue,  4 Feb 2020 09:38:08 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 66FC32166E
	for <linux-unionfs@archiver.kernel.org>; Tue,  4 Feb 2020 09:38:08 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=szeredi.hu header.i=@szeredi.hu header.b="c3HyYDUI"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726371AbgBDJiI (ORCPT
        <rfc822;linux-unionfs@archiver.kernel.org>);
        Tue, 4 Feb 2020 04:38:08 -0500
Received: from mail-wr1-f67.google.com ([209.85.221.67]:41055 "EHLO
        mail-wr1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726189AbgBDJiH (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Tue, 4 Feb 2020 04:38:07 -0500
Received: by mail-wr1-f67.google.com with SMTP id c9so22060500wrw.8
        for <linux-unionfs@vger.kernel.org>; Tue, 04 Feb 2020 01:38:06 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=szeredi.hu; s=google;
        h=date:from:to:cc:subject:message-id:mime-version:content-disposition;
        bh=e5s/Q23XRpHERwC1HKAUufLzjK03duCrqO+369/xdRI=;
        b=c3HyYDUIGCbmwQ5RaeLCIJycSm4cMOB66f/2kKiMuRLJTm24fr41E1eXQxJ1zqo4Yx
         NUQJEZ3Umg1ED29rwJSTq2Yk5yA3hosYHHIdgqX1R8WAn05DbbrbAuhMWC3BH1D0uAgr
         3I5l22FpO8BZpBOcHPKbvzgoVgMUgG2dVa86w=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:mime-version
         :content-disposition;
        bh=e5s/Q23XRpHERwC1HKAUufLzjK03duCrqO+369/xdRI=;
        b=O99J9taXGujOsXjWlh07llJCI2WTATQTQ2wb29BQdoPVzfJmwqNK12+tHYFHcxQs9m
         7JRNSGTlrF9RMwlCrxIouOGqFwSZVlJ5cJPPQ+9jpKmolRSZ4wY9PRnt6QxuiMvKQ/5u
         YgLeUEhuN7nduwKreYit64bxRpmPgEx8J0I5DlOS+Vtiqux8UC/nu0bVkI1M7RaPqP2i
         tKJCte1Ll7wykqo8ltxRcmcB4NQTEe+ZaMf5MxTK1s5FIDD+cDJJkigyjIM/NGqO9vq9
         yt7vNF2QyY3MymZXHEGUJRTs110GIuuXeeZPb9F/TI+5yCANZrTBWZB2QAEsT2LNI8Sh
         hfyw==
X-Gm-Message-State: APjAAAXlAnSYn+TcrOUwhaKOAFQKVTWu7iJ0TSUqcir2cLwH8vQI4ywb
        cSjzDHA8VW4qJdg25ffMqiOa8g==
X-Google-Smtp-Source: APXvYqxW87pKKm2TvO78Y86M0lFamfULzYlYMSdsk4xK82w+66DdZ6UUma7qqkMTNUZqOePUX84daQ==
X-Received: by 2002:adf:b310:: with SMTP id j16mr21346890wrd.361.1580809086295;
        Tue, 04 Feb 2020 01:38:06 -0800 (PST)
Received: from miu.piliscsaba.redhat.com (84-236-3-252.pool.digikabel.hu. [84.236.3.252])
        by smtp.gmail.com with ESMTPSA id e18sm28387698wrw.70.2020.02.04.01.38.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 04 Feb 2020 01:38:04 -0800 (PST)
Date:   Tue, 4 Feb 2020 10:37:58 +0100
From:   Miklos Szeredi <miklos@szeredi.hu>
To:     Linus Torvalds <torvalds@linux-foundation.org>
Cc:     linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        linux-unionfs@vger.kernel.org
Subject: [GIT PULL] overlayfs update for 5.6
Message-ID: <20200204093758.GA7822@miu.piliscsaba.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: linux-unionfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-unionfs.vger.kernel.org>
X-Mailing-List: linux-unionfs@vger.kernel.org

Hi Linus,

Please pull from:

  git://git.kernel.org/pub/scm/linux/kernel/git/mszeredi/vfs.git tags/ovl-update-5.6

- Try and preserve holes in sparse files when copying up, thus saving disk
  space and improving performance.

- Fix a performance regression introduced in v4.19 by preserving
  asynchronicity of IO when fowarding to underlying layers.  Add VFS
  helpers to submit async iocbs.

- Fix a regression in lseek(2) introduced in v4.19 that breaks >2G seeks on
  32bit kernels.

- Fix a corner case where st_ino/st_dev was not preserved across copy up.

- Miscellaneous fixes and cleanups.

Thanks,
Miklos

---
Amir Goldstein (7):
      ovl: fix wrong WARN_ON() in ovl_cache_update_ino()
      ovl: use ovl_inode_lock in ovl_llseek()
      ovl: generalize the lower_layers[] array
      ovl: simplify ovl_same_sb() helper
      ovl: generalize the lower_fs[] array
      ovl: fix corner case of conflicting lower layer uuid
      ovl: fix corner case of non-constant st_dev;st_ino

Chengguang Xu (1):
      ovl: improving copy-up efficiency for big sparse file

Jiufei Xue (2):
      vfs: add vfs_iocb_iter_[read|write] helper functions
      ovl: implement async IO routines

Miklos Szeredi (2):
      ovl: layer is const
      ovl: fix lseek overflow on 32bit

Murphy Zhou (1):
      ovl: add splice file read write helper

lijiazi (1):
      ovl: use pr_fmt auto generate prefix

---
 fs/overlayfs/copy_up.c   |  43 ++++++++-
 fs/overlayfs/dir.c       |  10 +-
 fs/overlayfs/export.c    |  28 +++---
 fs/overlayfs/file.c      | 162 +++++++++++++++++++++++++++++---
 fs/overlayfs/inode.c     |  66 ++++++++------
 fs/overlayfs/namei.c     |  38 ++++----
 fs/overlayfs/overlayfs.h |  24 ++++-
 fs/overlayfs/ovl_entry.h |  23 +++--
 fs/overlayfs/readdir.c   |  22 +++--
 fs/overlayfs/super.c     | 233 ++++++++++++++++++++++++++---------------------
 fs/overlayfs/util.c      |  28 ++----
 fs/read_write.c          |  56 ++++++++++++
 include/linux/fs.h       |  16 ++++
 13 files changed, 521 insertions(+), 228 deletions(-)
