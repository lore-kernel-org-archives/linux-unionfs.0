Return-Path: <SRS0=uZ0x=7I=vger.kernel.org=linux-unionfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 489B9C433DF
	for <linux-unionfs@archiver.kernel.org>; Tue, 26 May 2020 12:54:09 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 1D20D20787
	for <linux-unionfs@archiver.kernel.org>; Tue, 26 May 2020 12:54:09 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="PHM3GXyS"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729123AbgEZMyI (ORCPT
        <rfc822;linux-unionfs@archiver.kernel.org>);
        Tue, 26 May 2020 08:54:08 -0400
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:26019 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1729016AbgEZMyI (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Tue, 26 May 2020 08:54:08 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1590497647;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=nZg/ji17BvSzlCNz1HhexNAbhuZqvtbxh/CfeBU6veA=;
        b=PHM3GXySGQmlxODRDgFtn5qhwUpc02Ei6bJVXG4Uwj7gHD3LvAVLpGlRKwLEmN96EJyRAV
        5aTs8Lo7vq1ZUMOgoE27wehNhOFWgubMrUEt99H2O2DNPhiv4WAId1AIGFrd9tZHq/Dp41
        Pf3rPuMyiV8CbDIA7b6Nt328PzU2b/E=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-216-Lnmh86zXPh2Vzohz67xDxQ-1; Tue, 26 May 2020 08:54:05 -0400
X-MC-Unique: Lnmh86zXPh2Vzohz67xDxQ-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 6B33E108C30D;
        Tue, 26 May 2020 12:54:04 +0000 (UTC)
Received: from horse.redhat.com (ovpn-115-102.rdu2.redhat.com [10.10.115.102])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 496C519D61;
        Tue, 26 May 2020 12:54:04 +0000 (UTC)
Received: by horse.redhat.com (Postfix, from userid 10451)
        id 7F65222036E; Tue, 26 May 2020 08:54:03 -0400 (EDT)
Date:   Tue, 26 May 2020 08:54:03 -0400
From:   Vivek Goyal <vgoyal@redhat.com>
To:     Amir Goldstein <amir73il@gmail.com>
Cc:     Giuseppe Scrivano <gscrivan@redhat.com>,
        Miklos Szeredi <miklos@szeredi.hu>,
        overlayfs <linux-unionfs@vger.kernel.org>
Subject: Re: [PATCH 2/2] Configure custom layers via environment variables
Message-ID: <20200526125403.GC108774@redhat.com>
References: <CAOQ4uxjZ4Yd3ZWi+Fe64fVkrD=XMDjF1=C=XN_PNdywbGx_gzQ@mail.gmail.com>
 <20200416125807.GB276932@redhat.com>
 <CAOQ4uxi=mT2JYGSXro5YW8gTE5256cxauBddYe2HXM=ZfZ=+ZA@mail.gmail.com>
 <CAOQ4uxjvtGLn=SvLXy3KU6uKbonBUznL==OjdVVjjB6sM=-mgg@mail.gmail.com>
 <20200420191453.GA21057@redhat.com>
 <CAOQ4uxjVU6gcQMmyMiBsVV73gik931-7QjAO9TCu+N2ik6109w@mail.gmail.com>
 <CAOQ4uxgVnT3ZXZZa4-YktZaRDpU1hHujPoEtZ2vdFmsGxj=66A@mail.gmail.com>
 <20200522143606.GB58162@redhat.com>
 <CAOQ4uxj8Qhw-r8E+Fb-YYnMwmApkCPXD1136CA=oNo-81rzdVQ@mail.gmail.com>
 <CAOQ4uxgnRFZ8uTWV1_woCFutACc193X9eTzTOn4wzDkE8-huDQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAOQ4uxgnRFZ8uTWV1_woCFutACc193X9eTzTOn4wzDkE8-huDQ@mail.gmail.com>
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
Sender: linux-unionfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-unionfs.vger.kernel.org>
X-Mailing-List: linux-unionfs@vger.kernel.org

On Sun, May 24, 2020 at 01:28:44PM +0300, Amir Goldstein wrote:
> > > Hi Amir,
> > >
> > > Do you want to mention a word upper dir also when UNIONMOUNT_BASEDIR. That
> > > is upperdir is also created under UNIONMOUNT_BASEDIR. IOW, all directories
> > > lower, upper and mount point are under UNIONMOUNT_BASEDIR (until and
> > > unless overridden by other environment variables).
> >
> 
> Hi Vivek,
> 
> Please approve this text before I update master.
> Pushed this work to branch 'envvars'

Hi Amir,

This looks good to me. Thank you for providing these environment
variables. Helps me run these tests on top of virtiofs now.

Vivek

> 
> Thanks,
> Amir.
> 
> -----
> The following environment variables are supported:
> 
>      UNIONMOUNT_BASEDIR  - parent dir of all samefs layers (default: /base)
>      UNIONMOUNT_LOWERDIR - lower layer path for non samefs (default: /lower)
>      UNIONMOUNT_MNTPOINT - mount point for executing tests (default: /mnt)
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
>      2) Upper layer and middle layers will be created under base dir.
>      3) If UNIONMOUNT_MNTPOINT is not provided, the overlay mount point will
>         be created under base dir.
>      4) If UNIONMOUNT_LOWERDIR is not provided, the lower layer dir will be
>         created under base dir.
>      5) If UNIONMOUNT_LOWERDIR is not provided, the test setup defaults to
>         --samefs (i.e. lower and upper layers are on the same base fs).
>         However, if --maxfs=<M> is specified, a tmpfs instance will be mounted
>         on the lower layer dir that was created under base dir.
> 

