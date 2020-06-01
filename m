Return-Path: <SRS0=DrFc=7O=vger.kernel.org=linux-unionfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.6 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,
	SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1516FC433E1
	for <linux-unionfs@archiver.kernel.org>; Mon,  1 Jun 2020 19:18:58 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id DC934207BB
	for <linux-unionfs@archiver.kernel.org>; Mon,  1 Jun 2020 19:18:57 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Mx6Xk62i"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728080AbgFATS5 (ORCPT
        <rfc822;linux-unionfs@archiver.kernel.org>);
        Mon, 1 Jun 2020 15:18:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48946 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726751AbgFATS4 (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Mon, 1 Jun 2020 15:18:56 -0400
Received: from mail-io1-xd42.google.com (mail-io1-xd42.google.com [IPv6:2607:f8b0:4864:20::d42])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 998E9C061A0E;
        Mon,  1 Jun 2020 12:18:56 -0700 (PDT)
Received: by mail-io1-xd42.google.com with SMTP id c8so8139766iob.6;
        Mon, 01 Jun 2020 12:18:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=XolEYQBGLUcuZLQYRvwjytQlMW5T0LQIpbm33QF6JpY=;
        b=Mx6Xk62iXBpEQD91uw1p2rVckabam2O4YAB7ZCuyQlDjiZOf+qjAmtLo1s8Lw7wgmp
         LbXA92pg0BguBHtoDDMGKquU38zyjc6lWFXzGuhxBWhgnIymRLcCI4vHPBxxw+8iniFD
         Lei5L/iK8hxXM8wDhUndxst3nWZ9+CPiAbXeCFODobREKk+9ysIF64477stp4Ta//AE6
         CtmekJL72xSZ8mX0q8Hlgq7xYCWQ9JMmjWO7II/ruGxAvCWbWuWPBOZK4Ew25hlygOSP
         Vy76vG8CjqPDKFUqyTJV+SUF3pM4iwIINzl+0gHvZekf54S0Wp2dDOKlEGmA+FAlF2iC
         L3Mg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=XolEYQBGLUcuZLQYRvwjytQlMW5T0LQIpbm33QF6JpY=;
        b=T9TkkDUbudjg06W2+BUpL1IDRyIAWOIo58sKdZs27/xg5DVkHbwyZ5oz8YPSU6fc/f
         GtIq/WVakUUumttjYfaX5bGdp8+O3+IQU4lud4lMxvPIzV/0hAARlqiCQGniz0HmQRi7
         6sK73uF23oIU6nbrLPpb5y5dnvhVSSNbuvqnrcZR0uG9XDmhSaQmWX9M4XGllkHh15AY
         YNnex1rj6gB2ZTDrSdJfYhoS7seFNrVwaiSeFmzwwek7dslzP4pwg8ulK5/jfxT7n+ke
         ifO6s+BtJ/gI1Aq4RkDXoLrYedPXBQYxEjkBJaxcqIcE63eFi9KDmtk7F5KxRLm0XX3U
         uXeQ==
X-Gm-Message-State: AOAM532csSQ3SE+s1VzzSJ8+AkBzdrW1YiuEL0SA28klZw/OQmMvG2Xl
        1aZRjMJEsYaLd01Ekfu/MzaQEr4wK6P9saKSnP0=
X-Google-Smtp-Source: ABdhPJxEkRVYkG+MPX62XuVqybyH4Jluly+d2nvshfxoLWUHj6je0yV/rqO1TQDSH+PDjtSlT7QWs5wIRH6D0AZlQ2Y=
X-Received: by 2002:a05:6602:2437:: with SMTP id g23mr20291271iob.5.1591039135996;
 Mon, 01 Jun 2020 12:18:55 -0700 (PDT)
MIME-Version: 1.0
References: <20200531110156.6613-1-amir73il@gmail.com> <20200601175219.GE3219@redhat.com>
In-Reply-To: <20200601175219.GE3219@redhat.com>
From:   Amir Goldstein <amir73il@gmail.com>
Date:   Mon, 1 Jun 2020 22:18:44 +0300
Message-ID: <CAOQ4uxhgeadCVKi-gzAuaiyyaVVPLc9yR-t5xkfUwAuCSSEDXQ@mail.gmail.com>
Subject: Re: [PATCH 0/3] Running unionmount testsuite from xfstests
To:     Vivek Goyal <vgoyal@redhat.com>
Cc:     Eryu Guan <guaneryu@gmail.com>, Miklos Szeredi <miklos@szeredi.hu>,
        overlayfs <linux-unionfs@vger.kernel.org>,
        fstests <fstests@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-unionfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-unionfs.vger.kernel.org>
X-Mailing-List: linux-unionfs@vger.kernel.org

On Mon, Jun 1, 2020 at 8:52 PM Vivek Goyal <vgoyal@redhat.com> wrote:
>
> On Sun, May 31, 2020 at 02:01:53PM +0300, Amir Goldstein wrote:
> > Eryu,
> >
> > unionmount testsuite has a lot more test coverage than the overlay
> > xfstests, but it has a lot less exposure to testers.
> >
> > The various test setups that I have added to unionmount testsuite since
> > I took over the maintanace of the testsuite have even smaller exposure
> > to testers.
> >
> > These patches add overlay tests that are used as a harness to run
> > different setups of unionmount testsuite.  I have been using this method
> > for over two year for testing my overlayfs branches.
>
> Hi Amir,
>
> Is there a git branch somewhere with these changes. Its easier to pull
> that one in and test.
>

Of course. Forgot to mention.

https://github.com/amir73il/xfstests/commits/unionmount

Thanks,
Amir.
