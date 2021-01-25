Return-Path: <linux-unionfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.2 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,URIBL_BLOCKED,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 09D99C433DB
	for <linux-unionfs@archiver.kernel.org>; Tue, 26 Jan 2021 05:50:39 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id C55442223D
	for <linux-unionfs@archiver.kernel.org>; Tue, 26 Jan 2021 05:50:38 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727943AbhAZFuL (ORCPT
        <rfc822;linux-unionfs@archiver.kernel.org>);
        Tue, 26 Jan 2021 00:50:11 -0500
Received: from out30-132.freemail.mail.aliyun.com ([115.124.30.132]:43781 "EHLO
        out30-132.freemail.mail.aliyun.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728072AbhAYMoL (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Mon, 25 Jan 2021 07:44:11 -0500
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R401e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=e01e04426;MF=eguan@linux.alibaba.com;NM=1;PH=DS;RN=10;SR=0;TI=SMTPD_---0UMsJZDg_1611578112;
Received: from localhost(mailfrom:eguan@linux.alibaba.com fp:SMTPD_---0UMsJZDg_1611578112)
          by smtp.aliyun-inc.com(127.0.0.1);
          Mon, 25 Jan 2021 20:35:13 +0800
Date:   Mon, 25 Jan 2021 20:35:12 +0800
From:   Eryu Guan <eguan@linux.alibaba.com>
To:     Amir Goldstein <amir73il@gmail.com>
Cc:     Eryu Guan <guan@eryu.me>, Eryu Guan <guaneryu@gmail.com>,
        Icenowy Zheng <icenowy@aosc.io>,
        Chengguang Xu <cgxu519@mykernel.net>,
        Xiao Yang <yangx.jy@cn.fujitsu.com>,
        Miklos Szeredi <miklos@szeredi.hu>,
        overlayfs <linux-unionfs@vger.kernel.org>,
        fstests <fstests@vger.kernel.org>
Subject: Re: [PATCH 2/4] src/t_immutable: factor out some helpers
Message-ID: <20210125123512.GE58500@e18g06458.et15sqa>
References: <20210116165619.494265-1-amir73il@gmail.com>
 <20210116165619.494265-3-amir73il@gmail.com>
 <20210124150918.GB2350@desktop>
 <CAOQ4uxgohiok+9FUG_Xw0NWpDczBD1Gn2ApWMiuhB-O6=Tterw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAOQ4uxgohiok+9FUG_Xw0NWpDczBD1Gn2ApWMiuhB-O6=Tterw@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Precedence: bulk
List-ID: <linux-unionfs.vger.kernel.org>
X-Mailing-List: linux-unionfs@vger.kernel.org

On Sun, Jan 24, 2021 at 05:29:33PM +0200, Amir Goldstein wrote:
> On Sun, Jan 24, 2021 at 5:09 PM Eryu Guan <guan@eryu.me> wrote:
> >
> > On Sat, Jan 16, 2021 at 06:56:17PM +0200, Amir Goldstein wrote:
> > > Reduce boilerplate code.
> > > define _GNU_SOURCE needed for asprintf.
> > >
> > > Signed-off-by: Amir Goldstein <amir73il@gmail.com>
> > > ---
> > >  src/t_immutable.c | 221 ++++++++++++++++++++++------------------------
> > >  1 file changed, 104 insertions(+), 117 deletions(-)
> > >
> > > diff --git a/src/t_immutable.c b/src/t_immutable.c
> > > index 86c567ed..b6a76af0 100644
> > > --- a/src/t_immutable.c
> > > +++ b/src/t_immutable.c
> > > @@ -8,6 +8,9 @@
> > >
> > >  #define TEST_UTIME
> > >
> > > +#ifndef _GNU_SOURCE
> > > +#define _GNU_SOURCE
> > > +#endif
> > >  #include <stdio.h>
> > >  #include <stdlib.h>
> > >  #include <string.h>
> > > @@ -1895,13 +1898,66 @@ static int check_test_area(const char *dir)
> > >       return 0;
> > >  }
> > >
> > > +static int create_dir(char **ppath, const char *fmt, const char *dir)
> > > +{
> > > +     const char *path;
> > > +     struct stat st;
> > > +
> > > +     if (asprintf(ppath, fmt, dir) == -1) {
> > > +       return -1;
> > > +     }
> > > +     path = *ppath;
> > > +     if (stat(path, &st) == 0) {
> > > +       fprintf(stderr, "%s: Test area directory %s must not exist for test area creation.\n",
> > > +               __progname, path);
> > > +       return 1;
> >
> > Other places return -1 but 1 is returned here, should be -1 as well?
> >
> 
> It is a semantically different return value.
> 
> -1 are error cases, 1 means already existing, so the caller that requested to
> create the dir could treat this as success.
> I did not end up implementing the 'allow_existing' feature in this way, but I
> see no reason to change the return value, because future implementation
> could make use of this distinction. Unless you insist.

I can live with it :) I'm just curious why the return values are
different, as I didn't see different values in original code.

Thanks,
Eryu
