Return-Path: <linux-unionfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 24902EE4993
	for <linux-unionfs@archiver.kernel.org>; Mon, 21 Aug 2023 13:26:04 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232495AbjHUN0E (ORCPT
        <rfc822;linux-unionfs@archiver.kernel.org>);
        Mon, 21 Aug 2023 09:26:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57854 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235358AbjHUN0D (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Mon, 21 Aug 2023 09:26:03 -0400
Received: from mail-vs1-xe2a.google.com (mail-vs1-xe2a.google.com [IPv6:2607:f8b0:4864:20::e2a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 466AAD1
        for <linux-unionfs@vger.kernel.org>; Mon, 21 Aug 2023 06:26:02 -0700 (PDT)
Received: by mail-vs1-xe2a.google.com with SMTP id ada2fe7eead31-44768034962so672303137.3
        for <linux-unionfs@vger.kernel.org>; Mon, 21 Aug 2023 06:26:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1692624361; x=1693229161;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=52wzPuIeEdK5zNS5iLQWJukq2l/O5/L2dRBEWMU+16g=;
        b=VLaxQX0QIZfQS+htu1H+TRFZ0jFFmMafWVTgPw9akVEB3x3AsnkJRmHEN6cQAPGsCe
         /NsW+YEVftYohHLCqpcTH28lNAtuNdpGroLyWmXIqLRVO4G1ijWATtRDK2vwAmSS16f0
         y4ASqpPn3jEfBBMixc8pKciBUsczGVI0HRXvnCx0Oxittqi7cj/4WwmdaGO+ocm8siY9
         7Ow//b5irlNFi4ZaJdoC/wDcGe7VcnEP0eRJpAoMoBMK5TE+ZQAQB9MfUE1ZljrNnJxZ
         iJ3+gRS3CufrWGQ1LCNxU9N6CNOZp+3blRGxrQakpR0TutKTpG9ST+phN3K6vvSiyets
         Ha2Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1692624361; x=1693229161;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=52wzPuIeEdK5zNS5iLQWJukq2l/O5/L2dRBEWMU+16g=;
        b=E4GuwkARN7VaygvLiYTlMuiulzcWSLXbLmcYBgYWXJwNc5mJaU6w/evW3gZWr7HtaT
         v1AJMPl64S7knOX7EJsMNEiGiMbGze00SQI3MN1s2G3QDo05zpqb3ISxPz1XaJNq6IYi
         Jq0jLsoTzdhNeGuny9xPpDbLaMrDhb9oBefKV5my4ncMxYuz9HAKQix+aLHA4VI69Qbk
         RD9r1H3G8JLgE0gLD49lvJ3N4ei2Tzn567B9n23udG/veojoNa7dm4FVXqk7OGFARA9V
         Ysu/verIEkxu6QPj+8yFH7henxo/b8aBGEYuQy587bdp4ALHeKrP8HempWJ4NhKtBujq
         gITg==
X-Gm-Message-State: AOJu0YyrFw+GXasY3CIputPaA/h3mBP/PzjXbcjwAq6aQO2JIf75BMef
        Hx4IojSsIcQzmFRRhrt4mRFanTb3OmBwT92yr6E=
X-Google-Smtp-Source: AGHT+IFZOeGhuj2reuL8mWRdoVzzSusf0tbT7pVJf898JFj5RM0htiHCcVtix0pnQSvBOvHAFCMalbO2gIkCHmBVsI0=
X-Received: by 2002:a05:6102:1d5:b0:447:4ce7:527d with SMTP id
 s21-20020a05610201d500b004474ce7527dmr2792077vsq.19.1692624361224; Mon, 21
 Aug 2023 06:26:01 -0700 (PDT)
MIME-Version: 1.0
References: <cover.1692270188.git.alexl@redhat.com> <f140fd46c2f61e69630c14a6b3fb8ed5e3c62307.1692270188.git.alexl@redhat.com>
 <CAJfpeguHCVFpcGVWdP5-j+7-+4cqjvd+-40UM=+vL1OFwS7rZA@mail.gmail.com> <CAL7ro1G1uDUhOS0yJdaSKAz-8BkxS++gd29=K7Jr27zZU1wbPQ@mail.gmail.com>
In-Reply-To: <CAL7ro1G1uDUhOS0yJdaSKAz-8BkxS++gd29=K7Jr27zZU1wbPQ@mail.gmail.com>
From:   Amir Goldstein <amir73il@gmail.com>
Date:   Mon, 21 Aug 2023 16:25:50 +0300
Message-ID: <CAOQ4uxgAvkrEo=ZOiaY=+HGzVMsk4UCA+D5RfYdEj2Ubffh27Q@mail.gmail.com>
Subject: Re: [PATCH v2 4/5] ovl: Support creation of whiteout files on overlayfs
To:     Alexander Larsson <alexl@redhat.com>
Cc:     Miklos Szeredi <miklos@szeredi.hu>, linux-unionfs@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <linux-unionfs.vger.kernel.org>
X-Mailing-List: linux-unionfs@vger.kernel.org

On Mon, Aug 21, 2023 at 3:55=E2=80=AFPM Alexander Larsson <alexl@redhat.com=
> wrote:
>
> On Mon, Aug 21, 2023 at 1:00=E2=80=AFPM Miklos Szeredi <miklos@szeredi.hu=
> wrote:
> >
> > On Thu, 17 Aug 2023 at 13:05, Alexander Larsson <alexl@redhat.com> wrot=
e:
> > >
> > > This is needed to properly stack overlay filesystems, I.E, being able
> > > to create a whiteout file on an overlay mount and then use that as
> > > part of the lowerdir in another overlay mount.
> > >
> > > The way this works is that we create a regular whiteout, but set the
> > > `overlay.nowhiteout` xattr on it. Whenever we check if a file is a
> > > whiteout we check this xattr and don't treat it as a whiteout if it i=
s
> > > set. The xattr itself is then stripped and when viewed as part of the
> > > overlayfs mount it looks like a regular whiteout.
> > >
> >
> > I understand the motivation, but don't have good feelings about the
> > implementation.  Like the xattr escaping this should also have the
> > property that when fed to an old kernel version, it shouldn't
> > interpret this object as a whiteout.  Whether it remains hidden like
> > the escaped xattrs or if it shows up as something else is
> > uninteresting.
> >
> > It could just be a zero sized regular file with "overlay.whiteout".
> >
> > But we are also getting to the stage where the number of getxattr
> > queries on lookup could be a performance problem.  Or maybe not.  It
> > would be good to look at this aspect as well when adding xattr queries
> > to lookup.
>
> Wanting to avoid (as much as possible) the reading of more xattrs
> which would affect performance of every regular file was the reason
> for this particular implementation. I will do some more thinking and
> see if I can come up with an alternative approach.

I'd just like to add that, although the cost of getxattr is mostly fs
dependent, from my experience, the cost of several getxattr on one
file are usually amortized in the cost of the first getxattr on that file.

So while it is valuable to avoid any getxattr if possible, avoid an
extra getxattr is often less critical.
Again, this statement may not be accurate for all fs.

Thanks,
Amir.
