Return-Path: <SRS0=qTYs=6B=vger.kernel.org=linux-unionfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.6 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F34D7C2D0EF
	for <linux-unionfs@archiver.kernel.org>; Fri, 17 Apr 2020 14:40:16 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id D049620936
	for <linux-unionfs@archiver.kernel.org>; Fri, 17 Apr 2020 14:40:16 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="dpQ61sMl"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726151AbgDQOkQ (ORCPT
        <rfc822;linux-unionfs@archiver.kernel.org>);
        Fri, 17 Apr 2020 10:40:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36950 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727957AbgDQOkP (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Fri, 17 Apr 2020 10:40:15 -0400
Received: from mail-il1-x144.google.com (mail-il1-x144.google.com [IPv6:2607:f8b0:4864:20::144])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4C05FC061A0C
        for <linux-unionfs@vger.kernel.org>; Fri, 17 Apr 2020 07:40:14 -0700 (PDT)
Received: by mail-il1-x144.google.com with SMTP id t8so2351919ilj.3
        for <linux-unionfs@vger.kernel.org>; Fri, 17 Apr 2020 07:40:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=PTogCGIijSQKmQXnGevxUguExuNkfcAzeEejEmDAcHY=;
        b=dpQ61sMlGV31cRB51ySfpUjrKThlpN79MMZGbBFRznyFYsre5nx+zgGKDPzoHZCwRZ
         Mtc7emN+/Zh+g3e0pT/wgN9sWeErppef2yrppY7Iwh2wtzF+++H92tpJG8B8zllfK3j8
         WXth7za297w15B5c2f74KJpwVPJGH96OLMcQXTk+BMcZh0Nib23Dg9AbyQZmoayQa1Zv
         hwEJoUWMt5qbD34Czl0I+YQ7w8lUM1A808Tsa2s0Uf1YZ8Lc2I8WbRSODtaCAiCC4IAJ
         RKXXgMdpPniLPNdkXHQwMWOIUOAftPQcEnM6f06j36EiqC9+vn00c35P8AXYZU4922fZ
         qL2A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=PTogCGIijSQKmQXnGevxUguExuNkfcAzeEejEmDAcHY=;
        b=IBFg+BwkvMiuKGtE+pNLnJRjutCsWcv2wdb9xsXYUSoiJZq7rHqsikEdZ5ihtFFSre
         oIQyF4XEni5cmlbRXiVCU0x+vMz3cxEjAzhkGn7qH2zOs8v67QUPQ1A5garWA+XwlzO/
         DYRuXbahnXfvAQwlWKTjmaME0YeFnWzxUzZ9+LAv5Hnj1ExPFxRfRxIgVSHFDFCqemDF
         FWIaVDppr6UeJtyS5c8T4vSHWnBqvLJlPXwPG3FHowmiOiA8BNS/zEbre75y7GLglmJx
         9qugnPwalE3kqj7Wz6OHE0wYmr0OU4B7/h59V9gh+kJlwk1nb9k+sFhDPM9HyTXe8fY6
         Kl3w==
X-Gm-Message-State: AGi0PuYqWND/CtriknSuaISWAGBVcSKvi3E26oONp/nVVM6pta70Ht6I
        BgVInYe9kf+GymfKx5grcgUaMz0YiTnyb2oouQ9PJQ==
X-Google-Smtp-Source: APiQypIWpptJP/BRmAM4wehHOGfyoyQQWzBp/ALCk0FyK8Idfa+VXUjafUhEa/uQq3ncgMbGYkLtSp5qqD4Ctey8LdQ=
X-Received: by 2002:a92:7e86:: with SMTP id q6mr3354075ill.9.1587134413559;
 Fri, 17 Apr 2020 07:40:13 -0700 (PDT)
MIME-Version: 1.0
References: <20200410082539.23627-1-amir73il@gmail.com> <20200410082539.23627-3-amir73il@gmail.com>
 <CAJfpegs046fyxCcQtYxdBYT8_dR5B_6aYugtwbnSS6zL7kYiJw@mail.gmail.com>
In-Reply-To: <CAJfpegs046fyxCcQtYxdBYT8_dR5B_6aYugtwbnSS6zL7kYiJw@mail.gmail.com>
From:   Amir Goldstein <amir73il@gmail.com>
Date:   Fri, 17 Apr 2020 17:40:02 +0300
Message-ID: <CAOQ4uxj8KdOnkz1xgj+S7WL9zK4ZgJeas5KBnPM=tCtJa_5Oog@mail.gmail.com>
Subject: Re: [PATCH 2/3] ovl: prepare to copy up without workdir
To:     Miklos Szeredi <miklos@szeredi.hu>
Cc:     Chengguang Xu <cgxu519@mykernel.net>,
        overlayfs <linux-unionfs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-unionfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-unionfs.vger.kernel.org>
X-Mailing-List: linux-unionfs@vger.kernel.org

On Fri, Apr 17, 2020 at 5:16 PM Miklos Szeredi <miklos@szeredi.hu> wrote:
>
> On Fri, Apr 10, 2020 at 10:25 AM Amir Goldstein <amir73il@gmail.com> wrote:
> >
> > With index=on, we copy up lower hardlinks to work dir and move them
> > into index dir. Fix locking to allow work dir and index dir to be the
> > same directory.
> >
> > Signed-off-by: Amir Goldstein <amir73il@gmail.com>
> > ---
> >  fs/overlayfs/copy_up.c | 8 ++++++--
> >  1 file changed, 6 insertions(+), 2 deletions(-)
> >
> > diff --git a/fs/overlayfs/copy_up.c b/fs/overlayfs/copy_up.c
> > index 9709cf22cab3..e523e63f604f 100644
> > --- a/fs/overlayfs/copy_up.c
> > +++ b/fs/overlayfs/copy_up.c
> > @@ -576,7 +576,7 @@ static int ovl_copy_up_workdir(struct ovl_copy_up_ctx *c)
> >         struct inode *udir = d_inode(c->destdir), *wdir = d_inode(c->workdir);
> >         struct dentry *temp, *upper;
> >         struct ovl_cu_creds cc;
> > -       int err;
> > +       int err = 0;
> >         struct ovl_cattr cattr = {
> >                 /* Can't properly set mode on creation because of the umask */
> >                 .mode = c->stat.mode & S_IFMT,
> > @@ -584,7 +584,11 @@ static int ovl_copy_up_workdir(struct ovl_copy_up_ctx *c)
> >                 .link = c->link
> >         };
> >
> > -       err = ovl_lock_rename_workdir(c->workdir, c->destdir);
> > +       /* Are we copying up to indexdir which is also workdir? */
> > +       if (c->indexed && c->workdir == c->destdir)
> > +               inode_lock_nested(wdir, I_MUTEX_PARENT);
> > +       else
> > +               err = ovl_lock_rename_workdir(c->workdir, c->destdir);
>
> This is confusing.  What about just
>
> if (!lock_rename(c->workdir, c->destdir))
>     return -EIO;
>
> ?

Sure. Simple.

Thanks,
Amir.
