Return-Path: <SRS0=gqkc=57=vger.kernel.org=linux-unionfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 323C2C2BA19
	for <linux-unionfs@archiver.kernel.org>; Wed, 15 Apr 2020 19:42:53 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 016852076D
	for <linux-unionfs@archiver.kernel.org>; Wed, 15 Apr 2020 19:42:52 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="RgjX53K+"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2441831AbgDOTmw (ORCPT
        <rfc822;linux-unionfs@archiver.kernel.org>);
        Wed, 15 Apr 2020 15:42:52 -0400
Received: from us-smtp-2.mimecast.com ([207.211.31.81]:55145 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S2441830AbgDOTmv (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Wed, 15 Apr 2020 15:42:51 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1586979769;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=c/BeKJYtGQPTDZCCUkoO9f4rX1uJxBBnQojc3TBZxkY=;
        b=RgjX53K+QWw76yWxIOEXAN/urgBugaUXgcenQ5svhmYuRaBE+WAfU8lXrJ0Qbtg1+iej90
        6vXYPEB2xE/zjx+ah/mcgqAPCPnOTS0VxsTQUpoN4RSRPvLvgDKb+UPPKKgmDUVW8BkojZ
        KtJEpLQQMrE3BgiQZ6C4UgFR6E94Cxs=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-447-c3BB--skMfKiB-7YpxR4WA-1; Wed, 15 Apr 2020 15:42:46 -0400
X-MC-Unique: c3BB--skMfKiB-7YpxR4WA-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 4F7D21400;
        Wed, 15 Apr 2020 19:42:45 +0000 (UTC)
Received: from horse.redhat.com (ovpn-116-127.rdu2.redhat.com [10.10.116.127])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 6D028116D95;
        Wed, 15 Apr 2020 19:42:44 +0000 (UTC)
Received: by horse.redhat.com (Postfix, from userid 10451)
        id EB86D220935; Wed, 15 Apr 2020 15:42:43 -0400 (EDT)
Date:   Wed, 15 Apr 2020 15:42:43 -0400
From:   Vivek Goyal <vgoyal@redhat.com>
To:     Amir Goldstein <amir73il@gmail.com>
Cc:     Giuseppe Scrivano <gscrivan@redhat.com>,
        Miklos Szeredi <miklos@szeredi.hu>,
        overlayfs <linux-unionfs@vger.kernel.org>
Subject: Re: [PATCH 2/2] Configure custom layers via environment variables
Message-ID: <20200415194243.GE239514@redhat.com>
References: <20200415120134.28154-1-amir73il@gmail.com>
 <20200415120134.28154-3-amir73il@gmail.com>
 <20200415153032.GC239514@redhat.com>
 <CAOQ4uxhmxxjGGB3bBoK1OmcAWDsoNi3WdORtH7WDLOcp8=sYSQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAOQ4uxhmxxjGGB3bBoK1OmcAWDsoNi3WdORtH7WDLOcp8=sYSQ@mail.gmail.com>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
Sender: linux-unionfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-unionfs.vger.kernel.org>
X-Mailing-List: linux-unionfs@vger.kernel.org

On Wed, Apr 15, 2020 at 07:27:43PM +0300, Amir Goldstein wrote:
> On Wed, Apr 15, 2020 at 6:30 PM Vivek Goyal <vgoyal@redhat.com> wrote:
> >
> > On Wed, Apr 15, 2020 at 03:01:34PM +0300, Amir Goldstein wrote:
> > > The following environment variables are supported:
> > >
> > >  UNIONMOUNT_BASEDIR  - base dir for --samefs (default: /base)
> > >  UNIONMOUNT_UPPERDIR - upper layer root path (default: /upper)
> > >  UNIONMOUNT_LOWERDIR - lower layer root path (default: /lower)
> > >  UNIONMOUNT_MNTPOINT - mount point for tests (default: /mnt)
> > >
> > > User provided paths for base/lower/upper should point at a pre-mounted
> > > filesystem, whereas tmpfs instances will be created on default paths.
> > >
> > > This is going to be used for running unionmount tests from xfstests.
> >
> > Hi Amir,
> >
> > I don't understand this testsuite code. So I will ask.
> >
> > What's base dir?
> 
> Before these changes, with option --samefs, tmpfs is mounted
> at /base, overlay lowerdir is /base/lower and upperdir is /base/upper.
> After these changes, /base can be substituted with any pre mounted
> filesystem path.

If I can specify lower and upper root, then why do I need to specify
base directory. User can put lower, upper either on samefs or different
fs as need be.

IOW, either I need to specify base dir, so that lower and upper can
be setup by testsuite automatically. Or I need to specify lower and
upper and then base should not matter.

What am I missing.

> 
> >
> > So these options will allow me to specify lower directory, upper directory
> 
> Almost.
> 
> They let you specify lower fs root and upper fs root.
> Before these changes, tmpfs is mounted at /lower and this is used
> as overlay lowerdir.
> After these changes, /lower can be substituted with any pre mounted
> filesystem path.

Ok.

> 
> Situation for upperdir/workdir is a bit different (see below).
> 
> > and overlay mount point. User can specify these and testsuite will
> > mount overlay accordingly?
> >
> > What about overlay mount options. Should there be one option for that too.
> 
> Maybe. Currently the overlay mount options are determined by the various
> command line arguments, like --xino --meta --verify.
> The reason that testsuite does not let you use any combination of mount
> options is because the options (e.g. --meta) determine both how overlay is
> mounted and also how verification is done (see for example the is_metacopy
> case in check_copy_up()).
> 
> Do you have any requirement for specific overlay mount options you
> would like to test?

No, I don't have any requirements yet. Just thought that providing
extra flexibility will be good. At the same time I understand that
tests are tied to specific config, hence mount options. If we allow
override, suddenly many tests will start failing.

> 
> >
> > Assuming workdir is automatically determined.
> >
> 
> Yes. Before these changes, tmpfs is mounted at /upper.
> The directories /upper/0/u /upper/0/w are used as upperdir/workdir with
> single layer.
> With multiple layers (e.g. ov=2) more directories can be created, like
> /upper/1/{u,w}.
> After these changes, tmpfs /upper can be substituted with any pre
> mounted filesystem path.
> 
> Hope this is clear now.

Yes. Thanks.

Vivek

> See example is how xfstests make use of those variable to use
> the test and scratch partitions for lower and upper fs:
> https://github.com/amir73il/xfstests/commit/a36f476a04c5af5100141c3ff9938d0c2f93018d#diff-7892ac2dd3f989038dfaa2e708ab12e2R386
> 
> Thanks,
> Amir.
> 

