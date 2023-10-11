Return-Path: <linux-unionfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1CA85CD6E7B
	for <linux-unionfs@archiver.kernel.org>; Wed, 11 Oct 2023 14:33:16 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232036AbjJKOdP (ORCPT
        <rfc822;linux-unionfs@archiver.kernel.org>);
        Wed, 11 Oct 2023 10:33:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51970 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231506AbjJKOdP (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Wed, 11 Oct 2023 10:33:15 -0400
Received: from mail-ed1-x52d.google.com (mail-ed1-x52d.google.com [IPv6:2a00:1450:4864:20::52d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C86BA90
        for <linux-unionfs@vger.kernel.org>; Wed, 11 Oct 2023 07:33:13 -0700 (PDT)
Received: by mail-ed1-x52d.google.com with SMTP id 4fb4d7f45d1cf-532c81b9adbso12013196a12.1
        for <linux-unionfs@vger.kernel.org>; Wed, 11 Oct 2023 07:33:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=szeredi.hu; s=google; t=1697034792; x=1697639592; darn=vger.kernel.org;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=Sz7UHH1uecQoq4tkp/JuSN+iEeJ6jerMDltqWVjb4Ks=;
        b=edXGY+o8sz8v/w22ZrWSKCcUwCwhPnmSUmijSZsS7a+/QIOlae793Q6ArNR/L0WmTH
         mA23E0NL2eVSPfF4yIkYsDqai9FkpP9xlVeCeUKTkJbmi62MGStZCYxKaxjF9sqhr+5L
         4e6zPKOpK6S2V9LLdm+vs9YPrUXesjTJ+6dfc=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1697034792; x=1697639592;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=Sz7UHH1uecQoq4tkp/JuSN+iEeJ6jerMDltqWVjb4Ks=;
        b=NyqZK/+Y/uYmVWmB7MWe1dzCU78UXsxXm01qUt3jLdGpe8b8wvoHuF/T/3RX8NaWua
         kDW9685VqDf9+5xcBpWh1uXw+3+PR8mLIUWnjo07iZZUPi6GmrjrVpXXAnz+egW40SAu
         jikByYwld3A26QZlPRKK+Uww/JF3mRXszTJVsQljK3yuEtVPRVHV036hdnSpyIDPQziy
         IyQ68mZ9SohgpDawtSr+65tdYboeMi9c+tUk5VyX3Djak4WNUqLFJ20sxFJpH49GEOUF
         SBS+1+mB6P9oT1n+6EfvrACo/G0qmR2Il2X/tTnrRDdvoXmMBthdUSK5GL6IYUKyToHp
         XwWg==
X-Gm-Message-State: AOJu0Yzb1ftM/TiN/P8N+rbUA0BOHU0WUpPcCF9zsETloxulTKRns71G
        47tAmbq9LnhgxXlZR4eToZh97u7BXVmPbTxukNUfFg==
X-Google-Smtp-Source: AGHT+IGWGdTY22d7bAh51A7CoBYxIwmAxqVbo++O+cxKdADm1hEO25ZqT0O/Tx6azKX6ow0irDSHquelVXnRNoJn5f8=
X-Received: by 2002:a17:906:20e:b0:9ad:7e21:5a6d with SMTP id
 14-20020a170906020e00b009ad7e215a6dmr18725964ejd.33.1697034792062; Wed, 11
 Oct 2023 07:33:12 -0700 (PDT)
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
 <CAOQ4uxgBW03c9ZYvKKdD_n1z70fb=+-f6xYLzcZ6AWC3O04cXw@mail.gmail.com> <CAJfpegvngPP1KnM7JF4ofdmSVG0XH_NeOC+B97iJZbCgvfAWFw@mail.gmail.com>
In-Reply-To: <CAJfpegvngPP1KnM7JF4ofdmSVG0XH_NeOC+B97iJZbCgvfAWFw@mail.gmail.com>
From:   Miklos Szeredi <miklos@szeredi.hu>
Date:   Wed, 11 Oct 2023 16:33:00 +0200
Message-ID: <CAJfpegsvvuDLBwzH3fcNCnY4bzttVTd1zB3p5S-eKf3sqJjX6A@mail.gmail.com>
Subject: Re: [regression?] escaping commas in overlayfs mount options
To:     Amir Goldstein <amir73il@gmail.com>
Cc:     Sebastian Wick <sebastian.wick@redhat.com>,
        Ryan Hendrickson <ryan.hendrickson@alum.mit.edu>,
        Christian Brauner <brauner@kernel.org>,
        linux-unionfs@vger.kernel.org, Karel Zak <kzak@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-unionfs.vger.kernel.org>
X-Mailing-List: linux-unionfs@vger.kernel.org

On Wed, 11 Oct 2023 at 15:07, Miklos Szeredi <miklos@szeredi.hu> wrote:

> > > > > > Anyway, let's focus on what you would like best.
> > > > > > If you prefer to just fix the regression, it is doable.
> > > > > > If you prefer the upperdirfd, workdirfd, lowerdirfd API, I think we can
> > > > > > find a volunteer to write it up.
>
> Can't the existing option names be overloaded if a separate cmd
> (FSCONFIG_SET_PATH or FSCONFIG_SET_PATH_EMPTY) is used in fsconfig()?

Looked and there's nothing in the uAPI that would prevent overloading
the existing names.  However the internal fs_parse() API only allows a
single type associated with a name.   That could be changed if we
want.   I think it would make more sense than adding newer names that
are not in sync with the command line usage and existing
documentation.   I can look into that if there's no objection.

Thanks,
Miklos
