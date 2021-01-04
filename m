Return-Path: <linux-unionfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5E4CCC433E0
	for <linux-unionfs@archiver.kernel.org>; Mon,  4 Jan 2021 09:01:57 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 2B1FE207AE
	for <linux-unionfs@archiver.kernel.org>; Mon,  4 Jan 2021 09:01:57 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726616AbhADJB4 (ORCPT
        <rfc822;linux-unionfs@archiver.kernel.org>);
        Mon, 4 Jan 2021 04:01:56 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36902 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726605AbhADJB4 (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Mon, 4 Jan 2021 04:01:56 -0500
Received: from mail-io1-xd31.google.com (mail-io1-xd31.google.com [IPv6:2607:f8b0:4864:20::d31])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5E52FC061574
        for <linux-unionfs@vger.kernel.org>; Mon,  4 Jan 2021 01:01:16 -0800 (PST)
Received: by mail-io1-xd31.google.com with SMTP id z5so24348443iob.11
        for <linux-unionfs@vger.kernel.org>; Mon, 04 Jan 2021 01:01:16 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=Uvq88wtPwG6uKik5pCRJAlJzcqo0Xjc4ACJxkzN3HcY=;
        b=pYTDYjtZLbwaap28DDFw7G8VNCuyM4J3d7TpInq7U5PDxFa26Z4MM+gnzKcrPLaWEL
         JGp6TwSvFUbxI2uqV11XOmy5aUBnwD7rq4aer5U3eqVtNvpDkFaJLdbwPDM2wFiyF3H8
         O/VlBmuJEmWkBAIkoBCeomgYrOTLBjBlxjW4AnA14Q8QSsfoWrKIjmcjTZVZale1Kv2v
         yXSYgSKU7qBDe4XGG8iNChouqzYlbjNFcKcMwO0Iqjo4ZBQChH5qBhotOsxsUtI8O0kr
         EOQ8cToC/VSQPvniPRAzFpHdVYCAOq/W4k9sQ4N9fNB05AY2nEN933upp4RX5I36Nq+P
         rJhw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=Uvq88wtPwG6uKik5pCRJAlJzcqo0Xjc4ACJxkzN3HcY=;
        b=Z/jvliJvDQ+nSOKJ7ipClSu4X4Ll6NEbM7rDoV3VU1PMvxkxHSAeurCvGSEcucuiCm
         WQr1XtZoFcWr1w+MSHxrRy3oG0M8pg+XAgNK/gf+jN7Z7RCHAh0XQdmU2EmtmcUrvz/9
         0aViwMZjrhIj2AVu9KbfDGDaykZWXe3w/wBgRE0MJ6rm5mN8u2cC91uHxtxMooBdCaB4
         HR/7xAw1ZJxwB64108rKJR6ZpoFEQI3ZVm+3a7R2O6zCCBwyLUBycczxOxGC1Qb6klNk
         BRZxwSouGq14Czn7fCGftksCjV3krwgYacHZVnVCQoviuldH8eH1MZ5wWAcIwAwetVVy
         lyoQ==
X-Gm-Message-State: AOAM531j+sodR9BuTmYwVOInp/vrblvhvDnE0GE7mTJjbqwQzZyMswEl
        YipgA9KWaac8fRcK1im5Z7ZrgvS+BwE4EcOaAkfDHijBSPM=
X-Google-Smtp-Source: ABdhPJwGCrtw3obVhE50ueZP9fblAxKMqdJZ1k4Ih9q7Ofnt6E4jfU37R97FWrVTn+Ew6jk3Bg8MqEMHadiGla6A3LE=
X-Received: by 2002:a02:a60a:: with SMTP id c10mr60296996jam.123.1609750875712;
 Mon, 04 Jan 2021 01:01:15 -0800 (PST)
MIME-Version: 1.0
References: <20201226104618.239739-1-cgxu519@mykernel.net> <CAOQ4uxhn1q4ZcW+GgNxLwcSwhQxrQJibPhX8xO2YsbS1et6YiQ@mail.gmail.com>
 <176cc2dcd40.107ad48cf41153.6757897875754439646@mykernel.net>
In-Reply-To: <176cc2dcd40.107ad48cf41153.6757897875754439646@mykernel.net>
From:   Amir Goldstein <amir73il@gmail.com>
Date:   Mon, 4 Jan 2021 11:01:04 +0200
Message-ID: <CAOQ4uxh8DbdpDD6KUuEHaxHc3fGWgeSGdb8hXF45KKibyOf0Vw@mail.gmail.com>
Subject: Re: [RFC PATCH] ovl: keep some file attrubutions after copy-up
To:     Chengguang Xu <cgxu519@mykernel.net>
Cc:     Miklos Szeredi <miklos@szeredi.hu>,
        overlayfs <linux-unionfs@vger.kernel.org>,
        Vivek Goyal <vgoyal@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <linux-unionfs.vger.kernel.org>
X-Mailing-List: linux-unionfs@vger.kernel.org

On Mon, Jan 4, 2021 at 8:55 AM Chengguang Xu <cgxu519@mykernel.net> wrote:
>
>  ---- =E5=9C=A8 =E6=98=9F=E6=9C=9F=E4=B8=80, 2021-01-04 13:04:56 Amir Gol=
dstein <amir73il@gmail.com> =E6=92=B0=E5=86=99 ----
>  > On Sat, Dec 26, 2020 at 12:48 PM Chengguang Xu <cgxu519@mykernel.net> =
wrote:
>  > >
>  > > Currently after copy-up, upper file will lose most of file
>  > > attributions except copy-up triggered by setting fsflags.
>  > > Because ioctl operation of underlying file systems does not
>  > > expect calling from kernel component, it seems hard to
>  > > copy fsflags during copy-up.
>  > >
>  > > Overlayfs keeps limited attributions(append-only, etc) in it's
>  > > inode flags after successfully updating attributions. so ater
>  > > copy-up, lsattr(1) does not show correct result but overlayfs
>  > > can still prohibit ramdom write for those files which originally
>  > > have append-only attribution. However, recently I found this
>  > > protection can be easily broken in below operations.
>  > >
>  > > 1, Set append attribution to lower file.
>  > > 2, Mount overlayfs.
>  > > 3, Trigger copy-up by data append.
>  > > 4, Set noatime attributtion to the file.
>  > > 5, The file is random writable.
>  > >
>  > > This patch tries to keep some file attributions after copy-up
>  > > so that overlayfs keeps compatible behavior with local filesystem
>  > > as much as possible.
>  > >
>  >
>  > This approach seems quite wrong.
>  > For one thing, mount cycle overlay or drop caches will result in loss
>  > of append only flag after copy-up, so this is not a security fix.
>  >
>
> You are right, I overlooked the case of dropping cache.
>
>  > Second, Miklos has already proposed a much more profound change
>  > to address this and similar issues [1] and he has already made some
>  > changes to ioctl handler to master doesn't have ovl_iflags_to_fsflags(=
).
>  >
>  > [1] https://lore.kernel.org/linux-fsdevel/20201123141207.GC327006@miu.=
piliscsaba.redhat.com/
>  >
>  > One more thing.
>  > It seems like ovl_copyflags() in ovl_inode_init() would have been bett=
er
>  > to copy from ovl_inode_realdata() inode instead of ovl_inode_real().
>  > This way, copy up still loses the append-only flag, but metacopy up
>  > does not. So at least for the common use case of containers that
>  > chown -R won't cause losing all the file flags.
>
> IIUC, the flags will still keep in overlayfs' inode after copy up until
> the inode cleaned by dropping cache. So I think your suggestion will be
> helpful for the case of meta-copyup & dropping cache.

Yes, for the use case of chowning all files sure cannot rely on caches
and I believe those containers are also used as persistent containers
that can be mounted again later after initial ownership fix.

>
> Hi Miklos
>
> Is it worth to change like above?
>

I guess that depends what are the use cases that benefit.
After all it is not a security fix it just increases the amount of
use cases that preserve the append-only flag.

I *think* it could fix a lot of cases like:
chmod foo; drop_caches; touch foo # should fail
mv foo bar; drop_caches; touch bar # should fail

and in order to lose the append-only flag, users will need to
first open with O_APPEND, set noatime flag or some unusual
operations that do not happen by mistake as often as chmod,chown,rename.

>
>  >
>  > ovl_ioctl_set_flags() triggers data copy up, so that will break the li=
nk
>  > to lower flags anyway.
>
> I think though ovl_ioctl_set_flags() triggers data copy up but the flags
> will be set correctly to upper file, because chattr(1) will get the flags
> first and set the whole flags(include original flags) to upper file.
>

Sure, unless the user is not privileged to set flags, but copy up will stil=
l
happen. But what I meant is if user changes the flags, data copy up
happens and ovl_copyflags() after drop caches will no longer copy the
lower flags.

Thanks,
Amir.
