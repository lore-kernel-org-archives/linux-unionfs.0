Return-Path: <SRS0=JhEn=7A=vger.kernel.org=linux-unionfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.6 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C3C0CC433E0
	for <linux-unionfs@archiver.kernel.org>; Mon, 18 May 2020 07:53:02 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id A53C7207D3
	for <linux-unionfs@archiver.kernel.org>; Mon, 18 May 2020 07:53:02 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=szeredi.hu header.i=@szeredi.hu header.b="pR1h1k2Z"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726573AbgERHxB (ORCPT
        <rfc822;linux-unionfs@archiver.kernel.org>);
        Mon, 18 May 2020 03:53:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52118 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726676AbgERHxB (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Mon, 18 May 2020 03:53:01 -0400
Received: from mail-ej1-x644.google.com (mail-ej1-x644.google.com [IPv6:2a00:1450:4864:20::644])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 47391C05BD09
        for <linux-unionfs@vger.kernel.org>; Mon, 18 May 2020 00:53:01 -0700 (PDT)
Received: by mail-ej1-x644.google.com with SMTP id l21so8049654eji.4
        for <linux-unionfs@vger.kernel.org>; Mon, 18 May 2020 00:53:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=szeredi.hu; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=Ju6cMhxne5AXItMtwn693ScodaiFVLL33Aq2yo5CgjU=;
        b=pR1h1k2ZW8LIKcWBwkp0kuEkybbIZVBLXZEiuNTcfPpgvLRBCUIUOt/QeLYFIg2QB2
         A0NkvgCkVi6HoQG6p9z7JcpWEFbwGS2cYl5T1U8xeQA5TsCb+El6rXsDWkav0Mh58gwZ
         2qYG/iLRV5UFhpNIL+XNvJJPOFsSrWD3XJJJk=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=Ju6cMhxne5AXItMtwn693ScodaiFVLL33Aq2yo5CgjU=;
        b=jwE3SPHhMb6MH5UtZavPDwc9OAgjzVKUIgYMdOcBAElwhLAhIlTTGd2e/0oRSTdhkR
         IgWCycdelVYQdEkAOpFxYsxDWWpFU97tu4r5Nkd6eiSK/+HOR2UxAyMoBvWbf2idTehb
         bnslx11ahLREFh5ny7VcX/hWPRkGJJ6Vr+9mzxgF9XaTXs+pFXhQ5AsgnNdaMqPUMxi1
         8n5F3xbKt0x7k3HP6K6JCqaE/7t647A8wDQzapJNcb1p9NzZ7OC0At9iHj+vu9yuk/5Y
         lbIaYwu+fbttfltmU4dlMWk+ipWYesOVBMMY/gAFhqAGoI1YffSUi3eaXLv+O2Q0VLj5
         Gsrw==
X-Gm-Message-State: AOAM533hwfDHMVphd49lfqmz/J7D+xqZx4rtK7EeyoGS7QHdDHlgh24F
        OyWIlnXt/Sy3soE0/m2r3wyKcQyP211ajbAC/Kld5Dkq3i4=
X-Google-Smtp-Source: ABdhPJyr1OUN4yJAPmlPskd6CU1QEOc+tC3YoFH4pTLCgRqDvkO5NO91DPku8XCNQBha0Oh9EjwDIx56yPBvbp12DLA=
X-Received: by 2002:a17:906:cd08:: with SMTP id oz8mr13463551ejb.90.1589788379916;
 Mon, 18 May 2020 00:52:59 -0700 (PDT)
MIME-Version: 1.0
References: <20200515072047.31454-1-cgxu519@mykernel.net> <e994d56ff1357013a85bde7be2e901476f743b83.camel@themaw.net>
 <CAOQ4uxjT8DouPmf1mk1x24X8FcN5peYAqwdr362P4gcW+x15dw@mail.gmail.com>
In-Reply-To: <CAOQ4uxjT8DouPmf1mk1x24X8FcN5peYAqwdr362P4gcW+x15dw@mail.gmail.com>
From:   Miklos Szeredi <miklos@szeredi.hu>
Date:   Mon, 18 May 2020 09:52:48 +0200
Message-ID: <CAJfpegtpi1SVJRbQb8zM0t66WnrjKsPEGEN3qZKRzrZePP06dA@mail.gmail.com>
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

On Mon, May 18, 2020 at 7:27 AM Amir Goldstein <amir73il@gmail.com> wrote:
>
> On Mon, May 18, 2020 at 3:53 AM Ian Kent <raven@themaw.net> wrote:
> >
> > On Fri, 2020-05-15 at 15:20 +0800, Chengguang Xu wrote:
> > > This series adds a new lookup flag LOOKUP_DONTCACHE_NEGATIVE
> > > to indicate to drop negative dentry in slow path of lookup.
> > >
> > > In overlayfs, negative dentries in upper/lower layers are useless
> > > after construction of overlayfs' own dentry, so in order to
> > > effectively reclaim those dentries, specify LOOKUP_DONTCACHE_NEGATIVE
> > > flag when doing lookup in upper/lower layers.
> >
> > I've looked at this a couple of times now.
> >
> > I'm not at all sure of the wisdom of adding a flag to a VFS function
> > that allows circumventing what a file system chooses to do.
>
> But it is not really a conscious choice is it?
> How exactly does a filesystem express its desire to cache a negative
> dentry? The documentation of lookup() in vfs.rst makes it clear that
> it is not up to the filesystem to make that decision.
> The VFS needs to cache the negative dentry on lookup(), so
> it can turn it positive on create().
> Low level kernel modules that call the VFS lookup() might know
> that caching the negative dentry is counter productive.
>
> >
> > I also do really see the need for it because only hashed negative
> > dentrys will be retained by the VFS so, if you see a hashed negative
> > dentry then you can cause it to be discarded on release of the last
> > reference by dropping it.
> >
> > So what's different here, why is adding an argument to do that drop
> > in the VFS itself needed instead of just doing it in overlayfs?
>
> That was v1 patch. It was dealing with the possible race of
> returned negative dentry becoming positive before dropping it
> in an intrusive manner.
>
> In retrospect, I think this race doesn't matter and there is no
> harm in dropping a positive dentry in a race obviously caused by
> accessing the underlying layer, which as documented results in
> "undefined behavior".
>
> Miklos, am I missing something?

Dropping a positive dentry is harmful in case there's a long term
reference to the dentry (e.g. an open file) since it will look as if
the file was deleted, when in fact it wasn't.

It's possible to unhash a negative dentry in a safe way if we make
sure it cannot become positive.  One way is to grab d_lock and remove
it from the hash table only if count is one.

So yes, we could have a helper to do that instead of the lookup flag.
The disadvantage being that we'd also be dropping negatives that did
not enter the cache because of our lookup.

I don't really care, both are probably good enough for the overlayfs case.

Thanks,
Miklos
