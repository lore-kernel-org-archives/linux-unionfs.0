Return-Path: <linux-unionfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BB546C433FE
	for <linux-unionfs@archiver.kernel.org>; Thu, 13 Oct 2022 08:30:28 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229495AbiJMIa1 (ORCPT
        <rfc822;linux-unionfs@archiver.kernel.org>);
        Thu, 13 Oct 2022 04:30:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45304 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229437AbiJMIa1 (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Thu, 13 Oct 2022 04:30:27 -0400
Received: from mail-il1-f200.google.com (mail-il1-f200.google.com [209.85.166.200])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0FC4C9DD9E
        for <linux-unionfs@vger.kernel.org>; Thu, 13 Oct 2022 01:30:26 -0700 (PDT)
Received: by mail-il1-f200.google.com with SMTP id f15-20020a056e020b4f00b002fa34db70f0so986065ilu.2
        for <linux-unionfs@vger.kernel.org>; Thu, 13 Oct 2022 01:30:26 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=to:from:subject:message-id:in-reply-to:date:mime-version
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=RCfRBkrrNMRK19v311kWSWOmZyezCZ5TsQNU9jK1WPs=;
        b=WauhZU3Joy9gJufxToAA+nNzntR7gKxn2KJINj25r5XsLIq/pFLXAsHaejYZL4R5MI
         7X4+HmD+DiAMxOKLIhL+CV29c+bAUNKWYFuh5XFEIK6sAE/jevs9J+hm6IR2PSMLBwUn
         SGvwYfB/HVfZITWHUz9r1ydUQNriBR1in05i5BzPPmqCmt6oPIrOUuOHvIpomYm+cHxA
         FTtymDT05G9PjDHZS72ovn/M0Or/0hX6dScxTn7YjfhnOODsY3eybEANzacnp2gCrLMp
         EGT8FyO8eJvfZRrMIeMKxQ0pIng01SlABlGsR94K15tiD9IVqoBnMAxzrNEJQtLCU5JY
         yL+w==
X-Gm-Message-State: ACrzQf3BwNr9n3gN8h5HZObuwMo2DWjC3PMQBvgwb2c8FlXj2TK/iKpd
        RwZSdk6AL/3nuRFX3w+a4/pa1/M03XC1AFEt+zCwWdeR+iaN
X-Google-Smtp-Source: AMsMyM7k6/9AD14vBsPc4TY6v/uhwtYqAUGIdVoyfvsNLy06yTlJWYcH1pPUieL+9pxpX0fJHx+uSu0CbSbNbFFSFePqs/gM9EIW
MIME-Version: 1.0
X-Received: by 2002:a02:a307:0:b0:363:bd76:17fd with SMTP id
 q7-20020a02a307000000b00363bd7617fdmr9775450jai.248.1665649825465; Thu, 13
 Oct 2022 01:30:25 -0700 (PDT)
Date:   Thu, 13 Oct 2022 01:30:25 -0700
In-Reply-To: <CAJfpegtyWgdZDxPoYgwE=LekX1bNi8x0+Odvh-KYthSVxZMx7Q@mail.gmail.com>
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <0000000000002acbb605eae652b1@google.com>
Subject: Re: [syzbot] memory leak in vfs_tmpfile_open
From:   syzbot <syzbot+fd749a7ea127a84e0ffd@syzkaller.appspotmail.com>
To:     linux-kernel@vger.kernel.org, linux-unionfs@vger.kernel.org,
        miklos@szeredi.hu, syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-unionfs.vger.kernel.org>
X-Mailing-List: linux-unionfs@vger.kernel.org

Hello,

syzbot tried to test the proposed patch but the build/boot failed:

kernel clean failed: failed to start /usr/bin/make [make -j 64 ARCH=x86_64]: fork/exec /usr/bin/make: no such file or directory


Tested on:

commit:         a185a099 Merge tag 'linux-kselftest-kunit-6.1-rc1-2' o..
git tree:       upstream
dashboard link: https://syzkaller.appspot.com/bug?extid=fd749a7ea127a84e0ffd
compiler:       
patch:          https://syzkaller.appspot.com/x/patch.diff?x=1452718a880000

