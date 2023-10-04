Return-Path: <linux-unionfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 55D3CE8FDDD
	for <linux-unionfs@archiver.kernel.org>; Wed,  4 Oct 2023 09:03:19 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232806AbjJDJDV (ORCPT
        <rfc822;linux-unionfs@archiver.kernel.org>);
        Wed, 4 Oct 2023 05:03:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35456 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232554AbjJDJDU (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Wed, 4 Oct 2023 05:03:20 -0400
Received: from mail-ua1-x929.google.com (mail-ua1-x929.google.com [IPv6:2607:f8b0:4864:20::929])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 39DFC98
        for <linux-unionfs@vger.kernel.org>; Wed,  4 Oct 2023 02:03:17 -0700 (PDT)
Received: by mail-ua1-x929.google.com with SMTP id a1e0cc1a2514c-7b07c3eaf9bso861147241.3
        for <linux-unionfs@vger.kernel.org>; Wed, 04 Oct 2023 02:03:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1696410196; x=1697014996; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=o5yYDcNH0cgfpVAhech09O6waoy/vbfm8XaWoummBWk=;
        b=S2PD6RrcNJ0/80mGU5CMz6FAQ0I38KfiX5ixStND6wzi5TfalOaWCyJStrl7ygXkGF
         vCAu5zpy3cWUt3KC9gUEklDjTcT0AtPSATQDdnv+sgdojsQkUmmkVYePogRcp6lqHXtr
         6Q1svxXph9Aw9OHS+770/MIj3MTzZOPVtKPRGP/gJwgQakoIu9Z5z8VNjcwtbK0WJHte
         veqO2yHWajpRSw5tY5rcz4L3sacMoDhsuVqPx7evvyWxeSrB0qjl/wUndu+PDHKRRNoD
         nUGRr1z2/M/S8uxiIPpsXsWbNxPMEQk966A/KEtX9FKWg123SoGcciTBWIRSq2l/Ihg0
         y3Uw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1696410196; x=1697014996;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=o5yYDcNH0cgfpVAhech09O6waoy/vbfm8XaWoummBWk=;
        b=IExWTCU9CZ/TPF2XX6eoqnoANFd3ftdfAwWwFwIzaUmsWtDGXU/qUoOVfQES3RI+NE
         iH0TCJbR9d1hD1VUpER/HdnGHfGyhVyHNCVtngTFGLrpqaEIQU9egrNMkGQ7cpETbYBu
         8wqbWNJaNKMENfp+qI/JApdDf1ON8BATEsgXvyDGAOZRxWmiw9d5LBY7FPoBfUH4wa4Y
         YNhNm13OvzGTk3wWd2VmxbRxAAJbMT7HeIIiHR+nqZj0551jYqZ3t2InyzgOBNnRO0p0
         WdVTw3ZLD4n6AOlN/HBeUYChUg8EnSA3E/0QzRCwJJxkLkLV7rgGd2nV5PUX30WbcIuE
         TSMg==
X-Gm-Message-State: AOJu0YyvqJNG8tIbiguwSjp+9UxtBHNxtqVJvZg7zSMtmdolS11LNBTo
        SCJAvKjrSoPisE6mz9hWTwrVTbqxFYQuugUD6dM=
X-Google-Smtp-Source: AGHT+IEg/b+m1iXxBawjAtYwVHPCQLarkZEmS4vEKqOL3j29hdnqz/bhnQL2iBrY8tMo17pUMUlBjk36bNdz8OMtpn0=
X-Received: by 2002:a67:fe58:0:b0:44d:4c28:55ca with SMTP id
 m24-20020a67fe58000000b0044d4c2855camr1577735vsr.16.1696410196211; Wed, 04
 Oct 2023 02:03:16 -0700 (PDT)
MIME-Version: 1.0
References: <8da307fb-9318-cf78-8a27-ba5c5a0aef6d@alum.mit.edu>
 <CAOQ4uxhQhzv_LUW89m_BmKf+NjE+XDyY9XtLAt+SWG03M6LmYQ@mail.gmail.com>
 <80c265ab-1871-211e-2787-fefbf25a892a@alum.mit.edu> <CAOQ4uxheu-LXAh3nAcnufwOR=+9xPVeHdi_=dZVx6qj7ZwRGpA@mail.gmail.com>
 <2ee75e4f-0585-d603-80c9-5d0af36eb629@alum.mit.edu>
In-Reply-To: <2ee75e4f-0585-d603-80c9-5d0af36eb629@alum.mit.edu>
From:   Amir Goldstein <amir73il@gmail.com>
Date:   Wed, 4 Oct 2023 12:03:05 +0300
Message-ID: <CAOQ4uxhh4swD3LhLAT22mdeUfyNjezBFATnO1xdDcewTpuZOWg@mail.gmail.com>
Subject: Re: [regression?] escaping commas in overlayfs mount options
To:     Ryan Hendrickson <ryan.hendrickson@alum.mit.edu>
Cc:     Christian Brauner <brauner@kernel.org>,
        Miklos Szeredi <miklos@szeredi.hu>,
        linux-unionfs@vger.kernel.org, Karel Zak <kzak@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <linux-unionfs.vger.kernel.org>
X-Mailing-List: linux-unionfs@vger.kernel.org

On Tue, Oct 3, 2023 at 10:07=E2=80=AFPM Ryan Hendrickson
<ryan.hendrickson@alum.mit.edu> wrote:
>
> At 2023-10-03 12:50+0300, Amir Goldstein <amir73il@gmail.com> sent:
>
> > What you can do is use the new mount API for kernel >=3D6.5
> > and provide the parameters one by one, e.g.:
> >
> > fsconfig(fs_fd, FSCONFIG_SET_STRING, "lowerdir", "/tmp/test-lower,", 0)=
;
> >
> > See example in commit message of
> > b36a5780cb44 ("ovl: modify layer parameter parsing")
>
> That would be great, but fsconfig doesn't appear to be documented. It's a
> new syscall? What kernel version was it introduced in, and how am I
> supposed to support older kernels?
>

For old kernel would need to use the old mount API.

I don't know about the status of man pages for new mount API,
but you should be able to figure it out from the examples and from
libmount code if you want to try.

> The second part of your message suggests that the answer to older kernel
> support is libmount:
>
> > The mount tool and libmount in util-linux 2.39 support the new mount AP=
I
> > [1]. They already auto detect and fallback to the old mount API, so you
> > wouldn't need to implement per kernel version logic.
>
> Again sounds great, but in the libmount documentation I've been looking a=
t
> [1], there doesn't seem to be a function for setting options individually=
.
> mnt_context_set_options accepts a comma-delimited string, and
> mnt_optstr_set_option modifies a comma-delimited string. What am I
> missing?

The parsing of the comma-delimited string, if kernel and fs support new
mount API is supposed to be implemented by userspace library.

So the question of whether \, should be escaped in moved from the
kernel to libmount.

I don't know what libmount does - I did not check.
Deferring the question to Karl.

Thanks,
Amir.
