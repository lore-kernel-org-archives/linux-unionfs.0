Return-Path: <linux-unionfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E2352C433EF
	for <linux-unionfs@archiver.kernel.org>; Wed, 13 Jul 2022 10:18:26 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234823AbiGMKSZ (ORCPT
        <rfc822;linux-unionfs@archiver.kernel.org>);
        Wed, 13 Jul 2022 06:18:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42844 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230472AbiGMKSY (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Wed, 13 Jul 2022 06:18:24 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D63E3FA1D8
        for <linux-unionfs@vger.kernel.org>; Wed, 13 Jul 2022 03:18:23 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 9650EB81D87
        for <linux-unionfs@vger.kernel.org>; Wed, 13 Jul 2022 10:18:22 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 91315C34114;
        Wed, 13 Jul 2022 10:18:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1657707501;
        bh=6uwWow39rEewEZPxJu+5vNne5J3Fr2dD6Ha1qbLbTTw=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=f4oPAxUy8WGxtQ/kaMMVzK6LZIAurhVfMb15L84vtDIMkXsWkxhLY4PTiZIye7Y25
         td0UuyTKpILaqtzAOfq8oH1fQN/tmYCBFmpXFDZHvg1VzFz26rC7SaIIGv7lxkoCrv
         eiRFBqBE9Ye+m7Tr0w2G6zAvEA/W2He55Mtig7R9GQ3vtia+seqXOAz+VnyutJA6Q+
         mrkO8mXsbL5Kaai1qAKA0/ylE09DhbA8I1X2g3HKYrh9vgyKYBe4niBCGMrGnMku3U
         rwdRGqt/dk6qIjKO6wEqNhwkU0/ERSLLa9XBvcAWnZDyHfYPGMHgV3au9JOb97YsQG
         f4HM3DFg/lHRw==
Date:   Wed, 13 Jul 2022 12:18:14 +0200
From:   Christian Brauner <brauner@kernel.org>
To:     Miklos Szeredi <mszeredi@redhat.com>
Cc:     Vivek Goyal <vgoyal@redhat.com>, Christoph Hellwig <hch@lst.de>,
        Aleksa Sarai <cyphar@cyphar.com>,
        linux-unionfs@vger.kernel.org, Amir Goldstein <amir73il@gmail.com>,
        Seth Forshee <sforshee@digitalocean.com>
Subject: Re: [PATCH v2 0/3] ovl: acl fixes
Message-ID: <20220713101814.d5vg3qcc2qk46vqs@wittgenstein>
References: <20220708090134.385160-1-brauner@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20220708090134.385160-1-brauner@kernel.org>
Precedence: bulk
List-ID: <linux-unionfs.vger.kernel.org>
X-Mailing-List: linux-unionfs@vger.kernel.org

On Fri, Jul 08, 2022 at 11:01:31AM +0200, Christian Brauner wrote:
> From: "Christian Brauner (Microsoft)" <brauner@kernel.org>
> 
> Hey everyone,
> Hey Miklos,
> 
> This is the series I described and announced in the commit message to
> the patch I sent yesterdat (see [1]). It enables POSIX ACLs for
> overlayfs on top of idmapped layers. It encompasses everything that is
> needed to make this work correctly. There is a detailed explanation in
> the first patch of this series so I won't repeat it all here in the
> cover letter.
> 
> My plan would be to get this ready for the next merge window.
> Once Miklos has merged the temporary fix I sent out yesterday in [1] and
> it shows up in mainline I will rebase this series on top of the next
> mainline rc. I will then add a revert of the fix in [1] to this series
> reenabling POSIX ACL support for overlayfs on top of idmapped layers.
> 
> I will also merge in the vfs{g,u}id_t work that is in -next replacing
> the old idmapped mount helpers with the new type safe idmapping helpers.

Hey Miklos,

I've moved this into my for-next now with the changes I mentioned above.
Could please take a look at the

    fs.idmapped.overlay.acl

branch at

    git://git.kernel.org/pub/scm/linux/kernel/git/brauner/linux.git

and tell me if that looks ok to you?

Thanks!
Christian
