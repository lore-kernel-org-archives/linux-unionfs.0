Return-Path: <linux-unionfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D86D2C77B6C
	for <linux-unionfs@archiver.kernel.org>; Sat,  8 Apr 2023 16:43:13 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229452AbjDHQnM (ORCPT
        <rfc822;linux-unionfs@archiver.kernel.org>);
        Sat, 8 Apr 2023 12:43:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49936 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229448AbjDHQnM (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Sat, 8 Apr 2023 12:43:12 -0400
Received: from mail-wr1-x430.google.com (mail-wr1-x430.google.com [IPv6:2a00:1450:4864:20::430])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6096330D7
        for <linux-unionfs@vger.kernel.org>; Sat,  8 Apr 2023 09:43:10 -0700 (PDT)
Received: by mail-wr1-x430.google.com with SMTP id o18so1202181wro.12
        for <linux-unionfs@vger.kernel.org>; Sat, 08 Apr 2023 09:43:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1680972189; x=1683564189;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=j40uEkYMQTLR+ypLkJOQ1VpEWVaEKGPfF21ze7J6FIc=;
        b=OJr8xpOeZKOsfq7DTZnrEAmaAoHECmh8yD5IjyfgSBEl4VCnhj7EiHxLuiGGskVTg4
         zfoGXFbFkDLIAe+E8/Z7nPNak50CyDj0XFzfOk7Ie94Ex7O3hMq3h4sVZoP8Q2wC6//s
         iwg9Efcp3z00jsHnFQAc0G5oBDZTilPZGE6LMAtqFG/DoB0vhEQzcKwaU3cKr9Kdbwup
         tvCCXKrwMr5outVDJGqC+Jj+47uJukzSkcjbG6g7Wf45jcNdeX4qXTqZSClLLcWuQDu7
         ruZqnnh59IeBiKHK5JcwQ2jm0qZg1fKicpwY+vIcpv1gnMoRcm2ouM2RfuFEmmazYGoI
         HaKg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1680972189; x=1683564189;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=j40uEkYMQTLR+ypLkJOQ1VpEWVaEKGPfF21ze7J6FIc=;
        b=vbyOfOpe/H73MMWC5K/FlNE8+K6+OIvIm5QPRbOsmU9czfVKGTiGhkw6LEkUWVZFQO
         onmMCcKwMGbmDU63xaCW6McvLWVsOUhfTzCnfI3IOLBm7jaFpJ5kmOMkwqsPgWpggpIY
         aYusP5OF3CjmKbhiONoSbp6cBjeoXJ6H46Z+KOZ63XblTzWaRQPMoFDSV2kgXayLKOpo
         5VgXBCeXK0eKaBa8SI6szRSNuswPbNZRxDO6af2s3Js0na/lvEpqUxsgytrxlF9wNMpP
         6q7lylme2TAAAZZR3kqw/11QiIBmrsrU2wZnehC6+Uz1eCMP5cvR919aYk7udnxB/ipz
         nD2Q==
X-Gm-Message-State: AAQBX9cpCfO8YKxLBf07g+pvIS9bqdZu6wXcChrz6Gg5jdRq2Euu1M9q
        IBwbQx+YYIlyrGG5TjVj1LE=
X-Google-Smtp-Source: AKy350YLSALYadk/19iw02GcMC8E9PRs2bbohgUa7nRWll+WRD3ZHoHntY8kYkS+vq7Bd+3+dMfXKg==
X-Received: by 2002:a5d:6b90:0:b0:2ef:b5ce:25b2 with SMTP id n16-20020a5d6b90000000b002efb5ce25b2mr1180133wrx.46.1680972188439;
        Sat, 08 Apr 2023 09:43:08 -0700 (PDT)
Received: from amir-ThinkPad-T480.lan ([5.29.249.86])
        by smtp.gmail.com with ESMTPSA id w9-20020adfec49000000b002cde25fba30sm7370438wrn.1.2023.04.08.09.43.07
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 08 Apr 2023 09:43:08 -0700 (PDT)
From:   Amir Goldstein <amir73il@gmail.com>
To:     Miklos Szeredi <miklos@szeredi.hu>
Cc:     Alexander Larsson <alexl@redhat.com>, linux-unionfs@vger.kernel.org
Subject: [PATCH 0/7] Prepare for lazy lowerdata lookup
Date:   Sat,  8 Apr 2023 19:42:55 +0300
Message-Id: <20230408164302.1392694-1-amir73il@gmail.com>
X-Mailer: git-send-email 2.34.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-unionfs.vger.kernel.org>
X-Mailing-List: linux-unionfs@vger.kernel.org

Miklos,

This series is a cleanup towards the lazy lowerdata lookup patches that
I mentioned in an earlier email [1].  The lazy lowerdata patches are
ready including tests, but I am waiting for your feedback on the
data-only layers before I post the complete series.

I am posting this cleanup series independently, because it mostly [*]
stands on its own.

Specifically, patch #1 is a bug fix for stable.

Feel free to take just patch #1, or only part of the cleanup or wait for
the posting of the complete work.

Thanks,
Amir.

[*] The last patch, which reserves the space for lowerdata_redirect is
not completely independent of the lazy lowerdata series, but I preferred
to do it this way then to remove the lowerdata inode union field and add
lowerdata_redirect later, because I think the change is easier to review
this way.

[1] https://lore.kernel.org/linux-unionfs/CAOQ4uxich227fP7bGSCNqx-JX5h36O-MLwqPoy0r33tuH=z2cA@mail.gmail.com/

Amir Goldstein (7):
  ovl: update of dentry revalidate flags after copy up
  ovl: use OVL_E() and OVL_E_FLAGS() accessors
  ovl: use ovl_numlower() and ovl_lowerstack() accessors
  ovl: factor out ovl_free_entry() and ovl_stack_*() helpers
  ovl: move ovl_entry into ovl_inode
  ovl: deduplicate lowerpath and lowerstack[0]
  ovl: replace lowerdata inode reference with lowerdata redirect

 fs/overlayfs/copy_up.c   |   2 +
 fs/overlayfs/dir.c       |   5 +-
 fs/overlayfs/export.c    |  37 ++++-----
 fs/overlayfs/inode.c     |  20 ++---
 fs/overlayfs/namei.c     |  75 +++++++++---------
 fs/overlayfs/overlayfs.h |  24 ++++--
 fs/overlayfs/ovl_entry.h |  63 +++++++++++----
 fs/overlayfs/super.c     |  86 +++++++-------------
 fs/overlayfs/util.c      | 164 +++++++++++++++++++++++++++++----------
 9 files changed, 281 insertions(+), 195 deletions(-)

-- 
2.34.1

