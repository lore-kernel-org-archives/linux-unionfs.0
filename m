Return-Path: <SRS0=N6pz=6A=vger.kernel.org=linux-unionfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 28226C2BB55
	for <linux-unionfs@archiver.kernel.org>; Thu, 16 Apr 2020 12:58:48 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id F40F921973
	for <linux-unionfs@archiver.kernel.org>; Thu, 16 Apr 2020 12:58:47 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="A+ofZdTF"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2894655AbgDPM6r (ORCPT
        <rfc822;linux-unionfs@archiver.kernel.org>);
        Thu, 16 Apr 2020 08:58:47 -0400
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:60362 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S2894447AbgDPM6o (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Thu, 16 Apr 2020 08:58:44 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1587041922;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=yx6dwUsZ+7nDgJmMx1OxNb/rWhvBN4uOyxAL93kfBo8=;
        b=A+ofZdTF4LcaPIrGO+6Qk2figU3Kkv136cAQsupWTc4hWDPNTMcr78huf2OSH+iiI0/WQq
        lNkDe/gZtRcFkwIn2DYigMTEOx6iQRj+l33oS6SgOYTTxI/01Xjsxrrh8W1wVwH4oAa+69
        EAuoMpkFl7EtRo85LqC3tAxOwDFYQuk=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-52-sLWQ_cyYNdKvMFaUFT8hrA-1; Thu, 16 Apr 2020 08:58:40 -0400
X-MC-Unique: sLWQ_cyYNdKvMFaUFT8hrA-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 8DAD018FF664;
        Thu, 16 Apr 2020 12:58:09 +0000 (UTC)
Received: from horse.redhat.com (ovpn-116-15.rdu2.redhat.com [10.10.116.15])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 1782B7E7DD;
        Thu, 16 Apr 2020 12:58:08 +0000 (UTC)
Received: by horse.redhat.com (Postfix, from userid 10451)
        id 839FA220537; Thu, 16 Apr 2020 08:58:07 -0400 (EDT)
Date:   Thu, 16 Apr 2020 08:58:07 -0400
From:   Vivek Goyal <vgoyal@redhat.com>
To:     Amir Goldstein <amir73il@gmail.com>
Cc:     Giuseppe Scrivano <gscrivan@redhat.com>,
        Miklos Szeredi <miklos@szeredi.hu>,
        overlayfs <linux-unionfs@vger.kernel.org>
Subject: Re: [PATCH 2/2] Configure custom layers via environment variables
Message-ID: <20200416125807.GB276932@redhat.com>
References: <20200415120134.28154-1-amir73il@gmail.com>
 <20200415120134.28154-3-amir73il@gmail.com>
 <20200415153032.GC239514@redhat.com>
 <CAOQ4uxhmxxjGGB3bBoK1OmcAWDsoNi3WdORtH7WDLOcp8=sYSQ@mail.gmail.com>
 <20200415194243.GE239514@redhat.com>
 <CAOQ4uxjZ4Yd3ZWi+Fe64fVkrD=XMDjF1=C=XN_PNdywbGx_gzQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAOQ4uxjZ4Yd3ZWi+Fe64fVkrD=XMDjF1=C=XN_PNdywbGx_gzQ@mail.gmail.com>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
Sender: linux-unionfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-unionfs.vger.kernel.org>
X-Mailing-List: linux-unionfs@vger.kernel.org

On Thu, Apr 16, 2020 at 10:10:35AM +0300, Amir Goldstein wrote:
> On Wed, Apr 15, 2020 at 10:42 PM Vivek Goyal <vgoyal@redhat.com> wrote:
> >
> > On Wed, Apr 15, 2020 at 07:27:43PM +0300, Amir Goldstein wrote:
> > > On Wed, Apr 15, 2020 at 6:30 PM Vivek Goyal <vgoyal@redhat.com> wrote:
> > > >
> > > > On Wed, Apr 15, 2020 at 03:01:34PM +0300, Amir Goldstein wrote:
> > > > > The following environment variables are supported:
> > > > >
> > > > >  UNIONMOUNT_BASEDIR  - base dir for --samefs (default: /base)
> > > > >  UNIONMOUNT_UPPERDIR - upper layer root path (default: /upper)
> > > > >  UNIONMOUNT_LOWERDIR - lower layer root path (default: /lower)
> > > > >  UNIONMOUNT_MNTPOINT - mount point for tests (default: /mnt)
> > > > >
> > > > > User provided paths for base/lower/upper should point at a pre-mounted
> > > > > filesystem, whereas tmpfs instances will be created on default paths.
> > > > >
> > > > > This is going to be used for running unionmount tests from xfstests.
> > > >
> > > > Hi Amir,
> > > >
> > > > I don't understand this testsuite code. So I will ask.
> > > >
> > > > What's base dir?
> > >
> > > Before these changes, with option --samefs, tmpfs is mounted
> > > at /base, overlay lowerdir is /base/lower and upperdir is /base/upper.
> > > After these changes, /base can be substituted with any pre mounted
> > > filesystem path.
> >
> > If I can specify lower and upper root, then why do I need to specify
> > base directory. User can put lower, upper either on samefs or different
> > fs as need be.
> >
> > IOW, either I need to specify base dir, so that lower and upper can
> > be setup by testsuite automatically. Or I need to specify lower and
> > upper and then base should not matter.
> >
> > What am I missing.
> >
> 
> Not much, as it stands, with option --samefs, UNIONMOUNT_BASEDIR
> is used and without --samefs UNIONMOUNT_LOWERDIR and
> UNIONMOUNT_UPPERDIR used instead.
> 
> I agree that this a bit lame and non intuitive way to configure.
> The reason for explicit --samefs option (vs. providing upper and lower
> root from same fs) is, again, for the test sanity checks which differ
> for is_samefs() case.
> 
> I think what I will do is I will get rid of UNIONMOUNT_UPPERDIR
> because this name is a bit confusing. It is not the overlay upperdir,
> it is the grandfather of upperdir/workdir. So I might as well call
> this config UNIONMOUNT_BASEDIR and use it also as the parent
> of lowerdir in --samefs tests.

How about calling upper/work root as UNIONMOUNT_UPPER_WORK_ROOT instead.
That's more intuitive as oppsed to BASEDIR. But I understand that due 
to legacy reasons there must be many other assumptions in the code so
it might not be trivial.

What will help though, that document these options well, so that
those who don't read the code and still understand use different
config options.

> 
> The config UNIONMOUNT_LOWERDIR will remain, but it will only
> be relevant to tests without --samefs.
> 
> IOW, you won't need the fstab bind mount trick and you won't need
> to use the magic suffix "lower_layer" anymore. You could set:
>   UNIONMOUNT_BASEDIR=/mnt/virtiofs
> 
> to run --ov --samefs --verify tests.

If I specify UNIONMOUNT_BASEDIR, then --samefs should be implied?

Thanks
Vivek

> 
> If you want to run test with virtio fs as upper (single or multi layers)
> and lower as another fs, you could additionally set:
>   UNIONMOUNT_LOWERDIR=/mnt/anotherfs
> 
> and run --ov --verify tests.
> 
> Thanks for the feedback!
> Amir.
> 

