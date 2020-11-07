Return-Path: <SRS0=vXub=EN=vger.kernel.org=linux-unionfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.7 required=3.0 tests=BAYES_00,FROM_LOCAL_HEX,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 981FBC388F7
	for <linux-unionfs@archiver.kernel.org>; Sat,  7 Nov 2020 12:10:08 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 53A19206F4
	for <linux-unionfs@archiver.kernel.org>; Sat,  7 Nov 2020 12:10:08 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727320AbgKGMKH (ORCPT
        <rfc822;linux-unionfs@archiver.kernel.org>);
        Sat, 7 Nov 2020 07:10:07 -0500
Received: from mail-il1-f197.google.com ([209.85.166.197]:40673 "EHLO
        mail-il1-f197.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727298AbgKGMKH (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Sat, 7 Nov 2020 07:10:07 -0500
Received: by mail-il1-f197.google.com with SMTP id g14so2963397ilr.7
        for <linux-unionfs@vger.kernel.org>; Sat, 07 Nov 2020 04:10:06 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:date:in-reply-to:message-id:subject
         :from:to;
        bh=bEPCOFw5S5rBelNwysXtchmzidY5p8w+fdQ9rPQh+s4=;
        b=prvH2YLljH/TRY/QMzj4aS2aPuM2qFFFx06L8KSrOVBn438iu5ISIT4CBt48PAhJhO
         /zbtqT0Oi+E1snLjxN5M1THk0BNMwAlYpguGqTxf5eYKDnT4vskNMl0NHqSKltBpSL+Y
         EXP+XuzdFXn7suLOPakeTsH+4wUVDEJJERmpT2Hdk04VIqzfWscHMY67jnlaTsIo4mgI
         XHXSOblcnouAYdW6fJkCJh6AOHQo0X3h5AcZ9lu08W+Tz236JFbx/3ljS5KZk0ez6lzl
         G7Tz/J82xv2Q5O7Dth27uEkxVSOsSO19KTGw1DPIF8cYw5FLNtybWMoWCATfNY5Gh3YH
         wD1g==
X-Gm-Message-State: AOAM531INpp3kYBailc/4yGtRYYzsgB5jIK/yFrPo12WozugTgbSt1JQ
        bUnR58ruhWzg509ecwigoK40iYyH19KPgQoXWWS/b1ciK5DH
X-Google-Smtp-Source: ABdhPJy/fr/95Krh7za4yiITJhgfJeU+W90NQEYDsQN2T1cH8wGjrelyVfzoWNnPmSrQoa+mWN3xe4S+Mr6tLRiC6Ft6svXkCXrw
MIME-Version: 1.0
X-Received: by 2002:a05:6e02:11a4:: with SMTP id 4mr359864ilj.141.1604751006170;
 Sat, 07 Nov 2020 04:10:06 -0800 (PST)
Date:   Sat, 07 Nov 2020 04:10:06 -0800
In-Reply-To: <000000000000d03eea0571adfe83@google.com>
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <000000000000ad052105b383350a@google.com>
Subject: Re: possible deadlock in mnt_want_write
From:   syzbot <syzbot+ae82084b07d0297e566b@syzkaller.appspotmail.com>
To:     amir73il@gmail.com, ast@kernel.org, dvyukov@google.com,
        linux-fsdevel@vger.kernel.org, linux-integrity@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-unionfs@vger.kernel.org,
        miklos@szeredi.hu, mszeredi@redhat.com, rgoldwyn@suse.de,
        syzkaller-bugs@googlegroups.com, viro@zeniv.linux.org.uk,
        zohar@linux.ibm.com, zohar@linux.vnet.ibm.com
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-unionfs.vger.kernel.org>
X-Mailing-List: linux-unionfs@vger.kernel.org

syzbot suspects this issue was fixed by commit:

commit 146d62e5a5867fbf84490d82455718bfb10fe824
Author: Amir Goldstein <amir73il@gmail.com>
Date:   Thu Apr 18 14:42:08 2019 +0000

    ovl: detect overlapping layers

bisection log:  https://syzkaller.appspot.com/x/bisect.txt?x=11e40184500000
start commit:   6d906f99 Merge tag 'arm64-fixes' of git://git.kernel.org/p..
git tree:       upstream
kernel config:  https://syzkaller.appspot.com/x/.config?x=856fc6d0fbbeede9
dashboard link: https://syzkaller.appspot.com/bug?extid=ae82084b07d0297e566b
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=111767b7200000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=1611ab2d200000

If the result looks correct, please mark the issue as fixed by replying with:

#syz fix: ovl: detect overlapping layers

For information about bisection process see: https://goo.gl/tpsmEJ#bisection
