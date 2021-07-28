Return-Path: <linux-unionfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.6 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B61CFC4338F
	for <linux-unionfs@archiver.kernel.org>; Wed, 28 Jul 2021 14:32:33 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 9396860F5E
	for <linux-unionfs@archiver.kernel.org>; Wed, 28 Jul 2021 14:32:33 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235345AbhG1Ocd (ORCPT
        <rfc822;linux-unionfs@archiver.kernel.org>);
        Wed, 28 Jul 2021 10:32:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39750 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235464AbhG1Ocd (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Wed, 28 Jul 2021 10:32:33 -0400
Received: from mail-vs1-xe36.google.com (mail-vs1-xe36.google.com [IPv6:2607:f8b0:4864:20::e36])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F0206C061765
        for <linux-unionfs@vger.kernel.org>; Wed, 28 Jul 2021 07:32:31 -0700 (PDT)
Received: by mail-vs1-xe36.google.com with SMTP id j19so1573646vso.0
        for <linux-unionfs@vger.kernel.org>; Wed, 28 Jul 2021 07:32:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=szeredi.hu; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=EJo0PHoVbiVKIGpz4WbEXWXkHC4bfOhyP6K61KoB2LM=;
        b=S395aemGWoIdwNFYBBqyRA8mmCGQwttnLueWYxgibXsl/9W9ctYNpsyNsdJ7suhCFl
         iH9a/7h92eGx82xC6tg4Zs2lOEIeZg85gZbNLH47hCl1haxCJBTa2gL3dD8ezJOaoPpD
         CCY+Bl6InYozLIUDPOSDUU/WkLEF6OyWS4WCo=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=EJo0PHoVbiVKIGpz4WbEXWXkHC4bfOhyP6K61KoB2LM=;
        b=FgLyzEqBIx8g35qhm8U7xl6UZm1y3hPR4RB/ZhR1V0TzM518L2uE63yunVw/yv0lBF
         lOc/QjpJiuDl31gmrReGT1ZzkGQTMUTU4TVZIeKZ3N2uH4RM3bXGGt1CRsSfQf/qwY4g
         Qtv+9lnP2DEs2aZdLzhza3HNG7nkcqmj+YQvrUWuvLC43213jSKJ69O1V1216qZNrc1K
         WhnQf6S+2YhbVx/8/xWLOh2BzUbQyzVnRgjMAKytJkle5yjHnAMLy12zk0QQBYGY2BvF
         YQmW7/oJN9aRX+EP8yh2rYjBDwFyCwrYdRZ2RIIV7LB3hsDVDfQcu7MXl+pbhaoaU5nj
         3T+Q==
X-Gm-Message-State: AOAM533HOnj+gGdkytvHkw090P/14Of56OfMdG+E8fsYD1SN9ap7NDfw
        ZH/SskhBLWAEW7HXAeAGWIafjG8d+3QuuskuF2Tv9A==
X-Google-Smtp-Source: ABdhPJykaCzneBxaJdJtv56s3tLVJvYpO/nycTzEPfmIqI1jhBvMvWYg6rp0W6fqxmetTLMPXxBObPZmifwXmXznxhM=
X-Received: by 2002:a05:6102:2ca:: with SMTP id h10mr22658074vsh.7.1627482751123;
 Wed, 28 Jul 2021 07:32:31 -0700 (PDT)
MIME-Version: 1.0
References: <00000000000052a12105c82facde@google.com>
In-Reply-To: <00000000000052a12105c82facde@google.com>
From:   Miklos Szeredi <miklos@szeredi.hu>
Date:   Wed, 28 Jul 2021 16:32:20 +0200
Message-ID: <CAJfpeguXWAJRyRn=8tLRq41kqjuSnX9VNqNT_V2+jhuttC0nEw@mail.gmail.com>
Subject: Re: [syzbot] possible deadlock in iter_file_splice_write (2)
To:     syzbot <syzbot+4bdbcaa79e8ee36fe6af@syzkaller.appspotmail.com>
Cc:     linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        overlayfs <linux-unionfs@vger.kernel.org>,
        Miklos Szeredi <mszeredi@redhat.com>,
        syzkaller-bugs <syzkaller-bugs@googlegroups.com>,
        Al Viro <viro@zeniv.linux.org.uk>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-unionfs.vger.kernel.org>
X-Mailing-List: linux-unionfs@vger.kernel.org

#syz test: git://git.kernel.org/pub/scm/linux/kernel/git/mszeredi/vfs.git
overlayfs-next
