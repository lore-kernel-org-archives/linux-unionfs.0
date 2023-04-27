Return-Path: <linux-unionfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5B5CCC77B61
	for <linux-unionfs@archiver.kernel.org>; Thu, 27 Apr 2023 06:27:55 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242863AbjD0G1y (ORCPT
        <rfc822;linux-unionfs@archiver.kernel.org>);
        Thu, 27 Apr 2023 02:27:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38582 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232898AbjD0G1w (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Thu, 27 Apr 2023 02:27:52 -0400
Received: from mail-vs1-xe2f.google.com (mail-vs1-xe2f.google.com [IPv6:2607:f8b0:4864:20::e2f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8D2EC3C28
        for <linux-unionfs@vger.kernel.org>; Wed, 26 Apr 2023 23:27:51 -0700 (PDT)
Received: by mail-vs1-xe2f.google.com with SMTP id ada2fe7eead31-42e6ac0cd5aso2125765137.1
        for <linux-unionfs@vger.kernel.org>; Wed, 26 Apr 2023 23:27:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1682576870; x=1685168870;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=FzcSPnP3YMoc50rNG5ua+/AaIw5uO2pIIrpYJLlhxho=;
        b=bd9TrBEfmYU5iekOIjonV3hXxRSFx++p5JnBKAXbhgSGYJZLZLhMTUus7OB50muqlg
         LNtbVj70APw0WW/0CLdb7B8NmajFnVxNYPAkac6TNIAJ6pdbvNH5Xhg37LSm0UAKDvun
         QJf0EMraqqP3x9cqWsVB008v/wBcBndP7i1wI0UL3+gAsj4QGEWmWPCzFPQ1/9GbJKUF
         fZUKmstteu6kTw7UUOdv905qcXGG6wD9D5aQoRmA3d7GuivSWAIwO5XHkKhduTkkBdgz
         VDMBVzti+0NokN39J2GchU3VLa3FkAL2TR6Nj591CuQK+3IAr38IuX0IxF7y7Y/zY/nD
         PE7A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1682576870; x=1685168870;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=FzcSPnP3YMoc50rNG5ua+/AaIw5uO2pIIrpYJLlhxho=;
        b=U3eFBofH4DoJ5Qv+G6q1NRsaK2CPAhJLpoCaKgObLaGGiFBQdlQr50Y9KhznTDPqSP
         gCOOBDr4NF+a7Gny1REEqGa6lTZaftA0I1D8C+8f+rRnyfgBrmX5MOUBgte5zU0pZipx
         pUPwPCInW78xgDhFizx545fagUwumdxeWzRGdJYMA1CO9TmXKd5y4MW89vnKq+JdERAn
         GflhWIdYn1+2mxBPeAipIvJH4h/b/71YsqUvgFTNsijPCg29m+mAen6I5FPNxcT3LTtc
         KQGQcqGAJ24Ux/wOGtcfGb8dVGfUHM4WIQ9qvxptlVVjsAIut25rhLYuVc+jWHrvOLkZ
         xOAA==
X-Gm-Message-State: AC+VfDwipIJId2+Q2QefXDPDBGIBzQYWc/x59ngtzDt3DFz74AruujYh
        PVAncV9wI5YE7AkYT5ZVj0LmuLkWt2P4yGquwEnt+Qlmy5HxJA==
X-Google-Smtp-Source: ACHHUZ7N9IqSMdc5o/IxDi1V/cts9Ilk2be9C4bto7dhE8dEJLiwl5jEr3QNbFV3Oae8egvzk3acjOc0OC8PjaT+tsw=
X-Received: by 2002:a67:f782:0:b0:42e:6ac2:b19b with SMTP id
 j2-20020a67f782000000b0042e6ac2b19bmr312600vso.0.1682576870631; Wed, 26 Apr
 2023 23:27:50 -0700 (PDT)
MIME-Version: 1.0
References: <20230408164302.1392694-1-amir73il@gmail.com> <20230408164302.1392694-7-amir73il@gmail.com>
 <CAJfpegu_2u2f5UXi17xQV+6iMrDVzcHQ3A9f_WCK1Yjmsud+SA@mail.gmail.com>
In-Reply-To: <CAJfpegu_2u2f5UXi17xQV+6iMrDVzcHQ3A9f_WCK1Yjmsud+SA@mail.gmail.com>
From:   Amir Goldstein <amir73il@gmail.com>
Date:   Thu, 27 Apr 2023 09:27:39 +0300
Message-ID: <CAOQ4uxiA+x7APSmwvfAcAxqnPjOcaFdP9k0YiuWs+mZ4oKicAg@mail.gmail.com>
Subject: Re: [PATCH 6/7] ovl: deduplicate lowerpath and lowerstack[0]
To:     Miklos Szeredi <miklos@szeredi.hu>
Cc:     Alexander Larsson <alexl@redhat.com>, linux-unionfs@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <linux-unionfs.vger.kernel.org>
X-Mailing-List: linux-unionfs@vger.kernel.org

On Wed, Apr 26, 2023 at 3:07=E2=80=AFPM Miklos Szeredi <miklos@szeredi.hu> =
wrote:
>
> On Sat, 8 Apr 2023 at 18:43, Amir Goldstein <amir73il@gmail.com> wrote:
> >
> > For the common case of single lower layer, embed ovl_entry with a
> > single lower path in ovl_inode, so no stack allocation is needed.
>
> This makes ovl_inode grow by 8 bytes, right?

I can get rid of those extra bytes by stashing __numlower
inside the union with the LSB set to indicate an external stack.

> That's a win only in the numlower =3D 1 case,

That's a *very* common case (i.e. non-dir without lowerdata inode)

> in the other cases it's a net loss, so it might not
> be worth it even without the added complexity.
>

I guess this is an optimization that should be justified with a benchmark.
I'll drop it for now.

Thanks,
Amir.
