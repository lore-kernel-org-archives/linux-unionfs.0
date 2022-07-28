Return-Path: <linux-unionfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0A5D1C04A68
	for <linux-unionfs@archiver.kernel.org>; Thu, 28 Jul 2022 14:23:29 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231379AbiG1OX2 (ORCPT
        <rfc822;linux-unionfs@archiver.kernel.org>);
        Thu, 28 Jul 2022 10:23:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52078 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229475AbiG1OX1 (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Thu, 28 Jul 2022 10:23:27 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B602450727
        for <linux-unionfs@vger.kernel.org>; Thu, 28 Jul 2022 07:23:26 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 51AB5B8247E
        for <linux-unionfs@vger.kernel.org>; Thu, 28 Jul 2022 14:23:25 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C2256C433D7;
        Thu, 28 Jul 2022 14:23:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1659018204;
        bh=Z9kGMvisHpVHulTHpfKT6dnOV1vJizcChSJvizKebKo=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=LiHlzZv6gGc4EkjJtl2Ee3OYSsCNM5GRlFB7WhJZ4k2bY4Kd7LQpFaWCIWrflYphi
         MaP1MjHFb9hV3JlHcQkRQWYLY4zo4MVM9RIYuMrzemsHeZ8jPP20tqaavokcM1hlp/
         DyFBRH7etknQHmHaDa6qmLglNKmjvuuNsx2F+ar50q01q6YPNtlbcy1nzIvApOfny0
         wGnc5+9TFTaNLbvpvKBD0riv6ZyD0Jr4YFMkTPz1AmCNEr37eZLMjJMGFv9vn+QbD3
         Zwd9I53rOEyMzIPtmjZvTbjTlpOa3GtqBIvbdCtMpmxygimb2ixdHgiPVrKej2thnm
         57FhqY5w/ElgQ==
Date:   Thu, 28 Jul 2022 16:23:19 +0200
From:   Christian Brauner <brauner@kernel.org>
To:     Miklos Szeredi <miklos@szeredi.hu>
Cc:     Yang Xu <xuyang2018.jy@fujitsu.com>,
        overlayfs <linux-unionfs@vger.kernel.org>,
        Seth Forshee <sforshee@kernel.org>
Subject: Re: [PATCH v2] overlayfs: improve ovl_get_acl
Message-ID: <20220728142319.ddww4jrt7ighcj5y@wittgenstein>
References: <1658976564-2163-1-git-send-email-xuyang2018.jy@fujitsu.com>
 <CAJfpegvyhaUAbVYmkAwfkrgsAeauU54GxMWt4fD89TB-zAGXWg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <CAJfpegvyhaUAbVYmkAwfkrgsAeauU54GxMWt4fD89TB-zAGXWg@mail.gmail.com>
Precedence: bulk
List-ID: <linux-unionfs.vger.kernel.org>
X-Mailing-List: linux-unionfs@vger.kernel.org

On Thu, Jul 28, 2022 at 03:06:21PM +0200, Miklos Szeredi wrote:
> On Thu, 28 Jul 2022 at 03:48, Yang Xu <xuyang2018.jy@fujitsu.com> wrote:
> >
> > Provide a proper stub for the !CONFIG_FS_POSIX_ACL case.
> 
> Applied, thanks.

Hey Miklos,

Just an fyi that this will likely introduce a (somewhat minor) merge
conflict with the series to fix POSIX ACLs with overlayfs on top of
idmapped layers that I mentioned to you a few weeks ago in [1].

The series is - as announced in the mail above - in [2] and been in next
for quite a while now.

It's right before the mw so ideally I wouldn't want to rebase. Let me
know if I you want me to do anything. Ideally you could probably just
wait until I sent the PR next week.

Thanks!
Christian

[1]: https://lore.kernel.org/linux-unionfs/20220713101814.d5vg3qcc2qk46vqs@wittgenstein/raw
[2]: https://git.kernel.org/pub/scm/linux/kernel/git/brauner/linux.git/log/?h=fs.idmapped.overlay.acl
