Return-Path: <linux-unionfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D6164C7EE2F
	for <linux-unionfs@archiver.kernel.org>; Tue,  6 Jun 2023 09:12:53 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233658AbjFFJMw (ORCPT
        <rfc822;linux-unionfs@archiver.kernel.org>);
        Tue, 6 Jun 2023 05:12:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54870 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235675AbjFFJMr (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Tue, 6 Jun 2023 05:12:47 -0400
Received: from mail-io1-f72.google.com (mail-io1-f72.google.com [209.85.166.72])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 04DCE10C8
        for <linux-unionfs@vger.kernel.org>; Tue,  6 Jun 2023 02:12:37 -0700 (PDT)
Received: by mail-io1-f72.google.com with SMTP id ca18e2360f4ac-7776b76cc59so499511639f.2
        for <linux-unionfs@vger.kernel.org>; Tue, 06 Jun 2023 02:12:36 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1686042756; x=1688634756;
        h=cc:to:from:subject:message-id:in-reply-to:date:mime-version
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=cKjEJ+NhJxp2P/83FzouzrqL0ri1MzUuYoHzC3XIwgQ=;
        b=e39FKqs7sdYNNNpLq0sbB91cZ8cl+fi346RNPczoJZWVJ0D1g7XnY2cgBVP3Vq4DfY
         uSNLfkieJCLRh6sKt4gjFWhl3c/WtJslC2RfzT7Mg2OxR+oZT6gt1obdcT+UVNMo+Pkl
         hQof6qM+7ZnZ3tPLDPkRJvTmxvBYbyvWLH1uRieH2rK8Vy6Clf81TGHcXjGtK+g4rEtZ
         aQtaeVGFMSVxyccG585ENputw9/3uzU+ijxpc6VFCWGqf9DJY0Gi57urNNMB1q2eM4qv
         SdWPr2plIDTKpxRg7ZIFC+Ubv8cF5GFsqbqgehO1rP5XQeJCjSL9MB3ALSEhJpogchfS
         N6EA==
X-Gm-Message-State: AC+VfDzvIbdwu8cFHYtqRE+j5h6qEo21xeUgGSxuVWslFuurbhwNacWE
        SZm6vfUJlySapBCvd8AW6eh5K6NM7fK+YPppalmwqGhARNeh
X-Google-Smtp-Source: ACHHUZ4hPLNKpE1IYP8UTPjo59Z0ZEP2JEaW0grC8Ojb0fa/yI50EDSv8JRCXB1vPNR0sMhFHlh+lv1sqSuhYH9RxbYGnWQNiPFz
MIME-Version: 1.0
X-Received: by 2002:a02:b0c6:0:b0:41c:feac:7a9c with SMTP id
 w6-20020a02b0c6000000b0041cfeac7a9cmr587850jah.6.1686042756304; Tue, 06 Jun
 2023 02:12:36 -0700 (PDT)
Date:   Tue, 06 Jun 2023 02:12:36 -0700
In-Reply-To: <CAJfpegtzZnzW506AHyw_5Bqn-thhrd3-_t-qJ5OJBzP-z3O6Fg@mail.gmail.com>
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <00000000000090dbc405fd726b57@google.com>
Subject: Re: [syzbot] possible deadlock in mnt_want_write (2)
From:   syzbot <syzbot+b42fe626038981fb7bfa@syzkaller.appspotmail.com>
To:     miklos@szeredi.hu
Cc:     linux-integrity@vger.kernel.org, linux-unionfs@vger.kernel.org,
        miklos@szeredi.hu, syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-unionfs.vger.kernel.org>
X-Mailing-List: linux-unionfs@vger.kernel.org

> #syz set subsystems: intergrity, overlayfs

The specified label value is incorrect.
"intergrity" is not among the allowed values.
Please use one of the supported label values.

The following labels are suported:
missing-backport, no-reminders, prio: {low, normal, high}, subsystems: {.. see below ..}
The list of subsystems: https://syzkaller.appspot.com/upstream/subsystems?all=true

