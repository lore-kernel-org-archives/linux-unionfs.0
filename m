Return-Path: <SRS0=prAY=BF=vger.kernel.org=linux-unionfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.9 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4CB4EC433DF
	for <linux-unionfs@archiver.kernel.org>; Sun, 26 Jul 2020 16:22:08 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 234822065F
	for <linux-unionfs@archiver.kernel.org>; Sun, 26 Jul 2020 16:22:08 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Q39whQS6"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727783AbgGZQWI (ORCPT
        <rfc822;linux-unionfs@archiver.kernel.org>);
        Sun, 26 Jul 2020 12:22:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59454 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726044AbgGZQWH (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Sun, 26 Jul 2020 12:22:07 -0400
Received: from mail-io1-xd41.google.com (mail-io1-xd41.google.com [IPv6:2607:f8b0:4864:20::d41])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 69D0BC0619D2;
        Sun, 26 Jul 2020 09:22:06 -0700 (PDT)
Received: by mail-io1-xd41.google.com with SMTP id l1so14523014ioh.5;
        Sun, 26 Jul 2020 09:22:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=cWe+O/5s8xcTbT5idzVf89sT9Co/8XqXj3H57IRjIis=;
        b=Q39whQS6iGJHG6OsJnkiX4MCaAzHNdeH5T7kabWN6TKSsHKFsTwKDGQf4nukh+lz2h
         l/n1/zBYrPrb4l0X/WyewNl2LdD4bCb7AOzdSqQc+BjI+BlObp8nnthAlmoM/X2/w+3G
         r2hUwS9lze+04AtHFmOMnNyvNGv5LpSi837C2sGq86QY8iEyZTVDdeAev0XHit/Lib3C
         CaG511N7MHltb30T0NPD9gei6vhPKF2XNC+UZGMT/Mc8IpGrxtnwE/N59h598kX3+7oY
         utY+uZaNJIwbRlapvHSti2fSmvDXCxiBiWKEOPRKDSodFz8sTHpm2LPNsbis1If11BCv
         pqtw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=cWe+O/5s8xcTbT5idzVf89sT9Co/8XqXj3H57IRjIis=;
        b=BD5/EF9wRYX4ztA/Tik73xnf1/V0qCRSzvmf97PNIre0l95roBlOVtWF/s9HF3cfHJ
         8K7XM+upPTMghn0wIIxRdpDSxL4sw/UKVI25fg6VL5Gnrv+BX7BoggKCV4Mv94fIReIH
         /rNNZHjSKMkVcRF1B1cBYdrt2mvIVVwCovOpvo1nDTB4wnZ/lUcsLNFx0uNocgIbxv5O
         n+B75AAQHREgd4n7CkFcSfkmAg7qwhVNbji4vG0/YNk/tAgPfffDE8XZdwLbfgfnnPHg
         53SYoUY7Hor9lcclOn4H4qcGhbpmo9dTysvKU/oAo8zAyJE/B5qJxHqWxhmQAtUv63CN
         jcVw==
X-Gm-Message-State: AOAM530VZfWPDWlPBCGiLgA33bjYp+9qwVrE7LZpkLWFiY5N/X0EWTfv
        0pb5Z6+7wP3zCsiZInaN7H0mPmE7fVkWhcioqDg=
X-Google-Smtp-Source: ABdhPJyApKxeAGG+TVz+uGLiKt8YEs4bDmTBlC9wQ0/rcOcK4Wok7h/0YaTVqUCwFIZFPfI3tXn/iv7/qfGkZoPlxiM=
X-Received: by 2002:a05:6638:61b:: with SMTP id g27mr21487338jar.123.1595780524535;
 Sun, 26 Jul 2020 09:22:04 -0700 (PDT)
MIME-Version: 1.0
References: <20200531110156.6613-1-amir73il@gmail.com> <20200719181116.GG2557159@desktop>
 <CAOQ4uxjY7SqyVEG9vCtv=wB9BxDovpjwZGAQ7h5+VeiZPMKOeQ@mail.gmail.com> <20200726151632.GJ2557159@desktop>
In-Reply-To: <20200726151632.GJ2557159@desktop>
From:   Amir Goldstein <amir73il@gmail.com>
Date:   Sun, 26 Jul 2020 19:21:53 +0300
Message-ID: <CAOQ4uxhfxay_K9R12dY1gGTRw_su5m77YtX3nKXKmph4Vi=g0w@mail.gmail.com>
Subject: Re: [PATCH 0/3] Running unionmount testsuite from xfstests
To:     Eryu Guan <guan@eryu.me>
Cc:     Eryu Guan <guaneryu@gmail.com>, Miklos Szeredi <miklos@szeredi.hu>,
        Vivek Goyal <vgoyal@redhat.com>,
        overlayfs <linux-unionfs@vger.kernel.org>,
        fstests <fstests@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-unionfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-unionfs.vger.kernel.org>
X-Mailing-List: linux-unionfs@vger.kernel.org

> >
> > > The test itself looks really good to me, my only concern is that
> > > the updates in unionmount repo are not visible to fstests, and may cause
> > > new failures, which are out of fstests' control. But I'm not sure if
> > > this really is a problem for people.
> > >
> > > I came up with two options anyway
> > > - add unionmount tests as a submodule of fstests
> > > - put unionmount tests in fstests
> > >
> >
> > I suppose you mean git submodule?
>
> Exactly.
>
> But I think I'd merge it as-is, git submodule brings more maintain
> burden on both maintainers and users, especially users that usually
> don't care about overlay tests. Users that care about overlay tests
> should setup unionmount tests explicitly and know that's unionmount
> tests if there's any test failure.
>

Great!

I see you also kept my 100+N test numbering, which is very convenient :-)

I have a patch on my dev branch to run unionmount test cases with
metacopy enabled that Vivek requested.

Will post it this week.

Thanks!
Amir.
