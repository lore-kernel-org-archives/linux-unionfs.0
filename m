Return-Path: <SRS0=AhPS=5A=vger.kernel.org=linux-unionfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.4 required=3.0 tests=FROM_LOCAL_HEX,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1894FC10DCE
	for <linux-unionfs@archiver.kernel.org>; Sun, 15 Mar 2020 16:19:05 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id E9D9420637
	for <linux-unionfs@archiver.kernel.org>; Sun, 15 Mar 2020 16:19:04 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728900AbgCOQTE (ORCPT
        <rfc822;linux-unionfs@archiver.kernel.org>);
        Sun, 15 Mar 2020 12:19:04 -0400
Received: from mail-io1-f70.google.com ([209.85.166.70]:44448 "EHLO
        mail-io1-f70.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728898AbgCOQTE (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Sun, 15 Mar 2020 12:19:04 -0400
Received: by mail-io1-f70.google.com with SMTP id q13so10087125iob.11
        for <linux-unionfs@vger.kernel.org>; Sun, 15 Mar 2020 09:19:03 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:date:in-reply-to:message-id:subject
         :from:to;
        bh=aBVpr2lszHHXRhoIRtyr/UgZ7zigQ1Re4Bzqf5rEmB8=;
        b=ZNlJwprYDhNiPWWTx7Y39kZ5L8tgroOQlNn4ueATSlKLjO/lZjc+5gREr1ikP3PDbe
         nPye9dqW15AmhaTSCnoxZmiqRci43Fk1jHDz3D66Vd2qq3hknhVEQKalVXdPb8sStTMM
         CvpFrd1LvNdfOKgkn9Oc6JJSaR87kISFeW0POd92Fvb6A93i7JTRXns32uQLMabRK+mO
         EYmxE537K0I7t4ONpmumczS1l72KSFsD2GvorKmD8eRyNL1DdTnWOj/EECJab9hS5qtn
         KtB8vNghPC4QKwIslnaqM519fBFyQTeneTsOk3e1fy7j7okZl/e6Q+dix95V18LoLjxl
         vNIA==
X-Gm-Message-State: ANhLgQ2c/8ty8yzEZgX1s86UBI3bufpPgTh0bJaPXzVRxJfCWb1wp7/f
        m4bilvw2JhjBxu9Ax9Ams18ZGtlEXLbmyrEi6iBfxplvKpwN
X-Google-Smtp-Source: ADFU+vvEpKjTJKXQNX4cXiEk/M0vqZw0uACkxtFRoJsmPwDzy61qIqim7f8/xuwV9rHXdGAII/j6tBy3274dpYif2g5SMTDAgQSk
MIME-Version: 1.0
X-Received: by 2002:a92:3b11:: with SMTP id i17mr18499810ila.161.1584289143334;
 Sun, 15 Mar 2020 09:19:03 -0700 (PDT)
Date:   Sun, 15 Mar 2020 09:19:03 -0700
In-Reply-To: <000000000000fb27f1059aa202ea@google.com>
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <0000000000009c33d905a0e70f63@google.com>
Subject: Re: possible deadlock in pipe_lock (3)
From:   syzbot <syzbot+217d60b447573313b211@syzkaller.appspotmail.com>
To:     jencce.kernel@gmail.com, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-unionfs@vger.kernel.org,
        miklos@szeredi.hu, mszeredi@redhat.com,
        syzkaller-bugs@googlegroups.com, viro@zeniv.linux.org.uk
Content-Type: text/plain; charset="UTF-8"
Sender: linux-unionfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-unionfs.vger.kernel.org>
X-Mailing-List: linux-unionfs@vger.kernel.org

syzbot suspects this bug was fixed by commit:

commit 1a980b8cbf0059a5308eea61522f232fd03002e2
Author: Murphy Zhou <jencce.kernel@gmail.com>
Date:   Fri Jan 17 12:49:29 2020 +0000

    ovl: add splice file read write helper

bisection log:  https://syzkaller.appspot.com/x/bisect.txt?x=12dd7dc3e00000
start commit:   46cf053e Linux 5.5-rc3
git tree:       upstream
kernel config:  https://syzkaller.appspot.com/x/.config?x=ed9d672709340e35
dashboard link: https://syzkaller.appspot.com/bug?extid=217d60b447573313b211
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=116496c1e00000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=10104649e00000

If the result looks correct, please mark the bug fixed by replying with:

#syz fix: ovl: add splice file read write helper

For information about bisection process see: https://goo.gl/tpsmEJ#bisection
