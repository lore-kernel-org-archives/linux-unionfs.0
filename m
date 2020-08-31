Return-Path: <SRS0=nzN1=CJ=vger.kernel.org=linux-unionfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 97244C433E6
	for <linux-unionfs@archiver.kernel.org>; Mon, 31 Aug 2020 05:23:39 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 6F33120707
	for <linux-unionfs@archiver.kernel.org>; Mon, 31 Aug 2020 05:23:39 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="dDlzYaNK"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725982AbgHaFXj (ORCPT
        <rfc822;linux-unionfs@archiver.kernel.org>);
        Mon, 31 Aug 2020 01:23:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45332 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725446AbgHaFXi (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Mon, 31 Aug 2020 01:23:38 -0400
Received: from mail-io1-xd42.google.com (mail-io1-xd42.google.com [IPv6:2607:f8b0:4864:20::d42])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 562D1C061573
        for <linux-unionfs@vger.kernel.org>; Sun, 30 Aug 2020 22:23:36 -0700 (PDT)
Received: by mail-io1-xd42.google.com with SMTP id h10so4636519ioq.6
        for <linux-unionfs@vger.kernel.org>; Sun, 30 Aug 2020 22:23:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=DUiyeZuGh0FeTd7qY+PTA2Pdv40Ar8a/KMVGNasTJbc=;
        b=dDlzYaNK7HkdzbjgEICEY/JOBgtMfSszphB3nKB3AOJvfum+NRPfA4yeeU0zNUkJzT
         HwYjr0sJVH3Srqq31uxjvVG8b599eF4HEfYr3L65tSFbqbmQBb/tiZCE34JBJI081mKV
         k7t7o+C4DDrQCqCEhYYrk5zBPs+qL/jgeBgqfciRv4zJ55LWpqD2Olazm6CjyTPRjryX
         +3/0I9cLKaroVU4z5J8n62GCHEUYkMCsbQCiXdLinurILXmJJqG18oMSN/qStC+t6Jym
         H+5AA/dOXsaKi1p+ePNbf6LXV2b2thMdYYwPgmtx+hfZn5abMwYjU5SYFCM0LOCTah/J
         KLHQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=DUiyeZuGh0FeTd7qY+PTA2Pdv40Ar8a/KMVGNasTJbc=;
        b=OxiVR+fl1ega/sXQHN5/pmEnwQdqp6vIrkfYyu5Tyu7BK4460eZ/4zdIjHm/Y8S+00
         cZfhqeHx+njdwQu5M3m2NwZBcgtMZB8F+0uDLRucrkE18kYxo1iZDyERUVVzG8id71GR
         rh6S6/FrC6mhMJkR08AGFJodIUnmTzzb5cONAr459u0Afmbiydt7aMssPzFkevXYjD0v
         RWM/nVpBwTrfLCd0/fhNBPiJlKCjsgS4S+mm2pOyg3oPXrVq1OUgwfmOlmuGJ7NZY8bX
         pHADrrywBuMlBuiHYyt8ML//ER3ZaUNcLDxgrX6WcY4+IgmfrzG0HOU0Y/pmQDQA6C+X
         9k0Q==
X-Gm-Message-State: AOAM532SZ8AWdLwU5mOL7Tp9HlTeemBTHdfTeLZbVPZanJ3Iaw094/Ex
        jI0gB6BvAwRrINT2YHPPMj6gJMylak1XzzAte9XE5C0x+YQ=
X-Google-Smtp-Source: ABdhPJyhNBzq42PY2FPdO5/rbEZQyupOTVcaMEfK1GD3akdrkYVE67zNkhYcKeVoPAKR8XfAtYxOq127IAD7kYsjyNM=
X-Received: by 2002:a6b:ec17:: with SMTP id c23mr21941ioh.186.1598851415533;
 Sun, 30 Aug 2020 22:23:35 -0700 (PDT)
MIME-Version: 1.0
References: <20200827191843.GA1098241@redhat.com>
In-Reply-To: <20200827191843.GA1098241@redhat.com>
From:   Amir Goldstein <amir73il@gmail.com>
Date:   Mon, 31 Aug 2020 08:23:24 +0300
Message-ID: <CAOQ4uxjZmia9MFXoEj38JEJC9sQEA7rzhLeeP12Cd9LtD0_NHA@mail.gmail.com>
Subject: Re: [PATCH v6] overlayfs: Provide a mount option "volatile" to skip sync
To:     Vivek Goyal <vgoyal@redhat.com>
Cc:     overlayfs <linux-unionfs@vger.kernel.org>,
        Miklos Szeredi <miklos@szeredi.hu>,
        Giuseppe Scrivano <gscrivan@redhat.com>,
        Daniel J Walsh <dwalsh@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-unionfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-unionfs.vger.kernel.org>
X-Mailing-List: linux-unionfs@vger.kernel.org

On Thu, Aug 27, 2020 at 10:18 PM Vivek Goyal <vgoyal@redhat.com> wrote:
>
> Container folks are complaining that dnf/yum issues too many sync while
> installing packages and this slows down the image build. Build
> requirement is such that they don't care if a node goes down while
> build was still going on. In that case, they will simply throw away
> unfinished layer and start new build. So they don't care about syncing
> intermediate state to the disk and hence don't want to pay the price
> associated with sync.
>
> So they are asking for mount options where they can disable sync on overlay
> mount point.
>
> They primarily seem to have two use cases.
>
> - For building images, they will mount overlay with nosync and then sync
>   upper layer after unmounting overlay and reuse upper as lower for next
>   layer.
>
> - For running containers, they don't seem to care about syncing upper
>   layer because if node goes down, they will simply throw away upper
>   layer and create a fresh one.
>
> So this patch provides a mount option "volatile" which disables all forms
> of sync. Now it is caller's responsibility to throw away upper if
> system crashes or shuts down and start fresh.
>
> With "volatile", I am seeing roughly 20% speed up in my VM where I am just
> installing emacs in an image. Installation time drops from 31 seconds to
> 25 seconds when nosync option is used. This is for the case of building on top
> of an image where all packages are already cached. That way I take
> out the network operations latency out of the measurement.
>
> Giuseppe is also looking to cut down on number of iops done on the
> disk. He is complaining that often in cloud their VMs are throttled
> if they cross the limit. This option can help them where they reduce
> number of iops (by cutting down on frequent sync and writebacks).
>
> Changes from v5:
> - Added support to detect that previous overlay was mounted with
>   "volatile" option and fail mount. (Miklos and Amir).
>
> Changes from v4:
> - Dropped support for sync=fs (Miklos)
> - Renamed "sync=off" to "volatile". (Miklos)
>
> Changes from v3:
> - Used only enums and dropped bit flags (Amir Goldstein)
> - Dropped error when conflicting sync options provided. (Amir Goldstein)
>
> Changes from v2:
> - Added helper functions (Amir Goldstein)
> - Used enums to keep sync state (Amir Goldstein)
>
> Signed-off-by: Giuseppe Scrivano <gscrivan@redhat.com>
> Signed-off-by: Miklos Szeredi <mszeredi@redhat.com>
???

> Signed-off-by: Vivek Goyal <vgoyal@redhat.com>
> ---
>  Documentation/filesystems/overlayfs.rst |  17 ++++
>  fs/overlayfs/copy_up.c                  |  12 ++-
>  fs/overlayfs/file.c                     |  10 +-
>  fs/overlayfs/ovl_entry.h                |   6 ++
>  fs/overlayfs/readdir.c                  |   3 +
>  fs/overlayfs/super.c                    | 128 +++++++++++++++++++++++-
>  6 files changed, 168 insertions(+), 8 deletions(-)
>
> diff --git a/Documentation/filesystems/overlayfs.rst b/Documentation/filesystems/overlayfs.rst
> index 8ea83a51c266..438add193166 100644
> --- a/Documentation/filesystems/overlayfs.rst
> +++ b/Documentation/filesystems/overlayfs.rst
> @@ -563,6 +563,23 @@ This verification may cause significant overhead in some cases.
>  Note: the mount options index=off,nfs_export=on are conflicting for a
>  read-write mount and will result in an error.
>
> +Disable sync
> +------------
> +By default, overlay skips sync on files residing on a lower layer.  It
> +is possible to skip sync operations for files on the upper layer as well
> +with the "volatile" mount option.
> +
> +"volatile" mount option disables all forms of sync from overlay, including
> +the one done at umount/remount. If system crashes or shuts down, user
> +should throw away upper directory and start fresh.
> +
> +When overlay is mounted with "volatile" option, overlay creates an internal
> +file "$workdir/work/incompat/volatile/dirty". During next mount, overlay
> +checks for dirty file and refuses to mount if present. This is a strong
> +indicator that user should throw away upper and work directories and
> +create fresh one. In very limited cases where user knows system has not
> +crashed and contents in upperdir are intact, one can remove "dirty" file and
> +retry mount.

Just in case my comment about documentation wasn't clear:

+When overlay is mounted with "volatile" option, overlay creates an internal
+directory "$workdir/work/incompat/volatile". During next mount, overlay
+checks for this directory and refuses to mount if present. This is a strong
+indicator that user should throw away upper and work directories and
+create fresh one. In very limited cases where user knows system has not
+crashed and contents in upperdir are intact, one can remove the "volatile"
+directory and retry mount.

Thanks,
Amir.
