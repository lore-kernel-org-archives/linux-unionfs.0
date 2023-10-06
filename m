Return-Path: <linux-unionfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B6BB3E81E17
	for <linux-unionfs@archiver.kernel.org>; Fri,  6 Oct 2023 16:17:32 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232009AbjJFQRc (ORCPT
        <rfc822;linux-unionfs@archiver.kernel.org>);
        Fri, 6 Oct 2023 12:17:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44316 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230050AbjJFQRb (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Fri, 6 Oct 2023 12:17:31 -0400
Received: from mail-qv1-xf32.google.com (mail-qv1-xf32.google.com [IPv6:2607:f8b0:4864:20::f32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7A1F3B6
        for <linux-unionfs@vger.kernel.org>; Fri,  6 Oct 2023 09:17:28 -0700 (PDT)
Received: by mail-qv1-xf32.google.com with SMTP id 6a1803df08f44-65b162328edso11398566d6.2
        for <linux-unionfs@vger.kernel.org>; Fri, 06 Oct 2023 09:17:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1696609047; x=1697213847; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=rRK7yACHfKykGJQC6A3E4Rd0J97TnCWzfvm1weZ+P9o=;
        b=Pl8rwsSZ5NKadSyKHFNWkJa06fE+9xXVUMPEUOiG8fvONmc1q6AyXddxlm+1/dI5R0
         mUsmevRxoOtBxB/3fbtdUkUZ/Q4UVotqyoeKqHIejN0qLTlQpDl/OjUQD624oxW0lq4c
         wKHC1OujQhIb46VDH32uBYVBlDS5tnf500dletF46ZOpxOMISod72ZopotD79TBdJk/J
         I5cDysHPJ0dHvIxZbuoxs4mIZvDZeZDwWS4kAxdLXyOBxa9pQC9ZU10NYOy5BJ4K2mzw
         ay/vdUOrEKOCWtH5eW0rl8ufk7tPEoJOQeVtqXiyybO6dA9+5CZMuZ3KgoNdfQ3nm/+0
         Jh3A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1696609047; x=1697213847;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=rRK7yACHfKykGJQC6A3E4Rd0J97TnCWzfvm1weZ+P9o=;
        b=Zr7vuIFlZyKUMgeo5jKMXpJcMcHwyPSI5eknevCTbdmZ0/cqRz8Al6bRbacnLvo0u2
         uYwcxPc73B0VTyt569kIJp65biJIp5W+GUJInVn6nhQ72WwGyDMB9APccD3OU8/ee3q0
         6Ml8lLxq9tpOLmiHfXLtGXZ1mVGEfOkvDvvcD/VsfCYqjkqHBwgDwnKjL0EEmYyzcDHc
         jhX5rLydJn5PuGH+gwCEy+Wtg06O1lH+1Fxw3FbwiabaA23KXup0K4l/rjWS75Fm6Fq2
         0KgB1xYwxuq93aDUexz6aU6NQsEywQvzdR7RJdJTmuJ5xf//yf7MVcdLvYYhmHTkHO6i
         BXmg==
X-Gm-Message-State: AOJu0YzfwEBC4PR48S1lzAL8U7cAIqZ6siGD5V/iYrapf+wntsJyZyDO
        v11Q1yEpzzFrjdhT+PO+imsijjDA3PE0KubtiCM=
X-Google-Smtp-Source: AGHT+IH7ujO8YCI/GmeL7XdKSYaVWVDnSDo3eTVrpd7fLu86/CekzE6XOkXrffwXcZ3RQ8iMpJ/NU/KTYwR4vadwGK8=
X-Received: by 2002:ad4:5949:0:b0:64f:51fe:859c with SMTP id
 eo9-20020ad45949000000b0064f51fe859cmr10626190qvb.43.1696609047483; Fri, 06
 Oct 2023 09:17:27 -0700 (PDT)
MIME-Version: 1.0
References: <8da307fb-9318-cf78-8a27-ba5c5a0aef6d@alum.mit.edu>
 <CAOQ4uxhQhzv_LUW89m_BmKf+NjE+XDyY9XtLAt+SWG03M6LmYQ@mail.gmail.com> <20231006130259.GA438068@toolbox>
In-Reply-To: <20231006130259.GA438068@toolbox>
From:   Amir Goldstein <amir73il@gmail.com>
Date:   Fri, 6 Oct 2023 19:17:16 +0300
Message-ID: <CAOQ4uxg84M7H0EtTLWAsNkHaaLzVVXQ=-fCVFVr8a6MGSQC=vg@mail.gmail.com>
Subject: Re: [regression?] escaping commas in overlayfs mount options
To:     Sebastian Wick <sebastian.wick@redhat.com>
Cc:     Ryan Hendrickson <ryan.hendrickson@alum.mit.edu>,
        Christian Brauner <brauner@kernel.org>,
        Miklos Szeredi <miklos@szeredi.hu>,
        linux-unionfs@vger.kernel.org, Karel Zak <kzak@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <linux-unionfs.vger.kernel.org>
X-Mailing-List: linux-unionfs@vger.kernel.org

On Fri, Oct 6, 2023 at 4:03=E2=80=AFPM Sebastian Wick <sebastian.wick@redha=
t.com> wrote:
>
> On Fri, Sep 29, 2023 at 07:44:09AM +0300, Amir Goldstein wrote:
> > On Fri, Sep 29, 2023 at 4:08=E2=80=AFAM Ryan Hendrickson
> > <ryan.hendrickson@alum.mit.edu> wrote:
> > >
> > > Up to and including kernel 6.4.15, it was possible to have commas in
> > > the lowerdir/upperdir/workdir paths used by overlayfs, provided they =
were
> > > escaped with backslashes:
> > >
> > >      mkdir /tmp/test-lower, /tmp/test-upper /tmp/test-work /tmp/test
> > >      mount -t overlay overlay -o 'lowerdir=3D/tmp/test-lower\,,upperd=
ir=3D/tmp/test-upper,workdir=3D/tmp/test-work' /tmp/test
> > >
> > > In 6.5.2 and 6.5.5, this no longer works; dmesg reports that overlayf=
s
> > > can't resolve '/tmp/test-lower' (without the comma).
> > >
> > > I see that there is a commit between the 6.4 and 6.5 lines titled [ov=
l:
> > > port to new mount api][1]. I haven't compiled a kernel before and aft=
er
> > > this commit to verify, but based on the code it deletes I strongly su=
spect
> > > that it, or if not then one of the ovl commits committed on the same =
day,
> > > is responsible for this change.
> > >
> > > [1]: https://github.com/torvalds/linux/commit/1784fbc2ed9c888ea4e895f=
30a53207ed7ee8208
> > >
> >
> > That's a good guess.
> > It helps to CC the author of the patch in this case ;-)
> >
> > > Does this count as a regression?
> >
> > "used to work, does not work now" is pretty close to a dictionary
> > definition of a regression :)
> >
> > The question is whether we should fix it.
> > The rule of thumb is that if users complain than we need to fix it,
> > but it's a corner case and if the only users that complained are willin=
g
> > to work around the problem (hint hint) then we may not need to fix it.
>
> It would be nice to have this fixed. A more general question: will you
> commit on keeping the escaping stable from now on or do we have to
> expect changes at any point in the future?
>

I prefer that escaping would be handled in userspace, now that the new
mount API allows that, so deferring the question to libmount maintainer.

Thanks,
Amir.

> In that case we would just reject any string contianing characters that
> need escaping.
>
> > > I can't find documentation for this
> > > escaping feature anywhere, even as it pertains to the non-comma chara=
cters
> > > '\\' and ':' (which, I've tested, can still be escaped as expected), =
so
> > > perhaps it was never properly supported? But a search for escaping co=
mmas
> > > in overlayfs turns up resources like [this post][2], suggesting that =
there
> > > are others who figured this out and expect it to work.
> > >
> > > [2]: https://unix.stackexchange.com/a/552640
> > >
> > > Is there a new way to escape commas for overlayfs options?
> > >
> >
> > Deferring the question to Christian.
> >
> > Thanks,
> > Amir.
>
