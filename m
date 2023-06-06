Return-Path: <linux-unionfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 14CEDC7EE2F
	for <linux-unionfs@archiver.kernel.org>; Tue,  6 Jun 2023 09:22:33 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237425AbjFFJWc (ORCPT
        <rfc822;linux-unionfs@archiver.kernel.org>);
        Tue, 6 Jun 2023 05:22:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35216 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237420AbjFFJW3 (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Tue, 6 Jun 2023 05:22:29 -0400
Received: from mail-ed1-x531.google.com (mail-ed1-x531.google.com [IPv6:2a00:1450:4864:20::531])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 96BE2E51
        for <linux-unionfs@vger.kernel.org>; Tue,  6 Jun 2023 02:22:26 -0700 (PDT)
Received: by mail-ed1-x531.google.com with SMTP id 4fb4d7f45d1cf-5147f5efeb5so8894141a12.0
        for <linux-unionfs@vger.kernel.org>; Tue, 06 Jun 2023 02:22:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=szeredi.hu; s=google; t=1686043345; x=1688635345;
        h=cc:to:subject:message-id:date:from:mime-version:from:to:cc:subject
         :date:message-id:reply-to;
        bh=A2ESXYQhltyj7fjwwg8HklYOExEwSWjFcjtOKFaoW/Y=;
        b=Kpo9vPuy/MsTRfwwvxVa59D9vXquTWupJ6pHAucRUU5vzwo95I+Ti8nOJC5L2VPMR8
         yC4OMHZ6jZVdZpJUOwNjIB1msEXiR2X5qI0A3RbptKORkaZN4mj6zXINim0FGS5W9jFh
         x8d+LXORwPjRUDoC8kU5zdXkKKQ3sPFcRWmP0=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1686043345; x=1688635345;
        h=cc:to:subject:message-id:date:from:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=A2ESXYQhltyj7fjwwg8HklYOExEwSWjFcjtOKFaoW/Y=;
        b=hzcRewF8aT+PtWGOMFr47ewUoAfrD30tQKpqHuY8j0o6D4VMm7gaaMmavHkAhpzTgQ
         8unHNkdNpAQ8KYWRI4FPTxuQzbPT4GBjnxrbBj6xrmtPKhM12TLDgIvaF6ZWNc4hLz4K
         580NtZc0vIlaHTPLpUpO5IbXGcnUC8KPWGH9kE0znaxvMZ6Hw8GZci2NOqiEilJlQ2Of
         RUJa3iM5HcdjD56fpGtByZZ6f+LivKRfZdUcllbF4KP+IK115RztOg9UvoK1reNO40pi
         niWgQIb4YC5SC+oGDEt1lBqHijbBVy7EBomC73oPnj+2eHpnh29bJOBF7sP4jPnr3/J0
         tszg==
X-Gm-Message-State: AC+VfDyNhHcouXATKsHetVEBtwjL1n8PX6xbOECo5S8RVYQWTVCuFbA9
        Zt2/Pn7Aa4QYc9A8uU01y64SfREo/fuzDO9rX4MkZs9fqZ8TN/R3Pus=
X-Google-Smtp-Source: ACHHUZ5BbL+fkVjUDRt/CLDWeUDkrLxoMh0slW44uxEA/AoGJbJQoxFpILPG7FR44riSIZdNkYsgQvpSOiv6GwiNCww=
X-Received: by 2002:a17:907:7baa:b0:96a:30b5:cfb0 with SMTP id
 ne42-20020a1709077baa00b0096a30b5cfb0mr1987499ejc.22.1686043345046; Tue, 06
 Jun 2023 02:22:25 -0700 (PDT)
MIME-Version: 1.0
From:   Miklos Szeredi <miklos@szeredi.hu>
Date:   Tue, 6 Jun 2023 11:22:14 +0200
Message-ID: <CAJfpegsoe_2fiFB9fw3wCtaMj6qQqB-8Xi801ZB9Ye9_gYrJpQ@mail.gmail.com>
Subject: Re: possible deadlock in process_measurement (2)
To:     syzbot <syzbot+18a1619cceea30ed45af@syzkaller.appspotmail.com>,
        syzkaller-bugs <syzkaller-bugs@googlegroups.com>
Cc:     linux-integrity <linux-integrity@vger.kernel.org>,
        overlayfs <linux-unionfs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-unionfs.vger.kernel.org>
X-Mailing-List: linux-unionfs@vger.kernel.org

AFAICS, this is a duplicate.

#syz dup: possible deadlock in mnt_want_write (2)
