Return-Path: <linux-unionfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.6 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C563DC2BB48
	for <linux-unionfs@archiver.kernel.org>; Thu, 17 Dec 2020 14:20:56 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 9E4412395A
	for <linux-unionfs@archiver.kernel.org>; Thu, 17 Dec 2020 14:20:56 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727015AbgLQOU4 (ORCPT
        <rfc822;linux-unionfs@archiver.kernel.org>);
        Thu, 17 Dec 2020 09:20:56 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34784 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726601AbgLQOUz (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Thu, 17 Dec 2020 09:20:55 -0500
Received: from mail-ej1-x641.google.com (mail-ej1-x641.google.com [IPv6:2a00:1450:4864:20::641])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DA8AAC061794
        for <linux-unionfs@vger.kernel.org>; Thu, 17 Dec 2020 06:20:29 -0800 (PST)
Received: by mail-ej1-x641.google.com with SMTP id d17so38121928ejy.9
        for <linux-unionfs@vger.kernel.org>; Thu, 17 Dec 2020 06:20:29 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=szeredi.hu; s=google;
        h=date:from:to:cc:subject:message-id:mime-version:content-disposition;
        bh=s2io9byrVSQg39u9kY1sFTMQIOzVrXTXCf/O9WPWFOA=;
        b=RD62ChU+OJDF7UVtIVsJlfZGn25fGNj6obtVAVtbOfS2rSy0yE6P+pQA9jFQ/hMihx
         AQFvzcRCMpzHb5H2uFgcBZkSOfB02SaM9rPWUt+ugNEML91QwzkZ440MrnUrlX1dtd6d
         mACbQBbnpf5r+rUU5+ytGiLypwDX6Mliyj+TU=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:mime-version
         :content-disposition;
        bh=s2io9byrVSQg39u9kY1sFTMQIOzVrXTXCf/O9WPWFOA=;
        b=bhd64dI6+4rglJCUcCIOJPTu7WvWjLgQs+T1m6vTVFJ8En7Yj4EIqsUAf5rCBlysFy
         sKANckNAnkuJA+wsEhSjoz5sOiBefpw6QmfBFuKJYdw8LPeoYdYPadIeEG3feq4FGKZe
         BbfwvYFJwrXhRIlZxLSlJ/Wlq27WSyHwqGbAO8DH+wzKqflLNGh7G88u5+pX4kGFndAY
         GLaBuSOECtQLLp2fyYYXvO65s5dsXHJWTEP4oxx4+Xpgd81QAQ+NUQjDvKr/8GKBdnMh
         UzdJ6Ks5ufUjECelutj5irPeaGFJWy+Umx7b+vVHN5r15IdnjCfffksSkL4dCTKitSjq
         Y3fg==
X-Gm-Message-State: AOAM530MBiKkeLJWILQ4S1A5/Kkf3BxJgmk6v7Eov7m4vC7PT35GY4DS
        R12jpykB727Xu8vNYUR2wvOcXw==
X-Google-Smtp-Source: ABdhPJwYacqRq/f7MIh1/3pz0PfUQwyDeoMerwcxyS4emF6UV4Lid3Xf+1Hk5tGsH6lIIlmX0qnYXw==
X-Received: by 2002:a17:906:9345:: with SMTP id p5mr24446195ejw.40.1608214828591;
        Thu, 17 Dec 2020 06:20:28 -0800 (PST)
Received: from miu.piliscsaba.redhat.com (catv-86-101-169-67.catv.broadband.hu. [86.101.169.67])
        by smtp.gmail.com with ESMTPSA id n4sm24486697edt.46.2020.12.17.06.20.27
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 17 Dec 2020 06:20:27 -0800 (PST)
Date:   Thu, 17 Dec 2020 15:20:25 +0100
From:   Miklos Szeredi <miklos@szeredi.hu>
To:     Linus Torvalds <torvalds@linux-foundation.org>
Cc:     linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        linux-unionfs@vger.kernel.org,
        "Eric W. Biederman" <ebiederm@xmission.com>
Subject: [GIT PULL] overlayfs update for 5.11
Message-ID: <20201217142025.GB1236412@miu.piliscsaba.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Precedence: bulk
List-ID: <linux-unionfs.vger.kernel.org>
X-Mailing-List: linux-unionfs@vger.kernel.org

Hi Linus,

Please pull from:

  git://git.kernel.org/pub/scm/linux/kernel/git/mszeredi/vfs.git tags/ovl-update-5.11

 - Allow unprivileged mounting in a user namespace.

   For quite some time the security model of overlayfs has been that
   operations on underlying layers shall be performed with the privileges
   of the mounting task.

   This way an unprvileged user cannot gain privileges by the act of
   mounting an overlayfs instance.  A full audit of all function calls made
   by the overlayfs code has been performed to see whether they conform to
   this model, and this branch contains some fixes in this regard.

 - Support running on copied filesystem images by optionally disabling UUID
   verification.

 - Bug fixes as well as documentation updates.

I was hoping to get feedback from Eric Biederman on the unprivileged
mounting feature, but even without that I feel quite good about enabling it
at this point.  It's a trivial patch at the head of this branch, so
skipping it now or reverting later would also be options.

Thanks,
Miklos

---
Chengguang Xu (1):
      ovl: fix incorrect extent info in metacopy case

Kevin Locke (2):
      ovl: warn about orphan metacopy
      ovl: document lower modification caveats

Miklos Szeredi (12):
      ovl: doc clarification
      ovl: expand warning in ovl_d_real()
      vfs: move cap_convert_nscap() call into vfs_setxattr()
      vfs: verify source area in vfs_dedupe_file_range_one()
      ovl: check privs before decoding file handle
      ovl: make ioctl() safe
      ovl: simplify file splice
      ovl: user xattr
      ovl: do not fail when setting origin xattr
      ovl: do not fail because of O_NOATIME
      ovl: do not get metacopy for userxattr
      ovl: unprivieged mounts

Pavel Tikhomirov (2):
      ovl: propagate ovl_fs to ovl_decode_real_fh and ovl_encode_real_fh
      ovl: introduce new "uuid=off" option for inodes index feature

---
 Documentation/filesystems/overlayfs.rst |  36 ++++++--
 fs/overlayfs/copy_up.c                  |  28 ++++---
 fs/overlayfs/export.c                   |  10 ++-
 fs/overlayfs/file.c                     | 144 +++++---------------------------
 fs/overlayfs/inode.c                    |  14 +++-
 fs/overlayfs/namei.c                    |  28 ++++---
 fs/overlayfs/overlayfs.h                |  22 +++--
 fs/overlayfs/ovl_entry.h                |   2 +
 fs/overlayfs/super.c                    |  95 ++++++++++++++++++---
 fs/overlayfs/util.c                     |  18 +++-
 fs/remap_range.c                        |  10 ++-
 fs/xattr.c                              |  17 ++--
 include/linux/capability.h              |   2 +-
 security/commoncap.c                    |   3 +-
 14 files changed, 233 insertions(+), 196 deletions(-)
