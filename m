Return-Path: <linux-unionfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-18.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2A17FC64E90
	for <linux-unionfs@archiver.kernel.org>; Fri, 27 Nov 2020 09:21:17 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id C2AFE206D9
	for <linux-unionfs@archiver.kernel.org>; Fri, 27 Nov 2020 09:21:16 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=sargun.me header.i=@sargun.me header.b="XCbkKPcW"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728063AbgK0JVM (ORCPT
        <rfc822;linux-unionfs@archiver.kernel.org>);
        Fri, 27 Nov 2020 04:21:12 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42046 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726014AbgK0JVM (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Fri, 27 Nov 2020 04:21:12 -0500
Received: from mail-pg1-x541.google.com (mail-pg1-x541.google.com [IPv6:2607:f8b0:4864:20::541])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B743DC0613D1
        for <linux-unionfs@vger.kernel.org>; Fri, 27 Nov 2020 01:21:10 -0800 (PST)
Received: by mail-pg1-x541.google.com with SMTP id w4so3855133pgg.13
        for <linux-unionfs@vger.kernel.org>; Fri, 27 Nov 2020 01:21:10 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=sargun.me; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=N3znUkPKtqbryPODPnE7qItfA1c9fsYLlSw8ARlE2iU=;
        b=XCbkKPcW90nk8ZdKWXtOH5i9ZE+g53qlXZ8cLPT4L1dCcgEvMy8gG5O6KOjkCiRTS6
         T1sT0tOswqbzJT3gDHM0Pr4X0oa1KJkNX6xjd2KuxpINgXtXWLgF9ffxKbDKP1rjpMFz
         nxxOy0yG5pnW+FbC2hlo0yE1i2S7eA9V7xfbA=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=N3znUkPKtqbryPODPnE7qItfA1c9fsYLlSw8ARlE2iU=;
        b=sHf0mpeA7/gzAFnVdil7mD4IirJ+fDBG78b8BXsAwiCEGmHmeFmFWYZS8v7/TEoxQN
         Ckh2/euyrQIRA0Pb8YWfljFmUURQqiflxJXm0CsgJuqTgueviSRLDfkQqOpmW/D3a8f2
         +xuNCtR75d521HenD+GwEBN6C1JJLVUhbALFnS38kSlKz/F9/8eweWC9rGuWjdw37PC5
         8LXwL/SBQcTLlW8vne27VL67y4NLVNjbM7titxFHOYq/xc7dDpf9Rx0a9d4PIQRDv5/1
         MO7oESU2F5YEZdFmcI9qQ6qqP4yBcGr20qDWNBzSb+vjumDbtv9oFUDrK4kcYvgef6Xk
         nQ+A==
X-Gm-Message-State: AOAM530eyATABOiXEKZNDEGBomOFk27hmxaOo8wkGvdNZ/ciGMS6qlum
        xT+21MnOfpEv2o0/pUsQ+R8Y77CrlDYrgQ==
X-Google-Smtp-Source: ABdhPJy+Nm0BqxYRvhxozEhyB0RB1iAA9/rcKtYRc0oHpzl11BL3ij3EUW9jZDE3KklG4mSjjnCSJA==
X-Received: by 2002:a17:90a:2a83:: with SMTP id j3mr9035135pjd.84.1606468869856;
        Fri, 27 Nov 2020 01:21:09 -0800 (PST)
Received: from ubuntu.netflix.com (203.20.25.136.in-addr.arpa. [136.25.20.203])
        by smtp.gmail.com with ESMTPSA id t9sm9938944pjq.46.2020.11.27.01.21.08
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 27 Nov 2020 01:21:09 -0800 (PST)
From:   Sargun Dhillon <sargun@sargun.me>
To:     linux-unionfs@vger.kernel.org, miklos@szeredi.hu,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        Amir Goldstein <amir73il@gmail.com>
Cc:     Sargun Dhillon <sargun@sargun.me>,
        Giuseppe Scrivano <gscrivan@redhat.com>,
        Vivek Goyal <vgoyal@redhat.com>,
        Daniel J Walsh <dwalsh@redhat.com>,
        linux-fsdevel@vger.kernel.org, David Howells <dhowells@redhat.com>
Subject: [PATCH v2 2/4] overlay: Document current outstanding shortcoming of volatile
Date:   Fri, 27 Nov 2020 01:20:56 -0800
Message-Id: <20201127092058.15117-3-sargun@sargun.me>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20201127092058.15117-1-sargun@sargun.me>
References: <20201127092058.15117-1-sargun@sargun.me>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-unionfs.vger.kernel.org>
X-Mailing-List: linux-unionfs@vger.kernel.org

This documents behaviour that was discussed in a thread about the volatile
feature. Specifically, how failures can go hidden from asynchronous writes
(such as from mmap, or writes that are not immediately flushed to the
filesystem). Although we pass through calls like msync, fallocate, and
write, and will still return errors on those, it doesn't guarantee all
kinds of errors will happen at those times, and thus may hide errors.

In the future, we can add error checking to all interactions with the
upperdir, and pass through errseq_t from the upperdir on mappings,
and other interactions with the filesystem[1].

[1]: https://lore.kernel.org/linux-unionfs/20201116045758.21774-1-sargun@sargun.me/T/#m7d501f375e031056efad626e471a1392dd3aad33

Signed-off-by: Sargun Dhillon <sargun@sargun.me>
Cc: linux-fsdevel@vger.kernel.org
Cc: linux-unionfs@vger.kernel.org
Cc: Miklos Szeredi <miklos@szeredi.hu>
Cc: Amir Goldstein <amir73il@gmail.com>
Cc: Vivek Goyal <vgoyal@redhat.com>
---
 Documentation/filesystems/overlayfs.rst | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/Documentation/filesystems/overlayfs.rst b/Documentation/filesystems/overlayfs.rst
index 580ab9a0fe31..c6e30c1bc2f2 100644
--- a/Documentation/filesystems/overlayfs.rst
+++ b/Documentation/filesystems/overlayfs.rst
@@ -570,7 +570,11 @@ Volatile mount
 This is enabled with the "volatile" mount option.  Volatile mounts are not
 guaranteed to survive a crash.  It is strongly recommended that volatile
 mounts are only used if data written to the overlay can be recreated
-without significant effort.
+without significant effort.  In addition to this, the sync family of syscalls
+are not sufficient to determine whether a write failed as sync calls are
+omitted.  For this reason, it is important that the filesystem used by the
+upperdir handles failure in a fashion that's suitable for the user.  For
+example, upon detecting a fault, ext4 can be configured to panic.
 
 The advantage of mounting with the "volatile" option is that all forms of
 sync calls to the upper filesystem are omitted.
-- 
2.25.1

