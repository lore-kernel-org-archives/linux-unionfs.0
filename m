Return-Path: <SRS0=I5aa=7W=vger.kernel.org=linux-unionfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.5 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,
	SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7C2A9C433DF
	for <linux-unionfs@archiver.kernel.org>; Tue,  9 Jun 2020 20:37:33 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 58FC4204EC
	for <linux-unionfs@archiver.kernel.org>; Tue,  9 Jun 2020 20:37:33 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=szeredi.hu header.i=@szeredi.hu header.b="nXo4e1lL"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728400AbgFIUh1 (ORCPT
        <rfc822;linux-unionfs@archiver.kernel.org>);
        Tue, 9 Jun 2020 16:37:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39168 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728189AbgFIUhX (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Tue, 9 Jun 2020 16:37:23 -0400
Received: from mail-ej1-x642.google.com (mail-ej1-x642.google.com [IPv6:2a00:1450:4864:20::642])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DE5A2C08C5C3
        for <linux-unionfs@vger.kernel.org>; Tue,  9 Jun 2020 13:37:22 -0700 (PDT)
Received: by mail-ej1-x642.google.com with SMTP id o15so33778ejm.12
        for <linux-unionfs@vger.kernel.org>; Tue, 09 Jun 2020 13:37:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=szeredi.hu; s=google;
        h=date:from:to:cc:subject:message-id:mime-version:content-disposition;
        bh=7ZVlejTC0YuKPGpcteISk746OUPvuY4hgSWC1f7OLtQ=;
        b=nXo4e1lLm4NTrTzkokAa+id+fdgD1MXyvH4cDPWBQT70BhQJfREqivfXZvDNiAiWWp
         c2ZgYsbA7T54ZHViJGcdK9qb7pLw/TvBE50mRCbzGyvTHRb6i4uKOatrKuK4p4dbglQ5
         gHYpv3YUmO16neCN6MlZVyzyaKpZp13cG71oE=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:mime-version
         :content-disposition;
        bh=7ZVlejTC0YuKPGpcteISk746OUPvuY4hgSWC1f7OLtQ=;
        b=s13U5RGTrlOFLk4xagJDMrl6vo+mj0SNkdmW03JnBU5I+9NyilCc0Fi21rkz+ftCMq
         0dBq+pweaH+f8RBC9XHegf6wwj5jusM6EUE9/0hAmDUWgDqJ1Yq/LGCCB51lmvaMXmNR
         U4mSKljGz6XSHJmJByFBCXMHSW+EV0p79EHeuwtfCJwlh1xyx5roSMwWxjTyOmRwTVsf
         ga4qBoI3Uz41GdOeq9bI3qqDC5EQ9RfSueWBRyy15jRHB/3XzsnWrQPKdAQUIVDk1Ow/
         qa3SeOqz/ObablpgN3Gs8z+nPfByrEVSqAfZz2XxMAki7rUHgXD6qUAX/igokg357XXI
         uu8A==
X-Gm-Message-State: AOAM531VHWzU4Q6rQ/KQZ7x2r4tc9lcB8XYqA1cXEszFT4E94UpzKYJv
        I6pWqVonc/iwh1gISo4JwEIkzw==
X-Google-Smtp-Source: ABdhPJxpLOFautN81ZbcwIflxRmD4RRnfFtwTTRy8WEhlMS3Jc+pUiOH22RYN5xOgRBrM91Xj7MOhw==
X-Received: by 2002:a17:906:6156:: with SMTP id p22mr152434ejl.329.1591735041107;
        Tue, 09 Jun 2020 13:37:21 -0700 (PDT)
Received: from miu.piliscsaba.redhat.com (catv-212-96-48-140.catv.broadband.hu. [212.96.48.140])
        by smtp.gmail.com with ESMTPSA id v12sm16508347eda.39.2020.06.09.13.37.20
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 09 Jun 2020 13:37:20 -0700 (PDT)
Date:   Tue, 9 Jun 2020 22:37:18 +0200
From:   Miklos Szeredi <miklos@szeredi.hu>
To:     Linus Torvalds <torvalds@linux-foundation.org>
Cc:     linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        linux-unionfs@vger.kernel.org
Subject: [GIT PULL] overlayfs update for 5.8
Message-ID: <20200609203718.GB6171@miu.piliscsaba.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: linux-unionfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-unionfs.vger.kernel.org>
X-Mailing-List: linux-unionfs@vger.kernel.org

Hi Linus,

Please pull from:

  git://git.kernel.org/pub/scm/linux/kernel/git/mszeredi/vfs.git tags/ovl-update-5.8

There are some changes outside of the overlayfs tree; clone_private_mount()
was reviewed by Al, the rest are trivial.  No other filesystems are
affected by these.

Fixes:

 - Resolve mount option conflicts consistently.

 - Sync before remount R/O.

 - Fix file handle encoding corner cases.

 - Fix metacopy related issues.

 - Fix an unintialized return value.

 - Add missing permission checks for underlying layers.

Optimizations:

 - Allow multipe whiteouts to share an inode.

 - Optimize small writes by inheriting SB_NOSEC from upper layer.

 - Do not call ->syncfs() multiple times for sync(2).

 - Do not cache negative lookups on upper layer.

 - Make private internal mounts longterm.

Thanks,
Miklos

---
Amir Goldstein (5):
      ovl: resolve more conflicting mount options
      ovl: cleanup non-empty directories in ovl_indexdir_cleanup()
      ovl: prepare to copy up without workdir
      ovl: index dir act as work dir
      ovl: fix out of bounds access warning in ovl_check_fb_len()

Chengguang Xu (3):
      ovl: whiteout inode sharing
      ovl: sync dirty data when remounting to ro mode
      ovl: drop negative dentry in upper layer

Jeffle Xu (1):
      ovl: inherit SB_NOSEC flag from upperdir

Konstantin Khlebnikov (1):
      ovl: skip overlayfs superblocks at global sync

Lubos Dolezel (1):
      ovl: return required buffer size for file handles

Miklos Szeredi (10):
      ovl: pass correct flags for opening real directory
      ovl: switch to mounter creds in readdir
      ovl: verify permissions in ovl_path_open()
      ovl: call secutiry hook in ovl_real_ioctl()
      ovl: check permission to open real file
      ovl: add accessor for ofs->upper_mnt
      ovl: get rid of redundant members in struct ovl_fs
      ovl: make private mounts longterm
      ovl: only pass ->ki_flags to ovl_iocb_to_rwf()
      ovl: make oip->index bool

Vivek Goyal (4):
      ovl: simplify setting of origin for index lookup
      ovl: use only uppermetacopy state in ovl_lookup()
      ovl: initialize OVL_UPPERDATA in ovl_lookup()
      ovl: fix redirect traversal on metacopy dentries

Yuxuan Shui (1):
      ovl: initialize error in ovl_copy_xattr

youngjun (1):
      ovl: remove unnecessary lock check

---
 Documentation/filesystems/overlayfs.rst |   7 +-
 Documentation/filesystems/porting.rst   |   7 +
 fs/namespace.c                          |  16 +++
 fs/overlayfs/copy_up.c                  |   9 +-
 fs/overlayfs/dir.c                      |  51 +++++--
 fs/overlayfs/export.c                   |  24 ++--
 fs/overlayfs/file.c                     |  28 +++-
 fs/overlayfs/inode.c                    |  17 +--
 fs/overlayfs/namei.c                    | 138 ++++++++++--------
 fs/overlayfs/overlayfs.h                |  11 +-
 fs/overlayfs/ovl_entry.h                |  10 +-
 fs/overlayfs/readdir.c                  |  57 ++++++--
 fs/overlayfs/super.c                    | 243 +++++++++++++++++++++-----------
 fs/overlayfs/util.c                     |  36 ++++-
 fs/sync.c                               |   3 +-
 include/linux/fs.h                      |   2 +
 include/linux/mount.h                   |   2 +
 security/security.c                     |   1 +
 18 files changed, 440 insertions(+), 222 deletions(-)
