Return-Path: <linux-unionfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9970DCDB46E
	for <linux-unionfs@archiver.kernel.org>; Thu, 12 Oct 2023 09:27:54 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235581AbjJLJ1y (ORCPT
        <rfc822;linux-unionfs@archiver.kernel.org>);
        Thu, 12 Oct 2023 05:27:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45874 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235582AbjJLJ1l (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Thu, 12 Oct 2023 05:27:41 -0400
Received: from mail-ua1-x932.google.com (mail-ua1-x932.google.com [IPv6:2607:f8b0:4864:20::932])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 057C2BB
        for <linux-unionfs@vger.kernel.org>; Thu, 12 Oct 2023 02:27:39 -0700 (PDT)
Received: by mail-ua1-x932.google.com with SMTP id a1e0cc1a2514c-7b605706bb0so343262241.3
        for <linux-unionfs@vger.kernel.org>; Thu, 12 Oct 2023 02:27:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1697102858; x=1697707658; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Bx+dkGwUwSG6kjrWMk8k1md46OdqDNGbiQQ05AWi0ls=;
        b=N6VszTorMEj/Z5DDVELRGR6U/a+/YivNYor4z20htQjU8a9Klbm8aRXGmrXfqAL63T
         bbwDrsrq7ifmVqqnYT6eUdPZ2gT/79pBAYUQF6Y61gvY4+9OHmYrvTVzsaEpHWT/9F7P
         2K4eGJol3Davr8/7ceXcdyQnT4GEzh6ZyRUZjaNDco8cxh+vw/+BCnWr2TWcIs+dEx3E
         LVNAhXrzMhrUWjMvabcVAkhS+3/H3dQwtFQfsHV9iCb5MvYcJD7k57FdbZESqMj800Kj
         CsxJF7wYUP9Zeu2Ihm2UDe0z8Bgozm5H09xLuOVYxXjDlTDKdLbKUkgy4i3PoYJpUmOI
         nSLQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1697102858; x=1697707658;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=Bx+dkGwUwSG6kjrWMk8k1md46OdqDNGbiQQ05AWi0ls=;
        b=V/w0lwG+AZmlzO+rQb9K9vaANhR+6bSBNEn5bMLHsG9aSLOSUaVIgYJ6FO4dR4Qtox
         JilLPchvrIJAF1ZhY5C8JE1pqwiG/bVx3abrlbqcLiknMekA9wMiwdtcRY03wpfFE04d
         o7r9SqtpAhcF6aaxZh2ncsL1mF1oBgc8j6mrzJbpIv66pKTTlzM7472n7XbWtL/Jhn/x
         G3qDHNAmxSN6n2VkRs83luaR0UEkoJ9phzJ7wU397kuwgygMn7IuFD/azLayeQG/0tjN
         h3K4vxdDJhJSP0nZ+wujv2rf/1VgoJBu89zk7FfGLuqoRwn82DzvyoD8jKPAEDSQeXQ9
         MnYA==
X-Gm-Message-State: AOJu0YyYtUXlt4a52GEFUTwURbwm2g/yLgvr8NqwMis9+TQK7x3HO20J
        gFhjLckWvecBKtLOvdhVBYDl3XQsDQWM4jt6PRg=
X-Google-Smtp-Source: AGHT+IFlJtTstSbydOHwylbNepl9sTT5rwGKt9POOJ8IpmggNY2uqurFNTD7lD/+rIh8qlhp1hmN5h2cC6GtsHjKJvw=
X-Received: by 2002:a05:6102:7a3:b0:452:6178:642c with SMTP id
 x3-20020a05610207a300b004526178642cmr23072256vsg.1.1697102857583; Thu, 12 Oct
 2023 02:27:37 -0700 (PDT)
MIME-Version: 1.0
References: <CAOQ4uxgNr=ZbHTB8TcMfWLceBoQD0a2u4Bzo3-Hr3QZTRoBjLQ@mail.gmail.com>
 <CA+hFU4w78Ze-wKPg9fsdR6zpL5VUwp8jNqCcHGmOFJ--GAGKJA@mail.gmail.com>
 <CAOQ4uxhSTJaZggq-z_3oPbXh48n88E1QjfNTr5HO1ZuqyrF+ew@mail.gmail.com>
 <CA+hFU4w8mdo1DrWPU3MNM=YBXE9aVD2yFOe_zXXq1U51B0h7kw@mail.gmail.com>
 <CAOQ4uxjhpKU=YfG7KjAYtyQNFzVSpwpYEvPvbMZL_fXssqk1Dg@mail.gmail.com>
 <CAJfpegt3AasPxXt-bX35LB_xP0YXvvETMX98FKJJFK5RX1Q78w@mail.gmail.com>
 <CAOQ4uxgc2YegLuZKg4WLnOCn8-e-hxHJh7LD4=w-x--Fg7fdpw@mail.gmail.com>
 <CAJfpegvLZfYtYo2rbvJOmhbHGE5hoWaoGeb5r4hiTMQOpv0GbQ@mail.gmail.com>
 <CAOQ4uxgBW03c9ZYvKKdD_n1z70fb=+-f6xYLzcZ6AWC3O04cXw@mail.gmail.com>
 <CAJfpegvngPP1KnM7JF4ofdmSVG0XH_NeOC+B97iJZbCgvfAWFw@mail.gmail.com> <20231012-klaut-dohle-e87948620243@brauner>
In-Reply-To: <20231012-klaut-dohle-e87948620243@brauner>
From:   Amir Goldstein <amir73il@gmail.com>
Date:   Thu, 12 Oct 2023 12:27:26 +0300
Message-ID: <CAOQ4uxhU4kh5j55RpvD7=vkagySTbbvc=CqLv6sxk5114k4Kvg@mail.gmail.com>
Subject: Re: [regression?] escaping commas in overlayfs mount options
To:     Christian Brauner <brauner@kernel.org>
Cc:     Miklos Szeredi <miklos@szeredi.hu>,
        Sebastian Wick <sebastian.wick@redhat.com>,
        Ryan Hendrickson <ryan.hendrickson@alum.mit.edu>,
        linux-unionfs@vger.kernel.org, Karel Zak <kzak@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <linux-unionfs.vger.kernel.org>
X-Mailing-List: linux-unionfs@vger.kernel.org

On Thu, Oct 12, 2023 at 11:26=E2=80=AFAM Christian Brauner <brauner@kernel.=
org> wrote:
>
> > > Christian,
> > >
> > > Do you know any userspace that already uses your new append prefixes?
> > > Do we have any good reason to support "lowerdir_first"
> > > so a lower dir stack could be reset before creating the sb?
> >
> > If that is a requirement, I suggest extending fsconfig(2) to allow
> > resetting an option.
>
> Overlayfs does already support this. If you pass:
> fsconfig(FSCONFIG_SET_STRING, "lowerdir", "", ...)
> then the lower layer stack is reset. I've implemented it that way in
> ovl_parse_param_lowerdir().
>

Yes, I noticed that. Cool.

> >
> > > > > > >
> > > > > > > Anyway, let's focus on what you would like best.
> > > > > > > If you prefer to just fix the regression, it is doable.
> > > > > > > If you prefer the upperdirfd, workdirfd, lowerdirfd API, I th=
ink we can
> > > > > > > find a volunteer to write it up.
> >
> > Can't the existing option names be overloaded if a separate cmd
> > (FSCONFIG_SET_PATH or FSCONFIG_SET_PATH_EMPTY) is used in fsconfig()?
>
> Yes, they can and filesystems do do that today depending on whether they
> want to e.g., take an fd or a path or something.

Nice. It seems like Miklos has volunteered to implement the
dirfd and/or unescaped API variants for the new mount API :)

What is your opinion about the original regression report
regarding escaping of commas in ->parse_monolithic()?

It's easy to implement ovl_parse_monolithic() that will
conform to the old ovl_next_opt() behavior, but it does not
solve the problem long term.

If there are currently setups in the wild that pass arguments
like [lowerdir=3D/tmp/a\,b/], even if I do fix up ovl_parse_monolithic()
those setups will regress when they upgrade to libmount v2.39,
because AFAICT, libmount does not respect "\," to escape option split,
it respects [lowerdir=3D"/tmp/a,b/"] to escape option split.

If we do decide that we need to or want to fix ->parse_monolithic()
then do you think it would make sense to respect "\," escaping in
generic_parse_monolithic()?
I cannot imagine any workload that would get regressed by this
(famous last words).

Thoughts?

Thanks,
Amir.
