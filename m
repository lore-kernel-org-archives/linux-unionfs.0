Return-Path: <linux-unionfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0AFA0C43334
	for <linux-unionfs@archiver.kernel.org>; Fri,  8 Jul 2022 13:58:26 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232462AbiGHN6Z (ORCPT
        <rfc822;linux-unionfs@archiver.kernel.org>);
        Fri, 8 Jul 2022 09:58:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58348 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237500AbiGHN6X (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Fri, 8 Jul 2022 09:58:23 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AC7C62CDD5
        for <linux-unionfs@vger.kernel.org>; Fri,  8 Jul 2022 06:58:22 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 4A01F6281A
        for <linux-unionfs@vger.kernel.org>; Fri,  8 Jul 2022 13:58:22 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CAC8CC341C0;
        Fri,  8 Jul 2022 13:58:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1657288701;
        bh=aS2ZBvHdj6zvkVNlqbQKZQneSdff/hZPJViFtRROYjg=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=evYwJqIoeFUkBraOffhcrqcUTnlFKtrwEyhJaoJCRttqCiJ9Gp1BR+n/ubjEzoB01
         8nrj8hOQAtAY/XsNa/bf4kKlT+JX4pqEUWXir2DqI7Ql9vZ69do5PORoWyptlnu04Y
         KFoDHX8QFoiYnL2cQOhhoYjdrO9qZLpuRvQwOSEuLPvESzlZex3x7DLWzYJBlmAzSR
         dH+WwccS7asUi4Wxfc0lqsO5pweI/bKIoh9BzqeZhYSGu7r/VH1Uh1m6msRIIBYiqr
         uTnMApi5d6hmhyVp5RrogxHcltLmfFB0NNy2M46uo3oW/Tcc/7bERLUAfZNq8H76ST
         TUkEcpD7FzaYw==
Date:   Fri, 8 Jul 2022 15:58:16 +0200
From:   Christian Brauner <brauner@kernel.org>
To:     Miklos Szeredi <miklos@szeredi.hu>
Cc:     Seth Forshee <sforshee@digitalocean.com>,
        Amir Goldstein <amir73il@gmail.com>,
        Miklos Szeredi <mszeredi@redhat.com>,
        Vivek Goyal <vgoyal@redhat.com>,
        Christoph Hellwig <hch@lst.de>,
        Aleksa Sarai <cyphar@cyphar.com>,
        overlayfs <linux-unionfs@vger.kernel.org>
Subject: Re: [PATCH] ovl: turn of SB_POSIXACL with idmapped layers temporarily
Message-ID: <20220708135816.qovjjyoe2iw2hid4@wittgenstein>
References: <20220706135611.257213-1-brauner@kernel.org>
 <CAJfpegvg4AWRSotysxvcODLxX12gVCKm7=qUquu=Mo=sFtCy7g@mail.gmail.com>
 <20220707103336.op6zxx4wgqv6enxv@wittgenstein>
 <CAJfpegvS7ZzuauqbuWsUdOh=F=0=aCrd6vOKbGTMgcNYgDN4WA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <CAJfpegvS7ZzuauqbuWsUdOh=F=0=aCrd6vOKbGTMgcNYgDN4WA@mail.gmail.com>
Precedence: bulk
List-ID: <linux-unionfs.vger.kernel.org>
X-Mailing-List: linux-unionfs@vger.kernel.org

On Fri, Jul 08, 2022 at 03:54:09PM +0200, Miklos Szeredi wrote:
> On Thu, 7 Jul 2022 at 12:33, Christian Brauner <brauner@kernel.org> wrote:
> >
> > On Thu, Jul 07, 2022 at 09:58:47AM +0200, Miklos Szeredi wrote:
> > > On Wed, 6 Jul 2022 at 15:59, Christian Brauner <brauner@kernel.org> wrote:
> 
> > > However I don't think clearing SB_POSIXACL will do that.
> > >
> > > Maybe denying the operation in ovl_posix_acl_xattr_{get,set}() is the
> > > right way to achieve the above?
> >
> > Hm, removing SB_POSIXACL in my tests fixed that completely. But we can
> > add an additional check:
> 
> Strange... In my tests just clearing SB_POSIXACL will still let
> overlayfs get and set ACL's.

No, you were right. I was only checking ->get_acl() codepaths, not
directly {g,s}etxattr() so my bad!

> 
> >
> >         if (!IS_POSIXACL(inode))
> >                 return -EOPNOTSUPP;
> >
> > to both helpers additionally? Can you do that when you apply or do you
> > want me to send a version with that added?
> 
> Added, also simplified ovl_has_idmapped_layers().
> 
> Pushed to #overlayfs-next  and will send to Linus next week.

Thank you!
Christian
