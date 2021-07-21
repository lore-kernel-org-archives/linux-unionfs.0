Return-Path: <linux-unionfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E680EC12002
	for <linux-unionfs@archiver.kernel.org>; Wed, 21 Jul 2021 14:17:16 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id C68C16044F
	for <linux-unionfs@archiver.kernel.org>; Wed, 21 Jul 2021 14:17:16 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238779AbhGUNgi (ORCPT
        <rfc822;linux-unionfs@archiver.kernel.org>);
        Wed, 21 Jul 2021 09:36:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52908 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238065AbhGUNga (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Wed, 21 Jul 2021 09:36:30 -0400
Received: from mail-il1-x136.google.com (mail-il1-x136.google.com [IPv6:2607:f8b0:4864:20::136])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 07E07C061575
        for <linux-unionfs@vger.kernel.org>; Wed, 21 Jul 2021 07:17:06 -0700 (PDT)
Received: by mail-il1-x136.google.com with SMTP id j5so2440208ilk.3
        for <linux-unionfs@vger.kernel.org>; Wed, 21 Jul 2021 07:17:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=4l0Uvl0BcA9Klerlrdtf0l346T9ClQhvn+LrV4l6XXc=;
        b=X+148DDZ/BIfmzbh/B6DSRURPNQyso0Swfqa1Vb+jVc73mTrrO5+wiDCdz2XNsWOcG
         VwmP3OTCWdnUsXldr074RROO+oKNTfAnDV6YFeRmiUtUNlIr+COWdi4Xnr3xovqdIFXc
         2qxmdPmOytDw8zaQ7maYtnhMA9VG9wE7uRWoAV4wKThgNuwe5hdat8lPBpiwKtPfftQf
         TSFJQahBw/d3WYmGzSCgCz2AiAw88z20pUHhD45Rpg3O29J6ew/5LejE1yHWzB5wEPpO
         diIkz2U6lbrPMifdHDDDLygjyR/3ShG3VzQl/c7vGWoa46yy22m0EialsyZ4xF/arOL9
         CPiQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=4l0Uvl0BcA9Klerlrdtf0l346T9ClQhvn+LrV4l6XXc=;
        b=frylGjlD6tV/HZa4llKIMoCxNg4IHkd5nJA1JgdRqIDKHvf4AQ/WB4m8G42uNH7pXJ
         BWRuk0oHfHXDLzmF9YKiMMQgWC+IGTy1npk8iuyHQZVVkci5MUAPxBpg69/IeXOo6NO6
         ZvHns3avWxvUTReIO2krylVI4UQf5KCragaoUa/BnR3tX6yhKIo+TL1zGnO+K1FxYnY/
         e9u5AcZYjEUAUrrX1Q/zyuFrX65OGgomd0FkpydWXeJF08K/zr+tzz5iWohiYFImvkwH
         D8Nxjk776zeAa084soUlK+8WDOLsWT7H+i5Jn+AETFKjZx5kEDyVpgaq2KNHoMkIitmQ
         bhHg==
X-Gm-Message-State: AOAM531k+A1TnhkYmfF0TY0iz4i/HnZ1eMEN/qXM136vfSz/7zZRVHot
        nfcXAv/yZ7WPnY18SA/y+dfok1MObWyEeWXKg80=
X-Google-Smtp-Source: ABdhPJwOEvcIaKO9GgKArEDO+PWoqJkgT2zs0VlR7I+2zRco8DuNZNQOLfm+cgxUhBKvj+oh3zq9HldH8ozdH6K8qRE=
X-Received: by 2002:a05:6e02:1c2d:: with SMTP id m13mr23891079ilh.137.1626877025439;
 Wed, 21 Jul 2021 07:17:05 -0700 (PDT)
MIME-Version: 1.0
References: <20210427102826.1189410-1-amir73il@gmail.com> <CAJfpegsxTjjBo08FfbuGqPPqrR71=c8SE97BiNyFnk-0D0Dgug@mail.gmail.com>
In-Reply-To: <CAJfpegsxTjjBo08FfbuGqPPqrR71=c8SE97BiNyFnk-0D0Dgug@mail.gmail.com>
From:   Amir Goldstein <amir73il@gmail.com>
Date:   Wed, 21 Jul 2021 17:16:52 +0300
Message-ID: <CAOQ4uxhWrnNC0DQzXbgwFQa2n0Jj5dQxV1hS3r88_0B-s6UeiQ@mail.gmail.com>
Subject: Re: [PATCH] ovl: relax lookup error on mismatch origin ftype
To:     Miklos Szeredi <miklos@szeredi.hu>
Cc:     Byron <ouyangxuan10@163.com>, Kevin Locke <kevin@kevinlocke.name>,
        overlayfs <linux-unionfs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-unionfs.vger.kernel.org>
X-Mailing-List: linux-unionfs@vger.kernel.org

On Wed, Jul 21, 2021 at 4:10 PM Miklos Szeredi <miklos@szeredi.hu> wrote:
>
> On Tue, 27 Apr 2021 at 12:28, Amir Goldstein <amir73il@gmail.com> wrote:
> >
> > We get occasional reports of lookup errors due to mismatched
> > origin ftype from users that re-format a lower squashfs image.
> >
> > Commit 13c6ad0f45fd ("ovl: document lower modification caveats")
> > tries to discourage the practice of re-formating lower layers and
> > describes the expected behavior as undefined.
> >
> > Commit b0e0f69731cd ("ovl: restrict lower null uuid for "xino=auto"")
> > limits the configurations in which origin file handles are followed.
> >
> > In addition to these measures, change the behavior in case of detecting
> > a mismatch origin ftype in lookup to issue a warning, not follow origin,
> > but not fail the lookup operation either.
> >
> > That should make overall more users happy without any big consequences.
> >
> > Link: https://lore.kernel.org/linux-unionfs/CAOQ4uxgPq9E9xxwU2CDyHy-_yCZZeymg+3n+-6AqkGGE1YtwvQ@mail.gmail.com/
> > Signed-off-by: Amir Goldstein <amir73il@gmail.com>
> > ---
> >
> > Miklos,
> >
> > I am getting tired of dealing with lower squashfs related reports.
> > How about this?
> >
> > It passes the xfstests quick tests and no, I do not have a reproducer
> > for origin mismatch, so will wait for Byron to test the patch.
>
> Pushed a simplified variant that just changes the
> ovl_check_origin_fh() return value from -EIO to -ESTALE.   Do you see
> a problem with this?
>

The only difference is if ovl_fh_to_dentry() also emits a warning,
but since ovl_check_origin_fh() already has a warning I think that
your simplified version is fine.

Thanks,
Amir.
