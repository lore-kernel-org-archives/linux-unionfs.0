Return-Path: <linux-unionfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.6 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0D83BC4338F
	for <linux-unionfs@archiver.kernel.org>; Tue, 10 Aug 2021 15:04:12 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id E34CA60F38
	for <linux-unionfs@archiver.kernel.org>; Tue, 10 Aug 2021 15:04:11 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242562AbhHJPEc (ORCPT
        <rfc822;linux-unionfs@archiver.kernel.org>);
        Tue, 10 Aug 2021 11:04:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44232 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242557AbhHJPEb (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Tue, 10 Aug 2021 11:04:31 -0400
Received: from mail-ej1-x62c.google.com (mail-ej1-x62c.google.com [IPv6:2a00:1450:4864:20::62c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 89B4EC0613C1
        for <linux-unionfs@vger.kernel.org>; Tue, 10 Aug 2021 08:04:08 -0700 (PDT)
Received: by mail-ej1-x62c.google.com with SMTP id d11so11642708eja.8
        for <linux-unionfs@vger.kernel.org>; Tue, 10 Aug 2021 08:04:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=szeredi.hu; s=google;
        h=date:from:to:cc:subject:message-id:mime-version:content-disposition;
        bh=0kGkCVXi9LMetkI7vjpLy4IPYSR246cc36MeCJtVGWY=;
        b=Vg3szelyZHeSc/dqdJwfjdyaNeVjX91LJTqrkmxo+eXKbQy5/j20lTRJpUcGxCvdtD
         jDOjwa3ZvEhSpKq9bVkeUwKlPtBxTcuLzIajGDGO3UXcNnY09bajB/YMlav5D/eRMa3N
         jPBiJhm/g9mnPytSQD2TI00r1An39xj/YQIJk=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:mime-version
         :content-disposition;
        bh=0kGkCVXi9LMetkI7vjpLy4IPYSR246cc36MeCJtVGWY=;
        b=oE9VxGicl31A1DUoAgxxY++uUJWtzCxFAogM0tYSfbJFNuiGuCqze7xVbuOgPjY+MS
         1PZ+yaaBj42U6V7UGbt9L6uyIaGUrz5iW4PheuWCuHDQNXJrmcuyWTdLMfAD0a3Izh6L
         0d08wtDeUbdUP4sTbt7R1z8ulypEPbqF7olJaF4j/k97/o0eSJN60CmbINamdRi/aHxR
         PKXCIj9fyeXjqhs4gRqKWS0hxbO/xMfRpKa1xeeyyLa8urSNpe7QFWQoFJQtdH/whq3T
         TFgcQh73iIXbwPnEycbRuXDEAdO/E8daAA105T2JJiIIyJnDVfRx4VjUvHzZPmGtDTr6
         +MSQ==
X-Gm-Message-State: AOAM533M2E5e7wRwI+Z3vce/L+B65QooBqCj+Vo0dIBZkjVJK7hWwZB3
        a0JZCzdIjf57nbYqtCmFTXI6AA==
X-Google-Smtp-Source: ABdhPJxnq5BxlTa14rXURztYnwXAxPN8xl+/yaEV1Jt6ftczGTmT9LR5FamQjUkA/MlE9sSBl2vqDA==
X-Received: by 2002:a17:906:9c84:: with SMTP id fj4mr27408543ejc.264.1628607847156;
        Tue, 10 Aug 2021 08:04:07 -0700 (PDT)
Received: from miu.piliscsaba.redhat.com (catv-86-101-169-16.catv.broadband.hu. [86.101.169.16])
        by smtp.gmail.com with ESMTPSA id c16sm2536466ejm.125.2021.08.10.08.04.05
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 10 Aug 2021 08:04:06 -0700 (PDT)
Date:   Tue, 10 Aug 2021 17:04:03 +0200
From:   Miklos Szeredi <miklos@szeredi.hu>
To:     Linus Torvalds <torvalds@linux-foundation.org>
Cc:     linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        linux-unionfs@vger.kernel.org
Subject: [GIT PULL v2] overlayfs fixes for 5.14-rc6
Message-ID: <YRKVYyeAUqJSJ5rk@miu.piliscsaba.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Precedence: bulk
List-ID: <linux-unionfs.vger.kernel.org>
X-Mailing-List: linux-unionfs@vger.kernel.org

Hi Linus,

Please pull from:

  git://git.kernel.org/pub/scm/linux/kernel/git/mszeredi/vfs.git tags/ovl-fixes-5.14-rc6-v2

Fix several bugs in overlayfs.

Fixes have been in linux-next for a fair amount of time, the recent commit
timestamps are due to moving these fixes to the front of the patch queue.

v2: drop mmap denywrite fix.

Thanks,
Miklos

---
Amir Goldstein (1):
      ovl: skip stale entries in merge dir cache iteration

Miklos Szeredi (3):
      ovl: fix deadlock in splice write
      ovl: fix uninitialized pointer read in ovl_lookup_real_one()
      ovl: prevent private clone if bind mount is not allowed

---
 fs/namespace.c         | 42 ++++++++++++++++++++++++++++--------------
 fs/overlayfs/export.c  |  2 +-
 fs/overlayfs/file.c    | 47 ++++++++++++++++++++++++++++++++++++++++++++++-
 fs/overlayfs/readdir.c |  5 +++++
 4 files changed, 80 insertions(+), 16 deletions(-)
