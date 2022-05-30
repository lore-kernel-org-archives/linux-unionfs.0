Return-Path: <linux-unionfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 52DE3C433EF
	for <linux-unionfs@archiver.kernel.org>; Mon, 30 May 2022 08:17:59 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233418AbiE3IR6 (ORCPT
        <rfc822;linux-unionfs@archiver.kernel.org>);
        Mon, 30 May 2022 04:17:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59722 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233414AbiE3IR5 (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Mon, 30 May 2022 04:17:57 -0400
Received: from mail-ed1-x532.google.com (mail-ed1-x532.google.com [IPv6:2a00:1450:4864:20::532])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AF2D011A0D
        for <linux-unionfs@vger.kernel.org>; Mon, 30 May 2022 01:17:53 -0700 (PDT)
Received: by mail-ed1-x532.google.com with SMTP id b8so4520470edf.11
        for <linux-unionfs@vger.kernel.org>; Mon, 30 May 2022 01:17:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=szeredi.hu; s=google;
        h=date:from:to:cc:subject:message-id:mime-version:content-disposition;
        bh=YSjVIXrz4aX1dpD91UET7Xaw2MPWafK4NrWr0v1gvIU=;
        b=EF2gtJoOMhhPECKiHY28H+iATlv2dq/o4/nOU3ygyYe/7wgW52995x891LTFHf2GDb
         NEY4/7Wl7kZPVhgFrDO5bWHPaQ2KcKmMaEFitbOqTLHrc0QbvJljDa74nlONPsC3vLmO
         e8PbDucVrkf96oq2id2sSF2If5k8zTyhL0Q/U=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:mime-version
         :content-disposition;
        bh=YSjVIXrz4aX1dpD91UET7Xaw2MPWafK4NrWr0v1gvIU=;
        b=gkBMadNljB23NZrdzpLYYuQ7oKQ+hnOCERdZ3erjq4ReeceTt8oPn9Rz9+sheGAwfc
         Zpdvdi6Cc4KsVwxWTkH2h0lnWRULYXchtGoQMQUBX5QicINNvnVLwhFH0FOVz8ESCXxS
         DHShgv52/aLfKhMZNtm0umLXttdx3R598qrRTMAwE38Ec+dQiFrAzZk1SrNpKahBSUnU
         H2LUky6pzxJHK+NRVpD7hIQe/JnMXmizc8m3GNu9N1HVlVQ4zwcxZPeWfkxwPc8anJZ+
         Y3TPcOqq0RL0UMVElzc2u/PZG6eiL3Z1nXAeH19oXcSv/x7xwcnBl3qoH7X92SxcXCIy
         wXPQ==
X-Gm-Message-State: AOAM532ORRjBUilp4bIBFQHdf9yRRUmY9v97miXuWKfdY//RkytH7WWL
        gIn4DOw0wd7K+2c1Uu2kEaLh91i7oxbMJg==
X-Google-Smtp-Source: ABdhPJyVWevsco2ThF7lWQUJr6+RGj1iLEFH43aT9ZE+5VZe50hGTKKueU6g9jvG0y8Oym2Aqp7DRw==
X-Received: by 2002:a05:6402:1113:b0:428:679e:f73f with SMTP id u19-20020a056402111300b00428679ef73fmr57733573edv.378.1653898672304;
        Mon, 30 May 2022 01:17:52 -0700 (PDT)
Received: from miu.piliscsaba.redhat.com (catv-178-48-189-3.catv.fixed.vodafone.hu. [178.48.189.3])
        by smtp.gmail.com with ESMTPSA id c2-20020a17090603c200b006fea59ef3a5sm3800929eja.32.2022.05.30.01.17.50
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 30 May 2022 01:17:51 -0700 (PDT)
Date:   Mon, 30 May 2022 10:17:48 +0200
From:   Miklos Szeredi <miklos@szeredi.hu>
To:     Linus Torvalds <torvalds@linux-foundation.org>
Cc:     linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        linux-unionfs@vger.kernel.org
Subject: [GIT PULL] overlayfs update for 5.19
Message-ID: <YpR9rJkjso7lXdFC@miu.piliscsaba.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Precedence: bulk
List-ID: <linux-unionfs.vger.kernel.org>
X-Mailing-List: linux-unionfs@vger.kernel.org

Hi Linus,

Please pull from:

  git://git.kernel.org/pub/scm/linux/kernel/git/mszeredi/vfs.git tags/ovl-update-5.19

Support idmapped layers in overlayfs (Christian Brauner).  Add a fix to
exportfs that is relevant to open_by_handle_at(2) as well.  Also introduce
new lookup helpers that allow passing mnt_userns into inode_permission().

Thanks,
Miklos

---
Amir Goldstein (3):
      ovl: use wrappers to all vfs_*xattr() calls
      ovl: pass layer mnt to ovl_open_realfile()
      ovl: store lower path in ovl_inode

Christian Brauner (16):
      fs: add two trivial lookup helpers
      exportfs: support idmapped mounts
      ovl: pass ofs to creation operations
      ovl: add ovl_upper_mnt_userns() wrapper
      ovl: handle idmappings in creation operations
      ovl: pass ofs to setattr operations
      ovl: use ovl_do_notify_change() wrapper
      ovl: use ovl_lookup_upper() wrapper
      ovl: use ovl_path_getxattr() wrapper
      ovl: handle idmappings for layer fileattrs
      ovl: handle idmappings for layer lookup
      ovl: use ovl_copy_{real,upper}attr() wrappers
      ovl: handle idmappings in ovl_permission()
      ovl: handle idmappings in layer open helpers
      ovl: handle idmappings in ovl_xattr_{g,s}et()
      ovl: support idmapped layers

---
 fs/exportfs/expfs.c      |   5 +-
 fs/namei.c               |  70 ++++++++++++--
 fs/overlayfs/copy_up.c   |  90 +++++++++---------
 fs/overlayfs/dir.c       | 147 +++++++++++++++---------------
 fs/overlayfs/export.c    |   5 +
 fs/overlayfs/file.c      |  43 +++++----
 fs/overlayfs/inode.c     |  68 ++++++++------
 fs/overlayfs/namei.c     |  53 +++++++----
 fs/overlayfs/overlayfs.h | 232 +++++++++++++++++++++++++++++++++--------------
 fs/overlayfs/ovl_entry.h |   7 +-
 fs/overlayfs/readdir.c   |  48 +++++-----
 fs/overlayfs/super.c     |  57 ++++++------
 fs/overlayfs/util.c      | 103 ++++++++++++++++-----
 include/linux/namei.h    |   6 ++
 14 files changed, 598 insertions(+), 336 deletions(-)
