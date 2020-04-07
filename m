Return-Path: <SRS0=6c+a=5X=vger.kernel.org=linux-unionfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.6 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 74006C2BA1A
	for <linux-unionfs@archiver.kernel.org>; Tue,  7 Apr 2020 17:13:12 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 0F123206C0
	for <linux-unionfs@archiver.kernel.org>; Tue,  7 Apr 2020 17:13:12 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="LI2YNxl0"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726329AbgDGRNL (ORCPT
        <rfc822;linux-unionfs@archiver.kernel.org>);
        Tue, 7 Apr 2020 13:13:11 -0400
Received: from mail-io1-f67.google.com ([209.85.166.67]:40328 "EHLO
        mail-io1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726277AbgDGRNL (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Tue, 7 Apr 2020 13:13:11 -0400
Received: by mail-io1-f67.google.com with SMTP id s15so4178386ioj.7
        for <linux-unionfs@vger.kernel.org>; Tue, 07 Apr 2020 10:13:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=eYD6QZZokT1EBj1VV2a/4tlk4zGcFrohJ7yQDPbbmyw=;
        b=LI2YNxl0ieq5jIU9IQLuvU843IosWOA/DUxzRtCb7dM3Ag52euDDt3gtN70BfzwaYE
         mR64A2IJT7zX1nNO1Ei8JJsRClPl5IHKQg5O+ISUBboVdDMrwhkiP968G+BfekwmLZL+
         kfyczdBDt3OgeBbwa2rjhpHsB5hPGhmCOMtbbss56nvgzor2PZNE1R8OX68MW6+cGV3T
         ZwsCdghHk9dPxznc5UKWAZ3v/jfjJBbtm25peUP+Q/QKHEympj7FbHuRgzxvWscwjJ5/
         9hCQ9hXQ0ygcyUrt4WSGk4/H4SUNRQRp0wL5PIFYA0mWrpsIrhAVGPbD1XHGL6fpiOaI
         J3gw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=eYD6QZZokT1EBj1VV2a/4tlk4zGcFrohJ7yQDPbbmyw=;
        b=QobxiW97ANraesRWFm42sliM0Cx16Jn3oKZngEBuzxBeWs2GvM9oAXFFbhgYZHlewg
         g9JkS3s1dc+eFY/yW5esVaP+wBEk03d14fHbWTD6fqeun6cq1MYYbtWFDKJ22YRJOejP
         V2nDcCNEnei03ta0DtFTjKoQIyBE9BGkvV8ms0JEZA1jFnn2HaE6XCgsYalDAZCIiHYv
         Ff7B7oIbY/e5vxjcplioM7nGSVO8AeWF9txJZtqTLCcr805Qbx+AG1Y8ZIrroEfLLcIg
         jvkyXdZ5SUUFCEL8iqiViatzNnGuqnmkOgxl0wyiuNRZbowKeFm1zfYPfUMjiOu0oL00
         HBbg==
X-Gm-Message-State: AGi0PuZX3SIjpfN9ymGiyR/06mXaTlp7rB3vvZ2WJvnZOTiFPPF78PWb
        g9rB107YTtKoKr6p0oVsjUqTqVfQxa/X7gZ2gK5sDcdc
X-Google-Smtp-Source: APiQypJNyIL1qLn1PGJNnT1tue1bOnbq84xxv/rUoznqSFnANW1/jucLzZHw5nC/AjPErUmExYYugwVHKyyryjvpVMU=
X-Received: by 2002:a05:6602:1302:: with SMTP id h2mr3077147iov.186.1586279590528;
 Tue, 07 Apr 2020 10:13:10 -0700 (PDT)
MIME-Version: 1.0
References: <20200403064444.31062-1-cgxu519@mykernel.net> <CAOQ4uxi8eMWRc6uuNt_R9nS9UjrOsqupcCEST4ub-kCwEpx=_Q@mail.gmail.com>
 <17153e5b537.c827c90942921.7568518513045332175@mykernel.net>
 <CAOQ4uxiHwQ4_rGLZeKS8VwP84YoUDZcju76KeYugt+SOAKVGKQ@mail.gmail.com> <17153f590e5.13f80af2342991.2831629093514707476@mykernel.net>
In-Reply-To: <17153f590e5.13f80af2342991.2831629093514707476@mykernel.net>
From:   Amir Goldstein <amir73il@gmail.com>
Date:   Tue, 7 Apr 2020 20:12:59 +0300
Message-ID: <CAOQ4uxjhfOXaHMaXY+J67winJzFMDVfiHfF4m=yed7XNcPvFUw@mail.gmail.com>
Subject: Re: [PATCH v2] ovl: sharing inode with different whiteout files
To:     Chengguang Xu <cgxu519@mykernel.net>
Cc:     Miklos Szeredi <miklos@szeredi.hu>,
        overlayfs <linux-unionfs@vger.kernel.org>,
        Hou Tao <houtao1@huawei.com>,
        "zhangyi (F)" <yi.zhang@huawei.com>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-unionfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-unionfs.vger.kernel.org>
X-Mailing-List: linux-unionfs@vger.kernel.org

>  > did nfs_export tests fail with my recent branch (c1fe7dcb3db8)?
>  > because I had a bug that caused nfs_export tests to fail.
>  >
>  >
>  > ...
>  >
>
> Actually, it is "not run" not fail. I'm not very familiar how to run with nfs_export,
> is it needing some special options?
>
> test log below:
>
> overlay/068     [not run] overlay feature 'nfs_export' cannot be enabled on /mnt/scratch
> overlay/069     [not run] overlay feature 'nfs_export' cannot be enabled on /mnt/scratch
> overlay/070     [not run] overlay feature 'nfs_export' cannot be enabled on /mnt/scratch
> overlay/071     [not run] overlay feature 'nfs_export' cannot be enabled on /mnt/scratch
>
> overlay/050 4s ... [not run] overlay feature 'nfs_export' cannot be enabled on /mnt/scratch
> overlay/051 3s ... [not run] overlay feature 'nfs_export' cannot be enabled on /mnt/scratch
> overlay/052 1s ... [not run] overlay feature 'nfs_export' cannot be enabled on /mnt/scratch
> overlay/053 2s ... [not run] overlay feature 'nfs_export' cannot be enabled on /mnt/scratch
> overlay/054 1s ... [not run] overlay feature 'nfs_export' cannot be enabled on /mnt/scratch
> overlay/055 1s ... [not run] overlay feature 'nfs_export' cannot be enabled on /mnt/scratch
>
>

It depends which filesystem you have as lower/upper or
which mount options you used for the xfstests setup.
dmesg should give you a clue for why nfs_export could not be
enabled on overlayfs.

Thanks,
Amir.
