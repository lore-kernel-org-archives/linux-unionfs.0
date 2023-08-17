Return-Path: <linux-unionfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 03BF5C30627
	for <linux-unionfs@archiver.kernel.org>; Thu, 17 Aug 2023 14:44:02 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1352050AbjHQOna (ORCPT
        <rfc822;linux-unionfs@archiver.kernel.org>);
        Thu, 17 Aug 2023 10:43:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33002 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238878AbjHQOm6 (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Thu, 17 Aug 2023 10:42:58 -0400
Received: from mail-ua1-x92d.google.com (mail-ua1-x92d.google.com [IPv6:2607:f8b0:4864:20::92d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CEABC3596
        for <linux-unionfs@vger.kernel.org>; Thu, 17 Aug 2023 07:42:33 -0700 (PDT)
Received: by mail-ua1-x92d.google.com with SMTP id a1e0cc1a2514c-79a2216a2d1so2237466241.2
        for <linux-unionfs@vger.kernel.org>; Thu, 17 Aug 2023 07:42:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1692283307; x=1692888107;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=xdHf6wKaOfHJwiufWfkzNSVhUD4c5qo8CBYr9WF3rGg=;
        b=p34kcfuDqeZFzjKycO2gyUbxFNZGunYJeHFdX0qCRfpAhDnmpe8zV2kVvgYh1YiiKa
         6q4uzu1dX/WQ5Q5Nv5hOUzqazBBx6QUdfOwgfy5ini6to/yItIYdXcA6bZbXGQPvIzts
         awy0a83FaVkVMp0agciSbLqTDxtNof5BHfQKtjr1X2hWhwqa7J6xE+PnP+bGvM3aqsZ3
         UZ0Fzt0p8Sy4QefOP4++XvF0vw/WwI6W40iL3njAC8cPRHlpso6WoUsP5N2IyDYua0A0
         kO2udAlt/vyBxf5mzpTaCSY40rTTWBsbc7GRd6sw5rWeKWFhMw9E3sAAHIUYEsWP+KWU
         sqLA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1692283307; x=1692888107;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=xdHf6wKaOfHJwiufWfkzNSVhUD4c5qo8CBYr9WF3rGg=;
        b=QwZQWYdTxiGnli/RGAQiSHDtTcu2bmWAMQKp4PLAY7GzNDqgpNnthDNHnsXM1MpeHZ
         JHyHJ7oaT+HZ/w7YBLS0D/4Xu4dhVer3dh/nxOFsW5DsP4jCgS94M9JcGQJyn79+YAr5
         5KbM4T8FpChHAxoxESL3mKQOd26gYliBfe+pio6A0RfAYa+zFdjf8eZpl74S3+v25v/m
         1jH+oEMaDNFZDOg3wVFCHLUXZ5ZuZfZL2uXnQ+RF8yxoA83egjV5GNj/gW6TSvKoe2/S
         ESDmQ+eyEL2ptgkXCC2zYS17ndnoZav2CXxK0hnh4+iFz2V6z/YcySOPX/Ft8cziTpQ+
         egAg==
X-Gm-Message-State: AOJu0Yw/bwPDixl2r5MNNVNSHbDK1fkP65I2vm1GkQiF5gXaewJByxne
        pnkncE4YxMkSp9qRxsjy4nckTqarjbIjLFYU8fFtLqydo1k=
X-Google-Smtp-Source: AGHT+IFeDNun0jbczMBguhi4vC2OE09X8V4rGNUxwLvPcPy3WwqF+TlfKk9DH5Lvx0WqTuwjSyHGSgaGDCq/T53gXxk=
X-Received: by 2002:a67:eb46:0:b0:447:6901:a090 with SMTP id
 x6-20020a67eb46000000b004476901a090mr4476208vso.35.1692283306744; Thu, 17 Aug
 2023 07:41:46 -0700 (PDT)
MIME-Version: 1.0
References: <20230816152334.924960-1-amir73il@gmail.com> <20230817054446.961644-1-amir73il@gmail.com>
 <20230817-vagabunden-glatze-c30318a0ecc0@brauner> <CAOQ4uxhsyGwoOiTAegPmFBQiJmuhs_RZNzrb7L3gXLRxNmR3HA@mail.gmail.com>
 <20230817-anfechtbar-ruhelosigkeit-8c6cca8443fc@brauner>
In-Reply-To: <20230817-anfechtbar-ruhelosigkeit-8c6cca8443fc@brauner>
From:   Amir Goldstein <amir73il@gmail.com>
Date:   Thu, 17 Aug 2023 17:41:35 +0300
Message-ID: <CAOQ4uxigb+SYchPpXn325Sb4nU-7V=iXtrjeuwnk-nXoM3i82w@mail.gmail.com>
Subject: Re: [PATCH v3 0/4] fs: export __mnt_{want,drop}_write to modules
To:     Christian Brauner <brauner@kernel.org>
Cc:     Miklos Szeredi <miklos@szeredi.hu>, linux-unionfs@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <linux-unionfs.vger.kernel.org>
X-Mailing-List: linux-unionfs@vger.kernel.org

On Thu, Aug 17, 2023 at 5:32=E2=80=AFPM Christian Brauner <brauner@kernel.o=
rg> wrote:
>
> On Thu, Aug 17, 2023 at 04:55:55PM +0300, Amir Goldstein wrote:
> > On Thu, Aug 17, 2023 at 4:38=E2=80=AFPM Christian Brauner <brauner@kern=
el.org> wrote:
> > >
> > > On Thu, Aug 17, 2023 at 08:44:46AM +0300, Amir Goldstein wrote:
> > > > overlayfs is going to use those to grab a write reference on the
> > > > upper fs during copy up.
> > > >
> > > > Signed-off-by: Amir Goldstein <amir73il@gmail.com>
> > > > ---
> > > >
> > > > Christian,
> > > >
> > > > This patch is needed for the ovl_want_write() changes [1],
> > > > which I forgot to CC you on.
> > > >
> > > > Please ACK if you approve.
> > > >
> > > > Thanks,
> > > > Amir.
> > > >
> > > > [1] https://lore.kernel.org/linux-unionfs/20230816152334.924960-1-a=
mir73il@gmail.com/
> > > >
> > > >  fs/namespace.c | 2 ++
> > > >  1 file changed, 2 insertions(+)
> > > >
> > > > diff --git a/fs/namespace.c b/fs/namespace.c
> > > > index e157efc54023..370328b204f1 100644
> > > > --- a/fs/namespace.c
> > > > +++ b/fs/namespace.c
> > > > @@ -386,6 +386,7 @@ int __mnt_want_write(struct vfsmount *m)
> > > >
> > > >       return ret;
> > > >  }
> > > > +EXPORT_SYMBOL_GPL(__mnt_want_write);
> > >
> > > Puh, not excited about that but also no real reason to say no other t=
han
> > > generic worries about it being abused.
> > > But maybe let's not export underscore variants. Might make sense to a=
t
> > > least name them differently? mnt_want_write_locked()?
> >
> > Heh, it's not locked. It happens to be called with sb_start_write() fro=
m
> > mnt_want_write(), but from do_dentry_open() it's actually called *befor=
e*
> > file_start_write(), because the mnt_writers refcount and sb_writers loc=
k
> > are not strictly ordered, which is very convenient for ovl copy up.
> >
> > We could go for mnt_{get,put}_write(), but that's a bit close to
> > mnt_get_writers().
> >
> > We could go for mnt_{get,put}_write_access(), like helpers with similar
> > names for inode.
>
> Fine by me. I'm just not happy with this __*() thing.
>
> >
> > I don't really mind, as long as this doesn't become a bike shedding thi=
ng...
>
> So I brought all that paint for nothing?

LoL :)

I will take it as an ACK for exporting either mnt_{get,put}_write() or
mnt_{get,put}_write_access() symbols.

If no objections are raised I will go for the shorter option.

Thanks,
Amir.
