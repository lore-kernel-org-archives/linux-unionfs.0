Return-Path: <linux-unionfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EA0C2CE7A89
	for <linux-unionfs@archiver.kernel.org>; Mon, 25 Sep 2023 06:04:40 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232051AbjIYGEp (ORCPT
        <rfc822;linux-unionfs@archiver.kernel.org>);
        Mon, 25 Sep 2023 02:04:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54632 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231937AbjIYGEm (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Mon, 25 Sep 2023 02:04:42 -0400
Received: from mail-oi1-f198.google.com (mail-oi1-f198.google.com [209.85.167.198])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C366B83
        for <linux-unionfs@vger.kernel.org>; Sun, 24 Sep 2023 23:04:35 -0700 (PDT)
Received: by mail-oi1-f198.google.com with SMTP id 5614622812f47-3ae33bc5584so8367941b6e.3
        for <linux-unionfs@vger.kernel.org>; Sun, 24 Sep 2023 23:04:35 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1695621875; x=1696226675;
        h=to:from:subject:message-id:in-reply-to:date:mime-version
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=khHBmXA2nIs3RhLksCBbFyOHEO223Qv5mG+a8oCpCJQ=;
        b=u54lKyWx3+nEMaoArN7K9xTy/K8SJsMpWgv7MAwccv4kMgQ8MGXawvsZne+/JkP3Iq
         CEumGFQODAIN0F8O5sw/tcasz4eMMyvc48aiDskoiKSUOPO4Q6SfKWe/1Lo8vci2p3LM
         tPiXlD2y8GvdJx857KqlcdEutx7jvUIotIIsv1y2qyB68WsH5BENJ4zKyIZKgIfmotUo
         noFMJhjhdIg17VFzsj/c5QnIgzyP09BaUid0L4nZ1SHYxgUMFMg+EwFXvmz3uVDSme1G
         /04+bkaHCD09kV+cK5G+n0P5VXbXXRpAue+/jilnWv+91ofjdsmFA81mvLxsAciwceuM
         gzHQ==
X-Gm-Message-State: AOJu0YxAC+2lXTQGRJFr1LY64J4jloIWaq+QlAr+Lo2+M2v1CUK01YRu
        dKLKsslYI901jbSaXoyOB+WpqXWsmPs8Fc5VDV6FS8cYFUiT
X-Google-Smtp-Source: AGHT+IE485Egvd8Rw1szIweDcKYzID3+yJ1Zs3+MB+PybtfzFp8nFtfcYXSU3GYVqtn8I5orYLBFoL1j+GIQC7zKRp855KirTrKA
MIME-Version: 1.0
X-Received: by 2002:a05:6808:209d:b0:3ae:17ed:fdc9 with SMTP id
 s29-20020a056808209d00b003ae17edfdc9mr3280617oiw.9.1695621875117; Sun, 24 Sep
 2023 23:04:35 -0700 (PDT)
Date:   Sun, 24 Sep 2023 23:04:35 -0700
In-Reply-To: <000000000000964cb905f5e876ff@google.com>
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <0000000000008a3693060628bb0b@google.com>
Subject: Re: [syzbot] [reiserfs?] possible deadlock in delete_one_xattr (2)
From:   syzbot <syzbot+7a278bf8bfa794494110@syzkaller.appspotmail.com>
To:     amir73il@gmail.com, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-unionfs@vger.kernel.org,
        miklos@szeredi.hu, mszeredi@redhat.com,
        reiserfs-devel@vger.kernel.org, syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-unionfs.vger.kernel.org>
X-Mailing-List: linux-unionfs@vger.kernel.org

syzbot has bisected this issue to:

commit 9df085f3c9a2d4658a9fe323d70c200aa00ede93
Author: Amir Goldstein <amir73il@gmail.com>
Date:   Mon Sep 3 06:12:09 2018 +0000

    ovl: relax requirement for non null uuid of lower fs

bisection log:  https://syzkaller.appspot.com/x/bisect.txt?x=1711e75a680000
start commit:   ac9a78681b92 Linux 6.4-rc1
git tree:       upstream
final oops:     https://syzkaller.appspot.com/x/report.txt?x=1491e75a680000
console output: https://syzkaller.appspot.com/x/log.txt?x=1091e75a680000
kernel config:  https://syzkaller.appspot.com/x/.config?x=8bc832f563d8bf38
dashboard link: https://syzkaller.appspot.com/bug?extid=7a278bf8bfa794494110
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=1295e4b8280000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=140af20a280000

Reported-by: syzbot+7a278bf8bfa794494110@syzkaller.appspotmail.com
Fixes: 9df085f3c9a2 ("ovl: relax requirement for non null uuid of lower fs")

For information about bisection process see: https://goo.gl/tpsmEJ#bisection
