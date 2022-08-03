Return-Path: <linux-unionfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C72F0C19F28
	for <linux-unionfs@archiver.kernel.org>; Wed,  3 Aug 2022 07:44:05 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231898AbiHCHoE (ORCPT
        <rfc822;linux-unionfs@archiver.kernel.org>);
        Wed, 3 Aug 2022 03:44:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35408 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229480AbiHCHoD (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Wed, 3 Aug 2022 03:44:03 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4AFAD20188
        for <linux-unionfs@vger.kernel.org>; Wed,  3 Aug 2022 00:44:02 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id C60E761558
        for <linux-unionfs@vger.kernel.org>; Wed,  3 Aug 2022 07:44:01 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 08892C433C1;
        Wed,  3 Aug 2022 07:43:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1659512641;
        bh=Syouqn06WGZjv6Q/0QaXzN8V71OL97OgH2UTjmSeZy4=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=mrqkPNgxo32HUlxc6SgzXBqy/OE8KAlTgWrK70RDKKbfNH6013xekKFR6FD5CI3Yu
         e/n/pXRnK5bovq3OrGYOarJYfpZJ/HAS/nMRxYOLCGEC/41eY0/OanQVxO44Hy79C9
         LSnuDqA9/C88c40Fwsjt4g62wiz6PLxy9iUj507Ism5+VKiR+ZWqVHXkezBWiHZB5X
         Zle1SmPYWZEh26ywiWA+G7oMwshlhoQ5pwxgpezKXrDUNQa8vqgdCLO8qbhG9Iu+G4
         X7qlGRNyL3pHpXwtWgRx+QqYfi4y3N0hA1D1H6XwyNXOewVtj9hClUJYegxQDESjR0
         IWayvfzkiAQpw==
Date:   Wed, 3 Aug 2022 09:43:56 +0200
From:   Christian Brauner <brauner@kernel.org>
To:     Miklos Szeredi <miklos@szeredi.hu>
Cc:     Yang Xu <xuyang2018.jy@fujitsu.com>,
        overlayfs <linux-unionfs@vger.kernel.org>,
        Seth Forshee <sforshee@kernel.org>
Subject: Re: [PATCH v2] overlayfs: improve ovl_get_acl
Message-ID: <20220803074356.bpo2tbfdfc6iifan@wittgenstein>
References: <1658976564-2163-1-git-send-email-xuyang2018.jy@fujitsu.com>
 <CAJfpegvyhaUAbVYmkAwfkrgsAeauU54GxMWt4fD89TB-zAGXWg@mail.gmail.com>
 <20220728142319.ddww4jrt7ighcj5y@wittgenstein>
 <CAJfpegst_95cCUd_LWg0i1X=KfD3wy3ExXnekkj+=6Ku7bB76A@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <CAJfpegst_95cCUd_LWg0i1X=KfD3wy3ExXnekkj+=6Ku7bB76A@mail.gmail.com>
Precedence: bulk
List-ID: <linux-unionfs.vger.kernel.org>
X-Mailing-List: linux-unionfs@vger.kernel.org

On Tue, Aug 02, 2022 at 03:46:00PM +0200, Miklos Szeredi wrote:
> On Thu, 28 Jul 2022 at 16:23, Christian Brauner <brauner@kernel.org> wrote:
> >
> > On Thu, Jul 28, 2022 at 03:06:21PM +0200, Miklos Szeredi wrote:
> > > On Thu, 28 Jul 2022 at 03:48, Yang Xu <xuyang2018.jy@fujitsu.com> wrote:
> > > >
> > > > Provide a proper stub for the !CONFIG_FS_POSIX_ACL case.
> > >
> > > Applied, thanks.
> >
> > Hey Miklos,
> >
> > Just an fyi that this will likely introduce a (somewhat minor) merge
> > conflict with the series to fix POSIX ACLs with overlayfs on top of
> > idmapped layers that I mentioned to you a few weeks ago in [1].
> >
> > The series is - as announced in the mail above - in [2] and been in next
> > for quite a while now.
> >
> > It's right before the mw so ideally I wouldn't want to rebase. Let me
> > know if I you want me to do anything. Ideally you could probably just
> > wait until I sent the PR next week.
> 
> Okay, thanks for the heads up.

Fyi, this has now been merged into mainline!

Thanks!
Christian
