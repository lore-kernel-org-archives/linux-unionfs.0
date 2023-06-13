Return-Path: <linux-unionfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 33288EB64D8
	for <linux-unionfs@archiver.kernel.org>; Tue, 13 Jun 2023 18:22:38 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235556AbjFMSWh (ORCPT
        <rfc822;linux-unionfs@archiver.kernel.org>);
        Tue, 13 Jun 2023 14:22:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56896 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238619AbjFMSWh (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Tue, 13 Jun 2023 14:22:37 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 705CBCE
        for <linux-unionfs@vger.kernel.org>; Tue, 13 Jun 2023 11:22:36 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 04009615EF
        for <linux-unionfs@vger.kernel.org>; Tue, 13 Jun 2023 18:22:36 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3DED0C433F2;
        Tue, 13 Jun 2023 18:22:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1686680555;
        bh=p1sVHa++x6VMEDAQd9BE3fR/ssiqCqEdXJYnGNyBYDk=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=Mx2kS6Ky4Be8tqYCb+7fwE0T3TKYyUiOvd6wtM7SZJnYOqpcOT7K5r2iBNFM61Fi4
         KUcZ3i/JPg9MHYPig7piuFhp6kCCNZOozJCkBqYWj1TmNUGBUtyTShejoTPt1Pr4QJ
         LR29cPUQEUrNAAF/K3+P7fOsYtdK/b1QDDE7reWmvB85jI0xH/8GPqy5q+2Y5BIOww
         4VdNgQw16KnZHCP+xa3H6zMmRNOVfju9/wrP0JL59v5fQ7aj/X4sV0ZRC1cnAey8c9
         7SHcEhHvAxdOdyWBwEnZKL1o1noOZJApD6e0kE+bwLxnprWty6lkvIzONdHMx/yBm0
         ypfN/0cId98lg==
Date:   Tue, 13 Jun 2023 11:22:33 -0700
From:   Eric Biggers <ebiggers@kernel.org>
To:     Amir Goldstein <amir73il@gmail.com>
Cc:     Alexander Larsson <alexl@redhat.com>, miklos@szeredi.hu,
        linux-unionfs@vger.kernel.org, tytso@mit.edu,
        fsverity@lists.linux.dev
Subject: Re: [PATCH v3 2/4] ovl: Add framework for verity support
Message-ID: <20230613182233.GC1139@sol.localdomain>
References: <cover.1686565330.git.alexl@redhat.com>
 <03ac0ffd82bc1edc3a9baa68d1125f5e8cad93fd.1686565330.git.alexl@redhat.com>
 <20230612163216.GA847@sol.localdomain>
 <CAOQ4uxjS5-7_PaoxM41YaXW+KxwLK_K8AyJMaoi1m-3P-vZ9Kw@mail.gmail.com>
 <20230613063704.GA879@sol.localdomain>
 <CAOQ4uxg6BD_RDtWob5q2eX6uQ5hcWrK7wEDcBhFVrGM3vsn=NA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAOQ4uxg6BD_RDtWob5q2eX6uQ5hcWrK7wEDcBhFVrGM3vsn=NA@mail.gmail.com>
Precedence: bulk
List-ID: <linux-unionfs.vger.kernel.org>
X-Mailing-List: linux-unionfs@vger.kernel.org

On Tue, Jun 13, 2023 at 12:34:10PM +0300, Amir Goldstein wrote:
> >
> > In general the proposed documentation reads like the audience is overlayfs
> > developers.
> 
> I never considered that overlayfs.rst is for an audience other than
> overlayfs developers or people that want to become overlayfs
> developers. It is not a user guide. If it were, it would have been a
> very bad one.
> 
> > It doesn't describe the motivation for the feature or how to use it
> > in each of the two use cases.  Maybe that is intended, but it's not what I had
> > expected to see.
> >
> 
> Yeh, that's a valid point.
> That is what I wanted to know - what exactly is missing.
> I guess this is the documented motivation:

Sure, but even if the document is just for kernel developers, it should still
describe motivation and use cases, as those are important for userstanding.

> "This may then be used to verify the content of the source file at the time
> the file is opened"
> 
> but it does not tell a complete chain of trust story.
> 
> How about something along the lines of:
> 
> "In the case that the upper layer can be trusted not to be tampered
> with while overlayfs is offline

So *online* tampering of the upper layer is fine?

> and some of the lower layers cannot
> be trusted not to be tampered with, the "verity" feature can protect
> against offline modification to lower files

Data of lower files, not simply "lower files", right?

Are *online* modifications to lower files indeed not in scope?

If the feature "can protect", then under what circumstances does it protect, and
under what circumstances what does it not protect?

It would also be helpful to explain what specifically is meant by "protect".
Does it mean that overlayfs prevents modifications to lower file data, or does
it mean that overlayfs detects modifications to lower file data after they
happen?  If the latter, what happens when overlayfs detects a modification?
What do userspace programs experience?

> , whose metadata has been
> copied up to the upper layer (a.k.a "metacopy" files) ...."
> 
> It's generic language that what the patches do, regardless of the
> trust model of composefs and how it composes an overlayfs layers.

It's better, but it could use some more detail.  See my comments above.

- Eric
