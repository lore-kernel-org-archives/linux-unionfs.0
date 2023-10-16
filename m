Return-Path: <linux-unionfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4355ACDB465
	for <linux-unionfs@archiver.kernel.org>; Mon, 16 Oct 2023 09:27:26 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232831AbjJPJ10 (ORCPT
        <rfc822;linux-unionfs@archiver.kernel.org>);
        Mon, 16 Oct 2023 05:27:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38418 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233162AbjJPJ1Y (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Mon, 16 Oct 2023 05:27:24 -0400
Received: from mail-ej1-x62e.google.com (mail-ej1-x62e.google.com [IPv6:2a00:1450:4864:20::62e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6F308106
        for <linux-unionfs@vger.kernel.org>; Mon, 16 Oct 2023 02:27:21 -0700 (PDT)
Received: by mail-ej1-x62e.google.com with SMTP id a640c23a62f3a-9be7e3fa1daso292581766b.3
        for <linux-unionfs@vger.kernel.org>; Mon, 16 Oct 2023 02:27:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=szeredi.hu; s=google; t=1697448439; x=1698053239; darn=vger.kernel.org;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=0LlgRKBswuZvFcF1AqdfqHiDuR6Wvnt8p+dEhEdUnlg=;
        b=D7N4HpjiJTZarQ3+2oXnNRjaF/9mdDzCzDWn9zlIKN/P5RhaDMN6ywFEEdMWVhsl3q
         rAshT4A1dfdp5XU3bQwRkzpgCTUe3UAwO4i4muLzDoiO/6MIwEuK1+tmP9D7TnUElgMP
         2wb1evbSsDpv0V1xRDXaXLTrElAhC7Jfp7nOE=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1697448439; x=1698053239;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=0LlgRKBswuZvFcF1AqdfqHiDuR6Wvnt8p+dEhEdUnlg=;
        b=E5CYo0IQflAwcrcmhlihh7dumIIWl7hjiLAj8kFKWvJ0Zou+G1dAJ7yB3xYRCjocwZ
         ZxzT1b6DvIvK2diygquVehT8JbT16t+2IFAQLHuUpYMf8i8Ky9ZO0ps2pOnsCfAM5IL0
         LJgsV45CY/jPNJpyZkwB+erYBWOjnzr8Jvsoj9x4ToTsVgC7ZN5t85FZKgTwbV+h+HxE
         KXdeDl6s6lo5vNUDOLxr+xv5na3tR+NNMqvZ1JmFPWne9roVXIIDDBysMmho7ciJ4Y+t
         N04qd/hsX9Mv4LDkJ7jz1sGgzA9u8D5m1WPKd08X/wEJf9HF0H06Tv245KbaXsdD304z
         3Vig==
X-Gm-Message-State: AOJu0YwyA6GfRUjw/1FjyfgBdNaD5FfXvvoMkDKGpAWzMSaxOX5GFQYJ
        P2BGcW8VrM5bR0BEEdU6NbKavFOYNR1p+DrdqcvuIg==
X-Google-Smtp-Source: AGHT+IEzYmHk4GjDy4uHLGT7UDnOUysgXpkfKve/u3B5pJTxnUuRwdGiwy5p6/g5ELCTz7QtOnZkX7lc/r0AI6Dh/5g=
X-Received: by 2002:a17:907:7f0b:b0:9bf:5696:9153 with SMTP id
 qf11-20020a1709077f0b00b009bf56969153mr4731858ejc.57.1697448439533; Mon, 16
 Oct 2023 02:27:19 -0700 (PDT)
MIME-Version: 1.0
References: <20231011164613.1766616-1-amir73il@gmail.com> <CAJfpegvgePB-==T=yTU1R+JVxKYsU_Bm18vWdW5hXWLGw=47PQ@mail.gmail.com>
 <CAOQ4uxiE89q62JHnxwm14FBShPORmX_h0EyDCBN-VKv6aTf5BQ@mail.gmail.com>
 <CAJfpegsexQsNVMOZw+0byzj2wTbU_Tg6p0ATgwBAwmTaDmNbLA@mail.gmail.com>
 <CAOQ4uxjYGckJA=raAW8wyVmDaK-FXfFDRS0RCpZYcLucPqMi3w@mail.gmail.com>
 <CAJfpegt5COamxm-ZN+A9ub_Te-CPM0xMd-Rrzwv7OHBkvHS3yg@mail.gmail.com>
 <CAOQ4uxic3NDtEt9EiP+RYKGEB=6b_PCaudQA=cXK6mWY4Cmeqg@mail.gmail.com>
 <CAJfpegsr3A4YgF2YBevWa6n3=AcP7hNndG6EPMu3ncvV-AM71A@mail.gmail.com>
 <CAJfpegt7VC94KkRtb1dfHG8+4OzwPBLYqhtc8=QFUxpFJE+=RQ@mail.gmail.com> <CAOQ4uxhg+0_S1tQv9vUpv7Yu-VRLv7U7cnxLmxig+9LmS_qW+A@mail.gmail.com>
In-Reply-To: <CAOQ4uxhg+0_S1tQv9vUpv7Yu-VRLv7U7cnxLmxig+9LmS_qW+A@mail.gmail.com>
From:   Miklos Szeredi <miklos@szeredi.hu>
Date:   Mon, 16 Oct 2023 11:27:07 +0200
Message-ID: <CAJfpegu6cESPijvO51zjVeXA=wcw7nMaNkkNJ7+my07wq8k9FA@mail.gmail.com>
Subject: Re: [PATCH] ovl: fix regression in showing lowerdir mount option
To:     Amir Goldstein <amir73il@gmail.com>
Cc:     Christian Brauner <brauner@kernel.org>,
        linux-unionfs@vger.kernel.org, Karel Zak <kzak@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-unionfs.vger.kernel.org>
X-Mailing-List: linux-unionfs@vger.kernel.org

On Sun, 15 Oct 2023 at 08:58, Amir Goldstein <amir73il@gmail.com> wrote:

> +       for (nr = 0; nr < nr_added_lower; nr++, lowerdirs++) {
> +               if (nr < nr_merged_lower)
> +                       seq_show_option(m, "lowerdir+", *lowerdirs);
> +               else
> +                       seq_show_option(m, "datadir+", *lowerdirs);

Good.

I did some testing and it turns out libmount still regresses on
6.6-rc6 for the escaped comma case.  The reason is that libmount
doesn't understand escaping of commas, hence the '-oupper=upper\,1'
will result in two fsconfig() calls: 'upper=upper\'  and '1'.  Prior
to 6.5 these were nicely reconstructed into the original
'upper=upper\,1' by  legacy_parse_param().

The same reconstructing could be done by ovl_parse_param() when
detecting an option ending with a backslash.  But I guess we only need
to do this if there's a report of such a regression.

But this raises the question: shouldn't we turn off comma unescaping,
since it's useless?

Going further, unescaping in general for upperdir and workdir could be
turned off (lowerdir+ and datadir+ are naturally escape free), leaving
only unescaping in lowerdir?

Yes, that also has the potential to regress something out there.  But
it also has the potential to clean up the interface further if no such
regression happens.   And I don't think we need to hurry, the 6.7
cycle would be good for experimenting.

Thanks,
Miklos
