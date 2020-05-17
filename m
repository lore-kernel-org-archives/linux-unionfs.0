Return-Path: <SRS0=O/kl=67=vger.kernel.org=linux-unionfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4B770C433DF
	for <linux-unionfs@archiver.kernel.org>; Sun, 17 May 2020 16:47:48 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 21DC320657
	for <linux-unionfs@archiver.kernel.org>; Sun, 17 May 2020 16:47:48 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728041AbgEQQrr (ORCPT
        <rfc822;linux-unionfs@archiver.kernel.org>);
        Sun, 17 May 2020 12:47:47 -0400
Received: from out20-110.mail.aliyun.com ([115.124.20.110]:42471 "EHLO
        out20-110.mail.aliyun.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728028AbgEQQrr (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Sun, 17 May 2020 12:47:47 -0400
X-Alimail-AntiSpam: AC=CONTINUE;BC=0.08392455|-1;CH=green;DM=|CONTINUE|false|;DS=CONTINUE|ham_social|0.037933-0.00118985-0.960877;FP=0|0|0|0|0|-1|-1|-1;HT=e02c03299;MF=guan@eryu.me;NM=1;PH=DS;RN=6;RT=6;SR=0;TI=SMTPD_---.HZtRwnV_1589734064;
Received: from localhost(mailfrom:guan@eryu.me fp:SMTPD_---.HZtRwnV_1589734064)
          by smtp.aliyun-inc.com(10.147.41.231);
          Mon, 18 May 2020 00:47:44 +0800
Date:   Mon, 18 May 2020 00:47:44 +0800
From:   Eryu Guan <guan@eryu.me>
To:     Amir Goldstein <amir73il@gmail.com>
Cc:     Eryu Guan <guaneryu@gmail.com>,
        Chengguang Xu <cgxu519@mykernel.net>,
        Miklos Szeredi <miklos@szeredi.hu>,
        overlayfs <linux-unionfs@vger.kernel.org>,
        fstests <fstests@vger.kernel.org>
Subject: Re: [PATCH v5] overlay: test for whiteout inode sharing
Message-ID: <20200517164744.GH2704@desktop>
References: <20200513192338.13584-1-amir73il@gmail.com>
 <20200517162418.GG2704@desktop>
 <CAOQ4uxhtOSsi41z_kCA2ihCKVEg3FTxg892OHgCB22j60LQHoA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAOQ4uxhtOSsi41z_kCA2ihCKVEg3FTxg892OHgCB22j60LQHoA@mail.gmail.com>
Sender: linux-unionfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-unionfs.vger.kernel.org>
X-Mailing-List: linux-unionfs@vger.kernel.org

On Sun, May 17, 2020 at 07:42:32PM +0300, Amir Goldstein wrote:
> On Sun, May 17, 2020 at 7:24 PM Eryu Guan <guan@eryu.me> wrote:
> >
> > On Wed, May 13, 2020 at 10:23:38PM +0300, Amir Goldstein wrote:
> > > From: Chengguang Xu <cgxu519@mykernel.net>
> > >
> > > This is a test for whiteout inode sharing feature.
> > >
> > > [Amir] added check for whiteout sharing support
> > >        and whiteout of lower dir.
> > >
> > > Signed-off-by: Chengguang Xu <cgxu519@mykernel.net>
> > > Signed-off-by: Amir Goldstein <amir73il@gmail.com>
> > > ---
> > >
> > > Chengguang,
> > >
> > > I decided to take a stab at Eryu's challenge ;-)
> >
> > Great! Thanks for the update!
> >
> 
> FYI, not sure if and when that was mentioned.
> inode sharing feature is now on overlayfs-next.
> 
> So are the two file handle fixes for which I posted the test:
> "overlay: regression test for two file handle bugs"
> (will re-post when I have the final kernel commits)

Thanks! I noticed this test would oops kernel, so I didn't take it this
time and will wait until the fix goes to mainline kernel.

Thanks,
Eryu
