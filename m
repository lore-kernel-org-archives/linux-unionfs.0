Return-Path: <linux-unionfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2AD1DEB64D8
	for <linux-unionfs@archiver.kernel.org>; Fri, 16 Jun 2023 05:24:56 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233252AbjFPFYu (ORCPT
        <rfc822;linux-unionfs@archiver.kernel.org>);
        Fri, 16 Jun 2023 01:24:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34740 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231208AbjFPFYt (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Fri, 16 Jun 2023 01:24:49 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D73D82720
        for <linux-unionfs@vger.kernel.org>; Thu, 15 Jun 2023 22:24:47 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 6C6DB61B2A
        for <linux-unionfs@vger.kernel.org>; Fri, 16 Jun 2023 05:24:47 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7BDECC433C0;
        Fri, 16 Jun 2023 05:24:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1686893086;
        bh=sNBzdaxC4gOaZV3QsOYf4M6kuKsGRf3UgyQBvJYxbgQ=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=rvSIF1o6Ok8EHU94PLqC9e/DOQDnxCglXhF+ybtugooPZxKDKuVnKFkvSSBPc/d7f
         ANV+CMIvHnyPgBsfgkMEznmbJkP5nvPZ2cWN1F4svGGaM3vqLOmqCewqyVXB02+sX2
         9rc0PzpoSU4jSRp3n5jknb+778xH8ZfTr0wEU85KCFDlEtzcou3vumyih8QB6faHCq
         Idckn4DXSLwCReBC4yBGhmGQF1R9oMvU6DIc2z8vDlU0U4cGJCukBJ0LQYT4enyp6D
         IVA8SBNRn69E5xUYVRUVpB6xEW74MZLFGtIqhvqioxbdahcSEKmk04LwwPXHz719T0
         hE23r2MXPn6mg==
Date:   Thu, 15 Jun 2023 22:24:44 -0700
From:   Eric Biggers <ebiggers@kernel.org>
To:     Amir Goldstein <amir73il@gmail.com>
Cc:     Alexander Larsson <alexl@redhat.com>, miklos@szeredi.hu,
        linux-unionfs@vger.kernel.org, tytso@mit.edu,
        fsverity@lists.linux.dev
Subject: Re: [PATCH v2 5/6] ovl: Validate verity xattr when resolving
 lowerdata
Message-ID: <20230616052444.GA181948@sol.localdomain>
References: <cover.1683102959.git.alexl@redhat.com>
 <b58e57955e122b5d6c4e087cf2dd6ed664152c7b.1683102959.git.alexl@redhat.com>
 <20230514191647.GD9528@sol.localdomain>
 <CAOQ4uxhEq8u37YNnqQmLbybJy1Kkg3Qk0TVtRZQP-yHt8CMmWA@mail.gmail.com>
 <CAL7ro1Hqc29w-FuRuoEfcsxiXTnqqwHP73nwvmZRuKVRsz4D9w@mail.gmail.com>
 <CAOQ4uxh_y+YO3q7dB=ALCriq31RhapOHGt+jcXTQbOC7iVqYTw@mail.gmail.com>
 <CAL7ro1GTzJy5Nv1vH0buVEXUnUk7cXBhSJB2ap8Jt_hutk7nYw@mail.gmail.com>
 <CAOQ4uxgbMD2RdEqta7a2t3uVceLuZDxOWA9SBNDAgZSdO_532Q@mail.gmail.com>
 <CAL7ro1FF_q7FEJdevWrqvugkJ9S8bU5MxcoHHrLC3D834u4+zQ@mail.gmail.com>
 <CAOQ4uxgo9LOM3minBH0vw3huxjrHmO5O-caGfhgOUGCuT0B9Vg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAOQ4uxgo9LOM3minBH0vw3huxjrHmO5O-caGfhgOUGCuT0B9Vg@mail.gmail.com>
Precedence: bulk
List-ID: <linux-unionfs.vger.kernel.org>
X-Mailing-List: linux-unionfs@vger.kernel.org

On Fri, Jun 16, 2023 at 08:07:43AM +0300, Amir Goldstein wrote:
> > I would really like to get the overlay.verity xattr support in
> > upstream pretty soon, because without it I can't release a stable
> > version of the composefs userspace code. I don't want to release
> > something that is using an xattr format that is not guaranteed to be
> > stable.
> >
> 
> Alex,
> 
> Pondering about this last sentence.
> 
> The overlay.verity xattr format is already in its 3rd revision since
> the beginning of development.
> 
> When it was bare digest, it might have made sense to have no
> header that describes the format.
> 
> When the algo byte was added, that was already a very big hint
> that a proper header was in order.
> 
> Now that you had to change the meaning of the byte, it is very hard
> to argue that the xattr format is guaranteed to be stable - in the sense
> that it can never change again.
> 
> Please add a minimal header to the overlay.verity xattr format,
> similar to ovl_fb, that will allow composefs/overlayfs to be
> maintained as the separate projects that they are.
> 
> Something like this?
> 
> /* On-disk format for "verity" xattr */
> struct ovl_verity {
>         u8 version;     /* 0 */
>         u8 len;          /* size of this header + size of digest */
>         u8 flags;
>         u8 algo;        /* digest algo */
>         u8 digest[];
> };
> 
> I realize that digest size may be inferred from xattr size,
> but it is better to state the stored digest size explicitly and verify
> that it matches expected xattr size.

If it was up to me I think I'd keep it even more "minimal" just do:

        struct ovl_verity {
                u8 version;     /* 0 */
                u8 algo;        /* digest algo */
                u8 digest[];
        };

It's up to you, though.  Keep in mind, the definition of a fsverity digest as
algorithm ID + raw digest is pretty fundamental to fsverity.  It's not
especially prone to change.  The confusion we had was just over what type of
algorithm ID to use.

(There is some inconsistency about whether the algorithm ID is u8, u16, or u32.
However, it's u8 on-disk in the fsverity_descriptor.  So it's fine for the
overlayfs xattr to use u8.)

> 
> Does the digest buffer passed to fsnotify helpers have any
> memory alignment requirements?

I think you're asking about the raw_digest argument to fsverity_get_digest()?
No, there's no alignment requirement.

- Eric
