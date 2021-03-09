Return-Path: <linux-unionfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2E11BC433E0
	for <linux-unionfs@archiver.kernel.org>; Tue,  9 Mar 2021 19:25:18 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id F07B464F6C
	for <linux-unionfs@archiver.kernel.org>; Tue,  9 Mar 2021 19:25:17 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231352AbhCITYo (ORCPT
        <rfc822;linux-unionfs@archiver.kernel.org>);
        Tue, 9 Mar 2021 14:24:44 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38050 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231270AbhCITYW (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Tue, 9 Mar 2021 14:24:22 -0500
Received: from mail-io1-xd33.google.com (mail-io1-xd33.google.com [IPv6:2607:f8b0:4864:20::d33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CD956C06174A
        for <linux-unionfs@vger.kernel.org>; Tue,  9 Mar 2021 11:24:21 -0800 (PST)
Received: by mail-io1-xd33.google.com with SMTP id g27so15210883iox.2
        for <linux-unionfs@vger.kernel.org>; Tue, 09 Mar 2021 11:24:21 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=k4yWikI/qo+a2LIVOQ1+zIgAMyjaP6HpzLqITF/urmE=;
        b=uIKzag1jPTRyeB29VC1m/UlbObdQrn8BF5OGJOG1akWoDqo2eLP+UMH7X30mqOKcIm
         Ng5/bvHCctZFYJMquyKsJAMqrbFY1JeOotvmcLcYV81hxhmLs5/is2nVvUw0mvS89XF2
         D4iZyCLwCW9nTGJlcgabLER/oM7T0+tR52GHqXYbW6zeIBkEFaynxFbAb7flD8dkAhsk
         lTxQRy9SQN/NeDZWFiv0T+9ExQyMXAQ4SjYqxtJCMzIwFyZU1ZClqk1YcVtaGy+oCzEa
         /FCH7f/wBQXQLxjJz7lzrEyXOIiFplY56SXuJFNp/6e2NwCgVKpNT/XiXy5Ot4lm07tg
         UNtg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=k4yWikI/qo+a2LIVOQ1+zIgAMyjaP6HpzLqITF/urmE=;
        b=tvhQ+CGw6tX0HnaFa/XT6Zuxk0Dwsypf3XxnR9drXLE7oDQ7N52cR5X+YD6tG7ljBz
         1zwnZu7T67EAK586wBJxnVvVCKx63AVM7Q2mHVsknX7ZxfOQhji8KaCWA6vP1XfNJC+3
         zrLgDSbRnMeFI3YcFelSlwFtfjWBRzj3D72lQLf/7GU/plep8jGMJZAJvM3fVZMgI3jE
         OTTZlaNwdlMM7W1Y7QlwuZeUxez7b9MBCeCb022WcG7FvGYiKOABn59m+MRlJSif4Q0E
         K/8XXnRVqbl77jsKRetmYC1yMmJgM8GYB1ilmfp7ml5Uof6kDAvS4bKwvs05ONDzRFnW
         CZzQ==
X-Gm-Message-State: AOAM533lATZn6vD/ktmJEQQOi6kfY570ctujw4rUYtWErV4K4AAkOJMH
        7oM3ttkYV1O44JpC8Cc5i24e//0ofZQcn97ox6aATyud
X-Google-Smtp-Source: ABdhPJyZ7G+1RVgRTPuc5ypKEpwKegHfKQ2VVgxgPzLQ4gboflevqPjv68+a8DMIOlyJ6zCAVHr4Qn9CkhryiKBD3Pg=
X-Received: by 2002:a5e:8d01:: with SMTP id m1mr23635797ioj.72.1615317860782;
 Tue, 09 Mar 2021 11:24:20 -0800 (PST)
MIME-Version: 1.0
References: <CAOQ4uxj4zNHU49Q6JeUrw4dvgRBumzhtvGXpuG4WDEi5G7uyxw@mail.gmail.com>
 <b36a429d7c563730c28d763d4d57a6fc30508a4f.1615216996.git.kevin@kevinlocke.name>
 <CAOQ4uxhGSbEPPwZswXHq+k1YF=+ntDfukxnfGsJ3+RaGjgNDnQ@mail.gmail.com>
 <YEa4Jd0VE6w4T7/v@kevinlocke.name> <CAOQ4uxjBb_whXA5eNqkwDNj2VSS-F+0uACF7tpqFTrM8fYETQg@mail.gmail.com>
 <20210309185032.GI77194@redhat.com>
In-Reply-To: <20210309185032.GI77194@redhat.com>
From:   Amir Goldstein <amir73il@gmail.com>
Date:   Tue, 9 Mar 2021 21:24:09 +0200
Message-ID: <CAOQ4uxhHKd9PMb5-6_nZ+RNDB8LrEabSJaVAPR6xkFtzChF+Sw@mail.gmail.com>
Subject: Re: [PATCH] ovl: add xino to "changes to underlying fs" docs
To:     Vivek Goyal <vgoyal@redhat.com>
Cc:     Kevin Locke <kevin@kevinlocke.name>,
        Miklos Szeredi <miklos@szeredi.hu>,
        overlayfs <linux-unionfs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-unionfs.vger.kernel.org>
X-Mailing-List: linux-unionfs@vger.kernel.org

> > I just mislead you. Sorry for that.
> > We should leave "redirect_dir" in the documented list and add "xino"
> > just like the patch you posted.
> > But I guess if I am going to post a patch to change the xino behavior,
> > it would be better to include your change in my patch for context.
>
> This is quite complex to understand. I think I still stick to general
> stand that if any overlay feature stores any metadata info about
> lower layer in upper layer, then we should not allow changes to
> offline layers.  Otherwise there are so many possibilities to analyze
> to figure out the effect of a offline change. It is confusing for
> developers as well as users. So, IMHO, I will take simpler approach of
> no lower layer modifications for all these advanced features otherwise
> expect the unexpected. :-)
>

Eventually, I only added "xino" to the list, the same as Kevin's patch,
but I also changed the code and documentation of the "xino" feature.

Thanks,
Amir.
