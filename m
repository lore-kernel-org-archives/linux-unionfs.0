Return-Path: <linux-unionfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E5F56C7EE29
	for <linux-unionfs@archiver.kernel.org>; Tue, 13 Jun 2023 06:37:10 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232063AbjFMGhJ (ORCPT
        <rfc822;linux-unionfs@archiver.kernel.org>);
        Tue, 13 Jun 2023 02:37:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38236 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239851AbjFMGhI (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Tue, 13 Jun 2023 02:37:08 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DAE72E4A
        for <linux-unionfs@vger.kernel.org>; Mon, 12 Jun 2023 23:37:06 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 731F761E77
        for <linux-unionfs@vger.kernel.org>; Tue, 13 Jun 2023 06:37:06 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9EFE5C433D2;
        Tue, 13 Jun 2023 06:37:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1686638225;
        bh=myjwHHxCxZ3hd4/M3pWPdTZLqLmGxFa4VcTQaEBT0S4=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=nkprY6ebbpqpPEy3VXzbar/+7iD7L3TTc8bVwgChGYnLpBxPerUwddQwz5IF6DGGK
         wXKVsuki/OWt7LuGPyyulrUAonAyVFXmwGMNekkCmLLiGdhvwSNzGX/AzckSYEx2OT
         NF3pCDF5RL/gRjtT6A0F8JVsB/kkX6cVAnpXwJwZcUzMrODkkWwhLB/urzB5pIVAVM
         moDkvrf9kHEK1lg8jiIzhveK0zdtqHdBoEgubH1e6VLIQV+gC3EfPJZMbhepFL9l7j
         YlsBlDA9/xtwU7DPGnSIAf8TCVy4TQYWWF09pjFEriejPVFZdSuM/bFcRi5eIaJqcZ
         uvgnsdCSeB9pg==
Date:   Mon, 12 Jun 2023 23:37:04 -0700
From:   Eric Biggers <ebiggers@kernel.org>
To:     Amir Goldstein <amir73il@gmail.com>
Cc:     Alexander Larsson <alexl@redhat.com>, miklos@szeredi.hu,
        linux-unionfs@vger.kernel.org, tytso@mit.edu,
        fsverity@lists.linux.dev
Subject: Re: [PATCH v3 2/4] ovl: Add framework for verity support
Message-ID: <20230613063704.GA879@sol.localdomain>
References: <cover.1686565330.git.alexl@redhat.com>
 <03ac0ffd82bc1edc3a9baa68d1125f5e8cad93fd.1686565330.git.alexl@redhat.com>
 <20230612163216.GA847@sol.localdomain>
 <CAOQ4uxjS5-7_PaoxM41YaXW+KxwLK_K8AyJMaoi1m-3P-vZ9Kw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAOQ4uxjS5-7_PaoxM41YaXW+KxwLK_K8AyJMaoi1m-3P-vZ9Kw@mail.gmail.com>
Precedence: bulk
List-ID: <linux-unionfs.vger.kernel.org>
X-Mailing-List: linux-unionfs@vger.kernel.org

On Tue, Jun 13, 2023 at 08:18:50AM +0300, Amir Goldstein wrote:
> On Mon, Jun 12, 2023 at 7:32 PM Eric Biggers <ebiggers@kernel.org> wrote:
> >
> > On Mon, Jun 12, 2023 at 12:27:17PM +0200, Alexander Larsson wrote:
> > > +fs-verity support
> > > +----------------------
> > > +
> > > +When metadata copy up is used for a file, then the xattr
> > > +"trusted.overlay.verity" may be set on the metacopy file. This
> > > +specifies the expected fs-verity digest of the lowerdata file. This
> > > +may then be used to verify the content of the source file at the time
> > > +the file is opened. During metacopy copy up overlayfs can also set
> > > +this xattr.
> > > +
> > > +This is controlled by the "verity" mount option, which supports
> > > +these values:
> > > +
> > > +- "off":
> > > +    The verity xattr is never used. This is the default if verity
> > > +    option is not specified.
> > > +- "on":
> > > +    Whenever a metacopy files specifies an expected digest, the
> > > +    corresponding data file must match the specified digest.
> > > +    When generating a metacopy file the verity xattr will be set
> > > +    from the source file fs-verity digest (if it has one).
> > > +- "require":
> > > +    Same as "on", but additionally all metacopy files must specify a
> > > +    verity xattr. This means metadata copy up will only be used if
> > > +    the data file has fs-verity enabled, otherwise a full copy-up is
> > > +    used.
> >
> > It looks like my request for improved documentation was not taken, which is
> > unfortunate and makes this patchset difficult to review.
> >
> 
> Which one?
> IIRC, you had two requests.
> One very broad to get the overlayfs.rst document up-to-date:
> [1] https://lore.kernel.org/linux-unionfs/20230514190903.GC9528@sol.localdomain/

That isn't an accurate summary of what I said.  I actually pointed out two
specific things that are confusing specifically in the context of this feature.

> But I assume you mean the specific request about this sentence:
> [2] https://lore.kernel.org/linux-unionfs/20230514192227.GE9528@sol.localdomain/

And that was a third specific thing.  I got a detailed response back
(https://lore.kernel.org/linux-unionfs/CAL7ro1GGAfdZG9cHDWE2vnhY5tSE=9MxYi_n_gJHRfaw7zMSgg@mail.gmail.com),
which was helpful.  Unfortunately, the information in that response hasn't yet
found its way into the documentation that is being proposed.

In general the proposed documentation reads like the audience is overlayfs
developers.  It doesn't describe the motivation for the feature or how to use it
in each of the two use cases.  Maybe that is intended, but it's not what I had
expected to see.

Side note: the use of the passive voice, e.g. "the xattr may be set" and "the
xattr may then be used to verify", should be avoided since it makes it unclear
who/what is doing these actions.

- Eric
