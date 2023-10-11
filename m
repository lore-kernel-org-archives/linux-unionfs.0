Return-Path: <linux-unionfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 86CCCCDB468
	for <linux-unionfs@archiver.kernel.org>; Wed, 11 Oct 2023 16:37:40 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232146AbjJKQhk (ORCPT
        <rfc822;linux-unionfs@archiver.kernel.org>);
        Wed, 11 Oct 2023 12:37:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60766 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235079AbjJKQhj (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Wed, 11 Oct 2023 12:37:39 -0400
Received: from mail-qt1-x82d.google.com (mail-qt1-x82d.google.com [IPv6:2607:f8b0:4864:20::82d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D923DB7
        for <linux-unionfs@vger.kernel.org>; Wed, 11 Oct 2023 09:37:36 -0700 (PDT)
Received: by mail-qt1-x82d.google.com with SMTP id d75a77b69052e-41959feaae2so444621cf.0
        for <linux-unionfs@vger.kernel.org>; Wed, 11 Oct 2023 09:37:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1697042256; x=1697647056; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=K5EVrKXIyPhQT+KkM6yKZW0vnLVzzOs8G6AYv8bPDqw=;
        b=eQhFm+mshaD7Jl8U17nkZuCPNbttl9bW8owmTjOR60XwEskh37H80P6fpwhYBW2b6Z
         +ukJkzB70XXHXLvBZtBBn6Qcc952DxSzIMH0p9+TuUVp/fMtwQZhDfGO/pJJvY9QupP+
         SQKa3hQ77SpFlCKj02xYFOAcJ9IvVO5GlOKtohNd8x5iZ8fuvRu9pcTxuGCuYwyEiWte
         CpA27KyOFEqMwcYq5ek7SXq/kht+muMBONiXzXcB3XWDlDs5X9KCTgqX6MYQzbeWGKQi
         Tb9xCZ1MYkrES9GUfluHbwDb3m8VzmMDNWLdzW00rQOllBqt53zAdQJOVVE979dWnVWO
         knfw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1697042256; x=1697647056;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=K5EVrKXIyPhQT+KkM6yKZW0vnLVzzOs8G6AYv8bPDqw=;
        b=eIyV5UphPCvR5kHzoXMdT5ZxeNGM3PwsCCRdMF3BSsrtun1XsbToCs1Svv7i2fSLXy
         gPq2KN4nCSswYgx9yW0aFlZHAKhAldoy/WQV4c0JCXE6ZRMo8wpLpq///fp/cTNJZfaw
         QILTNkbt6W7XKrQep/JZoICNIDKBwiIlpLf4K3ZFOoeLa5+QXGCYev2eKtagCUhEc8To
         7DOj6yANz5Y0uiWgbY+B1I/WEe/7ahFCf1ggLog8dVRltyBGe4BZiabxkiddwNXUBT8t
         CfDrM4dFI5CLwFfj1V5NGyIFQl2XVBwlW2sCb/q7F9XtmoZgqaTOzHdfauKBw/RowH4T
         zoDw==
X-Gm-Message-State: AOJu0Yyby0kXoKfS/r0tFkxjkKKu0tgPC/fFcDn9toGoiF8json5i7ur
        xVhIH7+bwT8Gn1HynSTFyE4fZcl/mZLoUNr51PY=
X-Google-Smtp-Source: AGHT+IGu4coUwsJ0b6MxejRlyr9ONI8QJwdacWaXOz50NHemFnfomTw77WKz6asMkDgpTh8sWLc68z4vTdW+NcE/BHQ=
X-Received: by 2002:ac8:5a41:0:b0:406:98be:bda2 with SMTP id
 o1-20020ac85a41000000b0040698bebda2mr26086347qta.59.1697042255822; Wed, 11
 Oct 2023 09:37:35 -0700 (PDT)
MIME-Version: 1.0
References: <8da307fb-9318-cf78-8a27-ba5c5a0aef6d@alum.mit.edu>
 <CAOQ4uxhQhzv_LUW89m_BmKf+NjE+XDyY9XtLAt+SWG03M6LmYQ@mail.gmail.com>
 <20231006130259.GA438068@toolbox> <CAOQ4uxg84M7H0EtTLWAsNkHaaLzVVXQ=-fCVFVr8a6MGSQC=vg@mail.gmail.com>
 <5d708a45-43c9-b026-6619-7c377ee02793@alum.mit.edu> <CAOQ4uxgNakTHi0dHC1v51TCU_aAKTOrJ4zFv=BzfoKNMsCwZEg@mail.gmail.com>
 <CAJfpegsFNjMX+Lz8uX-6=fDa59qYJQjnUnJpzKiTxuBziC7pxQ@mail.gmail.com>
 <CAOQ4uxgNr=ZbHTB8TcMfWLceBoQD0a2u4Bzo3-Hr3QZTRoBjLQ@mail.gmail.com>
 <CA+hFU4w78Ze-wKPg9fsdR6zpL5VUwp8jNqCcHGmOFJ--GAGKJA@mail.gmail.com>
 <CAOQ4uxhSTJaZggq-z_3oPbXh48n88E1QjfNTr5HO1ZuqyrF+ew@mail.gmail.com>
 <CA+hFU4w8mdo1DrWPU3MNM=YBXE9aVD2yFOe_zXXq1U51B0h7kw@mail.gmail.com>
 <CAOQ4uxjhpKU=YfG7KjAYtyQNFzVSpwpYEvPvbMZL_fXssqk1Dg@mail.gmail.com>
 <CAJfpegt3AasPxXt-bX35LB_xP0YXvvETMX98FKJJFK5RX1Q78w@mail.gmail.com>
 <CAOQ4uxgc2YegLuZKg4WLnOCn8-e-hxHJh7LD4=w-x--Fg7fdpw@mail.gmail.com>
 <CAJfpegvLZfYtYo2rbvJOmhbHGE5hoWaoGeb5r4hiTMQOpv0GbQ@mail.gmail.com>
 <CAOQ4uxgBW03c9ZYvKKdD_n1z70fb=+-f6xYLzcZ6AWC3O04cXw@mail.gmail.com>
 <CAJfpegvngPP1KnM7JF4ofdmSVG0XH_NeOC+B97iJZbCgvfAWFw@mail.gmail.com> <CAJfpegsvvuDLBwzH3fcNCnY4bzttVTd1zB3p5S-eKf3sqJjX6A@mail.gmail.com>
In-Reply-To: <CAJfpegsvvuDLBwzH3fcNCnY4bzttVTd1zB3p5S-eKf3sqJjX6A@mail.gmail.com>
From:   Amir Goldstein <amir73il@gmail.com>
Date:   Wed, 11 Oct 2023 19:37:24 +0300
Message-ID: <CAOQ4uxh0xqktSyqm8kFXanVfVPJq4yPZgVOPN7+LgOVnjnwrLQ@mail.gmail.com>
Subject: Re: [regression?] escaping commas in overlayfs mount options
To:     Miklos Szeredi <miklos@szeredi.hu>
Cc:     Sebastian Wick <sebastian.wick@redhat.com>,
        Ryan Hendrickson <ryan.hendrickson@alum.mit.edu>,
        Christian Brauner <brauner@kernel.org>,
        linux-unionfs@vger.kernel.org, Karel Zak <kzak@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <linux-unionfs.vger.kernel.org>
X-Mailing-List: linux-unionfs@vger.kernel.org

On Wed, Oct 11, 2023 at 5:33=E2=80=AFPM Miklos Szeredi <miklos@szeredi.hu> =
wrote:
>
> On Wed, 11 Oct 2023 at 15:07, Miklos Szeredi <miklos@szeredi.hu> wrote:
>
> > > > > > > Anyway, let's focus on what you would like best.
> > > > > > > If you prefer to just fix the regression, it is doable.
> > > > > > > If you prefer the upperdirfd, workdirfd, lowerdirfd API, I th=
ink we can
> > > > > > > find a volunteer to write it up.
> >
> > Can't the existing option names be overloaded if a separate cmd
> > (FSCONFIG_SET_PATH or FSCONFIG_SET_PATH_EMPTY) is used in fsconfig()?
>
> Looked and there's nothing in the uAPI that would prevent overloading
> the existing names.  However the internal fs_parse() API only allows a
> single type associated with a name.   That could be changed if we
> want.   I think it would make more sense than adding newer names that
> are not in sync with the command line usage and existing
> documentation.   I can look into that if there's no objection.
>

Works for me.

FYI, I pushed the lowerdir escaping regression fix to ovl-fixes.

Thanks,
Amir.
