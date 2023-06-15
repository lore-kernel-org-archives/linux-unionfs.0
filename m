Return-Path: <linux-unionfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DA604EB64D9
	for <linux-unionfs@archiver.kernel.org>; Thu, 15 Jun 2023 23:52:34 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231739AbjFOXwe (ORCPT
        <rfc822;linux-unionfs@archiver.kernel.org>);
        Thu, 15 Jun 2023 19:52:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35438 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230300AbjFOXwd (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Thu, 15 Jun 2023 19:52:33 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D22D01BF9
        for <linux-unionfs@vger.kernel.org>; Thu, 15 Jun 2023 16:52:32 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 58844623C0
        for <linux-unionfs@vger.kernel.org>; Thu, 15 Jun 2023 23:52:32 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 49813C433C8;
        Thu, 15 Jun 2023 23:52:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1686873151;
        bh=cSQ7iQiaFIvOzEObGqNHvT9FEmXaqIOekoIY4cgyXmU=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=GVsFPs698FKNMg0EFczGR3bbsaMyMPbWIa7+aWSqQ4z68iwfn6kAj3W+gU6FZ9dHK
         bv/li4GJrcocuStENtt0co3eUOfDkq3ieutPqFdBbAR6pW0YVz8sX1MydwNlvjAwvI
         rySvA3P/C0/rZ4MDCVwJUWAYnLmVLlVjPyxm+jyzmA7ic0CMPsCGOGO5RI37Br6hrd
         GHEiTb5Qo9hNFrHOt8JN21pl6D8p9TbruivaTvlj8vk0MIAFREazuOCHESPSagCShR
         a4Pw5toIt5sDNjFiJd4ipMeNrTl+3fttckanewspihjzn5lw8F2c59zs270cRduBny
         I3uXWpJ9s/9WQ==
Date:   Thu, 15 Jun 2023 16:52:29 -0700
From:   Eric Biggers <ebiggers@kernel.org>
To:     Alexander Larsson <alexl@redhat.com>
Cc:     Amir Goldstein <amir73il@gmail.com>, miklos@szeredi.hu,
        linux-unionfs@vger.kernel.org, tytso@mit.edu,
        fsverity@lists.linux.dev
Subject: Re: [PATCH v3 2/4] ovl: Add framework for verity support
Message-ID: <20230615235229.GC25295@sol.localdomain>
References: <cover.1686565330.git.alexl@redhat.com>
 <03ac0ffd82bc1edc3a9baa68d1125f5e8cad93fd.1686565330.git.alexl@redhat.com>
 <20230612163216.GA847@sol.localdomain>
 <CAOQ4uxjS5-7_PaoxM41YaXW+KxwLK_K8AyJMaoi1m-3P-vZ9Kw@mail.gmail.com>
 <20230613063704.GA879@sol.localdomain>
 <CAOQ4uxg6BD_RDtWob5q2eX6uQ5hcWrK7wEDcBhFVrGM3vsn=NA@mail.gmail.com>
 <20230613182233.GC1139@sol.localdomain>
 <CAOQ4uxhzJFpfuFLxK2s0JqS5qGQDGfndFPY7n2NDmZso4cG4Rg@mail.gmail.com>
 <CAL7ro1FF2iUjPsXrha8tELYvi9MwW7WRhksqX7ahSXc4gPHraw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAL7ro1FF2iUjPsXrha8tELYvi9MwW7WRhksqX7ahSXc4gPHraw@mail.gmail.com>
Precedence: bulk
List-ID: <linux-unionfs.vger.kernel.org>
X-Mailing-List: linux-unionfs@vger.kernel.org

On Wed, Jun 14, 2023 at 09:57:41AM +0200, Alexander Larsson wrote:
> When a layer containing verity xattrs is used, it means that any
> such metacopy file in the upper layer is guaranteed to match the
> content that was in the lower at the time of the copy-up. If at any time
> (during a mount, after a remount, etc) such a file in the lower is
> replaced or modified in any way, then opening the corresponding file on
> overlayfs will result in EIO and a detailed error printed to the kernel logs.
> (Actually, due to caching the overlayfs mount might still see the previous
> file contents after a lower file is replaced under an active mount, but
> it will never see the wrong data.)

Well, the key point of fsverity is that data is not verified until it is
actually read.  At open time, the fsverity file digest is made available in
constant time, and overlayfs will verify that.  However, invalid data blocks are
not reported until the data is actually read.  The error that applications get
is EIO for syscalls, and SIGBUS for memory-mapped reads, as mentioned at
https://www.kernel.org/doc/html/latest/filesystems/fsverity.html#accessing-verity-files

So overlayfs might report EIO at open time, or it might not report an error
until the modified data is read.  And in the latter case, presumably the error
seen by the application matches the one for using fsverity natively?

You can link to the fsverity documentation somewhere if it would be helpful, but
I'd still like the semantics of how this works on overlayfs to be documented.

- Eric
