Return-Path: <SRS0=sCFp=CC=vger.kernel.org=linux-unionfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-4.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 80262C433E3
	for <linux-unionfs@archiver.kernel.org>; Mon, 24 Aug 2020 13:40:16 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 5EEEC2063A
	for <linux-unionfs@archiver.kernel.org>; Mon, 24 Aug 2020 13:40:16 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="dZvyfaLs"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727881AbgHXNkP (ORCPT
        <rfc822;linux-unionfs@archiver.kernel.org>);
        Mon, 24 Aug 2020 09:40:15 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:33000 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727042AbgHXNjx (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Mon, 24 Aug 2020 09:39:53 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1598276391;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=l9BZF3aqKdBVdLakyk1NoyGsDsAPi1ZAtlC+Tg1ADoA=;
        b=dZvyfaLsE2vCoYQrjKCerPBnO4wsfqe36LFSTucmpowjJ6Y+qyjqDVj4h9xlLnDkXcsVCT
        HRZYXKSaEiYAhBV4Ipjpqt+pp/2yJD7r2Dsm23pssgCfCi7LhaBzqL6hgvCqGax5opFiMD
        17q1XDwmpnOReRZDlvJ4xhHHuFKdnyA=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-123-yXanYZa0PjeIKm8byZIyng-1; Mon, 24 Aug 2020 09:39:49 -0400
X-MC-Unique: yXanYZa0PjeIKm8byZIyng-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id BBE7881F00F;
        Mon, 24 Aug 2020 13:39:48 +0000 (UTC)
Received: from horse.redhat.com (ovpn-115-156.rdu2.redhat.com [10.10.115.156])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 9D1DE5C1BB;
        Mon, 24 Aug 2020 13:39:48 +0000 (UTC)
Received: by horse.redhat.com (Postfix, from userid 10451)
        id 36EB82256FC; Mon, 24 Aug 2020 09:39:48 -0400 (EDT)
Date:   Mon, 24 Aug 2020 09:39:48 -0400
From:   Vivek Goyal <vgoyal@redhat.com>
To:     Amir Goldstein <amir73il@gmail.com>
Cc:     Miklos Szeredi <miklos@szeredi.hu>,
        Giuseppe Scrivano <gscrivan@redhat.com>,
        overlayfs <linux-unionfs@vger.kernel.org>,
        Daniel J Walsh <dwalsh@redhat.com>,
        Steven Whitehouse <swhiteho@redhat.com>
Subject: Re: [PATCH v5] overlayfs: Provide a mount option "volatile" to skip
 sync
Message-ID: <20200824133948.GA963827@redhat.com>
References: <20200722175024.GA608248@redhat.com>
 <87h7svyqsd.fsf@redhat.com>
 <CAJfpegtA-16EFFoqhn25rVmXat5hhNUTAWOf+hJEs5L910oQzA@mail.gmail.com>
 <CAOQ4uxj0SF1VRbMEvVm4a9TuUtdMYuZqFkZhkUyEGMagCWk5NA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAOQ4uxj0SF1VRbMEvVm4a9TuUtdMYuZqFkZhkUyEGMagCWk5NA@mail.gmail.com>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
Sender: linux-unionfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-unionfs.vger.kernel.org>
X-Mailing-List: linux-unionfs@vger.kernel.org

On Mon, Aug 24, 2020 at 01:59:41PM +0300, Amir Goldstein wrote:
> On Mon, Aug 24, 2020 at 11:15 AM Miklos Szeredi <miklos@szeredi.hu> wrote:
> >
> > On Sat, Aug 22, 2020 at 11:27 AM Giuseppe Scrivano <gscrivan@redhat.com> wrote:
> > >
> > > Vivek Goyal <vgoyal@redhat.com> writes:
> > >
> > > > Container folks are complaining that dnf/yum issues too many sync while
> > > > installing packages and this slows down the image build. Build
> > > > requirement is such that they don't care if a node goes down while
> > > > build was still going on. In that case, they will simply throw away
> > > > unfinished layer and start new build. So they don't care about syncing
> > > > intermediate state to the disk and hence don't want to pay the price
> > > > associated with sync.
> > > >
> >
> > [...]
> >
> > > Ping.
> > >
> > > Is there anything holding this patch?
> >
> > Not sure what happened with protection against mounting a volatile
> > overlay twice, I don't see that in the patch.
> 
> Do you mean protection only for new kernels or old kernels as well?
> 
> The latter can be achieved by using $workdir/volatile/ as upperdir
> instead of $upperdir.
> Or maybe even use $workdir/work/incompat/volatile/upper, so if older
> kernel tries to re-use that $workdir, it will fail to mount rw with error:
> 
>   overlayfs: cleanup of 'incompat/volatile' failed (-39)
> 
> If we agree to that, then upperdir= should not be provided at all when
> specifying "volatile".

If we keep volatile inside workdir, then we fail work and upperdir
being separate subtree checks. And I suspect that all that trap
magic will trigger too.

I think for image building use case, tools to have access to volatile
directory. So that they can persist it, rename it and use it as lower
layer for next layer build. That means we will have to document it
and let users access and rename $workdir/work/incompat/volatile/ or
$workdir/work/volatile.

Once Miklos has suggested to drop a file in workdir say $workdir/volatile
And next remount will refuse to mount that overlay instance if
$workdir/volatile is present. With this approach work/ and upper/
are in separate dir subtrees.

And user will be forced to remove work/ and upper/ if previous instance
was mounted with "volatile".

I am not too worried about protection against older kernels because if
system has been setup to boot into a new kernel, it will boot into
new kernel again. (Until and unless somebody forces it to go back to
old kernel). But if you think providing protection against old kernels
is important, we could create volatile in $workdir/work/dir1/dir2/volatile
instead.

/me is wondering why I don't get error with $workdir/work/dir1/volatile
but I do with $workdir/work/dir1/dir2/volatile. IOW, why in first
case removal of dir1 was successful despite the fact it is non-empty.

Thanks
Vivek

