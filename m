Return-Path: <SRS0=AFfm=BV=vger.kernel.org=linux-unionfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.1 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 28B7DC433DF
	for <linux-unionfs@archiver.kernel.org>; Tue, 11 Aug 2020 09:57:59 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id F3290205CB
	for <linux-unionfs@archiver.kernel.org>; Tue, 11 Aug 2020 09:57:58 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Yz15gRMW"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728265AbgHKJ56 (ORCPT
        <rfc822;linux-unionfs@archiver.kernel.org>);
        Tue, 11 Aug 2020 05:57:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37280 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727976AbgHKJ56 (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Tue, 11 Aug 2020 05:57:58 -0400
Received: from mail-io1-xd2c.google.com (mail-io1-xd2c.google.com [IPv6:2607:f8b0:4864:20::d2c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 148FFC06174A
        for <linux-unionfs@vger.kernel.org>; Tue, 11 Aug 2020 02:57:58 -0700 (PDT)
Received: by mail-io1-xd2c.google.com with SMTP id g14so12016737iom.0
        for <linux-unionfs@vger.kernel.org>; Tue, 11 Aug 2020 02:57:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=ox1wN8keFvQ9zgKGUn2UC7i/gTfYuMG174DXgz0AznM=;
        b=Yz15gRMWK4wC08lTKpCeolgBi4py3hnxlihodFIaIdCne9p8JnAzlwrCM5bjE6C09Q
         JPBREjLPxWDiYHBrU+rTBZwQHtlzeAToHgqOxITANYaDGAiWcRZIbDJOXgtlirFdyW47
         5ElfpIaniAMG/gPWxMG0Ku3uSz7ASOUWj90TJw0bAo/dEPYcrxzWCoA3v/2iOR7p8ZNv
         HgL6kF5+prZSe1myn15y21fuvoUd6CYsRot3Bu+bxwPu0+ud4KEKKbdQOMsgzZwIUfrD
         2Dckuv2D+lhxK4A3HNoPvIlzbKMV+npL/brUSDM4UgzBEc9UeapTJyJNXBtRnGreL9ve
         gIVg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=ox1wN8keFvQ9zgKGUn2UC7i/gTfYuMG174DXgz0AznM=;
        b=dsn527Go7Ib+bTnUBmT4e2QUD1zHzN4Xddwh8/ZPwb0jh/x25Sqfu0cwPhuyF9z44E
         Ov5lu+dN98U6MwY1PFe4W6ELi1BH1Hs4GefS5c0iMMG19CfxWfkfRZwm0yIqS7dfoTY9
         k1d6bdOlcWmisn84Oq49A+debGHHizRXgc+4WfrQ7OSJur4iJXaVRt3PMVDiwWCURpob
         8yJBGsxby/cU8C9qwLNfpzyG1mAdwIAtbcM8CijciQWvhj3lVqIRMioSIlpX9l7PT3+N
         IefoYP39NxI5PjeIVbS1OqOpA1+1sk6N382Z6do4ITI4+rjzRVvmcuKqeq0eadQ1BDV4
         s5wQ==
X-Gm-Message-State: AOAM5315IcZn4uSB+9tDL5LLZetVofygJMQTsHc0yPLZdP0cEnAAxok3
        pFsctRSxpshPRLYpV6IwBW52xKv9dteXvXvJZ8k=
X-Google-Smtp-Source: ABdhPJx+HVTKeyCXi5exZJhW8/W1W4TqDjNHiBRKvpscOOMqwXwu6sAciAw4Bb80ZoSgImdI8cXEFaQoN+C7846r6O4=
X-Received: by 2002:a5e:980f:: with SMTP id s15mr21774229ioj.5.1597139876869;
 Tue, 11 Aug 2020 02:57:56 -0700 (PDT)
MIME-Version: 1.0
References: <CAOQ4uxjFC81hikgg0WaF0Z3Mxkk3iDakKx2Ttuhp_L_2Tnc6xQ@mail.gmail.com>
 <20200108140611.GA1995@redhat.com> <CAOQ4uxiUXk-=RV+cCXvE_0KMjW-3xqFFVkhNx7TmnbtMySh7Gw@mail.gmail.com>
In-Reply-To: <CAOQ4uxiUXk-=RV+cCXvE_0KMjW-3xqFFVkhNx7TmnbtMySh7Gw@mail.gmail.com>
From:   Amir Goldstein <amir73il@gmail.com>
Date:   Tue, 11 Aug 2020 12:57:45 +0300
Message-ID: <CAOQ4uxhj6wxKM89n1q6GFQYfsSL1Cd63iSWb_-QzmaieXF8bZg@mail.gmail.com>
Subject: Re: OverlaysFS offline tools
To:     Vivek Goyal <vgoyal@redhat.com>
Cc:     overlayfs <linux-unionfs@vger.kernel.org>,
        StuartIanNaylor <rolyantrauts@gmail.com>,
        Linux Containers <containers@lists.linux-foundation.org>,
        kmxz <kxzkxz7139@gmail.com>, "zhangyi (F)" <yi.zhang@huawei.com>,
        Miklos Szeredi <miklos@szeredi.hu>,
        Christian Brauner <christian.brauner@ubuntu.com>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-unionfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-unionfs.vger.kernel.org>
X-Mailing-List: linux-unionfs@vger.kernel.org

> > - Overlayfs redirect_dir is not compatible with image building
> >
> >   redirect_dir is not compatible with image building and I think that's
> >   one reason that its not used by default. And as metacopy is dependent
> >   on redirect_dir, its not used by default as well. It can be used for
> >   running containers though, but one needs to know that in advacnce.
> >
> >   So it will be good if that's fixed with redirect_dir and metacopy
> >   features and then there is higher chance that these features are
> >   enabled by default.
> >
> >   Miklos had some ides on how to tackle the issue of getting diff
> >   correctly with redirect_dir enabled.
> >
> >   https://www.spinics.net/lists/linux-unionfs/msg06969.html
> >
>
> FYI, I have been playing with kmxz's overlay (offline tools).
> It's a nice little tool :)
> Adding "awareness" to redirect and metacopy was easy [1].
>
> It should be easy to add support for command "export"
> that does what Miklos suggested in order to migrate an image with
> metacopy/redirect.
>

FYI, I took a swing at that and implemented the command "deref"
that implements Miklos' suggestion [1].
I am sure we could think of a better name, but whatever...

> I submitted a talk proposal to plumbers containers track about
> enabling overlayfs features in container runtimes.
>

FYI2, this is a draft of talking points for my talk on Plumbers [2].
My hope is that I could use 15min to introduce the new overlayfs features
and the challenges to integrate them with container runtimes and that we
will be able to spend the remaining 30min for open discussion.

Thanks,
Amir.

[1] https://github.com/kmxz/overlayfs-tools/pull/11
[2] https://github.com/amir73il/overlayfs/wiki/Overlayfs-and-containers
