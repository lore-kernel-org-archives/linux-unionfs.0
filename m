Return-Path: <linux-unionfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0A122C54E94
	for <linux-unionfs@archiver.kernel.org>; Thu, 26 Jan 2023 08:22:37 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229491AbjAZIWg (ORCPT
        <rfc822;linux-unionfs@archiver.kernel.org>);
        Thu, 26 Jan 2023 03:22:36 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48548 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229473AbjAZIWf (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Thu, 26 Jan 2023 03:22:35 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E906D677AE
        for <linux-unionfs@vger.kernel.org>; Thu, 26 Jan 2023 00:22:34 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 7530B61729
        for <linux-unionfs@vger.kernel.org>; Thu, 26 Jan 2023 08:22:34 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3272EC433EF;
        Thu, 26 Jan 2023 08:22:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1674721353;
        bh=Z9MLKJ3Xs+BT2DZ/a7oN5V8MVxt7RLqsDA9jSOXxHVY=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=HS6LNYOialN1BlGGlmpN/VEhyfcFqRjliG1hh5TzcryEtzVqVEctpz4amzIu72kt9
         n8zVvdgFDp5pVFplrgR/4o1qiKMOtlag+2yVE4cKxFijw1yS+Dy3jVfHACJ27s+gqC
         mtRqmZme5oouOLAeqX/hOIHVFPW0bS2ftnuVA8Nza/D1jZjsWsLAhytCRLStglubRs
         3jYiH1Etijqa7FTkl8hzjbAXg/dB5679GmGRGs4SCVStiWT9GZ7/3Bte08AQNy1HGt
         p1gPiNXpsNWZDl7Yk/ldeeFxxjp32NZ3fYucfVO3mPSpCSfblZ9y0GQWV9Ckkd6RaV
         lqAYz8iAdliJA==
Date:   Thu, 26 Jan 2023 09:22:28 +0100
From:   Christian Brauner <brauner@kernel.org>
To:     Amir Goldstein <amir73il@gmail.com>
Cc:     Giuseppe Scrivano <gscrivan@redhat.com>,
        Alexander Larsson <alexl@redhat.com>,
        Vivek Goyal <vgoyal@redhat.com>,
        Miklos Szeredi <miklos@szeredi.hu>,
        overlayfs <linux-unionfs@vger.kernel.org>
Subject: Re: userns mount and metacopy redirects (Was: Re: [PATCH v3 0/6]
 Composefs: an opportunistically sharing verified image filesystem)
Message-ID: <20230126082228.rweg75ztaexykejv@wittgenstein>
References: <87wn5ac2z6.fsf@redhat.com>
 <CAOQ4uxiPLHHnr2=XH4gN4bAjizH-=4mbZMe_sx99FKuPo-fDMQ@mail.gmail.com>
 <87o7qmbxv4.fsf@redhat.com>
 <CAOQ4uximBLqXDtq9vDhqR__1ctiiOMhMd03HCFUR_Bh_JFE-UQ@mail.gmail.com>
 <87fsbybvzq.fsf@redhat.com>
 <CAOQ4uxgos8m72icX+u2_6Gh7eMmctTTt6XZ=BRt3VzeOZH+UuQ@mail.gmail.com>
 <87wn5a9z4m.fsf@redhat.com>
 <CAOQ4uxi7GHVkaqxsQV6ninD9fhvMAPk1xFRM2aMRFXQZUV-s3Q@mail.gmail.com>
 <CAOQ4uxiZ4iB82F4i2zMPcyCB8EBFGObdAoBEcar0KE7sA5BoNA@mail.gmail.com>
 <CAOQ4uxi5zpnX1EX3P1Ya4OkRa867NkdtkGcHjTJ9ftvnTL+EhQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <CAOQ4uxi5zpnX1EX3P1Ya4OkRa867NkdtkGcHjTJ9ftvnTL+EhQ@mail.gmail.com>
Precedence: bulk
List-ID: <linux-unionfs.vger.kernel.org>
X-Mailing-List: linux-unionfs@vger.kernel.org

On Thu, Jan 26, 2023 at 07:26:49AM +0200, Amir Goldstein wrote:
> [spawning overlayfs sub-topic]
> 
> On Wed, Jan 25, 2023 at 10:29 PM Amir Goldstein <amir73il@gmail.com> wrote:
> >
> > On Wed, Jan 25, 2023 at 10:23 PM Amir Goldstein <amir73il@gmail.com> wrote:
> > >
> > > On Wed, Jan 25, 2023 at 9:45 PM Giuseppe Scrivano <gscrivan@redhat.com> wrote:
> > > >
> > > > Amir Goldstein <amir73il@gmail.com> writes:
> > > >
> > > > >> >> I previously mentioned my wish of using it from a user namespace, the
> > > > >> >> goal seems more challenging with EROFS or any other block devices.  I
> 
> For those who are starting to read here, the context is userns mounting
> of overlayfs with a lower EROFS layer containing metacopy references to
> lower data blobs in another fs (a.k.a the composefs model).
> 
> IMO, mounting a readonly image of whatever on-disk format
> is a very high risk for userns mount.
> A privileged mount helper that verifies and mounts the EROFS
> layer sounds like a more feasible solution.

Very much agreed. This filesystem specific userns mountable stuff where
filesystems with any kind of on-disk format guarantees the safety is not
something we should support.

I'm starting to think about how to make it possible for a privileged
process to delegate/allow a filesystem mount to an unprivileged one. The
policy belongs in userspace. Something which I've talked about before a
few years ago but now I actually have time to work on this.
