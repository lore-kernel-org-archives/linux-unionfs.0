Return-Path: <linux-unionfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E3107C433EF
	for <linux-unionfs@archiver.kernel.org>; Fri,  8 Jul 2022 09:01:58 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237599AbiGHJB6 (ORCPT
        <rfc822;linux-unionfs@archiver.kernel.org>);
        Fri, 8 Jul 2022 05:01:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57398 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237582AbiGHJB5 (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Fri, 8 Jul 2022 05:01:57 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E383130F76
        for <linux-unionfs@vger.kernel.org>; Fri,  8 Jul 2022 02:01:56 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 9294EB82180
        for <linux-unionfs@vger.kernel.org>; Fri,  8 Jul 2022 09:01:55 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2E964C341C0;
        Fri,  8 Jul 2022 09:01:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1657270914;
        bh=i3CEH+tOicbi4K3qGnESPQs0M3tzQELzgMNP2mzJ5rE=;
        h=From:To:Cc:Subject:Date:From;
        b=tNKJnbNQmO9leBNsoh5pPBtThXf6W2f977SRZGoO3AhLXa5JpdZ+VyuVRnFisFhyf
         1XbqobX55h34ZKevDZw7xrrqMdeINAjxbuzzHS45R3hms3q8S7G6ZcLgtt1I/vz11T
         Qn+dYhe+zWAydlUkOY6EBiZ/N0pPHuOYfjrc5xI1QC4dOmyZynKGWIFbJc7U2PWafn
         nGMAe+swcgAu+yEbB/DQ1+xDmtLdQKX1LAAaMIQ8ulEUCvb9nJ5Hl3qHEJglaPotRR
         EXyfBXrsqPVvAHDNWvjkDw5R0pw0BJJyLc57jVUVtyMjA/b1DbeYG7D1dW6cRHnkfm
         zc1e4eqp66OOA==
From:   Christian Brauner <brauner@kernel.org>
To:     Seth Forshee <sforshee@digitalocean.com>,
        Amir Goldstein <amir73il@gmail.com>,
        Miklos Szeredi <mszeredi@redhat.com>
Cc:     "Christian Brauner (Microsoft)" <brauner@kernel.org>,
        Vivek Goyal <vgoyal@redhat.com>,
        Christoph Hellwig <hch@lst.de>,
        Aleksa Sarai <cyphar@cyphar.com>, linux-unionfs@vger.kernel.org
Subject: [PATCH v2 0/3] ovl: acl fixes
Date:   Fri,  8 Jul 2022 11:01:31 +0200
Message-Id: <20220708090134.385160-1-brauner@kernel.org>
X-Mailer: git-send-email 2.34.1
MIME-Version: 1.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=2110; h=from:subject; bh=7bBjnabeH8c3RPaUFAhPTJKKnMj0CAdhAhkof66NYRQ=; b=owGbwMvMwCU28Zj0gdSKO4sYT6slMSQd/8SZ8Kf7xH2hOZ9YJz1kj61+ss11et6qsocWbCf/3Yk/ 8I/7f0cpC4MYF4OsmCKLQ7tJuNxynorNRpkaMHNYmUCGMHBxCsBEEp4wMsxiqlBZ/DB/nt5DV/GVx0 61bvwvrjP/7JeuxnnFapOmeK1gZFg4gX1mqsrH1eJx1yt2dWyrPs8Sz5W+6qfe7chlPH2O5gwA
X-Developer-Key: i=brauner@kernel.org; a=openpgp; fpr=4880B8C9BD0E5106FC070F4F7B3C391EFEA93624
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-unionfs.vger.kernel.org>
X-Mailing-List: linux-unionfs@vger.kernel.org

From: "Christian Brauner (Microsoft)" <brauner@kernel.org>

Hey everyone,
Hey Miklos,

This is the series I described and announced in the commit message to
the patch I sent yesterdat (see [1]). It enables POSIX ACLs for
overlayfs on top of idmapped layers. It encompasses everything that is
needed to make this work correctly. There is a detailed explanation in
the first patch of this series so I won't repeat it all here in the
cover letter.

My plan would be to get this ready for the next merge window.
Once Miklos has merged the temporary fix I sent out yesterday in [1] and
it shows up in mainline I will rebase this series on top of the next
mainline rc. I will then add a revert of the fix in [1] to this series
reenabling POSIX ACL support for overlayfs on top of idmapped layers.

I will also merge in the vfs{g,u}id_t work that is in -next replacing
the old idmapped mount helpers with the new type safe idmapping helpers.

This survives LTP and xfstests:
sudo ./runltp -f fs_perms_simple,fs_bind,containers,cap_bounds,cve,uevent,filecaps
sudo ./check -g quick
sudo ./check -g overlay/union -overlay
sudo ./check -g quick -overlay
sudo ./check -g overlay/union -overlay # export IDMAPPED_MOUNTS=true
sudo ./check -g quick -overlay # export IDMAPPED_MOUNTS=true

Note that I'll be on vacation next week and so will be looking at mail
less frequently.

Thanks!
Christian

[1]: https://lore.kernel.org/linux-unionfs/20220707130520.321344-1-brauner@kernel.org

Christian Brauner (3):
  acl: move idmapped mount fixup into vfs_{g,s}etxattr()
  acl: make posix_acl_clone() available to overlayfs
  ovl: handle idmappings in ovl_get_acl()

 fs/ksmbd/vfs.c                  |   2 +-
 fs/ksmbd/vfs.h                  |   2 +-
 fs/overlayfs/inode.c            |  86 +++++++++++++++++--
 fs/overlayfs/overlayfs.h        |   3 +-
 fs/posix_acl.c                  | 142 ++++++++++++++++++++++----------
 fs/xattr.c                      |  25 ++++--
 include/linux/posix_acl.h       |   1 +
 include/linux/posix_acl_xattr.h |  34 +++++---
 include/linux/xattr.h           |   2 +-
 9 files changed, 224 insertions(+), 73 deletions(-)


base-commit: 88084a3df1672e131ddc1b4e39eeacfd39864acf
-- 
2.34.1

