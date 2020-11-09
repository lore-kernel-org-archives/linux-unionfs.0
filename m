Return-Path: <linux-unionfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.6 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4B7F7C2D0A3
	for <linux-unionfs@archiver.kernel.org>; Mon,  9 Nov 2020 19:40:12 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id EF2BF206A1
	for <linux-unionfs@archiver.kernel.org>; Mon,  9 Nov 2020 19:40:11 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Rlp/GrOH"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729903AbgKITkL (ORCPT
        <rfc822;linux-unionfs@archiver.kernel.org>);
        Mon, 9 Nov 2020 14:40:11 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54970 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729697AbgKITkL (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Mon, 9 Nov 2020 14:40:11 -0500
Received: from mail-io1-xd43.google.com (mail-io1-xd43.google.com [IPv6:2607:f8b0:4864:20::d43])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6B3D8C0613CF
        for <linux-unionfs@vger.kernel.org>; Mon,  9 Nov 2020 11:40:11 -0800 (PST)
Received: by mail-io1-xd43.google.com with SMTP id t8so6562002iov.8
        for <linux-unionfs@vger.kernel.org>; Mon, 09 Nov 2020 11:40:11 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=Dsj1AI8gZZDWGg5xDdJbBJgsV0Rqn2m55lGK11ioZ4Q=;
        b=Rlp/GrOHhYWYwnYb54AqQEl1vHwYCQSDUvWU6lNQncG1rv8t/YBku2P3V/Xu4VfxLi
         WfgVzFuT/wV2JWEGAXw5t+ZP/4VATReD21ffyoylNpXfv0rsR8oNVH9vKST6MwyKK827
         sNOTJJrMsxlVqW2r/8i0lAb0FjNyTruCSBbZAfYDVvWD/mah6Sckb+NiuHD20B4g0oXC
         0A6aWOlK0vL8tFHKCt5C2o3KlZ4ZHF+igRo6zvvN/4wLUCR7hsdCKg0Au6FC7DCha+ro
         Vxh1CaN+qPL1ozTW79Beo16kv7/W8IT4Tkr65oKE79rNpCl0kEPrvBugAf6uXS7Z3FSd
         5x0A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=Dsj1AI8gZZDWGg5xDdJbBJgsV0Rqn2m55lGK11ioZ4Q=;
        b=AUGE3s8VMXoPUsdl9Brr0fX3G7WCHdVqtL97NkJwXh6aMNqFGMBZqQcnPp0tWbfdF4
         OHx1gRO3EK0Zp+8zCkwLTeO1bd9on2rSctwA6ebN724x/CyYrDFIqpg8DKpaG2Ej6MdX
         NdBhUB7RRt5M/odat+Qkl1ucMNzMEs6AZk/CkqTPorr0I8TYFu3zoGR2jSPtgB+0LxVz
         C13qkbD2Fdj0gCJc4EkGeaP4yeLeZLH9N072Zp41kggOJaLzyN3uyIwz6rnM0xapwx3o
         9F3AithplGf9/CPX3COLVwNYWpoDYNj208m811r7rTOzVd8B7HwHq8eS0LTQqNOn4b/p
         thyw==
X-Gm-Message-State: AOAM5330A0o5AJ5DOmu4xDcv75RL9AyNfL/dbqNpbTZT368vq976sk5Z
        iY0udigzvjJpVdj+QNvwMlaQlHArthK2Ay3h8nEms02q
X-Google-Smtp-Source: ABdhPJxhPY7kIQzKHCqxaQCablelNzdqoUX/3N0ex3lBOJxRV/PwX6xDs0hdyr/ZKXgwO8SUz68f2xndifNvXd4+H5Q=
X-Received: by 2002:a6b:db0d:: with SMTP id t13mr11248282ioc.203.1604950810692;
 Mon, 09 Nov 2020 11:40:10 -0800 (PST)
MIME-Version: 1.0
References: <20200831181529.GA1193654@redhat.com> <CAMp4zn9dF-umZF-LP=f6qWekyupsXTB6B8CeH6km7=9oVYV+NA@mail.gmail.com>
 <CAOQ4uxhadzC3-kh-igfxv3pAmC3ocDtAQTxByu4hrn8KtZuieQ@mail.gmail.com>
 <20201109172203.GF1479853@redhat.com> <CAMp4zn81aWs_KBh=XeCWkktjC1ta-8ZvPSecKpdozLnK4CjxdQ@mail.gmail.com>
In-Reply-To: <CAMp4zn81aWs_KBh=XeCWkktjC1ta-8ZvPSecKpdozLnK4CjxdQ@mail.gmail.com>
From:   Amir Goldstein <amir73il@gmail.com>
Date:   Mon, 9 Nov 2020 21:39:59 +0200
Message-ID: <CAOQ4uxixjNJpGR1fo26-AYPBTRkZQ-OU-H=kbSKvuZxtAuxiMQ@mail.gmail.com>
Subject: Re: [PATCH v7] overlayfs: Provide a mount option "volatile" to skip sync
To:     Sargun Dhillon <sargun@sargun.me>
Cc:     Vivek Goyal <vgoyal@redhat.com>,
        overlayfs <linux-unionfs@vger.kernel.org>,
        Miklos Szeredi <miklos@szeredi.hu>,
        Giuseppe Scrivano <gscrivan@redhat.com>,
        Daniel J Walsh <dwalsh@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-unionfs.vger.kernel.org>
X-Mailing-List: linux-unionfs@vger.kernel.org

On Mon, Nov 9, 2020 at 7:26 PM Sargun Dhillon <sargun@sargun.me> wrote:
>
> On Mon, Nov 9, 2020 at 9:22 AM Vivek Goyal <vgoyal@redhat.com> wrote:
> >
> > On Fri, Nov 06, 2020 at 09:00:07PM +0200, Amir Goldstein wrote:
> > > On Fri, Nov 6, 2020 at 7:59 PM Sargun Dhillon <sargun@sargun.me> wrote:
> > > >
> > > > On Mon, Aug 31, 2020 at 11:15 AM Vivek Goyal <vgoyal@redhat.com> wrote:
> > > > >
> > > > > Container folks are complaining that dnf/yum issues too many sync while
> > > > > installing packages and this slows down the image build. Build
> > > > > requirement is such that they don't care if a node goes down while
> > > > > build was still going on. In that case, they will simply throw away
> > > > > unfinished layer and start new build. So they don't care about syncing
> > > > > intermediate state to the disk and hence don't want to pay the price
> > > > > associated with sync.
> > > > >
> > > > > So they are asking for mount options where they can disable sync on overlay
> > > > > mount point.
> > > > >
> > > > > They primarily seem to have two use cases.
> > > > >
> > > > > - For building images, they will mount overlay with nosync and then sync
> > > > >   upper layer after unmounting overlay and reuse upper as lower for next
> > > > >   layer.
> > > > >
> > > > > - For running containers, they don't seem to care about syncing upper
> > > > >   layer because if node goes down, they will simply throw away upper
> > > > >   layer and create a fresh one.
> > > > >
> > > > > So this patch provides a mount option "volatile" which disables all forms
> > > > > of sync. Now it is caller's responsibility to throw away upper if
> > > > > system crashes or shuts down and start fresh.
> > > > >
> > > > > With "volatile", I am seeing roughly 20% speed up in my VM where I am just
> > > > > installing emacs in an image. Installation time drops from 31 seconds to
> > > > > 25 seconds when nosync option is used. This is for the case of building on top
> > > > > of an image where all packages are already cached. That way I take
> > > > > out the network operations latency out of the measurement.
> > > > >
> > > > > Giuseppe is also looking to cut down on number of iops done on the
> > > > > disk. He is complaining that often in cloud their VMs are throttled
> > > > > if they cross the limit. This option can help them where they reduce
> > > > > number of iops (by cutting down on frequent sync and writebacks).
> > > > >
> > > [...]
> > > > There is some slightly confusing behaviour here [I realize this
> > > > behaviour is as intended]:
> > > >
> > > > (root) ~ # mount -t overlay -o
> > > > volatile,index=off,lowerdir=/root/lowerdir,upperdir=/root/upperdir,workdir=/root/workdir
> > > > none /mnt/foo
> > > > (root) ~ # umount /mnt/foo
> > > > (root) ~ # mount -t overlay -o
> > > > volatile,index=off,lowerdir=/root/lowerdir,upperdir=/root/upperdir,workdir=/root/workdir
> > > > none /mnt/foo
> > > > mount: /mnt/foo: wrong fs type, bad option, bad superblock on none,
> > > > missing codepage or helper program, or other error.
> > > >
> > > > From my understanding, the dirty flag should only be a problem if the
> > > > existing overlayfs is unmounted uncleanly. Docker does
> > > > this (mount, and re-mounts) during startup time because it writes some
> > > > files to the overlayfs. I think that we should harden
> > > > the volatile check slightly, and make it so that within the same boot,
> > > > it's not a problem, and having to have the user clear
> > > > the workdir every time is a pain. In addition, the semantics of the
> > > > volatile patch itself do not appear to be such that they
> > > > would break mounts during the same boot / mount of upperdir -- as
> > > > overlayfs does not defer any writes in itself, and it's
> > > > only that it's short-circuiting writes to the upperdir.
> > > >
> > > > Amir,
> > > > What do you think?
> > >
> > > How do you propose to check that upperdir was used during the same boot?
> >
> > Can we read and store "/proc/sys/kernel/random/boot_id". I am assuming
> > this will change if system is rebooting after a shutdown/reboot/crash.
> >
> > If boot_id has not changed, we can allow remount and delete incomapt
> > dir ourseleves. May be we can drop a file in incomat to store boot_id
> > at the time of overlay mount.
> >
> > Thanks
> > Vivek
> >
>
> Storing boot_id is not good enough. You need to store the identity of the
> superblock, because remounts can occur. Also, if errors happen
> after flushing pages through writeback, they may never have been reported
> to the user, so we need to see if those happened as well.

It is not clear to me what problem we are trying to solve.
What is wrong with the userspace option to remove the dirty file?

Docker has to be changed anyway to use the 'volatile' mount option,
right?

Thanks,
Amir.
