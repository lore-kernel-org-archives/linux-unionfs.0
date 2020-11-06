Return-Path: <SRS0=vZRj=EM=vger.kernel.org=linux-unionfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.9 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1BFD5C2D0A3
	for <linux-unionfs@archiver.kernel.org>; Fri,  6 Nov 2020 19:20:31 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id BAD392151B
	for <linux-unionfs@archiver.kernel.org>; Fri,  6 Nov 2020 19:20:30 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="WS14P1wF"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727257AbgKFTUa (ORCPT
        <rfc822;linux-unionfs@archiver.kernel.org>);
        Fri, 6 Nov 2020 14:20:30 -0500
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:40152 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727069AbgKFTUa (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Fri, 6 Nov 2020 14:20:30 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1604690428;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=cA2GwrQ6zerYWUKv7U+6v/72ZG/PxB17ToJzGzUpvCA=;
        b=WS14P1wFUcErdRXpBlBWjUOOozm8EIRfuh6ibrrm+1Thf6LGmaqnG/Wl6MGwhgHj4AN4CI
        LZF60PnFB1SNqurPwdzJ4yrZoDViTlLZ6+97lb3zTw+qbY/r6Tg8bI7YZxq6SjBFeWFX5h
        guxkoQzI9ghtqVrLzY2LUaamFFQYN8M=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-508-F7N3LE5yOX6ftvxv0yn9uQ-1; Fri, 06 Nov 2020 14:20:26 -0500
X-MC-Unique: F7N3LE5yOX6ftvxv0yn9uQ-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 59043186DD22;
        Fri,  6 Nov 2020 19:20:25 +0000 (UTC)
Received: from horse.redhat.com (ovpn-115-167.rdu2.redhat.com [10.10.115.167])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 175B15B4CC;
        Fri,  6 Nov 2020 19:20:25 +0000 (UTC)
Received: by horse.redhat.com (Postfix, from userid 10451)
        id 886DD225FCD; Fri,  6 Nov 2020 14:20:24 -0500 (EST)
Date:   Fri, 6 Nov 2020 14:20:24 -0500
From:   Vivek Goyal <vgoyal@redhat.com>
To:     Amir Goldstein <amir73il@gmail.com>
Cc:     Sargun Dhillon <sargun@sargun.me>,
        overlayfs <linux-unionfs@vger.kernel.org>,
        Miklos Szeredi <miklos@szeredi.hu>,
        Giuseppe Scrivano <gscrivan@redhat.com>,
        Daniel J Walsh <dwalsh@redhat.com>
Subject: Re: [PATCH v7] overlayfs: Provide a mount option "volatile" to skip
 sync
Message-ID: <20201106192024.GF1436035@redhat.com>
References: <20200831181529.GA1193654@redhat.com>
 <CAMp4zn9dF-umZF-LP=f6qWekyupsXTB6B8CeH6km7=9oVYV+NA@mail.gmail.com>
 <CAOQ4uxhadzC3-kh-igfxv3pAmC3ocDtAQTxByu4hrn8KtZuieQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAOQ4uxhadzC3-kh-igfxv3pAmC3ocDtAQTxByu4hrn8KtZuieQ@mail.gmail.com>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
Precedence: bulk
List-ID: <linux-unionfs.vger.kernel.org>
X-Mailing-List: linux-unionfs@vger.kernel.org

On Fri, Nov 06, 2020 at 09:00:07PM +0200, Amir Goldstein wrote:
> On Fri, Nov 6, 2020 at 7:59 PM Sargun Dhillon <sargun@sargun.me> wrote:
> >
> > On Mon, Aug 31, 2020 at 11:15 AM Vivek Goyal <vgoyal@redhat.com> wrote:
> > >
> > > Container folks are complaining that dnf/yum issues too many sync while
> > > installing packages and this slows down the image build. Build
> > > requirement is such that they don't care if a node goes down while
> > > build was still going on. In that case, they will simply throw away
> > > unfinished layer and start new build. So they don't care about syncing
> > > intermediate state to the disk and hence don't want to pay the price
> > > associated with sync.
> > >
> > > So they are asking for mount options where they can disable sync on overlay
> > > mount point.
> > >
> > > They primarily seem to have two use cases.
> > >
> > > - For building images, they will mount overlay with nosync and then sync
> > >   upper layer after unmounting overlay and reuse upper as lower for next
> > >   layer.
> > >
> > > - For running containers, they don't seem to care about syncing upper
> > >   layer because if node goes down, they will simply throw away upper
> > >   layer and create a fresh one.
> > >
> > > So this patch provides a mount option "volatile" which disables all forms
> > > of sync. Now it is caller's responsibility to throw away upper if
> > > system crashes or shuts down and start fresh.
> > >
> > > With "volatile", I am seeing roughly 20% speed up in my VM where I am just
> > > installing emacs in an image. Installation time drops from 31 seconds to
> > > 25 seconds when nosync option is used. This is for the case of building on top
> > > of an image where all packages are already cached. That way I take
> > > out the network operations latency out of the measurement.
> > >
> > > Giuseppe is also looking to cut down on number of iops done on the
> > > disk. He is complaining that often in cloud their VMs are throttled
> > > if they cross the limit. This option can help them where they reduce
> > > number of iops (by cutting down on frequent sync and writebacks).
> > >
> [...]
> > There is some slightly confusing behaviour here [I realize this
> > behaviour is as intended]:
> >
> > (root) ~ # mount -t overlay -o
> > volatile,index=off,lowerdir=/root/lowerdir,upperdir=/root/upperdir,workdir=/root/workdir
> > none /mnt/foo
> > (root) ~ # umount /mnt/foo
> > (root) ~ # mount -t overlay -o
> > volatile,index=off,lowerdir=/root/lowerdir,upperdir=/root/upperdir,workdir=/root/workdir
> > none /mnt/foo
> > mount: /mnt/foo: wrong fs type, bad option, bad superblock on none,
> > missing codepage or helper program, or other error.
> >
> > From my understanding, the dirty flag should only be a problem if the
> > existing overlayfs is unmounted uncleanly. Docker does
> > this (mount, and re-mounts) during startup time because it writes some
> > files to the overlayfs. I think that we should harden
> > the volatile check slightly, and make it so that within the same boot,
> > it's not a problem, and having to have the user clear
> > the workdir every time is a pain. In addition, the semantics of the
> > volatile patch itself do not appear to be such that they
> > would break mounts during the same boot / mount of upperdir -- as
> > overlayfs does not defer any writes in itself, and it's
> > only that it's short-circuiting writes to the upperdir.
> >
> > Amir,
> > What do you think?
> 
> How do you propose to check that upperdir was used during the same boot?
> 
> Maybe a simpler check  is that upperdir inode is still in cache as an easy way
> around this.
> 
> Add an overlayfs specific inode flag, similar to I_OVL_INUSE
> I_OVL_WAS_INUSE.

So this works only if inode has not been evicted. That means sometimes
it will work and other times it will error out. If that's the case
user has to write code to deal with the error anyway and does not
make life simpler.

Mayh be sync=fs was middle ground option where we ignore fsync() but still
do filesystem sync. And there we will do a sync of upper on umount and
then can remote this incompat directory.

https://lore.kernel.org/linux-unionfs/20200701215029.GF369085@redhat.com/

Thanks
Vivek

