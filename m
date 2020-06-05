Return-Path: <SRS0=dsgN=7S=vger.kernel.org=linux-unionfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C22D8C433E0
	for <linux-unionfs@archiver.kernel.org>; Fri,  5 Jun 2020 15:13:11 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id ACFCD206DB
	for <linux-unionfs@archiver.kernel.org>; Fri,  5 Jun 2020 15:13:11 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728094AbgFEPNL (ORCPT
        <rfc822;linux-unionfs@archiver.kernel.org>);
        Fri, 5 Jun 2020 11:13:11 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:55519 "EHLO
        youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726601AbgFEPNL (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Fri, 5 Jun 2020 11:13:11 -0400
Received: from ip5f5af183.dynamic.kabel-deutschland.de ([95.90.241.131] helo=wittgenstein)
        by youngberry.canonical.com with esmtpsa (TLS1.2:ECDHE_RSA_AES_128_GCM_SHA256:128)
        (Exim 4.86_2)
        (envelope-from <christian.brauner@ubuntu.com>)
        id 1jhE1o-0001Y5-OX; Fri, 05 Jun 2020 15:13:04 +0000
Date:   Fri, 5 Jun 2020 17:13:03 +0200
From:   Christian Brauner <christian.brauner@ubuntu.com>
To:     Amir Goldstein <amir73il@gmail.com>
Cc:     Vivek Goyal <vgoyal@redhat.com>,
        overlayfs <linux-unionfs@vger.kernel.org>,
        StuartIanNaylor <rolyantrauts@gmail.com>,
        Linux Containers <containers@lists.linux-foundation.org>,
        kmxz <kxzkxz7139@gmail.com>, "zhangyi (F)" <yi.zhang@huawei.com>,
        Miklos Szeredi <miklos@szeredi.hu>
Subject: Re: OverlaysFS offline tools
Message-ID: <20200605151303.d77nlr7ewmxx6tp3@wittgenstein>
References: <CAOQ4uxjFC81hikgg0WaF0Z3Mxkk3iDakKx2Ttuhp_L_2Tnc6xQ@mail.gmail.com>
 <20200108140611.GA1995@redhat.com>
 <CAOQ4uxiUXk-=RV+cCXvE_0KMjW-3xqFFVkhNx7TmnbtMySh7Gw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <CAOQ4uxiUXk-=RV+cCXvE_0KMjW-3xqFFVkhNx7TmnbtMySh7Gw@mail.gmail.com>
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

Amir, excellent! Looking forward to this!
Christian
