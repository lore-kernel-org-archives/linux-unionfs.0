Return-Path: <linux-unionfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 74444C433F5
	for <linux-unionfs@archiver.kernel.org>; Tue,  9 Nov 2021 09:08:14 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 5C23A6103C
	for <linux-unionfs@archiver.kernel.org>; Tue,  9 Nov 2021 09:08:14 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230489AbhKIJK7 (ORCPT
        <rfc822;linux-unionfs@archiver.kernel.org>);
        Tue, 9 Nov 2021 04:10:59 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39914 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242104AbhKIJK6 (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Tue, 9 Nov 2021 04:10:58 -0500
Received: from mail-ed1-x52b.google.com (mail-ed1-x52b.google.com [IPv6:2a00:1450:4864:20::52b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 37EE7C061764
        for <linux-unionfs@vger.kernel.org>; Tue,  9 Nov 2021 01:08:12 -0800 (PST)
Received: by mail-ed1-x52b.google.com with SMTP id m14so73273768edd.0
        for <linux-unionfs@vger.kernel.org>; Tue, 09 Nov 2021 01:08:12 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=szeredi.hu; s=google;
        h=date:from:to:cc:subject:message-id:mime-version:content-disposition;
        bh=VCMCayoiw6jiN14Vy0tGeBad8uf3NfKNTuH/91IaUr0=;
        b=aYVR3ufOsfMnHBKR9k4Bz0hUl0Kwq/e26/d6he0GM1iUrLEzS3CI5K4ItPWyUJQodh
         An6ypM1RoUHf7tu6yyKULI98UJUbSfA4NEBEXGMd5ckR8Cioz2N2Z5C0tOTJTh2OfW0z
         VBS3nFtzRfEPINJeKOGESEauvQ0NYW1XGXC/Q=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:mime-version
         :content-disposition;
        bh=VCMCayoiw6jiN14Vy0tGeBad8uf3NfKNTuH/91IaUr0=;
        b=zzafBbhCDiSgu10zUvwIZrcjE8qhwC0FPD0pQtO2ReCfPz1fC6DalOwjlzCiGFUy0d
         Q/bMm54M5ArzwBOcsEY6bg8/+7srOZzYFg0HZ1RCDTkTsTUV/b8Fhyki7vmJXtkt0vgz
         FRDTySVrbtz6ujSzQdwSa+/5OfkGAuVy5iRfE5kxKF9r8XcMGYcZkE4b8nYcacS54ezr
         4ouuVfDzNef3mJ3Hz4wlU+Y/zxbeJsQAqm1o/KwU3XCNqGxGFlOfJspebhQ/PpK1CUOP
         6PJ3/UMYUAPmO7MZIr6DaLWBwlH6cgs8SgU819D/AUtNq8LWScSJRpgIh0cfeUywq1R+
         xL5A==
X-Gm-Message-State: AOAM531C6rQtNkUxHGZQdsDEFuY5RryFoqjFbRZ28B20+laWPtKhadAI
        Y4TtXlpc0IZAhxzJAEmdV7UQBDqN/3g2EA==
X-Google-Smtp-Source: ABdhPJz9XrzSOmC4qjtJNbN2RuGiDKIgMwsJ3jk+9wtl12QNXF3iWJ3Zor39pSp4HstnYT3SrZD5wg==
X-Received: by 2002:a17:906:6a0f:: with SMTP id qw15mr7382844ejc.463.1636448890742;
        Tue, 09 Nov 2021 01:08:10 -0800 (PST)
Received: from miu.piliscsaba.redhat.com (catv-178-48-189-3.catv.broadband.hu. [178.48.189.3])
        by smtp.gmail.com with ESMTPSA id nd36sm9292965ejc.17.2021.11.09.01.08.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 09 Nov 2021 01:08:10 -0800 (PST)
Date:   Tue, 9 Nov 2021 10:08:08 +0100
From:   Miklos Szeredi <miklos@szeredi.hu>
To:     Linus Torvalds <torvalds@linux-foundation.org>
Cc:     linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        linux-unionfs@vger.kernel.org
Subject: [GIT PULL] overlayfs update for 5.16
Message-ID: <YYo6eHUbXJXQkogn@miu.piliscsaba.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Precedence: bulk
List-ID: <linux-unionfs.vger.kernel.org>
X-Mailing-List: linux-unionfs@vger.kernel.org

Hi Linus,

Please pull from:

  git://git.kernel.org/pub/scm/linux/kernel/git/mszeredi/vfs.git tags/ovl-update-5.16

 - Fix a regression introduced in the last cycle.

 - Fix a use-after-free in the AIO path.

 - Fix a bogus warning reported by syzbot.


Thanks,
Miklos

---
Miklos Szeredi (2):
      ovl: fix warning in ovl_create_real()
      ovl: fix filattr copy-up failure

yangerkun (1):
      ovl: fix use after free in struct ovl_aio_req

---
 fs/overlayfs/copy_up.c   | 23 ++++++++++++++++++-----
 fs/overlayfs/dir.c       |  3 +--
 fs/overlayfs/file.c      | 16 ++++++++++++++--
 fs/overlayfs/inode.c     |  5 ++++-
 fs/overlayfs/overlayfs.h |  1 +
 fs/overlayfs/super.c     | 12 ++++++++----
 6 files changed, 46 insertions(+), 14 deletions(-)
