Return-Path: <linux-unionfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AC12EC433FE
	for <linux-unionfs@archiver.kernel.org>; Thu, 28 Apr 2022 11:43:51 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233489AbiD1LrE (ORCPT
        <rfc822;linux-unionfs@archiver.kernel.org>);
        Thu, 28 Apr 2022 07:47:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58066 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229814AbiD1LrD (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Thu, 28 Apr 2022 07:47:03 -0400
Received: from mail-ed1-x52c.google.com (mail-ed1-x52c.google.com [IPv6:2a00:1450:4864:20::52c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8E64E66F96
        for <linux-unionfs@vger.kernel.org>; Thu, 28 Apr 2022 04:43:49 -0700 (PDT)
Received: by mail-ed1-x52c.google.com with SMTP id g23so5171785edy.13
        for <linux-unionfs@vger.kernel.org>; Thu, 28 Apr 2022 04:43:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=szeredi.hu; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=Yt4r3Pez90aETpPoF7FugUPY1h05uZlFhdm64bGUqKk=;
        b=QdOcYXn1psPUXrDsJuEHP2GMMH2H30/4wn6Xd7FqbMiFnXIZR2kzxWb94jhSHmI+J7
         1rP0f3GIaB+CokUKkZDI7YNAgJt0apbbk716qt2qCsidgzd+KGDb7b5hQOg4LH+eky7w
         TTvH9N6mmO0xPiVgMuZqgOgrr4ZhrOPyx/mRg=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=Yt4r3Pez90aETpPoF7FugUPY1h05uZlFhdm64bGUqKk=;
        b=cqtgGf5JKQa4AVNlLSqiXuee1Ar+aK+1xWUrsLZtmzbP6iT0GLvXlNrU78J7oTUJ+N
         Xo52C7YXng3XFoW87ke7oT/6FlehiOaZfNrsZAWJUtrtHVx4GYHZgt8qNN/sD5gQfpzM
         QDs65SrH8dYLLzgcBeOKa3OxVeHEY8QUq/e3MnPZiiyb2omeQY2+eIQXoGAPeG78R4Xm
         mCP01KU5qk2Q3qDUhrOGoMtPG9FFvtvMCD3+oT9vcooB2WToOIH57YZZwngwfA4Al1qB
         Ss90JJizlN+laT87DRxVTsyl00pRDbfdk6Z/WaD7jUmRVmOMa1oDiZDilksqVJXNCzC1
         WstA==
X-Gm-Message-State: AOAM532e/VYMCSUT/MAd7ToLcuvRubcydJrRaRoOt4hlFcs1vR195rCc
        AxRcKdFscBSKeMhmM1COaDHQeB3Qe2kOwOCjoRjsmw==
X-Google-Smtp-Source: ABdhPJw6AAWylt11EKDYgbCOmvRVB9eOqJvSfm/IgheDMxTSdFJ+JP9VA5yZ3Otv+MS3AEWS2cW6GxjfF223vcaNLUE=
X-Received: by 2002:a05:6402:2754:b0:426:2f8c:c39 with SMTP id
 z20-20020a056402275400b004262f8c0c39mr1105479edd.224.1651146227363; Thu, 28
 Apr 2022 04:43:47 -0700 (PDT)
MIME-Version: 1.0
References: <20220407112157.1775081-1-brauner@kernel.org> <20220407112157.1775081-14-brauner@kernel.org>
 <CAJfpegtXfrgb3qQTvqu6mtunhFjC-FwXcRvqMY4h-ZcjWyhUFg@mail.gmail.com>
 <20220428103046.kizonrkl7h2f2uvc@wittgenstein> <CAOQ4uxgiGWK8yqFHEe+qa2fnfDwV79_K1bMPHWBGW7iQry0gaQ@mail.gmail.com>
In-Reply-To: <CAOQ4uxgiGWK8yqFHEe+qa2fnfDwV79_K1bMPHWBGW7iQry0gaQ@mail.gmail.com>
From:   Miklos Szeredi <miklos@szeredi.hu>
Date:   Thu, 28 Apr 2022 13:43:36 +0200
Message-ID: <CAJfpegtG_cX=o7vvkhaXYBiXQzWe2SsO7xZS9cKsre8q5ZDAbQ@mail.gmail.com>
Subject: Re: [PATCH v5 13/19] ovl: handle idmappings for layer lookup
To:     Amir Goldstein <amir73il@gmail.com>
Cc:     Christian Brauner <brauner@kernel.org>,
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

On Thu, 28 Apr 2022 at 12:57, Amir Goldstein <amir73il@gmail.com> wrote:
>
> On Thu, Apr 28, 2022 at 1:30 PM Christian Brauner <brauner@kernel.org> wrote:
> >
> > On Thu, Apr 28, 2022 at 12:10:24PM +0200, Miklos Szeredi wrote:
> > > On Thu, 7 Apr 2022 at 13:23, Christian Brauner <brauner@kernel.org> wrote:
> > > >
> > > > Make the two places where lookup helpers can be called either on lower
> > > > or upper layers take the mount's idmapping into account. To this end we
> > > > pass down the mount in struct ovl_lookup_data. It can later also be used
> > > > to construct struct path for various other helpers. This is needed to
> > > > support idmapped base layers with overlay.
> > > >
> > > > Cc: <linux-unionfs@vger.kernel.org>
> > > > Tested-by: Giuseppe Scrivano <gscrivan@redhat.com>
> > > > Reviewed-by: Amir Goldstein <amir73il@gmail.com>
> > > > Signed-off-by: Christian Brauner (Microsoft) <brauner@kernel.org>
> > > > ---
> > > > /* v2 */
> > > > unchanged
> > > >
> > > > /* v3 */
> > > > unchanged
> > > >
> > > > /* v4 */
> > > > - Vivek Goyal <vgoyal@redhat.com>:
> > > >   - s/ovl_upper_idmap()/ovl_upper_mnt_userns()/g
> > > >
> > > > /* v5 */
> > > > unchanged
> > > > ---
> > > >  fs/overlayfs/export.c  |  3 ++-
> > > >  fs/overlayfs/namei.c   | 14 ++++++++------
> > > >  fs/overlayfs/readdir.c | 10 +++++-----
> > > >  3 files changed, 15 insertions(+), 12 deletions(-)
> > > >
> > > > diff --git a/fs/overlayfs/export.c b/fs/overlayfs/export.c
> > > > index ebde05c9cf62..5acf353d160b 100644
> > > > --- a/fs/overlayfs/export.c
> > > > +++ b/fs/overlayfs/export.c
> > > > @@ -391,7 +391,8 @@ static struct dentry *ovl_lookup_real_one(struct dentry *connected,
> > > >          * pointer because we hold no lock on the real dentry.
> > > >          */
> > > >         take_dentry_name_snapshot(&name, real);
> > > > -       this = lookup_one_len(name.name.name, connected, name.name.len);
> > > > +       this = lookup_one(mnt_user_ns(layer->mnt), name.name.name,
> > > > +                         connected, name.name.len);
> > >
> > > This one is tricky.  It's doing a lookup on overlay, so messing with
> > > the underlying mnt_userns is definitely wrong.
> > >
> > > Is the mnt_userns needed for permission checking?   Possibly in that
> > > case the permission checking needs to be skipped altogether, since
> > > it's doing an fh -> dentry lookup which should succeed regardless of
> > > caller's caps.
> >
> > If capabilities are checked then it's always caller's user namespace
> > that is used (Ofc, exceptions being filesystem-wide operations where
> > capabilities in the filesystem's userns are needed but that doesn't
> > apply here.).
> >
> > Nothing has changed with the introduction of the mnt_userns in the
> > area of capability checking. IOW, the mnt_userns isn't used for
> > capability checks as that would be a major permission model change
> > overall (It might have applications in the future ofc.).
> >
> > The mnt_userns matters for permission checking only in so far as it is
> > used to map the k{g,u}ids according to the mount and so is relevant in
> > only that sense in inode_permission().
> >
> > If this is doing a lookup on an overlay and the relevant mount isn't
> > supposed to be idmapped then the simple thing to do is to pass
> > &init_user_ns.
> >
> > Could you explain what "lookup on overlay" means here, i.e. what mount
> > is relevant?
>
> Let me explain because it's my hack ;)
>
> We need to find an ovl dentry corresponding with the dirent
> readdir result.
>
> The correct mount to use for lookup_one() is path->mnt
> (the mount of the ovl_readdir path) same as is done a few lines later
> for calling vfs_getattr().

That's a different one.   Apparently the correct mount is already used
in that case.

Thanks,
Miklos
