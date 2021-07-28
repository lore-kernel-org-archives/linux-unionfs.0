Return-Path: <linux-unionfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.7 required=3.0 tests=BAYES_00,FROM_LOCAL_HEX,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A10C3C4338F
	for <linux-unionfs@archiver.kernel.org>; Wed, 28 Jul 2021 20:57:08 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 7349860234
	for <linux-unionfs@archiver.kernel.org>; Wed, 28 Jul 2021 20:57:08 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231668AbhG1U5J (ORCPT
        <rfc822;linux-unionfs@archiver.kernel.org>);
        Wed, 28 Jul 2021 16:57:09 -0400
Received: from mail-il1-f197.google.com ([209.85.166.197]:57220 "EHLO
        mail-il1-f197.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231645AbhG1U5J (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Wed, 28 Jul 2021 16:57:09 -0400
Received: by mail-il1-f197.google.com with SMTP id u2-20020a056e021a42b0290221b4e6b2c8so2095724ilv.23
        for <linux-unionfs@vger.kernel.org>; Wed, 28 Jul 2021 13:57:07 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:date:in-reply-to:message-id:subject
         :from:to;
        bh=k7avy/HerkLzVt2TDE6cKZ9UT96PiKh/Pc16LGwaHOo=;
        b=KVUX5OB2UJb6nx3UpMiyZO+/v+HZtIIlf+/h1pMBKZ9ehzoTXuPAOfp6A0tVnzxXEB
         tt/hyM+8/raJoY6vy77nzIfWe30+oNcSpxSLYa1eEsBqWmX+kP40Vg+t+m3JE5VGipL7
         0GsLYWvqApLyRx0aqHiAbt84dubrYALyOfoZkbd+41ZCvPAgdCleLLFz4bReDvzd6Am3
         fa+VJrHFCBLNK8LIKMk9iKVou1K27FuPXoR+fBORMjMvU/w5DDfkVtD/SO891WG3FEhd
         oGwLQ8I/C18gqUT7y2FlMSdTI6zf7/f31aBSBjetokye+4GIgC5IPmHScK25QOLQT/Uh
         4XwQ==
X-Gm-Message-State: AOAM531xFpWdqVmWjcmuw3O4v8LKSr7VlemeeB5KGNo6uDiwE+iioeAR
        n+QkA7ni3rf1J5X6opPll13nXar1xDavHcgyBFoht6oBcjMP
X-Google-Smtp-Source: ABdhPJyZnAPPwgmg7uF5y/Cxw8Xv6DuGKAwZPuLqUazVOHeSKjzDmsa4PIvTWSOdsoD6wYrDR8P75M72ExNJce5udu9KdgSwzi/G
MIME-Version: 1.0
X-Received: by 2002:a02:cf0e:: with SMTP id q14mr1461977jar.86.1627505827360;
 Wed, 28 Jul 2021 13:57:07 -0700 (PDT)
Date:   Wed, 28 Jul 2021 13:57:07 -0700
In-Reply-To: <CAJfpeguXWAJRyRn=8tLRq41kqjuSnX9VNqNT_V2+jhuttC0nEw@mail.gmail.com>
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <000000000000b5b15305c8353a74@google.com>
Subject: Re: [syzbot] possible deadlock in iter_file_splice_write (2)
From:   syzbot <syzbot+4bdbcaa79e8ee36fe6af@syzkaller.appspotmail.com>
To:     linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-unionfs@vger.kernel.org, miklos@szeredi.hu,
        mszeredi@redhat.com, syzkaller-bugs@googlegroups.com,
        viro@zeniv.linux.org.uk
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-unionfs.vger.kernel.org>
X-Mailing-List: linux-unionfs@vger.kernel.org

Hello,

syzbot has tested the proposed patch and the reproducer did not trigger any issue:

Reported-and-tested-by: syzbot+4bdbcaa79e8ee36fe6af@syzkaller.appspotmail.com

Tested on:

commit:         cdaddca6 ovl: fix deadlock in splice write
git tree:       git://git.kernel.org/pub/scm/linux/kernel/git/mszeredi/vfs.git overlayfs-next
kernel config:  https://syzkaller.appspot.com/x/.config?x=4aa932b5eaeee9ef
dashboard link: https://syzkaller.appspot.com/bug?extid=4bdbcaa79e8ee36fe6af
compiler:       Debian clang version 11.0.1-2, GNU ld (GNU Binutils for Debian) 2.35.1

Note: testing is done by a robot and is best-effort only.
