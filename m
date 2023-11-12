Return-Path: <linux-unionfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A228BC4332F
	for <linux-unionfs@archiver.kernel.org>; Sun, 12 Nov 2023 15:09:06 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231430AbjKLPJI (ORCPT
        <rfc822;linux-unionfs@archiver.kernel.org>);
        Sun, 12 Nov 2023 10:09:08 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38550 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231475AbjKLPJH (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Sun, 12 Nov 2023 10:09:07 -0500
Received: from mail-pg1-f198.google.com (mail-pg1-f198.google.com [209.85.215.198])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BD91B2D63
        for <linux-unionfs@vger.kernel.org>; Sun, 12 Nov 2023 07:09:04 -0800 (PST)
Received: by mail-pg1-f198.google.com with SMTP id 41be03b00d2f7-5be09b7d01fso2947952a12.1
        for <linux-unionfs@vger.kernel.org>; Sun, 12 Nov 2023 07:09:04 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1699801744; x=1700406544;
        h=to:from:subject:message-id:in-reply-to:date:mime-version
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=srdz066tvvTdM4CmNeOwelm2biHAQtgJiKmsTshSsQM=;
        b=PT/bioPC67jr8xoqtYZ9QnkQPMfzrFCQOYAid3VkH6h5cSw+OTbFmkrPgYiptTDogm
         F1nBl6qapgtT+Nomd3ZuTjGAtGz0YwwScB0mrALJLyLMpEuskIGbMJgIMjQRAH5o55Tx
         a0EZQyY2LnpgJqnm7/ie3vaqnVWNJyZ//StSSixMXl1LV1FFuDYYKJfmBAxPzUz69oOf
         UghP5AtgtG7vJyJ9c4r3y3gA7Fkatzbfy2YsPWg9KZG+Nt15lP24OXaJ0DkmE4UihgF4
         AgwOEQea9JTUMrPE+NL84H172k7g77bqMqTr3GyyE0d3pMgfT9pPXlvMrRWvqkWaX398
         jylg==
X-Gm-Message-State: AOJu0YzbmM9MArzBhS8GLRyHr6fiFsbkq74VX6SUClPltNTV+bgjv5GI
        jA3AjyJjwvsE/chU+1MlNFYSh3DOWszT/PD2UJIrgSsKoZtC
X-Google-Smtp-Source: AGHT+IGs5Bkh6t4mkKR/0xr7IdzglfJ6hUWB8xmVEG9vXFMRG6t/rR+LHznVq6ba/NS14YuOHKxykcNXYixm3z/LZbZCrCy89uco
MIME-Version: 1.0
X-Received: by 2002:a05:6a02:523:b0:5bd:9b7f:b08d with SMTP id
 bx35-20020a056a02052300b005bd9b7fb08dmr1552203pgb.0.1699801744211; Sun, 12
 Nov 2023 07:09:04 -0800 (PST)
Date:   Sun, 12 Nov 2023 07:09:04 -0800
In-Reply-To: <CAOQ4uxhnY+hzfCA7A2aTfVKsveR9g6Hn=FbFrjFuXs8w3sYX5Q@mail.gmail.com>
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <000000000000271e420609f5eff0@google.com>
Subject: Re: [syzbot] [overlayfs?] memory leak in ovl_parse_param
From:   syzbot <syzbot+26eedf3631650972f17c@syzkaller.appspotmail.com>
To:     amir73il@gmail.com, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-unionfs@vger.kernel.org,
        miklos@szeredi.hu, syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-unionfs.vger.kernel.org>
X-Mailing-List: linux-unionfs@vger.kernel.org

Hello,

syzbot has tested the proposed patch and the reproducer did not trigger any issue:

Reported-and-tested-by: syzbot+26eedf3631650972f17c@syzkaller.appspotmail.com

Tested on:

commit:         97d58994 ovl: fix memory leak in ovl_parse_param()
git tree:       https://github.com/amir73il/linux ovl-fixes
console output: https://syzkaller.appspot.com/x/log.txt?x=12394b97680000
kernel config:  https://syzkaller.appspot.com/x/.config?x=ecfdf78a410c834
dashboard link: https://syzkaller.appspot.com/bug?extid=26eedf3631650972f17c
compiler:       gcc (Debian 12.2.0-14) 12.2.0, GNU ld (GNU Binutils for Debian) 2.40

Note: no patches were applied.
Note: testing is done by a robot and is best-effort only.
