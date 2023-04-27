Return-Path: <linux-unionfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EB863C77B61
	for <linux-unionfs@archiver.kernel.org>; Thu, 27 Apr 2023 17:58:25 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244039AbjD0R6Z (ORCPT
        <rfc822;linux-unionfs@archiver.kernel.org>);
        Thu, 27 Apr 2023 13:58:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38670 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229539AbjD0R6Y (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Thu, 27 Apr 2023 13:58:24 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 864333A91
        for <linux-unionfs@vger.kernel.org>; Thu, 27 Apr 2023 10:58:23 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 1FB9263EC2
        for <linux-unionfs@vger.kernel.org>; Thu, 27 Apr 2023 17:58:23 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5335BC433EF;
        Thu, 27 Apr 2023 17:58:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1682618302;
        bh=jydreXTrkzBK4j1QQvAcqSBGsTsp36XuvyGcc7jG60w=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=aCmKhrcO3KsLyOka0Q/mTS3kh6m9hE+LR317pKl9NKBH34lnFI2cZ58dyAc/pZXPW
         bn06KheMS3BwWIiDtmf377tQ+TUTc9Fyvw6qbrtnYEcHYHlriHw4QZa1/AKgrnCMNj
         YLB4CboQAbReaCYGA+/rpQZaq7s7BqXSo0L9VwkgkXtN8TkutS1DdOLI/eXFCjN4Oo
         abtej6YfxHbN8gzGAThi2xlYKQPEm+Wx1hMrQMipBP1WNt4BnWiQH+DYnErzOwuE54
         D1XIz2QKi2xuzBcZAEE4hNpQTJIdpqSx+/IeSzxl0dGQvRpTCjrCerQzMPNaDkjEkm
         EDZQGSSrt3H2w==
Date:   Thu, 27 Apr 2023 17:58:20 +0000
From:   Eric Biggers <ebiggers@kernel.org>
To:     Alexander Larsson <alexl@redhat.com>
Cc:     miklos@szeredi.hu, linux-unionfs@vger.kernel.org,
        amir73il@gmail.com, tytso@mit.edu, fsverity@lists.linux.dev
Subject: Re: [PATCH 5/6] ovl: Validate verity xattr when resolving lowerdata
Message-ID: <ZEq3vN09rhEAr19w@gmail.com>
References: <cover.1681917551.git.alexl@redhat.com>
 <df41e9dc96ddad9f9e1e684e39c28f4e097e9d9b.1681917551.git.alexl@redhat.com>
 <20230426214743.GA58528@sol.localdomain>
 <CAL7ro1EYZXUQM+Ygp3aO8-rWD0ULZyaJH4rN_+88LNS4h5p78w@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAL7ro1EYZXUQM+Ygp3aO8-rWD0ULZyaJH4rN_+88LNS4h5p78w@mail.gmail.com>
Precedence: bulk
List-ID: <linux-unionfs.vger.kernel.org>
X-Mailing-List: linux-unionfs@vger.kernel.org

On Thu, Apr 27, 2023 at 09:22:57AM +0200, Alexander Larsson wrote:
> On Wed, Apr 26, 2023 at 11:47 PM Eric Biggers <ebiggers@kernel.org> wrote:
> >
> > On Thu, Apr 20, 2023 at 09:44:04AM +0200, Alexander Larsson wrote:
> > > +     err = fsverity_get_digest(d_inode(datapath->dentry), actual_digest, &verity_algo);
> > > +     if (err < 0) {
> > > +             pr_warn_ratelimited("lower file '%pd' has no fs-verity digest\n", datapath->dentry);
> > > +             return -EIO;
> > > +     }
> > > +
> > > +     if (digest_len != hash_digest_size[verity_algo] ||
> > > +         memcmp(required_digest, actual_digest, digest_len) != 0) {
> > > +             pr_warn_ratelimited("lower file '%pd' has the wrong fs-verity digest\n",
> > > +                                 datapath->dentry);
> > > +             return -EIO;
> > > +     }
> > > +
> > > +     return 0;
> >
> > This is incorrect because the digest algorithm is not being compared.
> 
> This is actually an interesting question. How much are things weakened
> by comparing the digest size, but not comparing the digest type. Like,
> suppose the xattr has a sha256 digest (32 bytes), how likely is there
> to be another new supported verity algorithm of the same digest size
> where you can force it to produce matching digests?

It might actually be fairly likely, considering that whenever a system includes
a choice of cryptographic algorithm, it tends to grow to include many different
algorithms.  Some of the reasons for this include:

  - Algorithms can become outdated and broken, yet systems often have to
    continue to support such algorithms for backwards compatibility.

  - People sometimes insist on using "national pride" algorithms, e.g. due to
    government regulations.  For example, in China people can be required to use
    Chinese algorithms instead of the U.S. / NIST algorithms.  See e.g. the
    existing support for SM3, SM4, Streebog, and Aria in the kernel crypto API
    and various other kernel subsystems.

  - Non-cryptographic algorithms might be added for use cases that don't
    actually require cryptographic security, e.g. integrity-only.

I'd strongly discourage you from building something whose security critically
depends on every algorithm that may ever exist being cryptographically secure.

Also, two hash algorithms that are each secure individually are not necessarily
secure when used as alternatives sharing the same output space.  E.g. consider
algorithm1 = SHA-256(data) and algorithm2 = SHA-256(data with all bits flipped).

> 
> I ask because ideally we want to minimize the size of the xattrs,
> since they are stored for each file, and not having to specify the
> type for each saves space. Currently the only two supported algorithms
> (sha256 and sha512) are different sizes, so we essentially compare
> type by comparing the size.
> 
> I see three options here:
> 1) Only compare digest + size (like now)
> 2) Assume size 32 means sha256, and 64 means sha512 and validate that
> 3) Use more space in the xattr to store an algorithm type

Just store the algorithm alongside the digest.  It's just 1 extra byte.

- Eric
