Return-Path: <linux-unionfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C05C9E75424
	for <linux-unionfs@archiver.kernel.org>; Tue,  3 Oct 2023 04:56:36 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230161AbjJCE4h (ORCPT
        <rfc822;linux-unionfs@archiver.kernel.org>);
        Tue, 3 Oct 2023 00:56:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42666 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230249AbjJCE4h (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Tue, 3 Oct 2023 00:56:37 -0400
Received: from mail-ot1-f71.google.com (mail-ot1-f71.google.com [209.85.210.71])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1375EE0
        for <linux-unionfs@vger.kernel.org>; Mon,  2 Oct 2023 21:56:34 -0700 (PDT)
Received: by mail-ot1-f71.google.com with SMTP id 46e09a7af769-6c4b9cab821so580063a34.0
        for <linux-unionfs@vger.kernel.org>; Mon, 02 Oct 2023 21:56:34 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1696308993; x=1696913793;
        h=to:from:subject:message-id:in-reply-to:date:mime-version
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=XfrUWOBmU6zzAiZBESX6DIbmzW9eMSUX6mzf04Ler6k=;
        b=rY13bg7jhzurTcnt94xiX1YhYMbbzXfuZcdYeVDs/NbpU6Y9jI+RzWUznmcTbauvDe
         Wre/QiqoPs22em0lVB8D9+SLW/mfIEFKG33ebGCzh4wCF9ha+G/sxaYVmIW9MAXUogVS
         /1vjCrHdEDW6HtzZaQUAqygKTmjDMS0v4+k05BXu8fn1+oH6KFnQ3X7X6vm4XC5NRfU8
         14wopBzg5YC+/6089ixcGpc//H0qVagEGlUUy/KKncEh92WeGZm55bnIW0dLTFTCRRBV
         K5UMPoxwdIoSrAf58KJW6cxSLsz1/9AU8PMmJiSnzNBrZfqIc1zg9cQcYCcoq318PI4I
         SltA==
X-Gm-Message-State: AOJu0Yw5xCNX3hE/JdhPlTAZJk1ec99DN49yZfGwHOqn2Jvuo3tLcFYp
        q8EZfRriiZXCPTWzpDtm+r6ApiNCmZyC/uej7W1ZopO1lzig
X-Google-Smtp-Source: AGHT+IEbktwgravybWHUhcjDg2HPO0fZM9+laAEhvFerNy1UOSXTCbPCj1YqCLbR/KpGxOSSpO2R8d6JaZU/dh4DnHuTyvkCO+Z9
MIME-Version: 1.0
X-Received: by 2002:a05:6808:2219:b0:3ac:ab4f:ef3 with SMTP id
 bd25-20020a056808221900b003acab4f0ef3mr7223567oib.6.1696308993424; Mon, 02
 Oct 2023 21:56:33 -0700 (PDT)
Date:   Mon, 02 Oct 2023 21:56:33 -0700
In-Reply-To: <00000000000056dad80606c447e0@google.com>
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <000000000000fb84850606c8b688@google.com>
Subject: Re: [syzbot] [overlayfs?] general protection fault in ovl_encode_real_fh
From:   syzbot <syzbot+2208f82282740c1c8915@syzkaller.appspotmail.com>
To:     amir73il@gmail.com, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-unionfs@vger.kernel.org,
        miklos@szeredi.hu, syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-unionfs.vger.kernel.org>
X-Mailing-List: linux-unionfs@vger.kernel.org

syzbot has bisected this issue to:

commit 16aac5ad1fa94894b798dd522c5c3a6a0628d7f0
Author: Amir Goldstein <amir73il@gmail.com>
Date:   Sun Apr 23 16:02:04 2023 +0000

    ovl: support encoding non-decodable file handles

bisection log:  https://syzkaller.appspot.com/x/bisect.txt?x=11972062680000
start commit:   8a749fd1a872 Linux 6.6-rc4
git tree:       upstream
final oops:     https://syzkaller.appspot.com/x/report.txt?x=13972062680000
console output: https://syzkaller.appspot.com/x/log.txt?x=15972062680000
kernel config:  https://syzkaller.appspot.com/x/.config?x=57da1ac039c4c78a
dashboard link: https://syzkaller.appspot.com/bug?extid=2208f82282740c1c8915
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=14877eb2680000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=13b701f6680000

Reported-by: syzbot+2208f82282740c1c8915@syzkaller.appspotmail.com
Fixes: 16aac5ad1fa9 ("ovl: support encoding non-decodable file handles")

For information about bisection process see: https://goo.gl/tpsmEJ#bisection
