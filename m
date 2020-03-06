Return-Path: <SRS0=MwdX=4X=vger.kernel.org=linux-unionfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.4 required=3.0 tests=FROM_LOCAL_HEX,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,
	SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8B96EC10DCE
	for <linux-unionfs@archiver.kernel.org>; Fri,  6 Mar 2020 22:35:03 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 5CFB9206E6
	for <linux-unionfs@archiver.kernel.org>; Fri,  6 Mar 2020 22:35:03 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726397AbgCFWfD (ORCPT
        <rfc822;linux-unionfs@archiver.kernel.org>);
        Fri, 6 Mar 2020 17:35:03 -0500
Received: from mail-io1-f69.google.com ([209.85.166.69]:42042 "EHLO
        mail-io1-f69.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726194AbgCFWfD (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Fri, 6 Mar 2020 17:35:03 -0500
Received: by mail-io1-f69.google.com with SMTP id v23so2475376iob.9
        for <linux-unionfs@vger.kernel.org>; Fri, 06 Mar 2020 14:35:02 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:date:in-reply-to:message-id:subject
         :from:to;
        bh=KjWtQPcKIxIvEZPVuieJJ01SWtPnm/mBaTh4nN8Yq4A=;
        b=a9TlAYpGaPKxqh3Qxch/MUaGFSNJXObjrErJgzRdayLepVjSKxYRjUtfemMQ1i/7uU
         jNKdjpI467ipCeh0+mAbSGdPlNJ9MpG5yV52vmWAB/rtQV1oNSgyGdpQClVhkV45/nfV
         uh3nSBEEY8149eeG68JnjuG+lx8h07PZKx/+AZ90v9oADOVgYcdlzqFDbqi2X7j6uSHr
         JGO3NosF50W7XlRPgc3CUZnVd9732BU6TSYOa9JP8I3NS3+lYQ7IUZflq+/FzWTcdA+7
         8L78MYcGwv4rqvvVpbZ35dPC+0Xyi29KNjvc4eU/KGQUoa/9EXOqZ6BXoU3k5zqltJSr
         Womg==
X-Gm-Message-State: ANhLgQ3vkLXuB4W6mln4DJylSNXx4Dkoe8Nd9zolWPDvMEr4dmOzIwgj
        Ypc3c2JV+zhcw15hcVUmQ0Yarzf98ff3ODYTjFRNYaK8N2Uf
X-Google-Smtp-Source: ADFU+vs7TshTiXpJBBMMnK/klWxSkYQHop7Wk8LLzdT9LXsKtgaTBMKEykjWuXsgmj46xLIUaiFxMyYWPjhUHv97DMUt54UvAjhF
MIME-Version: 1.0
X-Received: by 2002:a6b:5a06:: with SMTP id o6mr4907893iob.54.1583534102612;
 Fri, 06 Mar 2020 14:35:02 -0800 (PST)
Date:   Fri, 06 Mar 2020 14:35:02 -0800
In-Reply-To: <CAOQ4uxirc1WwQOzE4Qq=k2R0ntGNTGYsot1b63DPkwCbUYjyZA@mail.gmail.com>
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <000000000000ad0f2c05a0374382@google.com>
Subject: Re: WARNING: bad unlock balance in ovl_llseek
From:   syzbot <syzbot+66a9752fa927f745385e@syzkaller.appspotmail.com>
To:     amir73il@gmail.com, dvyukov@google.com,
        linux-kernel@vger.kernel.org, linux-unionfs@vger.kernel.org,
        miklos@szeredi.hu, mszeredi@redhat.com,
        syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"
Sender: linux-unionfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-unionfs.vger.kernel.org>
X-Mailing-List: linux-unionfs@vger.kernel.org

Hello,

syzbot has tested the proposed patch and the reproducer did not trigger crash:

Reported-and-tested-by: syzbot+66a9752fa927f745385e@syzkaller.appspotmail.com

Tested on:

commit:         13944050 ovl: fix lock in ovl_llseek()
git tree:       https://github.com/amir73il/linux.git ovl-fixes
kernel config:  https://syzkaller.appspot.com/x/.config?x=31018567b8f0fc70
dashboard link: https://syzkaller.appspot.com/bug?extid=66a9752fa927f745385e
compiler:       gcc (GCC) 9.0.0 20181231 (experimental)

Note: testing is done by a robot and is best-effort only.
