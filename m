Return-Path: <SRS0=ksQV=7Q=vger.kernel.org=linux-unionfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.6 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3B74EC433DF
	for <linux-unionfs@archiver.kernel.org>; Wed,  3 Jun 2020 07:59:32 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 0C7B0206C3
	for <linux-unionfs@archiver.kernel.org>; Wed,  3 Jun 2020 07:59:32 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=szeredi.hu header.i=@szeredi.hu header.b="KmfZkJDv"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725888AbgFCH7c (ORCPT
        <rfc822;linux-unionfs@archiver.kernel.org>);
        Wed, 3 Jun 2020 03:59:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52086 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725881AbgFCH7b (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Wed, 3 Jun 2020 03:59:31 -0400
Received: from mail-ed1-x541.google.com (mail-ed1-x541.google.com [IPv6:2a00:1450:4864:20::541])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3D73EC05BD43
        for <linux-unionfs@vger.kernel.org>; Wed,  3 Jun 2020 00:59:31 -0700 (PDT)
Received: by mail-ed1-x541.google.com with SMTP id x93so924989ede.9
        for <linux-unionfs@vger.kernel.org>; Wed, 03 Jun 2020 00:59:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=szeredi.hu; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=cJG7zYTZoLhg274htUD7xXI8Lfe/gduTiU48DN7Z3Ng=;
        b=KmfZkJDvS6MGC9+WhubJ29eMI+kR/TqufMOfWsk1fUDVORaV9KyUA8ajZA9TJZY+kE
         Faen+P21YGSCMdEeB9m50LTlF67rfioLbsG/JGmMxgN9csM1+srkf5ZNJtdExeeGHa+N
         4qpBBCidgCqPfJpKXY8/uj+AbRnT1gknX6VEk=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=cJG7zYTZoLhg274htUD7xXI8Lfe/gduTiU48DN7Z3Ng=;
        b=aZdVgjMuiinGDUkae4OV4MLrBu5L5Of/EFd1XPp5dRwFAWp0mjIjZSJ+mi7jvprdBN
         3FByPGP7jWLva37OMyaKN0oeTS0ETMI27HXVMyLMm5ru6moLIeyV/xLqUi78QONQrcMd
         qOC4x73BsXuZKNHeCxLQuqKkOfWTccUb98G5gRCFkaUD4JnlMWHUh5M6ei6a/q8jdT1S
         6Z3Z3EtG5N6fFsj0wQxlGUElWmCbDnxbecw1hMDlZLm+gqaAOnuijwlcWl7B8xB5asgx
         n/2KzWOZDONoFqjecOtSPFhjYBghSA1pM3dJlMkKoDd7JsYAMioZPfNVH2ZCgD6ppplk
         TFrg==
X-Gm-Message-State: AOAM533prKknVkHjU+Q8ahEqLe1xzQ0RMiJss1HYy/JqDoeOOdauTQ0H
        UXlLz9Ls/H/WO3VQJqJY1gxLmqVocW4MvUuMgW+yIg==
X-Google-Smtp-Source: ABdhPJyuUie1RCgWYVD+wbSU201LavnZX3OBHeloxL/MlbZSZf85/otb+JCZHdLphwfoMPC/+o7re16bTJ6AYl+yU4Y=
X-Received: by 2002:a50:d499:: with SMTP id s25mr14950562edi.161.1591171170021;
 Wed, 03 Jun 2020 00:59:30 -0700 (PDT)
MIME-Version: 1.0
References: <20200601155652.17486-1-vgoyal@redhat.com> <a2f863af-6674-e148-181c-4fb5aca68885@huawei.com>
In-Reply-To: <a2f863af-6674-e148-181c-4fb5aca68885@huawei.com>
From:   Miklos Szeredi <miklos@szeredi.hu>
Date:   Wed, 3 Jun 2020 09:59:18 +0200
Message-ID: <CAJfpegt5-hOM5AugzB3L9_EoUS2AEq_Nfu64r08wgK9acBAPEA@mail.gmail.com>
Subject: Re: [PATCH v2 0/3] overlayfs: Do not check metacopy in ovl_get_inode()
To:     yangerkun <yangerkun@huawei.com>
Cc:     Vivek Goyal <vgoyal@redhat.com>,
        Amir Goldstein <amir73il@gmail.com>,
        overlayfs <linux-unionfs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: linux-unionfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-unionfs.vger.kernel.org>
X-Mailing-List: linux-unionfs@vger.kernel.org

On Wed, Jun 3, 2020 at 9:13 AM yangerkun <yangerkun@huawei.com> wrote:
>
> Try repeat this testcase for about half of a day. Wont happen again.
>
> Thanks,
>
> =E5=9C=A8 2020/6/1 23:56, Vivek Goyal =E5=86=99=E9=81=93:
> > Hi,
> >
> > This is V2 of the patches. Took care of few suggestions from Amir.
> >
> > This series tries to implement Amir's suggestion of initializing
> > OVL_UPPERDATA in callers of ovl_get_inode() and move checking of
> > metacopy xattr out of ovl_get_inode().
> >
> > It also has to patches to cleanup metacopy logic a bit and make it
> > little more readable and understandable in ovl_lookup().
> >
> > yangerkun, can you please make sure if this patch series fixes the
> > xfstest issue you were facing once in a while.

Thanks to everyone for the fix.  Applied.

Miklos
