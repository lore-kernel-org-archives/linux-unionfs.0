Return-Path: <SRS0=2h5r=7E=vger.kernel.org=linux-unionfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0F397C433DF
	for <linux-unionfs@archiver.kernel.org>; Fri, 22 May 2020 14:40:44 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id CBA40208B3
	for <linux-unionfs@archiver.kernel.org>; Fri, 22 May 2020 14:40:43 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="Vfd6oWJi"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729971AbgEVOkn (ORCPT
        <rfc822;linux-unionfs@archiver.kernel.org>);
        Fri, 22 May 2020 10:40:43 -0400
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:34648 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1729868AbgEVOkn (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Fri, 22 May 2020 10:40:43 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1590158441;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=YxvXMg5nursQu2SaPE3PBNEsGEm7tMOiBrGmZul0G74=;
        b=Vfd6oWJiCCHn0lMESUMEj4jGwnbAA0Juk3Vs14k8emYZkpEBuDOIurercKyk2LYkvdC8rr
        FHvv2JRC4phVLY+t/jQ7pp+b4m9VGBDjjGPL6e7STWQ40epL3W0jRlr+k4pbpAsVFLLhur
        jgUMXkVX5UOUEMWIt9Eqr2s398LQfLw=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-393-ddywJN9RMpO9UZEFljw8lw-1; Fri, 22 May 2020 10:40:37 -0400
X-MC-Unique: ddywJN9RMpO9UZEFljw8lw-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 2BF888014D4;
        Fri, 22 May 2020 14:40:36 +0000 (UTC)
Received: from localhost (ovpn-112-211.ams2.redhat.com [10.36.112.211])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 7FB4948D73;
        Fri, 22 May 2020 14:40:35 +0000 (UTC)
From:   Giuseppe Scrivano <gscrivan@redhat.com>
To:     Vivek Goyal <vgoyal@redhat.com>
Cc:     Miklos Szeredi <miklos@szeredi.hu>,
        Amir Goldstein <amir73il@gmail.com>,
        cgxu <cgxu519@mykernel.net>, Jan Kara <jack@suse.cz>,
        overlayfs <linux-unionfs@vger.kernel.org>,
        Sargun Dhillon <sargun@sargun.me>,
        Daniel J Walsh <dwalsh@redhat.com>
Subject: Re: [PATCH v12] ovl: improve syncfs efficiency
References: <20200506095307.23742-1-cgxu519@mykernel.net>
        <4bc73729-5d85-36b7-0768-ae5952ae05e9@mykernel.net>
        <CAOQ4uxi4coKOoYar7Y==i=P21j5r8fi_0op+BZR-VQ1w5CMUew@mail.gmail.com>
        <CAJfpeguyg0e-mE5N=1VKkHWTDJKKhf-Ka6vZ02sQCFeiqRD-aQ@mail.gmail.com>
        <20200522134447.GA58162@redhat.com>
Date:   Fri, 22 May 2020 16:40:33 +0200
In-Reply-To: <20200522134447.GA58162@redhat.com> (Vivek Goyal's message of
        "Fri, 22 May 2020 09:44:47 -0400")
Message-ID: <87r1vcf2xq.fsf@redhat.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/26.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
Sender: linux-unionfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-unionfs.vger.kernel.org>
X-Mailing-List: linux-unionfs@vger.kernel.org

Vivek Goyal <vgoyal@redhat.com> writes:

> On Fri, May 22, 2020 at 11:31:41AM +0200, Miklos Szeredi wrote:
>> On Wed, May 20, 2020 at 9:24 AM Amir Goldstein <amir73il@gmail.com> wrote:
>> >
>> > On Wed, May 20, 2020 at 4:02 AM cgxu <cgxu519@mykernel.net> wrote:
>> > >
>> > > On 5/6/20 5:53 PM, Chengguang Xu wrote:
>> > > > Current syncfs(2) syscall on overlayfs just calls sync_filesystem()
>> > > > on upper_sb to synchronize whole dirty inodes in upper filesystem
>> > > > regardless of the overlay ownership of the inode. In the use case of
>> > > > container, when multiple containers using the same underlying upper
>> > > > filesystem, it has some shortcomings as below.
>> > > >
>> > > > (1) Performance
>> > > > Synchronization is probably heavy because it actually syncs unnecessary
>> > > > inodes for target overlayfs.
>> > > >
>> > > > (2) Interference
>> > > > Unplanned synchronization will probably impact IO performance of
>> > > > unrelated container processes on the other overlayfs.
>> > > >
>> > > > This patch tries to only sync target dirty upper inodes which are belong
>> > > > to specific overlayfs instance and wait for completion. By doing this,
>> > > > it is able to reduce cost of synchronization and will not seriously impact
>> > > > IO performance of unrelated processes.
>> > > >
>> > > > Signed-off-by: Chengguang Xu <cgxu519@mykernel.net>
>> > >
>> > > Except explicit sycnfs is triggered by user process, there is also implicit
>> > > syncfs during umount process of overlayfs instance. Every syncfs will
>> > > deliver to upper fs and whole dirty data of upper fs syncs to persistent
>> > > device at same time.
>> > >
>> > > In high density container environment, especially for temporary jobs,
>> > > this is quite unwilling  behavior. Should we provide an option to
>> > > mitigate this effect for containers which don't care about dirty data?
>> 
>> If containers don't care about dirty data, why go to great lengths to
>> make sure that syncfs() works?  Can't we just have an option to turn
>> off syncing completely, for fsync, for syncfs, for shutdown, for
>> everything?  That would be orders of magnitude simpler than the patch
>> you posted.
>
> We definitely have this use case where certain class of contaienrs
> don't want to actually sync data back to disk. It slows them down
> significantly. For example, containers used for building images
> and they use "dnf" which issues bunch of sync and hence slowing
> down build process.
>
> These build containers don't care about system crashes. They will
> restart the build process if such an event were to happen.
>
> They are not in a position to modify "dnf" and other applications
> to not issue sync. So they will like to have a mount option say
> "nosync" where sync will be ignored by filesystem instance. This
> expedites their build process. Copying Dan Walsh and Gisueppe who
> were looking for such an option.

yes, it is definitely something we are looking into.  For fuse-overlayfs
(a FUSE implementation of overlay used for unprivileged containers), we
already expose an option to disable sync and we use it for build
containers.

For root containers, we are currently looking at other solutions like a
custom seccomp profile, but the mount flag would be a better solution.

Regards,
Giuseppe

