Return-Path: <linux-unionfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 87BDBC2B9F4
	for <linux-unionfs@archiver.kernel.org>; Thu, 17 Jun 2021 15:22:53 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 71A3B61159
	for <linux-unionfs@archiver.kernel.org>; Thu, 17 Jun 2021 15:22:53 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233245AbhFQPZA (ORCPT
        <rfc822;linux-unionfs@archiver.kernel.org>);
        Thu, 17 Jun 2021 11:25:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48474 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233274AbhFQPY5 (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Thu, 17 Jun 2021 11:24:57 -0400
Received: from mail-wr1-x431.google.com (mail-wr1-x431.google.com [IPv6:2a00:1450:4864:20::431])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 51922C061574
        for <linux-unionfs@vger.kernel.org>; Thu, 17 Jun 2021 08:22:48 -0700 (PDT)
Received: by mail-wr1-x431.google.com with SMTP id e22so3646608wrc.1
        for <linux-unionfs@vger.kernel.org>; Thu, 17 Jun 2021 08:22:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=gblo0/IH+IqIQfbMRn2E8Xi67qPNXrPlYs800suVfu8=;
        b=UOAlRM18+6D496c73u+6zlLzOFYNcJT6dN6m/hNL9CcAmOhqFTm+LOibIyaHWbspCL
         UAHzUevadVqyOIfjjXxQNmZGBFkCoUwQO2W63RW1BBABzPld1SJt+Ak9+ffIi5pDO10A
         p3BICCPpQ8vG4Jfc4vGUml0VmflLFoxqg9k+WZ184ae4c0XrZL/J5WFnvG0faTsbLiKs
         PG3dD14Ac7GYsaAzYpnMdEE/pVXXN7zdS4GN56XnJfAkmwycK8QjmWSTZViYYmS/Wz36
         KOnvbATiBxFFAFyCQ9s+KhH4Rp5J836vxfhYGsd32dXBuEChukOwPQN6fnT3yDEi8Z5L
         YJpQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=gblo0/IH+IqIQfbMRn2E8Xi67qPNXrPlYs800suVfu8=;
        b=AyW+e8cS/HJmRNavQ2nkXx9/yhZwXdRykf8saxNJ+HDVUnwAr3Ym04tyBpRRLzteyw
         yaECYKw63RzqdpXIPDwF5mOnH+1XbE97fcWlpXdAF8/xtr1Wd0KcxHPwYLaIOgG7xy9x
         lzBMV9pX32RavAHsBngRlEjM25GlnCQeulL9xbzMFPAoGobSWZhtXsknXSGDTh6kIana
         lDcj4h8cVKxSMdOtEaKGAXjOn3+sVoyCXAcc5PBt/mPuIcevNt9Ad6v5bSGDoVn3mGD7
         1/L8BSNUvXGqvVoyVhqCUWzI3e+8W7P7xA/FF19b1vu+tLVuioWCw7msADelBw7ERxG2
         1Irg==
X-Gm-Message-State: AOAM533bmzZYaExExb9sS5HVdRCluFzhT8hL2ikoXw+lYbhLSnLDPGhU
        WtzKRoKqDaC2oHv4fa7xg1c=
X-Google-Smtp-Source: ABdhPJwHxgwHWYKblYHWdH0VFrTqolpWF4hazE6ydEAIUsMW/O5Z5//nPE/9dCADGszc+3IkbsvOcg==
X-Received: by 2002:a5d:5388:: with SMTP id d8mr6212077wrv.423.1623943366830;
        Thu, 17 Jun 2021 08:22:46 -0700 (PDT)
Received: from localhost.localdomain ([141.226.242.176])
        by smtp.gmail.com with ESMTPSA id o7sm5835910wro.76.2021.06.17.08.22.45
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 17 Jun 2021 08:22:46 -0700 (PDT)
From:   Amir Goldstein <amir73il@gmail.com>
To:     Miklos Szeredi <miklos@szeredi.hu>
Cc:     Chengguang Xu <cgxu519@mykernel.net>, linux-unionfs@vger.kernel.org
Subject: [PATCH v2 0/3] Overlayfs fileattr related fixes
Date:   Thu, 17 Jun 2021 18:22:38 +0300
Message-Id: <20210617152241.987010-1-amir73il@gmail.com>
X-Mailer: git-send-email 2.32.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-unionfs.vger.kernel.org>
X-Mailing-List: linux-unionfs@vger.kernel.org

Miklos,

With these patches, copy up preserves the vfs aware subset of fileattr
flags, so xfstest overlay/075 passes.

I've tested also some generic chattr xfstests and written a new test
to verify the logic of overlay.xflags xattr [2].

Changes since v1 [1]:
- Store (i),(a) flags in xattr text format
- Copy up (A),(S) flags to upper fileattr
- Fixes the problems with setting ovl dirs and hardlinks immutable

[1] https://lore.kernel.org/linux-unionfs/CAJfpeguMQca-+vTdzoDdDWNJraWyqMa3vYRFDWPMk_R6-L7Obw@mail.gmail.com/
[2] https://github.com/amir73il/xfstests/commits/ovl-xflags

Amir Goldstein (3):
  ovl: pass ovl_fs to ovl_check_setxattr()
  ovl: copy up sync/noatime fileattr flags
  ovl: consistent behavior for immutable/append-only inodes

 fs/overlayfs/copy_up.c   |  72 +++++++++++++---
 fs/overlayfs/dir.c       |   6 +-
 fs/overlayfs/inode.c     |  58 ++++++++++---
 fs/overlayfs/namei.c     |   2 +-
 fs/overlayfs/overlayfs.h |  44 +++++++++-
 fs/overlayfs/util.c      | 178 ++++++++++++++++++++++++++++++++++++++-
 6 files changed, 323 insertions(+), 37 deletions(-)

-- 
2.32.0

