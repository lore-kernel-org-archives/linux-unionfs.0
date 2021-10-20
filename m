Return-Path: <linux-unionfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 38AB6C433EF
	for <linux-unionfs@archiver.kernel.org>; Wed, 20 Oct 2021 06:49:52 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 1C852610CB
	for <linux-unionfs@archiver.kernel.org>; Wed, 20 Oct 2021 06:49:52 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229741AbhJTGwF (ORCPT
        <rfc822;linux-unionfs@archiver.kernel.org>);
        Wed, 20 Oct 2021 02:52:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58924 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229591AbhJTGwC (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Wed, 20 Oct 2021 02:52:02 -0400
Received: from mail-ua1-x932.google.com (mail-ua1-x932.google.com [IPv6:2607:f8b0:4864:20::932])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4F85EC06161C
        for <linux-unionfs@vger.kernel.org>; Tue, 19 Oct 2021 23:49:48 -0700 (PDT)
Received: by mail-ua1-x932.google.com with SMTP id e2so4685207uax.7
        for <linux-unionfs@vger.kernel.org>; Tue, 19 Oct 2021 23:49:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=nextdayvideo-com.20210112.gappssmtp.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=05OkJ8SCx8vcj0qHs1VDaY9HBqfZw+ffSx0Ocm/mjv0=;
        b=dAhIiIqPKm54dLKkwSsbpjb0APYjh0hYTeVYl47cpsYEvDtQmH+Cs8/4KvSsap8JB2
         sxrwWqcAVhGFOH00Urcp5N91CY21iECi9frTUOvZTed8iZF72qnApDRdbBeGJJprJmce
         4NJzFXDgrdh++gYEAZvnfQKBK+HXAOYHfnifO0RtemIK7hGU2M3mj47nZh+f2Dy7iuUX
         wIqLwjz1nwz0NcyWaCBzc0gJ3MqyJs6xk2WUHE4GmFgwYRzjlxcpZxMj/ryiOOEh8mx3
         KedUA5ic18KsG/i2eucId7KPwrJ8XC2P5JRYw9FxcDL1rYpoH51hbpFfQUFIkR7PcOoX
         5qCA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=05OkJ8SCx8vcj0qHs1VDaY9HBqfZw+ffSx0Ocm/mjv0=;
        b=IZIPLuhejvo401/kzZUydLr89rF172DEAGuqvo/gKLmgR0Mw8j9PeMsYj84Ox02xQe
         Er5R5gYTdundJBTF7LG7UMSicqkak0L4VG3Vs0xcOoXFJHvuil80VlNvkQ3EYiCta5ma
         NtQpZ3NV66+mZw46fuzcJUnWvrQfxxrgqydHZcUdJJ1aVxhV+lpxR+I+HhIEc/TKOVt2
         UIaxHIWHarTzSbGIN18Ge+DGZS7+KJIt5N21XuF/TtYP2stmrHyzsC52qgE9372YR5fo
         dxHxDW8g8YZJuu31DnsryKERYGgUa0jOylm8tMUIOAYcaMCkANLpO8lnHIA7pMEP2PsZ
         9Yug==
X-Gm-Message-State: AOAM5322+E9lVvtfqeeCc5IhI3YwTovJtCLdFhWtyT0e5LcE7ugbbvAm
        4ZR7fWh6XAddUEaV4U4jKaG/WWw3hrtY2jLG5S8=
X-Google-Smtp-Source: ABdhPJwnKrxEeB19V8nZNJSzOnHuG6rdRCjGdk3Cci/jUgIuJdbOYeH77c/p0kfLaLweI1SDCm48SJ4AIa9y5j/t95w=
X-Received: by 2002:a67:f6d7:: with SMTP id v23mr40600623vso.22.1634712587419;
 Tue, 19 Oct 2021 23:49:47 -0700 (PDT)
MIME-Version: 1.0
References: <CADmzSSgiJ8jS5Ss-P+7_vXowM_TVNhwySE=QHwDhjG0Uj0Xr1g@mail.gmail.com>
 <CAOQ4uxiRthg8vMiFwNUW=V3HZhGyufgqFWBsBTh_SXVyXDO1jA@mail.gmail.com>
In-Reply-To: <CAOQ4uxiRthg8vMiFwNUW=V3HZhGyufgqFWBsBTh_SXVyXDO1jA@mail.gmail.com>
From:   Carl Karsten <carl@nextdayvideo.com>
Date:   Wed, 20 Oct 2021 01:49:20 -0500
Message-ID: <CADmzSSheLbJTJxfS6xF5jV4dauRZkt7OY7v9oPkpjQmnHpx_9Q@mail.gmail.com>
Subject: Re: nfs_export Stale file handle
To:     Amir Goldstein <amir73il@gmail.com>
Cc:     overlayfs <linux-unionfs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <linux-unionfs.vger.kernel.org>
X-Mailing-List: linux-unionfs@vger.kernel.org

On Wed, Oct 20, 2021 at 12:42 AM Amir Goldstein <amir73il@gmail.com> wrote:
>
> On Tue, Oct 19, 2021 at 10:49 PM Carl Karsten <carl@nextdayvideo.com> wro=
te:
> >
> > I am sure this worked once, then I rebooted and now something ....
>
> Are you saying it is a regression? From which kernel?

Not a regression - just something that I am sure was OK on my box,
then 20 min later the 'same thing' is causing problems.  We all know
it isn't the same, but this is what has me scratching my head.

>
> >
> > root@negk:/srv/nfs/rpi/root# mount -v -t overlay -o nfs_export=3Don
> > overlay -olowerdir=3Dimg,upperdir=3Dupper,workdir=3Dwork merged
> > mount: /srv/nfs/rpi/root/merged: mount(2) system call failed: Stale fil=
e handle.
> >
>
> What are lower and upper?

img was
/dev/mapper/loop2p2 on /srv/nfs/rpi/buster/root/img type ext4 (rw,relatime)

> cat /proc/self/mountinfo please

sorry, I've reinstalled the os and I'm not having this problem any more.

> If you happen to be using squashfs for lower fs, there were a bunch
> of changes and fixes in recent kernels.

no squashfs

>
> > # this works:
> > root@negk:/srv/nfs/rpi/root# mount -v -t overlay -o nfs_export=3Doff
> > overlay -olowerdir=3Dimg,upperdir=3Dupper,workdir=3Dwork merged
> > mount: overlay mounted on /srv/nfs/rpi/root/merged.
> > root@negk:/srv/nfs/rpi/root# umount merged
> >
> > # syslog:
> >
> > [   80.317697] overlayfs: failed to verify origin (root/img,
> > ino=3D2374476, err=3D-116)
> > [   80.317703] overlayfs: failed to verify upper root origin
> >
> > # no help:
> > systemctl disable nfs-server.service
> > reboot
> > root@negk:/srv/nfs/rpi/root# systemctl status nfs-server.service
> > =E2=97=8F nfs-server.service - NFS server and services
> >      Loaded: loaded (/lib/systemd/system/nfs-server.service; disabled;
> > vendor preset: enabled)
> >      Active: inactive (dead)
> >
>
> The error has nothing to do with NFS.
> The staleness is that of the root/img directory.
> Overlayfs believes that someone has replaced the original
> root/img directory with another directory on the same name
> but a different file handle.
>

the only difference between error and no error was

nfs_export=3Doff / on

Which is mostly why I posted - this little detail seemed odd.

> Did you re-create the lower image filesystem/subtree?

maybe.  I'm futzing around with this pi image file trying to figure
out how to manage various flavors of modifications. .
I was hoping the lowest level would be the fs in the .img file, but
there isn't a nice way to deal with the loop devices, so I'll copy the
files onto the base ext5 fs and get on with things.

At the moment my little sysadmin project has lots of moving parts that
are not at all reliable, it's hard to tell what is and isn't working.
robust is the goal, I'm getting there.


> See Documentation clarification commit
> 13c6ad0f45fd ("ovl: document lower modification caveats")
>
> Thanks,
> Amir.



--=20
Carl K
