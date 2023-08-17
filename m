Return-Path: <linux-unionfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2ACA2C2FC2F
	for <linux-unionfs@archiver.kernel.org>; Thu, 17 Aug 2023 14:01:31 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1351628AbjHQOAz (ORCPT
        <rfc822;linux-unionfs@archiver.kernel.org>);
        Thu, 17 Aug 2023 10:00:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55068 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1351625AbjHQOA2 (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Thu, 17 Aug 2023 10:00:28 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CE5D72D62
        for <linux-unionfs@vger.kernel.org>; Thu, 17 Aug 2023 06:59:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1692280780;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=8Sf3gL19paNh1id1ZWjlPdqsF9TtKC5K9J5/RAfecMM=;
        b=C5jRW2fkXAF0m/gNUGhSpKP7r62gr36KQxI+sew+bDnbJNiUTuUK+9WGHQ6ia/r/a0vemv
        Cfw46W2NgSW+gsfQr8d01y+QT0dT3+7xleHmy/5kil0Yy/sUNFnlgGBbX8AS8roWs258cy
        5eT5t5+euRtQIGNWe0j8xiD5Q5dAvKk=
Received: from mail-il1-f199.google.com (mail-il1-f199.google.com
 [209.85.166.199]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-631-KvMtLC9iNgmEaH3JUokhQA-1; Thu, 17 Aug 2023 09:59:38 -0400
X-MC-Unique: KvMtLC9iNgmEaH3JUokhQA-1
Received: by mail-il1-f199.google.com with SMTP id e9e14a558f8ab-34a91e9e936so7935185ab.0
        for <linux-unionfs@vger.kernel.org>; Thu, 17 Aug 2023 06:59:38 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1692280777; x=1692885577;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=8Sf3gL19paNh1id1ZWjlPdqsF9TtKC5K9J5/RAfecMM=;
        b=NB4YEtw87Pkmihxq3mJyp316QSlKG+ZImx1h7joGoMd5pl9KlXm05A1D2oTJeBksma
         GZS4gyv6ihyBSRlmA+3qBiYt1Px2NpOjgWrYypKZgmgcUCDGuFm5yqjzoEnhg3Q7LOwL
         nnImGxWlUXLU1j9mQe6rXuP61aD5kQXNO49sISMxlTvZPUU9Z4oLmJlv8udHECIuub48
         EQcse1vscOXiSabeMs2UEM+xtsfMHuMhEV0pz1O43g3S9dA1U3BEzS+Mj4TNPVtD9q20
         E1qJ4vISHaQRNyCOkzen7HQIqvvahCN86gDalbxkbSEBIgk9Abdf3A+pNcpWCqJphARR
         n2FQ==
X-Gm-Message-State: AOJu0YyrklzyKY1VZif/zWhMW0f6KSpfsI1C5xxqgrodObmOVd1ZORmw
        ck9jSbZdcbv5TAcOYX7bH7fRImFi65+pKJ2HBNhHh2YuEy19A/47j+pyj0jAFzxJaDPf5kQ0anu
        AZ6L6GpYZPdMQ5Keu8zHaD2vkN+tEv9I7qK+JaM4pdZ7xzpZlvg==
X-Received: by 2002:a05:6e02:dc4:b0:349:8ea:9bd1 with SMTP id l4-20020a056e020dc400b0034908ea9bd1mr3609831ilj.7.1692280777506;
        Thu, 17 Aug 2023 06:59:37 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IFh4HIkqTYJyDyGZbf0Wu+uxDMLAWEFaxqDHPTVjsOI5MPR5NIBfG3iR6kU8jKC7rqVv9oakDym1kJ4nYa+5gg=
X-Received: by 2002:a05:6e02:dc4:b0:349:8ea:9bd1 with SMTP id
 l4-20020a056e020dc400b0034908ea9bd1mr3609817ilj.7.1692280777278; Thu, 17 Aug
 2023 06:59:37 -0700 (PDT)
MIME-Version: 1.0
References: <cover.1692270188.git.alexl@redhat.com> <6c4b8bd0bf0c234f630242034208eebfe2eff3a1.1692270188.git.alexl@redhat.com>
 <CAOQ4uxgy8tm3ZsST0saTxNFJqb-Jk44BWaX6UfCBhMgbGht8BA@mail.gmail.com>
In-Reply-To: <CAOQ4uxgy8tm3ZsST0saTxNFJqb-Jk44BWaX6UfCBhMgbGht8BA@mail.gmail.com>
From:   Alexander Larsson <alexl@redhat.com>
Date:   Thu, 17 Aug 2023 15:59:26 +0200
Message-ID: <CAL7ro1EetaMdH+fzsbBnnUNE4suNYhbRHRsF7QEfkYvJh1BvQw@mail.gmail.com>
Subject: Re: [PATCH v2 5/5] ovl: Add documentation on nesting of overlayfs mounts
To:     Amir Goldstein <amir73il@gmail.com>
Cc:     miklos@szeredi.hu, linux-unionfs@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <linux-unionfs.vger.kernel.org>
X-Mailing-List: linux-unionfs@vger.kernel.org

On Thu, Aug 17, 2023 at 3:31=E2=80=AFPM Amir Goldstein <amir73il@gmail.com>=
 wrote:
>
> On Thu, Aug 17, 2023 at 2:05=E2=80=AFPM Alexander Larsson <alexl@redhat.c=
om> wrote:
> >
> > Signed-off-by: Alexander Larsson <alexl@redhat.com>
> > ---
> >  Documentation/filesystems/overlayfs.rst | 22 ++++++++++++++++++++++
> >  1 file changed, 22 insertions(+)
> >
> > diff --git a/Documentation/filesystems/overlayfs.rst b/Documentation/fi=
lesystems/overlayfs.rst
> > index 35853906accb..e38b2f5fadaf 100644
> > --- a/Documentation/filesystems/overlayfs.rst
> > +++ b/Documentation/filesystems/overlayfs.rst
> > @@ -492,6 +492,28 @@ directory tree on the same or different underlying=
 filesystem, and even
> >  to a different machine.  With the "inodes index" feature, trying to mo=
unt
> >  the copied layers will fail the verification of the lower root file ha=
ndle.
> >
> > +Nesting overlayfs mounts
> > +------------------------
> > +
> > +It is possible to use a lower directory that is stored on an overlayfs
> > +mount. For regular files this does not need any special care. However,=
 files
> > +that have overlayfs attributes, such as whiteouts or `overlay.*` xattr=
s will
> > +be interpreted by the underlying overlayfs mount and stripped out. In =
order to
> > +allow the second overlayfs mount to see the attributes they must be es=
caped.
> > +
> > +Overlayfs specific xattrs are escaped by using a special prefix of
> > +`overlay.overlay.`. So, a file with a `trusted.overlay.overlay.metacop=
y` xattr
> > +in the lower dir will be exposed as a regular file with a
> > +`trusted.overlay.metacopy` xattr in the overlayfs mount. This can be n=
ested
> > +by repeating the prefix multiple time, as each instance only removes o=
ne
> > +prefix.
> > +
> > +Whiteouts files marked with a `overlay.nowhiteout` xattr will cause ov=
erlayfs
> > +not to treat them as a whiteout. Since this xattr is then stripped out=
, the
> > +next layer will instead apply the whiteout.
> > +
> > +Files created via overlayfs will automatically be created with the rig=
ht
> > +escapes in the upper directory.
> >
>
> I was wondering why you used `` around xattr names.
> Is that intentional? I am not an expert in rst format, but
> other places in this doc use "" around xattr names and it
> does not look like the formatting of `` is handled well by github at leas=
t:
> https://github.com/alexlarsson/linux/blob/ovl-nesting/Documentation/files=
ystems/overlayfs.rst

I guess I'm just too used to markdown. Will change to ".

--=20
=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D=
-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D
 Alexander Larsson                                Red Hat, Inc
       alexl@redhat.com         alexander.larsson@gmail.com

