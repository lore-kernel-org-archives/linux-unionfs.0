Return-Path: <linux-unionfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EB7BAE92736
	for <linux-unionfs@archiver.kernel.org>; Thu,  5 Oct 2023 16:14:01 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234395AbjJEQN7 (ORCPT
        <rfc822;linux-unionfs@archiver.kernel.org>);
        Thu, 5 Oct 2023 12:13:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38656 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240479AbjJEQND (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Thu, 5 Oct 2023 12:13:03 -0400
Received: from mail-ot1-x346.google.com (mail-ot1-x346.google.com [IPv6:2607:f8b0:4864:20::346])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EAFEB22C9F
        for <linux-unionfs@vger.kernel.org>; Thu,  5 Oct 2023 03:46:29 -0700 (PDT)
Received: by mail-ot1-x346.google.com with SMTP id 46e09a7af769-6c4f235ee22so993924a34.2
        for <linux-unionfs@vger.kernel.org>; Thu, 05 Oct 2023 03:46:29 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1696502789; x=1697107589;
        h=to:from:subject:message-id:in-reply-to:date:mime-version
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=BGwGxlTuATRVWE5UT3ZKJoT5MpU675X68ZbpYCN+7kY=;
        b=ww0aqXMYpJjcosNrpxvm1XVw3xDtX/2ksjnjzBeKzTrQ07iu3Q69jd+yHAtDXh+3/u
         SGuPhrwi+BxzQAEdFVQ1PWhZoasuRvxnbR/EwXNVEZIO75OoyN2cIF49p1Pt06F3YAiH
         4mfhgVAKRo2z/G/55a5H+AXAqe6hwxs4SPWAvTN2okSA7JkYDo5c6hwNJ1tCIWexzDEy
         03yuCllpDsI2XBmmn00Iv6j2Z6M+u0G5uj+OXTxEVp8Pzok4piG1d59pCU56CIb1H+/t
         fyTtlZKmv6Mqi3PhieQKbHe9XFfiGmms7wWPk2PLidnWXZ6Sqqnd0QWOSchDmK9sGdYU
         oc9g==
X-Gm-Message-State: AOJu0YzYv+g1z5BWPRIy/VnetUephqWHVnUFYdSXQGuarkMg+6vxIogo
        u8Rd2jnQ/hSYbEGIeHD3lhvL/lRZUL0cN4QhrCBekqW2aAzz
X-Google-Smtp-Source: AGHT+IF6NXpW2zd+hCeIzElnwrg53MI5PnCCJL42D9bvk43rwJ1rmAHq/sIWi88y/rKUpfhhxrW+Yd6VgiNDyLe+SSuoEVFU4PnF
MIME-Version: 1.0
X-Received: by 2002:a05:6870:1987:b0:1dc:768d:bf6b with SMTP id
 v7-20020a056870198700b001dc768dbf6bmr1900344oam.11.1696502788922; Thu, 05 Oct
 2023 03:46:28 -0700 (PDT)
Date:   Thu, 05 Oct 2023 03:46:28 -0700
In-Reply-To: <CAOQ4uxjw_XztGxrhR9LWtz_SszdURkM+Add2q8A9BAt0z901kA@mail.gmail.com>
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <0000000000001824660606f5d6ac@google.com>
Subject: Re: [syzbot] [integrity] [overlayfs] possible deadlock in
 mnt_want_write (2)
From:   syzbot <syzbot+b42fe626038981fb7bfa@syzkaller.appspotmail.com>
To:     amir73il@gmail.com, hdanton@sina.com,
        linux-fsdevel@vger.kernel.org, linux-integrity@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-mm@kvack.org,
        linux-unionfs@vger.kernel.org, miklos@szeredi.hu,
        mszeredi@redhat.com, syzbot@syzkalhler.appspotmail.com,
        syzkaller-bugs@googlegroups.com, viro@zeniv.linux.org.uk,
        zohar@linux.ibm.com, zohar@us.ibm.com
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-unionfs.vger.kernel.org>
X-Mailing-List: linux-unionfs@vger.kernel.org

Hello,

syzbot has tested the proposed patch and the reproducer did not trigger any issue:

Reported-and-tested-by: syzbot+b42fe626038981fb7bfa@syzkaller.appspotmail.com

Tested on:

commit:         42555f30 ima: annotate iint mutex to avoid lockdep fal..
git tree:       https://github.com/amir73il/linux ima-ovl-fix
console output: https://syzkaller.appspot.com/x/log.txt?x=16889486680000
kernel config:  https://syzkaller.appspot.com/x/.config?x=57da1ac039c4c78a
dashboard link: https://syzkaller.appspot.com/bug?extid=b42fe626038981fb7bfa
compiler:       Debian clang version 15.0.6, GNU ld (GNU Binutils for Debian) 2.40

Note: no patches were applied.
Note: testing is done by a robot and is best-effort only.
