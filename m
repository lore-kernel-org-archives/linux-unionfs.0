Return-Path: <SRS0=1hX+=AA=vger.kernel.org=linux-unionfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2B5A3C433E1
	for <linux-unionfs@archiver.kernel.org>; Fri, 19 Jun 2020 14:22:36 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 0D07B208C7
	for <linux-unionfs@archiver.kernel.org>; Fri, 19 Jun 2020 14:22:36 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="CwQqRBbj"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730785AbgFSOWf (ORCPT
        <rfc822;linux-unionfs@archiver.kernel.org>);
        Fri, 19 Jun 2020 10:22:35 -0400
Received: from us-smtp-1.mimecast.com ([205.139.110.61]:57233 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1731028AbgFSOWa (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Fri, 19 Jun 2020 10:22:30 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1592576549;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=ih3E/vQdfsH0+eHIbSVo6cGU0b3QkTn9OdRnprGTJ8A=;
        b=CwQqRBbjGOwt4FheOnM7ErCCWE46L4zAvLKdlNYMMMeX7eVUVumDkV4V6OBAKfoRkecdbt
        3fQuYLO09bRB8PCV5PK+QetfHvYaVbKT4pxRJKlOuMROjTRdwQxuimUfxSKy2AB01z0zfC
        QI1jTE4uOgunxUHaqd1ZY6luuMCnduA=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-440-w_dZsx5YPkCMaR5ZUi1tnA-1; Fri, 19 Jun 2020 10:22:25 -0400
X-MC-Unique: w_dZsx5YPkCMaR5ZUi1tnA-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 722F9107ACCA;
        Fri, 19 Jun 2020 14:21:53 +0000 (UTC)
Received: from horse.redhat.com (ovpn-114-35.rdu2.redhat.com [10.10.114.35])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 556127BA1A;
        Fri, 19 Jun 2020 14:21:53 +0000 (UTC)
Received: by horse.redhat.com (Postfix, from userid 10451)
        id D9E17220390; Fri, 19 Jun 2020 10:21:52 -0400 (EDT)
Date:   Fri, 19 Jun 2020 10:21:52 -0400
From:   Vivek Goyal <vgoyal@redhat.com>
To:     Amir Goldstein <amir73il@gmail.com>
Cc:     overlayfs <linux-unionfs@vger.kernel.org>,
        Miklos Szeredi <miklos@szeredi.hu>
Subject: Re: [ANNOUNCE] unionmount-testsuite: master branch updated to 9c60a9c
Message-ID: <20200619142152.GA3154@redhat.com>
References: <20200529164058.4654-1-amir73il@gmail.com>
 <20200618213831.GF3814@redhat.com>
 <CAOQ4uxi8a1sLc_5j2RcYZL0ZSHnBhufhLkr92FmXv33KjX7qsA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAOQ4uxi8a1sLc_5j2RcYZL0ZSHnBhufhLkr92FmXv33KjX7qsA@mail.gmail.com>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
Sender: linux-unionfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-unionfs.vger.kernel.org>
X-Mailing-List: linux-unionfs@vger.kernel.org

On Fri, Jun 19, 2020 at 06:29:08AM +0300, Amir Goldstein wrote:

[..]
> > Hi Amir,
> >
> > I am running these tests with.
> >
> > UNIONMOUNT_BASEDIR="/mnt/foo/"
> 
> I suspect there is a bug with trailing / in UNIONMOUNT_BASEDIR
> I did not test with trailing /
> Can you try without it?

Hi Amir,

This indeed is trailing / issue. I removed it and things are working fine.

> 
> >
> > - ./run --ov runs fine. But when I try to run it again it complains
> >   that.
> >
> >   rm: cannot remove '/mnt/overlayfs//m': Device or resource busy
> >
> > So I have to first unmount /mnt/overlayfs/m/ and then run tests
> > again.
> >
> > I think it will be nice if it can clear the environment by itself.
> >
> 
> It should.
> All the tests I tried cleaned up previous test env automatically.
> The only case where explicit cleanup is needed is before changing
> context and modifying envvars.

After removing trailing /, cleanup was fine too.

> 
> > - I am running one the recent kernel (5.7.0+) and following errors
> >   out.
> >
> > # ./run --ov --verify
> > Environment variables:
> > UNIONMOUNT_BASEDIR=/mnt/overlayfs/
> >
> > ***
> > *** ./run --ov --samefs --ts=0 open-plain
> > ***
> > TEST open-plain.py:10: Open O_RDONLY
> > /mnt/overlayfs/m/a/foo100: not on union mount
> >
> > Will spend more time to figure out what happened.
> >
> > - I am planning to use these environment variables and run overlay over
> >   virtiofs tests. Can I do the same thing with xfstests overlay tests.
> >   In README.overlay I see that I need to specify two separate devices.
> >   Can I specify to directories (and not devices) to be used as TEST
> >   and SCRATCH and run overlay test.
> 
> As far as I can tell, SCRATCH_DEV and TEST_DEV are directories
> in all those non-block filesystems including virtiofs:
> _scratch_mkfs()
> ...
>       case $FSTYP in
>         nfs*|cifs|ceph|overlay|glusterfs|pvfs2|9p|virtiofs)
>                 # unable to re-create this fstyp, just remove all files in
>                 # $SCRATCH_MNT to avoid EEXIST caused by the leftover files
>                 # created in previous runs
>                 _scratch_cleanup_files
> 
> So I think you just need to set SCRATCH_DEV and TEST_DEV to
> two different directories and you are good to go for running
> check or check -overlay.

It seems to work. I am seeing bunch of failures but that probably 
are issues with virtiofs and overlayfs interaction. Will look into
these one by one.

Thanks
Vivek

