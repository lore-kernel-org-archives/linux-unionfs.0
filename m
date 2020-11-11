Return-Path: <linux-unionfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.4 required=3.0 tests=BAYES_00,DKIMWL_WL_MED,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_IN_DEF_DKIM_WL autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5540FC388F9
	for <linux-unionfs@archiver.kernel.org>; Wed, 11 Nov 2020 13:52:27 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id E33E72072C
	for <linux-unionfs@archiver.kernel.org>; Wed, 11 Nov 2020 13:52:26 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="ruYOIkEm"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727087AbgKKNwS (ORCPT
        <rfc822;linux-unionfs@archiver.kernel.org>);
        Wed, 11 Nov 2020 08:52:18 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56830 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726983AbgKKNwR (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Wed, 11 Nov 2020 08:52:17 -0500
Received: from mail-qk1-x743.google.com (mail-qk1-x743.google.com [IPv6:2607:f8b0:4864:20::743])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 928C7C0613D6
        for <linux-unionfs@vger.kernel.org>; Wed, 11 Nov 2020 05:52:17 -0800 (PST)
Received: by mail-qk1-x743.google.com with SMTP id n132so1680592qke.1
        for <linux-unionfs@vger.kernel.org>; Wed, 11 Nov 2020 05:52:17 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=m80oT1JfZEh7w9pLk5CWjzhWzy3pvKhfVuBt46eLCBw=;
        b=ruYOIkEm/5N7tXFU9wnoobpSSwg6ScTTQcUGJl4xQvztJCtpHPICTHlzj52Ws0uUn0
         DC39qewbtysvAam0v/xotz7/Fo/BfTQtsNPVxofXvrtftF0tCiNaYDfUIgL3/+AImpV1
         d2QoUb5xBzp/rwuCfttZ1GNLH5ro9M7FyxelmSHEwvahc7zT9p5tAxaEydOUjI0ph3VL
         /U7adurRdeyE1Nz9Hum4FnJP49bOIH+1/UOVEfJWELAu3VkFK67PQwJLNCNtudVqXgXE
         /WgORiHN6IFJ1Gn4SY8n+rWQxkD1FtqPdzf9LeAJ8ymLniGa0IATUJb22l/Mq1lULOUt
         G0Rw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=m80oT1JfZEh7w9pLk5CWjzhWzy3pvKhfVuBt46eLCBw=;
        b=gawj4vO6/s5/xZlHPMqurSmTOja+Mf3N7iMNONf58ZRDapxTwQ6VAJ+E7Kqux1SU9k
         2qrLSxNwc0SDLfdsqJd7b6MfJ8uyyT3zkN6+/p5JnC3Age2z1KgR4O1adPH1XY5LJrGi
         pA9tjVrxi1T4bn9Xw9kGOCy1tgvGuizhZNNyGYt/3gZA2rDfZZUHTWy2spZvJgRdcVuq
         mmALL1nU/g6LpPPRnMz+raS6T0DXd88NScVij/Io02i8PJaa3BPLC8a6EZeTkuWl0+ov
         +7vid0aVx1BUz/enRl8zV8tee/SK3dY1yfctDyOZAT4S3vyh1xFa8MzFhtQGK2FY3Bjm
         yhVQ==
X-Gm-Message-State: AOAM532aw4UAkOgdsOOV2CO7tTWnpEK7exCAgigUH9ldQsmmd6gDAidO
        Y1hN2dt9gmhTyWXAWNF0U0z0R9bm8hBmdTZroRs6dA==
X-Google-Smtp-Source: ABdhPJyqhSwQAMi7KabE5H8i99YpFBEAgyBaMgInJ4zyZ3IFflyUyoUrw58EdIQt6hUjGikYX6RbliJBfZjpbkt8VXQ=
X-Received: by 2002:a37:49d6:: with SMTP id w205mr25091516qka.501.1605102736439;
 Wed, 11 Nov 2020 05:52:16 -0800 (PST)
MIME-Version: 1.0
References: <000000000000d03eea0571adfe83@google.com> <000000000000ad052105b383350a@google.com>
In-Reply-To: <000000000000ad052105b383350a@google.com>
From:   Dmitry Vyukov <dvyukov@google.com>
Date:   Wed, 11 Nov 2020 14:52:05 +0100
Message-ID: <CACT4Y+Z=WF1jbjjSX0hWSJXqUpNGJgwW=f2tBFkJH=mSjyMqag@mail.gmail.com>
Subject: Re: possible deadlock in mnt_want_write
To:     syzbot <syzbot+ae82084b07d0297e566b@syzkaller.appspotmail.com>,
        LKML <linux-kernel@vger.kernel.org>,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>,
        overlayfs <linux-unionfs@vger.kernel.org>,
        syzkaller-bugs <syzkaller-bugs@googlegroups.com>
Cc:     Amir Goldstein <amir73il@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-unionfs.vger.kernel.org>
X-Mailing-List: linux-unionfs@vger.kernel.org

On Sat, Nov 7, 2020 at 1:10 PM syzbot
<syzbot+ae82084b07d0297e566b@syzkaller.appspotmail.com> wrote:
>
> syzbot suspects this issue was fixed by commit:
>
> commit 146d62e5a5867fbf84490d82455718bfb10fe824
> Author: Amir Goldstein <amir73il@gmail.com>
> Date:   Thu Apr 18 14:42:08 2019 +0000
>
>     ovl: detect overlapping layers
>
> bisection log:  https://syzkaller.appspot.com/x/bisect.txt?x=11e40184500000
> start commit:   6d906f99 Merge tag 'arm64-fixes' of git://git.kernel.org/p..
> git tree:       upstream
> kernel config:  https://syzkaller.appspot.com/x/.config?x=856fc6d0fbbeede9
> dashboard link: https://syzkaller.appspot.com/bug?extid=ae82084b07d0297e566b
> syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=111767b7200000
> C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=1611ab2d200000
>
> If the result looks correct, please mark the issue as fixed by replying with:
>
> #syz fix: ovl: detect overlapping layers
>
> For information about bisection process see: https://goo.gl/tpsmEJ#bisection

#syz fix: ovl: detect overlapping layers
