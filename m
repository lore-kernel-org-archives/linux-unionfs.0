Return-Path: <linux-unionfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A99F6C77B61
	for <linux-unionfs@archiver.kernel.org>; Tue, 25 Apr 2023 19:07:56 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234230AbjDYTHz (ORCPT
        <rfc822;linux-unionfs@archiver.kernel.org>);
        Tue, 25 Apr 2023 15:07:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35170 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231356AbjDYTHy (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Tue, 25 Apr 2023 15:07:54 -0400
Received: from mail-ej1-x62f.google.com (mail-ej1-x62f.google.com [IPv6:2a00:1450:4864:20::62f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B54914EC5
        for <linux-unionfs@vger.kernel.org>; Tue, 25 Apr 2023 12:07:53 -0700 (PDT)
Received: by mail-ej1-x62f.google.com with SMTP id a640c23a62f3a-94f3cd32799so1150764266b.0
        for <linux-unionfs@vger.kernel.org>; Tue, 25 Apr 2023 12:07:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=szeredi.hu; s=google; t=1682449672; x=1685041672;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=t+lW5/aM+/TFAIDX9oO6p6JBJrzahjMhzzRYEiI/91o=;
        b=VszDIwa86Oy1/6P7MsMKkJ2314zqqV+3jRidGlgbk1Ybgy1YFjUsPWYH0OI0GSoE6A
         fUnQGv3luX3w1eVaWHR0nnlFg6A6KUypw8zWVdN18raukvFbLjz0zOgtgcfvcrjSsnZk
         gk7nVoDG5vOhhG8vNahG2potOr91UBKJmS++0=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1682449672; x=1685041672;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=t+lW5/aM+/TFAIDX9oO6p6JBJrzahjMhzzRYEiI/91o=;
        b=cJYF7fEtHSzd8hYKGxoUhdl4JRjbCYlvDYas93Q6dwU3rOZ0pWfQ2vfeX9DTbIN5Im
         2B2Y8EkGJcnobGrMPV2wnoVIS+LTtp4QTBNq2T54z6Oeq7GrelOyIgDOfNN5zo6pnr65
         NJ3/MbqNJ0gIg/ArQbdrgYRFCQYsZ5xcwyMJFll+kzcRJatyRHkrhi8oofzpe2J3t5Kl
         rcD1njx6o5MitGo0MW8YVVsb4Ie9YTvFFUKFYk00jOMwRwAdu5jH6c9aN8c6DpeVeufb
         dZt5BCa/6a9inGZlFhygVag1iWszNFfswV7eYU3EE342H44hB08r8OXUyJyQfhU8T9+3
         3Scg==
X-Gm-Message-State: AAQBX9fchYdoIZsSUQmdw2CofbIjn3zzkOLnXRE3H9+EGG4cq/7MH8xo
        8Vt4TosTemAC7FqkuhAUv6XQOF51EKWEZE1Wxkzjuw==
X-Google-Smtp-Source: AKy350bXlLW5KjjjNKmqkNrF7QfE4/BABON23+81fkQWyktXxvUUDCXeaeJ4gOde363uGverivFppjtuyIvpskCXPtY=
X-Received: by 2002:a17:906:b341:b0:953:4a7c:900b with SMTP id
 cd1-20020a170906b34100b009534a7c900bmr13338723ejb.33.1682449672175; Tue, 25
 Apr 2023 12:07:52 -0700 (PDT)
MIME-Version: 1.0
References: <cover.1681917551.git.alexl@redhat.com> <2b2c5ecaf80f810f46791a94d8638ec4027a3a0e.1681917551.git.alexl@redhat.com>
 <CAJfpegt_=nNne51Au0AvhVwBgHBesCQ9YCC6WMGVyN6nUA_B2A@mail.gmail.com> <CAL7ro1ErBN_VmTpe8EmDTVHBsQnZaMEhHKcbEtGy-ynkhzKcVA@mail.gmail.com>
In-Reply-To: <CAL7ro1ErBN_VmTpe8EmDTVHBsQnZaMEhHKcbEtGy-ynkhzKcVA@mail.gmail.com>
From:   Miklos Szeredi <miklos@szeredi.hu>
Date:   Tue, 25 Apr 2023 21:07:40 +0200
Message-ID: <CAJfpegtLBYPQfXKZs=B2kiexrr-iDtmUYr0AshkT=epnSovo4A@mail.gmail.com>
Subject: Re: [PATCH 4/6] ovl: Add framework for verity support
To:     Alexander Larsson <alexl@redhat.com>
Cc:     linux-unionfs@vger.kernel.org, amir73il@gmail.com,
        ebiggers@kernel.org, tytso@mit.edu, fsverity@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <linux-unionfs.vger.kernel.org>
X-Mailing-List: linux-unionfs@vger.kernel.org

On Tue, 25 Apr 2023 at 15:33, Alexander Larsson <alexl@redhat.com> wrote:
>
> On Tue, Apr 25, 2023 at 1:19=E2=80=AFPM Miklos Szeredi <miklos@szeredi.hu=
> wrote:
> >
> > On Thu, 20 Apr 2023 at 09:44, Alexander Larsson <alexl@redhat.com> wrot=
e:

> > > +There are two ways to tune the default behaviour. The kernel config
> > > +option OVERLAY_FS_VERITY, or the module option "verity=3DBOOL". If
> > > +either of these are enabled, then verity mode is "on" by default,
> > > +otherwise it is "validate".
> >
> > I'm not sure that enabling verity by default is safe.  E.g. a script
> > mounts overalyfs but doesn't set the verity mount, since it's on by
> > default.  Then the script is moved to a different system where the
> > default is off, which will result in verity not being enabled, even
> > though that was not intended.  Is there an advantage to allowing to
> > change the default?  I know it's done for most of the overlayfs
> > options, but I think this is different.
>
> I sort of agree, in particular because many filesystems still don't
> support verity, or need it to be specifically enabled.
> So, what about dropping "validate" and go with modes: "off, on,
> require", where "off" is the default?

Okay.

Thanks,
Miklos
