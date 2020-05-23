Return-Path: <SRS0=PFgV=7F=vger.kernel.org=linux-unionfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.4 required=3.0 tests=FROM_LOCAL_HEX,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=unavailable autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 79E69C433E0
	for <linux-unionfs@archiver.kernel.org>; Sat, 23 May 2020 11:33:14 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 5CE6320757
	for <linux-unionfs@archiver.kernel.org>; Sat, 23 May 2020 11:33:14 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387729AbgEWLdH (ORCPT
        <rfc822;linux-unionfs@archiver.kernel.org>);
        Sat, 23 May 2020 07:33:07 -0400
Received: from mail-il1-f197.google.com ([209.85.166.197]:43269 "EHLO
        mail-il1-f197.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2387802AbgEWLdG (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Sat, 23 May 2020 07:33:06 -0400
Received: by mail-il1-f197.google.com with SMTP id v14so10977602ilm.10
        for <linux-unionfs@vger.kernel.org>; Sat, 23 May 2020 04:33:05 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:date:in-reply-to:message-id:subject
         :from:to;
        bh=dZyZqTwiP+xrs8PlvPwtIHnm6mFf5YN6wYhwO+sWOlc=;
        b=doXHEon2bQFwoyVmXasRtw8DbYGPhVtOREKe4sBu+NTv06ubF9NBoPmiuENaLq5VOT
         j3TbTcY2IKvc69Qjwy2VWIYnBXzN4HUaJXYTMAXs9skCwZ7YfN8/Nk4HQQnha6r21GGc
         Kg4M2PCqQvvOBh0rqan65Id7OnXvlfhFcd4wYAZ+yAYRqI+V59mmFC4jtT/ETBkoqPF2
         E3RxQbd2c9zJ+Q4B87WCanuKN2g0dIfAvjDXdWAE0UV2rOY+GM82VPa5V82hQ35xeQXh
         18Csk7n8qlAox/t65H+EEa8qPFj43R141b7+ikLJ/ldhwnjKisHO8KeQucCR4ER+kXgY
         pFVA==
X-Gm-Message-State: AOAM531+iXZ9AK4snh7JdwM5PaHMIYkK2R+TasthEArSPFA27T78MH3E
        ggucJ1wzKxqAAEL0BhNo5dsbB7ck+EFrcqcTH+ZUm4KUf6MT
X-Google-Smtp-Source: ABdhPJwfvsc/Vx5jBxjkvQ8bakqR5UQhv+TwIJyfPj49usVz9ZgCxOwmgKW5G8qRIuo1D8KEOKLd5Fp/aQNB00af2lM5ssRrsDM4
MIME-Version: 1.0
X-Received: by 2002:a05:6638:1104:: with SMTP id n4mr11987894jal.91.1590233584794;
 Sat, 23 May 2020 04:33:04 -0700 (PDT)
Date:   Sat, 23 May 2020 04:33:04 -0700
In-Reply-To: <CAOQ4uxh2+fhAdpyu4JB93MGB9wV0ztExc6cWBZnhfLmozk8Fag@mail.gmail.com>
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <000000000000ee810805a64f1b6f@google.com>
Subject: Re: KASAN: slab-out-of-bounds Read in ovl_check_fb_len
From:   syzbot <syzbot+61958888b1c60361a791@syzkaller.appspotmail.com>
To:     amir73il@gmail.com, dan.carpenter@oracle.com,
        linux-kernel@vger.kernel.org, linux-unionfs@vger.kernel.org,
        miklos@szeredi.hu, mszeredi@redhat.com,
        syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"
Sender: linux-unionfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-unionfs.vger.kernel.org>
X-Mailing-List: linux-unionfs@vger.kernel.org

Hello,

syzbot has tested the proposed patch and the reproducer did not trigger crash:

Reported-and-tested-by: syzbot+61958888b1c60361a791@syzkaller.appspotmail.com

Tested on:

commit:         30981015 ovl: fix out of bounds access warning in ovl_chec..
git tree:       https://github.com/amir73il/linux.git ovl-fixes
kernel config:  https://syzkaller.appspot.com/x/.config?x=b3368ce0cc5f5ace
dashboard link: https://syzkaller.appspot.com/bug?extid=61958888b1c60361a791
compiler:       gcc (GCC) 9.0.0 20181231 (experimental)

Note: testing is done by a robot and is best-effort only.
