Return-Path: <SRS0=fhJW=AU=vger.kernel.org=linux-unionfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BC72AC433E0
	for <linux-unionfs@archiver.kernel.org>; Thu,  9 Jul 2020 14:49:17 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 952EC20767
	for <linux-unionfs@archiver.kernel.org>; Thu,  9 Jul 2020 14:49:17 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="FcEWNO1M"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726662AbgGIOtR (ORCPT
        <rfc822;linux-unionfs@archiver.kernel.org>);
        Thu, 9 Jul 2020 10:49:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49808 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726517AbgGIOtR (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Thu, 9 Jul 2020 10:49:17 -0400
Received: from mail-io1-xd44.google.com (mail-io1-xd44.google.com [IPv6:2607:f8b0:4864:20::d44])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 11990C08C5CE
        for <linux-unionfs@vger.kernel.org>; Thu,  9 Jul 2020 07:49:17 -0700 (PDT)
Received: by mail-io1-xd44.google.com with SMTP id e64so2553498iof.12
        for <linux-unionfs@vger.kernel.org>; Thu, 09 Jul 2020 07:49:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=Gy5xDVRCQngZbcUxvxWB7yfT4qKC92xY/gaBTVZnkds=;
        b=FcEWNO1MscKnxB9jGYff5ghFZ3T5SL5FdBZivoE4vcmrob1rq/zRHG7ctyETfpdT+0
         SzLoIZB5sQmocfu+pzGxiIoplWgxL4n7eLwBFc4uPR66IFImaBaYWzIqptJX2/gptBIk
         89DQvAYzz3zl0s3lEWoTqF3I5VV+VLYU8xBHCexa0hTE+7olDfjK5yTEaKvcbdEX7HZv
         NwFP2ZlYoINYmLcWz4sgr+2aeoCQDaCYdS7pY7SfuPk64abKpxVJbsBwfDkQSTAjVwTJ
         lSG0449hnDBuuUc/yrNakb6Oxwt65yvb1y/UJTppV0bhlajWMktiaTeQXK3yluTzwfMw
         IG4g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=Gy5xDVRCQngZbcUxvxWB7yfT4qKC92xY/gaBTVZnkds=;
        b=t5eSn7k7I0FXe9OI4fU7hTd2/fbLiHtu7RKRhsu5UrrQ22/Q3ngOolfP6vyrJz6dct
         rRGEjBzsWbw/O8BTcg+Ml/+x4bOTOpyBi8cB9NEWvdE5GYeLdVXF1z3oLrngXHW6eqDS
         NcDTDDxzKTW3k5SjkXpWbfd46ceQyvPV8v5m5J7O5Yj5zpqbJDFK60/Ux1FZrne6QQx0
         KP+LXyBR6ttsxb7sVOS/Q+XA7IqJx1bes5+aLvDZN2HWETeTpToaFbVVEOoc/1UgXvmX
         yXSBro8qZ9lYmip6E3XMiVUfT6CeatuQaS1OU0OAlhT+VVWX3FmN/9UHhx1IPRHVh8RM
         +CGQ==
X-Gm-Message-State: AOAM530maTnlgbjDG5AOkJYFmCa8SyRPXgUEb8szkmZD1Vks4eBAHS+W
        lCoh96gWLhWzBFx9vmFZ/SK+xm+1eQtj5TnmU9g=
X-Google-Smtp-Source: ABdhPJwaap6B2Tar9grwRxC/4OKDyVsBB6KK5jCP8QUEpUr+Vv9i83gi/NVPDioDT/RStvaRk/J2q5Gu/iWvGq42KZA=
X-Received: by 2002:a02:c903:: with SMTP id t3mr54893659jao.30.1594306156463;
 Thu, 09 Jul 2020 07:49:16 -0700 (PDT)
MIME-Version: 1.0
References: <20200709140220.GC150543@redhat.com> <20200709141439.GD150543@redhat.com>
In-Reply-To: <20200709141439.GD150543@redhat.com>
From:   Amir Goldstein <amir73il@gmail.com>
Date:   Thu, 9 Jul 2020 17:49:05 +0300
Message-ID: <CAOQ4uxj2xw8PVk40xx91JemP1JCBkvnW_ndX_wU9ScpipBWaAg@mail.gmail.com>
Subject: Re: [PATCH] overlayfs, doc: Do not allow lower layer recreation with
 redirect_dir enabled
To:     Vivek Goyal <vgoyal@redhat.com>
Cc:     Miklos Szeredi <miklos@szeredi.hu>,
        overlayfs <linux-unionfs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-unionfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-unionfs.vger.kernel.org>
X-Mailing-List: linux-unionfs@vger.kernel.org

On Thu, Jul 9, 2020 at 5:14 PM Vivek Goyal <vgoyal@redhat.com> wrote:
>
> On Thu, Jul 09, 2020 at 10:02:20AM -0400, Vivek Goyal wrote:
> > Currently we seem to support lower layer recreation and re-use with existing
> > upper until and unless "index" or "metadata only copy up" feature is
> > enabled.
> >
> > If redirect_dir feature is enabled then re-creating/modifying lower layers
> > will break things. For example.
> >
> > - mkdir lower lower/foo upper work merged
> > - touch lower/foo/foo-child
> > - mount -t overlay -o lowerdir=lower,upperdir=upper,workdir=work,redirect_dir=on none merged
> > - mv merged/foo merged/bar
> > - ls merged/bar/ (this should list foo-child)
> >
> > - umount merged
> > - mv lower/foo lower/baz
> > - mount -t overlay -o lowerdir=lower,upperdir=upper,workdir=work,redirect_dir=on none merged
> > - ls merged/bar/  (Now foo-child has disappeared)
> >
> > IOW, modifying lower layers did not crash overlay but it resulted in
> > directory contents being lost and that can be unexpected. So don't
> > support lower layer recreation/modification when redirect_dir is enabled
> > at any point of time.

I don't understand why this has to do with redirect_dir.
The same text holds also if you do not do mv merged/foo merged/bar


> >
> > Signed-off-by: Vivek Goyal <vgoyal@redhat.com>
> > ---
> >  Documentation/filesystems/overlayfs.rst | 12 ++++++++----
> >  1 file changed, 8 insertions(+), 4 deletions(-)
> >
> > diff --git a/Documentation/filesystems/overlayfs.rst b/Documentation/filesystems/overlayfs.rst
> > index 660dbaf0b9b8..1d1a8da7fdbc 100644
> > --- a/Documentation/filesystems/overlayfs.rst
> > +++ b/Documentation/filesystems/overlayfs.rst
> > @@ -371,8 +371,8 @@ conflict with metacopy=on, and will result in an error.
> >  [*] redirect_dir=follow only conflicts with metacopy=on if upperdir=... is
> >  given.
> >
> > -Sharing and copying layers
> > ---------------------------
> > +Sharing, copying and recreating lower layers
> > +--------------------------------------------
> >
> >  Lower layers may be shared among several overlay mounts and that is indeed
> >  a very common practice.  An overlay mount may use the same lower layer
> > @@ -388,8 +388,12 @@ though it will not result in a crash or deadlock.
> >
> >  Mounting an overlay using an upper layer path, where the upper layer path
> >  was previously used by another mounted overlay in combination with a
> > -different lower layer path, is allowed, unless the "inodes index" feature
> > -or "metadata only copy up" feature is enabled.
> > +different lower layer path, is allowed, unless any of the following features
> > +is enabled at any point of time.
> > +
> > +- inode index
> > +- metadata only copy up
> > +- redirect_dir
>
> I probably should add "nfs_export" to the list as well. Though it is
> implicitly there as enabling nfs export requires to enable index. But
> saying it explicitly is even better.
>

Ok you can mention it but xino is also relevant.
I wonder if we should define "legacy mode" where no options expect for
lowerdir,upperdir,workdir,default_permissions are provided

Thanks,
Amir.
