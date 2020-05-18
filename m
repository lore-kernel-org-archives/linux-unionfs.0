Return-Path: <SRS0=JhEn=7A=vger.kernel.org=linux-unionfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.6 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4E962C433E0
	for <linux-unionfs@archiver.kernel.org>; Mon, 18 May 2020 09:17:18 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 1D31F20643
	for <linux-unionfs@archiver.kernel.org>; Mon, 18 May 2020 09:17:18 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=szeredi.hu header.i=@szeredi.hu header.b="GwLWHDJp"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726285AbgERJRR (ORCPT
        <rfc822;linux-unionfs@archiver.kernel.org>);
        Mon, 18 May 2020 05:17:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37040 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726270AbgERJRR (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Mon, 18 May 2020 05:17:17 -0400
Received: from mail-ed1-x541.google.com (mail-ed1-x541.google.com [IPv6:2a00:1450:4864:20::541])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4C959C05BD09
        for <linux-unionfs@vger.kernel.org>; Mon, 18 May 2020 02:17:17 -0700 (PDT)
Received: by mail-ed1-x541.google.com with SMTP id s19so7810548edt.12
        for <linux-unionfs@vger.kernel.org>; Mon, 18 May 2020 02:17:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=szeredi.hu; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=8xlz8GsaEbqA7+Q0OgDVIVF7fZyrH+eyib1SwOfcFkk=;
        b=GwLWHDJpAgtpfvRU2Fl0XDrm+cFz4QU1FCrNrXPGsMOh9MUPIXxxx/3Lu8Q77ZsTfP
         QMhnLgCbloAHRfhuT9x29yE5bYKzLSOk9n3b5ynOwjNVCiJTyCp2gnhRJuhmeHLP5kVD
         vsENIg0p4v6RIzz74CLJvqgxw3JCcY0Fa9KIQ=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=8xlz8GsaEbqA7+Q0OgDVIVF7fZyrH+eyib1SwOfcFkk=;
        b=rOPdhyDyQVOVe7EsuTFGB7cOnG9aQTZCxyQXFuFrr4sPMp8kjnEtq/EZt90tKuO/eF
         +ay4SRv3ZMuhs12xoMGwwmXrNCl0xICfJyx7ItZ7dAt/8m9H6bGAaLVkVLU6jbaTgFDT
         yoZki2FpqwpnufQReLNRQ+bx/yirP2u/jmpoMVW7SiscRPrWuDLu4WV4gXjs3LnTd7UI
         mRqlBf5TEl7STpmtT2wNhYnI5i8yQolulKmqN2qYQvPocsibISqbnGriozpvezkpgpUS
         o4l1DN4ShIODmKPfPOOfh4k/1+bNMwMdd46kR+yoAcE3VEwsBvxqfbhtu9IEky74E5i3
         VfOg==
X-Gm-Message-State: AOAM531xpIpiCU6G56g5AYs6K/qdmeCh/dcHx+6Pn0XMvBhJiFLbTTga
        mudfGASeyqcQXaLlWbzFG5z21q6qNiLvwE+F0LulF/dkrjc=
X-Google-Smtp-Source: ABdhPJwpDqdsy9lmKmYTn6XGegQYLl2kT288a0DXA49iyCvZtD8jstRHqiY9fH6eZ1ZmbGlu5YMqc03a2MQokxkbGSM=
X-Received: by 2002:a50:8d57:: with SMTP id t23mr12955766edt.168.1589793435950;
 Mon, 18 May 2020 02:17:15 -0700 (PDT)
MIME-Version: 1.0
References: <20200515072047.31454-1-cgxu519@mykernel.net> <e994d56ff1357013a85bde7be2e901476f743b83.camel@themaw.net>
 <CAOQ4uxjT8DouPmf1mk1x24X8FcN5peYAqwdr362P4gcW+x15dw@mail.gmail.com>
 <CAJfpegtpi1SVJRbQb8zM0t66WnrjKsPEGEN3qZKRzrZePP06dA@mail.gmail.com> <CAOQ4uxgfEBksbtLtPVA2L-JhRUQ5aEh9+W4dXGREuoMe40V8tQ@mail.gmail.com>
In-Reply-To: <CAOQ4uxgfEBksbtLtPVA2L-JhRUQ5aEh9+W4dXGREuoMe40V8tQ@mail.gmail.com>
From:   Miklos Szeredi <miklos@szeredi.hu>
Date:   Mon, 18 May 2020 11:17:04 +0200
Message-ID: <CAJfpegseFkdiKQ-_h64-9O-euoy8FDr_fA=wLxpR9cnpC2NHtg@mail.gmail.com>
Subject: Re: [RFC PATCH v3 0/9] Suppress negative dentry
To:     Amir Goldstein <amir73il@gmail.com>
Cc:     Ian Kent <raven@themaw.net>, Chengguang Xu <cgxu519@mykernel.net>,
        Al Viro <viro@zeniv.linux.org.uk>,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>,
        overlayfs <linux-unionfs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-unionfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-unionfs.vger.kernel.org>
X-Mailing-List: linux-unionfs@vger.kernel.org

On Mon, May 18, 2020 at 10:52 AM Amir Goldstein <amir73il@gmail.com> wrote:
>
> > > > I also do really see the need for it because only hashed negative
> > > > dentrys will be retained by the VFS so, if you see a hashed negative
> > > > dentry then you can cause it to be discarded on release of the last
> > > > reference by dropping it.
> > > >
> > > > So what's different here, why is adding an argument to do that drop
> > > > in the VFS itself needed instead of just doing it in overlayfs?
> > >
> > > That was v1 patch. It was dealing with the possible race of
> > > returned negative dentry becoming positive before dropping it
> > > in an intrusive manner.
> > >
> > > In retrospect, I think this race doesn't matter and there is no
> > > harm in dropping a positive dentry in a race obviously caused by
> > > accessing the underlying layer, which as documented results in
> > > "undefined behavior".
> > >
> > > Miklos, am I missing something?
> >
> > Dropping a positive dentry is harmful in case there's a long term
> > reference to the dentry (e.g. an open file) since it will look as if
> > the file was deleted, when in fact it wasn't.
> >
>
> I see. My point was that the negative->positive transition cannot
> happen on underlying layers without user modifying underlying
> layers underneath overlay, so it is fine to be in the "undefined" behavior
> zone.

Right, I don't think you can actually crash a filesystem by unhashing
a positive dentry in the middle of a create op, but it would
definitely be prudent to avoid that.

>
> > It's possible to unhash a negative dentry in a safe way if we make
> > sure it cannot become positive.  One way is to grab d_lock and remove
> > it from the hash table only if count is one.
> >
> > So yes, we could have a helper to do that instead of the lookup flag.
> > The disadvantage being that we'd also be dropping negatives that did
> > not enter the cache because of our lookup.
> >
> > I don't really care, both are probably good enough for the overlayfs case.
> >
>
> There is another point to consider.
> A negative underlying fs dentry may be useless for *this* overlayfs instance,
> but since lower layers can be shared among many overlayfs instances,
> for example, thousands of containers all testing for existence of file /etc/FOO
> on startup.
>
> It sounds like if we want to go through with DONTCACHE_NEGATIVE, that
> it should be opt-in behavior for overlayfs.

Good point.

Thanks,
Miklos
