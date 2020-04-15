Return-Path: <SRS0=gqkc=57=vger.kernel.org=linux-unionfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.6 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1E2C4C2BB55
	for <linux-unionfs@archiver.kernel.org>; Wed, 15 Apr 2020 12:03:59 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id F03A620575
	for <linux-unionfs@archiver.kernel.org>; Wed, 15 Apr 2020 12:03:58 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="fbVLwExN"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S368270AbgDOMDt (ORCPT
        <rfc822;linux-unionfs@archiver.kernel.org>);
        Wed, 15 Apr 2020 08:03:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44058 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S368163AbgDOMBo (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Wed, 15 Apr 2020 08:01:44 -0400
Received: from mail-wr1-x444.google.com (mail-wr1-x444.google.com [IPv6:2a00:1450:4864:20::444])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CB10AC061A0C
        for <linux-unionfs@vger.kernel.org>; Wed, 15 Apr 2020 05:01:41 -0700 (PDT)
Received: by mail-wr1-x444.google.com with SMTP id h26so7384314wrb.7
        for <linux-unionfs@vger.kernel.org>; Wed, 15 Apr 2020 05:01:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=aFCr6bBy3R3TEO37u2HkvHSEa2pPKYgA93DL9q5KAlo=;
        b=fbVLwExNShZ+WgJdDksycstRDhT0igNYc5jYS62uKV3pYMw4eQQJFrbzjbEOcE/brq
         H3oCcAiYtjTcjuvZkUCg3e91mUJ0kPTPldxbcmjxlp+Bq60H1h3SX2C6j52e5Gzy04JR
         uGx7IGFKIj7xo84ZfwCA2cgJ3hZqHJdyGaFN1LVGKUns8hA+/zR8honMLEybXPAlzljt
         GuZ8HL7DDRMTbope8+5LXu35z4d8XLpSh9AhXuYbIc4GGqQE44tigqchSBYKVz8mJYDZ
         1PO/KEVGJEhMsIhqGArivvsRsLyDqjLOo7O4zfiooXk2tWAViifyknKHm/XLaUbAaIJ6
         0UNw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=aFCr6bBy3R3TEO37u2HkvHSEa2pPKYgA93DL9q5KAlo=;
        b=Bl+P/c09tYuxk1cH8WCGQzCIdudDIXKggCB9GL2heEP4itD7I4qXJWHm1dRb6GlZ6Q
         xVh3ks/GNwDyPqR+zRNj73eb2PWx0mosuQ2GkbOWeMG+SKzMcfgnZ5wQ2rQ9LWg/T1dh
         DoC0ISZ0kFnas8YGomxKPvAGX0ceToklvis0B2hJZSoh0vj1IkT9Fqpjynzl2ZZzrnAY
         ITENvFUR0Ql8DVKMcpmEjLbzP7znw0v9ZN4tYyWIC6h0BeOEEnkPUHmQAC3b7orSb1oB
         kLKdga8uJK4l9v/ewamOP0qy7aXmfT/vVKDxXtUdWtYgArGZ4ilJdLSluf1jtd46hOCR
         KlRA==
X-Gm-Message-State: AGi0PuafhAUtqlfn2dhn5XXskc8hZjxHBUG8UCM6F/+iH/2BqtT7UnBl
        zX42TcU9LC5mmYd2LlQu8Cs=
X-Google-Smtp-Source: APiQypIcUwUXD9bVzzc7PyFU6a17soSp7/p0ZNmgtodjdrNNqjYwoYVl1KEm7Lv02/mN2ZxSolSvPA==
X-Received: by 2002:adf:dfcd:: with SMTP id q13mr6783285wrn.423.1586952100370;
        Wed, 15 Apr 2020 05:01:40 -0700 (PDT)
Received: from localhost.localdomain ([141.226.12.123])
        by smtp.gmail.com with ESMTPSA id h137sm17578238wme.0.2020.04.15.05.01.38
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 15 Apr 2020 05:01:39 -0700 (PDT)
From:   Amir Goldstein <amir73il@gmail.com>
To:     Vivek Goyal <vgoyal@redhat.com>
Cc:     Giuseppe Scrivano <gscrivan@redhat.com>,
        Miklos Szeredi <miklos@szeredi.hu>,
        linux-unionfs@vger.kernel.org
Subject: [PATCH 0/2] Prepare for running unionmount testssuite from
Date:   Wed, 15 Apr 2020 15:01:32 +0300
Message-Id: <20200415120134.28154-1-amir73il@gmail.com>
X-Mailer: git-send-email 2.17.1
Sender: linux-unionfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-unionfs.vger.kernel.org>
X-Mailing-List: linux-unionfs@vger.kernel.org

Vivek,

You mentioned the need to run unionmount tests on custom layers
(virtiofs in your case) and I provided you the /etc/fstab solution,
which you said works for you.

I now added a new way to run unionmount tests on custom layers,
which I am going to use for xfstests integration [1].

I'd be interested to know if this method serves your use case as well.

Note that I overloaded the meaning of configuring base/lower/upper path:
  1. Use path different than the default
  2. Do not mount tmpfs nor unmount this path

I realize that it might have been better to split the two meanings into
different config options.  However, I am not fond of maintaining config
permutations that nobody is using.  So unless a user comes forward with
a use case, that's the way I intend to leave it.

Would love to get comments from anyone else of course.

Would love to get testing feedback from people that use the --fuse option,
because I am not testing it regularly.

Thanks,
Amir.

[1] https://github.com/amir73il/xfstests/commits/unionmount

Amir Goldstein (2):
  Stop using bind mounts for --samefs
  Configure custom layers via environment variables

 README           | 11 +++++++
 mount_union.py   |  8 ++---
 run              |  3 +-
 set_up.py        | 84 +++++++++++++++++++++++++++---------------------
 settings.py      | 61 +++++++++++++++++++++++++----------
 unmount_union.py | 19 ++++++-----
 6 files changed, 117 insertions(+), 69 deletions(-)

-- 
2.17.1

