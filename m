Return-Path: <linux-unionfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8370ACE79A9
	for <linux-unionfs@archiver.kernel.org>; Tue, 19 Sep 2023 18:41:55 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231906AbjISSl7 (ORCPT
        <rfc822;linux-unionfs@archiver.kernel.org>);
        Tue, 19 Sep 2023 14:41:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47838 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229552AbjISSl7 (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Tue, 19 Sep 2023 14:41:59 -0400
Received: from mail-wm1-x32e.google.com (mail-wm1-x32e.google.com [IPv6:2a00:1450:4864:20::32e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EE86BBE
        for <linux-unionfs@vger.kernel.org>; Tue, 19 Sep 2023 11:41:51 -0700 (PDT)
Received: by mail-wm1-x32e.google.com with SMTP id 5b1f17b1804b1-403004a96eeso63772315e9.3
        for <linux-unionfs@vger.kernel.org>; Tue, 19 Sep 2023 11:41:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1695148910; x=1695753710; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=7SvdCr6oci0uLTBIwWJDyyLWmEm5PCpadaj80JY8tNE=;
        b=HEm/2oyQlZwbehrhn+l+iXjz5MwP1kLvzMFXsk8V6+62O+naMPwzUwIVZarbOJa6dl
         5bjfwlqfC6/BCE1o1iZksvWrIdCyFCeQ077osgdXoKFLiYERcCXK13HM9chj8PKF7H3J
         Js/Mrs7trCVUmpuc4SljI5d2Koyqrq0sQxHaWamCE26F51/KZH7XEL9FDpr9LRn8hmFj
         kUepiFOpJHOis/EOTatzxGWDayS9zNVPLaSLcbwopwdIK6XzUm00bIlXEYgxmZUYj/6P
         QM63wfu+ayXR3ewRMg7pLXCTe07fDWzKJvCz+r1gTE1w4eG6DwYO6uI57RAQjnZ7G4Kb
         EDNw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1695148910; x=1695753710;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=7SvdCr6oci0uLTBIwWJDyyLWmEm5PCpadaj80JY8tNE=;
        b=DOTpJiSjUUD9a+QaIQZjMqU6irOYPeGBxet7yhuzJ2FszAMwTAQVRgpvQ0szsJi8qo
         J89DhePc2C8iKtz8lq7eB6yWbePStCivuU6E7znFQZZhqt4iGixq3rUtg0gVp1rqrFpl
         AH+trjFIMHMlMYwtowzKlUc3V0Y5w5vCxzG24+1o6l90OvLm9Faolr3UG0M6f3aiTAtc
         kX+nx0en41q9z1JZ1Uas4odl9kVoIwHR8prHOJqMXVJvzE5nQ8C370WGINdOPhaFEfjj
         4weIgMMZfesvmk0OKkRtXHwZ1tRJNTTSu7OoBiFa/iwVieovcs+eM7PHCW2pQDAyIZZZ
         /Vgg==
X-Gm-Message-State: AOJu0YwDJHDBU1wW8ojywA+O0/FilHwm1Z7M9mYnZLjZrLCXE0XDLiyn
        ABU6qEGqYdCme/YFtbS84y/4t3t4+O8=
X-Google-Smtp-Source: AGHT+IH4WEWAqtWgpRa4+iNvYUDAqlJzPaxxuXbCqjvtzwFZzJ1BnRNkxC8YNV7YHx7nfEiXdCSf1g==
X-Received: by 2002:a7b:c8c8:0:b0:401:4417:a82d with SMTP id f8-20020a7bc8c8000000b004014417a82dmr505527wml.38.1695148909921;
        Tue, 19 Sep 2023 11:41:49 -0700 (PDT)
Received: from amir-ThinkPad-T480.lan ([5.29.249.86])
        by smtp.gmail.com with ESMTPSA id 7-20020a05600c230700b003fefcbe7fa8sm16129608wmo.28.2023.09.19.11.41.48
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 19 Sep 2023 11:41:49 -0700 (PDT)
From:   Amir Goldstein <amir73il@gmail.com>
To:     Miklos Szeredi <miklos@szeredi.hu>
Cc:     Alexander Larsson <alexl@redhat.com>,
        Christian Brauner <brauner@kernel.org>,
        linux-unionfs@vger.kernel.org
Subject: [ANNOUNCE] ovl: overlayfs-next updated to d1512c40431a
Date:   Tue, 19 Sep 2023 21:41:46 +0300
Message-Id: <20230919184146.32501-1-amir73il@gmail.com>
X-Mailer: git-send-email 2.34.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-unionfs.vger.kernel.org>
X-Mailing-List: linux-unionfs@vger.kernel.org

Hi all,

The overlayfs-next branch of the overlayfs repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/overlayfs/vfs.git

has been updated.

The head of the overlayfs-next branch is commit:

  d1512c40431a ("ovl: Add documentation on nesting of overlayfs mounts")

The updated head contains the following patch sets:

- Rename and export some vfs helpers [1] (merged via vfs tree)

- Overlayfs aio cleanups [2] (prep work for FUSE passthrough helpers)

- Overlayfs lock ordering changes [3] (prep work for write-safe fsnotify
  permission events)

- Add support for nesting overlayfs private xattrs (Alex) [4]

The new code was tested using fstests including new tests written
by Alex, which are available on his xfstests tree [5].

Miklos,

Each of the overlayfs patch sets include changes that address your
review comments from earlier revision, but niether have an explicit ACK
from you on the final version (as posted in the links below).

We still have plently of time until the merge window for you to review
those patches, so I decided to expose them to linux-next testing.
Please shout if you think that any of the patches need extra time for
review or not acceptable for consideration to 6.7 in their current form.

Thanks,
Amir.

[1] https://lore.kernel.org/r/20230908132900.2983519-1-amir73il@gmail.com/
[2] https://lore.kernel.org/r/20230912173653.3317828-1-amir73il@gmail.com/
[3] https://lore.kernel.org/r/20230816152334.924960-1-amir73il@gmail.com/
[4] https://lore.kernel.org/r/cover.1694512044.git.alexl@redhat.com/
[5] https://github.com/alexlarsson/xfstests/commits/overlayfs-nesting

----------------------------------------------------------------

Alexander Larsson (5):
  ovl: Move xattr support to new xattrs.c file
  ovl: Add OVL_XATTR_TRUSTED/USER_PREFIX_LEN macros
  ovl: Support escaped overlay.* xattrs
  ovl: Add an alternative type of whiteout
  ovl: Add documentation on nesting of overlayfs mounts

Amir Goldstein (12):
  ovl: fix failed copyup of fileattr on a symlink
  ovl: fix incorrect fdput() on aio completion
  fs: rename __mnt_{want,drop}_write*() helpers
  fs: export mnt_{get,put}_write_access() to modules
  ovl: protect copying of realinode attributes to ovl inode
  ovl: use simpler function to convert iocb to rw flags
  ovl: propagate IOCB_APPEND flag on writes to realfile
  ovl: move ovl_file_accessed() to aio completion
  ovl: split ovl_want_write() into two helpers
  ovl: reorder ovl_want_write() after ovl_inode_lock()
  ovl: do not open/llseek lower file with upper sb_writers held
  ovl: do not encode lower fh with upper sb_writers held

