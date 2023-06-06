Return-Path: <linux-unionfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B7D06C7EE2C
	for <linux-unionfs@archiver.kernel.org>; Tue,  6 Jun 2023 10:05:22 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232547AbjFFKFV (ORCPT
        <rfc822;linux-unionfs@archiver.kernel.org>);
        Tue, 6 Jun 2023 06:05:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38194 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237630AbjFFKFL (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Tue, 6 Jun 2023 06:05:11 -0400
Received: from mail-io1-f72.google.com (mail-io1-f72.google.com [209.85.166.72])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7F036E78
        for <linux-unionfs@vger.kernel.org>; Tue,  6 Jun 2023 03:05:10 -0700 (PDT)
Received: by mail-io1-f72.google.com with SMTP id ca18e2360f4ac-76ce93a10f3so380219139f.0
        for <linux-unionfs@vger.kernel.org>; Tue, 06 Jun 2023 03:05:10 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1686045910; x=1688637910;
        h=cc:to:from:subject:message-id:in-reply-to:date:mime-version
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=7UkhkPWN4vtdwEgDSbXtWkYaQGXdhTwsGfVwAerMvqU=;
        b=de+Wb1Xo4X0l4vPEimvQ7DfvT4MwceBXTza/XWhIoxDBgL7kK0mxX3wVD2OwhKXri/
         M2MN2I0ZK1NvrILYgQnkq/SbuVu3w9KTTC0Di7X0eAHawh8ulFVR6OXvNnCab4Dt4fjH
         9ExD1WJTN/jcio8lZurLd5ySSMtaj98mjEmBEMZRW5dbD38U9c5dYWsdQtBm/jlYKPY4
         HDaebRPdrV1iJGnNoag1C9oC+K5djqJqDu5ACYZINFavsz/F57J+h6xv5gW9HJKUin6O
         ne9PD3H0MoPT9NzdTe0BhTcedoFkCbivn4UrSm2Hm1ZFaGeF2vTSwBdl2k6MUZFNCqlc
         9iHw==
X-Gm-Message-State: AC+VfDxS24/CxSSrwLERN2DOAJWbVw5bwGRFDNg3tn0o6+9oLuTtSbmK
        8S92+aPoleApxjdeMOoQA9sV+muVRq0awYPWSOwShaOgEaCN
X-Google-Smtp-Source: ACHHUZ5XcFcHS+R2q5jms9GgOuXY8+wwBs8QTwllngSwldtC94cHSzKdy7YXUkvMkpkBQucIYvtsXVx1MFlI7PrN2OQqOo1LizqN
MIME-Version: 1.0
X-Received: by 2002:a02:9663:0:b0:40f:9ab9:c438 with SMTP id
 c90-20020a029663000000b0040f9ab9c438mr651395jai.3.1686045909882; Tue, 06 Jun
 2023 03:05:09 -0700 (PDT)
Date:   Tue, 06 Jun 2023 03:05:09 -0700
In-Reply-To: <CAJfpegtY5gpWnT9LqUeaL=QWWDtp9n=YCi9dBWu9cHxZ=7C9Og@mail.gmail.com>
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <00000000000088a1c505fd732771@google.com>
Subject: Re: [syzbot] WARNING: locking bug in take_dentry_name_snapshot
From:   syzbot <syzbot+5a195884ee3ad761db4e@syzkaller.appspotmail.com>
To:     miklos@szeredi.hu
Cc:     linux-kernel@vger.kernel.org, linux-unionfs@vger.kernel.org,
        miklos@szeredi.hu, syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-unionfs.vger.kernel.org>
X-Mailing-List: linux-unionfs@vger.kernel.org

> #syz dup: BUG: unable to handle kernel paging request in

can't find the dup bug

> take_dentry_name_snapshot
