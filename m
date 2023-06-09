Return-Path: <linux-unionfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0457CC7EE2E
	for <linux-unionfs@archiver.kernel.org>; Fri,  9 Jun 2023 08:20:15 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240215AbjFIIUN (ORCPT
        <rfc822;linux-unionfs@archiver.kernel.org>);
        Fri, 9 Jun 2023 04:20:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52514 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240643AbjFIIT5 (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Fri, 9 Jun 2023 04:19:57 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0787E35AD
        for <linux-unionfs@vger.kernel.org>; Fri,  9 Jun 2023 01:18:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1686298673;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=rd7VTwJj41sSWBWJxfoVgVSHTW5DQONGMpYkA6fGdtw=;
        b=FbIYuIDYUNPbtMcthih20Tfj2aSASNNv1g8lvAvQa5MjR9xhAcP6meNRgomX1zef3mJpoj
        oVvxkTu+omveggLFzqisL52wTz8Wo50KNuw6CY2+VTkL2eVCym+eOVYNqel9Jd1kkP15hR
        NgaCA+aKJCOWAjhafw1WtK/HFs83UpQ=
Received: from mail-il1-f199.google.com (mail-il1-f199.google.com
 [209.85.166.199]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-509-DVqXbcF1OuSegAbmAcTUlg-1; Fri, 09 Jun 2023 04:17:47 -0400
X-MC-Unique: DVqXbcF1OuSegAbmAcTUlg-1
Received: by mail-il1-f199.google.com with SMTP id e9e14a558f8ab-33b59d59193so15922025ab.0
        for <linux-unionfs@vger.kernel.org>; Fri, 09 Jun 2023 01:17:47 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1686298667; x=1688890667;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=rd7VTwJj41sSWBWJxfoVgVSHTW5DQONGMpYkA6fGdtw=;
        b=LIYa5T2+OcLMw4IkqpiDJPr0fqa155Q55TTsYROZcSiGK0GHMevU9khyNwaegdggey
         ZQpup1GGhyLQosRDONiA5tZ1qHL+2VtqxK2YU+Imfw7gpQYxapqIEQGZKUEeACuCDrS8
         zFz/hqDI/X2UU+dTY9ppu6bGm4NDy9E1XAvYKHfFBlzvsu2hNUSN1+d4sKMmsI8vd/Mg
         QRY1vtzk169/MMsP5xBh3P8bk4sSseFsBLKnKAAT0JNhg7gJmvODMudXIHgfgW19iIH9
         jbqhKSrfptVgSwMdiAv11hMBgyFT8a05FNqtI+vA4NY28t5sTJWI34jQtQ70IzW3krMb
         zx1Q==
X-Gm-Message-State: AC+VfDxw7fuwF5j7WOSA0ONh7JqUny48t8KV8WPr6rRCrReN4fJCHNbg
        GXBbhvQong1nSHNNA9ZzbpRwzkN2Ze9CUJnmZzl78YAPLxafud92np6ndz+JcMZNHfXmahjCXhF
        9J6Qg0eYuZ0VxuHzBr/fDJW2YypDXktKqK9O5gCzQvQ==
X-Received: by 2002:a92:d5c9:0:b0:33e:5113:577b with SMTP id d9-20020a92d5c9000000b0033e5113577bmr1148350ilq.13.1686298667029;
        Fri, 09 Jun 2023 01:17:47 -0700 (PDT)
X-Google-Smtp-Source: ACHHUZ5e5fNUEGjjVxxit+FFHdh/RpE9+CaKHVNevJ1lgCIeWGTPIVMZFmGU8P2r0UqAf+27I7JQefPyQtQStrjN02g=
X-Received: by 2002:a92:d5c9:0:b0:33e:5113:577b with SMTP id
 d9-20020a92d5c9000000b0033e5113577bmr1148339ilq.13.1686298666765; Fri, 09 Jun
 2023 01:17:46 -0700 (PDT)
MIME-Version: 1.0
References: <20230427130539.2798797-1-amir73il@gmail.com> <CAL7ro1G7DQS_aAC4+9-ppdQz_7vjoXdBLohZ6bKo6S75NQUDPA@mail.gmail.com>
 <CAOQ4uxhN1dPBkhAu3Zag8=RKCbzMQghuXnyp+uur83dRW8tz6Q@mail.gmail.com>
 <87h6s0z6rf.fsf@redhat.com> <CAOQ4uxhkCgU2=F2oAJn34Jor2_Hr56fLsa8cAAz936G05d-+ZQ@mail.gmail.com>
 <CAL7ro1EoNDMxU2d9WYrb772VFWWMDWV=KVvrZDnK=5byemmo8Q@mail.gmail.com>
 <fb711bb4-3f25-ccee-0d21-2cb6deea75ec@linux.alibaba.com> <CAOQ4uxiCzTbr4OXhxv=RbNbKn+kaBva-Wkz4AGW8OJUwL3GfLQ@mail.gmail.com>
 <CAJfpegvsEuSNepb_9MNEkEFsW7R60DDk57x3oivA6wx9y8StRA@mail.gmail.com> <20230530-klagen-zudem-32c0908c2108@brauner>
In-Reply-To: <20230530-klagen-zudem-32c0908c2108@brauner>
From:   Alexander Larsson <alexl@redhat.com>
Date:   Fri, 9 Jun 2023 10:17:35 +0200
Message-ID: <CAL7ro1EnakXWOvJW7QGfd1+X_rpCUPQWotoL9Ca5RkWWYCscDA@mail.gmail.com>
Subject: Re: [PATCH v2 00/13] Overlayfs lazy lookup of lowerdata
To:     Christian Brauner <brauner@kernel.org>
Cc:     Miklos Szeredi <miklos@szeredi.hu>,
        Amir Goldstein <amir73il@gmail.com>,
        Gao Xiang <hsiangkao@linux.alibaba.com>,
        Giuseppe Scrivano <gscrivan@redhat.com>,
        linux-unionfs@vger.kernel.org,
        Lennart Poettering <lennart@poettering.net>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <linux-unionfs.vger.kernel.org>
X-Mailing-List: linux-unionfs@vger.kernel.org

On Tue, May 30, 2023 at 6:19=E2=80=AFPM Christian Brauner <brauner@kernel.o=
rg> wrote:
>
> On Tue, May 30, 2023 at 04:08:38PM +0200, Miklos Szeredi wrote:
> > On Sat, 27 May 2023 at 16:04, Amir Goldstein <amir73il@gmail.com> wrote=
:
> >
> > > If we would want to support data-only layers in the middle on the
> > > stack, which would this syntax make sense?
> > > lowerdir=3Dlower1::data1:lower2::data2
> > >
> > > If this syntax makes sense to everyone, then we can change the syntax
> > > of data-only in the tail from lower1::data1:data2 to lower1::data1::d=
ata2
> > > and enforce that after the first ::, only :: are allowed.
> > >
> > > Miklos, any thoughts?
> > > I have a feeling that this was your natural interpretation when you f=
irst
> > > saw the :: syntax.
> >
> > Yes, I think it's more natural to have a prefix for each data-only
> > layer.  And this is also good for extensibility, as discussed.
>
> Sorry, just a quick braindump vaguely related to this new mount syntax.
>
> A while ago util-linux reported issues with overlayfs when mounted
> through the new mount api (cf. [1]) and I completely forgot to mention
> this to you during LSFMM. So say you do:
>
>         fs_fd =3D fsopen("overlay", FSOPEN_CLOEXEC);
>
>         fsconfig(fs_fd, FSCONFIG_SET_STRING, "upperdir", "/home/asavah/kr=
oss/tmp/asusb450eg/upper", 0);
>
>         fsconfig(fs_fd, FSCONFIG_SET_STRING, "workdir", "/tmp/work", 0);
>
>         fsconfig(fs_fd, FSCONFIG_SET_STRING, "lowerdir", "0:1:2:3:4:5:6:7=
:8:9:a:b:c:d:e:f:10:11:12:13:14:15:16:17:18:19:1a:1b:1c:1d:1e:1f:20:21:22:2=
3:24:25:26:27:28:29:2a:2b:2c:2d:2e:2f:
>
> This will fail because FSCONFIG_SET_STRING is limited to 256 bytes.
> That's a reasonable limit and I don't think we need to extend this to
> PATH_MAX.
>
> Instead, my reaction had been that lowerdir should be specifiable
> multiple times through fsconfig() and overlayfs should probably append
> lower layers via:
>
>         ret =3D fsconfig(fs_fd, FSCONFIG_SET_STRING, "lowerdir", "/home/u=
sername/project/data1", 0);
>         // append
>         ret =3D fsconfig(fs_fd, FSCONFIG_SET_STRING, "lowerdir", ":/home/=
username/project/data2", 0);
>         // append
>         ret =3D fsconfig(fs_fd, FSCONFIG_SET_STRING, "lowerdir", ":/home/=
username/project/data3", 0);
>
>         // replace everything specified until now
>         ret =3D fsconfig(fs_fd, FSCONFIG_SET_STRING, "lowerdir", "/home/u=
sername/project/data4", 0);
>
>         // reset everything
>         ret =3D fsconfig(fs_fd, FSCONFIG_SET_STRING, "lowerdir", "", 0);
>
> so with the new syntax this would probably be:
>
>         ret =3D fsconfig(fs_fd, FSCONFIG_SET_STRING, "lowerdir", "/home/u=
sername/project/data1", 0);
>         // append data only layer
>         ret =3D fsconfig(fs_fd, FSCONFIG_SET_STRING, "lowerdir", "::/home=
/username/project/data2", 0);
>         // append data only layer
>         ret =3D fsconfig(fs_fd, FSCONFIG_SET_STRING, "lowerdir", "::/home=
/username/project/data3", 0);
>
> [1]: https://github.com/util-linux/util-linux/issues/1992

Btw. I forgot to mention this, but I ran into an issue with overlayfs
and the new mount api. In order to be able to pass in any pathname in
the
lowerdir option, overlayfs escapes commas, like:

  -o lowerdir=3D/lower/dir/with\,commas,upperdir=3D/upper

This is handled in overlayfs in ovl_split_lowerdirs() and ovl_unescape().

However, when using the new mount APIs, currently overlayfs uses
legacy_fs_context_ops, and legacy_parse_param() forbids commas in the
string, even if it is escaped. So the above mount will fail with "VFS:
Legacy: Option '%s' contained comma".

--=20
=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D=
-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D
 Alexander Larsson                                Red Hat, Inc
       alexl@redhat.com         alexander.larsson@gmail.com

