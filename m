Return-Path: <linux-unionfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B0290C433DB
	for <linux-unionfs@archiver.kernel.org>; Sun, 24 Jan 2021 15:30:41 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 7C95B22E03
	for <linux-unionfs@archiver.kernel.org>; Sun, 24 Jan 2021 15:30:41 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726386AbhAXPak (ORCPT
        <rfc822;linux-unionfs@archiver.kernel.org>);
        Sun, 24 Jan 2021 10:30:40 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60348 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726381AbhAXPa0 (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Sun, 24 Jan 2021 10:30:26 -0500
Received: from mail-io1-xd2c.google.com (mail-io1-xd2c.google.com [IPv6:2607:f8b0:4864:20::d2c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BCF12C061573;
        Sun, 24 Jan 2021 07:29:45 -0800 (PST)
Received: by mail-io1-xd2c.google.com with SMTP id q129so21461783iod.0;
        Sun, 24 Jan 2021 07:29:45 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=RCz/IO50P5yBgxCx7JmnM/Ts8yhXJwNKkuv8s5ESRes=;
        b=ZmaRzkqs2r1g2ZLOsmTfHksHKdBu1YCfa4mNiqnKgjyQidoNuz31n7aLsiJVR9agLG
         GlaZimpAMp3v+OA06YU9ytqePr8vlzjIVL0Ex1zge2QCO6ApSfHruQO0GUpthYY9QzeW
         6X1tvp3hXoxUU+mhDJYrBaPfidT0xRlCGbvfmAf3MBcclgTYjSoaHDGd30oARE/7LsSS
         83ziBfMVCG5DSJBQaX7JMPsW9Vb/YGp7SwG5e6Jj4pUfpX88tDDp29vdxH736JbdiVBA
         j/8pKG8QzMLEJFXMObl2ywbg7EElXOPq95POWiLZPD5GTtfR77wKY8mrjURX7ztgWeeH
         Deig==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=RCz/IO50P5yBgxCx7JmnM/Ts8yhXJwNKkuv8s5ESRes=;
        b=m2nJaRAkdBmkb5HaFyOWIOGF8KgIPuRO7uwOM2ema+K/WuhEVyK+rk5jeSw1NU7Gk2
         VkP2b4ey4olOpXSMIVTEPahNg161o2hhwvMhM2ys/wIyJ638GBKYf8dfXMWznTwO5yZ2
         DJJItohWTMI/i7ChbfovO7wVK5Xoj1RrWt0GF9tSNU6SgpYQ3wBOw1DDWaRIYsIQkMuJ
         8yj90q7xd40GfOVi3RBUNhJ5DG6VjoM96QjCGb3S4Iw6qiNW+oeA36NR/0TL5QZacEf5
         DaE8kWOgBiFIg36Qtux4vLi6tB1ZKSiuAwVav5GVJ+UOgEgcrUrtjWEBzK6CyqzYuvPw
         /oCg==
X-Gm-Message-State: AOAM533rDBrwVrmNKZ2H7g522/BXAc21hYWN46lWK7eL/JL6/3f8uusr
        6ci/oBhTfMys6H6JO7zUe02gDLS2NjJBimM2M/I=
X-Google-Smtp-Source: ABdhPJy+rYdrsGi6dn2GJsLaqx+4CcNumuWeE8wbG1T1BMFqOTsanZMItbQkwhcQ/r9PP1o+gZAI60TzTegweZgOayA=
X-Received: by 2002:a05:6e02:eb0:: with SMTP id u16mr900300ilj.250.1611502184637;
 Sun, 24 Jan 2021 07:29:44 -0800 (PST)
MIME-Version: 1.0
References: <20210116165619.494265-1-amir73il@gmail.com> <20210116165619.494265-3-amir73il@gmail.com>
 <20210124150918.GB2350@desktop>
In-Reply-To: <20210124150918.GB2350@desktop>
From:   Amir Goldstein <amir73il@gmail.com>
Date:   Sun, 24 Jan 2021 17:29:33 +0200
Message-ID: <CAOQ4uxgohiok+9FUG_Xw0NWpDczBD1Gn2ApWMiuhB-O6=Tterw@mail.gmail.com>
Subject: Re: [PATCH 2/4] src/t_immutable: factor out some helpers
To:     Eryu Guan <guan@eryu.me>
Cc:     Eryu Guan <guaneryu@gmail.com>, Icenowy Zheng <icenowy@aosc.io>,
        Chengguang Xu <cgxu519@mykernel.net>,
        Xiao Yang <yangx.jy@cn.fujitsu.com>,
        Miklos Szeredi <miklos@szeredi.hu>,
        overlayfs <linux-unionfs@vger.kernel.org>,
        fstests <fstests@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-unionfs.vger.kernel.org>
X-Mailing-List: linux-unionfs@vger.kernel.org

On Sun, Jan 24, 2021 at 5:09 PM Eryu Guan <guan@eryu.me> wrote:
>
> On Sat, Jan 16, 2021 at 06:56:17PM +0200, Amir Goldstein wrote:
> > Reduce boilerplate code.
> > define _GNU_SOURCE needed for asprintf.
> >
> > Signed-off-by: Amir Goldstein <amir73il@gmail.com>
> > ---
> >  src/t_immutable.c | 221 ++++++++++++++++++++++------------------------
> >  1 file changed, 104 insertions(+), 117 deletions(-)
> >
> > diff --git a/src/t_immutable.c b/src/t_immutable.c
> > index 86c567ed..b6a76af0 100644
> > --- a/src/t_immutable.c
> > +++ b/src/t_immutable.c
> > @@ -8,6 +8,9 @@
> >
> >  #define TEST_UTIME
> >
> > +#ifndef _GNU_SOURCE
> > +#define _GNU_SOURCE
> > +#endif
> >  #include <stdio.h>
> >  #include <stdlib.h>
> >  #include <string.h>
> > @@ -1895,13 +1898,66 @@ static int check_test_area(const char *dir)
> >       return 0;
> >  }
> >
> > +static int create_dir(char **ppath, const char *fmt, const char *dir)
> > +{
> > +     const char *path;
> > +     struct stat st;
> > +
> > +     if (asprintf(ppath, fmt, dir) == -1) {
> > +       return -1;
> > +     }
> > +     path = *ppath;
> > +     if (stat(path, &st) == 0) {
> > +       fprintf(stderr, "%s: Test area directory %s must not exist for test area creation.\n",
> > +               __progname, path);
> > +       return 1;
>
> Other places return -1 but 1 is returned here, should be -1 as well?
>

It is a semantically different return value.

-1 are error cases, 1 means already existing, so the caller that requested to
create the dir could treat this as success.
I did not end up implementing the 'allow_existing' feature in this way, but I
see no reason to change the return value, because future implementation
could make use of this distinction. Unless you insist.

Thanks,
Amir.
