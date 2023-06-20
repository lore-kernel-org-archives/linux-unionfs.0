Return-Path: <linux-unionfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DF79DEB64D7
	for <linux-unionfs@archiver.kernel.org>; Tue, 20 Jun 2023 10:12:10 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231231AbjFTKMK (ORCPT
        <rfc822;linux-unionfs@archiver.kernel.org>);
        Tue, 20 Jun 2023 06:12:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43320 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231561AbjFTKMI (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Tue, 20 Jun 2023 06:12:08 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 84D12A3
        for <linux-unionfs@vger.kernel.org>; Tue, 20 Jun 2023 03:12:07 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 1E27361199
        for <linux-unionfs@vger.kernel.org>; Tue, 20 Jun 2023 10:12:07 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A6F2CC433C8;
        Tue, 20 Jun 2023 10:12:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1687255926;
        bh=N0FKtAt003ujeU6xCc0ZvleiNag1ufsd/myrbU1Tn1Q=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=NAydyfK2IEgVztt3b7CgXeMPTe4CZe9EN1FRMCjeVYc90k0oz8Rb+JsqkgcvBEEGp
         NBF9SW1kEn/rJHL6/E1ZtmKlRL8lset4XHakoTCmlrZI2saY2VV1Q5nCFgmTWmEcJa
         fhJOmHutqMh6dpRquXPhu2gyRF8tJ+YfgPZMYuBleX87l+wzGA9xBqHKCVdZ4/CURc
         BBIidzoirYpXCGjScH4P1ZAvuj0efMwmcOfzdP87SKmpLTQySBTeYYajMjLXjGbSYw
         4QoVep3orGlmvy2p5JX2H33FdqXHv2KIuk6Ad+5scZj2mb1Yo7pN9fh5O4Tz4jjvqp
         /4r5XyysPoVpg==
Date:   Tue, 20 Jun 2023 12:12:02 +0200
From:   Christian Brauner <brauner@kernel.org>
To:     Amir Goldstein <amir73il@gmail.com>
Cc:     Miklos Szeredi <miklos@szeredi.hu>, linux-unionfs@vger.kernel.org
Subject: Re: [PATCH v2 0/5] Prep patches for porting overlayfs to new mount
 api
Message-ID: <20230620-euren-betiteln-cc3335d5579c@brauner>
References: <20230617084702.2468470-1-amir73il@gmail.com>
 <20230620-emblem-umgeladen-7d5c2cc0a8db@brauner>
 <CAOQ4uxjLm92xRoSoexheyAE49298++hAWs4MbqyT8KEAZJQtdQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAOQ4uxjLm92xRoSoexheyAE49298++hAWs4MbqyT8KEAZJQtdQ@mail.gmail.com>
Precedence: bulk
List-ID: <linux-unionfs.vger.kernel.org>
X-Mailing-List: linux-unionfs@vger.kernel.org

On Tue, Jun 20, 2023 at 12:46:52PM +0300, Amir Goldstein wrote:
> On Tue, Jun 20, 2023 at 12:26 PM Christian Brauner <brauner@kernel.org> wrote:
> >
> > On Sat, Jun 17, 2023 at 11:46:57AM +0300, Amir Goldstein wrote:
> > > Miklos,
> > >
> > > Following some more cleanup patches that make Christian's new mount api
> > > patches smaller and easier to review.
> > >
> > > I had rebased Christain's patches over these cleanups and pushed the
> > > result to github branch fs-overlayfs-mount_api [1].
> > >
> > > The v1 prep patches had a bug with xino option parsing that resulted in
> > > some tests being skipped (not failing) and I had only noticed the
> > > skipped test after posting v1.
> > >
> > > The v2 prep patches + new mount api patches have passed all the tests
> > > with no new tests skipped.
> > >
> > > In addition to running the tests with the default kernel config, I also
> > > ran the tests with the following non-default configs (individually):
> > >
> > > 1) CONFIG_OVERLAY_FS_REDIRECT_DIR=y
> > > 2) CONFIG_OVERLAY_FS_REDIRECT_ALWAYS_FOLLOW=n
> > > 3) CONFIG_OVERLAY_FS_XINO_AUTO=y
> >
> > Thanks for splitting some work into preparatory patches. I'm not sure
> > how worthwhile this actually is given they aren't marked as backports
> > for LTS releases so the overall delta ould still the same between LTSes
> > and mainline but it might make bisection easier.
> 
> Yeh, bisection, review, all the usual reasons for keep unrelated changes
> split. I am not usually fanatic about splitting hairs on this, but the
> mount api porting patch was already a big change that was hard for me to
> review and it grew all those extra additions like redirect_mode which
> were good changes, but not related, so I did this to make my own (and others)
> review of your patches easier.
> 
> I am glad if we are all happy with the end result.

Yeah, I appreciate the work and wasn't trying to critique it. I just
wouldn't have bothered because the mount api port in itself is
cumbersome enough. :)
