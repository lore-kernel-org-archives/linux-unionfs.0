Return-Path: <linux-unionfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E8E80C433F5
	for <linux-unionfs@archiver.kernel.org>; Thu, 28 Apr 2022 11:31:15 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231591AbiD1Le2 (ORCPT
        <rfc822;linux-unionfs@archiver.kernel.org>);
        Thu, 28 Apr 2022 07:34:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52960 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234872AbiD1Le1 (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Thu, 28 Apr 2022 07:34:27 -0400
Received: from mail-ed1-x52f.google.com (mail-ed1-x52f.google.com [IPv6:2a00:1450:4864:20::52f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D43765BD0E
        for <linux-unionfs@vger.kernel.org>; Thu, 28 Apr 2022 04:31:11 -0700 (PDT)
Received: by mail-ed1-x52f.google.com with SMTP id g23so5135182edy.13
        for <linux-unionfs@vger.kernel.org>; Thu, 28 Apr 2022 04:31:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=szeredi.hu; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=5C4TM7J98gmhZAoyD7Qt7Kzyh0ImCK2J8UI4aH+IvNA=;
        b=jjHRW5npydkxc7CA1aclqxr7hqZbEZku98z6EMqSW+EqLUUXc5YSV0hlmGX5nXFj4X
         0BPK4oTR6doL6SiGH4faGrtDvx0ZyZRV126g59tE97ewqqd9lJNubQez/GIw4otlnDPq
         ydZjsF7xHTCL+0e7HVXT+RhLuAp6EVl9EUU+U=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=5C4TM7J98gmhZAoyD7Qt7Kzyh0ImCK2J8UI4aH+IvNA=;
        b=V6tK5Xe43vu9xynwU+yGa03RmDTrXWAtztgSCotsWSCAsGNLtpqKJZQ7dvmp0vZJGp
         f9XW9s54ntc11XlIRzs1w9hpfDST4rkL2E6bEm7lV1LBnWXAPwX7Yuygn9QiffAZqycH
         pGwB/9PIwBV4LXBzbjfzWV8bLlokKKgpCbvybw6IpjH66yatqEPrsFzXwLBWGetzCL5/
         NT2fEWunFypbWT663gVI2GfGWrUMgc6gtbLVy42zTbgUSEq8o4bFl5uf1oKJ8aac5QNj
         Ndj5ABoNWem6rUzRchFxf+oeGqYtF/vLbrNw/INYu6lAOocuUBM6gR/fOiGg7Pn64dtX
         6jHA==
X-Gm-Message-State: AOAM533UpDtuFaly/wGtWtYAvCa6MzOCaDmw33z2waIyHJIuw520Ekux
        cT0JMgUrWicSzikIgNr0rkGAHjcOs/1rtV2Jmy9hew==
X-Google-Smtp-Source: ABdhPJwjkBXNHB1OFJA585xiInQIZ5JvKVOCixmt6wB8gvDIASYOwX+gg5spUyJWZzwEyT76p71chcIxdJajabWvFSY=
X-Received: by 2002:a05:6402:2754:b0:426:2f8c:c39 with SMTP id
 z20-20020a056402275400b004262f8c0c39mr1050327edd.224.1651145470411; Thu, 28
 Apr 2022 04:31:10 -0700 (PDT)
MIME-Version: 1.0
References: <20220407112157.1775081-1-brauner@kernel.org> <20220407112157.1775081-14-brauner@kernel.org>
 <CAJfpegtXfrgb3qQTvqu6mtunhFjC-FwXcRvqMY4h-ZcjWyhUFg@mail.gmail.com> <20220428103046.kizonrkl7h2f2uvc@wittgenstein>
In-Reply-To: <20220428103046.kizonrkl7h2f2uvc@wittgenstein>
From:   Miklos Szeredi <miklos@szeredi.hu>
Date:   Thu, 28 Apr 2022 13:30:58 +0200
Message-ID: <CAJfpeguor9gbfTgaHeZ-RxXoGM6V953vrrksWp9E8cOzc+gLDw@mail.gmail.com>
Subject: Re: [PATCH v5 13/19] ovl: handle idmappings for layer lookup
To:     Christian Brauner <brauner@kernel.org>
Cc:     Amir Goldstein <amir73il@gmail.com>,
        Miklos Szeredi <mszeredi@redhat.com>,
        Christoph Hellwig <hch@lst.de>,
        overlayfs <linux-unionfs@vger.kernel.org>,
        Aleksa Sarai <cyphar@cyphar.com>,
        Giuseppe Scrivano <gscrivan@redhat.com>,
        Rodrigo Campos Catelin <rodrigo@sdfg.com.ar>,
        Seth Forshee <sforshee@digitalocean.com>,
        Luca Bocassi <luca.boccassi@microsoft.com>,
        Lennart Poettering <mzxreary@0pointer.de>,
        =?UTF-8?Q?St=C3=A9phane_Graber?= <stgraber@ubuntu.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-unionfs.vger.kernel.org>
X-Mailing-List: linux-unionfs@vger.kernel.org

On Thu, 28 Apr 2022 at 12:30, Christian Brauner <brauner@kernel.org> wrote:
>
> On Thu, Apr 28, 2022 at 12:10:24PM +0200, Miklos Szeredi wrote:
> > On Thu, 7 Apr 2022 at 13:23, Christian Brauner <brauner@kernel.org> wrote:
> > >
> > > Make the two places where lookup helpers can be called either on lower
> > > or upper layers take the mount's idmapping into account. To this end we
> > > pass down the mount in struct ovl_lookup_data. It can later also be used
> > > to construct struct path for various other helpers. This is needed to
> > > support idmapped base layers with overlay.
> > >
> > > Cc: <linux-unionfs@vger.kernel.org>
> > > Tested-by: Giuseppe Scrivano <gscrivan@redhat.com>
> > > Reviewed-by: Amir Goldstein <amir73il@gmail.com>
> > > Signed-off-by: Christian Brauner (Microsoft) <brauner@kernel.org>
> > > ---
> > > /* v2 */
> > > unchanged
> > >
> > > /* v3 */
> > > unchanged
> > >
> > > /* v4 */
> > > - Vivek Goyal <vgoyal@redhat.com>:
> > >   - s/ovl_upper_idmap()/ovl_upper_mnt_userns()/g
> > >
> > > /* v5 */
> > > unchanged
> > > ---
> > >  fs/overlayfs/export.c  |  3 ++-
> > >  fs/overlayfs/namei.c   | 14 ++++++++------
> > >  fs/overlayfs/readdir.c | 10 +++++-----
> > >  3 files changed, 15 insertions(+), 12 deletions(-)
> > >
> > > diff --git a/fs/overlayfs/export.c b/fs/overlayfs/export.c
> > > index ebde05c9cf62..5acf353d160b 100644
> > > --- a/fs/overlayfs/export.c
> > > +++ b/fs/overlayfs/export.c
> > > @@ -391,7 +391,8 @@ static struct dentry *ovl_lookup_real_one(struct dentry *connected,
> > >          * pointer because we hold no lock on the real dentry.
> > >          */
> > >         take_dentry_name_snapshot(&name, real);
> > > -       this = lookup_one_len(name.name.name, connected, name.name.len);
> > > +       this = lookup_one(mnt_user_ns(layer->mnt), name.name.name,
> > > +                         connected, name.name.len);
> >
> > This one is tricky.  It's doing a lookup on overlay, so messing with
> > the underlying mnt_userns is definitely wrong.
> >
> > Is the mnt_userns needed for permission checking?   Possibly in that
> > case the permission checking needs to be skipped altogether, since
> > it's doing an fh -> dentry lookup which should succeed regardless of
> > caller's caps.
>
> If capabilities are checked then it's always caller's user namespace
> that is used (Ofc, exceptions being filesystem-wide operations where
> capabilities in the filesystem's userns are needed but that doesn't
> apply here.).
>
> Nothing has changed with the introduction of the mnt_userns in the
> area of capability checking. IOW, the mnt_userns isn't used for
> capability checks as that would be a major permission model change
> overall (It might have applications in the future ofc.).
>
> The mnt_userns matters for permission checking only in so far as it is
> used to map the k{g,u}ids according to the mount and so is relevant in
> only that sense in inode_permission().

Sorry, sloppy phrasing on my part. Yes, I meant permission checking.

> If this is doing a lookup on an overlay and the relevant mount isn't
> supposed to be idmapped then the simple thing to do is to pass
> &init_user_ns.
>
> Could you explain what "lookup on overlay" means here, i.e. what mount
> is relevant?

It's doing an fh -> dentry transform, the mount should be irrelevant.
Lookup permission cannot properly be checked, hence the operation
needs CAP_DAC_READ_SEARCH when invoked from userspace via
open_by_handle_at(2).

So I guess the proper fix would be to introduce a version of
lookup_one_len() without inode_permission()...

Thanks,
Miklos
