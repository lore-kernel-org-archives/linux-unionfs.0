Return-Path: <SRS0=2h5r=7E=vger.kernel.org=linux-unionfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F1580C433E0
	for <linux-unionfs@archiver.kernel.org>; Fri, 22 May 2020 13:44:56 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id CB427207D8
	for <linux-unionfs@archiver.kernel.org>; Fri, 22 May 2020 13:44:56 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="CHLJoqha"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729918AbgEVNo4 (ORCPT
        <rfc822;linux-unionfs@archiver.kernel.org>);
        Fri, 22 May 2020 09:44:56 -0400
Received: from us-smtp-2.mimecast.com ([205.139.110.61]:59497 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1729399AbgEVNo4 (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Fri, 22 May 2020 09:44:56 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1590155094;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=2oGaCksTm1sNXR2ILEe7m/Zu+7nI6ZhSmGmUuWgmDS8=;
        b=CHLJoqhaynY/6JZwNbytt5z/2oadP3UVwA0Ru1gVwXt1ThhjR1lNOYySu7c3P++oJ3IYcq
        Ie5aG2d1ClRTuQjReq/xTO7NQIQ8N+Oht66TTZd4rhbMPP5Kehkq8l2tpvDberIMG169h+
        KlZ+a/flXJTXnlmE7HK0Xb3qDTIyBn8=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-102-hFDGfpNlO52Ll2FyAqOegA-1; Fri, 22 May 2020 09:44:51 -0400
X-MC-Unique: hFDGfpNlO52Ll2FyAqOegA-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id BE53D19057A1;
        Fri, 22 May 2020 13:44:49 +0000 (UTC)
Received: from horse.redhat.com (ovpn-115-124.rdu2.redhat.com [10.10.115.124])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 3C729707BA;
        Fri, 22 May 2020 13:44:48 +0000 (UTC)
Received: by horse.redhat.com (Postfix, from userid 10451)
        id B804B22036E; Fri, 22 May 2020 09:44:47 -0400 (EDT)
Date:   Fri, 22 May 2020 09:44:47 -0400
From:   Vivek Goyal <vgoyal@redhat.com>
To:     Miklos Szeredi <miklos@szeredi.hu>
Cc:     Amir Goldstein <amir73il@gmail.com>, cgxu <cgxu519@mykernel.net>,
        Jan Kara <jack@suse.cz>,
        overlayfs <linux-unionfs@vger.kernel.org>,
        Sargun Dhillon <sargun@sargun.me>,
        Daniel J Walsh <dwalsh@redhat.com>, gscrivan@redhat.com
Subject: Re: [PATCH v12] ovl: improve syncfs efficiency
Message-ID: <20200522134447.GA58162@redhat.com>
References: <20200506095307.23742-1-cgxu519@mykernel.net>
 <4bc73729-5d85-36b7-0768-ae5952ae05e9@mykernel.net>
 <CAOQ4uxi4coKOoYar7Y==i=P21j5r8fi_0op+BZR-VQ1w5CMUew@mail.gmail.com>
 <CAJfpeguyg0e-mE5N=1VKkHWTDJKKhf-Ka6vZ02sQCFeiqRD-aQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAJfpeguyg0e-mE5N=1VKkHWTDJKKhf-Ka6vZ02sQCFeiqRD-aQ@mail.gmail.com>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
Sender: linux-unionfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-unionfs.vger.kernel.org>
X-Mailing-List: linux-unionfs@vger.kernel.org

On Fri, May 22, 2020 at 11:31:41AM +0200, Miklos Szeredi wrote:
> On Wed, May 20, 2020 at 9:24 AM Amir Goldstein <amir73il@gmail.com> wrote:
> >
> > On Wed, May 20, 2020 at 4:02 AM cgxu <cgxu519@mykernel.net> wrote:
> > >
> > > On 5/6/20 5:53 PM, Chengguang Xu wrote:
> > > > Current syncfs(2) syscall on overlayfs just calls sync_filesystem()
> > > > on upper_sb to synchronize whole dirty inodes in upper filesystem
> > > > regardless of the overlay ownership of the inode. In the use case of
> > > > container, when multiple containers using the same underlying upper
> > > > filesystem, it has some shortcomings as below.
> > > >
> > > > (1) Performance
> > > > Synchronization is probably heavy because it actually syncs unnecessary
> > > > inodes for target overlayfs.
> > > >
> > > > (2) Interference
> > > > Unplanned synchronization will probably impact IO performance of
> > > > unrelated container processes on the other overlayfs.
> > > >
> > > > This patch tries to only sync target dirty upper inodes which are belong
> > > > to specific overlayfs instance and wait for completion. By doing this,
> > > > it is able to reduce cost of synchronization and will not seriously impact
> > > > IO performance of unrelated processes.
> > > >
> > > > Signed-off-by: Chengguang Xu <cgxu519@mykernel.net>
> > >
> > > Except explicit sycnfs is triggered by user process, there is also implicit
> > > syncfs during umount process of overlayfs instance. Every syncfs will
> > > deliver to upper fs and whole dirty data of upper fs syncs to persistent
> > > device at same time.
> > >
> > > In high density container environment, especially for temporary jobs,
> > > this is quite unwilling  behavior. Should we provide an option to
> > > mitigate this effect for containers which don't care about dirty data?
> 
> If containers don't care about dirty data, why go to great lengths to
> make sure that syncfs() works?  Can't we just have an option to turn
> off syncing completely, for fsync, for syncfs, for shutdown, for
> everything?  That would be orders of magnitude simpler than the patch
> you posted.

We definitely have this use case where certain class of contaienrs
don't want to actually sync data back to disk. It slows them down
significantly. For example, containers used for building images
and they use "dnf" which issues bunch of sync and hence slowing
down build process.

These build containers don't care about system crashes. They will
restart the build process if such an event were to happen.

They are not in a position to modify "dnf" and other applications
to not issue sync. So they will like to have a mount option say
"nosync" where sync will be ignored by filesystem instance. This
expedites their build process. Copying Dan Walsh and Gisueppe who
were looking for such an option.

Thanks
Vivek

