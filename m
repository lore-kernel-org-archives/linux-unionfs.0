Return-Path: <linux-unionfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 03EF0E7C4E2
	for <linux-unionfs@archiver.kernel.org>; Wed,  4 Oct 2023 16:45:43 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243453AbjJDQpo (ORCPT
        <rfc822;linux-unionfs@archiver.kernel.org>);
        Wed, 4 Oct 2023 12:45:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51684 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243471AbjJDQpn (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Wed, 4 Oct 2023 12:45:43 -0400
Received: from mail-oi1-f198.google.com (mail-oi1-f198.google.com [209.85.167.198])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 86C34C0
        for <linux-unionfs@vger.kernel.org>; Wed,  4 Oct 2023 09:45:38 -0700 (PDT)
Received: by mail-oi1-f198.google.com with SMTP id 5614622812f47-3af5b5d816aso57100b6e.3
        for <linux-unionfs@vger.kernel.org>; Wed, 04 Oct 2023 09:45:38 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1696437938; x=1697042738;
        h=to:from:subject:message-id:in-reply-to:date:mime-version
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=PxK2RXD2bOgzxh1BIYIHwF4FqtGpBF80iTPbZHI2mEs=;
        b=RrFWvi6UPp4ReYUDwg55oYmcWcjflsCEeYBU6WpkwEeWuwrCPNJZRnmRQR8Zc1hhBd
         BUtRZbMv4StLoOctsV0P90N2V8/MZo2x8kl4V6rrYyoiSm9Z+W4+8HsC85O1Oaf7+rZX
         rl4As7miT89uUsPbkkuj7LZCPxPMC4VQxilEstgGi3szmvemDlRqWAEt/8YOGB5TMtZE
         HjBMGSxIsYjb9Lhp6i3LNDQHEaw4wVbp6Q396Fcng+zrgrv//j0Z6piz3h2MMKdHf0VO
         KGmgPuT5MrwqwzqhIzfrGsBMXXdLjlLM+1qfBZ9k4jl4dKX/sozOtWEd2eASG86KUM3d
         xieQ==
X-Gm-Message-State: AOJu0YzmnoiJLZoxlK2cxdT8RKOdlRDRpZDmTPadJX6vWnkMTyynau/3
        A+nk9K0xDZXJacjml6kj7t8nhFl9kqxABiwt6ZwJPSRhiQoR
X-Google-Smtp-Source: AGHT+IH9LBqUAa3Czu2Ikd6so6wJCoEmqsI3B4Xy7BXDcw+NDdCsxu/Ij5v71RF5EfonX4kuJiuXe/Pq4wMLTbsrWqQGUZ97gxGX
MIME-Version: 1.0
X-Received: by 2002:a05:6808:f8e:b0:3ae:17ed:fdc9 with SMTP id
 o14-20020a0568080f8e00b003ae17edfdc9mr1421317oiw.9.1696437937945; Wed, 04 Oct
 2023 09:45:37 -0700 (PDT)
Date:   Wed, 04 Oct 2023 09:45:37 -0700
In-Reply-To: <00000000000067d24205c4d0e599@google.com>
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <000000000000accfd30606e6bcd0@google.com>
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

syzbot has bisected this issue to:

commit 708fa01597fa002599756bf56a96d0de1677375c
Author: Miklos Szeredi <mszeredi@redhat.com>
Date:   Mon Apr 12 10:00:37 2021 +0000

    ovl: allow upperdir inside lowerdir

bisection log:  https://syzkaller.appspot.com/x/bisect.txt?x=17ad11b2680000
start commit:   3aba70aed91f Merge tag 'gpio-fixes-for-v6.6-rc3' of git://..
git tree:       upstream
final oops:     https://syzkaller.appspot.com/x/report.txt?x=146d11b2680000
console output: https://syzkaller.appspot.com/x/log.txt?x=106d11b2680000
kernel config:  https://syzkaller.appspot.com/x/.config?x=e4ca82a1bedd37e4
dashboard link: https://syzkaller.appspot.com/bug?extid=b42fe626038981fb7bfa
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=1304fba6680000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=13cec0dc680000

Reported-by: syzbot+b42fe626038981fb7bfa@syzkaller.appspotmail.com
Fixes: 708fa01597fa ("ovl: allow upperdir inside lowerdir")

For information about bisection process see: https://goo.gl/tpsmEJ#bisection
