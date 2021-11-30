Return-Path: <linux-unionfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5A702C433FE
	for <linux-unionfs@archiver.kernel.org>; Tue, 30 Nov 2021 15:20:40 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244549AbhK3PX6 (ORCPT
        <rfc822;linux-unionfs@archiver.kernel.org>);
        Tue, 30 Nov 2021 10:23:58 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38594 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S245045AbhK3PX1 (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Tue, 30 Nov 2021 10:23:27 -0500
Received: from mail-io1-xd2b.google.com (mail-io1-xd2b.google.com [IPv6:2607:f8b0:4864:20::d2b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 439AFC061373
        for <linux-unionfs@vger.kernel.org>; Tue, 30 Nov 2021 07:19:17 -0800 (PST)
Received: by mail-io1-xd2b.google.com with SMTP id v23so26475735iom.12
        for <linux-unionfs@vger.kernel.org>; Tue, 30 Nov 2021 07:19:17 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=cwj8HPgS62VY7VIklg2+PI8MCij78uKpSxIafy8T4Ss=;
        b=mnAETj/FuIsQj+KKL9Ajk+rB221VET0pM5xFMdGbbYUR+lHGqwZ4ttHhJm9/ZyAhxM
         qqH2sUHFTDeOofsiOxT7Z8XZbFo/Conm7imt7U38d6XrXEtSC5oDBJ12ToprCrsQ0gfb
         3ZzEC99gRMkbDQwuuSRV6cIa4zTbHaSfLw/PCXY6u+h2IdMvCxLDAijeLsM0Mkg3GqlS
         rsI+1glWTpeEUW2L+P3EKFuJk8syunBgabdefEC+E1JtyTeKw3xEfcf1BUOx1xiwelCe
         Oh1FRPnFLOYj2OJ8vkl/vyPXsJCVOZAFiwb/5OxQ7VacmaTSICM6xfyNR1yclOLEmzUr
         t27g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=cwj8HPgS62VY7VIklg2+PI8MCij78uKpSxIafy8T4Ss=;
        b=V+dCFUyF4YvsCDy5gRcTfSM8qzLAWtVbDIRZEXXY8oHOwxf/2rNBXRoapT14T/aELB
         W+bOBusEJoV1sQtC0OHqJshJnqA2JP+Ls1nc76xOE5/WFGKDEG9CjAD6CZ7uPHLFhMqu
         1078vSuoQw2F/GDYfkk6//yqboFEIOjx5Fxn3LXjzwau6BoJQnuXwJHCYfSXcRCSG8C4
         OrsgjVZ1DISrj+02INVeB5M5PEw9VtyaPid7sUGzVRHDvTiBX9UG17EbwCKvRGy67yZ3
         wHMBwsjs35DafKASHcBULWVZS3lMqQO4TiWvVPDo4GoS3CTxjGfzMxbXtcmPwZW/8TOE
         MwWw==
X-Gm-Message-State: AOAM530X5PKEW6Hn9RXMPBHbuGmDoHOGk9i+0Bdg/LLVRQwxEbYv0H5F
        HHrL/rlKj3twV1FJDrbpqaaaTK0i+8Ov7MdchrY767Db1hE=
X-Google-Smtp-Source: ABdhPJxAshwjDkILaXI2ZtNhzV47//3IPWHj3bepSyrmvc797EDSly05W9zMP3/11whUr4rhEJ59U78geW7N3OZQDg0=
X-Received: by 2002:a05:6638:2727:: with SMTP id m39mr73375089jav.75.1638285556709;
 Tue, 30 Nov 2021 07:19:16 -0800 (PST)
MIME-Version: 1.0
References: <CADmzSSh7P+T78nuKxgK4mjOMMPO6AZmtYBFw+uu4UuE_K5FWCA@mail.gmail.com>
In-Reply-To: <CADmzSSh7P+T78nuKxgK4mjOMMPO6AZmtYBFw+uu4UuE_K5FWCA@mail.gmail.com>
From:   Amir Goldstein <amir73il@gmail.com>
Date:   Tue, 30 Nov 2021 17:19:05 +0200
Message-ID: <CAOQ4uxjPMHnS3zU11t_Jo5OXAv4-vXj4+9BtAxMUt0ueTFgmtQ@mail.gmail.com>
Subject: Re: index=on,nfs_export=on Operation not permitted
To:     Carl Karsten <carl@nextdayvideo.com>
Cc:     overlayfs <linux-unionfs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-unionfs.vger.kernel.org>
X-Mailing-List: linux-unionfs@vger.kernel.org

On Tue, Nov 30, 2021 at 4:54 PM Carl Karsten <carl@nextdayvideo.com> wrote:
>
> I don't need any help, This seems odd enough to report.
>
> I accidentally  built my nfs server on buster, which threw some errors
> about index=on, so I added index=on.  Then I rebuilt the server on
> bullseye, and almost everything was the same, except for 1 little
> thing.  I removed the index=on, and all was well again.
>
> server:
> dist=bullseye
> d=/srv/nfs/rpi/${dist}
> p=${d}/boot
> rm -rf ${p}/work/index
> mount -t overlay overlay -o index=on,nfs_export=on,\
> lowerdir=${p}/setup:${p}/base,\
> upperdir=${p}/updates,\
> workdir=${p}/work \
>     ${p}/merged
>
> /etc/exports
> /srv/nfs/rpi/bullseye/boot/merged
> *(rw,sync,no_subtree_check,no_root_squash,fsid=1)
>
>
> client:
> root@raspberrypi:~# mount
> 10.21.0.1:/srv/nfs/rpi/bullseye/root/merged on / type nfs
> (rw,relatime,vers=3,rsize=4096,wsize=4096,namlen=255,hard,nolock,proto=tcp,timeo=600,retrans=2,sec=sys,mountaddr=10.21.0.1,mountvers=3,mountproto=tcp,local_lock=all,addr=10.21.0.1)
>
> root@raspberrypi:~# mv /boot/z /boot/config.txt
> mv: cannot move '/boot/z' to '/boot/config.txt': Operation not permitted
>
> root@raspberrypi:~# strace mv /boot/z /boot/config.txt

strace is not useful information.
kernel log would have been able to shed more light on the error.

But I did not understand the report.
The error was on buster/bullseye? with index=on? without index=on?
You managed to confuse me.
index=on is deferred from nfs_export=on since commit
b0def88d807f ovl: resolve more conflicting mount options

So that is probably the difference between buster/bullseye.
Didn't check which kernels they use.

Thanks,
Amir.
