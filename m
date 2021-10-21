Return-Path: <linux-unionfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2531FC433EF
	for <linux-unionfs@archiver.kernel.org>; Thu, 21 Oct 2021 08:10:35 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 0318860FDA
	for <linux-unionfs@archiver.kernel.org>; Thu, 21 Oct 2021 08:10:34 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230440AbhJUIMt (ORCPT
        <rfc822;linux-unionfs@archiver.kernel.org>);
        Thu, 21 Oct 2021 04:12:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35888 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231239AbhJUIMt (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Thu, 21 Oct 2021 04:12:49 -0400
Received: from mail-ua1-x92c.google.com (mail-ua1-x92c.google.com [IPv6:2607:f8b0:4864:20::92c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E55D4C06161C
        for <linux-unionfs@vger.kernel.org>; Thu, 21 Oct 2021 01:10:33 -0700 (PDT)
Received: by mail-ua1-x92c.google.com with SMTP id r22so11531647uat.11
        for <linux-unionfs@vger.kernel.org>; Thu, 21 Oct 2021 01:10:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=nextdayvideo-com.20210112.gappssmtp.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=ZMvGWv/MagL159/9YX2pcsJdOngWrK19krnsQtC3fWc=;
        b=lgu4j2UqhD0CQwwCFgCI6sw70JYYEUrun9TrxqWyb+LAfHxVnUzxQe6KRdPSj5cfeN
         P+BoUz6MkO1uZMlZBC0H266NEKZVLX8LcsQPkjFTK9tFqv6hXMhlCzyirC6OuNGzuYgx
         vOa5cTZYwcwCXSRGWe2V/8e5+I2VwAh8o36GbK1BpMIKhagLZVjyYJ8hOt/ik5Ul+A/A
         tjkqmhTBbpb7v2lhzadBqI7h67pBgISBG+P43RNEABE+8IlPUepFoHibjn9E1H9BzHaf
         MjDrEza1MR6tUjfluCKZO4aweFKP6q5UJEOYoizQTVC1YIZg5/KoU9u+eDf6imP0zr3Q
         iMQQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=ZMvGWv/MagL159/9YX2pcsJdOngWrK19krnsQtC3fWc=;
        b=2CVAtGfiL0LdzVbH9ttTxz8otOeYq4HEJVfZ6wbRM7kOujmdKP8ODYSoaGbSMkr7NB
         HO8/+rrU3SMNplue5hglKV1IFPUx6cdzXBQApvLYmj45sGhX76w4fizF8+uDxAFBvJsa
         QRDFwZMyySsxx+RVuKOgmS65VcXsslwsByq7LGxCa2n+yUFt4pbjbDWnHap1zWoZr8tV
         cckzanNjHirW9Jr9kwm+ZdCnyfU+fWpeHg7f/zKOsaQixvKyUSZMrWj5bF/h5XsQyFjn
         Z56Ad0Nf23jvXzLv7aQdI02cYIMo9fzMjr0TZ+3x0zqES+IiQe5DWhpzDgXkBBp12mBG
         xrtA==
X-Gm-Message-State: AOAM533hyp/9lhyQiWBEcaR5aDR7/mEg36ulciTLfurIotiyUTjaig/6
        K5XAX++UAzeteAdRlXmkruiFmu8GyIFBCX6Thl7p+IIYci0=
X-Google-Smtp-Source: ABdhPJwTezu8SLeadIG9EZkt2aGPfRM9+gUGMNBaxhiAWQ5HO19ptx7MblEKVzOGtfangKXV8yqKx9P1LkZNHGCYVYg=
X-Received: by 2002:ab0:6dcd:: with SMTP id r13mr4479540uaf.74.1634803833013;
 Thu, 21 Oct 2021 01:10:33 -0700 (PDT)
MIME-Version: 1.0
References: <CADmzSSjy+bzPUus3xO2zT_USEKZYJ7WBOCbOiF+ro3EDoipXqg@mail.gmail.com>
 <CAOQ4uxgN50djKrqE4FYhC0pNpHdp5HDyQcSQX4+dHqOYp_NY6A@mail.gmail.com>
In-Reply-To: <CAOQ4uxgN50djKrqE4FYhC0pNpHdp5HDyQcSQX4+dHqOYp_NY6A@mail.gmail.com>
From:   Carl Karsten <carl@nextdayvideo.com>
Date:   Thu, 21 Oct 2021 03:10:06 -0500
Message-ID: <CADmzSSg5AZE61KMmUkrUMGVN=db4Q8kpB4vVuALzaN2uwg89rQ@mail.gmail.com>
Subject: Re: nfs server serving ... wrong mount?
To:     Amir Goldstein <amir73il@gmail.com>
Cc:     overlayfs <linux-unionfs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-unionfs.vger.kernel.org>
X-Mailing-List: linux-unionfs@vger.kernel.org

ah, non-disk filesystem is the problem.  thanks.

I had switched the mounts to use ..../base and everything was fine, so
I figured overlayfs was mucking something up.

I'm glad you enjoying my riddles :)

On Thu, Oct 21, 2021 at 2:09 AM Amir Goldstein <amir73il@gmail.com> wrote:
>
> On Thu, Oct 21, 2021 at 12:51 AM Carl Karsten <carl@nextdayvideo.com> wrote:
> >
> > I have 2 overlayfs monts.
> >
> > I can nfs export one or the other fine, but not both at the same time,
> > the client gets the wrong files.
>
> Hi Carl,
>
> Thanks for the daily overlayfs riddles ;-)
>
> This is not an overlayfs issue. It's nfs exports configuration issue.
> Please read the documentation of fsid export option.
> Disk filesystems have uuid so they don't need explicit identification.
> Overlayfs does not have a stable UUID.
>
> >
> > server hosthame negk bullseye ext4
> > client twist ubuntu
> >
> > juser@negk:~$ cat /etc/exports
> > # /srv/nfs/rpi/buster/boot/merged *(ro,sync,no_subtree_check,no_root_squash)
> > /srv/nfs/rpi/buster/root/merged *(ro,sync,no_subtree_check,no_root_squash)
>
> In this case, "root" is auto assigned fsid 1
>
> >
> > juser@negk:~$ ls /srv/nfs/rpi/buster/boot/merged
> > bcm2708-rpi-b.dtb       bcm2710-rpi-3-b-plus.dtb  fixup4cd.dat
> > kernel7.img       start4.elf
> > (snip)
> >
> > juser@negk:~$ ls /srv/nfs/rpi/buster/root/merged
> > bin  boot  dev  etc  home  lib  lost+found  media  mnt  opt  proc
> > root  run  sbin  srv  sys  tmp  usr  var
> >
> > carl@twist:~/mnt$ sudo mount -t nfs negk:/srv/nfs/rpi/buster/root/merged nfs
> > carl@twist:~/mnt$ ls nfs
> > bin  boot  dev  etc  home  lib  lost+found  media  mnt  opt  proc
> > root  run  sbin  srv  sys  tmp  usr  var
> > carl@twist:~/mnt$ sudo umount nfs
> >
> > # enable root in negk exports...
>
> I think you meant enable "boot"
> and is that case "boot" gets assigned fsid 1 and "root" gets reassigned fsid 2
>
> >
> > carl@twist:~/mnt$ sudo mount -t nfs negk:/srv/nfs/rpi/buster/root/merged nfs
> > carl@twist:~/mnt$ ls nfs
> > bcm2708-rpi-b.dtb       bcm2710-rpi-3-b-plus.dtb  fixup4cd.dat
> > kernel7.img       start4.elf
> > (snip)
> >
>
> It is a bit surprising to me that you get the wrong export after a clean mount,
> but it doesn't change the core configuration issue.
>
> Perhaps nfs client has some fsid cache or you have a deferred umount in
> the system of negk:/srv/nfs/rpi/buster/root/merged (e.g. due to spawned mount
> ns or something) and then the "new" nfs mount uses the old resolved fsid 1.
>
> In any case, when exporting more than one non-disk filesystem, you should
> use explicit fsid.
>
> Thanks,
> Amir.



-- 
Carl K
