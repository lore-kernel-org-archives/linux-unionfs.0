Return-Path: <SRS0=xMZa=52=vger.kernel.org=linux-unionfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.6 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0A8F1C2BA2B
	for <linux-unionfs@archiver.kernel.org>; Fri, 10 Apr 2020 06:52:44 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id C76052084D
	for <linux-unionfs@archiver.kernel.org>; Fri, 10 Apr 2020 06:52:43 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="o8lBXqDH"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726007AbgDJGwm (ORCPT
        <rfc822;linux-unionfs@archiver.kernel.org>);
        Fri, 10 Apr 2020 02:52:42 -0400
Received: from mail-io1-f68.google.com ([209.85.166.68]:36960 "EHLO
        mail-io1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725844AbgDJGwm (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Fri, 10 Apr 2020 02:52:42 -0400
Received: by mail-io1-f68.google.com with SMTP id n20so891932ioa.4
        for <linux-unionfs@vger.kernel.org>; Thu, 09 Apr 2020 23:52:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=55sH5QivxiECEwi5EwfGRCCL/pnd97NBgFTV0Jfzoq8=;
        b=o8lBXqDHtn3cqiwXApeclcYQmDVzDQmD8raO3IYKm9uG9+Hzd4Zz3dW0o1DDi13xhU
         PQLobN3AfmP9ouuFiWm7uV/69pkAuJY4ah+yr+0fHVOsKV+z8oGBeUKx25AgNvp34lLC
         g2xgEx2bxdcAGECRwCLd92dCitvbPNtbrbWbFlrX4yls06DYtruhydKjhnD/K+gPhukM
         6vdX2dOk/G+WIw5z4TTYgzL89GfQixIV+3Vx91GAIwt7Z1W3ucKfhTw3pWpZG36j2Nyb
         f25qoqFe4ssMrNfTRQjooj2k3lSc4LLuQxvP9C/91q9sTwDkv57lhTM7Oq/hskCME1/d
         QGcA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=55sH5QivxiECEwi5EwfGRCCL/pnd97NBgFTV0Jfzoq8=;
        b=Sfven7B5JGs9UbfKnWkYCofKbbPgCuCnu/aMOrICM9GSWoZ7o4A9vXE3t8bEBqiL35
         hmxIGnx5buH5LfbtJ+5f7/b4DXOHNv44ZQCsbiUCkxG+UKj/OTXal+whHheSWHseXCCg
         55oVROdEe7eMsPkzcXxGwc8jBjPZNnh3RaX3cj9Bpjd8NfBjsP5rxgP+djjHvjQrQ4pY
         2XgpAwcdKPE587t8ReDtntFJSuHwS4/XufKu16FKDmMKAXv1/5WqYYeqBhjVHIMKwbxS
         Al96L95A08seLDjLS1B9PE6tun3YaIXpm411YxWWiEh09HuYj1JZXlysI82aJmYh/n0v
         5cbg==
X-Gm-Message-State: AGi0PuZUglK5vAyVGYZT5cKYiXHStpnI8DctdVqoIfX6BGsdoTbB9lFV
        WBlTxAfmwgbVfXsJ802I3Air92y8ZFI3F1qqGyHylg==
X-Google-Smtp-Source: APiQypIR0KQ8quQS4/jRZSZpSTjdTRcwiRxPw8jW7iv0IeHqvJVPe+9I6TG8lzQH0PySkeFyH+wXQdSJ0q1a1WFRAbI=
X-Received: by 2002:a02:b897:: with SMTP id p23mr3365223jam.120.1586501562537;
 Thu, 09 Apr 2020 23:52:42 -0700 (PDT)
MIME-Version: 1.0
References: <20200409163902.11404-1-amir73il@gmail.com> <20200409214926.GA144134@redhat.com>
In-Reply-To: <20200409214926.GA144134@redhat.com>
From:   Amir Goldstein <amir73il@gmail.com>
Date:   Fri, 10 Apr 2020 09:52:31 +0300
Message-ID: <CAOQ4uxh-MK2iVbS-uhZUm3enJxVhdO6Ch9sMDBZpKDW7zAHLuw@mail.gmail.com>
Subject: Re: [PATCH] ovl: resolve more conflicting mount options
To:     Vivek Goyal <vgoyal@redhat.com>
Cc:     Miklos Szeredi <miklos@szeredi.hu>,
        Chengguang Xu <cgxu519@mykernel.net>,
        overlayfs <linux-unionfs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-unionfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-unionfs.vger.kernel.org>
X-Mailing-List: linux-unionfs@vger.kernel.org

On Fri, Apr 10, 2020 at 12:49 AM Vivek Goyal <vgoyal@redhat.com> wrote:
>
> On Thu, Apr 09, 2020 at 07:39:02PM +0300, Amir Goldstein wrote:
> > Similar to the way that a conflict between metacopy=on,redirect_dir=off
> > is resolved, also resolve conflicts between nfs_export=on,index=off and
> > nfs_export=on,metacopy=on.
> >
> > An explicit mount option wins over a default config value.
> > Both explicit mount options result in an error.
> >
> > Without this change the xfstests group overlay/exportfs are skipped if
> > metacopy is enabled by default.
> >
> > Reported-by: Chengguang Xu <cgxu519@mykernel.net>
> > Signed-off-by: Amir Goldstein <amir73il@gmail.com>
> > ---
> >  Documentation/filesystems/overlayfs.rst |  7 ++--
> >  fs/overlayfs/super.c                    | 48 +++++++++++++++++++++++++
> >  2 files changed, 53 insertions(+), 2 deletions(-)
> >
> > diff --git a/Documentation/filesystems/overlayfs.rst b/Documentation/filesystems/overlayfs.rst
> > index c9d2bf96b02d..660dbaf0b9b8 100644
> > --- a/Documentation/filesystems/overlayfs.rst
> > +++ b/Documentation/filesystems/overlayfs.rst
> > @@ -365,8 +365,8 @@ pointed by REDIRECT. This should not be possible on local system as setting
> >  "trusted." xattrs will require CAP_SYS_ADMIN. But it should be possible
> >  for untrusted layers like from a pen drive.
> >
> > -Note: redirect_dir={off|nofollow|follow[*]} conflicts with metacopy=on, and
> > -results in an error.
> > +Note: redirect_dir={off|nofollow|follow[*]} and nfs_export=on mount options
> > +conflict with metacopy=on, and will result in an error.
> >
> >  [*] redirect_dir=follow only conflicts with metacopy=on if upperdir=... is
> >  given.
> > @@ -560,6 +560,9 @@ When the NFS export feature is enabled, all directory index entries are
> >  verified on mount time to check that upper file handles are not stale.
> >  This verification may cause significant overhead in some cases.
> >
> > +Note: the mount options index=off,nfs_export=on are conflicting and will
> > +result in an error.
> > +
> >
> >  Testsuite
> >  ---------
> > diff --git a/fs/overlayfs/super.c b/fs/overlayfs/super.c
> > index 732ad5495c92..fbd6207acdbf 100644
> > --- a/fs/overlayfs/super.c
> > +++ b/fs/overlayfs/super.c
> > @@ -470,6 +470,7 @@ static int ovl_parse_opt(char *opt, struct ovl_config *config)
> >       char *p;
> >       int err;
> >       bool metacopy_opt = false, redirect_opt = false;
> > +     bool nfs_export_opt = false, index_opt = false;
> >
> >       config->redirect_mode = kstrdup(ovl_redirect_mode_def(), GFP_KERNEL);
> >       if (!config->redirect_mode)
> > @@ -519,18 +520,22 @@ static int ovl_parse_opt(char *opt, struct ovl_config *config)
> >
> >               case OPT_INDEX_ON:
> >                       config->index = true;
> > +                     index_opt = true;
> >                       break;
> >
> >               case OPT_INDEX_OFF:
> >                       config->index = false;
> > +                     index_opt = true;
> >                       break;
> >
> >               case OPT_NFS_EXPORT_ON:
> >                       config->nfs_export = true;
> > +                     nfs_export_opt = true;
> >                       break;
> >
> >               case OPT_NFS_EXPORT_OFF:
> >                       config->nfs_export = false;
> > +                     nfs_export_opt = true;
> >                       break;
> >
> >               case OPT_XINO_ON:
> > @@ -552,6 +557,7 @@ static int ovl_parse_opt(char *opt, struct ovl_config *config)
> >
> >               case OPT_METACOPY_OFF:
> >                       config->metacopy = false;
> > +                     metacopy_opt = true;
>
> Hi Amir,
>
> I am wondering why metacopy_opt needs to be set for OPT_METACOPY_OFF case.
> In this case config->metacopy=false and it does not conflict with
> config->nfs_export at all. So there is no need to know if metacopy=off
> was specified as mount option or not.
>

It's true. We can drop that one.
I just liked it better that the meaning of the _opt vars are
"was this value set explicitly", even before we get to using it.

Thanks,
Amir.
