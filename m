Return-Path: <linux-unionfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E3DA0CD8CAE
	for <linux-unionfs@archiver.kernel.org>; Tue, 10 Oct 2023 18:16:00 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233691AbjJJSQA (ORCPT
        <rfc822;linux-unionfs@archiver.kernel.org>);
        Tue, 10 Oct 2023 14:16:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43798 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233489AbjJJSP6 (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Tue, 10 Oct 2023 14:15:58 -0400
Received: from mail-qt1-x82e.google.com (mail-qt1-x82e.google.com [IPv6:2607:f8b0:4864:20::82e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5CF9894
        for <linux-unionfs@vger.kernel.org>; Tue, 10 Oct 2023 11:15:57 -0700 (PDT)
Received: by mail-qt1-x82e.google.com with SMTP id d75a77b69052e-418148607c2so33238751cf.3
        for <linux-unionfs@vger.kernel.org>; Tue, 10 Oct 2023 11:15:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1696961756; x=1697566556; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=sovwXefHaL0pqbsrydPETP8JWSUI3hsCveObYwv+PVg=;
        b=lUyRYU1/fhmg389eUT1nDprLlbC2AZpD/EuVfMIvBDP6n7ma5LFnEc6RiYte61jfCB
         m37tBnwSrXXu+HpKlDQlKwtmhSRQX19KXnHNZK/tJsxq7e8IcC4EHJYsI45pmgix8HDk
         mb8Rocad/4tABzA9jcWzBfmOrVDVIyqVPE8szLfFnOqfLT495fg2kxdP1c/hXwRw8Mwt
         Tidd/aYVlarLnZF5/qu5CYsCTYlT6ZIXcXunEd7c6uG1BZur1u/1fNkcl+ebKp8Bppd+
         4n7vNeFAwzhS7zbV4zazAn05SvmweIkELYaGklRPQF/rG0EizipTuDpHo5XnIdyNL6Zi
         U+ig==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1696961756; x=1697566556;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=sovwXefHaL0pqbsrydPETP8JWSUI3hsCveObYwv+PVg=;
        b=Q39jwSlq28POlRlL++LYLJnPfuod71nRx/41zkGbqE7W/1aFC/DjgcC15UQ6L0rr1A
         6UiRZqbqtLopsnzfXx6aC0IZckhziiJflWcIXEI+dNgLQxS0BTRjxm23gDQfDNaBomtL
         CB5HDbyFVref6AyhMLnFI9MCngAzXN73L7RnGZZkhYvCBbUunJH7Za1CT7XvtgvQRFzs
         y1ooH5fpK+vI4eAPXtoSI4cPmo3SO8n0CNkD42AFrzQFjdzuGXEyXe2GLv/r9XpBjaeN
         29jyxt7tfOJ6gfZ6jE0ENaJX31Eaf36p+1obn7Kc9p4Fe70ISEqx2LEMeNdo4WHkWg//
         00kQ==
X-Gm-Message-State: AOJu0YyPSW6P2T7OJMEQ7upC+0Je0Uy2WU8yKzWSYUhJvx/HDS49F45y
        ZRpRaMJC6wqHE5sO0WwulsrJBOoaSs2MtwB/qSZez3/5uV8=
X-Google-Smtp-Source: AGHT+IEFs59UC0gJ+wns0ZIFLCChWvBQ6i2VZgSNG3LNwA/b40thrlwC/RA7yJd3/qnMRsqJelUNfER1++DE4MX9v/I=
X-Received: by 2002:ac8:5fd6:0:b0:413:bd3:cda5 with SMTP id
 k22-20020ac85fd6000000b004130bd3cda5mr23204824qta.49.1696961756408; Tue, 10
 Oct 2023 11:15:56 -0700 (PDT)
MIME-Version: 1.0
References: <8da307fb-9318-cf78-8a27-ba5c5a0aef6d@alum.mit.edu>
 <CAOQ4uxhQhzv_LUW89m_BmKf+NjE+XDyY9XtLAt+SWG03M6LmYQ@mail.gmail.com>
 <20231006130259.GA438068@toolbox> <CAOQ4uxg84M7H0EtTLWAsNkHaaLzVVXQ=-fCVFVr8a6MGSQC=vg@mail.gmail.com>
 <5d708a45-43c9-b026-6619-7c377ee02793@alum.mit.edu> <CAOQ4uxgNakTHi0dHC1v51TCU_aAKTOrJ4zFv=BzfoKNMsCwZEg@mail.gmail.com>
 <CAJfpegsFNjMX+Lz8uX-6=fDa59qYJQjnUnJpzKiTxuBziC7pxQ@mail.gmail.com>
 <CAOQ4uxgNr=ZbHTB8TcMfWLceBoQD0a2u4Bzo3-Hr3QZTRoBjLQ@mail.gmail.com>
 <CA+hFU4w78Ze-wKPg9fsdR6zpL5VUwp8jNqCcHGmOFJ--GAGKJA@mail.gmail.com>
 <CAOQ4uxhSTJaZggq-z_3oPbXh48n88E1QjfNTr5HO1ZuqyrF+ew@mail.gmail.com> <CA+hFU4w8mdo1DrWPU3MNM=YBXE9aVD2yFOe_zXXq1U51B0h7kw@mail.gmail.com>
In-Reply-To: <CA+hFU4w8mdo1DrWPU3MNM=YBXE9aVD2yFOe_zXXq1U51B0h7kw@mail.gmail.com>
From:   Amir Goldstein <amir73il@gmail.com>
Date:   Tue, 10 Oct 2023 21:15:44 +0300
Message-ID: <CAOQ4uxjhpKU=YfG7KjAYtyQNFzVSpwpYEvPvbMZL_fXssqk1Dg@mail.gmail.com>
Subject: Re: [regression?] escaping commas in overlayfs mount options
To:     Sebastian Wick <sebastian.wick@redhat.com>
Cc:     Miklos Szeredi <miklos@szeredi.hu>,
        Ryan Hendrickson <ryan.hendrickson@alum.mit.edu>,
        Christian Brauner <brauner@kernel.org>,
        linux-unionfs@vger.kernel.org, Karel Zak <kzak@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <linux-unionfs.vger.kernel.org>
X-Mailing-List: linux-unionfs@vger.kernel.org

On Tue, Oct 10, 2023 at 8:33=E2=80=AFPM Sebastian Wick
<sebastian.wick@redhat.com> wrote:
>
> On Tue, Oct 10, 2023 at 6:54=E2=80=AFPM Amir Goldstein <amir73il@gmail.co=
m> wrote:
> >
> > On Tue, Oct 10, 2023 at 7:13=E2=80=AFPM Sebastian Wick
> > <sebastian.wick@redhat.com> wrote:
> > >
> > > On Tue, Oct 10, 2023 at 12:00=E2=80=AFPM Amir Goldstein <amir73il@gma=
il.com> wrote:
> > > >
> > > > On Tue, Oct 10, 2023 at 12:06=E2=80=AFPM Miklos Szeredi <miklos@sze=
redi.hu> wrote:
> > > > >
> > > > > On Fri, 6 Oct 2023 at 19:21, Amir Goldstein <amir73il@gmail.com> =
wrote:
> > > > > >
> > > > > > On Fri, Oct 6, 2023 at 7:42=E2=80=AFPM Ryan Hendrickson
> > > > >
> > > > > > > And there is the escaping that needs to happen for ':' and '\=
' when
> > > > > > > parsing the path parameters (':' is only special syntax in lo=
werdir, but
> > > > > > > the escaping logic seems to apply to upperdir and workdir as =
well, based
> > > > > > > on my testing). Even using the new API, this is handled in th=
e kernel.
> > > > > > > We'd like to know if this escaping can be considered stable a=
s well, and I
> > > > > > > don't think that's a question for the libmount maintainer.
> > > > > >
> > > > > > Agree.
> > > > > > Unlike the comma separated parameters list,
> > > > > > upperdir,workdir,lowerdir are overlayfs specific format.
> > > > > >
> > > > > > ovl_unescape() (for upperdir/workdir) unescapes '\' characters.
> > > > > > as does ovl_parse_param_split_lowerdirs().
> > > > > > Not sure why this was needed for upperdir/workdir, but it It ha=
s
> > > > > > been this way for a long time.
> > > > > > I see no reason for it to change in the future.
> > > > >
> > > > > Unescaping  upperdir/workdir was the side effect of using a commo=
n
> > > > > helper; it wasn't intentional, I think.  The problem is that
> > > > > unescaping breaks code that doesn't expect it, and filenames with
> > > > > backslashes (and especially \\ or \: sequences) are very rare, so=
 this
> > > > > won't show up in testing.
> > > > >
> > > > > At this point I'm not sure which is more likely to cause bugs: ge=
tting
> > > > > rid of unescaping or leaving it alone.
> > > >
> > > > Considering the fact that the applications that mount overlayfs has
> > > > always had to do the correct escaping, getting rid of escaping can
> > > > only solve issues in new deployments, so I think we should greatly
> > > > favor leaving it alone.
> > >
> > > Any change here is a regression. I'm seriously confused why this is
> > > even debated. You already managed to have a regression and I'm still
> > > of the opinion that this should be fixed because it literally breaks
> > > user space.
> > >
> >
> > You are right. Literally it does.
> > But if prospect users are ok with upgrading libmount and if that
> > solves the problem, I'd rather not have to carry in the kernel
> > baggage code to support old mount API for a very niche use case.
> >
> > > > >
> > > > > One way out of this mess is to create explicit _unesc versions of=
 these options.
> > > > >
> > > >
> > > > I like that solution, with two reservations:
> > > > 1. IMO, new _unesc versions should only be supported from new mount=
 API
> > > > 2. I only want to do that if real users exists - said users are exp=
ected
> > > >     to send the patch and explain their use case
> > >
> > > This is confusing me a lot. Why would you not want to provide an API
> > > which is clearly, objectively the better API? As user space, when we
> > > can use the new mount API and we could use this, we absolutely would
> > > use this.
> >
> > I am also confused by this reaction.
> > Who said that I do not want to provide the _unenc API?
> >
> > IIUC, you are requesting a new feature that did not exist before,
> > namely, upperdir_unenc, workdir_unenc, lowerdir_unenc options.
> > Did I understand correctly?
> > If that is the case then please send a patch to support
> > those new options in the new mount API only
> > including documentation and tests.
>
> My entire problem is that you break user space. Either fix the
> regression and *continue* fixing regressions instead of hoping that no
> one complains enough and escalates things, or give us another API
> where you can actually make that guarantee. The current way is simply
> not workable.

Ok. No need for hostility, I am just trying to figure out what would
be the best solution for everyone going forward.

How about an API that takes upperdirfd, workdirfd, lowerdirfd,
leaving string parsing and path resolution completely out of the equation?

I think this is something that Christian had once suggested.
I think that will be a good improvement for many other use cases as well.

Will that work for you?

>
> Even if we'd accept this regression (and thus regress our user space
> to not handle any paths any more), the commitment to keeping the API
> stable in this thread has been "we'll try" instead of a "yes,
> absolutely" and that makes me worry as well.

It may not be me, it may be someone else, so there is a limit to my
commitment, but kernel developers usually abide by Linus' no regressions
rules (which do allow some slack).

Anyway, let's focus on what you would like best.
If you prefer to just fix the regression, it is doable.
If you prefer the upperdirfd, workdirfd, lowerdirfd API, I think we can
find a volunteer to write it up.

Thanks,
Amir.
