Return-Path: <linux-unionfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 56414CD13CF
	for <linux-unionfs@archiver.kernel.org>; Mon, 18 Sep 2023 00:05:31 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232187AbjIRAFD (ORCPT
        <rfc822;linux-unionfs@archiver.kernel.org>);
        Sun, 17 Sep 2023 20:05:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44876 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231518AbjIRAEm (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Sun, 17 Sep 2023 20:04:42 -0400
Received: from mail-oa1-f72.google.com (mail-oa1-f72.google.com [209.85.160.72])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 93938126
        for <linux-unionfs@vger.kernel.org>; Sun, 17 Sep 2023 17:04:37 -0700 (PDT)
Received: by mail-oa1-f72.google.com with SMTP id 586e51a60fabf-1d66d948417so4135719fac.3
        for <linux-unionfs@vger.kernel.org>; Sun, 17 Sep 2023 17:04:37 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1694995474; x=1695600274;
        h=to:from:subject:message-id:in-reply-to:date:mime-version
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=plqiVhsHQJW/q4sf5YkInYlIVvS0lexxFRBvtsJXFDw=;
        b=Qad2CMOLHh3RAyAZTIssY+HiPEKkbt/w6nUGbQSjhjFEo8n30yc0HsdXOFRIBwwaGp
         LZxNl0uZ5Msut6pquWNswfXTEE/my9cSTrtU4QqsksH6+fUBPWCWEE5erwzWRCV82XBa
         mRW9MhPSjmryj9eysbVuKR+CCUcLaMJMxOkaxcvsefepPhIn5aVpiNZ4VC/DzxpHqB9U
         bXKrif2C0ZDNP7d8GCNGNwoTauZZD1bsJxFT+3RDfFIyle3txTEhxlp8z12837eOEIYU
         53V1+zK4oSkjFTG7UoZhb10iEnsKqNNi+5enX+ZlFaXs55SRQ4H/xMgXHRbFS3W7BzYL
         6JEw==
X-Gm-Message-State: AOJu0YzMCX6rBU6AJIn6+4lt2T80StCAQ6R62+wi3vHOuN5yoH/cmVqi
        rQEjs2ZSZX9JKeua2ZbZk1teK3RMrWrqZlZTnGhQ1cb3UQ0S
X-Google-Smtp-Source: AGHT+IH/zkGlEDq9VbJg97gGt1EgLfqWnEVJ7h5xnIpv8Ku68gE0DF1eHR9jFI017KdKqlc7/TMCj9QpD4KDhKZQUzCLionLJESV
MIME-Version: 1.0
X-Received: by 2002:a05:6870:b7ad:b0:1d5:95fc:2a7f with SMTP id
 ed45-20020a056870b7ad00b001d595fc2a7fmr2748642oab.7.1694995474388; Sun, 17
 Sep 2023 17:04:34 -0700 (PDT)
Date:   Sun, 17 Sep 2023 17:04:34 -0700
In-Reply-To: <0000000000004f34d705ffbc2604@google.com>
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <000000000000259bd8060596e33f@google.com>
Subject: Re: [syzbot] [integrity] [overlayfs] general protection fault in d_path
From:   syzbot <syzbot+a67fc5321ffb4b311c98@syzkaller.appspotmail.com>
To:     amir73il@gmail.com, brauner@kernel.org, jlayton@kernel.org,
        linux-fsdevel@vger.kernel.org, linux-integrity@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-unionfs@vger.kernel.org,
        miklos@szeredi.hu, stefanb@linux.ibm.com,
        syzkaller-bugs@googlegroups.com, zohar@linux.ibm.com
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-unionfs.vger.kernel.org>
X-Mailing-List: linux-unionfs@vger.kernel.org

syzbot has bisected this issue to:

commit db1d1e8b9867aae5c3e61ad7859abfcc4a6fd6c7
Author: Jeff Layton <jlayton@kernel.org>
Date:   Mon Apr 17 16:55:51 2023 +0000

    IMA: use vfs_getattr_nosec to get the i_version

bisection log:  https://syzkaller.appspot.com/x/bisect.txt?x=106f7e54680000
start commit:   a747acc0b752 Merge tag 'linux-kselftest-next-6.6-rc2' of g..
git tree:       upstream
final oops:     https://syzkaller.appspot.com/x/report.txt?x=126f7e54680000
console output: https://syzkaller.appspot.com/x/log.txt?x=146f7e54680000
kernel config:  https://syzkaller.appspot.com/x/.config?x=df91a3034fe3f122
dashboard link: https://syzkaller.appspot.com/bug?extid=a67fc5321ffb4b311c98
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=1671b694680000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=14ec94d8680000

Reported-by: syzbot+a67fc5321ffb4b311c98@syzkaller.appspotmail.com
Fixes: db1d1e8b9867 ("IMA: use vfs_getattr_nosec to get the i_version")

For information about bisection process see: https://goo.gl/tpsmEJ#bisection
