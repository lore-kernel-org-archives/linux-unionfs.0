Return-Path: <linux-unionfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 72625CDB474
	for <linux-unionfs@archiver.kernel.org>; Sun, 22 Oct 2023 07:26:48 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229574AbjJVH0r (ORCPT
        <rfc822;linux-unionfs@archiver.kernel.org>);
        Sun, 22 Oct 2023 03:26:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35472 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229452AbjJVH0q (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Sun, 22 Oct 2023 03:26:46 -0400
Received: from mail-qv1-xf2d.google.com (mail-qv1-xf2d.google.com [IPv6:2607:f8b0:4864:20::f2d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8A7D5C2
        for <linux-unionfs@vger.kernel.org>; Sun, 22 Oct 2023 00:26:43 -0700 (PDT)
Received: by mail-qv1-xf2d.google.com with SMTP id 6a1803df08f44-66d87554434so17599866d6.2
        for <linux-unionfs@vger.kernel.org>; Sun, 22 Oct 2023 00:26:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1697959602; x=1698564402; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=xnfbqRhmut39DwLdZ2MbDa5AkD9xtyC7U95KlczW2Co=;
        b=W3O2htwliCEHDuFFBeK+NEuXTCa1nCUzv3Ir+DF5+89+sUNev4cZ08m5t72k0f7iYK
         1XPJxjO2s9ZFYI4OZabgzSklPrPkuPd9tCQZIHlurypwwcTaJrfyimEGskfjgJQ57ftF
         BdA+0VE2sTKKJXGXjqrBGrAo351RD3qt4Tn+DLGzvllHVGz2ozZls4Be+w9GPbxLKZgB
         uWSpHqnF3WPBRi/mgMkPAUEnOGViRwc9CZ+JDCjKdllYa7MXF2Z/F7Fu5Ri+B0+NuDTU
         CdKVYRKZH56ZZ8vKTReTcvHa684rzkrLk7IPPrFyrT1HKkHJpYP0qy4GYo2od908esRR
         ieYw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1697959602; x=1698564402;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=xnfbqRhmut39DwLdZ2MbDa5AkD9xtyC7U95KlczW2Co=;
        b=j5pmJbff3Er0Le+X7T/S4gx7lp2mfWHFTS3JuRmn95k0rSZbty0giZzcGND24Dlly6
         XMS9dV81OXhEB1Sk6ujX+d1JroZ1TwpWAB7ulWCePOEs6xbDjmHcOKtrYq0JH538nEc4
         0B7PiQpxF2ee0G70/2x3Lj+A5BuT77CZeuSr/ukEMfOX5fiCzzSSs5XfaL1DCOb16X0V
         /Wkf/scLwpa2E/GFJXmFL2jZEKDY30Ip0DUG0VEbd3BI7jc7e5KtQb8HJTTdAFqahGeP
         HV8o8V+J1zaQf1wr1IMsA8iMn12sDYS2lpO6Fb7EVfbRMxOTI3wgyL8+aJaymxOs3pJO
         wjDw==
X-Gm-Message-State: AOJu0YxmwU0/dIBDjyDJEf38SVx+3oEvYeXTlW2yjFwaoVbgtPlDIBGx
        d3C7QHPUrxA8sKk8uDYtj5aXqFNEjVAiapNhoQI=
X-Google-Smtp-Source: AGHT+IEXiyUr7WFr9oTdOKmryoMCCbYJ4iLPCaRBL+9/dSEy9SOyNcQILzR5UvLAk/QZsOc01EcMJH05sDMopVfTWhA=
X-Received: by 2002:a05:6214:5186:b0:66d:1021:5e8d with SMTP id
 kl6-20020a056214518600b0066d10215e8dmr7740880qvb.10.1697959602522; Sun, 22
 Oct 2023 00:26:42 -0700 (PDT)
MIME-Version: 1.0
References: <CAJfpegsexQsNVMOZw+0byzj2wTbU_Tg6p0ATgwBAwmTaDmNbLA@mail.gmail.com>
 <CAOQ4uxjYGckJA=raAW8wyVmDaK-FXfFDRS0RCpZYcLucPqMi3w@mail.gmail.com>
 <CAJfpegt5COamxm-ZN+A9ub_Te-CPM0xMd-Rrzwv7OHBkvHS3yg@mail.gmail.com>
 <CAOQ4uxic3NDtEt9EiP+RYKGEB=6b_PCaudQA=cXK6mWY4Cmeqg@mail.gmail.com>
 <CAJfpegsr3A4YgF2YBevWa6n3=AcP7hNndG6EPMu3ncvV-AM71A@mail.gmail.com>
 <CAJfpegt7VC94KkRtb1dfHG8+4OzwPBLYqhtc8=QFUxpFJE+=RQ@mail.gmail.com>
 <CAOQ4uxhg+0_S1tQv9vUpv7Yu-VRLv7U7cnxLmxig+9LmS_qW+A@mail.gmail.com>
 <CAJfpegu6cESPijvO51zjVeXA=wcw7nMaNkkNJ7+my07wq8k9FA@mail.gmail.com>
 <CAOQ4uxicurA4nNeDkUarkTMujtsaOvwQ8HEMpz97N2SejBRx9Q@mail.gmail.com>
 <CAJfpegv=UXqYQzvH6+py76MV7+5L6=3a+_J7LpHQ0VK5YYrAUA@mail.gmail.com> <20231017101118.5h7pj26vos32h63u@ws.net.home>
In-Reply-To: <20231017101118.5h7pj26vos32h63u@ws.net.home>
From:   Amir Goldstein <amir73il@gmail.com>
Date:   Sun, 22 Oct 2023 10:26:31 +0300
Message-ID: <CAOQ4uxhgUSPkYAV8SJu-SFszkJcVO3-M4DXf46nJUtXODrPk2g@mail.gmail.com>
Subject: Re: [PATCH] ovl: fix regression in showing lowerdir mount option
To:     Karel Zak <kzak@redhat.com>
Cc:     Miklos Szeredi <miklos@szeredi.hu>,
        Christian Brauner <brauner@kernel.org>,
        linux-unionfs@vger.kernel.org, Steve French <sfrench@samba.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <linux-unionfs.vger.kernel.org>
X-Mailing-List: linux-unionfs@vger.kernel.org

On Tue, Oct 17, 2023 at 1:11=E2=80=AFPM Karel Zak <kzak@redhat.com> wrote:
>
> On Mon, Oct 16, 2023 at 03:10:33PM +0200, Miklos Szeredi wrote:
> > On Mon, 16 Oct 2023 at 13:56, Amir Goldstein <amir73il@gmail.com> wrote=
:
> > >
> > > On Mon, Oct 16, 2023 at 12:27=E2=80=AFPM Miklos Szeredi <miklos@szere=
di.hu> wrote:
> > > >
> > > > On Sun, 15 Oct 2023 at 08:58, Amir Goldstein <amir73il@gmail.com> w=
rote:
> > > >
> > > > > +       for (nr =3D 0; nr < nr_added_lower; nr++, lowerdirs++) {
> > > > > +               if (nr < nr_merged_lower)
> > > > > +                       seq_show_option(m, "lowerdir+", *lowerdir=
s);
> > > > > +               else
> > > > > +                       seq_show_option(m, "datadir+", *lowerdirs=
);
> > > >
> > > > Good.
> > > >
> > > > I did some testing and it turns out libmount still regresses on
> > > > 6.6-rc6 for the escaped comma case.  The reason is that libmount
> > > > doesn't understand escaping of commas, hence the '-oupper=3Dupper\,=
1'
> > > > will result in two fsconfig() calls: 'upper=3Dupper\'  and '1'.  Pr=
ior
> > > > to 6.5 these were nicely reconstructed into the original
> > > > 'upper=3Dupper\,1' by  legacy_parse_param().
>
> Yes, libmount does not interpret '\,' in any way, it's just comma
> after a char :-)
>
> > >
> > > Technically, I think this is a libmount regression, not a kernel regr=
ession.
> > > Since libmount 2.39, libmount will split the commas differently than
> > > overlayfs always did.
>
> The difference is that old libmount versions do not split the string;
> it only removes well-known non-kernel stuff and flags from the string.
> However, the rest of the string remains unmodified. This means that
> "upper=3Daaa,bbb" comprises two options for the old libmount, but
> because it neither reorders nor splits it, it is sent unmodified to
> the mount(2) syscall.
>
> The new libmount works with mount options differently. It keeps them
> parsed in memory (in a struct libmnt_optlist), and this list is used
> for fsconfig().
>
> > Ah, but it's not a regression after all, since the kernel un-split the
> > same commas until 6.5, so there was no way the libmount devs would
> > have observed any regression in overlayfs mount.   But arguing about
> > which component is the cause of the regression is not very productive.
> > Indeed libmount can be fixed parse overlayfs options the same way as
> > the kernel parsed them before 6.5, which is probably a much better
> > fix, than a kernel one.
> >
> > Karel, is doing such filesystem specific option handling feasible?
>
> For decade we have support for commas in mount option due to
> creativity of SELinux developers:
>
>     foo,context=3D"aaa,bbb,ccc",bar
>
> is valid mount options string and libmount will ignore commas within
> " " and split it to foo, bar, and context=3D.
>
> The current util-linux git (and old 6.2 kernel):
>
> # strace -e fsopen,fsconfig ./mount -t overlay overlay -o 'lowerdir=3D"/t=
mp/test-lower,",upperdir=3D/tmp/test-upper,workdir=3D/tmp/test-work' /tmp/t=
est
> fsopen("overlay", FSOPEN_CLOEXEC)       =3D 3
> fsconfig(3, FSCONFIG_SET_STRING, "source", "overlay", 0) =3D 0
> fsconfig(3, FSCONFIG_SET_STRING, "lowerdir", "/tmp/test-lower,", 0) =3D -=
1 EINVAL (Invalid argument)
>
> You can see "/tmp/test-lower,".
>
> Maybe all we need is to improve mount(8) docs to force people use ""
> for paths when used in mount options.
>

Even if people would read documentation ;-)
I don't think that would have helped in this case,
because with old libmount and old kernel, overlayfs does not parse
lowerdir=3D"/tmp/test-lower," correctly - it requires lowerdir=3D"/tmp/test=
-lower\,"

> Anyway, I think we can improve libmount to ignore \, as non-separator.
> The question is what the rest of the userspace universe, because fstab
> is interpreted on many places ...

The other option is to require overlayfs users to opt-in to new mount api
(LIBMOUNT_FORCE_MOUNT2=3Dalways) and otherwise default to
the old mount api or
instead of improving libmount parsing of \,
maybe just detect it and default to the old mount api
just for overlayfs or generally?

All-in-all, those cases are probably rare, so I think the minimal
solution with as little room for complication should be applied.
Detecting \, and defaulting to old mount api seems to meet this criteria?

BTW, smb3_fs_context_parse_monolithic() also has special
handling of comma parsing in kernel (,, is a non-separator comma),
so smb3 (cifs) may also require special treatment when choosing
old/new mount api.

Thanks,
Amir.
