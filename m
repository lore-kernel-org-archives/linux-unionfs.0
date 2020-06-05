Return-Path: <SRS0=dsgN=7S=vger.kernel.org=linux-unionfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 52EFBC433DF
	for <linux-unionfs@archiver.kernel.org>; Fri,  5 Jun 2020 14:32:33 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 2923020659
	for <linux-unionfs@archiver.kernel.org>; Fri,  5 Jun 2020 14:32:33 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="c6zlc3uU"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727944AbgFEOcd (ORCPT
        <rfc822;linux-unionfs@archiver.kernel.org>);
        Fri, 5 Jun 2020 10:32:33 -0400
Received: from us-smtp-1.mimecast.com ([207.211.31.81]:30695 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1727113AbgFEOcc (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Fri, 5 Jun 2020 10:32:32 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1591367551;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=/1M7YRcPNUnOoP0iLjc2aCpb+Brq0ToDXEQ1b+kmXKI=;
        b=c6zlc3uUYisP2m8d9QQG2YvRiTxnBMQ6W5b4lsbbQjDELcCyzwvsnYWwB+6tzHP3Ebh4YU
        vIZW0xiwXXMDO23wIRIgnVi7sP9QP4ZEIjJFGWndo7Dw4SF7VHyGElItoV8pJyhXrXfbPC
        6dVp2yOxRqxtyKkC1+QePCipIREqFVI=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-381-44KsxrUMNKWbGf1tWKMO-w-1; Fri, 05 Jun 2020 10:32:22 -0400
X-MC-Unique: 44KsxrUMNKWbGf1tWKMO-w-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id D0778A0C13;
        Fri,  5 Jun 2020 14:32:18 +0000 (UTC)
Received: from horse.redhat.com (ovpn-116-65.rdu2.redhat.com [10.10.116.65])
        by smtp.corp.redhat.com (Postfix) with ESMTP id EE23C619C0;
        Fri,  5 Jun 2020 14:32:17 +0000 (UTC)
Received: by horse.redhat.com (Postfix, from userid 10451)
        id 80FCE22092C; Fri,  5 Jun 2020 10:32:17 -0400 (EDT)
Date:   Fri, 5 Jun 2020 10:32:17 -0400
From:   Vivek Goyal <vgoyal@redhat.com>
To:     Amir Goldstein <amir73il@gmail.com>
Cc:     overlayfs <linux-unionfs@vger.kernel.org>,
        StuartIanNaylor <rolyantrauts@gmail.com>,
        Linux Containers <containers@lists.linux-foundation.org>,
        kmxz <kxzkxz7139@gmail.com>, "zhangyi (F)" <yi.zhang@huawei.com>,
        Miklos Szeredi <miklos@szeredi.hu>,
        Christian Brauner <christian.brauner@ubuntu.com>
Subject: Re: OverlaysFS offline tools
Message-ID: <20200605143217.GB123988@redhat.com>
References: <CAOQ4uxjFC81hikgg0WaF0Z3Mxkk3iDakKx2Ttuhp_L_2Tnc6xQ@mail.gmail.com>
 <20200108140611.GA1995@redhat.com>
 <CAOQ4uxiUXk-=RV+cCXvE_0KMjW-3xqFFVkhNx7TmnbtMySh7Gw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAOQ4uxiUXk-=RV+cCXvE_0KMjW-3xqFFVkhNx7TmnbtMySh7Gw@mail.gmail.com>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
Sender: linux-unionfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-unionfs.vger.kernel.org>
X-Mailing-List: linux-unionfs@vger.kernel.org

On Fri, Jun 05, 2020 at 08:33:08AM +0300, Amir Goldstein wrote:
> On Wed, Jan 8, 2020 at 4:06 PM Vivek Goyal <vgoyal@redhat.com> wrote:
> >
> > On Wed, Jan 08, 2020 at 09:27:12AM +0200, Amir Goldstein wrote:
> > > [-fsdevel,+containers]
> > >
> > > > On Thu, Apr 18, 2019 at 1:58 PM StuartIanNaylor <rolyantrauts@gmail.com> wrote:
> > > > >
> > > > > Apols to ask here but are there any tools for overlayFS?
> > > > >
> > > > > https://github.com/kmxz/overlayfs-tools is just about the only thing I
> > > > > can find.
> > > >
> > > > There is also https://github.com/hisilicon/overlayfs-progs which
> > > > can check and fix overlay layers, but it hasn't been updated in a while.
> > > >
> > >
> > > Hi Vivek (and containers folks),
> > >
> > > Stuart has pinged me on https://github.com/StuartIanNaylor/zram-config/issues/4
> > > to ask about the status of overlayfs offline tools.
> > >
> > > Quoting my answer here for visibility to more container developers:
> > >
> > > I have been involved with implementing many overlayfs features in the
> > > kernel in the
> > > past couple of years (redirect_dir,index,nfs_export,xino,metacopy).
> > > All of these features bring benefits to end users, but AFAIK, they are
> > > all still disabled
> > > by default in containers runtimes (?) because lack of tools support
> > > (e.g. migration
> > > /import/export). I cannot force anyone to use the new overlayfs
> > > features nor to write
> > > offline tools support for them.
> > >
> > > So how can we improve this situation?
> > >
> > > If the problem is development resources then I've had great experience
> > > in the past
> > > with OSS internship programs like Google summer of code (GSoC):
> > > Organizations, such as Redhat or mobyproject.org, can participate in the program
> > > by posting proposals for open source projects.
> > > Developers, such as myself, volunteer to mentors projects and students apply
> > > to work on them.
> > >
> > > IIRC, the timeline for GSoC for project proposals in around April. Applying as
> > > an organization could be before that.
> > >
> > > Vivek, since you are the only developer I know involved in containers runtime
> > > projects I am asking you, but really its a question for all container developers
> > > out there.
> > >
> > > Are you aware of missing features in containers that could be met by filling the
> > > gaps with overlayfs offline tools?
> >
> > CCing Dan Walsh as he is taking care of podman and often I hear some of
> > the the complaints from him w.r.t what he thinks is missing. This is
> > not necessarily related to overlayfs offline tools.
> >
> > - Unpriviliged mounting of overlayfs.
> >
> >   He wants to launch containers unpriviliged and hence wants to be able
> >   to mount overlayfs without being root in init_user_ns. I think Miklos
> >   posted some patches for that but not much progress after that.
> >
> >   https://patchwork.kernel.org/cover/11212091/
> >
> > - shiftfs
> >
> >   As of now they are relying on doing chown of the image but will really
> >   like to see the ability to shift uid/gids using shiftfs or using
> >   VFS layer solution.
> >
> > - Overlayfs redirect_dir is not compatible with image building
> >
> >   redirect_dir is not compatible with image building and I think that's
> >   one reason that its not used by default. And as metacopy is dependent
> >   on redirect_dir, its not used by default as well. It can be used for
> >   running containers though, but one needs to know that in advacnce.
> >
> >   So it will be good if that's fixed with redirect_dir and metacopy
> >   features and then there is higher chance that these features are
> >   enabled by default.
> >
> >   Miklos had some ides on how to tackle the issue of getting diff
> >   correctly with redirect_dir enabled.
> >
> >   https://www.spinics.net/lists/linux-unionfs/msg06969.html
> >
> 
> FYI, I have been playing with kmxz's overlay (offline tools).
> It's a nice little tool :)
> Adding "awareness" to redirect and metacopy was easy [1].
> 
> It should be easy to add support for command "export"
> that does what Miklos suggested in order to migrate an image with
> metacopy/redirect.
> 
> As a first step, command "vacuum" (or a new one) could be run
> on layers to check if layers are already portable and then the
> heavy weight "export" is not needed.
> 
> >   Having said that, I think Dan Walsh has enabled metacopy by default
> >   in podman in certain configurations (for running containers and not
> >   for building images).
> >
> 
> I submitted a talk proposal to plumbers containers track about
> enabling overlayfs features in container runtimes [2].

Hi Amir,

I can't seem to access this abstract proposal (Despite the fact I 
created a new login id).

> 
> The last time I brought up this topic [3] the discussion quickly shifted
> to the hot shiftfs (pun intended) and the same thing happened with this
> thread about offline tools [4].
> Please resist the temptation to do that again!
> I realize shiftfs and userns overlay are high priority features for containers.
> I trust they will gets their own talk on containers track.

Miklos already posted patches once for allowing mounting overlayfs from
inside user namespace. He might have more to say on this.

> 
> Vivek,
> 
> It would be great if you could co-author this talk with me, although
> it is intended to be more of a round table discussion anyway.
> The main idea is to exchange knowledge between overlayfs users
> and overlayfs developers.

Sure. I can help write some sections of that talk (especially metacopy
feature) and anything else you want.

Thanks
Vivek

> 
> Thanks,
> Amir.
> 
> [1] https://github.com/amir73il/overlayfs-tools/commits/metacopy
> [2] https://linuxplumbersconf.org/event/7/abstracts/601/
> [3] https://lore.kernel.org/linux-unionfs/CAOQ4uxiQEpofdS97kxnii8LtVW2QiKAGvjjaH0Px-Bj3eHVCFA@mail.gmail.com/
> [4] https://lore.kernel.org/linux-unionfs/70a7e65d-40a5-7940-0d4d-14cdbfef39bd@redhat.com/
> 

