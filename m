Return-Path: <SRS0=dsgN=7S=vger.kernel.org=linux-unionfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.6 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1C12FC433DF
	for <linux-unionfs@archiver.kernel.org>; Fri,  5 Jun 2020 05:33:21 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id D62D6207ED
	for <linux-unionfs@archiver.kernel.org>; Fri,  5 Jun 2020 05:33:20 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="V6n59qjv"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725962AbgFEFdU (ORCPT
        <rfc822;linux-unionfs@archiver.kernel.org>);
        Fri, 5 Jun 2020 01:33:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51720 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725280AbgFEFdU (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Fri, 5 Jun 2020 01:33:20 -0400
Received: from mail-io1-xd44.google.com (mail-io1-xd44.google.com [IPv6:2607:f8b0:4864:20::d44])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 15637C08C5C2
        for <linux-unionfs@vger.kernel.org>; Thu,  4 Jun 2020 22:33:20 -0700 (PDT)
Received: by mail-io1-xd44.google.com with SMTP id m81so8987001ioa.1
        for <linux-unionfs@vger.kernel.org>; Thu, 04 Jun 2020 22:33:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=b+ihbQAm8m+h8hB92otd8toQ+AjPKo6LWPdf7Hbr/6U=;
        b=V6n59qjvSOvITwlA8tV6ODEEPc6PSIf/3sjpfMZVzeuei+2XtXLXHVLqErMhxdbo7j
         0RKno3HN2dfF6PKuQh46G1WetExclCoEZFFSDzhz1EFn8DGtftALBCmdiefk+eEgFR/L
         DQlyqoxr4slYIDx8U13lGlnaySdlNfjhWbuu9QZyXIMedXHqDgKzdq13OSi3b7Kfzzlw
         W8SQNmKnvdpqGaY+Wb3gk9UK1zmWCChacPs15T1/GLIacjL97etI3IJDuJbrZorWdMBO
         6+UuI/LGzbpvBJ8sPqfp9OQYzbjCxFg1VcDilTchoGseicmox7EnQcW6DNe+yByJYu/G
         Ugkw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=b+ihbQAm8m+h8hB92otd8toQ+AjPKo6LWPdf7Hbr/6U=;
        b=D1lReW+3xew/TJPDIWs1iA0g+eue9fur3BKJNRHdHQTKBR+bgmjI3hfbRrZFIFFX/Q
         w8lYUq0Jt1oP2I6yl8MeaoN8rPdcoxsFu8qDSJliBm7hHv9IUKiGGd4O2gxSlpDKD5nj
         TJtvrdpByGtYW4MTH7yVsDiT4yfWiafS+6wXpwNV4J/VdxQmyf4j06E4uxI9zYm0Rd2H
         Ri+DnO3w1/4jFKznnrM9LJjShCQIZn/sPW9y0OI8l8PH5tSylZmg11P9Aq9IGsYKry+B
         xFDBhYfDjKfWTw98MgDlyWHfjZNCI3mdlWpAgC4ATC3vGMVedVg8dhKPvtHkxI71aEKA
         13hw==
X-Gm-Message-State: AOAM530B1dMgR7KjMHpWkIH7Ax6RO69+YqVbl8fp+eZMdRzscGepl7/O
        n+JFgfNGI5hUN6DfXio4/Ilx6nut9Hm3oz4QT9w=
X-Google-Smtp-Source: ABdhPJznLanseiDJ7qFvgXNjdyECPwLu9LK0labdWSw3kKuZYLWjZPZS2082LPaekXVUzHEzBA1epvjCS1c+5rjDgcw=
X-Received: by 2002:a05:6602:2a52:: with SMTP id k18mr7139781iov.64.1591335199112;
 Thu, 04 Jun 2020 22:33:19 -0700 (PDT)
MIME-Version: 1.0
References: <CAOQ4uxjFC81hikgg0WaF0Z3Mxkk3iDakKx2Ttuhp_L_2Tnc6xQ@mail.gmail.com>
 <20200108140611.GA1995@redhat.com>
In-Reply-To: <20200108140611.GA1995@redhat.com>
From:   Amir Goldstein <amir73il@gmail.com>
Date:   Fri, 5 Jun 2020 08:33:08 +0300
Message-ID: <CAOQ4uxiUXk-=RV+cCXvE_0KMjW-3xqFFVkhNx7TmnbtMySh7Gw@mail.gmail.com>
Subject: Re: OverlaysFS offline tools
To:     Vivek Goyal <vgoyal@redhat.com>
Cc:     overlayfs <linux-unionfs@vger.kernel.org>,
        StuartIanNaylor <rolyantrauts@gmail.com>,
        Linux Containers <containers@lists.linux-foundation.org>,
        kmxz <kxzkxz7139@gmail.com>, "zhangyi (F)" <yi.zhang@huawei.com>,
        Miklos Szeredi <miklos@szeredi.hu>,
        Christian Brauner <christian.brauner@ubuntu.com>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-unionfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-unionfs.vger.kernel.org>
X-Mailing-List: linux-unionfs@vger.kernel.org

On Wed, Jan 8, 2020 at 4:06 PM Vivek Goyal <vgoyal@redhat.com> wrote:
>
> On Wed, Jan 08, 2020 at 09:27:12AM +0200, Amir Goldstein wrote:
> > [-fsdevel,+containers]
> >
> > > On Thu, Apr 18, 2019 at 1:58 PM StuartIanNaylor <rolyantrauts@gmail.com> wrote:
> > > >
> > > > Apols to ask here but are there any tools for overlayFS?
> > > >
> > > > https://github.com/kmxz/overlayfs-tools is just about the only thing I
> > > > can find.
> > >
> > > There is also https://github.com/hisilicon/overlayfs-progs which
> > > can check and fix overlay layers, but it hasn't been updated in a while.
> > >
> >
> > Hi Vivek (and containers folks),
> >
> > Stuart has pinged me on https://github.com/StuartIanNaylor/zram-config/issues/4
> > to ask about the status of overlayfs offline tools.
> >
> > Quoting my answer here for visibility to more container developers:
> >
> > I have been involved with implementing many overlayfs features in the
> > kernel in the
> > past couple of years (redirect_dir,index,nfs_export,xino,metacopy).
> > All of these features bring benefits to end users, but AFAIK, they are
> > all still disabled
> > by default in containers runtimes (?) because lack of tools support
> > (e.g. migration
> > /import/export). I cannot force anyone to use the new overlayfs
> > features nor to write
> > offline tools support for them.
> >
> > So how can we improve this situation?
> >
> > If the problem is development resources then I've had great experience
> > in the past
> > with OSS internship programs like Google summer of code (GSoC):
> > Organizations, such as Redhat or mobyproject.org, can participate in the program
> > by posting proposals for open source projects.
> > Developers, such as myself, volunteer to mentors projects and students apply
> > to work on them.
> >
> > IIRC, the timeline for GSoC for project proposals in around April. Applying as
> > an organization could be before that.
> >
> > Vivek, since you are the only developer I know involved in containers runtime
> > projects I am asking you, but really its a question for all container developers
> > out there.
> >
> > Are you aware of missing features in containers that could be met by filling the
> > gaps with overlayfs offline tools?
>
> CCing Dan Walsh as he is taking care of podman and often I hear some of
> the the complaints from him w.r.t what he thinks is missing. This is
> not necessarily related to overlayfs offline tools.
>
> - Unpriviliged mounting of overlayfs.
>
>   He wants to launch containers unpriviliged and hence wants to be able
>   to mount overlayfs without being root in init_user_ns. I think Miklos
>   posted some patches for that but not much progress after that.
>
>   https://patchwork.kernel.org/cover/11212091/
>
> - shiftfs
>
>   As of now they are relying on doing chown of the image but will really
>   like to see the ability to shift uid/gids using shiftfs or using
>   VFS layer solution.
>
> - Overlayfs redirect_dir is not compatible with image building
>
>   redirect_dir is not compatible with image building and I think that's
>   one reason that its not used by default. And as metacopy is dependent
>   on redirect_dir, its not used by default as well. It can be used for
>   running containers though, but one needs to know that in advacnce.
>
>   So it will be good if that's fixed with redirect_dir and metacopy
>   features and then there is higher chance that these features are
>   enabled by default.
>
>   Miklos had some ides on how to tackle the issue of getting diff
>   correctly with redirect_dir enabled.
>
>   https://www.spinics.net/lists/linux-unionfs/msg06969.html
>

FYI, I have been playing with kmxz's overlay (offline tools).
It's a nice little tool :)
Adding "awareness" to redirect and metacopy was easy [1].

It should be easy to add support for command "export"
that does what Miklos suggested in order to migrate an image with
metacopy/redirect.

As a first step, command "vacuum" (or a new one) could be run
on layers to check if layers are already portable and then the
heavy weight "export" is not needed.

>   Having said that, I think Dan Walsh has enabled metacopy by default
>   in podman in certain configurations (for running containers and not
>   for building images).
>

I submitted a talk proposal to plumbers containers track about
enabling overlayfs features in container runtimes [2].

The last time I brought up this topic [3] the discussion quickly shifted
to the hot shiftfs (pun intended) and the same thing happened with this
thread about offline tools [4].
Please resist the temptation to do that again!
I realize shiftfs and userns overlay are high priority features for containers.
I trust they will gets their own talk on containers track.

Vivek,

It would be great if you could co-author this talk with me, although
it is intended to be more of a round table discussion anyway.
The main idea is to exchange knowledge between overlayfs users
and overlayfs developers.

Thanks,
Amir.

[1] https://github.com/amir73il/overlayfs-tools/commits/metacopy
[2] https://linuxplumbersconf.org/event/7/abstracts/601/
[3] https://lore.kernel.org/linux-unionfs/CAOQ4uxiQEpofdS97kxnii8LtVW2QiKAGvjjaH0Px-Bj3eHVCFA@mail.gmail.com/
[4] https://lore.kernel.org/linux-unionfs/70a7e65d-40a5-7940-0d4d-14cdbfef39bd@redhat.com/
