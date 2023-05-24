Return-Path: <linux-unionfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B595FC77B7C
	for <linux-unionfs@archiver.kernel.org>; Wed, 24 May 2023 17:14:22 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229742AbjEXROU (ORCPT
        <rfc822;linux-unionfs@archiver.kernel.org>);
        Wed, 24 May 2023 13:14:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36590 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236470AbjEXRNr (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Wed, 24 May 2023 13:13:47 -0400
Received: from mail-vk1-xa2a.google.com (mail-vk1-xa2a.google.com [IPv6:2607:f8b0:4864:20::a2a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A528A10D7
        for <linux-unionfs@vger.kernel.org>; Wed, 24 May 2023 10:13:02 -0700 (PDT)
Received: by mail-vk1-xa2a.google.com with SMTP id 71dfb90a1353d-4572fc80fe2so833647e0c.1
        for <linux-unionfs@vger.kernel.org>; Wed, 24 May 2023 10:13:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1684948338; x=1687540338;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=OTA+XIW7LOtcolKXZyg9zOBYBTvElXQ/8g9Ut9eeWoY=;
        b=jZh6p6svW57n0ujnGq5e9cWDI7mGGxLnsdxvB5riUO0wl/P8rSGa62RsQJu/lt4lbV
         vPOHuBQO4wBXrWffvKVEFRIV3JDNro6SsxkuQQ/BxNboZMvsGs99vGsK2eA8S+g4dT4I
         cSchgRXsNgRINwrO0mdgmI8TK4nL1z+XfsMvuMiZGBeU7YTzPDj/0IT872mUmoXExdkz
         gCKqCA2LQm4KXyrgxPqd2GDxkoHTSvBMLjnqE5vCl3o4ZO71yYRwXBYo4C304Yzmbl1X
         zVczYGYhXxBtHMDrH1ezIyuQKddyhZ8sZaBdILkwHU5KJ95Jr1KDjq8/N351yUS8S10r
         Przg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1684948338; x=1687540338;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=OTA+XIW7LOtcolKXZyg9zOBYBTvElXQ/8g9Ut9eeWoY=;
        b=YD0qyfFuNr+CP0cXVQVeV5JNspo1tVp2456xUzXNoEc8Ak0WV4zmYqBXbF0nBfM88w
         tRjx1tEndzfDMvG6vtv1UIxI6n5QVQUPmK0kE6KN2OJlMouuIM2Iudx7A95ozwrSTyhz
         9Qfdta7StblKUyIxEVo7PiKEGvBK/0T8X8ZAQZhYNMP+Fkc/tp60qDWF0XFoXFmDrVOx
         5m89Cj0zpg8ni+sfkXlxNkGqjAO09L8LYz0E2o43gmWF0hGgpzX4uAZLsUctDqH2t6ll
         C0C1+GNUhnbuywUnrXDcxXxwKyh8H7G6mKcfz1KJfa66f6+kQEqVC1a9uKgQti8+/wEA
         tVGg==
X-Gm-Message-State: AC+VfDx1mKO8kq6bk4aiUYVBLEaM74zS7CxTfQZf3D57zRH0/ddDs6Zt
        A2w6YmqETnIBjwXsTEXk71HOJe3ovZpcX90tNqFaiIJzo+w=
X-Google-Smtp-Source: ACHHUZ7FDh0rNK0hLz0stYcyqr7tah7dhYgQqjDQg7MxLVD+tb3P1lvcuzfOnR8N2C+OvYyv3mTm2N29dJoZh7uFOsw=
X-Received: by 2002:a05:6102:2849:b0:42c:3457:6718 with SMTP id
 az9-20020a056102284900b0042c34576718mr5378039vsb.5.1684948338322; Wed, 24 May
 2023 10:12:18 -0700 (PDT)
MIME-Version: 1.0
References: <20230427130539.2798797-1-amir73il@gmail.com>
In-Reply-To: <20230427130539.2798797-1-amir73il@gmail.com>
From:   Amir Goldstein <amir73il@gmail.com>
Date:   Wed, 24 May 2023 20:12:07 +0300
Message-ID: <CAOQ4uxiT1dmnUiFhthQ+Yd_2s8OCYRFxCaJtezHTBahnJe-syQ@mail.gmail.com>
Subject: Re: [PATCH v2 00/13] Overlayfs lazy lookup of lowerdata
To:     Miklos Szeredi <miklos@szeredi.hu>
Cc:     Alexander Larsson <alexl@redhat.com>, linux-unionfs@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <linux-unionfs.vger.kernel.org>
X-Mailing-List: linux-unionfs@vger.kernel.org

On Thu, Apr 27, 2023 at 4:05=E2=80=AFPM Amir Goldstein <amir73il@gmail.com>=
 wrote:
>
> Miklos,
>
> This v2 combines the prep patch set [1] and lazy lookup patch set [2].
>
> This work is motivated by Alexander's composefs use case.
> Alexander has been developing and testing his fsverity patches over
> my lazy-lowerdata-lookup branch [3].

FYI, I rebased this branch on top of v6.4-rc2 and on top
of branch ovl-fixes with the NULL pointer defer fix patches
from Zhihao Cheng:

https://lore.kernel.org/linux-unionfs/20230516141619.2160800-1-chengzhihao1=
@huawei.com/

Thanks,
Amir.

>
> Alexander has also written tests for lazy lowerdata lookup [4].
>
> Note that patch #1 is a Fixes patch for stable.
> Gao commented that the fix may not be complete, but I think it is better
> than no fix at all.
>
> Regarding lazy lookup in d_real(), I am not sure if the best effort
> lookup is the best solution, but in any case, none of this code kicks in
> without explicit opt-in to data-only layers, so the risk of breaking
> existing setups is quite low.
>
> Thanks,
> Amir.
>
> Changes since v1:
> - Include the prep patch set
> - Split remove lowerdata from add lowerdata_redirect patch
> - Remove embedded ovl_entry stack optimization
> - Add lazy lookup and comment in d_real_inode()
> - Improve documentation of :: data-only layers syntax
> - Added RVBs
>
> [1] https://lore.kernel.org/linux-unionfs/20230408164302.1392694-1-amir73=
il@gmail.com/
> [2] https://lore.kernel.org/linux-unionfs/20230412135412.1684197-1-amir73=
il@gmail.com/
> [3] https://github.com/amir73il/linux/commits/ovl-lazy-lowerdata
> [4] https://github.com/amir73il/xfstests/commits/ovl-lazy-lowerdata
>
> Amir Goldstein (13):
>   ovl: update of dentry revalidate flags after copy up
>   ovl: use OVL_E() and OVL_E_FLAGS() accessors
>   ovl: use ovl_numlower() and ovl_lowerstack() accessors
>   ovl: factor out ovl_free_entry() and ovl_stack_*() helpers
>   ovl: move ovl_entry into ovl_inode
>   ovl: deduplicate lowerpath and lowerstack[]
>   ovl: deduplicate lowerdata and lowerstack[]
>   ovl: remove unneeded goto instructions
>   ovl: introduce data-only lower layers
>   ovl: implement lookup in data-only layers
>   ovl: prepare to store lowerdata redirect for lazy lowerdata lookup
>   ovl: prepare for lazy lookup of lowerdata inode
>   ovl: implement lazy lookup of lowerdata in data-only layers
>
>  Documentation/filesystems/overlayfs.rst |  36 +++++
>  fs/overlayfs/copy_up.c                  |  11 ++
>  fs/overlayfs/dir.c                      |   3 +-
>  fs/overlayfs/export.c                   |  41 +++---
>  fs/overlayfs/file.c                     |  21 ++-
>  fs/overlayfs/inode.c                    |  38 +++--
>  fs/overlayfs/namei.c                    | 185 +++++++++++++++++++-----
>  fs/overlayfs/overlayfs.h                |  20 ++-
>  fs/overlayfs/ovl_entry.h                |  73 ++++++++--
>  fs/overlayfs/super.c                    | 132 ++++++++++-------
>  fs/overlayfs/util.c                     | 165 ++++++++++++++++-----
>  11 files changed, 534 insertions(+), 191 deletions(-)
>
> --
> 2.34.1
>
