Return-Path: <linux-unionfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CA1C2CDB47E
	for <linux-unionfs@archiver.kernel.org>; Thu, 12 Oct 2023 08:26:35 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235414AbjJLI0f (ORCPT
        <rfc822;linux-unionfs@archiver.kernel.org>);
        Thu, 12 Oct 2023 04:26:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43658 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235321AbjJLI0f (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Thu, 12 Oct 2023 04:26:35 -0400
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 19B4BA9
        for <linux-unionfs@vger.kernel.org>; Thu, 12 Oct 2023 01:26:34 -0700 (PDT)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2EB6AC433C7;
        Thu, 12 Oct 2023 08:26:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1697099193;
        bh=WtpD+iGhNIl/im3/HJRDqtpwqVwJXBzb5iYRZfAoOuI=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=KUWrXpGn99RiSXuR3xpEuNC/cV8LTrc4hw9bPa7jOqgjm2/G3rFMMyBILB+9r5o0p
         b0SJ6Vk/iapET++1r4hLKICvh97eJvzEAt3vqL/C8ZCtDPNpM9wur/lEL5ureizSMd
         1gzGreyWOyKKRYzXXlKmbw/yHfPOp8IT0SBxkEkGu6+47QycJdM97GpkkobhnJWQbd
         pKFHDUO7tKXdhNUjq36V3E1C7INs7JHDqEnG5/FYVeDws3bWM1yliuIX6v87UgzmbP
         d41HSJIf9gLam2W+LsEVyMprFoostl8zqk/gW5KetkHTWTw9+wLZU/jbz6GEJw9oPd
         LZi/vvx2xuhJQ==
Date:   Thu, 12 Oct 2023 10:26:24 +0200
From:   Christian Brauner <brauner@kernel.org>
To:     Miklos Szeredi <miklos@szeredi.hu>
Cc:     Amir Goldstein <amir73il@gmail.com>,
        Sebastian Wick <sebastian.wick@redhat.com>,
        Ryan Hendrickson <ryan.hendrickson@alum.mit.edu>,
        linux-unionfs@vger.kernel.org, Karel Zak <kzak@redhat.com>
Subject: Re: [regression?] escaping commas in overlayfs mount options
Message-ID: <20231012-klaut-dohle-e87948620243@brauner>
References: <CAOQ4uxgNr=ZbHTB8TcMfWLceBoQD0a2u4Bzo3-Hr3QZTRoBjLQ@mail.gmail.com>
 <CA+hFU4w78Ze-wKPg9fsdR6zpL5VUwp8jNqCcHGmOFJ--GAGKJA@mail.gmail.com>
 <CAOQ4uxhSTJaZggq-z_3oPbXh48n88E1QjfNTr5HO1ZuqyrF+ew@mail.gmail.com>
 <CA+hFU4w8mdo1DrWPU3MNM=YBXE9aVD2yFOe_zXXq1U51B0h7kw@mail.gmail.com>
 <CAOQ4uxjhpKU=YfG7KjAYtyQNFzVSpwpYEvPvbMZL_fXssqk1Dg@mail.gmail.com>
 <CAJfpegt3AasPxXt-bX35LB_xP0YXvvETMX98FKJJFK5RX1Q78w@mail.gmail.com>
 <CAOQ4uxgc2YegLuZKg4WLnOCn8-e-hxHJh7LD4=w-x--Fg7fdpw@mail.gmail.com>
 <CAJfpegvLZfYtYo2rbvJOmhbHGE5hoWaoGeb5r4hiTMQOpv0GbQ@mail.gmail.com>
 <CAOQ4uxgBW03c9ZYvKKdD_n1z70fb=+-f6xYLzcZ6AWC3O04cXw@mail.gmail.com>
 <CAJfpegvngPP1KnM7JF4ofdmSVG0XH_NeOC+B97iJZbCgvfAWFw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <CAJfpegvngPP1KnM7JF4ofdmSVG0XH_NeOC+B97iJZbCgvfAWFw@mail.gmail.com>
Precedence: bulk
List-ID: <linux-unionfs.vger.kernel.org>
X-Mailing-List: linux-unionfs@vger.kernel.org

> > Christian,
> >
> > Do you know any userspace that already uses your new append prefixes?
> > Do we have any good reason to support "lowerdir_first"
> > so a lower dir stack could be reset before creating the sb?
> 
> If that is a requirement, I suggest extending fsconfig(2) to allow
> resetting an option.

Overlayfs does already support this. If you pass:
fsconfig(FSCONFIG_SET_STRING, "lowerdir", "", ...)
then the lower layer stack is reset. I've implemented it that way in
ovl_parse_param_lowerdir().

> 
> > > > > >
> > > > > > Anyway, let's focus on what you would like best.
> > > > > > If you prefer to just fix the regression, it is doable.
> > > > > > If you prefer the upperdirfd, workdirfd, lowerdirfd API, I think we can
> > > > > > find a volunteer to write it up.
> 
> Can't the existing option names be overloaded if a separate cmd
> (FSCONFIG_SET_PATH or FSCONFIG_SET_PATH_EMPTY) is used in fsconfig()?

Yes, they can and filesystems do do that today depending on whether they
want to e.g., take an fd or a path or something.
