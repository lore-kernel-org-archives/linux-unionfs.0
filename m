Return-Path: <linux-unionfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7CA8AEB64DD
	for <linux-unionfs@archiver.kernel.org>; Thu, 13 Jul 2023 12:03:59 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233058AbjGMMD6 (ORCPT
        <rfc822;linux-unionfs@archiver.kernel.org>);
        Thu, 13 Jul 2023 08:03:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60046 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231280AbjGMMD5 (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Thu, 13 Jul 2023 08:03:57 -0400
Received: from mail-wr1-x42f.google.com (mail-wr1-x42f.google.com [IPv6:2a00:1450:4864:20::42f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 92D8F1FCD
        for <linux-unionfs@vger.kernel.org>; Thu, 13 Jul 2023 05:03:56 -0700 (PDT)
Received: by mail-wr1-x42f.google.com with SMTP id ffacd0b85a97d-3141fa31c2bso732152f8f.2
        for <linux-unionfs@vger.kernel.org>; Thu, 13 Jul 2023 05:03:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1689249835; x=1691841835;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=TYvnZZXuWBP4YQ84uNj7MPEh7CAwYkVJ9xSCzws7dLk=;
        b=Rk+bcRo1uxb0ssUJZY5N3k7e/oH5rxoaBhnuu9WD5wXMtrblFCmlAhFzVrLR11qjUx
         kKSM+rd81JPqpjjnNIOd/Cs2Qgtk106olbE3gvo90zJtV2mh4NC5E6D60OrRb8iYSiFf
         ViIa4o3pCEuOEv+qLDpl+5bYaWyITdQFZqbByKIA0oyeeYkSJ5k0ZKChVwiZqIRQ02Ry
         Iaw9fCBYqQar17Z6XG5LVxIP6hikOoy6uzeBmqBXWp/e4V6IeIUGfdgDNBY7AsImAwkI
         t5FvIbZl5l8gnaYmNAjb8+W1VQLCqlEz4GOZMrHY/E2Imgh+Epf+vR3AzNV8XqXnPNGU
         5GBw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1689249835; x=1691841835;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=TYvnZZXuWBP4YQ84uNj7MPEh7CAwYkVJ9xSCzws7dLk=;
        b=EmhOZFPHXYGnsbWZ5LhC5t7BRlTvacSmNudtg5VTRxiFWaWX2PraamzziRk2eRqoP8
         jzU5lIh55T2QCxVI1l7LoD+0uZWW+AJfVnuTi6hkfYmlZEVm9Eo11mpJgyIOcYRFmwZD
         KC8TynAn0no9YgRe5hUmUoctqkxjRivnO7Zvcud336W1R83agi1Zx+rSZaIqFkrB+Ha9
         yycu0sSFyVT5e419EbmZqllO38igy/aLHaGh6NJZk4OCacNJLtHzQn42HUgL1ug75oPR
         dCQVILGTP/+nPZ7ivmDHIfR7LOJoc+/Yww3N9/1cQ0zTys57a9XN6Uqo5WgCcaehqKOO
         v40w==
X-Gm-Message-State: ABy/qLanqh9VhbV1ku4GH84IkazJqVmZ2YuGgV+xOjYowF42jNpUF5Pr
        UuAWud2U6NfKs4nLDtGjYU4=
X-Google-Smtp-Source: APBJJlGcdmCTrs6grn9c+OJiXHe2i8VXm5nGE+wziobRgQifo8whpigH+V009/ew6VozYJfWJ8pdKg==
X-Received: by 2002:a05:6000:50:b0:314:8d:7eb5 with SMTP id k16-20020a056000005000b00314008d7eb5mr1252975wrx.29.1689249834686;
        Thu, 13 Jul 2023 05:03:54 -0700 (PDT)
Received: from amir-ThinkPad-T480.lan ([5.29.249.86])
        by smtp.gmail.com with ESMTPSA id cr13-20020a05600004ed00b003143ba62cf4sm7848772wrb.86.2023.07.13.05.03.53
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 13 Jul 2023 05:03:54 -0700 (PDT)
From:   Amir Goldstein <amir73il@gmail.com>
To:     Miklos Szeredi <miklos@szeredi.hu>
Cc:     Jan Kara <jack@suse.cz>, Christian Brauner <brauner@kernel.org>,
        linux-unionfs@vger.kernel.org
Subject: [PATCH v2 0/4] Report overlayfs file ids with fanotify
Date:   Thu, 13 Jul 2023 15:03:40 +0300
Message-Id: <20230713120344.1422468-1-amir73il@gmail.com>
X-Mailer: git-send-email 2.34.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-unionfs.vger.kernel.org>
X-Mailing-List: linux-unionfs@vger.kernel.org

Miklos,

This is the second part of the work to support fanotify reporting of
events with file ids on overlayfs.  The fanotify_event_info_fid struct
reported with fanotify events has an object file handle and an fsid,
so fanotify requires that filesystems can encode file handles and have
a non-zero f_fsid.

The first part [1] that was merged to v6.5-rc1, relaxed the fanotify
requirements for filesystems to support reporting events with fid to
require only the ->encode_fh() export operation.

Patch 1 changes overlayfs export_operations to meet the new requirements
with the default overlay configurations (i.e. no need for nfs_export=on),
thus, allowing an fanotify watch with FAN_REPORT_FID on overlayfs.
There are LTS tests [2] for fanotify(FAN_REPORT_FID) + overlayfs.

Patches 2-4 are not strcitly needed to support reporting fanotify events
with fid, because overlayfs already reports a non-zero f_fsid, it's just
not a unique fsid.  So before allowing to report events with overlayfs
fids, I wanted to fix overlayfs fsid to be more unique.

I wanted to implement a persistent and unique fsid for overlayfs.
I wanted it to be the default behavior, but needed to avoid breaking
applications that rely on an existing overlayfs fsid to persist.
I came up with a solution that is described in patch 4 (uuid=auto) that
meets all the requirement above.
There is an xfstest to test the persistent-unique fsid feature [3].

This patch set has been in overlayfs-next for soaking since v6.5-rc1.
If you have any reservations that we will not be able to resolve in time
for 6.6, especially regarding the on-disk format and backward compat,
we could also merge only patch 1 and leave the fsid patches for later.

Thanks,
Amir.

[1] https://lore.kernel.org/linux-fsdevel/20230425130105.2606684-1-amir73il@gmail.com/
[2] https://github.com/amir73il/ltp/commits/ovl_encode_fid
[3] https://github.com/amir73il/xfstests/commits/ovl_fsid


Amir Goldstein (4):
  ovl: support encoding non-decodable file handles
  ovl: add support for unique fsid per instance
  ovl: store persistent uuid/fsid with uuid=on
  ovl: auto generate uuid for new overlay filesystems

 Documentation/filesystems/overlayfs.rst | 25 ++++++++++
 fs/overlayfs/copy_up.c                  |  2 +-
 fs/overlayfs/export.c                   | 26 ++++++++---
 fs/overlayfs/inode.c                    |  2 +-
 fs/overlayfs/namei.c                    |  5 +-
 fs/overlayfs/overlayfs.h                | 22 +++++++++
 fs/overlayfs/ovl_entry.h                |  3 +-
 fs/overlayfs/params.c                   | 31 +++++++++++--
 fs/overlayfs/super.c                    | 29 ++++++++++--
 fs/overlayfs/util.c                     | 61 +++++++++++++++++++++++++
 10 files changed, 186 insertions(+), 20 deletions(-)

-- 
2.34.1

