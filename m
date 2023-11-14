Return-Path: <linux-unionfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 08FD9C4332F
	for <linux-unionfs@archiver.kernel.org>; Tue, 14 Nov 2023 07:23:50 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231161AbjKNHXv (ORCPT
        <rfc822;linux-unionfs@archiver.kernel.org>);
        Tue, 14 Nov 2023 02:23:51 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36608 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229580AbjKNHXu (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Tue, 14 Nov 2023 02:23:50 -0500
Received: from mail-lf1-x12d.google.com (mail-lf1-x12d.google.com [IPv6:2a00:1450:4864:20::12d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DF379198
        for <linux-unionfs@vger.kernel.org>; Mon, 13 Nov 2023 23:23:46 -0800 (PST)
Received: by mail-lf1-x12d.google.com with SMTP id 2adb3069b0e04-507adc3381cso7062314e87.3
        for <linux-unionfs@vger.kernel.org>; Mon, 13 Nov 2023 23:23:46 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1699946625; x=1700551425; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=QxrHlSoCBMMFv7ivAvbBTxcLyyYe8Wyhi8kqX73X/l0=;
        b=aH6WfnVn8UJZkQSYRJTU81EtNdcepemtvJwT1G4lPDsP64bGJQGyCJ5YP22dq3y8zk
         BRKltT4bILhc++Ij3O/BEZgSaQtFlmiepP8WRWOvUKBSVg+68eknV8rfZqHMLu6heIED
         H+d/vh+2blwKN7Rm2wxQN3/0LioxAPOwvPDfHXDhDpYZDkWYLOpBSHONyfsiZsyrNK1P
         uvbF71kMsXUKSWDd1mbiaonnwtJQpda3wnxuop0PZZDOcJmEmIHYvcLajMPHjrW8IvGM
         pFOd3Poes8STvuheGAxNPfIu5E14c1amrxOxmFwxcF7pUPE6zcfO2bmaCysz/DOFC8PH
         ufLw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1699946625; x=1700551425;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=QxrHlSoCBMMFv7ivAvbBTxcLyyYe8Wyhi8kqX73X/l0=;
        b=sRYtazPPGt21ntquRVKMnmRk8x34zGtYMEh5a3io7pftLn1LvkKET9jAcZ/9PQ5ta7
         hLQQj0DFiSFLRvA3b7TBni3Z8/hCDfrjbS8yT9h7oeBB2fxZ4wlmUBqhpk+n9TxhXNBF
         tzVfEwr2WJ/fyZ2lqsfD6UkPrH7Zh6+nPX0kMgoXPE7V+g3VrotyO2xVJqmhKujoFbwY
         Tjg7g9CwooJtGT3nW4B+DgfWKOZHdQPxDEwwRTx9MIIN5Dbb4S+reNQdbSDukzpb7Wck
         oj+fda3PM0/2voK8v3qUQcTYbngiCfIwleCVJtfM0b21h3mJcjdMqwDbjnGg8RkahqaQ
         BCaw==
X-Gm-Message-State: AOJu0Yx7neoRZ3BwOa7jWlBKj/Bh65EpdsFOYb1/aXehgpIBhJsopb0/
        dAI3zpmETBheXMo0A+Rk7Bl6bdpGRUM=
X-Google-Smtp-Source: AGHT+IHrcS5uug2e5MWimHP/ThzHzOnrjskCSltfm4uRTqTLPkXGm2+SEzN/4ktWLhvH9sTZ0nnOhA==
X-Received: by 2002:ac2:4d90:0:b0:509:4ab2:3635 with SMTP id g16-20020ac24d90000000b005094ab23635mr5361520lfe.59.1699946625007;
        Mon, 13 Nov 2023 23:23:45 -0800 (PST)
Received: from amir-ThinkPad-T480.lan ([5.29.249.86])
        by smtp.gmail.com with ESMTPSA id g9-20020adff409000000b0032f7d7ec4adsm6865681wro.92.2023.11.13.23.23.43
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 13 Nov 2023 23:23:44 -0800 (PST)
From:   Amir Goldstein <amir73il@gmail.com>
To:     Petr Vorel <pvorel@suse.cz>
Cc:     Cyril Hrubis <chrubis@suse.cz>, Jan Kara <jack@suse.cz>,
        Miklos Szeredi <miklos@szeredi.hu>,
        linux-unionfs@vger.kernel.org, ltp@lists.linux.it
Subject: [PATCH 0/2] fanotify LTP tests for v6.6
Date:   Tue, 14 Nov 2023 09:23:36 +0200
Message-Id: <20231114072338.1669277-1-amir73il@gmail.com>
X-Mailer: git-send-email 2.34.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-unionfs.vger.kernel.org>
X-Mailing-List: linux-unionfs@vger.kernel.org

Hi Petr,

For v6.5, we added a new test variant to fanotify13, to test fanotify
watching upper fs path while making changes to overlayfs.

To increase test coverage, adding another test variant for watching
lower fs path instad of upper fs path, which also runs on v6.5.

Adding two new test variants for watching overlayfs paths.
The new variants only run on v6.6 where overlayfs gained support for
being watched by fanotify.

Thanks,
Amir.

Amir Goldstein (2):
  fanotify13: Test overlayfs while watching lower fs
  fanotify13: Test watching overlayfs with FAN_REPORT_FID

 testcases/kernel/syscalls/fanotify/fanotify.h | 28 ++++++++---
 .../kernel/syscalls/fanotify/fanotify13.c     | 50 ++++++++++++++-----
 2 files changed, 59 insertions(+), 19 deletions(-)

-- 
2.34.1

