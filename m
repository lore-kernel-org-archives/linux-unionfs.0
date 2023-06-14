Return-Path: <linux-unionfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0ADC7EB64D7
	for <linux-unionfs@archiver.kernel.org>; Wed, 14 Jun 2023 03:28:19 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232504AbjFND2S (ORCPT
        <rfc822;linux-unionfs@archiver.kernel.org>);
        Tue, 13 Jun 2023 23:28:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50704 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231720AbjFND2R (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Tue, 13 Jun 2023 23:28:17 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3002E10C6
        for <linux-unionfs@vger.kernel.org>; Tue, 13 Jun 2023 20:28:16 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id B7FE263D03
        for <linux-unionfs@vger.kernel.org>; Wed, 14 Jun 2023 03:28:15 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E83F1C433C8;
        Wed, 14 Jun 2023 03:28:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1686713295;
        bh=a+HlJLYeq8o7HnH1H/VH4850veirKWW63c+q8NvpUXY=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=aJW0N4CSc/dClQUfzW3xnKBYBEV23IBcbvC+De6T5Pw7C1fk1aFU+9CzPw9j1imqm
         y5JIfZWSbvfKCpgUi5t95Yezzv6Quit5jA8yrk+XA1NGFTjIHHwIDBPc47tjssgWYN
         +8hPGLtuja4L6qpuaA9rgVqwHXG84+hhU59lw6S0XgnHl9TDpwR/IuWrohtoxZZEJU
         WEXbMC18sZa4r+Xh/XXpsSauoxK3IKdXActRabdSx86HvM39f5nC4zNkR7MR2iLXzz
         sqxni4p63B878742FHDPLFLLT6M57KVAuWq6ZMzf6Zu4k4W4XmgctwBiX13Vot56Tt
         1p/SDADDR1uyA==
Date:   Tue, 13 Jun 2023 20:28:13 -0700
From:   Eric Biggers <ebiggers@kernel.org>
To:     Alexander Larsson <alexl@redhat.com>
Cc:     miklos@szeredi.hu, linux-unionfs@vger.kernel.org,
        amir73il@gmail.com, tytso@mit.edu, fsverity@lists.linux.dev
Subject: Re: [PATCH v3 3/4] ovl: Validate verity xattr when resolving
 lowerdata
Message-ID: <20230614032813.GA1146@sol.localdomain>
References: <cover.1686565330.git.alexl@redhat.com>
 <dd294a44e8f401e6b5140029d8355f88748cd8fd.1686565330.git.alexl@redhat.com>
 <20230612190944.GB847@sol.localdomain>
 <CAL7ro1Feep_aQimxEJzKk+4cv6-UNgco3VNDKZrrC3y2u04DCw@mail.gmail.com>
 <20230613175759.GA1139@sol.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230613175759.GA1139@sol.localdomain>
Precedence: bulk
List-ID: <linux-unionfs.vger.kernel.org>
X-Mailing-List: linux-unionfs@vger.kernel.org

On Tue, Jun 13, 2023 at 10:57:59AM -0700, Eric Biggers wrote:
> On Tue, Jun 13, 2023 at 01:41:34PM +0200, Alexander Larsson wrote:
> > > Can you consider
> > > https://lore.kernel.org/r/20230612190047.59755-1-ebiggers@kernel.org which would
> > > make fsverity_get_digest() support both types of IDs?  Then you can use
> > > FS_VERITY_HASH_ALG_*, which I think would make things slightly easier for you.
> > 
> > Sounds very good to me. I'll rebase the patchset on top of it. Not
> > sure how to best land this though, are you ok with this landing via
> > overlayfs-next?
> 
> If you're confident that this series will land in v6.4, then sure, you can apply
> my patch "fsverity: rework fsverity_get_digest() again" to overlayfs-next,
> instead of me taking it through fsverity/for-next.  (Hopefully the IMA
> maintainer will ack it as well, as it touches security/integrity/.)
> 
> Just be careful about being overly-optimistic about features landing in the next
> release.  I've had experience with cases like this before, where I didn't apply
> something for a reason like this, but then the series didn't make it in right
> away so it was worse than me just taking the patch in the first place.
> 
> I do see that the other prerequisites were just applied to overlayfs-next, so
> maybe this is good to go now.  It's up to the other overlayfs folks.

I meant to say 6.5, not 6.4.

Anyway, just let me know if I should apply it or not, before it gets too late.

- Eric
