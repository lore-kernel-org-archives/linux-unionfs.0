Return-Path: <linux-unionfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 73997EB64DC
	for <linux-unionfs@archiver.kernel.org>; Thu,  6 Jul 2023 09:52:08 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232160AbjGFJwH (ORCPT
        <rfc822;linux-unionfs@archiver.kernel.org>);
        Thu, 6 Jul 2023 05:52:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48938 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229518AbjGFJwG (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Thu, 6 Jul 2023 05:52:06 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8B3BF1990
        for <linux-unionfs@vger.kernel.org>; Thu,  6 Jul 2023 02:51:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1688637079;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=lMaP9YAr9PiYqF//CZv5LxvRtkcDEaEjQmroPJR9T9o=;
        b=MIvjmQRaufNGMEkC3gwUK/vJmMqTRWpNtfaEOuk/JUzv8peC2UIQ3PR+T45w9eJ5mxdqq7
        PTK2CMEWNklLOvoIIydgPpR1YoACr0axYi1W9EAAXVBk1Qw8MyGJAf2igrSZve8UOxRDft
        uEAujVgURqiNS9CQDzk8vcijVpfG1qM=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-658-mYGhocKxPz2Li-wSzzuNwQ-1; Thu, 06 Jul 2023 05:51:16 -0400
X-MC-Unique: mYGhocKxPz2Li-wSzzuNwQ-1
Received: from smtp.corp.redhat.com (int-mx10.intmail.prod.int.rdu2.redhat.com [10.11.54.10])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 44C591039439;
        Thu,  6 Jul 2023 09:51:16 +0000 (UTC)
Received: from greebo.redhat.com (unknown [10.39.193.57])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 840D4492C13;
        Thu,  6 Jul 2023 09:51:15 +0000 (UTC)
From:   alexl@redhat.com
To:     fstests@vger.kernel.org
Cc:     linux-unionfs@vger.kernel.org, amir73il@gmail.com,
        Alexander Larsson <alexl@redhat.com>
Subject: [PATCH 0/4] overlayfs: Test data-only upperdirs and fs-verity
Date:   Thu,  6 Jul 2023 11:50:57 +0200
Message-Id: <cover.1688633251.git.alexl@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.10
Precedence: bulk
List-ID: <linux-unionfs.vger.kernel.org>
X-Mailing-List: linux-unionfs@vger.kernel.org

From: Alexander Larsson <alexl@redhat.com>

This adds support for testing the new data-only upperdir feature which is
currently in master and will be in 6.5-rc1. It also adds tests for the
fs-verity validation feature which is queued in overlayfs-next for 6.6.

All new tests check for the required features before running, so
having it in early will be nice for testers of linux-next.

Alexander Larsson (1):
  overlay: Add test coverage for fs-verity support

Amir Goldstein (3):
  overlay: add helper for mounting rdonly overlay
  overlay/060: add test cases of follow to lowerdata
  overlay: Add test for follow of lowerdata in data-only layers

 common/overlay        |  35 ++++-
 common/verity         |  10 +-
 tests/overlay/060     |  43 +++++-
 tests/overlay/060.out |  18 +++
 tests/overlay/079     | 325 +++++++++++++++++++++++++++++++++++++++++
 tests/overlay/079.out |  42 ++++++
 tests/overlay/080     | 327 ++++++++++++++++++++++++++++++++++++++++++
 tests/overlay/080.out |   7 +
 8 files changed, 798 insertions(+), 9 deletions(-)
 create mode 100755 tests/overlay/079
 create mode 100644 tests/overlay/079.out
 create mode 100755 tests/overlay/080
 create mode 100644 tests/overlay/080.out

-- 
2.40.1

