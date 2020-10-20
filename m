Return-Path: <SRS0=P7/h=D3=vger.kernel.org=linux-unionfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-11.2 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,USER_AGENT_SANE_1 autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2B8E4C433DF
	for <linux-unionfs@archiver.kernel.org>; Tue, 20 Oct 2020 05:22:39 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id D7AD322282
	for <linux-unionfs@archiver.kernel.org>; Tue, 20 Oct 2020 05:22:38 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2391616AbgJTFWh (ORCPT
        <rfc822;linux-unionfs@archiver.kernel.org>);
        Tue, 20 Oct 2020 01:22:37 -0400
Received: from out30-132.freemail.mail.aliyun.com ([115.124.30.132]:42903 "EHLO
        out30-132.freemail.mail.aliyun.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S2391613AbgJTFWh (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Tue, 20 Oct 2020 01:22:37 -0400
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R151e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=e01e04394;MF=eguan@linux.alibaba.com;NM=1;PH=DS;RN=7;SR=0;TI=SMTPD_---0UCcc2MM_1603171349;
Received: from localhost(mailfrom:eguan@linux.alibaba.com fp:SMTPD_---0UCcc2MM_1603171349)
          by smtp.aliyun-inc.com(127.0.0.1);
          Tue, 20 Oct 2020 13:22:30 +0800
Date:   Tue, 20 Oct 2020 13:22:29 +0800
From:   Eryu Guan <eguan@linux.alibaba.com>
To:     Murphy Zhou <jencce.kernel@gmail.com>
Cc:     Amir Goldstein <amir73il@gmail.com>,
        fstests <fstests@vger.kernel.org>,
        Chengguang Xu <cgxu519@mykernel.net>,
        Miklos Szeredi <miklos@szeredi.hu>,
        overlayfs <linux-unionfs@vger.kernel.org>
Subject: Re: [PATCH v2] overlay/073: test with nfs_export being off
Message-ID: <20201020052229.GL80581@e18g06458.et15sqa>
References: <CAOQ4uxh+ppPMOSeAZU3sdwxwb_ixMHEpHLF9ZO_MTiedNJRgsw@mail.gmail.com>
 <20200911021813.o6vtueabupevfgab@xzhoux.usersys.redhat.com>
 <20201020024538.tl7xenmmguhcj6af@xzhoux.usersys.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201020024538.tl7xenmmguhcj6af@xzhoux.usersys.redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Precedence: bulk
List-ID: <linux-unionfs.vger.kernel.org>
X-Mailing-List: linux-unionfs@vger.kernel.org

On Tue, Oct 20, 2020 at 10:52:59AM +0800, Murphy Zhou wrote:
> Ping on this one.

Queued for next update.

Sorry, I thought I've applied it and pushed, but clearly I didn't.
Thanks for the reminder!

Thanks,
Eryu

> 
> On Fri, Sep 11, 2020 at 10:18:13AM +0800, Murphy Zhou wrote:
> > When nfs_export is enabled, the link count of upper dir
> > objects are more then the expected number in this testcase.
> > Because extra index entries are linked to upper inodes.
> > 
> > Signed-off-by: Murphy Zhou <jencce.kernel@gmail.com>
> > ---
> >  tests/overlay/073 | 4 +++-
> >  1 file changed, 3 insertions(+), 1 deletion(-)
> > 
> > diff --git a/tests/overlay/073 b/tests/overlay/073
> > index 37860c92..c5deccc6 100755
> > --- a/tests/overlay/073
> > +++ b/tests/overlay/073
> > @@ -99,7 +99,9 @@ run_test_case()
> >  {
> >  	_scratch_mkfs
> >  	make_lower_files ${1}
> > -	_scratch_mount -o "index=on"
> > +	# There will be extra hard links with nfs_export enabled which
> > +	# is expected. Turn it off explicitly to avoid the false alarm.
> > +	_scratch_mount -o "index=on,nfs_export=off"
> >  	make_whiteout_files
> >  	check_whiteout_files ${1} ${2}
> >  	_scratch_unmount
> > -- 
> > 2.20.1
> > 
> 
> -- 
> Murphy
