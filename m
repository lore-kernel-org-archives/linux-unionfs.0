Return-Path: <SRS0=DrFc=7O=vger.kernel.org=linux-unionfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3A531C433DF
	for <linux-unionfs@archiver.kernel.org>; Mon,  1 Jun 2020 17:51:40 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 09CEB206E2
	for <linux-unionfs@archiver.kernel.org>; Mon,  1 Jun 2020 17:51:40 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="G8VIzI2m"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726125AbgFARvj (ORCPT
        <rfc822;linux-unionfs@archiver.kernel.org>);
        Mon, 1 Jun 2020 13:51:39 -0400
Received: from us-smtp-2.mimecast.com ([207.211.31.81]:37533 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726073AbgFARvj (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Mon, 1 Jun 2020 13:51:39 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1591033898;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=FYmd6WaJ/uQnE3uDf+XzuHMf295G+CWbqLsmFlYHTqI=;
        b=G8VIzI2m+gp7vUYFacpeXjkKkD8L+AGVpPOTUiZai0Ob38MXzxqwRcJPV4HiNwlrvvzolM
        Xz4gJLpV4vq8havremGz6aaVIHEDrZm8pv0aOm8xrQ5qwwKmfpS4zMUt+5CuInwRVLZVVF
        uQepJ6R/4pmpTv24/oMFyjyBkmSjg8E=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-251-Z_JugDurMemI82D5myCHWw-1; Mon, 01 Jun 2020 13:51:31 -0400
X-MC-Unique: Z_JugDurMemI82D5myCHWw-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 2BA3219057A6;
        Mon,  1 Jun 2020 17:51:30 +0000 (UTC)
Received: from horse.redhat.com (ovpn-115-117.rdu2.redhat.com [10.10.115.117])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 0D07060C47;
        Mon,  1 Jun 2020 17:51:30 +0000 (UTC)
Received: by horse.redhat.com (Postfix, from userid 10451)
        id 8303D220244; Mon,  1 Jun 2020 13:51:29 -0400 (EDT)
Date:   Mon, 1 Jun 2020 13:51:29 -0400
From:   Vivek Goyal <vgoyal@redhat.com>
To:     Amir Goldstein <amir73il@gmail.com>
Cc:     Miklos Szeredi <miklos@szeredi.hu>,
        yangerkun <yangerkun@huawei.com>,
        overlayfs <linux-unionfs@vger.kernel.org>
Subject: Re: [PATCH 1/3] overlayfs: Simplify setting of origin for index
 lookup
Message-ID: <20200601175129.GD3219@redhat.com>
References: <20200529212952.214175-1-vgoyal@redhat.com>
 <20200529212952.214175-2-vgoyal@redhat.com>
 <CAOQ4uxj=MoKfo32tz8zmxf13gheDt+y1DZ3-oznY9YX=DhWiFg@mail.gmail.com>
 <20200601140446.GA3219@redhat.com>
 <CAOQ4uxj-r5kpOTRx9BV+hcS7sk0TGnWR0vGzSpEENLn_ZHeXWg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAOQ4uxj-r5kpOTRx9BV+hcS7sk0TGnWR0vGzSpEENLn_ZHeXWg@mail.gmail.com>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
Sender: linux-unionfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-unionfs.vger.kernel.org>
X-Mailing-List: linux-unionfs@vger.kernel.org

On Mon, Jun 01, 2020 at 06:15:44PM +0300, Amir Goldstein wrote:

[..]
> > > But see one improvement below.
> > > Also, please make sure to run unionmount setups:
> > >
> > > ./run --ov=10 --verify
> > > ./run --ov=10 --meta --verify
> > >
> > > --verify will enable index and check st_dev;st_ino are not broken
> > > on copy up. --ov=10 will cause lower hardlink copy up, because
> > > after hardlink is creates by some test, upper is rotated to mid layer
> > > and next modifying operation will trigger the hardlink copy up.
> >
> > Hi Amir,
> >
> > I ran above configurations and it passes with the patches.
> >
> > Thanks for these suggestions. I used to run only "./run --ov" so far.
> > It will be nice to have some documentation about --meta, --verify in README.
> >
> 
> Yeh, I never get to it.
> But now I finally posted xfstest integration, so we can just add more
> xfstests to run metacopy configurations on a full test cycle.

Yes, I saw those patches. Very nice. Will be good to run all overlay
tests from single place. Once your patches get merged, I definitely
want to add some more tests to run "--meta" tests.

Vivek

