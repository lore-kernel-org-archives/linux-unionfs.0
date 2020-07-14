Return-Path: <SRS0=Lx5L=AZ=vger.kernel.org=linux-unionfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.1 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,
	SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 70E8BC433DF
	for <linux-unionfs@archiver.kernel.org>; Tue, 14 Jul 2020 16:57:53 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 4E3952242B
	for <linux-unionfs@archiver.kernel.org>; Tue, 14 Jul 2020 16:57:53 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="OmgDSZVM"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726252AbgGNQ5x (ORCPT
        <rfc822;linux-unionfs@archiver.kernel.org>);
        Tue, 14 Jul 2020 12:57:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48944 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726062AbgGNQ5w (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Tue, 14 Jul 2020 12:57:52 -0400
Received: from mail-il1-x142.google.com (mail-il1-x142.google.com [IPv6:2607:f8b0:4864:20::142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 91A9DC061755
        for <linux-unionfs@vger.kernel.org>; Tue, 14 Jul 2020 09:57:52 -0700 (PDT)
Received: by mail-il1-x142.google.com with SMTP id t4so14816687iln.1
        for <linux-unionfs@vger.kernel.org>; Tue, 14 Jul 2020 09:57:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=NIom9mw0Ev3APIQfJ3jQqmwMZqeRC+cVfGb/3NBBjO8=;
        b=OmgDSZVMmSNhe7MdSPqb4Gw+fda+SkL9MTd5aGutgU0MSm3TwWv4L46Ywjc1nZAz7Z
         8Qi5XC6P8mwkDxzOJ0sGodgLvjq8604M5wwc8B0gSJ1N9W+stLwWRZ5RrZFduuZ+kBU7
         cX4BNxEpuHGGu9IQT83rQgzsqzzUuHfn/0SzhMw3/Er892Q27RiWreVRG79ykBi4vKvS
         454cA1SV0qWU29dI6XwAzZmrvuuVYhH/rKksmNGEwDvO4SfPF+DE1kQKkiRHoTfgCnQA
         JrjL7BkyaIXhk57EaX6lJAfCVSIlub7YRGvFF2H/YgjIBcIZwdb1rAWbI5eeEes0bke6
         BFSw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=NIom9mw0Ev3APIQfJ3jQqmwMZqeRC+cVfGb/3NBBjO8=;
        b=VPTjrMBI0WTjkaqJVxTJ88ry7kdyiARiyVry2rHm7iHVFbzUTcTbN1g5z8YzXPAsJK
         x4+NpgeWiGZSEHpgbDcv54VGPpT0y1q0VLcIc723GKXehKJX8sMMZyY479nUJiineCGW
         xmrVEr9DjJ9IH71p/tX7yS/t1paGGCXLLxXJEr0YZSgQqkQnJQbiYdTgnAdRf8lI/tab
         oHIk/eXcdaq5Hc6jriUkljPdS/7BQQUyNnWxuszaiWEkjHvr+dTHPFN/7EoIxmQGb1JJ
         zrpu3zmAgIWWAhKTSxsaghiiZ8sE+Jf32D1Lnf6yTxBJAUCjwNGml/KP5/JmHOCxcVRg
         oJuw==
X-Gm-Message-State: AOAM531DdAHWglqbZDvX88/yQcMajeL1IFMLjb+kz/KDe/6Z0OyVf2pS
        DFMZfg8wKF3abeUrWds78etutRaVUI026fHUAcA=
X-Google-Smtp-Source: ABdhPJwC1THnqFOrNGTqAJxT8XEofsCtmJbUsrlnWGU0EhQiAsgQ/3i8g/SbZmSOgbmfAzg/xA1tps7OETbsS27anzw=
X-Received: by 2002:a92:b6d4:: with SMTP id m81mr5681849ill.72.1594745871765;
 Tue, 14 Jul 2020 09:57:51 -0700 (PDT)
MIME-Version: 1.0
References: <20200713105732.2886-1-amir73il@gmail.com> <CAOQ4uxg9PWi+645+zeH77FKQwi+RJ6bFugqG8Zv6qpPPJuTPnQ@mail.gmail.com>
 <20200714162213.GD324688@redhat.com>
In-Reply-To: <20200714162213.GD324688@redhat.com>
From:   Amir Goldstein <amir73il@gmail.com>
Date:   Tue, 14 Jul 2020 19:57:40 +0300
Message-ID: <CAOQ4uxhGjLKA+2O8mBnS7pJdaFPxAvY_OiV+rZmVUkTG2rTqJQ@mail.gmail.com>
Subject: Re: [PATCH RFC 0/2] Invalidate overlayfs dentries on underlying changes
To:     Vivek Goyal <vgoyal@redhat.com>
Cc:     Miklos Szeredi <miklos@szeredi.hu>,
        Josh England <jjengla@gmail.com>,
        overlayfs <linux-unionfs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-unionfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-unionfs.vger.kernel.org>
X-Mailing-List: linux-unionfs@vger.kernel.org

On Tue, Jul 14, 2020 at 7:22 PM Vivek Goyal <vgoyal@redhat.com> wrote:
>
> On Tue, Jul 14, 2020 at 12:29:08PM +0300, Amir Goldstein wrote:
> > On Mon, Jul 13, 2020 at 1:57 PM Amir Goldstein <amir73il@gmail.com> wrote:
> > >
> > > Miklos,Vivek,
> > >
> > > These patches are part of the new overlay "fsnotify snapshot" series
> > > I have been working on.
> > >
> > > Conterary to the trend to disallow underlying offline changes with more
> > > configurations, I have seen that some people do want to be able to make
> > > some "careful" underlying online changes and survive [1].
> > >
> > > In the following patches, I argue for improving the robustness of
> > > overlayfs in the face of online underlying changes, but I have not
> > > really proved my claims, so feel free to challenge them.
> > >
> >
> > This wasn't actually working unless underlying fs was remote, because
> > overlayfs clears the DCACHE_OP_REVALIDATE flags in that case.
> >
> > I added this hunk for revalidate of local lower fs with nfs_export=on:
> >
> > @@ -111,6 +111,10 @@ void ovl_dentry_update_reval(struct dentry
> > *dentry, struct dentry *upperdentry,
> >         for (i = 0; i < oe->numlower; i++)
> >                 flags |= oe->lowerstack[i].dentry->d_flags;
> >
> > +       /* Revalidate on local fs lower changes */
> > +       if (oe->numlower && ovl_verify_lower(dentry->d_sb))
> > +               flags |= mask;
> > +
> >
> >
> > > I also remember we discussed several times about the conversion of
> > > zero return value to -ESTALE, including in the linked thread.
> > > I did not change this behavior, but I left a boolean 'strict', which
> > > controls this behavior. I am using this boolean to relax strict behavior
> > > for snapshot mount later in my snapshot series. Relaxing the strict
> > > behavior for other use cases can be considered if someone comes up with
> > > a valid use case.
> > >
> >
> > After giving this some more though, I came to a conclusion that it is actually
> > wrong to convert 0 to error because 0 could mean cache timeout expiry
> > or other things that do not imply anyone has made underlying changes.
> > I see that fuse_dentry_revalidate() handles timeout expiry internally and
> > other network filesystems may also do that, but there is nothing in the
> > "contract" about not returning 0 if entry MAY be valid.
> > Am I wrong?
> >
> > I can even think of a network filesystem that marks its own dentry for lazy
> > revalidate after some local changes, so this behavior is even more dodgy
> > when dealing with remote upper fs.
> >
> > So I added another patch to remove the conversion 0 => -ESTALE.
> >
> > Pushed these patches to
> > https://github.com/amir73il/linux/commits/ovl-revalidate:
> >  ovl: invalidate dentry if lower was renamed
> >  ovl: invalidate dentry with deleted real dir
> >  ovl: do not return error on remote dentry cache expiry
>
> So what's the end goal. We don't want to return error during lookup,
> if underlying layer changed and instead force re-lookup. And re-lookup
> might work in a slightly different way and that's allowed?
>

Correct.

> IOW, we don't want to return error if we detected lower layer change
> and just continue to run. It might fail later or it might subtly
> change behavior in some way (inode number reporting etc). But that's
> fine?
>

Correct.

> What will documentation says. Lower layer changes are allowed? Or
> we say lower layer changes are not allowed but overlay will not
> flag it at runtime even if we detect it.
>

We do not change our statement:
"Changes to the underlying filesystems while part of a mounted overlay
filesystem are not allowed.  If the underlying filesystem is changed,
the behavior of the overlay is undefined, though it will not result in
a crash or deadlock."

Only we are slightly more credible when saying won't result in
crash or deadlock...

Note that we can perform similar validations before certain operations,
for example, validate parent stack before performing ovl_lookup()
to further fortify the code against xxxat(dfd, ...) syscalls.

Another operation that works on an fd with dentry that may have lowerstack
that might be relevant is ovl_iterate(), but I wouldn't go dealing with them
one by one without a plan.

The reason I posted those RFC patches is because I wrote them anyway
for my snapshot series, so though they might be of interest.

Thanks,
Amir.
