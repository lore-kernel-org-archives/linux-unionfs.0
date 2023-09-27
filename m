Return-Path: <linux-unionfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B1ABAE82CA6
	for <linux-unionfs@archiver.kernel.org>; Wed, 27 Sep 2023 15:10:27 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232332AbjI0PK1 (ORCPT
        <rfc822;linux-unionfs@archiver.kernel.org>);
        Wed, 27 Sep 2023 11:10:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50148 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232294AbjI0PK0 (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Wed, 27 Sep 2023 11:10:26 -0400
Received: from mail-ot1-f70.google.com (mail-ot1-f70.google.com [209.85.210.70])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8A26112A
        for <linux-unionfs@vger.kernel.org>; Wed, 27 Sep 2023 08:10:23 -0700 (PDT)
Received: by mail-ot1-f70.google.com with SMTP id 46e09a7af769-6c0d445555eso24481151a34.0
        for <linux-unionfs@vger.kernel.org>; Wed, 27 Sep 2023 08:10:23 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1695827423; x=1696432223;
        h=to:from:subject:message-id:in-reply-to:date:mime-version
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=y6qE2XlTa4u4RBDlvYz/Aw+cZGD4Gks8ccLO/qfOPBU=;
        b=IkYonLN64yTsxI/aHP04Rc177Y3N+ZFuGrs+GQEh5aDLi5vqcEDStjSVGGeoLvkYW1
         2X7wWAZtC6GpCNntrPpY710Jbe2B2RJm89PYTeDtK3X/sNIYPUxbed3/xdMoTm0KvAxY
         6YZEgk9Ai1rceIzVyp44yea0joJiK0jT+GlifUwpeFlTNvhnpbZhiVxp+GgLk+RVXppD
         gc8m2/3EaaugYvUCc8+8Pq6pms/Of/6MlCfahWHPly0PRmjaU+8MRF2b+SEQ19vUftIz
         XnYB3CvGy45CL7tomw5r76+X4U35TCxIOCrShR3aaldaCmP5NgQh5lIGeQSXyVo7e+MF
         WVJw==
X-Gm-Message-State: AOJu0YyWsJgKZRnBT5VOArw0m1gHOUODbNYentxKPssSzOFS8iX0NQ5E
        9qwTJg2xFfJZ0nVqvuOTH8Si2gQFZ+fmXVFuudogdvNmseS1
X-Google-Smtp-Source: AGHT+IEFVwYkF4pSZdjsYdqAD/xZB6kBdzYdkZYFLAG3QuG2GXvs6P/b93hLjfBc2ENBC9VtkK0vGxM/1mdAklvW/skrsm/5zsau
MIME-Version: 1.0
X-Received: by 2002:a05:6870:c342:b0:1d5:a24a:c33 with SMTP id
 e2-20020a056870c34200b001d5a24a0c33mr861602oak.8.1695827422969; Wed, 27 Sep
 2023 08:10:22 -0700 (PDT)
Date:   Wed, 27 Sep 2023 08:10:22 -0700
In-Reply-To: <CAOQ4uxjssgw1tZrUQvtHHVacSgR9NE0yF8DA3+R5LNFAocCvVQ@mail.gmail.com>
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <000000000000258ac60606589787@google.com>
Subject: Re: [syzbot] [overlayfs?] KASAN: invalid-free in ovl_copy_up_one
From:   syzbot <syzbot+477d8d8901756d1cbba1@syzkaller.appspotmail.com>
To:     amir73il@gmail.com, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-unionfs@vger.kernel.org,
        miklos@szeredi.hu, syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-unionfs.vger.kernel.org>
X-Mailing-List: linux-unionfs@vger.kernel.org

Hello,

syzbot has tested the proposed patch and the reproducer did not trigger any issue:

Reported-and-tested-by: syzbot+477d8d8901756d1cbba1@syzkaller.appspotmail.com

Tested on:

commit:         8e9b46c4 ovl: do not encode lower fh with upper sb_wri..
git tree:       https://github.com/amir73il/linux.git ovl_want_write
console output: https://syzkaller.appspot.com/x/log.txt?x=10d10ffa680000
kernel config:  https://syzkaller.appspot.com/x/.config?x=bb54ecdfa197f132
dashboard link: https://syzkaller.appspot.com/bug?extid=477d8d8901756d1cbba1
compiler:       gcc (Debian 12.2.0-14) 12.2.0, GNU ld (GNU Binutils for Debian) 2.40

Note: no patches were applied.
Note: testing is done by a robot and is best-effort only.
