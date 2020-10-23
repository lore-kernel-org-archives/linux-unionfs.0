Return-Path: <SRS0=pzJs=D6=vger.kernel.org=linux-unionfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.6 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E556DC388F9
	for <linux-unionfs@archiver.kernel.org>; Fri, 23 Oct 2020 00:31:44 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 7A8D424631
	for <linux-unionfs@archiver.kernel.org>; Fri, 23 Oct 2020 00:31:44 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="U/ZEVNL1"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S373807AbgJWAbn (ORCPT
        <rfc822;linux-unionfs@archiver.kernel.org>);
        Thu, 22 Oct 2020 20:31:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41722 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S373805AbgJWAbn (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Thu, 22 Oct 2020 20:31:43 -0400
Received: from mail-pg1-x543.google.com (mail-pg1-x543.google.com [IPv6:2607:f8b0:4864:20::543])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 65635C0613CE;
        Thu, 22 Oct 2020 17:31:43 -0700 (PDT)
Received: by mail-pg1-x543.google.com with SMTP id s22so2083067pga.9;
        Thu, 22 Oct 2020 17:31:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=jl/GA1h9CU0xR4BzXSMHyC4YeuYB4slWr13tjKW6DmM=;
        b=U/ZEVNL13gYgTkT7AABf3svIH7VV/zY7Nqhjb7Egdat2uirNWAwjIbTqll7i0aRviZ
         JmhmF1N5KHS9ZXrujQGdZpGo3sEDnNQv2ShUh1zeG1ast7T6aSPiI62DYin/sEnrafHH
         d4nqNP1CU16kx64s2GZV+4Lcu2LPiGu+SbYhMma8xfbFjlUafaBg8wJRbjqbfEaOZ5x3
         zbkazW7UzTttLNwnSICWXWLI7Csa1LLrP69jsGmqTK1RwJj+iT0XIQ6cjN9o3kqqwtoZ
         60UwXQf94Mar0wX0Tc0votd0lGsTh8AoyQjrl1wqdZSrGe2cxvCuRgmvaWFgvvyNopqa
         73yw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=jl/GA1h9CU0xR4BzXSMHyC4YeuYB4slWr13tjKW6DmM=;
        b=dm3NJERsub1THtPqbTlmGHHFjvqR85581fwHkmHj0ZbOU7cY0pvXT39rCyX7sK8pLS
         HcdAZtUWKEX3Y/vg3WIZHIpxxO5L8eMSbqozCaK6F7baI8h96QcG6aL7pFmjxmhfoi7Y
         58SoxEoWno6Rj1smeMPFmjud/AEcr3Gt+fubuN+FvDnTl4LB2nFJ+4Iy10qx1MQH5AVB
         /QRDklEeiKZBFCZVNkVX0ufQ40GfAoFbzjl10Vzlg+hM7rzQ6JTBuo6QMTRF/+ZDvK0Q
         0U8wwmszpIVZMSI3d7vhuHULWr04bStGQTdWJgk0nJSTyqqz5nudgTfCfQUI2Ed3gcBb
         9svA==
X-Gm-Message-State: AOAM530AYmBirRup8UUZmTkE6dQtfXsJR6KTsBOpGodY1x76Q+U8c8FY
        wVqGo6Agy9X0ewCkDwTe9Txd8tgcHPc=
X-Google-Smtp-Source: ABdhPJz4ZzvODjaSJ5YgC74tbiHQ5wyPIMoW6AtiRlm0cmTAHf3l1xrSKVr4j+1/cBH2M/D45LSouw==
X-Received: by 2002:a17:90a:5d17:: with SMTP id s23mr5109463pji.170.1603413102977;
        Thu, 22 Oct 2020 17:31:42 -0700 (PDT)
Received: from localhost ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id w6sm3496679pgw.28.2020.10.22.17.31.41
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 22 Oct 2020 17:31:42 -0700 (PDT)
Date:   Fri, 23 Oct 2020 08:31:35 +0800
From:   Murphy Zhou <jencce.kernel@gmail.com>
To:     Eryu Guan <eguan@linux.alibaba.com>
Cc:     Murphy Zhou <jencce.kernel@gmail.com>,
        Amir Goldstein <amir73il@gmail.com>,
        fstests <fstests@vger.kernel.org>,
        Chengguang Xu <cgxu519@mykernel.net>,
        Miklos Szeredi <miklos@szeredi.hu>,
        overlayfs <linux-unionfs@vger.kernel.org>
Subject: Re: [PATCH v2] overlay/073: test with nfs_export being off
Message-ID: <20201023003135.w25522gphidf7gpn@xzhoux.usersys.redhat.com>
References: <CAOQ4uxh+ppPMOSeAZU3sdwxwb_ixMHEpHLF9ZO_MTiedNJRgsw@mail.gmail.com>
 <20200911021813.o6vtueabupevfgab@xzhoux.usersys.redhat.com>
 <20201020024538.tl7xenmmguhcj6af@xzhoux.usersys.redhat.com>
 <20201020052229.GL80581@e18g06458.et15sqa>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201020052229.GL80581@e18g06458.et15sqa>
Precedence: bulk
List-ID: <linux-unionfs.vger.kernel.org>
X-Mailing-List: linux-unionfs@vger.kernel.org

On Tue, Oct 20, 2020 at 01:22:29PM +0800, Eryu Guan wrote:
> On Tue, Oct 20, 2020 at 10:52:59AM +0800, Murphy Zhou wrote:
> > Ping on this one.
> 
> Queued for next update.
> 
> Sorry, I thought I've applied it and pushed, but clearly I didn't.
> Thanks for the reminder!

No warries :)

> 
> Thanks,
> Eryu
> 
> > 
> > On Fri, Sep 11, 2020 at 10:18:13AM +0800, Murphy Zhou wrote:
> > > When nfs_export is enabled, the link count of upper dir
> > > objects are more then the expected number in this testcase.
> > > Because extra index entries are linked to upper inodes.
> > > 
> > > Signed-off-by: Murphy Zhou <jencce.kernel@gmail.com>
> > > ---
> > >  tests/overlay/073 | 4 +++-
> > >  1 file changed, 3 insertions(+), 1 deletion(-)
> > > 
> > > diff --git a/tests/overlay/073 b/tests/overlay/073
> > > index 37860c92..c5deccc6 100755
> > > --- a/tests/overlay/073
> > > +++ b/tests/overlay/073
> > > @@ -99,7 +99,9 @@ run_test_case()
> > >  {
> > >  	_scratch_mkfs
> > >  	make_lower_files ${1}
> > > -	_scratch_mount -o "index=on"
> > > +	# There will be extra hard links with nfs_export enabled which
> > > +	# is expected. Turn it off explicitly to avoid the false alarm.
> > > +	_scratch_mount -o "index=on,nfs_export=off"
> > >  	make_whiteout_files
> > >  	check_whiteout_files ${1} ${2}
> > >  	_scratch_unmount
> > > -- 
> > > 2.20.1
> > > 
> > 
> > -- 
> > Murphy

-- 
Murphy
