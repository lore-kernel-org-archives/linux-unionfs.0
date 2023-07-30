Return-Path: <linux-unionfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2A572C001DC
	for <linux-unionfs@archiver.kernel.org>; Sun, 30 Jul 2023 14:34:43 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229915AbjG3Oem (ORCPT
        <rfc822;linux-unionfs@archiver.kernel.org>);
        Sun, 30 Jul 2023 10:34:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44424 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229842AbjG3Oek (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Sun, 30 Jul 2023 10:34:40 -0400
Received: from mail-oo1-f70.google.com (mail-oo1-f70.google.com [209.85.161.70])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0A8ACE65
        for <linux-unionfs@vger.kernel.org>; Sun, 30 Jul 2023 07:34:39 -0700 (PDT)
Received: by mail-oo1-f70.google.com with SMTP id 006d021491bc7-56c99e94fa9so1854314eaf.0
        for <linux-unionfs@vger.kernel.org>; Sun, 30 Jul 2023 07:34:39 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1690727678; x=1691332478;
        h=to:from:subject:message-id:in-reply-to:date:mime-version
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=lWEs9tBxQ1qd6Nv15hqv+sQ9Wsq7wE6UQ0dhzWGDEw0=;
        b=btpppN/L0xaIaPa5qCNBzD6JQ2njh0sVYRkt5rL3i1TkzXcD6yttKenP+Dv4eBAwR6
         8rO9DwXUqxJGzJ+R0b0cDcKKLVKtiRraI+mOZOXz/5RMbq5G7gnru/bAHWqpPXf54L0f
         BE76zzGcGDPnSS3HU4ZuwYu/Mo7ICG+n2HPJlNmnTtDysCphgXXQoZu6J4HGAbYJsdA1
         Chd8ug6ych29Us10n/yjhcZ6mDrTvspaqEYlSzWEDM2EsCWiRRP6HQRuYlD2Z/o8W73V
         4b8I4hgoc7H1cwHcPtXNIl9o8wFuPxsGaWdV2TCP0K0gqSRLRHDw+JW2EkkV4mauGSRI
         ggTg==
X-Gm-Message-State: ABy/qLax/EHOTNx5cTeqCjK585rOBvGvE0R7xqXY0o1S7BRHjqYrhXtP
        hZ7Ujw2rrU+9FifPwy5EGRBEnq1a3NG7WOyj9b3+rUJxyVKp
X-Google-Smtp-Source: APBJJlHlZeRsJhA1JwC+Vdmu+N9LIUtZDdY44VIw8JRBKBvwAYj1K34PoqnTCgPrj4fdOUK92lFjeE0YyPKsMBKChX5FPGXNgJdc
MIME-Version: 1.0
X-Received: by 2002:a05:6808:1a18:b0:3a7:2d4c:5d34 with SMTP id
 bk24-20020a0568081a1800b003a72d4c5d34mr1839695oib.8.1690727677890; Sun, 30
 Jul 2023 07:34:37 -0700 (PDT)
Date:   Sun, 30 Jul 2023 07:34:37 -0700
In-Reply-To: <0000000000003b7fee05eec392a8@google.com>
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <000000000000a7178a0601b5366f@google.com>
Subject: Re: [syzbot] [reiserfs?] [overlayfs?] BUG: unable to handle kernel
 paging request in take_dentry_name_snapshot
From:   syzbot <syzbot+90392eaed540afcc8fc3@syzkaller.appspotmail.com>
To:     amir73il@gmail.com, brauner@kernel.org,
        linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-unionfs@vger.kernel.org, miklos@szeredi.hu,
        reiserfs-devel@vger.kernel.org, syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-unionfs.vger.kernel.org>
X-Mailing-List: linux-unionfs@vger.kernel.org

syzbot suspects this issue was fixed by commit:

commit 1784fbc2ed9c888ea4e895f30a53207ed7ee8208
Author: Christian Brauner <brauner@kernel.org>
Date:   Fri Jun 16 12:53:58 2023 +0000

    ovl: port to new mount api

bisection log:  https://syzkaller.appspot.com/x/bisect.txt?x=12561bd9a80000
start commit:   8395ae05cb5a Merge tag 'scsi-misc' of git://git.kernel.org..
git tree:       upstream
kernel config:  https://syzkaller.appspot.com/x/.config?x=85327a149d5f50f
dashboard link: https://syzkaller.appspot.com/bug?extid=90392eaed540afcc8fc3
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=16199460480000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=1797f274480000

If the result looks correct, please mark the issue as fixed by replying with:

#syz fix: ovl: port to new mount api

For information about bisection process see: https://goo.gl/tpsmEJ#bisection
