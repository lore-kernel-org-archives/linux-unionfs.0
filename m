Return-Path: <linux-unionfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4D614EB64DD
	for <linux-unionfs@archiver.kernel.org>; Thu, 13 Jul 2023 13:34:14 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230439AbjGMNeN (ORCPT
        <rfc822;linux-unionfs@archiver.kernel.org>);
        Thu, 13 Jul 2023 09:34:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37646 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235043AbjGMNeM (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Thu, 13 Jul 2023 09:34:12 -0400
Received: from mail-wr1-x434.google.com (mail-wr1-x434.google.com [IPv6:2a00:1450:4864:20::434])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E038DE4D
        for <linux-unionfs@vger.kernel.org>; Thu, 13 Jul 2023 06:34:10 -0700 (PDT)
Received: by mail-wr1-x434.google.com with SMTP id ffacd0b85a97d-3143ccb0f75so929067f8f.0
        for <linux-unionfs@vger.kernel.org>; Thu, 13 Jul 2023 06:34:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1689255249; x=1691847249;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=tGh35fGrCQn9ZZfyfGGlMueVGoXX0VzXWi3FmLcRTcE=;
        b=oo0hCDrWMpnm2Q+RcLvS8Y7NqXdhhXrbNpc705Jf50gvug994L4o++73O0w1+I6wVu
         gcxXBMuGvnMkhrhBl/BYaNCVRqcswGTNAfGnyTfZouoFU3u1OvdMF6iPHmBFnKtguZth
         0QaAUSGDF6d3v5h/d7FhWwEc9Er4Wjm5OctR8fAHA5owkXqiJersPtVnY0aLLYCdWe2t
         YTG99QQ96kT83GO/S8q7XQHN4z5n6J876Zp4DPdvreFkTR4P2NGiezKxJN/1owBycOTy
         yMCAHmI3pIMEFanaJ+BX6wxBQ0YnopobaJNYIFn+NrxLp+zRj07uDRbT/fNMSl/WyLOt
         7kJA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1689255249; x=1691847249;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=tGh35fGrCQn9ZZfyfGGlMueVGoXX0VzXWi3FmLcRTcE=;
        b=iDhwWZn/MwN3g+8XaG4xBRfEEZir39nKRmyczgqinEfHGngo+0Z4CXRI230V7MzSno
         QwbOTkSgkAZ+D7qJJBIP5oWTtb0Se2pULFXD8D7HOWp7iYjWKXiTo+jR3y0+BOUrfIVx
         kcVYNBi5iEkWNw8UjB9tpL7RkYD6ZhPlj03579TwoQexpstYRpjiCtcMZCmQzpFCOrIz
         tBapMiMBPl5j334bLGB9Erj0tTOR3pj7ZJG1x86sEn1jbGvrmC6gCfviNemehyeeqbeA
         8JXslb5NJW/+yloTWrcTOvqTkm3pUmdwXquMm+Dh5N959ctQNTSSCvUL2GdmbcP+7cbc
         vSbA==
X-Gm-Message-State: ABy/qLa+YjPtPXmwZZbwJ0DKloYXwT+gvEUkJlUQ1SNRxzqGLS6b65Q9
        cH+gagCGWt/t/cQeK8s8c3jbwGr9S0U=
X-Google-Smtp-Source: APBJJlE2lq0Kxz+z2ahtNqnYYN1yjyf1o5J9CIkxYW2bAqI6nxMCxVQwQzo9uxmfFhrQ/fVp1lTTEQ==
X-Received: by 2002:a05:6000:114e:b0:314:1416:3be3 with SMTP id d14-20020a056000114e00b0031414163be3mr1831108wrx.70.1689255248650;
        Thu, 13 Jul 2023 06:34:08 -0700 (PDT)
Received: from amir-ThinkPad-T480.lan ([5.29.249.86])
        by smtp.gmail.com with ESMTPSA id i10-20020a5d558a000000b0030fb828511csm7986544wrv.100.2023.07.13.06.34.07
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 13 Jul 2023 06:34:08 -0700 (PDT)
From:   Amir Goldstein <amir73il@gmail.com>
To:     Miklos Szeredi <miklos@szeredi.hu>
Cc:     Alexander Larsson <alexl@redhat.com>, linux-unionfs@vger.kernel.org
Subject: [ANNOUNCE] ovl: overlayfs-next branch updated to 0a3bf81dbcb2
Date:   Thu, 13 Jul 2023 16:34:04 +0300
Message-Id: <20230713133404.1426405-1-amir73il@gmail.com>
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

  0a3bf81dbcb2 ("ovl: auto generate uuid for new overlay filesystems")

The updated head contains the following patch sets:

- Add support for fs-verity checking of lowerdata -
  including fixes to address review comments of Eric Biggers on v5 [1]

- Report overlayfs file ids with fanotify (v2) [2]

The new code was tested using fstests including new tests written
by Alex and myself, which are available on my xfstests tree [3].
Test setup scripts for testing the verity feature are available
in my xfstests-bld tree [4].

Thanks,
Amir.

[1] https://lore.kernel.org/r/cover.1687345663.git.alexl@redhat.com
[2] https://lore.kernel.org/r/20230713120344.1422468-1-amir73il@gmail.com
[3] https://github.com/amir73il/xfstests/commits/overlayfs-devel
[4] https://github.com/amir73il/xfstests-bld/commits/overlayfs-devel

----------------------------------------------------------------
Alexander Larsson (4):
      ovl: Add framework for verity support
      ovl: Add versioned header for overlay.metacopy xattr
      ovl: Validate verity xattr when resolving lowerdata
      ovl: Handle verity during copy-up

Amir Goldstein (4):
      ovl: support encoding non-decodable file handles
      ovl: add support for unique fsid per instance
      ovl: store persistent uuid/fsid with uuid=on
      ovl: auto generate uuid for new overlay filesystems

 Documentation/filesystems/fsverity.rst  |   2 +
 Documentation/filesystems/overlayfs.rst |  72 +++++++++++
 fs/overlayfs/copy_up.c                  |  52 +++++++-
 fs/overlayfs/export.c                   |  26 +++-
 fs/overlayfs/file.c                     |   8 +-
 fs/overlayfs/inode.c                    |   2 +-
 fs/overlayfs/namei.c                    |  87 +++++++++++--
 fs/overlayfs/overlayfs.h                |  66 +++++++++-
 fs/overlayfs/ovl_entry.h                |   4 +-
 fs/overlayfs/params.c                   |  92 ++++++++++++--
 fs/overlayfs/super.c                    |  34 ++++-
 fs/overlayfs/util.c                     | 217 +++++++++++++++++++++++++++++++-
 12 files changed, 617 insertions(+), 45 deletions(-)
