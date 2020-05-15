Return-Path: <SRS0=KPW4=65=vger.kernel.org=linux-unionfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.6 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1C4BDC433DF
	for <linux-unionfs@archiver.kernel.org>; Fri, 15 May 2020 08:42:43 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id C8D782054F
	for <linux-unionfs@archiver.kernel.org>; Fri, 15 May 2020 08:42:42 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=szeredi.hu header.i=@szeredi.hu header.b="Lwj7yc3C"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727998AbgEOImm (ORCPT
        <rfc822;linux-unionfs@archiver.kernel.org>);
        Fri, 15 May 2020 04:42:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36722 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1727927AbgEOIml (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Fri, 15 May 2020 04:42:41 -0400
Received: from mail-ed1-x544.google.com (mail-ed1-x544.google.com [IPv6:2a00:1450:4864:20::544])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 750C4C061A0C
        for <linux-unionfs@vger.kernel.org>; Fri, 15 May 2020 01:42:41 -0700 (PDT)
Received: by mail-ed1-x544.google.com with SMTP id h15so1562398edv.2
        for <linux-unionfs@vger.kernel.org>; Fri, 15 May 2020 01:42:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=szeredi.hu; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=B20IIqgVPN5EsJCsjMuXMwagsi+l/qnqtyAK/Hxxl78=;
        b=Lwj7yc3CLPjGQmlYTvBQB5aNkHaZ/QIaZTuSWArFVmjaAykhy83SZgUHcPxSsLLk2Q
         ieSqvIv2N/mZpP+rvFAtJUe0KDbDqG2xR1bME0yH49vVchjGnGollMSgvNbmMlKvU7Sp
         qd1lchhwW27PJjC2vBT9tJSt7ZTUGg1JO/9nQ=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=B20IIqgVPN5EsJCsjMuXMwagsi+l/qnqtyAK/Hxxl78=;
        b=LFXAG+Nqx7FXfDyXNiK9ztB/npQtSe63w0HJ1OS3sHN9jbkFOrHwT/tYcSUBFcd7R+
         TFUihW40ROmGLhK2vQvVWruuRo++0G9ppCZ3PPSLeWUmzcjMN/+Bg3Xu6LWDJM1KFzzr
         EKajZV0g7rfTEMgolbkFBMEh6E7KnZr+5VXb0/3uNJlDoU3fCuEraIn/JnDovNRChZU0
         gfHWUnHJt9AMqU3CPL1KSWwcqtS+RAkTPwAgpbtg4LGGG5LhSvjGAXPzzrZgQBT1xNIF
         4MOlygDoImtbRbXfa8VjZFPsCVNJJjzZaSJ4zKCi/E755/GyxMzn5KrfcEB1J/44nUz9
         6Tbw==
X-Gm-Message-State: AOAM531WaKm4Qj8hMaTFJHpVaGsDGl4OToYMGAqXcG1J0djs/DsvmeSn
        U4NJlsqv+DG0DkiMVbrafAYjcd3WNv5vsZGdpWeKdw==
X-Google-Smtp-Source: ABdhPJwdcrWF3G7Rq+qfYkIVbIazzm/I9qPrWKhfieUqOBMC9ltDEavfEhg2N/npBshJ4yLUirzpyxuS5OLN9w7sghw=
X-Received: by 2002:a50:d785:: with SMTP id w5mr1709907edi.212.1589532160099;
 Fri, 15 May 2020 01:42:40 -0700 (PDT)
MIME-Version: 1.0
References: <20200515072047.31454-1-cgxu519@mykernel.net> <CAOQ4uxhytw8YPY5WR+txeeHhuO+Hvr0eDFuKOahrN_htXtH_rA@mail.gmail.com>
 <17217706984.f5e20fe88512.8363313618084688988@mykernel.net>
In-Reply-To: <17217706984.f5e20fe88512.8363313618084688988@mykernel.net>
From:   Miklos Szeredi <miklos@szeredi.hu>
Date:   Fri, 15 May 2020 10:42:29 +0200
Message-ID: <CAJfpegvfEeDkBbgL0SXgZORkd2+eLaosNDG+_o=+qksyHcfurQ@mail.gmail.com>
Subject: Re: [RFC PATCH v3 0/9] Suppress negative dentry
To:     Chengguang Xu <cgxu519@mykernel.net>
Cc:     Amir Goldstein <amir73il@gmail.com>,
        Al Viro <viro@zeniv.linux.org.uk>,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>,
        overlayfs <linux-unionfs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: linux-unionfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-unionfs.vger.kernel.org>
X-Mailing-List: linux-unionfs@vger.kernel.org

On Fri, May 15, 2020 at 10:26 AM Chengguang Xu <cgxu519@mykernel.net> wrote=
:
>
>  ---- =E5=9C=A8 =E6=98=9F=E6=9C=9F=E4=BA=94, 2020-05-15 15:30:27 Amir Gol=
dstein <amir73il@gmail.com> =E6=92=B0=E5=86=99 ----
>  > On Fri, May 15, 2020 at 10:21 AM Chengguang Xu <cgxu519@mykernel.net> =
wrote:
>  > >
>  > > This series adds a new lookup flag LOOKUP_DONTCACHE_NEGATIVE
>  > > to indicate to drop negative dentry in slow path of lookup.
>  > >
>  > > In overlayfs, negative dentries in upper/lower layers are useless
>  > > after construction of overlayfs' own dentry, so in order to
>  > > effectively reclaim those dentries, specify LOOKUP_DONTCACHE_NEGATIV=
E
>  > > flag when doing lookup in upper/lower layers.
>  > >
>  > > Patch 1 adds flag LOOKUP_DONTCACHE_NEGATIVE and related logic in vfs=
 layer.
>  > > Patch 2 does lookup optimazation for overlayfs.
>  > > Patch 3-9 just adjusts function argument when calling
>  > > lookup_positive_unlocked() and lookup_one_len_unlocked().
>  >
>  > Hmm you cannot do that, build must not be broken mid series.
>  > When Miklos said split he meant to patch 1 and 2.
>  > Patch 1 must convert all callers to the new argument list,
>  > at which point all overlayfs calls are with 0 flags.
>  >
>  > Once that's done, you may add:
>  > Reviewed-by: Amir Goldstein <amir73il@gmail.com>
>  >
>
> OK, I got it, I'll still wait for a while in case of other feedbacks.
>
> Miklos, AI
>
> I'm not sure this series will go into whose tree in the end,
> so I just rebased on current linus-tree, any suggestion for the code base=
?

Linus' tree is a good base in this case.  I'm happier if VFS changes
go through Al's tree, but simple stuff can go through overlayfs tree
as well.

Thanks,
Miklos
