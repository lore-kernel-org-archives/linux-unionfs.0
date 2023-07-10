Return-Path: <linux-unionfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9177CEB64DC
	for <linux-unionfs@archiver.kernel.org>; Mon, 10 Jul 2023 09:08:59 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232382AbjGJJIr (ORCPT
        <rfc822;linux-unionfs@archiver.kernel.org>);
        Mon, 10 Jul 2023 05:08:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40290 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230419AbjGJJH6 (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Mon, 10 Jul 2023 05:07:58 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A5DE7E7
        for <linux-unionfs@vger.kernel.org>; Mon, 10 Jul 2023 02:07:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1688980042;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=Bh7l4igTYLskmItwiNWl2ecV3kqRFKnH4lQcNfK47OQ=;
        b=L2D6dIf6vfhmPJMQ0YEOZJZm21Q+1mlFD+8qJi8jxfi0y9GFc7KUaeeioJIvMOIn7gHFG/
        9z0OWwB8h1jU97v4C9xv+JHFoN+dD7hwcPLCRkdORMv6FX3dEJjQEknLFhTMaYhyMjgTAu
        chrWCUR3m21t4zh4UlLTohQ8dEDMiUs=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-648-REbD1aUbM5-qmCEfuS_q7w-1; Mon, 10 Jul 2023 05:07:19 -0400
X-MC-Unique: REbD1aUbM5-qmCEfuS_q7w-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.rdu2.redhat.com [10.11.54.5])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 52B39896671;
        Mon, 10 Jul 2023 09:07:19 +0000 (UTC)
Received: from greebo.redhat.com (unknown [10.39.193.57])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 81F4EF5CED;
        Mon, 10 Jul 2023 09:07:18 +0000 (UTC)
From:   alexl@redhat.com
To:     fstests@vger.kernel.org
Cc:     linux-unionfs@vger.kernel.org, amir73il@gmail.com, alexl@redhat.com
Subject: [PATCH v2 0/4] overlayfs: Test data-only upperdirs and fs-verity
Date:   Mon, 10 Jul 2023 11:07:09 +0200
Message-Id: <cover.1688979643.git.alexl@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.5
Precedence: bulk
List-ID: <linux-unionfs.vger.kernel.org>
X-Mailing-List: linux-unionfs@vger.kernel.org

From: Alexander Larsson <alexl@redhat.com>

This adds support for testing the new data-only upperdir feature which is
currently in master and will be in 6.5-rc1. It also adds tests for the
fs-verity validation feature which is queued in overlayfs-next for 6.6.

All new tests check for the required features before running, so
having it in early will be nice for testers of linux-next.

Changes since v1:
 * Consistently use $fstyp and $scratch_mnt in _require_scratch_verity
   (Pointed out by Eric Biggers)
 * Added Signed-off-by to patches from Amir

Alexander Larsson (1):
  overlay: Add test coverage for fs-verity support

Amir Goldstein (3):
  overlay: add helper for mounting rdonly overlay
  overlay/060: add test cases of follow to lowerdata
  overlay: Add test for follow of lowerdata in data-only layers

 common/overlay        |  35 ++++-
 common/verity         |  16 ++-
 tests/overlay/060     |  43 +++++-
 tests/overlay/060.out |  18 +++
 tests/overlay/079     | 325 +++++++++++++++++++++++++++++++++++++++++
 tests/overlay/079.out |  42 ++++++
 tests/overlay/080     | 326 ++++++++++++++++++++++++++++++++++++++++++
 tests/overlay/080.out |   7 +
 8 files changed, 800 insertions(+), 12 deletions(-)
 create mode 100755 tests/overlay/079
 create mode 100644 tests/overlay/079.out
 create mode 100755 tests/overlay/080
 create mode 100644 tests/overlay/080.out

-- 
2.40.1

