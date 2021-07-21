Return-Path: <linux-unionfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3D63EC12002
	for <linux-unionfs@archiver.kernel.org>; Wed, 21 Jul 2021 14:46:33 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 1ADFD60D07
	for <linux-unionfs@archiver.kernel.org>; Wed, 21 Jul 2021 14:46:33 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238570AbhGUOFz (ORCPT
        <rfc822;linux-unionfs@archiver.kernel.org>);
        Wed, 21 Jul 2021 10:05:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59952 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232977AbhGUOFz (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Wed, 21 Jul 2021 10:05:55 -0400
Received: from mail-il1-x135.google.com (mail-il1-x135.google.com [IPv6:2607:f8b0:4864:20::135])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 60E86C061757
        for <linux-unionfs@vger.kernel.org>; Wed, 21 Jul 2021 07:46:31 -0700 (PDT)
Received: by mail-il1-x135.google.com with SMTP id w1so2490074ilg.10
        for <linux-unionfs@vger.kernel.org>; Wed, 21 Jul 2021 07:46:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=ZrL8gZoRxpsJ0Xmkzg/mZxjBoqtKgPvulR0K82zJQ7o=;
        b=d75E44JYADpoa14i//swycMOOGCq8+YYhOAdkbCPaQe4cidOgozND9QnyvsPky3jlS
         wsTGj8kSlIhMZjFp8Lw3hHlWVqqdJi5ATGFOSvxJWeWlOewUEVQnIB9Kwj23N2vinhXT
         zv8XHunV+5BUUbJLq89PGICf4CCcHfcB5R9OEDeEQFhmP4jHsS5wADyAyI33D2bjDFwZ
         6OxRBTpV+rd/DZYRwTVkQBYMD6wU9wk/pbmVMdtXz3lY9DBcm0te5XMZdK48+kJP4ifw
         pafawqEhM3+9doktvv7500QVSwLlYoeyaTWXx6G9aEXONy42C4rXPXHHEk+S2j+sk1ur
         PGGQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=ZrL8gZoRxpsJ0Xmkzg/mZxjBoqtKgPvulR0K82zJQ7o=;
        b=h0wsnsfnUpTIJ0eoohQtx9GSzt/yMBd6V8nU7H1/Mz94bJOYy9G9/4MZnff26siOEP
         SksvjIOrnBfVW/vB7YvK65rcYCn43LCw5Gdn2VGVprL9EtjOLm8NcGpFhH5FqMSbiCNG
         ycj920/xuDkVBDDB2sQg+dohCiWhbajHt3MPTZQFiCr1WzG4OiaQ3fCW65eyNOiFphQZ
         f074z9EX6SRn8xTuOWOHcjsWQMOpzFCt6I/lN3TySxRX2NnLr+W5i7JB+Ilw14gjC7OU
         WDlUtK24/6gpDb04WhgvKy4DYaR+ZU0hjgqHnNnh3/pUS83bOmYs963xPWANcHQY7ImZ
         cphQ==
X-Gm-Message-State: AOAM532SfnJ9Wbg7Im5csyXZJKR5cJiz4IuN3nrdYgXQ+DRjFzHNEGPF
        4GZ3AYtvyyUiIw/wFkoRoPuFmng8eRw5H8R1Ga0=
X-Google-Smtp-Source: ABdhPJwqo9TMQkjbOS7Fy3Xvjw0O8WKDbop8gxbrkmJ9S/DTX/xBivpjIOCQtFvAmfEDa8NGDuCZD8rqx/h7WufFHjA=
X-Received: by 2002:a05:6e02:1c2d:: with SMTP id m13mr23965876ilh.137.1626878790824;
 Wed, 21 Jul 2021 07:46:30 -0700 (PDT)
MIME-Version: 1.0
References: <20210427102826.1189410-1-amir73il@gmail.com> <CAJfpegsxTjjBo08FfbuGqPPqrR71=c8SE97BiNyFnk-0D0Dgug@mail.gmail.com>
 <CAOQ4uxhWrnNC0DQzXbgwFQa2n0Jj5dQxV1hS3r88_0B-s6UeiQ@mail.gmail.com> <CAJfpegvmNsWrgKc-=oO2zz2MQyLgk=orCzh0UMa9rY7s1U_iYQ@mail.gmail.com>
In-Reply-To: <CAJfpegvmNsWrgKc-=oO2zz2MQyLgk=orCzh0UMa9rY7s1U_iYQ@mail.gmail.com>
From:   Amir Goldstein <amir73il@gmail.com>
Date:   Wed, 21 Jul 2021 17:46:19 +0300
Message-ID: <CAOQ4uxiX+xQDcRVFc6L-tdPErizPkeq9SSf-+zz+5ygVQKeUig@mail.gmail.com>
Subject: Re: [PATCH] ovl: relax lookup error on mismatch origin ftype
To:     Miklos Szeredi <miklos@szeredi.hu>
Cc:     Byron <ouyangxuan10@163.com>, Kevin Locke <kevin@kevinlocke.name>,
        overlayfs <linux-unionfs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-unionfs.vger.kernel.org>
X-Mailing-List: linux-unionfs@vger.kernel.org

On Wed, Jul 21, 2021 at 5:33 PM Miklos Szeredi <miklos@szeredi.hu> wrote:
>
> On Wed, 21 Jul 2021 at 16:17, Amir Goldstein <amir73il@gmail.com> wrote:
> >
> > On Wed, Jul 21, 2021 at 4:10 PM Miklos Szeredi <miklos@szeredi.hu> wrote:
> > >
> > > On Tue, 27 Apr 2021 at 12:28, Amir Goldstein <amir73il@gmail.com> wrote:
> > > >
> > > > We get occasional reports of lookup errors due to mismatched
> > > > origin ftype from users that re-format a lower squashfs image.
> > > >
> > > > Commit 13c6ad0f45fd ("ovl: document lower modification caveats")
> > > > tries to discourage the practice of re-formating lower layers and
> > > > describes the expected behavior as undefined.
> > > >
> > > > Commit b0e0f69731cd ("ovl: restrict lower null uuid for "xino=auto"")
> > > > limits the configurations in which origin file handles are followed.
> > > >
> > > > In addition to these measures, change the behavior in case of detecting
> > > > a mismatch origin ftype in lookup to issue a warning, not follow origin,
> > > > but not fail the lookup operation either.
> > > >
> > > > That should make overall more users happy without any big consequences.
> > > >
> > > > Link: https://lore.kernel.org/linux-unionfs/CAOQ4uxgPq9E9xxwU2CDyHy-_yCZZeymg+3n+-6AqkGGE1YtwvQ@mail.gmail.com/
> > > > Signed-off-by: Amir Goldstein <amir73il@gmail.com>
> > > > ---
> > > >
> > > > Miklos,
> > > >
> > > > I am getting tired of dealing with lower squashfs related reports.
> > > > How about this?
> > > >
> > > > It passes the xfstests quick tests and no, I do not have a reproducer
> > > > for origin mismatch, so will wait for Byron to test the patch.
> > >
> > > Pushed a simplified variant that just changes the
> > > ovl_check_origin_fh() return value from -EIO to -ESTALE.   Do you see
> > > a problem with this?
> > >
> >
> > The only difference is if ovl_fh_to_dentry() also emits a warning,
> > but since ovl_check_origin_fh() already has a warning I think that
> > your simplified version is fine.
>
> Yeah, you are right, new version could have one less warning in the
> ->fh_to_dentry() case, but I agree that that should not be a problem.
>

Technically, there is also a change in vfs api in the error returned to
exportfs_decode_fh_raw(), but both callers seem to convert EINVAL
to ESTALE anyway...

Thanks,
Amir.
