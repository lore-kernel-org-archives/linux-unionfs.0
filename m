Return-Path: <linux-unionfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.7 required=3.0 tests=BAYES_00,FROM_LOCAL_HEX,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B889CC433EF
	for <linux-unionfs@archiver.kernel.org>; Wed,  8 Sep 2021 08:26:14 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 9AAEB61139
	for <linux-unionfs@archiver.kernel.org>; Wed,  8 Sep 2021 08:26:14 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349634AbhIHI1U (ORCPT
        <rfc822;linux-unionfs@archiver.kernel.org>);
        Wed, 8 Sep 2021 04:27:20 -0400
Received: from mail-il1-f198.google.com ([209.85.166.198]:42606 "EHLO
        mail-il1-f198.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1349357AbhIHI1T (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Wed, 8 Sep 2021 04:27:19 -0400
Received: by mail-il1-f198.google.com with SMTP id p10-20020a92d28a000000b0022b5f9140f7so1082209ilp.9
        for <linux-unionfs@vger.kernel.org>; Wed, 08 Sep 2021 01:26:12 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:date:in-reply-to:message-id:subject
         :from:to;
        bh=78IxIo20RHVjo5QvtpSB+aSKKhjTDobbC+QvMjvPAiw=;
        b=H6K01UtPqO2H3mI4mUV7V7BrdvTKqVFBDN/CPDe9rGAk08ZX8AKpUjybza7RwI1rHb
         ANG1P+edy30HFOB6JdjCvErvxsbIseBYTtyDOHr+dDAksK7q1fFkZztsBl6OeVnn4FTx
         kbEvw8eL7Xy0+N9UC8bSdj4SESVGEiIJoK/3HWz1x8FhNVtt5GcClAxWR0aBVKrHRlP8
         6D5iOZ/h2M1/1L4rgRCwVJY29+qj1aaosj5DBfW2x5YtrZv8yuRCj3mRE6yjf7qmaiDQ
         7yywyGB67F+X5aSNHxqkuwMi4wjNndO072ah0QzirWWTqdr4W/M3/Jq27fnJjVlG2Jtv
         xfpA==
X-Gm-Message-State: AOAM532BvWS0nB+zGSCSyuhZMEhtA4TfIrTL1Zp9LwZj8n8rCpvJRmnh
        oTj8CTMWO6xy/WV/Z69Z/g9sHKI1SQDCPfFeY+CAECt6oMf1
X-Google-Smtp-Source: ABdhPJylhXqTPfF2GffTlDJJAOvyXDXchsxNmGUL/aOTLpIx5wk15j5BBJzC8fejpT4lNWlkYFc8nELAx9DVV54E46MiLpKLxl2l
MIME-Version: 1.0
X-Received: by 2002:a05:6638:1613:: with SMTP id x19mr2579191jas.77.1631089571970;
 Wed, 08 Sep 2021 01:26:11 -0700 (PDT)
Date:   Wed, 08 Sep 2021 01:26:11 -0700
In-Reply-To: <CAJfpegvVL-U3_4rhnhAU15qMAH-6WBuvmhnPMUkr_423R_2TOA@mail.gmail.com>
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <00000000000088c3ec05cb77a2c2@google.com>
Subject: Re: [syzbot] WARNING in ovl_create_real
From:   syzbot <syzbot+75eab84fd0af9e8bf66b@syzkaller.appspotmail.com>
To:     linux-kernel@vger.kernel.org, linux-unionfs@vger.kernel.org,
        miklos@szeredi.hu, syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-unionfs.vger.kernel.org>
X-Mailing-List: linux-unionfs@vger.kernel.org

Hello,

syzbot has tested the proposed patch and the reproducer did not trigger any issue:

Reported-and-tested-by: syzbot+75eab84fd0af9e8bf66b@syzkaller.appspotmail.com

Tested on:

commit:         ac08b1c6 Merge tag 'pci-v5.15-changes' of git://git.ke..
git tree:       upstream
kernel config:  https://syzkaller.appspot.com/x/.config?x=3ec7a3d00a9dd6f1
dashboard link: https://syzkaller.appspot.com/bug?extid=75eab84fd0af9e8bf66b
compiler:       gcc (Debian 10.2.1-6) 10.2.1 20210110, GNU ld (GNU Binutils for Debian) 2.35.1
patch:          https://syzkaller.appspot.com/x/patch.diff?x=10a55a43300000

Note: testing is done by a robot and is best-effort only.
