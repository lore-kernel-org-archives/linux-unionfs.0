Return-Path: <SRS0=sCFp=CC=vger.kernel.org=linux-unionfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-4.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 01F2AC433DF
	for <linux-unionfs@archiver.kernel.org>; Mon, 24 Aug 2020 21:01:06 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id C584C207DF
	for <linux-unionfs@archiver.kernel.org>; Mon, 24 Aug 2020 21:01:05 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="fmu8+U9h"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726541AbgHXVBE (ORCPT
        <rfc822;linux-unionfs@archiver.kernel.org>);
        Mon, 24 Aug 2020 17:01:04 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:36058 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726365AbgHXVBD (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Mon, 24 Aug 2020 17:01:03 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1598302861;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=pGzh3lKqrfLfmQy6PBRky6BGUBfZAthRsyXnGL+lwYU=;
        b=fmu8+U9hACDMDAHsdpcSBuP8oiAIAKOuWbPuyg49W+xwNBIRrNCZuqidF0/vXtsC87Uade
        2yiuhrky/uO8B5eUXOayJBWLa+btyxlJ6aEQtkpCVNzqAi8ehAyFz5WdeyjEOCw4U4+wLG
        QmTKNocPwR6GTdItIn2cHaITY2HG+8E=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-245-fvgAQFtNOviLACFmFp2EOA-1; Mon, 24 Aug 2020 17:00:59 -0400
X-MC-Unique: fvgAQFtNOviLACFmFp2EOA-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id BFE9018B9EC2;
        Mon, 24 Aug 2020 21:00:54 +0000 (UTC)
Received: from horse.redhat.com (ovpn-115-156.rdu2.redhat.com [10.10.115.156])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 8408360C13;
        Mon, 24 Aug 2020 21:00:54 +0000 (UTC)
Received: by horse.redhat.com (Postfix, from userid 10451)
        id 06B7B2256FC; Mon, 24 Aug 2020 17:00:53 -0400 (EDT)
Date:   Mon, 24 Aug 2020 17:00:53 -0400
From:   Vivek Goyal <vgoyal@redhat.com>
To:     Amir Goldstein <amir73il@gmail.com>
Cc:     Miklos Szeredi <miklos@szeredi.hu>,
        Giuseppe Scrivano <gscrivan@redhat.com>,
        overlayfs <linux-unionfs@vger.kernel.org>,
        Daniel J Walsh <dwalsh@redhat.com>,
        Steven Whitehouse <swhiteho@redhat.com>
Subject: Re: [PATCH v5] overlayfs: Provide a mount option "volatile" to skip
 sync
Message-ID: <20200824210053.GL963827@redhat.com>
References: <20200722175024.GA608248@redhat.com>
 <87h7svyqsd.fsf@redhat.com>
 <CAJfpegtA-16EFFoqhn25rVmXat5hhNUTAWOf+hJEs5L910oQzA@mail.gmail.com>
 <CAOQ4uxj0SF1VRbMEvVm4a9TuUtdMYuZqFkZhkUyEGMagCWk5NA@mail.gmail.com>
 <87a6yknugp.fsf@redhat.com>
 <CAOQ4uxg4xmvsoKVBfGJ0SVCXfM6aeNji6c8FSCevxV-FYX3LtQ@mail.gmail.com>
 <874kosnqnn.fsf@redhat.com>
 <CAJfpegvaUz_M0jtibOk=a6Cx=U9JBnOcVSmF2xM9cyVmCz8CFg@mail.gmail.com>
 <20200824135108.GB963827@redhat.com>
 <CAOQ4uxi9PoYzWxKF0c2a9zzxnrZMeB08Htomn1eHjYha-djLrA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAOQ4uxi9PoYzWxKF0c2a9zzxnrZMeB08Htomn1eHjYha-djLrA@mail.gmail.com>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
Sender: linux-unionfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-unionfs.vger.kernel.org>
X-Mailing-List: linux-unionfs@vger.kernel.org

On Mon, Aug 24, 2020 at 11:53:30PM +0300, Amir Goldstein wrote:
> On Mon, Aug 24, 2020 at 4:51 PM Vivek Goyal <vgoyal@redhat.com> wrote:
> >
> > On Mon, Aug 24, 2020 at 03:20:20PM +0200, Miklos Szeredi wrote:
> > > On Mon, Aug 24, 2020 at 3:02 PM Giuseppe Scrivano <gscrivan@redhat.com> wrote:
> > > >
> > > > Amir Goldstein <amir73il@gmail.com> writes:
> > > >
> > > > > On Mon, Aug 24, 2020 at 2:39 PM Giuseppe Scrivano <gscrivan@redhat.com> wrote:
> > > > >>
> > > > >> Hi Amir,
> > > > >>
> > > > >> Amir Goldstein <amir73il@gmail.com> writes:
> > > > >>
> > > > >> > On Mon, Aug 24, 2020 at 11:15 AM Miklos Szeredi <miklos@szeredi.hu> wrote:
> > > > >> >>
> > > > >> >> On Sat, Aug 22, 2020 at 11:27 AM Giuseppe Scrivano <gscrivan@redhat.com> wrote:
> > > > >> >> >
> > > > >> >> > Vivek Goyal <vgoyal@redhat.com> writes:
> > > > >> >> >
> > > > >> >> > > Container folks are complaining that dnf/yum issues too many sync while
> > > > >> >> > > installing packages and this slows down the image build. Build
> > > > >> >> > > requirement is such that they don't care if a node goes down while
> > > > >> >> > > build was still going on. In that case, they will simply throw away
> > > > >> >> > > unfinished layer and start new build. So they don't care about syncing
> > > > >> >> > > intermediate state to the disk and hence don't want to pay the price
> > > > >> >> > > associated with sync.
> > > > >> >> > >
> > > > >> >>
> > > > >> >> [...]
> > > > >> >>
> > > > >> >> > Ping.
> > > > >> >> >
> > > > >> >> > Is there anything holding this patch?
> > > > >> >>
> > > > >> >> Not sure what happened with protection against mounting a volatile
> > > > >> >> overlay twice, I don't see that in the patch.
> > > > >> >
> > > > >> > Do you mean protection only for new kernels or old kernels as well?
> > > > >> >
> > > > >> > The latter can be achieved by using $workdir/volatile/ as upperdir
> > > > >> > instead of $upperdir.
> > > > >> > Or maybe even use $workdir/work/incompat/volatile/upper, so if older
> > > > >> > kernel tries to re-use that $workdir, it will fail to mount rw with error:
> > > > >> >
> > > > >> >   overlayfs: cleanup of 'incompat/volatile' failed (-39)
> > > > >> >
> > > > >> > If we agree to that, then upperdir= should not be provided at all when
> > > > >> > specifying "volatile".
> > > > >>
> > > > >> in this case, what does a program need to do to remount the overlay more
> > > > >> than once?  Is it enough to just delete a file?
> > > > >>
> > > > >
> > > > > Do you mean re-mount while forgetting all changes to previous "volatile"
> > > > > mount?
> > > >
> > > > no, without forgetting them.
> > > > The original idea was to have a way to disable any sync operation in the
> > > > overlay file system and let the upper layers handle it.  IOW, mount
> > > > volatile overlay+umount overlay+syncfs upper dir must still be
> > > > considered safe.
> > > > If we want to make it safer and disallow remounting the same
> > > > workdir+upperdir by default when "volatile" is used, that is fine; but I
> > > > think there should still be a way to say "I know what I am doing, just
> > > > remount it".
> > >
> > > Indeed.  "Volatile" doesn't mean you can't use the data, just that the
> > > data may be lost completely in case of a crash (tmpfs analogue).
> > >
> > > Maybe just stick
> > >
> > >   $(workdir)/work/incompat/volatile/donotremove
> > >
> > > in there to prevent misuse.
> >
> > So we ask users to remove "$(workdir)/work/incompat/volatile/donotremove"
> > if they want to remount with with same upper/ and work/? (Presumably
> > after syncing upper/).
> >
> 
> Sounds right.
> Just don't rely on the workdir cleanup error yes?
> That protection is for old kernels and it falls back to r/o mount.
> New kernel should of course recognise $(workdir)/work/incompat/volatile
> fail to mount and explicitly error about unclean "volatile" unmount and
> maybe give a hint how to fix it in kernel log.

Ok, I am wondering why are we concerned about older kernels. I mean,
if we introduce new features, we don't provide compatibility with
older kernels. Say "metacopy", "redirect_dir". If you mount with
older kernel, they will see something which you don't expect.

So why "volatile" is different. We seem to be bending backward and
using an unrelated behavior of overlay to provide this.

Why not simply drop a file $workdir/volatile for volatile mounts
and check for presence of this file when mounting?

Thanks
Vivek

