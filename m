Return-Path: <linux-unionfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 310C0CDB474
	for <linux-unionfs@archiver.kernel.org>; Mon, 16 Oct 2023 11:57:00 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229848AbjJPL5A (ORCPT
        <rfc822;linux-unionfs@archiver.kernel.org>);
        Mon, 16 Oct 2023 07:57:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45174 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230078AbjJPL47 (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Mon, 16 Oct 2023 07:56:59 -0400
Received: from mail-qv1-xf33.google.com (mail-qv1-xf33.google.com [IPv6:2607:f8b0:4864:20::f33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CA862E6
        for <linux-unionfs@vger.kernel.org>; Mon, 16 Oct 2023 04:56:57 -0700 (PDT)
Received: by mail-qv1-xf33.google.com with SMTP id 6a1803df08f44-66d1a05b816so27056476d6.1
        for <linux-unionfs@vger.kernel.org>; Mon, 16 Oct 2023 04:56:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1697457417; x=1698062217; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=TOOK+M30jcWIxAA4F8uVmG+DM8Gu2fI9sL+cZrOxqoc=;
        b=GI/dqzCATRW3pYFIkw/j9ikLbdjYVWbRBqaDYOona66b8Q+IrewSR8cJ3tXVVJVwRs
         fOQEDVl0HwnBiQcBdAeZBSZpguKHo+nRBBW4TtcdnBdYPGImMdA8IGSZ4kmX1M70LPMB
         tHY84aCLVtauy8JEkmcPoz7rUYSbwVncAAnb5YF5SI6+vPzzj4jcSp9hPQ/mtSCcUiOW
         KwjFytBa0A8O3oSvi4SAhi7YHyStneRXeYv7VNekVXLn1NiGjaXLIPwFTS4VglamtbZa
         aoJceBELvtHDEz8C67XfI0frxYzONJHnm7JXV+HChkJuR6X4mrgvWbjACplp6lZ8EcVE
         d6Aw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1697457417; x=1698062217;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=TOOK+M30jcWIxAA4F8uVmG+DM8Gu2fI9sL+cZrOxqoc=;
        b=kpMTFICkw1uC6ABOqdEzk5q905Sr8gUzaoxXl81z0l7tUKL8hnD+rM3IyR34xLXTw9
         Wrgo/F3trU0mWL1uAhEyqB6x38Gu0aBkCZpu6AFk6AG0b7cWhyA6IbvbzZo6wvrkB69A
         Z0WwpQ3vugLkPvOKcgmrYLWrhq/vNi8UhFDXIgr5VZxzrjVJTJcG4cSBWx5sfK0v+mJG
         ArRAOZEAg0LCbEiJfCU+cAwnK7gyaGcHzIz2Dk/LBAvYFG2oArWa/G+OipQWS9jP3Kts
         ADkX68l5VDac1+YpY4UkdQDEqdfR3s8FNsgzyhnrstTCVKXriTJQr4C8bqASLEZr/ZMa
         uSLw==
X-Gm-Message-State: AOJu0Yx4WRYjk84pK+7rOXC/Ip/uM75sFhtC95cME9WvG3G/sfdn25EI
        XwsZqJvDVPMM8ZoHbmZn0bQXKEDs/MyGMg8GohdfANCgAaE=
X-Google-Smtp-Source: AGHT+IFRPknFlIQ2LnrulOijCw7tyhZks2dO3RQoHlQJh5gmS5FljYZ4O4Q8bbq1nU1xQEfmwLl/SVeUyHEQ+mN+Yo8=
X-Received: by 2002:a0c:b3da:0:b0:659:e547:ca72 with SMTP id
 b26-20020a0cb3da000000b00659e547ca72mr32460211qvf.40.1697457416921; Mon, 16
 Oct 2023 04:56:56 -0700 (PDT)
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
Date:   Mon, 16 Oct 2023 14:56:45 +0300
Message-ID: <CAOQ4uxicurA4nNeDkUarkTMujtsaOvwQ8HEMpz97N2SejBRx9Q@mail.gmail.com>
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
> I did some testing and it turns out libmount still regresses on
> 6.6-rc6 for the escaped comma case.  The reason is that libmount
> doesn't understand escaping of commas, hence the '-oupper=3Dupper\,1'
> will result in two fsconfig() calls: 'upper=3Dupper\'  and '1'.  Prior
> to 6.5 these were nicely reconstructed into the original
> 'upper=3Dupper\,1' by  legacy_parse_param().
>

Technically, I think this is a libmount regression, not a kernel regression=
.
Since libmount 2.39, libmount will split the commas differently than
overlayfs always did.

If a user using libmount 2.39 upgrades to kernel 6.5 and reports
a regression, we can tell that user to opt-out of new mount api via
LIBMOUNT_FORCE_MOUNT2=3Dnever.

> The same reconstructing could be done by ovl_parse_param() when
> detecting an option ending with a backslash.  But I guess we only need
> to do this if there's a report of such a regression.
>

I really hope we will not need to do that.

> But this raises the question: shouldn't we turn off comma unescaping,
> since it's useless?
>

Not sure I understand what this means.

> Going further, unescaping in general for upperdir and workdir could be
> turned off (lowerdir+ and datadir+ are naturally escape free), leaving
> only unescaping in lowerdir?
>
> Yes, that also has the potential to regress something out there.  But
> it also has the potential to clean up the interface further if no such
> regression happens.   And I don't think we need to hurry, the 6.7
> cycle would be good for experimenting.
>

I am ok with doing this experiment in 6.7.

I saw that your patch converted upperdir/workdir to path type
without unescaping.  Don't we need to keep the support for
string type params for ->parse_monolothic()?
Or is this the reason for the change in fs_lookup_param()?

Anyway, please make sure to split the patch that changes
upperdir/workdir params to be without unescaping, so if we
get regression reports in the future, it will be easy to revert
this change independently from lowerdir+,datadir+.

BTW, can lowerdir+,datadir+ be provided to mount(8)
via command line? or does that require a libmount change?
If they work with mount(8), I can write up an fstests.

FYI, I rebased overlayfs-next over 6.6-rc6.

Thanks,
Amir.
