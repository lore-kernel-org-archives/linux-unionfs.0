Return-Path: <linux-unionfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 122E2EB64DD
	for <linux-unionfs@archiver.kernel.org>; Tue, 11 Jul 2023 09:55:32 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229468AbjGKJzb (ORCPT
        <rfc822;linux-unionfs@archiver.kernel.org>);
        Tue, 11 Jul 2023 05:55:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41674 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230017AbjGKJz3 (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Tue, 11 Jul 2023 05:55:29 -0400
Received: from mail-ot1-f72.google.com (mail-ot1-f72.google.com [209.85.210.72])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BCC47DD
        for <linux-unionfs@vger.kernel.org>; Tue, 11 Jul 2023 02:55:26 -0700 (PDT)
Received: by mail-ot1-f72.google.com with SMTP id 46e09a7af769-6b7431b77ffso4318897a34.0
        for <linux-unionfs@vger.kernel.org>; Tue, 11 Jul 2023 02:55:26 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1689069326; x=1691661326;
        h=to:from:subject:message-id:in-reply-to:date:mime-version
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=ZcloSHs79l9WLtw5wCq7rljrtMphumU2bij75yt+08U=;
        b=akMMsAC8P8ncgdTr5OxyB3wRUFFDqFRcVoCoOmacpYboy1Rp5PdAAZBLD6DL8XcIzl
         wQ/zRn+2cTylIJfpGx7BhpERztxB+motZxpVQzyhofOJxmIQRvZ9k3oM9YSDKZ7KfPl6
         DC//Ms1O+bBbQPaDL4EI0M5LxEFiMC2QHoQUbqBOgFKRl1XBPGEgtyNtcpG1X/VHRizx
         aRkwr0ptiZSYem6ChwBEejxSpzrDbHRZnGCVzz5BOTLPpO17uw2AsbB+S6krjtvzIH34
         KZItRrtdRrCiUvRmcvXa67i6UE+yW7gnzF33zLv1hHrLPiNh2SyA0ngBcTL5RuVHv9h3
         ICGg==
X-Gm-Message-State: ABy/qLYpgPXcg60lAhM+8JuYK9EcKuukoK6vPfk7dzGKqhncwqJjm08t
        4TzdPlgiIN4CWJS30uCtelbhStuD+AxsIF+4UkgDH3ri240k
X-Google-Smtp-Source: APBJJlG+Y2stJI6lo+xrfpFL0vzaKSDOn/mZxf8Cf2lChooL8gNyzSBg1zJaCt6wJiO6k1leSV57zO96Wz6zgVVABI47EAn4TrM5
MIME-Version: 1.0
X-Received: by 2002:a05:6870:d8ae:b0:1b4:71b0:749 with SMTP id
 dv46-20020a056870d8ae00b001b471b00749mr1062532oab.3.1689069326128; Tue, 11
 Jul 2023 02:55:26 -0700 (PDT)
Date:   Tue, 11 Jul 2023 02:55:26 -0700
In-Reply-To: <CAOQ4uxgQodMoCLvO6TGPiR3dKOhbtYKrDHzmu-gkaRAO8iSLTQ@mail.gmail.com>
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <0000000000002f59ee06003319ec@google.com>
Subject: Re: [syzbot] [overlayfs?] general protection fault in ovl_init_uuid_xattr
From:   syzbot <syzbot+b592c1f562f0da80ce2c@syzkaller.appspotmail.com>
To:     amir73il@gmail.com, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-unionfs@vger.kernel.org,
        miklos@szeredi.hu, syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-unionfs.vger.kernel.org>
X-Mailing-List: linux-unionfs@vger.kernel.org

Hello,

syzbot has tested the proposed patch and the reproducer did not trigger any issue:

Reported-and-tested-by: syzbot+b592c1f562f0da80ce2c@syzkaller.appspotmail.com

Tested on:

commit:         0a3bf81d ovl: auto generate uuid for new overlay files..
git tree:       git://git.kernel.org/pub/scm/linux/kernel/git/overlayfs/vfs.git overlayfs-next
console output: https://syzkaller.appspot.com/x/log.txt?x=16079b6ca80000
kernel config:  https://syzkaller.appspot.com/x/.config?x=150188feee7071a7
dashboard link: https://syzkaller.appspot.com/bug?extid=b592c1f562f0da80ce2c
compiler:       gcc (Debian 10.2.1-6) 10.2.1 20210110, GNU ld (GNU Binutils for Debian) 2.35.2

Note: no patches were applied.
Note: testing is done by a robot and is best-effort only.
