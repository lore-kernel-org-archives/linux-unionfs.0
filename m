Return-Path: <linux-unionfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.3 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 388C2C433E0
	for <linux-unionfs@archiver.kernel.org>; Mon, 25 Jan 2021 19:52:18 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id E2133206D4
	for <linux-unionfs@archiver.kernel.org>; Mon, 25 Jan 2021 19:52:17 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732061AbhAYTvs (ORCPT
        <rfc822;linux-unionfs@archiver.kernel.org>);
        Mon, 25 Jan 2021 14:51:48 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58536 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1732086AbhAYTva (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Mon, 25 Jan 2021 14:51:30 -0500
Received: from mail-io1-xd35.google.com (mail-io1-xd35.google.com [IPv6:2607:f8b0:4864:20::d35])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 65220C061A2B
        for <linux-unionfs@vger.kernel.org>; Mon, 25 Jan 2021 11:48:52 -0800 (PST)
Received: by mail-io1-xd35.google.com with SMTP id d81so29027489iof.3
        for <linux-unionfs@vger.kernel.org>; Mon, 25 Jan 2021 11:48:52 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=sargun.me; s=google;
        h=date:from:to:subject:message-id:mime-version:content-disposition
         :user-agent;
        bh=spkl/nvHwLso9Cb6+tWylM633bnTklfo+FMF0NywHm8=;
        b=kflzkRrme+5sRUC8nrTZQLwhkOTWqW1iWK/SUb4Ztd8Pq1wbotJhqNZgRZHVmgPRhu
         kW8f12YwCcSlkl6/HMlj3KgP1mxz5YMAOHFflhvYh0RvBSebADTUVXAFJy8Pg895SMEP
         ZCVsHEpNwf/ApOaX/mh0DmMtHtAiUdVlH5Tns=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:subject:message-id:mime-version
         :content-disposition:user-agent;
        bh=spkl/nvHwLso9Cb6+tWylM633bnTklfo+FMF0NywHm8=;
        b=KPaRS0ToHbfWUE2Bu6yC4DYBc7g95gC4BJelvCGBVS+C5NuW0i3CwD4UjqBRpue4/E
         0VxPKLJjCs9VzYt9qwpiVNI7XXj/H8o7vbTDrslFJXjrqGRlZWH1fSg73me7qqx+LQUw
         WvDutvIii2WbCr6Hzg+iCUAif4ubegYkvwMbwCaHQT+FgJRQo3ExNORlGVE7UZTaFSzV
         iIdexoldkJi6tJFN13LvzCS2DrxdkTe8L5fe8gfBZgJ/gXLplfhoYkKY+Y8oDcBEhlp5
         vpPkh9tUSXndN0gZUkuZcu9UORyqAzSYDj/cd+vGwAg8cF11HguiPfHhMovWjNC9DqeN
         9Jgw==
X-Gm-Message-State: AOAM532kvRpQCqEHwuGllKzW5Cx8J35GYEQv24KCQVvphzibKqlL8PC1
        NjvO7DdLgpebtd+uxT69L5pYzSC1qQamlQ==
X-Google-Smtp-Source: ABdhPJwHRfmNAlEpdof5dgfmfWKYFZK2GT/P4guiHzNcknAJx1Y8zoO8nOQ1TN/it8pbLnvZirM4xw==
X-Received: by 2002:a6b:2d4:: with SMTP id 203mr1691382ioc.0.1611604131372;
        Mon, 25 Jan 2021 11:48:51 -0800 (PST)
Received: from ircssh-2.c.rugged-nimbus-611.internal (80.60.198.104.bc.googleusercontent.com. [104.198.60.80])
        by smtp.gmail.com with ESMTPSA id q5sm11125232ioi.43.2021.01.25.11.48.50
        for <linux-unionfs@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-ECDSA-CHACHA20-POLY1305 bits=256/256);
        Mon, 25 Jan 2021 11:48:50 -0800 (PST)
Date:   Mon, 25 Jan 2021 19:48:49 +0000
From:   Sargun Dhillon <sargun@sargun.me>
To:     linux-unionfs@vger.kernel.org
Subject: Lazy Loading Layers (Userfaultfd for filesystems?)
Message-ID: <20210125194848.GA12389@ircssh-2.c.rugged-nimbus-611.internal>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.9.4 (2018-02-28)
Precedence: bulk
List-ID: <linux-unionfs.vger.kernel.org>
X-Mailing-List: linux-unionfs@vger.kernel.org

One of the projects I'm playing with for containers is lazy-loading of layers. 
We've found that less than 10% of the files on a layer actually get used, which 
is an unfortunate waste. It also means in some cases downloading ~100s of MB, or 
~1s of GB of files before starting a container workload. This is unfortunate.

It would be nice if there was a way to start a container workload, and have
it so that if it tries to access and unpopulated (not yet downloaded) part
of the filesystem block while trying to be accessed. This is trivial to do
if the "lowest" layer is FUSE, where one can just stall in userspace on
loads. Unfortunately, AFAIK, there's not a good way to swap out the FUSE
filesystem with the "real" filesystem once it's done fully populating,
and you have to pay for the full FUSE cost on each read / write.

I've tossed around:
1. Mutable lowerdirs and having something like this:

layer0 --> Writeable space
layer1 --> Real XFS filesystem
layer2 --> FUSE FS

and if there is a "miss" on layer 1, it will then look it up on
layer 2 while layer 1 is being populated. Then the FUSE FS can block.
This is neat, but it requires the FUSE FS to always be up, and incurs
a userspace bounce on every miss.

It also means things like metadata only copies don't work.

Does anyone have a suggestion of a mechanism to handle this? I've looked into 
swapping out layers on the fly, and what it would take to add a mechanism like 
userfaultfd to overlayfs, but I was wondering if anything like this was already 
built, or if someone has thought it through more than me.

