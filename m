Return-Path: <linux-unionfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 43C92C433E6
	for <linux-unionfs@archiver.kernel.org>; Thu, 11 Feb 2021 16:35:50 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 15E4B64EA1
	for <linux-unionfs@archiver.kernel.org>; Thu, 11 Feb 2021 16:35:50 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230202AbhBKQfq (ORCPT
        <rfc822;linux-unionfs@archiver.kernel.org>);
        Thu, 11 Feb 2021 11:35:46 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38386 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230147AbhBKQdm (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Thu, 11 Feb 2021 11:33:42 -0500
Received: from mail-ej1-x62d.google.com (mail-ej1-x62d.google.com [IPv6:2a00:1450:4864:20::62d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 99F05C061574
        for <linux-unionfs@vger.kernel.org>; Thu, 11 Feb 2021 08:32:53 -0800 (PST)
Received: by mail-ej1-x62d.google.com with SMTP id a9so11006399ejr.2
        for <linux-unionfs@vger.kernel.org>; Thu, 11 Feb 2021 08:32:53 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=paul-moore-com.20150623.gappssmtp.com; s=20150623;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=w4256LvFpqrjJWxaCLTjmivG0mWQTVKA8Bzu5/DQPbA=;
        b=tFpohbmgZGg4MQpbdAo0AKvocbpdtyRxf13vfA+L6tzIIB5fCkBdfXgDj0mGZaidTB
         wJKuRF6BnmBr/f/jTRkSASCQgTjvC5tFUN22ksT4Vxa/xuGOVBzSc5+da63YKtUHGQz0
         lGqbtM2Ab030ZvHFq/f4YF3YIpf4T/g477H4RmptG48hhjcLP8zjtO16e+IF8fr4fQ3V
         qx5SbrTVWnXVbjR/W4so3+BrBC1KsX1vM2djXvzJWOqayGLEoGCTitEH29tm17ZpjFp7
         pAzhRWVbaohSChSA2F+CtQnqz9VJ7QV0lXiSrw/CpxKJM0GMttLlOw2gbYMVlaG7LXAO
         4hMA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=w4256LvFpqrjJWxaCLTjmivG0mWQTVKA8Bzu5/DQPbA=;
        b=ayhbM6+uvsFfN6LVfvG3leZ/ertXbHmiSLcnKdr2J5yyWMk3gBAURZIngI2kRvYGkZ
         JGxZjR/BFRKYR/0mVby3Zu2HGfeYRIHgzBhO9DIhUb/H6PFEYhT+y68iJWVnib9Ku1fj
         VoY7GKdsh08GzDvOu/M7v652cbDA6k6AsuB1hKt88cJ1Cy5dicumpnn0iv3eN3m9ZKjP
         IX2KzpPIxOXChTbBuyoqAmquHYckD0Bgkf0JCVnm5G6B6MXhMM3O6W4iO/y6CSWT8gIE
         Zg5NaAUnG9aG4OeYQ9znzvyahVYIIgbttUm/OD6RmCI4OoB9rzBtvLBY29RediEKh/BV
         JTag==
X-Gm-Message-State: AOAM532A8GffP3o5pjV3EJhoCZckIIN5raEFGszqE93Wikwv6gSujc9+
        84GV1AoSdZ0rENbjb+fRzCr1DQ9IIwmaya4V+FoX
X-Google-Smtp-Source: ABdhPJxYQ438Z9wm2ZtfF0roQWuh5mUn58vDjkODPItVE19H9pc9j1rgBNa0AbgJ4ibX8j2m4e1lcHTPZ/sU32bMDmU=
X-Received: by 2002:a17:906:35d9:: with SMTP id p25mr9200468ejb.398.1613061172254;
 Thu, 11 Feb 2021 08:32:52 -0800 (PST)
MIME-Version: 1.0
References: <20210209200233.GF3171@redhat.com> <CAHC9VhQYE3ga53AiK2r-568_=2U0BJe+L4g9U_J0dLinzJqXYA@mail.gmail.com>
 <20210211140147.GA5014@redhat.com>
In-Reply-To: <20210211140147.GA5014@redhat.com>
From:   Paul Moore <paul@paul-moore.com>
Date:   Thu, 11 Feb 2021 11:32:41 -0500
Message-ID: <CAHC9VhS=GkB2JbSz++iTygGzb2Ze6WVKuj5rnNaNVTN=p7=dCQ@mail.gmail.com>
Subject: Re: [PATCH] selinux: Allow context mounts for unpriviliged overlayfs
To:     Vivek Goyal <vgoyal@redhat.com>
Cc:     selinux@vger.kernel.org, linux-unionfs@vger.kernel.org,
        Stephen Smalley <stephen.smalley.work@gmail.com>,
        Eric Paris <eparis@parisplace.org>,
        Miklos Szeredi <miklos@szeredi.hu>,
        Daniel J Walsh <dwalsh@redhat.com>,
        Ondrej Mosnacek <omosnace@redhat.com>,
        Amir Goldstein <amir73il@gmail.com>,
        Giuseppe Scrivano <gscrivan@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-unionfs.vger.kernel.org>
X-Mailing-List: linux-unionfs@vger.kernel.org

On Thu, Feb 11, 2021 at 9:01 AM Vivek Goyal <vgoyal@redhat.com> wrote:
> On Wed, Feb 10, 2021 at 06:50:57PM -0500, Paul Moore wrote:
> > On Tue, Feb 9, 2021 at 3:02 PM Vivek Goyal <vgoyal@redhat.com> wrote:
> > >
> > > Now overlayfs allow unpriviliged mounts. That is root inside a non-init
> > > user namespace can mount overlayfs. This was added in 5.10 kernel.
>
> Actually this is being added in 5.11 kernel (and not 5.10 kernel).
>
> Paul, can you please fix this while committing. If you want me to
> report, let me know.

Good to know, thanks for the clarification.  As far as updating the
commit description, while I generally prefer the patch author to make
changes (my personal opinion is that maintainers should have as light
a touch as possible outside the mechanical work of merging), this is
pretty minor and I can fix that up if you want.  Regardless, we've
likely got ~2.5 weeks before it really matters anyway :)

-- 
paul moore
www.paul-moore.com
