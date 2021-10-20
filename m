Return-Path: <linux-unionfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1DF15C4321E
	for <linux-unionfs@archiver.kernel.org>; Wed, 20 Oct 2021 07:49:51 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id F38AA613AD
	for <linux-unionfs@archiver.kernel.org>; Wed, 20 Oct 2021 07:49:50 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229702AbhJTHuJ (ORCPT
        <rfc822;linux-unionfs@archiver.kernel.org>);
        Wed, 20 Oct 2021 03:50:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43656 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229842AbhJTHuJ (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Wed, 20 Oct 2021 03:50:09 -0400
Received: from mail-io1-xd35.google.com (mail-io1-xd35.google.com [IPv6:2607:f8b0:4864:20::d35])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 93B6AC06161C
        for <linux-unionfs@vger.kernel.org>; Wed, 20 Oct 2021 00:47:55 -0700 (PDT)
Received: by mail-io1-xd35.google.com with SMTP id n7so23499577iod.0
        for <linux-unionfs@vger.kernel.org>; Wed, 20 Oct 2021 00:47:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=/W0YnE+8c//03sdFkTBDHqNF4ovHaEsDABM4AewUwwk=;
        b=U5XVi+QLKtmfPr0PbCoQQ9ve100nSU/f5IQJelMMye9y4kT1x/4MCISuPykKNsDGHm
         B07FiA+KHdLOv3ZBMK4zQbYly6EHuc4ipaYpmt+sc1bDjUumzBdtE0Yz+e3MwtKYeVWy
         vkpOiklujrplEz7HcZIObNxKstPHMd17LHFfca9ia4VwNnTVFVWDTQk3FJMoCsXJiQez
         0pdIsI+HPqB5PUDUsUbL2CJt/StD2Kn6pt/pLhhRCpI5aFM+2xn/Lua4eZh+61EGOpmd
         KUykVlF0QOcjDLRTBV6bYQMGc+Mjk725/FTTUrd+8zqkFI/zvwJC4uecOFiuS9MlBVXj
         rlcQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=/W0YnE+8c//03sdFkTBDHqNF4ovHaEsDABM4AewUwwk=;
        b=DgdxL89nZDtxohucMXAT+pEGvnYusCBXLCIO++1IGbdm4rP6f6sB9SpjzgTc8hICel
         tkN4T7fYKlScpM+TNgBw+6jSBc10whq1pPb9ESQGTDf+f06rQuX6UthQLh3/keG4AfEu
         boAIvvOFexOy+tQkx2DussHajTYynDX0BRBSCcl72/PiaUP3DZGFn2C3+brifDtk5Cta
         Ih9E1O0y8lX+YUiFXOZFBcA2EmJqvayGqXVzf8q8avjwq6CkfBvFPwG2zr8lmIkYzykJ
         qgmaLglCCbBI+vpQ1ifVTIhzIdrqskQTG6ZuS+YNaVYi54RB3ErKkuHecMUo8dFaw0Op
         t6NQ==
X-Gm-Message-State: AOAM53277/xAnoucSB0suTSXa7nsf1gqznqs5VN4XdTSwIuZ7O86Wst/
        MKvHRcCVQSqvKqTM/ejttckTS+jdCqk/3f2wqU6unLsvpfw=
X-Google-Smtp-Source: ABdhPJz+YgCXMF6k5TJK7pgqH5Vi4Dg1TTtxoqvuB8cOQi+AD9kXWF2yQ/Kwd8E0A+wPtsZuYZDQ2dEuDs2/xBkT8NE=
X-Received: by 2002:a05:6602:2ac8:: with SMTP id m8mr23144208iov.112.1634716074717;
 Wed, 20 Oct 2021 00:47:54 -0700 (PDT)
MIME-Version: 1.0
References: <CADmzSSgiJ8jS5Ss-P+7_vXowM_TVNhwySE=QHwDhjG0Uj0Xr1g@mail.gmail.com>
 <CAOQ4uxiRthg8vMiFwNUW=V3HZhGyufgqFWBsBTh_SXVyXDO1jA@mail.gmail.com> <CADmzSSheLbJTJxfS6xF5jV4dauRZkt7OY7v9oPkpjQmnHpx_9Q@mail.gmail.com>
In-Reply-To: <CADmzSSheLbJTJxfS6xF5jV4dauRZkt7OY7v9oPkpjQmnHpx_9Q@mail.gmail.com>
From:   Amir Goldstein <amir73il@gmail.com>
Date:   Wed, 20 Oct 2021 10:47:43 +0300
Message-ID: <CAOQ4uxghLQCLf6O9Q1GdgPsB1-OeessRCAtdehnOsa89RpxuWQ@mail.gmail.com>
Subject: Re: nfs_export Stale file handle
To:     Carl Karsten <carl@nextdayvideo.com>
Cc:     overlayfs <linux-unionfs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <linux-unionfs.vger.kernel.org>
X-Mailing-List: linux-unionfs@vger.kernel.org

On Wed, Oct 20, 2021 at 9:49 AM Carl Karsten <carl@nextdayvideo.com> wrote:
>
> On Wed, Oct 20, 2021 at 12:42 AM Amir Goldstein <amir73il@gmail.com> wrot=
e:
> >
> > On Tue, Oct 19, 2021 at 10:49 PM Carl Karsten <carl@nextdayvideo.com> w=
rote:
> > >
> > > I am sure this worked once, then I rebooted and now something ....
> >
> > Are you saying it is a regression? From which kernel?
>
> Not a regression - just something that I am sure was OK on my box,
> then 20 min later the 'same thing' is causing problems.  We all know
> it isn't the same, but this is what has me scratching my head.
>
> >
> > >
> > > root@negk:/srv/nfs/rpi/root# mount -v -t overlay -o nfs_export=3Don
> > > overlay -olowerdir=3Dimg,upperdir=3Dupper,workdir=3Dwork merged
> > > mount: /srv/nfs/rpi/root/merged: mount(2) system call failed: Stale f=
ile handle.
> > >
> >
> > What are lower and upper?
>
> img was
> /dev/mapper/loop2p2 on /srv/nfs/rpi/buster/root/img type ext4 (rw,relatim=
e)
>
> > cat /proc/self/mountinfo please
>
> sorry, I've reinstalled the os and I'm not having this problem any more.
>
> > If you happen to be using squashfs for lower fs, there were a bunch
> > of changes and fixes in recent kernels.
>
> no squashfs
>
> >
> > > # this works:
> > > root@negk:/srv/nfs/rpi/root# mount -v -t overlay -o nfs_export=3Doff
> > > overlay -olowerdir=3Dimg,upperdir=3Dupper,workdir=3Dwork merged
> > > mount: overlay mounted on /srv/nfs/rpi/root/merged.
> > > root@negk:/srv/nfs/rpi/root# umount merged
> > >
> > > # syslog:
> > >
> > > [   80.317697] overlayfs: failed to verify origin (root/img,
> > > ino=3D2374476, err=3D-116)
> > > [   80.317703] overlayfs: failed to verify upper root origin
> > >
> > > # no help:
> > > systemctl disable nfs-server.service
> > > reboot
> > > root@negk:/srv/nfs/rpi/root# systemctl status nfs-server.service
> > > =E2=97=8F nfs-server.service - NFS server and services
> > >      Loaded: loaded (/lib/systemd/system/nfs-server.service; disabled=
;
> > > vendor preset: enabled)
> > >      Active: inactive (dead)
> > >
> >
> > The error has nothing to do with NFS.
> > The staleness is that of the root/img directory.
> > Overlayfs believes that someone has replaced the original
> > root/img directory with another directory on the same name
> > but a different file handle.
> >
>
> the only difference between error and no error was
>
> nfs_export=3Doff / on
>
> Which is mostly why I posted - this little detail seemed odd.

This is intentional as the documentation commit clarifies.
You are allowed to re-create lower dir when not enabling
index or nfs_export which implies index=3Don.
You are not allowed to re-create lower dir when using new features.
Specifically, index and nfs_export features simply cannot work
with re-created lower. Read about this in overlay documentation.

>
> > Did you re-create the lower image filesystem/subtree?
>
> maybe.  I'm futzing around with this pi image file trying to figure
> out how to manage various flavors of modifications. .
> I was hoping the lowest level would be the fs in the .img file, but
> there isn't a nice way to deal with the loop devices, so I'll copy the
> files onto the base ext5 fs and get on with things.
>

When you copy lower layer, you need to re-create an empty upper dir
you cannot mount an old upper dir with new lowerdir when nfs_export is
enabled.

> At the moment my little sysadmin project has lots of moving parts that
> are not at all reliable, it's hard to tell what is and isn't working.
> robust is the goal, I'm getting there.
>

Good luck.
Thanks,
Amir.
