Return-Path: <linux-unionfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0901AC433EF
	for <linux-unionfs@archiver.kernel.org>; Sun,  5 Dec 2021 01:14:01 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230382AbhLEBR0 (ORCPT
        <rfc822;linux-unionfs@archiver.kernel.org>);
        Sat, 4 Dec 2021 20:17:26 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33662 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230378AbhLEBR0 (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Sat, 4 Dec 2021 20:17:26 -0500
Received: from mail-vk1-xa32.google.com (mail-vk1-xa32.google.com [IPv6:2607:f8b0:4864:20::a32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2B8BFC061751
        for <linux-unionfs@vger.kernel.org>; Sat,  4 Dec 2021 17:14:00 -0800 (PST)
Received: by mail-vk1-xa32.google.com with SMTP id q21so4408234vkn.2
        for <linux-unionfs@vger.kernel.org>; Sat, 04 Dec 2021 17:14:00 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=nextdayvideo-com.20210112.gappssmtp.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to;
        bh=yqVB1MBlKIt+6r249OM8XzVe7nO7AITmuUfiLorfZ5I=;
        b=i8j820ouPL50FP16S0BnGZB3e14frUaJXi3g9Al5Hj6wghZUcUiAp0hVsYjhg3i2iE
         DjbaTTVcXBlc5K+Z8uN2fiOkkeZDYjFQ3elsZn/rOR8QqH5XEyqaA4znXSEWMoFN50mQ
         fJ92q4185NCRm1SsLO+5mF6ShNqJFpVoBRVgbQkhxzY5drZl3CZb5L9gSCfLbJdfK33K
         GnaYui9ig7aP7tNohp7mwISsheTdwjU04cLUls7TAAe5hQO9SduvwrCDGpW6pjDSQnGD
         KUjwgiQiAEPEQ5zkRDfGI241PTE0i/SLnywAT98RrR1eP7QK31qAMawh8bdb/EyuxKBu
         AMOQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to;
        bh=yqVB1MBlKIt+6r249OM8XzVe7nO7AITmuUfiLorfZ5I=;
        b=n02lgOUXtjc9p7Jy4Og49lpaYxky/xnr4TWQpJ8YVoKsIMvZJUPyuNw7jiRxoQrVta
         5IgNN7pub3EzW29R8+7Nmon9EixN/zAMFXujyP7onOdx0PbBJmf0/Dl6X4/NX8G9MZuf
         9hPmspCINu+KW7EmLlW7VdwnDrYsb3Ni0IPixHx4Hd2vAu7HmCRWWt9Bn7r23s4aZAxW
         Zc5khk3upqpZbdjcXABVePTaMAhKkG4CgHqZqY1qNNYS86cOP4q6DudgXRvVrVDiWnx6
         R9jw8VQpkYwzNofDEDli27QCfXnBApELk1UXRqGjPV5QN0hHeoH2HKSa4dvvVSYr5C67
         5nQg==
X-Gm-Message-State: AOAM532dR1lPD1RUnhUCx9yv8gidLZDNIKKcMpCgCnosdHNPq4xOR5bO
        Yb8430aInSoylAw2V2sIYPK44Se4s8yjeDGWHcpfFM+DDEw=
X-Google-Smtp-Source: ABdhPJwcd+6IU/H5xPafgqsEaNFXwQ2+4D61MJZIRrtxDkMECiS3ehzWcvnDhquNO4OKWATGT31gwNt/wfuAwLs9O9I=
X-Received: by 2002:ac5:c93a:: with SMTP id u26mr33354946vkl.41.1638666838865;
 Sat, 04 Dec 2021 17:13:58 -0800 (PST)
MIME-Version: 1.0
References: <CADmzSSjKoiYn7moEVFDV2p+x2BuTnWBLMBtdPQYsqQOttcgN1A@mail.gmail.com>
In-Reply-To: <CADmzSSjKoiYn7moEVFDV2p+x2BuTnWBLMBtdPQYsqQOttcgN1A@mail.gmail.com>
From:   Carl Karsten <carl@nextdayvideo.com>
Date:   Sat, 4 Dec 2021 17:13:32 -0800
Message-ID: <CADmzSSjhWE-5HN+2_Svm_EyOGbiC7bEtZp0xDKf=RTxVpk0ppA@mail.gmail.com>
Subject: Re: failed to verify upper - halts boot
To:     overlayfs <linux-unionfs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-unionfs.vger.kernel.org>
X-Mailing-List: linux-unionfs@vger.kernel.org

On Sat, Dec 4, 2021 at 5:04 PM Carl Karsten <carl@nextdayvideo.com> wrote:
>
> I powercyced my box, I'm assuming I did a sudo poweroff or halt or
> something, but maybe not.
>
> It got stuck, (enter rescue mode, root account disabled, hit enter to
> enter rescue mode... )  so I killed power.
>
> I edited fstab, changed auto to noauto, booted.
>
> overlay   /srv/nfs/rpi/bullseye/boot/merged    overlay
> noauto,defaults,ro,lowerdir=/srv/nfs/rpi/bullseye/boot/updates:/srv/nfs/rpi/bullseye/boot/setup:/srv/nfs/rpi/bullseye/boot/base,upperdir=/srv/nfs/rpi/bullseye/boot/play,workdir=/srv/nfs/rpi/bullseye/boot/work,nfs_export=on
>    0   0
>
> # mount /srv/nfs/rpi/bullseye/boot/merged
> mount: /srv/nfs/rpi/bullseye/boot/merged: mount(2) system call failed:
> Stale file handle.
>
> dmesg shows:
>
> [   45.941350] overlayfs: failed to verify upper (boot/play,
> ino=379405, err=-116)
> [   45.941369] overlayfs: failed to verify index dir 'upper' xattr
> [   45.941379] overlayfs: try deleting index dir or mounting with '-o
> index=off' to disable inodes index.
>
> It is a bit concerning that I need to consider a power cycle may
> require local console use.  I plan on managing this remotely.  For now
> I'll leave it noauto and remotely mount when needed.  so this isn't a
> critical blocker to me.
>
> What would happen:  errors=remount-ro
>
> errors={continue|remount-ro|panic}
>     Define the behavior  when  an  error  is  encountered.  The
> default is set in the filesystem superblock,  ...     and can be
> changed using tune2fs(8).
>
> In normal operation I want the mount ro anyway.
> continue unmounted is also an option.  which would be better than
> noauto if I am assured it won't get stuck at boot.

welp...
noauto,defaults,ro,errors=continue
and remount-ro

[ 1157.781768] overlayfs: unrecognized mount option "errors=continue"
or missing value
[ 1565.415281] overlayfs: unrecognized mount option
"errors=remount-ro" or missing value


>
> --
> Carl K



-- 
Carl K
