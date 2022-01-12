Return-Path: <linux-unionfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8B11CC433EF
	for <linux-unionfs@archiver.kernel.org>; Wed, 12 Jan 2022 21:04:09 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230210AbiALVEJ (ORCPT
        <rfc822;linux-unionfs@archiver.kernel.org>);
        Wed, 12 Jan 2022 16:04:09 -0500
Received: from vulcan.kevinlocke.name ([107.191.43.88]:54658 "EHLO
        vulcan.kevinlocke.name" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229436AbiALVEI (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Wed, 12 Jan 2022 16:04:08 -0500
X-Greylist: delayed 334 seconds by postgrey-1.27 at vger.kernel.org; Wed, 12 Jan 2022 16:04:08 EST
Received: from kevinolos.kevinlocke.name (098-127-251-251.res.spectrum.com [98.127.251.251])
        (Authenticated sender: kevin@kevinlocke.name)
        by vulcan.kevinlocke.name (Postfix) with ESMTPSA id 076AF2A5C4C3;
        Wed, 12 Jan 2022 20:58:32 +0000 (UTC)
Received: by kevinolos.kevinlocke.name (Postfix, from userid 1000)
        id CA4C213003B6; Wed, 12 Jan 2022 13:58:30 -0700 (MST)
Date:   Wed, 12 Jan 2022 13:58:30 -0700
From:   Kevin Locke <kevin@kevinlocke.name>
To:     Christoph Fritz <chf.fritz@googlemail.com>
Cc:     Miklos Szeredi <miklos@szeredi.hu>, linux-unionfs@vger.kernel.org
Subject: Re: [PATCH] ovl: fix NULL pointer dereference
Message-ID: <Yd9A9g9nsjwmbZtm@kevinlocke.name>
Mail-Followup-To: Kevin Locke <kevin@kevinlocke.name>,
        Christoph Fritz <chf.fritz@googlemail.com>,
        Miklos Szeredi <miklos@szeredi.hu>, linux-unionfs@vger.kernel.org
References: <10d8ed194b934c298713ad7f0958329b46573dd1.camel@googlemail.com>
 <c3ede9cee662964c174fdccc0039df8fa0a2be9b.camel@googlemail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <c3ede9cee662964c174fdccc0039df8fa0a2be9b.camel@googlemail.com>
Precedence: bulk
List-ID: <linux-unionfs.vger.kernel.org>
X-Mailing-List: linux-unionfs@vger.kernel.org

Hi Christoph,

On Wed, 2022-01-12 at 19:46 +0100, Christoph Fritz wrote:
> On Wed, 2022-01-12 at 19:33 +0100, Christoph Fritz wrote:
>> This patch is fixing a NULL pointer dereference to get a recently
>> introduced warning message working.

Good catch!

> With that patch applied, a lot of these are popping up now:
> 
> [    7.132514] overlayfs: failed to retrieve upper fileattr (index/#26, err=-25)
>
> [...]
> 
> These have been -ENOIOCTLCMD errors but got (falsely?) converted to
> -ENOTTY by the recently introduced commit 5b0a414d06c3 ("ovl: fix filattr copy-up failure"):

Which filesystem are you using for upper (and lower) in your mount?
Presumably the upper doesn't support file attributes, if it returns
-ENOIOCTLCMD?  If so, I guess the question would be what behavior
overlayfs should have when attributes can't be copied from lower to
upper, which is actually a question Miklos raised when that commit was
being worked on![^1]  Perhaps your use case can help inform a good
answer.

Cheers,
Kevin

[^1]: https://lore.kernel.org/linux-unionfs/CAJfpegsRo3e-9B64W37YrmvDcjo0QB9t+coAW3mO6TSqdROz2w@mail.gmail.com/
