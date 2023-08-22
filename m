Return-Path: <linux-unionfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 37A00EE4993
	for <linux-unionfs@archiver.kernel.org>; Tue, 22 Aug 2023 15:31:14 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237126AbjHVPbO (ORCPT
        <rfc822;linux-unionfs@archiver.kernel.org>);
        Tue, 22 Aug 2023 11:31:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40022 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237122AbjHVPbO (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Tue, 22 Aug 2023 11:31:14 -0400
Received: from mail-ua1-x92f.google.com (mail-ua1-x92f.google.com [IPv6:2607:f8b0:4864:20::92f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 52B9DCD2
        for <linux-unionfs@vger.kernel.org>; Tue, 22 Aug 2023 08:31:11 -0700 (PDT)
Received: by mail-ua1-x92f.google.com with SMTP id a1e0cc1a2514c-79da1a3e2e2so1191982241.1
        for <linux-unionfs@vger.kernel.org>; Tue, 22 Aug 2023 08:31:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1692718270; x=1693323070;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=v9DSJCQ5ilY1QNRUXcUlmFGzUAqh4ImXiDSo8qejQ6U=;
        b=TZNg/2AQm99JQGASXPO08IqGIvbUN1+04fu8guDa1bOT8seA8m6mjpuq3/aP0u3Gun
         lsxFrOljbV3UMeoFLUwS/Y2YAFl07+7ZbLDRfvqACERQfohlGX7gv3ePxziqAjncNKQ1
         6mdT19m6zXzgUCdEAQV8i+z5rMqpHoqz30iUigEY0Jhj521NFr1/pV0YdEqEiwjFmLMa
         7na/JUNv0ZawaUjt3MkBOKff8ALfMxa1A+w8MtL36VIqEzNHu1WSSPoqF1Zb/ovPC4MW
         P42SVi3XvAg53FD7KUIMs/UCc69rdwTYxLl/7Ea/z1jVHb9uClKhtocwsI/j64bTILHw
         rEPg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1692718270; x=1693323070;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=v9DSJCQ5ilY1QNRUXcUlmFGzUAqh4ImXiDSo8qejQ6U=;
        b=IZndbApk/tmQo5+kMs9PoCe5Hb7iyHrW5h/AclmSP3gtK8g3mXp6r/IX5dpbWVH0NB
         +LHYdhLA7Cd1vcydDS/YsfuVoV1dzpJBfQP0P7PFwLoZjVD+JvQ8iNY4fUGH2LOH5K/W
         RfGiI9E3NsIhEluYh4vku/9jr3ySOK6ZQ938fIX0MDAus5X4EMjINeLspE/yEgbpCYTC
         J65x+oZXzkpl8R1xK3g8XN7Q+jlFnuJ+Y3ySPIltcb2FJoOVLFRJFmfqSWOtsn2JNtd7
         UJzsRm7PlpCyXPgdA4KrW8ocFS38Pt2dku8P9MQp76oelVqdv7XYU4Jj/pqiuapZNcfO
         j74A==
X-Gm-Message-State: AOJu0Yy+1zt2lKzwdJ7QQCkltzKawNK/wReWbnVF2l7/5t4iREk2EPQ+
        44TBNvwLYlpX8PnjTu5UZ31l0g65Ilizt05b8n4=
X-Google-Smtp-Source: AGHT+IGQG4qHeQjxzJsbQMMQ7INwmSo1miqd4SF9d0j0tVgeJTXL1CY5hs1YDYMgm87WATsyK4eEY3WwNSaWzObtJcE=
X-Received: by 2002:a67:e915:0:b0:447:7da:bd42 with SMTP id
 c21-20020a67e915000000b0044707dabd42mr5808719vso.18.1692718270223; Tue, 22
 Aug 2023 08:31:10 -0700 (PDT)
MIME-Version: 1.0
References: <cover.1692270188.git.alexl@redhat.com> <f140fd46c2f61e69630c14a6b3fb8ed5e3c62307.1692270188.git.alexl@redhat.com>
 <CAJfpeguHCVFpcGVWdP5-j+7-+4cqjvd+-40UM=+vL1OFwS7rZA@mail.gmail.com>
 <CAL7ro1HMZxXZDyJG9yikx+KCd3HsYPZdgk7SJBLAGWBKVrYD6g@mail.gmail.com>
 <CAJfpeguerGOWAELyd7oY=z8Y-1sGG6OY9MurhCB7-kegxZ-wmQ@mail.gmail.com>
 <CAL7ro1Hr43u7CoyHwVOzxp+pcN2MHEf18B7+CZk=HFw=viGz8A@mail.gmail.com> <CAL7ro1FagGOZZg9yeWvWDov6L3prrjJE-+Yre1CJuViT7idNYw@mail.gmail.com>
In-Reply-To: <CAL7ro1FagGOZZg9yeWvWDov6L3prrjJE-+Yre1CJuViT7idNYw@mail.gmail.com>
From:   Amir Goldstein <amir73il@gmail.com>
Date:   Tue, 22 Aug 2023 18:30:59 +0300
Message-ID: <CAOQ4uxhVXrNfhWc-EsunfyWyrJDFCjYu8GeAtvN0__QTfjtV5A@mail.gmail.com>
Subject: Re: [PATCH v2 4/5] ovl: Support creation of whiteout files on overlayfs
To:     Alexander Larsson <alexl@redhat.com>
Cc:     Miklos Szeredi <miklos@szeredi.hu>, linux-unionfs@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <linux-unionfs.vger.kernel.org>
X-Mailing-List: linux-unionfs@vger.kernel.org

On Tue, Aug 22, 2023 at 5:36=E2=80=AFPM Alexander Larsson <alexl@redhat.com=
> wrote:
>
> On Tue, Aug 22, 2023 at 4:25=E2=80=AFPM Alexander Larsson <alexl@redhat.c=
om> wrote:
> >
> > On Tue, Aug 22, 2023 at 3:56=E2=80=AFPM Miklos Szeredi <miklos@szeredi.=
hu> wrote:
> > >
> > > On Tue, 22 Aug 2023 at 15:22, Alexander Larsson <alexl@redhat.com> wr=
ote:
> > > >
> > > > On Mon, Aug 21, 2023 at 1:00=E2=80=AFPM Miklos Szeredi <miklos@szer=
edi.hu> wrote:
> > > > >
> > > > > On Thu, 17 Aug 2023 at 13:05, Alexander Larsson <alexl@redhat.com=
> wrote:
> > > > > >
> > > > > > This is needed to properly stack overlay filesystems, I.E, bein=
g able
> > > > > > to create a whiteout file on an overlay mount and then use that=
 as
> > > > > > part of the lowerdir in another overlay mount.
> > > > > >
> > > > > > The way this works is that we create a regular whiteout, but se=
t the
> > > > > > `overlay.nowhiteout` xattr on it. Whenever we check if a file i=
s a
> > > > > > whiteout we check this xattr and don't treat it as a whiteout i=
f it is
> > > > > > set. The xattr itself is then stripped and when viewed as part =
of the
> > > > > > overlayfs mount it looks like a regular whiteout.
> > > > > >
> > > > >
> > > > > I understand the motivation, but don't have good feelings about t=
he
> > > > > implementation.  Like the xattr escaping this should also have th=
e
> > > > > property that when fed to an old kernel version, it shouldn't
> > > > > interpret this object as a whiteout.  Whether it remains hidden l=
ike
> > > > > the escaped xattrs or if it shows up as something else is
> > > > > uninteresting.
> > > > >
> > > > > It could just be a zero sized regular file with "overlay.whiteout=
".
> > > >
> > > > So, I started doing this, where a whiteout is just a regular file w=
ith
> > > > the xattr set. Initially I thought I only needed to check the xattr
> > > > during lookup and convert the inode mode from S_IFREG to S_IFCHR.
> > > > However, I also need to hook up readdir and convert DT_REG to DT_CH=
R,
> > > > otherwise readdir will report the wrong d_type. To make it worse,
> > > > overlayfs itself looks for DT_CHR to handle whiteouts when listing
> > > > files, so nesting is not working without that.
> > > >
> > > > The only way I see to implement that conversion is to call getxattr=
()
> > > > on every DT_REG file during readdir(), and while a single getxattr(=
)
> > > > on lookup is fine, I don't think that is.
> > > >
> > > > Any other ideas?
> > >
> > > Not messing with d_type seems a good idea.   How about a random
> > > unreserved chardev?
> >
> > Only the whiteout one (0,0) can be created by non-root users.
>
> I was thinking of (ab)using DT_SOCK or DT_FIFO, but turns out you
> can't store xattrs on such files.

FWIW, there is also DT_WHT that was defined and never used.
But that is just an anecdote.

Regarding the issue of avoiding getxattr for every dirent.
Note that in readdir, dirent that goes through ovl_cache_update_ino()
calls lookup()/stat() on the overlay itself, so as long as ovl_lookup()
will treat overlay.whiteout file as a whiteout, the code
                 /* Mark a stale entry */
                p->is_whiteout =3D true;
will kick in and do the right thing for readdir wrt cleaning up
lower entries covered with whiteouts, regardless of DT_CHR.

Now all that is left is to make sure that ovl_cache_update_ino()
is called if there are possibly overlay.whiteout files.

For the case of nested ovl, upper and lower fs cannot be the same,
so ovl_same_fs() is false.
Therefore, as long as xino is enabled (this is the default),
ovl_same_dev() is true =3D> ovl_xino_bits() > 0 =3D>
ovl_calc_d_ino() is true and ovl_cache_update_ino() will be
called for all merged dirents.

IOW, unless I am missing something, if you implement overlay.whiteout
logic in ovl_lookup() correctly, readdir should "just work" as long as
the mounter does not explicitly use -o xino=3Doff.

Thanks,
Amir.
