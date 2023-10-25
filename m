Return-Path: <linux-unionfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4AD24C25B70
	for <linux-unionfs@archiver.kernel.org>; Wed, 25 Oct 2023 04:40:43 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229587AbjJYEkm (ORCPT
        <rfc822;linux-unionfs@archiver.kernel.org>);
        Wed, 25 Oct 2023 00:40:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44850 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229456AbjJYEkm (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Wed, 25 Oct 2023 00:40:42 -0400
Received: from mail-qv1-xf2e.google.com (mail-qv1-xf2e.google.com [IPv6:2607:f8b0:4864:20::f2e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D017691
        for <linux-unionfs@vger.kernel.org>; Tue, 24 Oct 2023 21:40:39 -0700 (PDT)
Received: by mail-qv1-xf2e.google.com with SMTP id 6a1803df08f44-66d332f23e4so32186426d6.0
        for <linux-unionfs@vger.kernel.org>; Tue, 24 Oct 2023 21:40:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1698208839; x=1698813639; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=wj6LG/2Q6fXUj0PW8XyQLAsQ6l3lnRvNd7+G90TCldE=;
        b=jijfbamW03x64E6KvOsorgLMWOiye7l8oZKsD6AYxkMVRZMAqjtqUKn278efyL0erN
         84PBalvM9aAkAdjtYQZrXZ/3zdjGCDB8R9iyNyY3jrz3+gMTjqGZZw+8XIAo8aOmEY7C
         PNVwVZwJ8lB66CzYQohDJPiuenjOkDsyLCMH/1gBTFp7Nq3C3yNlVTB0zIvciL/oybqy
         0PS7v3dTFz5XHqsPo9OisgJptnB+Px0uwVvOq+WMipwo2x4F6hQRrB+2ximABOV7fHN0
         3xwHucZqid2QEJqxugU+eE2kte6+jlQg9xgmOgP3P78nTixI1V8wVY4zGVdoMWYSC5cx
         sEzg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1698208839; x=1698813639;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=wj6LG/2Q6fXUj0PW8XyQLAsQ6l3lnRvNd7+G90TCldE=;
        b=FpV4r16M20/4r/wvpskFpkO0g+Cgj+Pb1AhSJEhDmtn+5I31Lq1ZvBd88nhHpwvk83
         n1x05JUI1nulfybhIG7H2fhWqcM8BcPeQBTniIHuNJCVGyQoQDJT6+W2dKVzFMR0B2tI
         hrn8n5ZZjhBgwCDLusYBtGXpOLoaqpaEyIeVPLQs0z1K4TSSj5WiyO5bjwcPzk46DzVS
         BOc2/oTztHRsCqsiw4yY3fbkRkQz1OXlaHcXwoyrHzR3Fb9QEK1ZAxQqpakU6vZqGaMv
         v5+/wD0+sR7e9BYl3tRDSDTIj8FtjbDCxTUj7czW2atYYeM3luIjUF3cxOjGivfosCJI
         YDEw==
X-Gm-Message-State: AOJu0Yy+KyhkcAAeksBS+dv9lPqdVEIhXLqlxl1DkgXB32XlOhpsP1GG
        9ufle7QkIlyXIpIO3ib2GCNWlrIoaTzYXXnZjf0=
X-Google-Smtp-Source: AGHT+IGR46v79WeKYTkgeo1VXTkseQ39OhC9xtdYD7JDZcqbDFVfhpBypVjim+0OggX/KG8AuoQtWS6aRmNPb6X1g9E=
X-Received: by 2002:a05:6214:1c0f:b0:66d:50a8:2439 with SMTP id
 u15-20020a0562141c0f00b0066d50a82439mr19010027qvc.23.1698208838842; Tue, 24
 Oct 2023 21:40:38 -0700 (PDT)
MIME-Version: 1.0
References: <20231011164613.1766616-1-amir73il@gmail.com> <CAJfpegvgePB-==T=yTU1R+JVxKYsU_Bm18vWdW5hXWLGw=47PQ@mail.gmail.com>
 <CAOQ4uxiE89q62JHnxwm14FBShPORmX_h0EyDCBN-VKv6aTf5BQ@mail.gmail.com>
 <CAJfpegsexQsNVMOZw+0byzj2wTbU_Tg6p0ATgwBAwmTaDmNbLA@mail.gmail.com>
 <CAOQ4uxjYGckJA=raAW8wyVmDaK-FXfFDRS0RCpZYcLucPqMi3w@mail.gmail.com>
 <CAJfpegt5COamxm-ZN+A9ub_Te-CPM0xMd-Rrzwv7OHBkvHS3yg@mail.gmail.com>
 <CAOQ4uxic3NDtEt9EiP+RYKGEB=6b_PCaudQA=cXK6mWY4Cmeqg@mail.gmail.com>
 <CAJfpegsr3A4YgF2YBevWa6n3=AcP7hNndG6EPMu3ncvV-AM71A@mail.gmail.com>
 <CAJfpegt7VC94KkRtb1dfHG8+4OzwPBLYqhtc8=QFUxpFJE+=RQ@mail.gmail.com>
 <CAOQ4uxhg+0_S1tQv9vUpv7Yu-VRLv7U7cnxLmxig+9LmS_qW+A@mail.gmail.com> <CAJfpegu6cESPijvO51zjVeXA=wcw7nMaNkkNJ7+my07wq8k9FA@mail.gmail.com>
In-Reply-To: <CAJfpegu6cESPijvO51zjVeXA=wcw7nMaNkkNJ7+my07wq8k9FA@mail.gmail.com>
From:   Amir Goldstein <amir73il@gmail.com>
Date:   Wed, 25 Oct 2023 07:40:27 +0300
Message-ID: <CAOQ4uxghGb-J6LSv0HNMkDg5rKCGrLK+0_LyEQ59F=XdvizVug@mail.gmail.com>
Subject: Re: [PATCH] ovl: fix regression in showing lowerdir mount option
To:     Miklos Szeredi <miklos@szeredi.hu>
Cc:     Christian Brauner <brauner@kernel.org>,
        linux-unionfs@vger.kernel.org, Karel Zak <kzak@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <linux-unionfs.vger.kernel.org>
X-Mailing-List: linux-unionfs@vger.kernel.org

On Mon, Oct 16, 2023 at 12:27=E2=80=AFPM Miklos Szeredi <miklos@szeredi.hu>=
 wrote:
>
> On Sun, 15 Oct 2023 at 08:58, Amir Goldstein <amir73il@gmail.com> wrote:
>
> > +       for (nr =3D 0; nr < nr_added_lower; nr++, lowerdirs++) {
> > +               if (nr < nr_merged_lower)
> > +                       seq_show_option(m, "lowerdir+", *lowerdirs);
> > +               else
> > +                       seq_show_option(m, "datadir+", *lowerdirs);
>
> Good.
>

And if we are going to show lowerdir+/datadir+ in a comma separated
string, we might as well also support them with FSCONFIG_SET_STRING
as long as they don't need escaping.

I think this may even be more important than supporting path params
just to restore the feature that was retroactively disabled in 6.5.y.
We can later add FSCONFIG_SET_PATH support for all those params.

I can take on writing the string params patch based on your POC,
including the fstests, which are quite simple to do in bash for string para=
ms.

Thanks,
Amir.
