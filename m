Return-Path: <linux-unionfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B68CAC04A68
	for <linux-unionfs@archiver.kernel.org>; Thu, 28 Jul 2022 13:06:08 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238979AbiG1NGH (ORCPT
        <rfc822;linux-unionfs@archiver.kernel.org>);
        Thu, 28 Jul 2022 09:06:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44976 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238882AbiG1NGG (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Thu, 28 Jul 2022 09:06:06 -0400
Received: from mail-ed1-x530.google.com (mail-ed1-x530.google.com [IPv6:2a00:1450:4864:20::530])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 17449CD6
        for <linux-unionfs@vger.kernel.org>; Thu, 28 Jul 2022 06:06:03 -0700 (PDT)
Received: by mail-ed1-x530.google.com with SMTP id i13so2076345edj.11
        for <linux-unionfs@vger.kernel.org>; Thu, 28 Jul 2022 06:06:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=szeredi.hu; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=Zda77mg1ZZpOWsNvo8VG8yNV1v0c9vJN28zhGs4j7Co=;
        b=LiZHYy+VWInwHyqug4oZSVH4NIe032Ss239NP3GsmxgHC7dqSIjbPTuWe3EImLsHid
         HyfTrV+f+pSzH4+VxlB2HytHnDf7MEQd9Xftns9QUsAjd7ylxMx0HnI2/DsShcMG905K
         fuamrsR6PoaheVVy7tfC6cjcuwCLoRKUApQhY=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=Zda77mg1ZZpOWsNvo8VG8yNV1v0c9vJN28zhGs4j7Co=;
        b=uilHR6xIetH23HrBHteViZG3XIv85NjL4ozu65OBFB3KvsxJxGeZ+yt9xrt0Dt9a3j
         SvksnvuoqzUgXRKeZDEPXZnZ9lJcm2QHqTD3PyWJdHea8x2PBqK9PsHGD0XOL9UzIsVO
         1Jjc76Un2wRQ/N4PdesyaQ5ZEv+31bpeW6EWXj4gQ5JpZYynOHZO1MDG03ZEXtyRgAZZ
         vmv66z1YKPd1axMDtBR21Kk0ubF3sFDty4uZsVB+kokix9j1ZSI5a2oTfXiOQIZQa9Zb
         9FqHP+SHjEsehw83OJPca8KlKbA9FaXHHwP19KFUN08282SvaXDjDq3GfBWX3Yft+E6D
         FylQ==
X-Gm-Message-State: AJIora/eVwV06P+RYC1P6DozLDrVDt2qKGNy7nzCbq1DY+/sph8/sTS4
        OO86yqu1kmhfNm/HIO+OmLDpw90Fil2ywqEiLgg5kQ==
X-Google-Smtp-Source: AGRyM1tOXQ83oiijld594L1K/qs5gc3SWYDeihnffqaM2IEgRBgLJ6intgsdVQkHW12Iqu0p07tPfY25Yv9nGgVh1EM=
X-Received: by 2002:a05:6402:5201:b0:43b:f621:3ce0 with SMTP id
 s1-20020a056402520100b0043bf6213ce0mr20847294edd.22.1659013561468; Thu, 28
 Jul 2022 06:06:01 -0700 (PDT)
MIME-Version: 1.0
References: <20220728114915.91021-1-zhangjiachen.jaycee@bytedance.com>
In-Reply-To: <20220728114915.91021-1-zhangjiachen.jaycee@bytedance.com>
From:   Miklos Szeredi <miklos@szeredi.hu>
Date:   Thu, 28 Jul 2022 15:05:50 +0200
Message-ID: <CAJfpegtxUrytqTFjVG0J03ZmEzzpFr8Ra1KP8HiZNPzTtgY3kw@mail.gmail.com>
Subject: Re: [PATCH v2] ovl: drop WARN_ON() dentry is NULL in ovl_encode_fh()
To:     Jiachen Zhang <zhangjiachen.jaycee@bytedance.com>
Cc:     overlayfs <linux-unionfs@vger.kernel.org>,
        linux-kernel@vger.kernel.org, songmuchun@bytedance.com,
        Hongbo Yin <yinhongbo@bytedance.com>,
        Tianci Zhang <zhangtianci.1997@bytedance.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-unionfs.vger.kernel.org>
X-Mailing-List: linux-unionfs@vger.kernel.org

On Thu, 28 Jul 2022 at 13:49, Jiachen Zhang
<zhangjiachen.jaycee@bytedance.com> wrote:
>
> Some code paths cannot guarantee the inode have any dentry alias. So
> WARN_ON() all !dentry may flood the kernel logs.
>
> For example, when an overlayfs inode is watched by inotifywait (1), and
> someone is trying to read the /proc/$(pidof inotifywait)/fdinfo/INOTIFY_FD,
> at that time if the dentry has been reclaimed by kernel (such as
> echo 2 > /proc/sys/vm/drop_caches), there will be a WARN_ON(). The
> printed call stack would be like:
>
>     ? show_mark_fhandle+0xf0/0xf0
>     show_mark_fhandle+0x4a/0xf0
>     ? show_mark_fhandle+0xf0/0xf0
>     ? seq_vprintf+0x30/0x50
>     ? seq_printf+0x53/0x70
>     ? show_mark_fhandle+0xf0/0xf0
>     inotify_fdinfo+0x70/0x90
>     show_fdinfo.isra.4+0x53/0x70
>     seq_show+0x130/0x170
>     seq_read+0x153/0x440
>     vfs_read+0x94/0x150
>     ksys_read+0x5f/0xe0
>     do_syscall_64+0x59/0x1e0
>     entry_SYSCALL_64_after_hwframe+0x44/0xa9
>
> So let's drop WARN_ON() to avoid kernel log flooding.


Applied, thanks.

Miklos
