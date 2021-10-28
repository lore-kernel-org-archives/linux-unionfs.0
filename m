Return-Path: <linux-unionfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 482B9C433EF
	for <linux-unionfs@archiver.kernel.org>; Thu, 28 Oct 2021 18:44:33 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 2CDEC60D43
	for <linux-unionfs@archiver.kernel.org>; Thu, 28 Oct 2021 18:44:33 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230401AbhJ1Sq6 (ORCPT
        <rfc822;linux-unionfs@archiver.kernel.org>);
        Thu, 28 Oct 2021 14:46:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34204 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229645AbhJ1Sq6 (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Thu, 28 Oct 2021 14:46:58 -0400
Received: from mail-ua1-x930.google.com (mail-ua1-x930.google.com [IPv6:2607:f8b0:4864:20::930])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 23E80C061570
        for <linux-unionfs@vger.kernel.org>; Thu, 28 Oct 2021 11:44:31 -0700 (PDT)
Received: by mail-ua1-x930.google.com with SMTP id q13so13460435uaq.2
        for <linux-unionfs@vger.kernel.org>; Thu, 28 Oct 2021 11:44:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=nextdayvideo-com.20210112.gappssmtp.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=mEsQ1vyYSqL+5Vtft07FW46B+Tg7ZkE9pMNJl8LdPbw=;
        b=dJwqESvuoHIWblCwngavCgePoxpb8rq3MZqSJLKJuB9Cqts4/CKEiN+V40lo2SW/3A
         kS8glXDodQe/8EiUxDbPWqGG8R3xPHXXoMUQGyL/mpfK5OkOcizBXosd6N52qmphGJMQ
         Ep06PUB1Padn/T29wtrAYOLGykNPuzBr7MOnWDlfbiejmsCkuvr/BRE2mG/B1jaGbW4J
         0JRftIBh1q4ZENpzPow6/dAPjNtcdt8tV9LMiq3mPx2J3YZG122X8SXNyt+ylEv6/xPs
         BLikiVQl+P706/ZzL4IrRnuYGBLAVgRQspeeiHyP4XfRMcQ+9scB1DLooYDgpfs/pwzy
         qlxg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=mEsQ1vyYSqL+5Vtft07FW46B+Tg7ZkE9pMNJl8LdPbw=;
        b=AjD0HrPOpnvbNrncNH1eyoK7picsm7pTIOKmAku+pIQQQbYgb3PLadhUZfeaSzw/kb
         suO6c/wOG+pyL47lcrjXyAXFjaaA7SP977SUHttfWJSQGFLFORCUuV7UQGfJrCwE3TB4
         XHmxUaLkw9ICDGzxv1JB9c96GoMPty+szG1tiEeoiztGqM27D4y+REOQnC6tzwwTC9M7
         Itu2Helm4+NUr6Htrwv1HT5wEqYkGcram3ybPyPE0K56HTImiU6i0ZPGIQjVDXyAbEQr
         DmyTym6Os/HDAnbV1hvSDqmS9B9lKwteDCg+/C+TfpSPZI7xKp2hcVGi/JtTgJZAFraG
         dFSQ==
X-Gm-Message-State: AOAM533/CJbI8aQ/fmpyXSGJDy6iU2n3iOzSwN2uf3QROFA+xMU4jNfM
        BEYxX2RpcmxnsNv/1CJafm+aftG6WhseiBBtkRtb6tviwcY=
X-Google-Smtp-Source: ABdhPJwR2lHRARqqGgI0NAfpr8RBTcus/lpLBG3YVxPH+sLzGQO0GbRWm8gol8VwapoTtY2KC1IeXhj83SLabEeM6S8=
X-Received: by 2002:a05:6102:548d:: with SMTP id bk13mr6155742vsb.6.1635446669736;
 Thu, 28 Oct 2021 11:44:29 -0700 (PDT)
MIME-Version: 1.0
References: <CADmzSSgiJ8jS5Ss-P+7_vXowM_TVNhwySE=QHwDhjG0Uj0Xr1g@mail.gmail.com>
 <CAOQ4uxiRthg8vMiFwNUW=V3HZhGyufgqFWBsBTh_SXVyXDO1jA@mail.gmail.com>
 <CADmzSSheLbJTJxfS6xF5jV4dauRZkt7OY7v9oPkpjQmnHpx_9Q@mail.gmail.com> <CAOQ4uxghLQCLf6O9Q1GdgPsB1-OeessRCAtdehnOsa89RpxuWQ@mail.gmail.com>
In-Reply-To: <CAOQ4uxghLQCLf6O9Q1GdgPsB1-OeessRCAtdehnOsa89RpxuWQ@mail.gmail.com>
From:   Carl Karsten <carl@nextdayvideo.com>
Date:   Thu, 28 Oct 2021 13:44:01 -0500
Message-ID: <CADmzSSjQN0=ymETAavgKWBgOsTFpZAkL-WKk+SZum8quHsu2NQ@mail.gmail.com>
Subject: Re: nfs_export Stale file handle
To:     Amir Goldstein <amir73il@gmail.com>
Cc:     overlayfs <linux-unionfs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <linux-unionfs.vger.kernel.org>
X-Mailing-List: linux-unionfs@vger.kernel.org

 bumping into this again, and now I have more stable .. thing.

my stack of dirs:
base - copy of files from raspios-buster-armhf-lite.img
setup - config files my setup adds
updates - apt update/upgrade
play - random things I am testing

work - overlayfs working dir
merged - overlayfs mount point

I cp files in base and setup,
mount base setup updates play on mounted
write some files into mounted

Now I want to undo:
rm play work merged
mkdir play work merged
mount...
error Stale file handle.

juser@negk:~$ sudo ./test.sh
+ rm -rf /srv/nfs/rpi/buster/boot/play /srv/nfs/rpi/buster/boot/work
/srv/nfs/rpi/buster/boot/merged
+ mkdir /srv/nfs/rpi/buster/boot/play /srv/nfs/rpi/buster/boot/work
/srv/nfs/rpi/buster/boot/merged
+ mount -t overlay overlay -o
nfs_export=3Don,lowerdir=3D/srv/nfs/rpi/buster/boot/base:/srv/nfs/rpi/buste=
r/boot/setup,upperdir=3D/srv/nfs/rpi/buster/boot/updates,workdir=3D/srv/nfs=
/rpi/buster/boot/work
/srv/nfs/rpi/buster/boot/merged
mount: /srv/nfs/rpi/buster/boot/merged: mount(2) system call failed:
Stale file handle.
[ 1602.271239] overlayfs: failed to verify origin (boot/base,
ino=3D4194652, err=3D-116)
[ 1602.271244] overlayfs: failed to verify upper root origin

On Wed, Oct 20, 2021 at 2:47 AM Amir Goldstein <amir73il@gmail.com> wrote:
>
> On Wed, Oct 20, 2021 at 9:49 AM Carl Karsten <carl@nextdayvideo.com> wrot=
e:
> >
> > On Wed, Oct 20, 2021 at 12:42 AM Amir Goldstein <amir73il@gmail.com> wr=
ote:
> > >
> > > On Tue, Oct 19, 2021 at 10:49 PM Carl Karsten <carl@nextdayvideo.com>=
 wrote:
> > > >
> > > > I am sure this worked once, then I rebooted and now something ....
> > >
> > > Are you saying it is a regression? From which kernel?
> >
> > Not a regression - just something that I am sure was OK on my box,
> > then 20 min later the 'same thing' is causing problems.  We all know
> > it isn't the same, but this is what has me scratching my head.
> >
> > >
> > > >
> > > > root@negk:/srv/nfs/rpi/root# mount -v -t overlay -o nfs_export=3Don
> > > > overlay -olowerdir=3Dimg,upperdir=3Dupper,workdir=3Dwork merged
> > > > mount: /srv/nfs/rpi/root/merged: mount(2) system call failed: Stale=
 file handle.
> > > >
> > >
> > > What are lower and upper?
> >
> > img was
> > /dev/mapper/loop2p2 on /srv/nfs/rpi/buster/root/img type ext4 (rw,relat=
ime)
> >
> > > cat /proc/self/mountinfo please
> >
> > sorry, I've reinstalled the os and I'm not having this problem any more=
.
> >
> > > If you happen to be using squashfs for lower fs, there were a bunch
> > > of changes and fixes in recent kernels.
> >
> > no squashfs
> >
> > >
> > > > # this works:
> > > > root@negk:/srv/nfs/rpi/root# mount -v -t overlay -o nfs_export=3Dof=
f
> > > > overlay -olowerdir=3Dimg,upperdir=3Dupper,workdir=3Dwork merged
> > > > mount: overlay mounted on /srv/nfs/rpi/root/merged.
> > > > root@negk:/srv/nfs/rpi/root# umount merged
> > > >
> > > > # syslog:
> > > >
> > > > [   80.317697] overlayfs: failed to verify origin (root/img,
> > > > ino=3D2374476, err=3D-116)
> > > > [   80.317703] overlayfs: failed to verify upper root origin
> > > >
> > > > # no help:
> > > > systemctl disable nfs-server.service
> > > > reboot
> > > > root@negk:/srv/nfs/rpi/root# systemctl status nfs-server.service
> > > > =E2=97=8F nfs-server.service - NFS server and services
> > > >      Loaded: loaded (/lib/systemd/system/nfs-server.service; disabl=
ed;
> > > > vendor preset: enabled)
> > > >      Active: inactive (dead)
> > > >
> > >
> > > The error has nothing to do with NFS.
> > > The staleness is that of the root/img directory.
> > > Overlayfs believes that someone has replaced the original
> > > root/img directory with another directory on the same name
> > > but a different file handle.
> > >
> >
> > the only difference between error and no error was
> >
> > nfs_export=3Doff / on
> >
> > Which is mostly why I posted - this little detail seemed odd.
>
> This is intentional as the documentation commit clarifies.
> You are allowed to re-create lower dir when not enabling
> index or nfs_export which implies index=3Don.
> You are not allowed to re-create lower dir when using new features.
> Specifically, index and nfs_export features simply cannot work
> with re-created lower. Read about this in overlay documentation.
>
> >
> > > Did you re-create the lower image filesystem/subtree?
> >
> > maybe.  I'm futzing around with this pi image file trying to figure
> > out how to manage various flavors of modifications. .
> > I was hoping the lowest level would be the fs in the .img file, but
> > there isn't a nice way to deal with the loop devices, so I'll copy the
> > files onto the base ext5 fs and get on with things.
> >
>
> When you copy lower layer, you need to re-create an empty upper dir
> you cannot mount an old upper dir with new lowerdir when nfs_export is
> enabled.
>
> > At the moment my little sysadmin project has lots of moving parts that
> > are not at all reliable, it's hard to tell what is and isn't working.
> > robust is the goal, I'm getting there.
> >
>
> Good luck.
> Thanks,
> Amir.



--=20
Carl K
