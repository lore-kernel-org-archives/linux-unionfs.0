Return-Path: <linux-unionfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 343A5EB64D9
	for <linux-unionfs@archiver.kernel.org>; Sat, 17 Jun 2023 19:47:42 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230040AbjFQTrk (ORCPT
        <rfc822;linux-unionfs@archiver.kernel.org>);
        Sat, 17 Jun 2023 15:47:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33600 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229487AbjFQTrj (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Sat, 17 Jun 2023 15:47:39 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C243BE4
        for <linux-unionfs@vger.kernel.org>; Sat, 17 Jun 2023 12:47:38 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 52CCF610E7
        for <linux-unionfs@vger.kernel.org>; Sat, 17 Jun 2023 19:47:38 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 75821C433C8;
        Sat, 17 Jun 2023 19:47:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1687031257;
        bh=uizU/zBwhLt6NInEicPvKsyGRX5jWVQ/eAUgQgGVQaU=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=KibC2zkygC9VPYzbAGXMHZ9HG7k1nVmW5gOtA1V3jdg+C7cIRBfBUurski4WToam5
         mkOyGxefGXPTuJoHn4gDd9qjzq6lsIT5H/PCW3BCTKUJcomXIugz0w0RKsZXOJfGc1
         1eW7Zrt77G8XGxTprwKJ+Gr8XRYu1pG62xWLmXTA5vXEFhtyslZD2XPV8TG3QaOqHN
         Ki73uf8YdT5EOwFEN3f1W0guYqLY/2jtZzmBxDnCv7/7h+Tyt6yTKxvfXOesybVeUr
         J9rbI57wV2u8LJiAUe8hmOQslc/dL2p0mzyHxxiHVJgA6NqwMgNGvpqV36UpqeYSYa
         GQuYyPBjWP8mA==
Date:   Sat, 17 Jun 2023 12:47:35 -0700
From:   Eric Biggers <ebiggers@kernel.org>
To:     Alexander Larsson <alexl@redhat.com>
Cc:     Amir Goldstein <amir73il@gmail.com>, miklos@szeredi.hu,
        linux-unionfs@vger.kernel.org, tytso@mit.edu,
        fsverity@lists.linux.dev
Subject: Re: [PATCH v3 2/4] ovl: Add framework for verity support
Message-ID: <20230617194735.GA4703@sol.localdomain>
References: <03ac0ffd82bc1edc3a9baa68d1125f5e8cad93fd.1686565330.git.alexl@redhat.com>
 <20230612163216.GA847@sol.localdomain>
 <CAOQ4uxjS5-7_PaoxM41YaXW+KxwLK_K8AyJMaoi1m-3P-vZ9Kw@mail.gmail.com>
 <20230613063704.GA879@sol.localdomain>
 <CAOQ4uxg6BD_RDtWob5q2eX6uQ5hcWrK7wEDcBhFVrGM3vsn=NA@mail.gmail.com>
 <20230613182233.GC1139@sol.localdomain>
 <CAOQ4uxhzJFpfuFLxK2s0JqS5qGQDGfndFPY7n2NDmZso4cG4Rg@mail.gmail.com>
 <CAL7ro1FF2iUjPsXrha8tELYvi9MwW7WRhksqX7ahSXc4gPHraw@mail.gmail.com>
 <20230615235229.GC25295@sol.localdomain>
 <CAL7ro1G+Dnet=M+CUY7e_9nJhOtD3rQm16C7bWkMBVnfcvm4Yg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAL7ro1G+Dnet=M+CUY7e_9nJhOtD3rQm16C7bWkMBVnfcvm4Yg@mail.gmail.com>
Precedence: bulk
List-ID: <linux-unionfs.vger.kernel.org>
X-Mailing-List: linux-unionfs@vger.kernel.org

On Fri, Jun 16, 2023 at 10:11:06AM +0200, Alexander Larsson wrote:
> On Fri, Jun 16, 2023 at 1:52 AM Eric Biggers <ebiggers@kernel.org> wrote:
> >
> > On Wed, Jun 14, 2023 at 09:57:41AM +0200, Alexander Larsson wrote:
> > > When a layer containing verity xattrs is used, it means that any
> > > such metacopy file in the upper layer is guaranteed to match the
> > > content that was in the lower at the time of the copy-up. If at any time
> > > (during a mount, after a remount, etc) such a file in the lower is
> > > replaced or modified in any way, then opening the corresponding file on
> > > overlayfs will result in EIO and a detailed error printed to the kernel logs.
> > > (Actually, due to caching the overlayfs mount might still see the previous
> > > file contents after a lower file is replaced under an active mount, but
> > > it will never see the wrong data.)
> >
> > Well, the key point of fsverity is that data is not verified until it is
> > actually read.  At open time, the fsverity file digest is made available in
> > constant time, and overlayfs will verify that.  However, invalid data blocks are
> > not reported until the data is actually read.  The error that applications get
> > is EIO for syscalls, and SIGBUS for memory-mapped reads, as mentioned at
> > https://www.kernel.org/doc/html/latest/filesystems/fsverity.html#accessing-verity-files
> >
> > So overlayfs might report EIO at open time, or it might not report an error
> > until the modified data is read.  And in the latter case, presumably the error
> > seen by the application matches the one for using fsverity natively?
> 
> Yes, I'm aware of that, but do we need to describe this in the
> overlayfs documentation?
> The text I wrote is describing the behaviour that overlayfs adds to
> the mix, and I sort of
> assumed the late validation from fs-verity itself would be known about
> if the file already
> has fs-verity enabled.
> 
> > You can link to the fsverity documentation somewhere if it would be helpful, but
> > I'd still like the semantics of how this works on overlayfs to be documented.
> 
> I guess just adding a link to that is not that bad. What about:
> 
> ----
> When a layer containing verity xattrs is used, it means that any such
> metacopy file in the upper layer is guaranteed to match the content
> that was in the lower at the time of the copy-up. If at any time
> (during a mount, after a remount, etc) such a file in the lower is
> replaced or modified in any way, then opening the corresponding file
> on overlayfs will result in EIO and a detailed error printed to the
> kernel logs.  (Actually, due to caching the overlayfs mount might
> still see the previous file contents after a lower file is replaced
> under an active mount, but it will never see the wrong data.)  In
> addition fs-verity will do late validation of the file content, as
> described in :ref:`Documentation/filesystems/fsverity.rst
> <accessing_verity_files>`.

That still has the incorrect statement "If at any time (during a mount, after a
remount, etc) such a file in the lower is replaced or modified in any way, then
opening the corresponding file on overlayfs will result in EIO and a detailed
error printed to the kernel logs."  See my last email where I explained why that
statement is not correct.

- Eric
