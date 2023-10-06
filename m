Return-Path: <linux-unionfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AC8C7E81E1E
	for <linux-unionfs@archiver.kernel.org>; Fri,  6 Oct 2023 17:21:44 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232636AbjJFRVo (ORCPT
        <rfc822;linux-unionfs@archiver.kernel.org>);
        Fri, 6 Oct 2023 13:21:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47404 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229900AbjJFRVn (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Fri, 6 Oct 2023 13:21:43 -0400
Received: from mail-qt1-x82b.google.com (mail-qt1-x82b.google.com [IPv6:2607:f8b0:4864:20::82b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0B7B6C6
        for <linux-unionfs@vger.kernel.org>; Fri,  6 Oct 2023 10:21:42 -0700 (PDT)
Received: by mail-qt1-x82b.google.com with SMTP id d75a77b69052e-4194d89a6dfso13839121cf.0
        for <linux-unionfs@vger.kernel.org>; Fri, 06 Oct 2023 10:21:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1696612901; x=1697217701; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=6jaXtk7gtrG/8ok3Q/PiFA/5xpgm6aCZy7tnaYMOt9k=;
        b=HLUMESZLjf8tDiHvib4Lg6UdApZCnmVquH14P0gmeT3LACmiB++NPmS3JmnwZfHe3w
         ChtRCAFaa2RW9OMkI+Uql5kVgoEweHqobEDaGDyVIsnPsBUf3u0g1XFVNt5l05lLaH1c
         GoOT0yISgY96c//DWQQCTHxWjaG1CjzHOWJ1oM8lvBxVPL0S90wUvlou1Xmm8ihOp30P
         4kTUba7jecz+q/m00n6ZtJySU1MMZq5oI+ThC9EQDQFfJ+S60cx9DCl68ePKG5t5nslE
         +44pBvyKRCzbpD8o0u7SovDpU/vvMqnRPIfLDA7y+Uy80jXp0twl+Ge15uUhiC9zBYEb
         RIew==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1696612901; x=1697217701;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=6jaXtk7gtrG/8ok3Q/PiFA/5xpgm6aCZy7tnaYMOt9k=;
        b=Sx10pKaPYzexU5wqTTGuBAelJdfRPgvoMwey4s1qwdvl80OtvKmXDhYaZG0vNvP1Tz
         L7KXNSctjrLdPtzc6NvzeLfkmZqLkaR5PvzLfQwsPG0GX1EQ2DnBHJAUoKobmmV26NME
         uxWYMNYI49ebj6m+fGidAQGk1vhEmpr3TtOvVjoGwPNPVx3Msqn7UjMuhS4yboqHdhHv
         VVHDiyKpH+VuL+RNB5o6xD3UwrmmCedfQSy6+9LJYWdOiUbjGrybJEYiGE8vQ4zkUbrJ
         hlEiAXbDPznZiFSDNexrf9VYQUJnkPivMwosIIcfPdk3oELeP5afEfrPQTUx3hI4sNOW
         IeYg==
X-Gm-Message-State: AOJu0Yz/qKAix8Ai9P+9cQuzZI9ExJ3nXHuHaf0u2e0YSiaSrxzwmWXp
        GhwDFpBCOXBzpx01lhshY6VjuoX+gDvcwiy65XY=
X-Google-Smtp-Source: AGHT+IFNQ10NGQCtYq8xMvTjzTxPxQYWODjvqLazXRAwQKVXXw8j6552i9YAGIsF6B+HQA1jRSd7pp8EtRFFF1AvIiY=
X-Received: by 2002:ac8:7f05:0:b0:418:1f04:ca17 with SMTP id
 f5-20020ac87f05000000b004181f04ca17mr8923314qtk.49.1696612901084; Fri, 06 Oct
 2023 10:21:41 -0700 (PDT)
MIME-Version: 1.0
References: <8da307fb-9318-cf78-8a27-ba5c5a0aef6d@alum.mit.edu>
 <CAOQ4uxhQhzv_LUW89m_BmKf+NjE+XDyY9XtLAt+SWG03M6LmYQ@mail.gmail.com>
 <20231006130259.GA438068@toolbox> <CAOQ4uxg84M7H0EtTLWAsNkHaaLzVVXQ=-fCVFVr8a6MGSQC=vg@mail.gmail.com>
 <5d708a45-43c9-b026-6619-7c377ee02793@alum.mit.edu>
In-Reply-To: <5d708a45-43c9-b026-6619-7c377ee02793@alum.mit.edu>
From:   Amir Goldstein <amir73il@gmail.com>
Date:   Fri, 6 Oct 2023 20:21:29 +0300
Message-ID: <CAOQ4uxgNakTHi0dHC1v51TCU_aAKTOrJ4zFv=BzfoKNMsCwZEg@mail.gmail.com>
Subject: Re: [regression?] escaping commas in overlayfs mount options
To:     Ryan Hendrickson <ryan.hendrickson@alum.mit.edu>
Cc:     Sebastian Wick <sebastian.wick@redhat.com>,
        Christian Brauner <brauner@kernel.org>,
        Miklos Szeredi <miklos@szeredi.hu>,
        linux-unionfs@vger.kernel.org, Karel Zak <kzak@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <linux-unionfs.vger.kernel.org>
X-Mailing-List: linux-unionfs@vger.kernel.org

On Fri, Oct 6, 2023 at 7:42=E2=80=AFPM Ryan Hendrickson
<ryan.hendrickson@alum.mit.edu> wrote:
>
> At 2023-10-06 19:17+0300, Amir Goldstein <amir73il@gmail.com> sent:
>
> > On Fri, Oct 6, 2023 at 4:03=E2=80=AFPM Sebastian Wick
> > <sebastian.wick@redhat.com> wrote:
> >>
> >> It would be nice to have this fixed. A more general question: will you
> >> commit on keeping the escaping stable from now on or do we have to
> >> expect changes at any point in the future?
> >>
> >
> > I prefer that escaping would be handled in userspace, now that the new
> > mount API allows that, so deferring the question to libmount maintainer=
.
>
> Note that with overlayfs on the new mount API, there are now two levels o=
f
> escaping to consider:
>
> There is the escaping that needs to happen for commas when splitting moun=
t
> parameters; this could be handled in libmount when using the new API.
>

Right.

> And there is the escaping that needs to happen for ':' and '\' when
> parsing the path parameters (':' is only special syntax in lowerdir, but
> the escaping logic seems to apply to upperdir and workdir as well, based
> on my testing). Even using the new API, this is handled in the kernel.
> We'd like to know if this escaping can be considered stable as well, and =
I
> don't think that's a question for the libmount maintainer.

Agree.
Unlike the comma separated parameters list,
upperdir,workdir,lowerdir are overlayfs specific format.

ovl_unescape() (for upperdir/workdir) unescapes '\' characters.
as does ovl_parse_param_split_lowerdirs().
Not sure why this was needed for upperdir/workdir, but it It has
been this way for a long time.
I see no reason for it to change in the future.

Thanks,
Amir.
