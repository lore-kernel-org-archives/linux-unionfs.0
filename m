Return-Path: <SRS0=2h5r=7E=vger.kernel.org=linux-unionfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B8F1EC433E0
	for <linux-unionfs@archiver.kernel.org>; Fri, 22 May 2020 14:36:17 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 8B6222100A
	for <linux-unionfs@archiver.kernel.org>; Fri, 22 May 2020 14:36:17 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="I1GUvW32"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730028AbgEVOgR (ORCPT
        <rfc822;linux-unionfs@archiver.kernel.org>);
        Fri, 22 May 2020 10:36:17 -0400
Received: from us-smtp-2.mimecast.com ([207.211.31.81]:25299 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1729879AbgEVOgQ (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Fri, 22 May 2020 10:36:16 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1590158174;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=zyTmwuCY/QLhIimMkL6uAM3oV1If1lzoHpJJ7rLGnwU=;
        b=I1GUvW32i7CugZkUgIrUNIuaTegzCmqc627p6uPSwRWCBUDVZ/m+a462DGEqZZ769FXGud
        71n1aU1dsEWP5vmqvAnnjStJkLkp5cRCVqqjSeYhKoDrtlzpGN54kyQp9yqDKSo6FpJayg
        5X/juBl5orY/+aOF0fxXFmmT7oPCN3k=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-439-_5a3oHPJOVSODNUG5c-QYg-1; Fri, 22 May 2020 10:36:08 -0400
X-MC-Unique: _5a3oHPJOVSODNUG5c-QYg-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id DF55B8463A1;
        Fri, 22 May 2020 14:36:06 +0000 (UTC)
Received: from horse.redhat.com (ovpn-115-124.rdu2.redhat.com [10.10.115.124])
        by smtp.corp.redhat.com (Postfix) with ESMTP id B84165C1D0;
        Fri, 22 May 2020 14:36:06 +0000 (UTC)
Received: by horse.redhat.com (Postfix, from userid 10451)
        id 279B022036E; Fri, 22 May 2020 10:36:06 -0400 (EDT)
Date:   Fri, 22 May 2020 10:36:06 -0400
From:   Vivek Goyal <vgoyal@redhat.com>
To:     Amir Goldstein <amir73il@gmail.com>
Cc:     Giuseppe Scrivano <gscrivan@redhat.com>,
        Miklos Szeredi <miklos@szeredi.hu>,
        overlayfs <linux-unionfs@vger.kernel.org>
Subject: Re: [PATCH 2/2] Configure custom layers via environment variables
Message-ID: <20200522143606.GB58162@redhat.com>
References: <20200415153032.GC239514@redhat.com>
 <CAOQ4uxhmxxjGGB3bBoK1OmcAWDsoNi3WdORtH7WDLOcp8=sYSQ@mail.gmail.com>
 <20200415194243.GE239514@redhat.com>
 <CAOQ4uxjZ4Yd3ZWi+Fe64fVkrD=XMDjF1=C=XN_PNdywbGx_gzQ@mail.gmail.com>
 <20200416125807.GB276932@redhat.com>
 <CAOQ4uxi=mT2JYGSXro5YW8gTE5256cxauBddYe2HXM=ZfZ=+ZA@mail.gmail.com>
 <CAOQ4uxjvtGLn=SvLXy3KU6uKbonBUznL==OjdVVjjB6sM=-mgg@mail.gmail.com>
 <20200420191453.GA21057@redhat.com>
 <CAOQ4uxjVU6gcQMmyMiBsVV73gik931-7QjAO9TCu+N2ik6109w@mail.gmail.com>
 <CAOQ4uxgVnT3ZXZZa4-YktZaRDpU1hHujPoEtZ2vdFmsGxj=66A@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAOQ4uxgVnT3ZXZZa4-YktZaRDpU1hHujPoEtZ2vdFmsGxj=66A@mail.gmail.com>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
Sender: linux-unionfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-unionfs.vger.kernel.org>
X-Mailing-List: linux-unionfs@vger.kernel.org

On Sun, May 17, 2020 at 11:45:59AM +0300, Amir Goldstein wrote:
> > >
> > > What's most intuitive to me is this.
> > >
> > > - If user only specifies UNIONMOUNT_BASEDIR, all layers (lower, upper,
> > >   work and even mount point) comes from that directory.
> >
> > OK.
> >
> > >
> > > - If user specifies both UNIONMOUNT_LOWERDIR and UNIONMOUNT_BASEDIR, then
> > >   lower layer path comes from UNIONMOUNT_LOWERDIR and rest of the layers
> > >   come from UNIONMOUNT_BASEDIR.
> >
> > DONE.
> >
> > >
> > > - If user specifies UNIONMOUNT_MNTPOINT, it is used as overlay mount
> > >   point. Otherwise one is selected from UNIONMOUNT_BASEDIR if user
> > >   specified one. Otherwise "/mnt" is the default.
> > >
> >
> > OK.
> >
> 
> Vivek,
> 
> I finally got around to implementing your suggestion (see [1]).
> 
> Quoting from README:
> 
>      When user provides UNIONMOUNT_LOWERDIR:
> 
>      1) Path should be an existing directory whose content will be deleted.
>      2) Path is assumed to be on a different filesystem than base dir, so
>         --samefs setup is not supported.
> 
>      When user provides UNIONMOUNT_BASEDIR:
> 
>      1) Path should be an existing directory whose content will be deleted.
>      2) If UNIONMOUNT_MNTPOINT is not provided, the overlay mount point will
>         be created under base dir.
>      3) If UNIONMOUNT_LOWERDIR is not provided, the lower layer dir will be
>         created under base dir.
>      4) If UNIONMOUNT_LOWERDIR is not provided, the test setup defaults to
>         --samefs (i.e. lower and upper are on the same base fs).  However,
>         if --maxfs=<M> is specified, a tmpfs instance will be created for
>         the lower layer dir.

Hi Amir,

Do you want to mention a word upper dir also when UNIONMOUNT_BASEDIR. That
is upperdir is also created under UNIONMOUNT_BASEDIR. IOW, all directories
lower, upper and mount point are under UNIONMOUNT_BASEDIR (until and
unless overridden by other environment variables).

For point 4, I understand that we will mount multiple instances of
tmpfs because maxfs tests on multiple different filessytems. I am
assuming that we will be creating lowerdir mount points under
UNIONMOUNT_BASEDIR for --maxfs.

I think this looks pretty good. Just one more thing. Is there a way to
specify multiple lowerdirs as well. If not, may be in future we can
add it once somebody needs to specify multiple lowerdirs.

Thanks
Vivek

> ----
> 
> I realize this last item (4) is a bit tricky.
> Let me know if you think it needs further clarification.
> 
> Thanks,
> Amir.
> 
> 
> [1] https://github.com/amir73il/unionmount-testsuite/commits/envvars
> 

