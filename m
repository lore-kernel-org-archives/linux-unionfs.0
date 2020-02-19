Return-Path: <SRS0=YYYA=4H=vger.kernel.org=linux-unionfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.7 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A7A05C34050
	for <linux-unionfs@archiver.kernel.org>; Wed, 19 Feb 2020 13:26:09 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 8A9C424654
	for <linux-unionfs@archiver.kernel.org>; Wed, 19 Feb 2020 13:26:09 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727434AbgBSN0I (ORCPT
        <rfc822;linux-unionfs@archiver.kernel.org>);
        Wed, 19 Feb 2020 08:26:08 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:59725 "EHLO
        youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726977AbgBSN0I (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Wed, 19 Feb 2020 08:26:08 -0500
Received: from ip5f5bf7ec.dynamic.kabel-deutschland.de ([95.91.247.236] helo=wittgenstein)
        by youngberry.canonical.com with esmtpsa (TLS1.2:ECDHE_RSA_AES_128_GCM_SHA256:128)
        (Exim 4.86_2)
        (envelope-from <christian.brauner@ubuntu.com>)
        id 1j4PMa-00072o-5w; Wed, 19 Feb 2020 13:26:04 +0000
Date:   Wed, 19 Feb 2020 14:26:03 +0100
From:   Christian Brauner <christian.brauner@ubuntu.com>
To:     James Bottomley <James.Bottomley@HansenPartnership.com>
Cc:     Amir Goldstein <amir73il@gmail.com>,
        Miklos Szeredi <miklos@szeredi.hu>,
        Linux Containers <containers@lists.linux-foundation.org>,
        overlayfs <linux-unionfs@vger.kernel.org>,
        David Howells <dhowells@redhat.com>,
        Seth Forshee <seth.forshee@canonical.com>,
        Al Viro <viro@zeniv.linux.org.uk>,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>,
        Eric Biederman <ebiederm@xmission.com>, stgraber@ubuntu.com
Subject: Re: [PATCH v3 0/3] introduce a uid/gid shifting bind mount
Message-ID: <20200219132603.ivuttlgzixis2y2f@wittgenstein>
References: <20200217205307.32256-1-James.Bottomley@HansenPartnership.com>
 <CAOQ4uxjtp7d_xL20pGwvbFKqgAbyQhE=Pbw+e9Kj24wqF2hPfQ@mail.gmail.com>
 <1582042260.3416.19.camel@HansenPartnership.com>
 <20200218172606.ohlj6prhpmhodzqu@wittgenstein>
 <1582052748.16681.34.camel@HansenPartnership.com>
 <20200218200341.tzrehiapskznovx5@wittgenstein>
 <1582069398.16681.53.camel@HansenPartnership.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <1582069398.16681.53.camel@HansenPartnership.com>
Sender: linux-unionfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-unionfs.vger.kernel.org>
X-Mailing-List: linux-unionfs@vger.kernel.org

On Tue, Feb 18, 2020 at 03:43:18PM -0800, James Bottomley wrote:
> On Tue, 2020-02-18 at 21:03 +0100, Christian Brauner wrote:
> > On Tue, Feb 18, 2020 at 11:05:48AM -0800, James Bottomley wrote:
> > > On Tue, 2020-02-18 at 18:26 +0100, Christian Brauner wrote:
> [...]
> > > > But way more important: what Amir got right is that your approach
> > > > and fsid mappings don't stand in each others way at all. Shiftfed
> > > > bind-mounts can be implemented completely independent of fsid
> > > > mappings after the fact on top of it.
> > > > 
> > > > Your example, does this:
> > > > 
> > > > nsfd = open("/proc/567/ns/user", O_RDONLY);  /* note: not O_PATH
> > > > */
> > > > configfd_action(fd, CONFIGFD_SET_FD, "ns", NULL, nsfd);
> > > > 
> > > > as the ultimate step. Essentially marking a mountpoint as shifted
> > > > relative to that user namespace. Once fsid mappings are in all
> > > > that you need to do is replace your
> > > > make_kuid()/from_kuid()/from_kuid_munged() calls and so on in
> > > > your patchset with
> > > > make_kfsuid()/from_kfsuid()/from_kfsuid_munged() and you're done.
> > > > So I honestly don't currently see any need to block the patchsets
> > > > on each other. 
> > > 
> > > Can I repeat: there's no rush to get upstream on this.  Let's pause
> > > to get the kernel implementation (the thing we have to maintain)
> > > right.  I realise we could each work around the other and get our
> > > implementations bent around each other so they all work
> > > independently thus making our disjoint user cabals happy but I
> > > don't think that would lead to the best outcome for kernel
> > > maintainability.
> > 
> > We have had the discussion with all major stakeholders in a single
> > room on what we need at LPC 2019.
> 
> Well, you didn't invite me, so I think "stakeholders" means people we

I'm confused as you were in the room with everyone. It's even on the
schedule under your name:
https://linuxplumbersconf.org/event/4/contributions/474/

> selected because we like their use case.  More importantly:
> "stakeholders" traditionally means not only people who want to consume
> the feature but also people who have to maintain it ... how many VFS
> stakeholders were present?

Again, I'm confused you were in the room with at least David and Eric.

In any case, the patches are on the relevant lists. They are actively
being discussed and visible to everyone and we'll have time for proper
review which is already happening.
