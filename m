Return-Path: <linux-unionfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 71F1BEB64D9
	for <linux-unionfs@archiver.kernel.org>; Sun,  2 Jul 2023 11:03:27 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229750AbjGBLD0 (ORCPT
        <rfc822;linux-unionfs@archiver.kernel.org>);
        Sun, 2 Jul 2023 07:03:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54484 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229460AbjGBLDY (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Sun, 2 Jul 2023 07:03:24 -0400
Received: from mail-pg1-f198.google.com (mail-pg1-f198.google.com [209.85.215.198])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 955D9126
        for <linux-unionfs@vger.kernel.org>; Sun,  2 Jul 2023 04:03:23 -0700 (PDT)
Received: by mail-pg1-f198.google.com with SMTP id 41be03b00d2f7-55b9ed8275aso97018a12.1
        for <linux-unionfs@vger.kernel.org>; Sun, 02 Jul 2023 04:03:23 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1688295803; x=1690887803;
        h=to:from:subject:message-id:in-reply-to:date:mime-version
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=FW+jnssKc4axivZmxdckxWbOLeaYTizFPCkFahn0NbM=;
        b=iUVAigbiyimKBcf6agskK7vTHKgWN5EsYLLSllELTpIavK0L17lrvGxj5HKX7f2uR/
         jH63mKqiruM/iFsxG6T7eE8qwRnYPc2A2uGxv9W17A6IUFLsZLENHHW+uArQNidhoh3t
         B0CPuzevr7fZSsTFdtJOQe6Dpp5tufHo0nfhBfVBjvoynzRO/UqLZETTFtuXJkV5LbG8
         DvSFcB0oQPo1HOwPysrfIHrkr4SQAyzoXll1dFYIGvUsHhOXGihxv9H3q+F8HRQg821Y
         mbGcFVNIX2h2cpJXeKVCs82a2camx3e3a8ZXIqKkUS+1Sb9ybTQ63Jd+wDf2Zkbvg8ne
         EPVw==
X-Gm-Message-State: ABy/qLawFISal1fjEWCsFvsKfYa0i9LyVdgfPooFHqPvkt3MRxJx/saU
        /1knBDqo9ASxTLIf9N7mc6NX0Cqwr9t49X2kbbsUVa+zlAZL
X-Google-Smtp-Source: APBJJlFdfB5AenJZG4N4lFiG9XgwD5d5IoT/5ELJ7KfLxzpYuDMEclT9CiSS1XLMyJZ3BJ/21rLGPnSXDenjPaeG8ereBhIZWX37
MIME-Version: 1.0
X-Received: by 2002:a63:1a26:0:b0:553:c2df:9059 with SMTP id
 a38-20020a631a26000000b00553c2df9059mr4162075pga.7.1688295803034; Sun, 02 Jul
 2023 04:03:23 -0700 (PDT)
Date:   Sun, 02 Jul 2023 04:03:22 -0700
In-Reply-To: <20230702-neuer-anrief-61b5b722de0f@brauner>
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <0000000000009da2bd05ff7effb2@google.com>
Subject: Re: [syzbot] [overlayfs?] KASAN: invalid-free in init_file
From:   syzbot <syzbot+ada42aab05cf51b00e98@syzkaller.appspotmail.com>
To:     amir73il@gmail.com, brauner@kernel.org,
        linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-unionfs@vger.kernel.org, miklos@szeredi.hu,
        syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-unionfs.vger.kernel.org>
X-Mailing-List: linux-unionfs@vger.kernel.org

Hello,

syzbot has tested the proposed patch and the reproducer did not trigger any issue:

Reported-and-tested-by: syzbot+ada42aab05cf51b00e98@syzkaller.appspotmail.com

Tested on:

commit:         0ed645e2 fs: move cleanup from init_file() into its ca..
git tree:       https://git.kernel.org/pub/scm/linux/kernel/git/vfs/vfs.git vfs.fixes
console output: https://syzkaller.appspot.com/x/log.txt?x=124e2008a80000
kernel config:  https://syzkaller.appspot.com/x/.config?x=78aa7bd472e7bb0d
dashboard link: https://syzkaller.appspot.com/bug?extid=ada42aab05cf51b00e98
compiler:       Debian clang version 15.0.7, GNU ld (GNU Binutils for Debian) 2.35.2

Note: no patches were applied.
Note: testing is done by a robot and is best-effort only.
