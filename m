Return-Path: <linux-unionfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7C54CC433FE
	for <linux-unionfs@archiver.kernel.org>; Thu, 24 Nov 2022 16:20:19 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229676AbiKXQUS (ORCPT
        <rfc822;linux-unionfs@archiver.kernel.org>);
        Thu, 24 Nov 2022 11:20:18 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55526 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229468AbiKXQUR (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Thu, 24 Nov 2022 11:20:17 -0500
Received: from mail-il1-f197.google.com (mail-il1-f197.google.com [209.85.166.197])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CA15614E6EF
        for <linux-unionfs@vger.kernel.org>; Thu, 24 Nov 2022 08:20:16 -0800 (PST)
Received: by mail-il1-f197.google.com with SMTP id a14-20020a921a0e000000b00302a8ffa8e5so1410318ila.2
        for <linux-unionfs@vger.kernel.org>; Thu, 24 Nov 2022 08:20:16 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=to:from:subject:message-id:in-reply-to:date:mime-version
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=BLu57xj1JC82H0XXz+GNssdmQJiC9qe/YgctFzNmVG4=;
        b=Oe/f4eRTWs5VO4xpWuGP1WGixLrUXFtP7QGZMKtfW0Q5rD6MIc8OZ/a97BcJWW8JuE
         UEY81qWYaXUz+xDtcZ/QxDIJoQFkk+dnM6PyisyaXFRx2zXidgLMax/ueThYZJpWmrnv
         efqM8BbZ4XuUt/VHL2ZuVMEc+70d9eEV6ZGO5o4ShYrRZLfaECUpcbLNSwCUDcmDQsad
         1oj8PfBpffeMpLlD8D7Gop1OmK5B/7uY0r9XdUtV9d9QO5C3U3Jf0yW0TAHzoDwrISG1
         MKmPNczhcrLqT+byXGfWuVG0mJui/jprV7r+o8Kbak1WApmrKjJxi0wxKUeeFBKRVcfw
         MmLA==
X-Gm-Message-State: ANoB5pkSCOJDrDi+WwQWWfnw9wGiX3O7a4QRUY24NDhivRF1/0AYeADL
        OTyFfJsRd69gpAnlOfnBCOL/CeWe9BK42uWYouMvD5zA0CRw
X-Google-Smtp-Source: AA0mqf4SJAQZVT4Jwk7/+fz5PzSbbTOB+9yCW80SQJofgTk2Q1JpUZ6ITjSAqpEq12edrM6PcQ2CYn2mBv5fHDzsVoZBesMnImOs
MIME-Version: 1.0
X-Received: by 2002:a05:6638:1c0a:b0:386:8261:ab08 with SMTP id
 ca10-20020a0566381c0a00b003868261ab08mr4116458jab.21.1669306816155; Thu, 24
 Nov 2022 08:20:16 -0800 (PST)
Date:   Thu, 24 Nov 2022 08:20:16 -0800
In-Reply-To: <CAJfpeguD4Ai8_PiRnDO8dRFauHPdwLimWrB6xsxsyn8yFLgL6w@mail.gmail.com>
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <000000000000cc587705ee39c75c@google.com>
Subject: Re: [syzbot] general protection fault in ovl_dentry_upper
From:   syzbot <syzbot+a4055c78774bbf3498bb@syzkaller.appspotmail.com>
To:     linux-kernel@vger.kernel.org, linux-unionfs@vger.kernel.org,
        miklos@szeredi.hu, syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-unionfs.vger.kernel.org>
X-Mailing-List: linux-unionfs@vger.kernel.org

Hello,

syzbot has tested the proposed patch and the reproducer did not trigger any issue:

Reported-and-tested-by: syzbot+a4055c78774bbf3498bb@syzkaller.appspotmail.com

Tested on:

commit:         c3eb11fb Merge tag 'pci-v6.1-fixes-3' of git://git.ker..
git tree:       upstream
console output: https://syzkaller.appspot.com/x/log.txt?x=14a0ec05880000
kernel config:  https://syzkaller.appspot.com/x/.config?x=8cdf448d3b35234
dashboard link: https://syzkaller.appspot.com/bug?extid=a4055c78774bbf3498bb
compiler:       Debian clang version 13.0.1-++20220126092033+75e33f71c2da-1~exp1~20220126212112.63, GNU ld (GNU Binutils for Debian) 2.35.2
patch:          https://syzkaller.appspot.com/x/patch.diff?x=16b17403880000

Note: testing is done by a robot and is best-effort only.
