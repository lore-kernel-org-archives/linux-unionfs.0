Return-Path: <SRS0=wxOy=BA=vger.kernel.org=linux-unionfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-4.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 79DB1C433E5
	for <linux-unionfs@archiver.kernel.org>; Tue, 21 Jul 2020 13:51:34 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 57A8B206E9
	for <linux-unionfs@archiver.kernel.org>; Tue, 21 Jul 2020 13:51:34 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="YTCvJpfe"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726949AbgGUNve (ORCPT
        <rfc822;linux-unionfs@archiver.kernel.org>);
        Tue, 21 Jul 2020 09:51:34 -0400
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:33267 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726506AbgGUNvd (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Tue, 21 Jul 2020 09:51:33 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1595339492;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=yprAtR9XHlpKxtrX4jYo/Pn8Fvvc3FitPJ8aeq1QjJQ=;
        b=YTCvJpfed8w1ESKhKLgDHzNHk9yA5M4hyAspWlNurlWGhVGD6yF2aPIhoR1YX6fbJwrFN5
        BWd93r6IQGfJKCyAfwxbHfCDCdD0kEkloaCYY9LPQwhPKda18615m0RK3gmbSG3cwGf5nZ
        WaWT3mzM3za2ICPe0P5J1Y4o12ZoYvE=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-420--NV0K4yrM8CkWrY-Upp5Fg-1; Tue, 21 Jul 2020 09:51:28 -0400
X-MC-Unique: -NV0K4yrM8CkWrY-Upp5Fg-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id A71F918FF687;
        Tue, 21 Jul 2020 13:51:27 +0000 (UTC)
Received: from horse.redhat.com (ovpn-116-14.rdu2.redhat.com [10.10.116.14])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 02B3D2DE6F;
        Tue, 21 Jul 2020 13:51:24 +0000 (UTC)
Received: by horse.redhat.com (Postfix, from userid 10451)
        id 8CED4223C1E; Tue, 21 Jul 2020 09:51:23 -0400 (EDT)
Date:   Tue, 21 Jul 2020 09:51:23 -0400
From:   Vivek Goyal <vgoyal@redhat.com>
To:     Miklos Szeredi <miklos@szeredi.hu>
Cc:     Amir Goldstein <amir73il@gmail.com>,
        overlayfs <linux-unionfs@vger.kernel.org>,
        Giuseppe Scrivano <gscrivan@redhat.com>,
        Daniel J Walsh <dwalsh@redhat.com>,
        Steven Whitehouse <swhiteho@redhat.com>, pmatilai@redhat.com,
        sandeen@redhat.com
Subject: Re: [PATCH v4] overlayfs: Provide mount options sync=off/fs to skip
 sync
Message-ID: <20200721135123.GA551452@redhat.com>
References: <20200706161227.GB3107@redhat.com>
 <CAJfpegtBjv60ZYJYSgQfU9EFx+eMbjqzcZ1HFV8P2nL64x5D2A@mail.gmail.com>
 <20200720161618.GD502563@redhat.com>
 <CAJfpegt2k=r6TRok57tKPcLyUhCBOcBAV7bgLSPrQYXsPoPkpQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAJfpegt2k=r6TRok57tKPcLyUhCBOcBAV7bgLSPrQYXsPoPkpQ@mail.gmail.com>
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
Sender: linux-unionfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-unionfs.vger.kernel.org>
X-Mailing-List: linux-unionfs@vger.kernel.org

On Tue, Jul 21, 2020 at 03:15:55PM +0200, Miklos Szeredi wrote:
> On Mon, Jul 20, 2020 at 6:16 PM Vivek Goyal <vgoyal@redhat.com> wrote:
> 
> > For building images containers folks need to sync upper layer. Their
> > current plan is to use "syncfs upper/" because it is same as if overlay
> > was mounted with sync=fs. But this syncs whole upper filesystem and
> > not just upper of a particular overlayfs instance
> >
> > So idea was to provide sync=fs from the beginning and ask container
> > folks to use this. So that in future if we can optimize sync=fs to
> > sync selctive inodes, then container runtime will automatically
> > benefit from it without any changes. It also reduces the chances
> > of error on container runtime which fail to sync upper.  Hence idea
> > of sync=fs sounded appleaing to me.
> 
> Not sure I understand the reason for sync=fs?  Should it rather be
> sync=shutdown?
> 
> >
> > Havid said that, I am open to dropping sync=fs for now, if you don't
> > see the value at this point of time.
> 
> At this point it doesn't add any usefulness, so let's just drop it.

Ok, Will drop it.

> 
> > >
> > > Naming: I'm not at all convinced by any name having "sync" in it.  I
> > > think "sync=no" is about the implementation, not the functionality,
> > > and so it's confusing. The functionality is better described by
> > > "volatile" or "temporary".   But I can live with sync=... if voted
> > > down.
> >
> > I am fine with the name "volatile/temporary" for sync=off.
> 
> How about needing "volatile" for all kinds of modes that reduce the
> normal durability/integrity guarantees.  Then additional "sync=foobar"
> option to control the details?

Sounds good. For now I will just implement "volatile" which is equivalent
of sync=off. One can implement "volatile,sync=shutdown" in future if
need be.

Thanks
Vivek

