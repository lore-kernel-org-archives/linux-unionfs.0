Return-Path: <linux-unionfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9EE3DC4742C
	for <linux-unionfs@archiver.kernel.org>; Mon, 16 Nov 2020 04:58:27 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 2AF06222B9
	for <linux-unionfs@archiver.kernel.org>; Mon, 16 Nov 2020 04:58:26 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=sargun.me header.i=@sargun.me header.b="IvG0OnuD"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726248AbgKPE6G (ORCPT
        <rfc822;linux-unionfs@archiver.kernel.org>);
        Sun, 15 Nov 2020 23:58:06 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41064 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726136AbgKPE6G (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Sun, 15 Nov 2020 23:58:06 -0500
Received: from mail-pf1-x444.google.com (mail-pf1-x444.google.com [IPv6:2607:f8b0:4864:20::444])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 45809C0613CF
        for <linux-unionfs@vger.kernel.org>; Sun, 15 Nov 2020 20:58:06 -0800 (PST)
Received: by mail-pf1-x444.google.com with SMTP id c20so12998801pfr.8
        for <linux-unionfs@vger.kernel.org>; Sun, 15 Nov 2020 20:58:06 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=sargun.me; s=google;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=QcuJ1NW1YehWmgBg+VMQk/gptB71q8qjLJoFS+oaQgQ=;
        b=IvG0OnuDg7tSmG/wMSi6LFasb821mx8kxTb/57T5OKotMpT7K38Hhw5MApIRhprBwa
         elbeyvHZ1W+1gBN74MvUaVUIMP1K3BH8JfWFXnZnbSEeBk2h335F18WkNFmaMT0e+0HP
         HJwO5YZwhvFp97+ozVljxjnpRVRK6Ga4ysNcE=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=QcuJ1NW1YehWmgBg+VMQk/gptB71q8qjLJoFS+oaQgQ=;
        b=ZIGewDocTk9mftghK/ykeEIR16xeD42TifMglEyxFaG6ExJkvquvlOVz67fHJAs9w3
         5rDgCMG52ctErLNRwvFuYYarhJZPO/QAdibuvnZV7sF4zh6+1lkQDeww9j1kiWFJe906
         F7b9xO1vvp8eXAmE1eA0vgkMI6JS0UrnA4DN06beV30tZG41iKogIozLasWZoQmPHIq0
         2i99ipAKIlSk3+d/xRtdBhdJmN62S6k+iYgVoo9um/qFb3w9h+VS86dCbgsfC+fmeJaN
         F6dDBoEZw0tW4A54BDhG7jfVdhID/Qd9pDUou7jfwDTpVQZI4jc6ePDzY56y1Arh/DGY
         ikaw==
X-Gm-Message-State: AOAM5338JtM+pq/6jXcv31Wlj0vc4ZbrRrunhDflCXqldzovdd2Sg5lq
        2CtANZipMteJrApFtWCHYOzoqI8AcZk7ni/K
X-Google-Smtp-Source: ABdhPJwsxhWT1OCo0uHgeIfsl7H/4jzg73m/Rmmg895T6/QYk6mOE9q+qc3a5crrxZYynMZ12GyZSg==
X-Received: by 2002:a63:5864:: with SMTP id i36mr11751358pgm.68.1605502685214;
        Sun, 15 Nov 2020 20:58:05 -0800 (PST)
Received: from ubuntu.netflix.com (203.20.25.136.in-addr.arpa. [136.25.20.203])
        by smtp.gmail.com with ESMTPSA id v23sm16465284pjh.46.2020.11.15.20.58.03
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 15 Nov 2020 20:58:04 -0800 (PST)
From:   Sargun Dhillon <sargun@sargun.me>
To:     linux-unionfs@vger.kernel.org, miklos@szeredi.hu,
        Alexander Viro <viro@zeniv.linux.org.uk>
Cc:     Sargun Dhillon <sargun@sargun.me>,
        Giuseppe Scrivano <gscrivan@redhat.com>,
        Vivek Goyal <vgoyal@redhat.com>,
        Daniel J Walsh <dwalsh@redhat.com>,
        David Howells <dhowells@redhat.com>
Subject: [RFC PATCH 0/3] Make overlayfs volatile mounts reusable
Date:   Sun, 15 Nov 2020 20:57:55 -0800
Message-Id: <20201116045758.21774-1-sargun@sargun.me>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-unionfs.vger.kernel.org>
X-Mailing-List: linux-unionfs@vger.kernel.org

The volatile option is great for "ephemeral" containers. Unfortunately,
it doesn't capture all uses. There are two ways to use it safely right now:

1. Throw away the entire upperdir between mounts
2. Manually syncfs between mounts

For certain use-cases like serverless, or short-lived containers, it is
advantageous to be able to stop the container (runtime) and start it up on
demand / invocation of the function. Usually, there is some bootstrap
process which involves downloading some artifacts, or putting secrets on
disk, and then upon invocation of the function, you want to (re)start the
container.

If you have to syncfs every time you do this, it can lead to excess
filesystem overhead for all of the other containers on the machine, and
stall out every container who's upperdir is on the same underlying
filesystem, unless your filesystem offers something like subvolumes,
and if sync can be restricted to a subvolume.

The kernel has information that it can use to determine whether or not this
is safe -- primarily if the underlying FS has had writeback errors or not.
Overlayfs doesn't delay writes, so the consistency of the upperdir is not
contingent on the mount of overlayfs, but rather the mount of the
underlying filesystem. It can also make sure the underlying filesystem
wasn't remounted. Although, it was suggested that we use derive this
information from the upperdir's inode[1], we can checkpoint this data on
disk in an xattr.

Specifically we checkpoint:
  * Superblock "id": This is a new concept introduced in one of the patches
    which keeps track of (re)mounts of filesystems, by having a per boot
    monotonically increasing integer identifying the superblock. This is
    safer than trying to obfuscate the pointer and putting it into an
    xattr (due to leak risk, and address reuse), and during the course
    of a boot, the u64 should not wrap.
  * Overlay "boot id": This is a new UUID that is overlayfs specific,
    as overlayfs is a module that's independent from the rest of the
    system and can be (re)loaded independently -- thus it generates
    a UUID at load time which can be used to uniquely identify it.
  * upperdir / workdir errseq: A sample of the errseq_t on the workdir /
    upperdir's superblock. Since the errseq_t is implemented as a u32
    with errno + error counter, we can safely store it in a checkpoint.
    

[1]: https://lore.kernel.org/linux-unionfs/CAOQ4uxhadzC3-kh-igfxv3pAmC3ocDtAQTxByu4hrn8KtZuieQ@mail.gmail.com/

Sargun Dhillon (3):
  fs: Add s_instance_id field to superblock for unique identification
  overlay: Add ovl_do_getxattr helper
  overlay: Add the ability to remount volatile directories when safe

 Documentation/filesystems/overlayfs.rst |  5 +-
 fs/overlayfs/overlayfs.h                | 43 +++++++++++++
 fs/overlayfs/readdir.c                  | 86 +++++++++++++++++++++++--
 fs/overlayfs/super.c                    | 22 ++++++-
 fs/super.c                              |  3 +
 include/linux/fs.h                      |  7 ++
 include/uapi/linux/fs.h                 |  2 +
 7 files changed, 160 insertions(+), 8 deletions(-)

-- 
2.25.1

