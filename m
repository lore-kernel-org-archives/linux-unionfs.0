Return-Path: <SRS0=I2E7=5B=vger.kernel.org=linux-unionfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BEB83C2BB1D
	for <linux-unionfs@archiver.kernel.org>; Mon, 16 Mar 2020 19:40:25 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 95D662077C
	for <linux-unionfs@archiver.kernel.org>; Mon, 16 Mar 2020 19:40:25 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="Sorsx47T"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732436AbgCPTkZ (ORCPT
        <rfc822;linux-unionfs@archiver.kernel.org>);
        Mon, 16 Mar 2020 15:40:25 -0400
Received: from us-smtp-delivery-74.mimecast.com ([63.128.21.74]:35910 "EHLO
        us-smtp-delivery-74.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1732413AbgCPTkZ (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Mon, 16 Mar 2020 15:40:25 -0400
X-Greylist: delayed 5113 seconds by postgrey-1.27 at vger.kernel.org; Mon, 16 Mar 2020 15:40:24 EDT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1584387624;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=IXOVlQrf9gUik+N/bCY2n71wJwdX4EpfIGutgn70zIg=;
        b=Sorsx47Ta7n/65DzF6w1PGqFYzVZ5f1c9dPzkIRFjBWn+yAdUQtdzlYdqkoAEHxt6HpcUm
        Hbxb0CL9O9o+06z8urfbkEmH/De/0LStwGtLf2Loj6psluR9lBagQ6znmUMF74EZ1pCgQd
        nPwNn8HOo7wJ5bCjl0blbDobbXExO0U=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-80-VoHrmuXlPgevcobTcPbHNA-1; Mon, 16 Mar 2020 15:40:19 -0400
X-MC-Unique: VoHrmuXlPgevcobTcPbHNA-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 7B24D107ACC4;
        Mon, 16 Mar 2020 19:40:18 +0000 (UTC)
Received: from horse.redhat.com (ovpn-121-211.rdu2.redhat.com [10.10.121.211])
        by smtp.corp.redhat.com (Postfix) with ESMTP id B289E60BFB;
        Mon, 16 Mar 2020 19:40:17 +0000 (UTC)
Received: by horse.redhat.com (Postfix, from userid 10451)
        id 0A76C2234E4; Mon, 16 Mar 2020 15:40:17 -0400 (EDT)
Date:   Mon, 16 Mar 2020 15:40:17 -0400
From:   Vivek Goyal <vgoyal@redhat.com>
To:     Amir Goldstein <amir73il@gmail.com>
Cc:     Miklos Szeredi <miklos@szeredi.hu>,
        Miklos Szeredi <mszeredi@redhat.com>,
        overlayfs <linux-unionfs@vger.kernel.org>,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>
Subject: Re: [PATCH 4/4] ovl: alllow remote upper
Message-ID: <20200316194017.GC4013@redhat.com>
References: <20200131115004.17410-1-mszeredi@redhat.com>
 <20200131115004.17410-5-mszeredi@redhat.com>
 <20200204145951.GC11631@redhat.com>
 <CAJfpegtq4A-m9vOPwUftiotC_Xv6w-dnhCi9=E0t-b1ZPJXPGw@mail.gmail.com>
 <CAOQ4uxj_pVp9-EN2Gmq9j6G3xozzpK_zQiRO-brx6PZ9VpgD0Q@mail.gmail.com>
 <CAOQ4uxjFYO28r+0pY+pKxK-dDJcQF2nf2EivnOUBgrgkYTFjPQ@mail.gmail.com>
 <CAOQ4uxhZ8a2ObfB9sUtrc=95mM70qurLtXkaNyHOXYxGEKvxFw@mail.gmail.com>
 <CAOQ4uxhkd5FkN5ynpQxQ0m1MR9MgzTBbvzjkoHfSRA2umb-JTA@mail.gmail.com>
 <20200316175453.GB4013@redhat.com>
 <CAOQ4uxgfTJwE2O1GGt-TY+6ijjKE13+ATTarijFGLiM69jk8HA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAOQ4uxgfTJwE2O1GGt-TY+6ijjKE13+ATTarijFGLiM69jk8HA@mail.gmail.com>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
Sender: linux-unionfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-unionfs.vger.kernel.org>
X-Mailing-List: linux-unionfs@vger.kernel.org

On Mon, Mar 16, 2020 at 09:02:32PM +0200, Amir Goldstein wrote:
[..]
> > > Could you please make sure that the code in ovl-strict-upper branch
> > > works as expected for virtio as upper fs?
> >
> > Hi Amir,
> >
> > Right now it fails becuase virtiofs doesn't seem to support tmpfile yet.
> >
> > overlayfs: upper fs does not support tmpfile
> > overlayfs: upper fs missing required features.
> >
> > Will have to check what's required to support it.
> >
> > I also wanted to run either overlay xfstests or unionmount-testsuite. But
> > none of these seem to give me enough flexibility where I can specify
> > that overlayfs needs to be mounted on top of virtiofs.
> >
> > I feel that atleast for unionmount-testsuite, there should be an
> > option where we can simply give a target directory and tests run
> > on that directory and user mounts that directory as needed.
> >
> 
> Need to see how patches look.
> Don't want too much configuration complexity, but I agree that some
> flexibly is needed.
> Maybe the provided target directory should be the upper/work basedir?
> 
> > > I have rebased it on latest overlayfs-next merge into current master.
> > >
> > > I would very much prefer that the code merged to v5.7-rc1 will be more
> > > restrictive than the current overlayfs-next.
> >
> > In general I agree that if we want to not support some configuration
> > with remote upper, this is the time to introduce that restriction
> > otherwise we will later run into backward compatibility issue.
> >
> > Having said that, tmpfile support for upper sounds like a nice to
> > have feature. Not sure why to make it mandatory.
> >
> 
> Agreed, I just went automatic on all the warnings.
> tmpfile should not be a requirement for upper.
> Could you please verify that if dropping the tmpfile strict check,
> virtio can be used as upper.

I dropped tmpfile strict check and now I can mount overlayfs using
virtiofs as upper. Tried few basic file operations and these are
working.

Vivek

