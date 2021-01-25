Return-Path: <linux-unionfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.2 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	UNPARSEABLE_RELAY,URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 19BE3C43381
	for <linux-unionfs@archiver.kernel.org>; Tue, 26 Jan 2021 19:19:56 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id D289B22228
	for <linux-unionfs@archiver.kernel.org>; Tue, 26 Jan 2021 19:19:55 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728747AbhAZFuW (ORCPT
        <rfc822;linux-unionfs@archiver.kernel.org>);
        Tue, 26 Jan 2021 00:50:22 -0500
Received: from out30-133.freemail.mail.aliyun.com ([115.124.30.133]:50879 "EHLO
        out30-133.freemail.mail.aliyun.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728307AbhAYMrS (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Mon, 25 Jan 2021 07:47:18 -0500
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R391e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=e01e04394;MF=eguan@linux.alibaba.com;NM=1;PH=DS;RN=10;SR=0;TI=SMTPD_---0UMpgW9L_1611578789;
Received: from localhost(mailfrom:eguan@linux.alibaba.com fp:SMTPD_---0UMpgW9L_1611578789)
          by smtp.aliyun-inc.com(127.0.0.1);
          Mon, 25 Jan 2021 20:46:29 +0800
Date:   Mon, 25 Jan 2021 20:46:29 +0800
From:   Eryu Guan <eguan@linux.alibaba.com>
To:     Amir Goldstein <amir73il@gmail.com>
Cc:     Eryu Guan <guan@eryu.me>, Eryu Guan <guaneryu@gmail.com>,
        Icenowy Zheng <icenowy@aosc.io>,
        Chengguang Xu <cgxu519@mykernel.net>,
        Xiao Yang <yangx.jy@cn.fujitsu.com>,
        Miklos Szeredi <miklos@szeredi.hu>,
        overlayfs <linux-unionfs@vger.kernel.org>,
        fstests <fstests@vger.kernel.org>
Subject: Re: [PATCH 3/4] src/t_immutable: Allow setting flags on existing
 files
Message-ID: <20210125124629.GF58500@e18g06458.et15sqa>
References: <20210116165619.494265-1-amir73il@gmail.com>
 <20210116165619.494265-4-amir73il@gmail.com>
 <20210124151411.GC2350@desktop>
 <CAOQ4uxj8xx7izTV8Sp3FH_Pgv_S0gvCKZtCmfRnDGfo318d86Q@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAOQ4uxj8xx7izTV8Sp3FH_Pgv_S0gvCKZtCmfRnDGfo318d86Q@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Precedence: bulk
List-ID: <linux-unionfs.vger.kernel.org>
X-Mailing-List: linux-unionfs@vger.kernel.org

On Sun, Jan 24, 2021 at 05:32:15PM +0200, Amir Goldstein wrote:
> On Sun, Jan 24, 2021 at 5:14 PM Eryu Guan <guan@eryu.me> wrote:
> >
[snap]
> > >
> > >       if (create) {
> > >         ret = create_test_area(argv[argc-1]);
> > > -       if (ret || !runtest) {
> > > +       if (ret || allow_existing) {
> >
> > With this change, compiler warns about 'runtest' is set but not used,
> > and 'allow_existing' now indicates '!runtest' implicitly, which seems
> > subtle. I think it's better to keep 'runtest' as the indicator to
> > actually run the test?
> >
> 
> Sure, I removed it by mistake.

Then this is the only place that needs update. I can fix it on commit,
no need to resend then.

Thanks,
Eryu
