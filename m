Return-Path: <linux-unionfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A89B6C433ED
	for <linux-unionfs@archiver.kernel.org>; Sun, 25 Apr 2021 07:14:50 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 8755261288
	for <linux-unionfs@archiver.kernel.org>; Sun, 25 Apr 2021 07:14:50 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230196AbhDYHP3 (ORCPT
        <rfc822;linux-unionfs@archiver.kernel.org>);
        Sun, 25 Apr 2021 03:15:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33034 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230194AbhDYHP2 (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Sun, 25 Apr 2021 03:15:28 -0400
Received: from mail-wr1-x434.google.com (mail-wr1-x434.google.com [IPv6:2a00:1450:4864:20::434])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8DA0AC061574;
        Sun, 25 Apr 2021 00:14:49 -0700 (PDT)
Received: by mail-wr1-x434.google.com with SMTP id j5so51590655wrn.4;
        Sun, 25 Apr 2021 00:14:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=j9ebeZLhPtpy/4ObvG3aF+B5zxZTmEi/bwnNXqNswBs=;
        b=OzLExM2KO05Ojsf49Usa0i3pRS4UnGAQdG49SbJdxq7+H6igZA1leWB1MAGWjwA0h9
         5Dk4Sy0tsD3yPawIyZZIhDkhoBNwcQZR/FgQLAOPFDUv6IHlOFy4bazLkYXwBFD1JOry
         L1tpZSydONz4LjLMqhK4RMCPJRTnS8urlXClNevwMHvXyO1nijBLD2U9LCoeMrYOn2vu
         QQ8fzE47SJ6wnmhjNgwSF5gq4+XSmOEPJHcbYM9pUGk8eWh9EXSpNstNozHfp/IYx2WU
         F0G1fjDRATn5EUL0pXx1yZ0hVs/2+cAKPizICN40Gs83A0vaL5JdrHbz5EEYbmnFzKF+
         Bdag==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=j9ebeZLhPtpy/4ObvG3aF+B5zxZTmEi/bwnNXqNswBs=;
        b=fLYWv1GdZt9zTCsaMFdzgj66YCHofUnDW6hJJvr2knaHvAbNA9ihsBBO+jTLFlwKuV
         9lckf0+jQ4wEonq5Mf73FTkVQ2v3o5pLMzBdAyuudF/sGi43Anms1npmGD2PJ2p8Zl8e
         NN0OCcC1PgqvPzUVli1FLF/E1wi8BR73wvgimXagYJGKjo6vd7iAOpPEPYS4ZW1Wzeme
         FWi4E6BbovDeKPubuMIbM2UcVyMZ4TktMYuFhE/8ln1yhgqCatKpwzz8GmGlGonvyyis
         VUWvXGMkA78JJ62b5XTa1awC7HyTI57FInEMJMFlZ81JvP+LLtb0snZIXE50nhM9oJe1
         I0dg==
X-Gm-Message-State: AOAM533nxiEt2rzoCSdzV4LiaM3cRZQ6Rk+bKlKbrzB5/Zg+Jnq0n8W7
        B/3zdxcfKrym/5kMfN2NZPZ9NHIsSQM=
X-Google-Smtp-Source: ABdhPJweEi6dsTNN0eCdg88Z4JSEukgpSoo/NPTkWLAQrlNaSurTWcBov4ZUnTOr+YrwFGlyrvp9+w==
X-Received: by 2002:adf:e60e:: with SMTP id p14mr14831513wrm.427.1619334887486;
        Sun, 25 Apr 2021 00:14:47 -0700 (PDT)
Received: from localhost.localdomain ([82.114.44.37])
        by smtp.gmail.com with ESMTPSA id x189sm15885626wmg.17.2021.04.25.00.14.46
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 25 Apr 2021 00:14:47 -0700 (PDT)
From:   Amir Goldstein <amir73il@gmail.com>
To:     Eryu Guan <guaneryu@gmail.com>
Cc:     Miklos Szeredi <miklos@szeredi.hu>, linux-unionfs@vger.kernel.org,
        fstests@vger.kernel.org
Subject: [PATCH v2 0/5] Test overlayfs readdir cache
Date:   Sun, 25 Apr 2021 10:14:40 +0300
Message-Id: <20210425071445.29547-1-amir73il@gmail.com>
X-Mailer: git-send-email 2.31.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-unionfs.vger.kernel.org>
X-Mailing-List: linux-unionfs@vger.kernel.org

Eryu,

This extends the generic t_dir_offset2 helper program to verify
some cases of missing/stale entries and adds a new generic test which
passes on overlayfs (and other fs) on upstream kernel.

The overlayfs specific test fails on upstream kernel and the fix commit
is currently in linux-next.  As usual, you may want to wait with merging
until the fix commit hits upstream.

Based on feedback from Miklos, I changed the test to check for the
missing/stale entries on a new fd, while old fd is kept open, because
POSIX allows for stale/missing entries in the old fd.

I was looking into another speculated bug in overlayfs which involves
multiple calls to getdents.  Although it turned out that overlayfs does
not have the speculated bug, I left both generic and overlay test with
multiple calls to getdents in order to excersize the relevant code.

The attached patch was used to verify that the overlayfs test excercises
the call to ovl_cache_update_ino() with stale entries.
Overlayfs populates the merge dir readdir cache with a list of files in
the first getdents call, but updates d_ino of files on the list in
subsequent getdents calls.  By that time, the last entry is stale and the
following warning is printed (on linux-next with patch below applied):
[   ] overlayfs: failed to look up (m100) for ino (0)
[   ] overlayfs: failed to look up (f100) for ino (0)

Miklos,

Do you think it is worth the trouble to set p->is_whiteout and skip
dir_emit() in this case? and do we need to worry about lookup_one_len()
returning -ENOENT in this case?

Thanks,
Amir.

Changes since v1:
- Use small getdents buffer to force multiple calls
- Tidy up new command line options for t_dir_offset2
- Check missing/stale entries on new fd
- Add impure dir use case to overlay test

Amir Goldstein (5):
  src/t_dir_offset2: Add an option to limit of buffer size
  src/t_dir_offset2: Add an option to find file by name
  src/t_dir_offset2: Add option to create or unlink file
  generic: Test readdir of modified directrory
  overlay: Test invalidate of readdir cache

 src/t_dir_offset2.c   | 113 ++++++++++++++++++++++++++++++++++++++--
 tests/generic/700     |  62 ++++++++++++++++++++++
 tests/generic/700.out |   2 +
 tests/generic/group   |   1 +
 tests/overlay/077     | 117 ++++++++++++++++++++++++++++++++++++++++++
 tests/overlay/077.out |   2 +
 tests/overlay/group   |   1 +
 7 files changed, 293 insertions(+), 5 deletions(-)
 create mode 100755 tests/generic/700
 create mode 100644 tests/generic/700.out
 create mode 100755 tests/overlay/077
 create mode 100644 tests/overlay/077.out

--
diff --git a/fs/overlayfs/readdir.c b/fs/overlayfs/readdir.c
index cc1e80257064..cadcbfafa179 100644
--- a/fs/overlayfs/readdir.c
+++ b/fs/overlayfs/readdir.c
@@ -486,7 +486,7 @@ static int ovl_cache_update_ino(struct path *path, struct ovl_cache_entry *p)
                        this = NULL;
                        goto fail;
                }
-               goto out;
+               goto fail;
        }
 
 get:
-- 
2.31.1

