Return-Path: <linux-unionfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6B26FC7EE29
	for <linux-unionfs@archiver.kernel.org>; Thu, 25 May 2023 15:22:32 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241309AbjEYPWb (ORCPT
        <rfc822;linux-unionfs@archiver.kernel.org>);
        Thu, 25 May 2023 11:22:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56704 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241186AbjEYPW3 (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Thu, 25 May 2023 11:22:29 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 81E2F19A
        for <linux-unionfs@vger.kernel.org>; Thu, 25 May 2023 08:21:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1685028096;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=9jcrtP1xHu1msENXKazIP4DyVQkJLfmcc3PtFdmyyDo=;
        b=afPcPwfwK75+YpAb7q4wcLQIqrIr1Z4PdPyB96huzXeE1NYn6GnR4feyH5AvAl9gC+3OYP
        FyTwbdNH4fz49Ad4kYNLGk72OoqKHrpjrSvH/pLBOMYzz+cQKsACP9sJyQj3hb3Tqfy0uo
        8BHt2GxUXpyswQx4N4LX1NcMp3QpAWo=
Received: from mail-il1-f200.google.com (mail-il1-f200.google.com
 [209.85.166.200]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-540-Zu9xq9HfMym3TPFHsyCt7w-1; Thu, 25 May 2023 11:21:35 -0400
X-MC-Unique: Zu9xq9HfMym3TPFHsyCt7w-1
Received: by mail-il1-f200.google.com with SMTP id e9e14a558f8ab-33859d4a322so40870175ab.1
        for <linux-unionfs@vger.kernel.org>; Thu, 25 May 2023 08:21:35 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1685028094; x=1687620094;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=9jcrtP1xHu1msENXKazIP4DyVQkJLfmcc3PtFdmyyDo=;
        b=PUCz3gPiO1ZPP8JqfhIbLjqgcrP4g3Mn3EJB9n4tmi0OvMgtIQ5+TrHT0NgckVsNZs
         O/TdBpvRc3DAg3yNSGgTikZr4AxhMOAPekZRl0wyM789g6TjwkqsmHZhdfEfaySqBl9w
         z0fmnGCgaer9Y+S+Wy/FA/tHJIhzctA3IHr4lc6QsW5o4ELMuG88Dn8CLbaAxgQheSIB
         DwzE7WfvurTaqIb6AHBzmOQiOB5QdQ9TWL2Ux//b8mnIxk4WMM4CoaCFeBCPMBMov3MW
         aaoiwqTWiCgFl9CqUWigsei1gGq3X5cuUEX4PydM0BBGeKNOMY5uiuwvsnhwq3r2BUho
         bVqQ==
X-Gm-Message-State: AC+VfDygnMboHCSIXpnABG/zO87SDMw+gPsexwUR9kQYRboCTCkSmgLd
        GZ1ER/8cfab6A52C4mWgTjaOxfxhGnqArEQe27gBvkutuC9kl5SLqMmXtlhOAmgrz6ODk8sewfK
        VvBJ6PkUBziXqLheXJa3UfovCd1wWi4/g7WLJc3aFysvBpXxAFw==
X-Received: by 2002:a92:cb4a:0:b0:339:38d7:5bb6 with SMTP id f10-20020a92cb4a000000b0033938d75bb6mr11584594ilq.19.1685028094289;
        Thu, 25 May 2023 08:21:34 -0700 (PDT)
X-Google-Smtp-Source: ACHHUZ4h5BhFTW8apUVe4PmeANuwbo1x9X4P890zT8txJ2eyK5ei1z/iX1BWCqr02P8XGoRJectBBxH67mZJUURXnqM=
X-Received: by 2002:a92:cb4a:0:b0:339:38d7:5bb6 with SMTP id
 f10-20020a92cb4a000000b0033938d75bb6mr11584584ilq.19.1685028094084; Thu, 25
 May 2023 08:21:34 -0700 (PDT)
MIME-Version: 1.0
References: <20230427130539.2798797-1-amir73il@gmail.com>
In-Reply-To: <20230427130539.2798797-1-amir73il@gmail.com>
From:   Alexander Larsson <alexl@redhat.com>
Date:   Thu, 25 May 2023 17:21:22 +0200
Message-ID: <CAL7ro1G7DQS_aAC4+9-ppdQz_7vjoXdBLohZ6bKo6S75NQUDPA@mail.gmail.com>
Subject: Re: [PATCH v2 00/13] Overlayfs lazy lookup of lowerdata
To:     Amir Goldstein <amir73il@gmail.com>,
        Giuseppe Scrivano <gscrivan@redhat.com>
Cc:     Miklos Szeredi <miklos@szeredi.hu>, linux-unionfs@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <linux-unionfs.vger.kernel.org>
X-Mailing-List: linux-unionfs@vger.kernel.org

Something that came up about this in a discussion recently was
multi-layer composefs style images. For example, this may be a useful
approach for multi-layer container images.

In such a setup you would have one lowerdata layer, but two real
lowerdirs, like lowerdir=3DA:B::C. In this situation a file in B may
accidentally have the same name as a file on C, causing a redirect
from A to end up in B instead of C.

Would it be possible to have a syntax for redirects that mean "only
lookup in lowerdata layers. For example a double-slash path
//some/file.

On Thu, Apr 27, 2023 at 3:06=E2=80=AFPM Amir Goldstein <amir73il@gmail.com>=
 wrote:
>
> Miklos,
>
> This v2 combines the prep patch set [1] and lazy lookup patch set [2].
>
> This work is motivated by Alexander's composefs use case.
> Alexander has been developing and testing his fsverity patches over
> my lazy-lowerdata-lookup branch [3].
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


--=20
=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D=
-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D
 Alexander Larsson                                Red Hat, Inc
       alexl@redhat.com         alexander.larsson@gmail.com

