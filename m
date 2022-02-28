Return-Path: <linux-unionfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 19DBDC433FE
	for <linux-unionfs@archiver.kernel.org>; Mon, 28 Feb 2022 11:39:30 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235916AbiB1LkF (ORCPT
        <rfc822;linux-unionfs@archiver.kernel.org>);
        Mon, 28 Feb 2022 06:40:05 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34922 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235901AbiB1LkF (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Mon, 28 Feb 2022 06:40:05 -0500
Received: from mail-wr1-x429.google.com (mail-wr1-x429.google.com [IPv6:2a00:1450:4864:20::429])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 70BD7546BD;
        Mon, 28 Feb 2022 03:39:26 -0800 (PST)
Received: by mail-wr1-x429.google.com with SMTP id n14so14936520wrq.7;
        Mon, 28 Feb 2022 03:39:26 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=0ctFKY1Dn2SOXBB41lbEysb0dPgkRzW0iBsvqQk91OU=;
        b=cGb9pCH7UGzehVfHvOjm/Xn7p05IpP4lbxAKR6gMNebpfRLPE0PwwnAGZyFaDk/HGB
         sYQvvMzjkx9z97y3tVVToewgpsROikL/YVo0OY7YN0YHtPM7vcNe/8QEhATSzZchsf3W
         FHdFotQxcCKV4qXyAoWUnAUPgm8dMRal519rcQZkgfmM0JsdhC1ocIOz8AxCvj5RoWBS
         c1676/YahJPFJyGDA/h+aH+p+nLKjJDURytvQrZLIIKSzZ2JTiisLKKeaCHzHDi+6Djx
         RO5I468fdtpOdK8omzgbsD4qZhXszqFkuJ7HthRH1YD+RwV6dgwbHpQTvGNLNT8EBRfR
         D88A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=0ctFKY1Dn2SOXBB41lbEysb0dPgkRzW0iBsvqQk91OU=;
        b=4OSqIqKCOyUBUO2Gyupwtq+j2Jw9IEQ7fZqAJhXipgMKwwCxdsJqUVRzbF7U4FfVW3
         qiqApM23IA/1aPF9qN6LRp0SUn+scHjsJlc0KyEzt4FL2uZdR/VjLBZmsVmCpzKcmuJf
         OrSfNF2avlMfy5aM5Gas8nK2k0uQ6Wg/9zSXfzTjSotwcCmxXbKwGr/MWyiu9v7NVP2n
         jpn+utOw6hTvZypMAJbztR/lpn8JS+aQAuQKF1LaFHe4/yE5/P8d2ajJsZC0cic8v0LD
         ucz9H5aeNUl+qgE3wcIAqu+aZ0I8Lh6iyrXhVsRf9WzSuZsoDKIPYahWYIqOy5M7HHb4
         A/oA==
X-Gm-Message-State: AOAM533L0L0bNHMqazLl5N54gk7+s24LBLp6BqAv/QT3cbAc7ocspGrQ
        eBx3q4o6KrvbN/2EGWPh1Ew=
X-Google-Smtp-Source: ABdhPJwRZNFnQcCrZ2+w//6tqhbE5mVDn4g5ft1kXezw3dJ3TT4+y5r8du32rDQ3WDw6Xa05wuvfoA==
X-Received: by 2002:a05:6000:38e:b0:1ef:e106:bdc7 with SMTP id u14-20020a056000038e00b001efe106bdc7mr2046182wrf.551.1646048364916;
        Mon, 28 Feb 2022 03:39:24 -0800 (PST)
Received: from localhost.localdomain ([5.29.13.154])
        by smtp.gmail.com with ESMTPSA id e22-20020adf9bd6000000b001eda1017861sm10584592wrc.64.2022.02.28.03.39.23
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 28 Feb 2022 03:39:24 -0800 (PST)
From:   Amir Goldstein <amir73il@gmail.com>
To:     Miklos Szeredi <miklos@szeredi.hu>
Cc:     Al Viro <viro@zeniv.linux.org.uk>, linux-unionfs@vger.kernel.org,
        containers@lists.linux.dev, linux-fsdevel@vger.kernel.org
Subject: [PATCH v2 0/6] Generic per-mount io stats
Date:   Mon, 28 Feb 2022 13:39:04 +0200
Message-Id: <20220228113910.1727819-1-amir73il@gmail.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-unionfs.vger.kernel.org>
X-Mailing-List: linux-unionfs@vger.kernel.org

Miklos,

Resending those patches with only minor change even though I did get
and feedback on v1 [1].

My use case specifically is for fuse, but I think these mount stats
can be useful for container use cases, either with overlayfs or even
with bind mounts, in order to help sysadmins bisect the source of io
from containers POV.

This revision opts-in for mountstats for all fuse/overlayfs mounts,
but we could also make it always opt-in by mount options for any fs.

Thoughts?

Thanks,
Amir.

Changes since v1:
- Opt-in for per-mount io stats for overlayfs and fuse

[1] https://lore.kernel.org/linux-fsdevel/20210107214401.249416-1-amir73il@gmail.com/

Amir Goldstein (6):
  fs: add iostats counters to struct mount
  fs: tidy up fs_flags definitions
  fs: collect per-mount io stats
  fs: report per-mount io stats
  ovl: opt-in for per-mount io stats
  fuse: opt-in for per-mount io stats

 fs/Kconfig           |  9 ++++++
 fs/fuse/inode.c      |  2 +-
 fs/mount.h           | 59 +++++++++++++++++++++++++++++++++++
 fs/namespace.c       | 19 ++++++++++++
 fs/overlayfs/super.c |  2 +-
 fs/proc_namespace.c  | 13 ++++++++
 fs/read_write.c      | 73 +++++++++++++++++++++++++++++---------------
 include/linux/fs.h   | 15 ++++-----
 8 files changed, 159 insertions(+), 33 deletions(-)

-- 
2.25.1

