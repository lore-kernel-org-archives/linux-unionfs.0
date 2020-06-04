Return-Path: <SRS0=s+il=7R=vger.kernel.org=linux-unionfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.6 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A385DC433DF
	for <linux-unionfs@archiver.kernel.org>; Thu,  4 Jun 2020 18:05:11 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 84D3D206C3
	for <linux-unionfs@archiver.kernel.org>; Thu,  4 Jun 2020 18:05:11 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="LxwDsfhG"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730174AbgFDSFL (ORCPT
        <rfc822;linux-unionfs@archiver.kernel.org>);
        Thu, 4 Jun 2020 14:05:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58706 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730008AbgFDSFK (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Thu, 4 Jun 2020 14:05:10 -0400
Received: from mail-il1-x142.google.com (mail-il1-x142.google.com [IPv6:2607:f8b0:4864:20::142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DD1B0C08C5C0;
        Thu,  4 Jun 2020 11:05:10 -0700 (PDT)
Received: by mail-il1-x142.google.com with SMTP id p5so6988453ile.6;
        Thu, 04 Jun 2020 11:05:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=X1b4BEr/DHZQvQyvdQ9WJt5QLV82BJBnaAPWqeJ7CbY=;
        b=LxwDsfhGYIoloqCEYEN6havWe+hHDiiiSWB2lxrkhSlWYqlgCcvvGfQ1EO9CnzqRYI
         tbcjhekFwcQV4EBwzr7ciUqScRgSLunqVWtr1mPUV3+GN743iaG1qXVyedYo125GtheB
         R3U68HkD01CC64FEYjv4CjsXpvrOeeNnaSw87DL1Gu4REtV3Jx/Nw4I8bR4lt+MuFRl8
         TbQgGqxR2cZZuWtK20hJjl9dRQYr9Mhug3Yp+lbxAGz0i94B22hNSRSqn2otStGbfgMI
         cTb/yQ9TUpRc74y1Af2O3TJGgGDed2kMkNCNdF1Dk3rxaXggM0i/Zj9lWoEyF6em/PRW
         eZGQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=X1b4BEr/DHZQvQyvdQ9WJt5QLV82BJBnaAPWqeJ7CbY=;
        b=Y214IBXDtetwtXFDL2gYUTH9ydfTNxmcgX/wWMiWzPqH0veW0xcdtSGm1W2vzE5VsV
         bMhzzh0j99G0UVpk0dAIEW1fjpFNhTjBKdAonv3aIQ3zWor9NpxZgJJXEaIdqG6cojAA
         CPgpYjc+DLSydwguqfD2e5k5hJbEKIqSlnPbFEfvW0fBgBJwMkGVojf/uuH07qzV+L39
         ZFckNeTiu3oBUgis8tkqO5wec0iECtgaC1+mdY2v1vAdMDWyuer/azytYVh3zoI57XBh
         f5D22njRBzeUJ1KoXN/Cr1uJAEXD1VtBdJy7QudD6lBvr8klxFfc7H/HwWTikQt56QBS
         ojOg==
X-Gm-Message-State: AOAM531s8QDn5x0GcNUnEBndX+Sp133jA3gZV7IxSAPPuu9QyCbqENwx
        8FIXMLJI8Cv2J6HFYvPui+8siLSrX3I+TX9D4ENLPA==
X-Google-Smtp-Source: ABdhPJwTGNq+lts75fMK6GZCnI9DekzO33pOxX+DxEM9Hqbj/tJNJuBrTQOnBrFuXCIXjdDRGFoD+++N8JKDhvPn9PI=
X-Received: by 2002:a92:c9ce:: with SMTP id k14mr5108937ilq.250.1591293910251;
 Thu, 04 Jun 2020 11:05:10 -0700 (PDT)
MIME-Version: 1.0
References: <20200604161133.20949-1-alexander.mikhalitsyn@virtuozzo.com>
In-Reply-To: <20200604161133.20949-1-alexander.mikhalitsyn@virtuozzo.com>
From:   Amir Goldstein <amir73il@gmail.com>
Date:   Thu, 4 Jun 2020 21:04:58 +0300
Message-ID: <CAOQ4uxhGswjxZjc3mN7K99pPrDgMV9_194U46b2MgszZnq1SDw@mail.gmail.com>
Subject: Re: [PATCH 0/2] overlayfs: C/R enhancements
To:     Alexander Mikhalitsyn <alexander.mikhalitsyn@virtuozzo.com>
Cc:     Miklos Szeredi <miklos@szeredi.hu>,
        Andrei Vagin <avagin@openvz.org>, ptikhomirov@virtuozzo.com,
        khorenko@virtuozzo.com, vvs@virtuozzo.com, ktkhai@virtuozzo.com,
        overlayfs <linux-unionfs@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-unionfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-unionfs.vger.kernel.org>
X-Mailing-List: linux-unionfs@vger.kernel.org

On Thu, Jun 4, 2020 at 7:13 PM Alexander Mikhalitsyn
<alexander.mikhalitsyn@virtuozzo.com> wrote:
>
> This patchset aimed to make C/R of overlayfs mounts with CRIU possible.
> We introduce two new overlayfs module options -- dyn_path_opts and
> mnt_id_path_opts. If enabled this options allows to see real *full* paths
> in lowerdir, workdir, upperdir options, and also mnt_ids for corresponding
> paths.
>
> This changes should not break anything because for showing mnt_ids we simply
> introduce new show-time mount options. And for paths we simply *always*
> provide *full paths* instead of relative path on mountinfo.
>
> BEFORE
>
> overlay on /var/lib/docker/overlay2/XYZ/merged type overlay (rw,relatime,
> lowerdir=/var/lib/docker/overlay2/XYZ-init/diff:/var/lib/docker/overlay2/
> ABC/diff,upperdir=/var/lib/docker/overlay2/XYZ/diff,workdir=/var/lib/docker
> /overlay2/XYZ/work)
> none on /sys type sysfs (rw,relatime)
>
> AFTER
>
> overlay on /var/lib/docker/overlay2/XYZ/merged type overlay (rw,relatime,
> lowerdir=/var/lib/docker/overlay2/XYZ-init/diff:/var/lib/docker/overlay2/
> ABC/diff,upperdir=/var/lib/docker/overlay2/XYZ/diff,workdir=/var/lib/docker
> /overlay2/XYZ/work,lowerdir_mnt_id=175:175,upperdir_mnt_id=175)
> none on /sys type sysfs (rw,relatime)
>

But overlayfs won't accept these "output only" options as input args,
which is a problem.

Wouldn't it be better for C/R to implement mount options
that overlayfs can parse and pass it mntid and fhandle instead
of paths?
I believe C/R is using a similar method to export inotify/fanotify
marks.

FWIW overlayfs already has utilities that encode filehandle to
text and back, see  ovl_get_index_name().

Thanks,
Amir.
