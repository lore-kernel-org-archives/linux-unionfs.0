Return-Path: <SRS0=dsgN=7S=vger.kernel.org=linux-unionfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.6 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 790EFC433E0
	for <linux-unionfs@archiver.kernel.org>; Fri,  5 Jun 2020 02:35:46 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 50180207D5
	for <linux-unionfs@archiver.kernel.org>; Fri,  5 Jun 2020 02:35:46 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="FhPcPNY6"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726026AbgFECfq (ORCPT
        <rfc822;linux-unionfs@archiver.kernel.org>);
        Thu, 4 Jun 2020 22:35:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52760 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725883AbgFECfp (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Thu, 4 Jun 2020 22:35:45 -0400
Received: from mail-io1-xd44.google.com (mail-io1-xd44.google.com [IPv6:2607:f8b0:4864:20::d44])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A1CCFC08C5C0;
        Thu,  4 Jun 2020 19:35:45 -0700 (PDT)
Received: by mail-io1-xd44.google.com with SMTP id j8so8644722iog.13;
        Thu, 04 Jun 2020 19:35:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=z9EotnjM1m15VPlAC5q/xowE94IPhwwOBWYN2BOjzoA=;
        b=FhPcPNY6IZzPvkjXJh6YjYMplRHKQ20MHU/nL2NRUfbIITN3kpSznaGAanpix1I4sP
         36NwGPenDSyOGhUugL1GqOIhPH68f2hooQlnyzpTFdyqL3vhBrHMPb3dgMQkJpwm5SV2
         EGqvjvby629GYnmjl+vMb2qKtBOurXNycaEWPls5zO+ZuBZj9MeHCPlgDaSziUVXceSB
         qnKOxxHaev+DAVLicPMiX9l7vO9NzXW1nrmJq/7tsutPV9iaz9AX4apsUJ17JpAJur/c
         nS48mDDv8u7H2gG5uBSjA9+4KiD9wTi594Q/s/d62wEBx0lefPVfXk0NH26jPmVtRKHb
         GM6w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=z9EotnjM1m15VPlAC5q/xowE94IPhwwOBWYN2BOjzoA=;
        b=MJEmbjlkFAKe+kVbdInneIThdj81KxEaJif/N072mjs4WyIiSkBFWU1ThaqnsnoH36
         bcxRQtVTGOa8tnyjQQ66Ys9A9QrtfnYNn9WFZaIvbH1MnUmBTDhajCDs77Bb4Hkume1P
         TrgvOhTFs3Qa3+49rR5l/XgF7XEJzwD99FCaEuJXKME2HzQWlxU3glaPUliRJ9eFQVHQ
         07EFlQ+Re1rA/OaNLOjDn5eWFodKKdrX7f8frmfyGPwCoJ0OZuBmgJrc+vRWuaU7o8mc
         3VDi+PwloipfwvQPIW78ChxhsG3btEZ64aALVjWCBaPxWMR41bDaVF9zHQcyE0GEqizI
         yvLw==
X-Gm-Message-State: AOAM532iZXtF9dgTJiBG+tmzdELJVk+RabBRek0wT/AVNSrMLTTJgyOt
        m+rWUBnvUZ7Dq7MCDHpfWyrk2J45y3BdRJG/UFLDsw==
X-Google-Smtp-Source: ABdhPJwRLe/QhaF5jTfwOKU/yzPdk6R3feJAYKNyBrxr3TYeTNastPqxL25fAD1Ji+5m1Xi9BhAzpB/NJCcurgcFDPU=
X-Received: by 2002:a02:5184:: with SMTP id s126mr6779429jaa.30.1591324544909;
 Thu, 04 Jun 2020 19:35:44 -0700 (PDT)
MIME-Version: 1.0
References: <20200604161133.20949-1-alexander.mikhalitsyn@virtuozzo.com>
 <CAOQ4uxhGswjxZjc3mN7K99pPrDgMV9_194U46b2MgszZnq1SDw@mail.gmail.com> <AM6PR08MB36394A00DC129791CC89296AE8890@AM6PR08MB3639.eurprd08.prod.outlook.com>
In-Reply-To: <AM6PR08MB36394A00DC129791CC89296AE8890@AM6PR08MB3639.eurprd08.prod.outlook.com>
From:   Amir Goldstein <amir73il@gmail.com>
Date:   Fri, 5 Jun 2020 05:35:33 +0300
Message-ID: <CAOQ4uxisdLt-0eT1R=V1ihagMoNfjiTrUdcdF2yDgD4O94Zjcw@mail.gmail.com>
Subject: Re: [PATCH 0/2] overlayfs: C/R enhancements
To:     Alexander Mikhalitsyn <alexander.mikhalitsyn@virtuozzo.com>
Cc:     Miklos Szeredi <miklos@szeredi.hu>,
        Andrey Vagin <avagin@virtuozzo.com>,
        Pavel Tikhomirov <ptikhomirov@virtuozzo.com>,
        Konstantin Khorenko <khorenko@virtuozzo.com>,
        Vasiliy Averin <vvs@virtuozzo.com>,
        Kirill Tkhai <ktkhai@virtuozzo.com>,
        overlayfs <linux-unionfs@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-unionfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-unionfs.vger.kernel.org>
X-Mailing-List: linux-unionfs@vger.kernel.org

On Fri, Jun 5, 2020 at 12:34 AM Alexander Mikhalitsyn
<alexander.mikhalitsyn@virtuozzo.com> wrote:
>
> Hello,
>
> >But overlayfs won't accept these "output only" options as input args,
> which is a problem.
>
> Will it be problematic if we simply ignore "lowerdir_mnt_id" and "upperdir_mnt_id" options in ovl_parse_opt()?
>

That would solve this small problem.

> >Wouldn't it be better for C/R to implement mount options
> that overlayfs can parse and pass it mntid and fhandle instead
> of paths?
>
> Problem is that we need to know on C/R "dump stage" which mounts are used on lower layers and upper layer. Most likely I don't understand something but I can't catch how "mount-time" options will help us.

As you already know from inotify/fanotify C/R fhandle is timeless, so
there would be no distinction between mount time and dump time.
About mnt_id, your patches will cause the original mount-time mounts to be busy.
That is a problem as well.

I think you should describe the use case is more details.
Is your goal to C/R any overlayfs mount that the process has open
files on? visible to process?
For NFS export, we use the persistent descriptor {uuid;fhandle}
(a.k.a. struct ovl_fh) to encode
an underlying layer object.

CRIU can look for an existing mount to a filesystem with uuid as restore stage
(or even mount this filesystem) and use open_by_handle_at() to open a
path to layer.
After mounting overlay, that mount to underlying fs can even be discarded.

And if this works for you, you don't have to export the layers ovl_fh in
/proc/mounts, you can export them in numerous other ways.
One way from the top of my head, getxattr on overlay root dir.
"trusted.overlay" xattr is anyway a reserved prefix, so "trusted.overlay.layers"
for example could work.

Thanks,
Amir.
