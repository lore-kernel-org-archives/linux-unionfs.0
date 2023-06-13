Return-Path: <linux-unionfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 95F9BC7EE2E
	for <linux-unionfs@archiver.kernel.org>; Tue, 13 Jun 2023 09:34:46 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240311AbjFMJeo (ORCPT
        <rfc822;linux-unionfs@archiver.kernel.org>);
        Tue, 13 Jun 2023 05:34:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53148 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241247AbjFMJee (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Tue, 13 Jun 2023 05:34:34 -0400
Received: from mail-ua1-x92e.google.com (mail-ua1-x92e.google.com [IPv6:2607:f8b0:4864:20::92e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A32351BC5
        for <linux-unionfs@vger.kernel.org>; Tue, 13 Jun 2023 02:34:22 -0700 (PDT)
Received: by mail-ua1-x92e.google.com with SMTP id a1e0cc1a2514c-78a065548e3so329702241.0
        for <linux-unionfs@vger.kernel.org>; Tue, 13 Jun 2023 02:34:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1686648861; x=1689240861;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=52WRH9Kv8GkDTKf8Sf3tnfccbLz+vAiltYLe/Gsewf0=;
        b=bGhxvAtUmAIEQ20+3I4HygHadgN0gYphtJE5CoguTFkowEgnQXrPrwnhjfrhembFvc
         25YETNKF6M8hXg9NbS3sIqNz6ZTXC99SGCkNWCMHz48rXw9c6v0nB+uiNRZbtVZdCBm+
         2c9xEm4g6VnbIHAHP3ypajXpauLU5H73XEISXdOlXmDKM1ybKp7eKN6868PJQ6fXJz/q
         1hA07fFeszCH+7meEsFatdcPzmV38jkqh2ImEaFRZX3oYmeLIQKSaS48cICKrmzeNjlb
         z/ACcydQTL5wRpGcLg5mSQvlM4sX2ZvxHvVEerZZviF2y6ebulnYQUPO8AB7wh7SyTJ1
         7hbA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1686648861; x=1689240861;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=52WRH9Kv8GkDTKf8Sf3tnfccbLz+vAiltYLe/Gsewf0=;
        b=av7CXRF3ILLpdpHrewa9IfdMYvJ6MWjcqI7EMGIVqQu3r3JWW/ZCR382AhKrDt1j2a
         4bfR0KJyLRwp3niiQxP5+Abug60EJSMFsAdMHxm7Ryx1HlYwCEcYmFy17KMR5W7urANk
         My9jEFS54ffpgTRKe3PA7TofIHzGes4R4qvymZBLjoGWaZlnlUfjqxgIWEtmR/KpIL2g
         KVAuA8iLVSu4MZy05+AJ/tj/6hlNfgibnCJmbSvBai+IjzkWukB/Fw3CoY18GrDyl9Ly
         GEFKHjw/6HdHxBEqAe8mLJDZtUsvbSCrM23+wf1u+CjLYWfI2bKYJXNMcd1BQsQwxj25
         ZJNA==
X-Gm-Message-State: AC+VfDyF7MRxo32EMlK9gmjP+yQU0DPc6WTawOy2C3kWCqRyUw7RQszB
        RMXkAb7nqi6VCjzlMlxXoj81+TeqtqxTq/sd27j9hm0u8O0=
X-Google-Smtp-Source: ACHHUZ6YdZvTi8/QML6y+TShwyA4ItvPrwqhT49+J54O7SyAlawCabjVaXFmhC7GAC0oOQnYEhjZnFFKLlloHlwB4q4=
X-Received: by 2002:a67:f5c8:0:b0:43b:3b8c:740e with SMTP id
 t8-20020a67f5c8000000b0043b3b8c740emr5976542vso.10.1686648861048; Tue, 13 Jun
 2023 02:34:21 -0700 (PDT)
MIME-Version: 1.0
References: <cover.1686565330.git.alexl@redhat.com> <03ac0ffd82bc1edc3a9baa68d1125f5e8cad93fd.1686565330.git.alexl@redhat.com>
 <20230612163216.GA847@sol.localdomain> <CAOQ4uxjS5-7_PaoxM41YaXW+KxwLK_K8AyJMaoi1m-3P-vZ9Kw@mail.gmail.com>
 <20230613063704.GA879@sol.localdomain>
In-Reply-To: <20230613063704.GA879@sol.localdomain>
From:   Amir Goldstein <amir73il@gmail.com>
Date:   Tue, 13 Jun 2023 12:34:10 +0300
Message-ID: <CAOQ4uxg6BD_RDtWob5q2eX6uQ5hcWrK7wEDcBhFVrGM3vsn=NA@mail.gmail.com>
Subject: Re: [PATCH v3 2/4] ovl: Add framework for verity support
To:     Eric Biggers <ebiggers@kernel.org>
Cc:     Alexander Larsson <alexl@redhat.com>, miklos@szeredi.hu,
        linux-unionfs@vger.kernel.org, tytso@mit.edu,
        fsverity@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <linux-unionfs.vger.kernel.org>
X-Mailing-List: linux-unionfs@vger.kernel.org

On Tue, Jun 13, 2023 at 9:37=E2=80=AFAM Eric Biggers <ebiggers@kernel.org> =
wrote:
>
> On Tue, Jun 13, 2023 at 08:18:50AM +0300, Amir Goldstein wrote:
> > On Mon, Jun 12, 2023 at 7:32=E2=80=AFPM Eric Biggers <ebiggers@kernel.o=
rg> wrote:
> > >
> > > On Mon, Jun 12, 2023 at 12:27:17PM +0200, Alexander Larsson wrote:
> > > > +fs-verity support
> > > > +----------------------
> > > > +
> > > > +When metadata copy up is used for a file, then the xattr
> > > > +"trusted.overlay.verity" may be set on the metacopy file. This
> > > > +specifies the expected fs-verity digest of the lowerdata file. Thi=
s
> > > > +may then be used to verify the content of the source file at the t=
ime
> > > > +the file is opened. During metacopy copy up overlayfs can also set
> > > > +this xattr.
> > > > +
> > > > +This is controlled by the "verity" mount option, which supports
> > > > +these values:
> > > > +
> > > > +- "off":
> > > > +    The verity xattr is never used. This is the default if verity
> > > > +    option is not specified.
> > > > +- "on":
> > > > +    Whenever a metacopy files specifies an expected digest, the
> > > > +    corresponding data file must match the specified digest.
> > > > +    When generating a metacopy file the verity xattr will be set
> > > > +    from the source file fs-verity digest (if it has one).
> > > > +- "require":
> > > > +    Same as "on", but additionally all metacopy files must specify=
 a
> > > > +    verity xattr. This means metadata copy up will only be used if
> > > > +    the data file has fs-verity enabled, otherwise a full copy-up =
is
> > > > +    used.
> > >
> > > It looks like my request for improved documentation was not taken, wh=
ich is
> > > unfortunate and makes this patchset difficult to review.
> > >
> >
> > Which one?
> > IIRC, you had two requests.
> > One very broad to get the overlayfs.rst document up-to-date:
> > [1] https://lore.kernel.org/linux-unionfs/20230514190903.GC9528@sol.loc=
aldomain/
>
> That isn't an accurate summary of what I said.  I actually pointed out tw=
o
> specific things that are confusing specifically in the context of this fe=
ature.
>
> > But I assume you mean the specific request about this sentence:
> > [2] https://lore.kernel.org/linux-unionfs/20230514192227.GE9528@sol.loc=
aldomain/
>
> And that was a third specific thing.  I got a detailed response back
> (https://lore.kernel.org/linux-unionfs/CAL7ro1GGAfdZG9cHDWE2vnhY5tSE=3D9M=
xYi_n_gJHRfaw7zMSgg@mail.gmail.com),
> which was helpful.  Unfortunately, the information in that response hasn'=
t yet
> found its way into the documentation that is being proposed.

This response is mostly about composefs and as Alex wrote
these details have no place in overlayfs.rst and not related to the
proposed feature, which stands alone even without composefs.

>
> In general the proposed documentation reads like the audience is overlayf=
s
> developers.

I never considered that overlayfs.rst is for an audience other than
overlayfs developers or people that want to become overlayfs
developers. It is not a user guide. If it were, it would have been a
very bad one.

> It doesn't describe the motivation for the feature or how to use it
> in each of the two use cases.  Maybe that is intended, but it's not what =
I had
> expected to see.
>

Yeh, that's a valid point.
That is what I wanted to know - what exactly is missing.
I guess this is the documented motivation:

"This may then be used to verify the content of the source file at the time
the file is opened"

but it does not tell a complete chain of trust story.

How about something along the lines of:

"In the case that the upper layer can be trusted not to be tampered
with while overlayfs is offline and some of the lower layers cannot
be trusted not to be tampered with, the "verity" feature can protect
against offline modification to lower files, whose metadata has been
copied up to the upper layer (a.k.a "metacopy" files) ...."

It's generic language that what the patches do, regardless of the
trust model of composefs and how it composes an overlayfs layers.

> Side note: the use of the passive voice, e.g. "the xattr may be set" and =
"the
> xattr may then be used to verify", should be avoided since it makes it un=
clear
> who/what is doing these actions.
>

I am not a native English speaker and bad at documentation in general,
so the only thing I can say is the passive-aggressive "patches welcome" ;-)

Thanks,
Amir.
