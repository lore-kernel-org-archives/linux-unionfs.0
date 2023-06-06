Return-Path: <linux-unionfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 22927C77B73
	for <linux-unionfs@archiver.kernel.org>; Tue,  6 Jun 2023 10:05:22 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229507AbjFFKFU (ORCPT
        <rfc822;linux-unionfs@archiver.kernel.org>);
        Tue, 6 Jun 2023 06:05:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38154 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237634AbjFFKFM (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Tue, 6 Jun 2023 06:05:12 -0400
Received: from mail-ed1-x536.google.com (mail-ed1-x536.google.com [IPv6:2a00:1450:4864:20::536])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CF98AE7A
        for <linux-unionfs@vger.kernel.org>; Tue,  6 Jun 2023 03:05:10 -0700 (PDT)
Received: by mail-ed1-x536.google.com with SMTP id 4fb4d7f45d1cf-5149390b20aso8927472a12.3
        for <linux-unionfs@vger.kernel.org>; Tue, 06 Jun 2023 03:05:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=szeredi.hu; s=google; t=1686045909; x=1688637909;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=rnMujNjqe1l2Xq3EuAPc0/B+xPfCFxxwqOAJdqo6rxQ=;
        b=nMEHFFK9Rdv3z5BPfTqjdgzouAUlJnqVtRc4BmCdVPAtlFwoKBoMBLmBqdPZWIMUTq
         GdwA+j9/5xoxDx5CDYqmPTQlHkiuVwR0QH4nADhy1sE6RlEtqbFiCIEN39UD8pUiqEH+
         GIkgzP0S5tica754aiTdKaqCQ4O3fdtSUEJgc=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1686045909; x=1688637909;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=rnMujNjqe1l2Xq3EuAPc0/B+xPfCFxxwqOAJdqo6rxQ=;
        b=BXzzRuo2AFBJu1D6AdcjbNNLNPL+WFjRTW5hFtjCiO+8X6s0XtYqi7sneN7Sh92qdk
         Zl1R2MVMmGuq13tRFlALYKwv7dB9AF4wUDHrKSRxLgurfhsfnhzclse/IRec48xb8U6a
         TbiltRkIOha42zrV/r0rfx5fG9wpOfE6mopMBGwZ/UceGNgNSMClmEYAASSEUSTd2GVf
         3wyjgJHOD/1T40pjjimtvjs+bnESLr8zOlT7r5f96WUlesXxkMdNjZ+vgEFQRL8CZfQu
         +3exToZQXIyKbjgChsfKLXCD6X6ex7peoWXwoEgqGHDfJMwx2hRiDGivCttwEdBnTgF3
         YA/A==
X-Gm-Message-State: AC+VfDznjUxii0ewWKPL7LhabXEMXiXJvC6OIxrLkPQCg3oF30gKoEIc
        VrJJizM3wEN77FZfKYllSNMHFuIGU+Rz3zBIUlefIQ==
X-Google-Smtp-Source: ACHHUZ7ezEZLOJN4hkU6I45f7Eh6IZy9yJfrv0LLAb/WmqVy8pWJCt9YKFsK/unBKYH1os+oupopFWPyVnCxgeWFeqQ=
X-Received: by 2002:a17:907:9809:b0:96a:57fe:3bfb with SMTP id
 ji9-20020a170907980900b0096a57fe3bfbmr1858329ejc.26.1686045909356; Tue, 06
 Jun 2023 03:05:09 -0700 (PDT)
MIME-Version: 1.0
References: <0000000000001b987605f47b72d3@google.com>
In-Reply-To: <0000000000001b987605f47b72d3@google.com>
From:   Miklos Szeredi <miklos@szeredi.hu>
Date:   Tue, 6 Jun 2023 12:04:58 +0200
Message-ID: <CAJfpegtY5gpWnT9LqUeaL=QWWDtp9n=YCi9dBWu9cHxZ=7C9Og@mail.gmail.com>
Subject: Re: [syzbot] WARNING: locking bug in take_dentry_name_snapshot
To:     syzbot <syzbot+5a195884ee3ad761db4e@syzkaller.appspotmail.com>
Cc:     linux-kernel@vger.kernel.org, linux-unionfs@vger.kernel.org,
        syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-unionfs.vger.kernel.org>
X-Mailing-List: linux-unionfs@vger.kernel.org

#syz dup: BUG: unable to handle kernel paging request in
take_dentry_name_snapshot
