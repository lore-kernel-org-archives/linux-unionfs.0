Return-Path: <linux-unionfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C99D4C433EF
	for <linux-unionfs@archiver.kernel.org>; Fri, 29 Oct 2021 08:35:24 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id A6CD761177
	for <linux-unionfs@archiver.kernel.org>; Fri, 29 Oct 2021 08:35:24 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232437AbhJ2Ihw (ORCPT
        <rfc822;linux-unionfs@archiver.kernel.org>);
        Fri, 29 Oct 2021 04:37:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49444 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232416AbhJ2Ihv (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Fri, 29 Oct 2021 04:37:51 -0400
Received: from mail-ua1-x92f.google.com (mail-ua1-x92f.google.com [IPv6:2607:f8b0:4864:20::92f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8A807C061570
        for <linux-unionfs@vger.kernel.org>; Fri, 29 Oct 2021 01:35:23 -0700 (PDT)
Received: by mail-ua1-x92f.google.com with SMTP id v20so16746453uaj.9
        for <linux-unionfs@vger.kernel.org>; Fri, 29 Oct 2021 01:35:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=szeredi.hu; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=2j9UFo5BKyTs5CJl5gBC+bcV7k1F0YXnE7EekC5Ar3c=;
        b=ITC9seViBbXjrS2ABvLp5fvYQ5KNP9fYwqFJgc2EhNB6wiT3s7hWzkVoi1H8MJ07Kp
         bTpsjS6E94cETa3J3tebCDOmeJgp5c2tbIqgd0yxUxh21FsHCVB1+ZfNvXjGMQ09BONq
         iUIktcQZuDiSKN2bEuyrw82ebNZGfm/SrjOYU=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=2j9UFo5BKyTs5CJl5gBC+bcV7k1F0YXnE7EekC5Ar3c=;
        b=H6y1rqBgAx3+qeUDd+gWTvhRRmy0H0HpyALNJRIRAwMz3vWmNsxXKjqk+5l3j04wlw
         oopMAoi0glbBl7IgaCp0hELaXVQUJtoa15XNJFKq3MSGH2znYzfaj1+CM04wKylhTLQe
         PRffd6vmTW8opbxxxnfSj9P6xmd/dnV1bJqrYwsxcVvFFAW3J7Z2hMuReGmlx+PiMNq2
         ZEB294Opn1huS0pffx9E6X0X2q+u15Db61AxFDlY/x9+JKJXXtC5SiuA9cQa7Q5FAXHv
         HBQSx2sMclDEcRoxM0eBv97NNB0BZn/SjUqEqjh0d1dyy8Fa9HY2SiAva3Cj0URNwAv3
         ZdcA==
X-Gm-Message-State: AOAM533gL2bYb6KRmfLKq15KvawYVwEKlNfbpXYNKL0OlLUSFSP035Ua
        zYfomjJZzD2fpUJJWFe3jlUKxO6uSOMOW1/6FfgFkw==
X-Google-Smtp-Source: ABdhPJzAyXY0So3IOSjwQuCB0wYxz/d70SIASHkS7TwXLi8CLAU+B7YJW7oJkLFGstYMEuq3hQ9DMez2ezm2tllbHng=
X-Received: by 2002:a67:ec94:: with SMTP id h20mr10540574vsp.59.1635496522731;
 Fri, 29 Oct 2021 01:35:22 -0700 (PDT)
MIME-Version: 1.0
References: <20210930032228.3199690-1-yangerkun@huawei.com>
 <20210930032228.3199690-3-yangerkun@huawei.com> <CAJfpeguSczH6E6AA+gL1ZVd37H-h4Nekw-e-FW=g6+S5qsKztQ@mail.gmail.com>
 <5617bd21-7495-98b6-d2c9-4fec23f1411d@huawei.com> <401efae5-da00-b398-5895-fe6201e93096@huawei.com>
In-Reply-To: <401efae5-da00-b398-5895-fe6201e93096@huawei.com>
From:   Miklos Szeredi <miklos@szeredi.hu>
Date:   Fri, 29 Oct 2021 10:35:12 +0200
Message-ID: <CAJfpegvFrsdAAKwxUrZQp509MgyD+r4nApnY8fJcaW6Rb56Wrg@mail.gmail.com>
Subject: Re: [PATCH 2/2] ovl: fix UAF for ovl_aio_req
To:     yangerkun <yangerkun@huawei.com>
Cc:     Amir Goldstein <amir73il@gmail.com>,
        Jiufei Xue <jiufei.xue@linux.alibaba.com>,
        overlayfs <linux-unionfs@vger.kernel.org>, yukuai3@huawei.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <linux-unionfs.vger.kernel.org>
X-Mailing-List: linux-unionfs@vger.kernel.org

On Thu, 28 Oct 2021 at 14:41, yangerkun <yangerkun@huawei.com> wrote:
>
>
>
> =E5=9C=A8 2021/10/18 22:26, yangerkun =E5=86=99=E9=81=93:
> >
> >
> > =E5=9C=A8 2021/10/8 23:13, Miklos Szeredi =E5=86=99=E9=81=93:
> >> On Thu, 30 Sept 2021 at 05:12, yangerkun <yangerkun@huawei.com> wrote:
> >>>
> >>> Our testcase trigger follow UAF:
> >>>
> >>> [  153.939147]
> >>> =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> >>> [  153.942199] BUG: KASAN: use-after-free in
> >>> ext4_dio_read_iter+0xcc/0x1a0
> >>> [  153.943331] Read of size 8 at addr ffff88803b7f1500 by task
> >>> fsstress/726
> >>> [  153.948182] Call Trace:
> >>> [  153.948628]  ? dump_stack_lvl+0x73/0x9f
> >>> [  153.950255]  ? ext4_dio_read_iter+0xcc/0x1a0
> >>> [  153.950972]  ? ext4_dio_read_iter+0xcc/0x1a0
> >>> [  153.951693]  ? kasan_report.cold+0x81/0x165
> >>> [  153.952429]  ? ext4_dio_read_iter+0xcc/0x1a0
> >>> [  153.953190]  ? __asan_load8+0x74/0x110
> >>> [  153.953856]  ? ext4_dio_read_iter+0xcc/0x1a0
> >>> [  153.954612]  ? ext4_file_read_iter+0x1df/0x2a0
> >>> [  153.955394]  ? ext4_dio_read_iter+0x1a0/0x1a0
> >>> [  153.956159]  ? vfs_iocb_iter_read+0xd5/0x330
> >>> [  153.956916]  ? ovl_read_iter+0x15f/0x270
> >>> [  153.957605]  ? ovl_aio_cleanup_handler+0x2a0/0x2a0
> >>> [  153.958436]  ? aio_setup_rw+0xbf/0xe0
> >>> [  153.959101]  ? aio_read+0x190/0x2d0
> >>> [  153.959750]  ? aio_write+0x3e0/0x3e0
> >>> [  153.960404]  ? __kasan_check_read+0x1d/0x30
> >>> [  153.961167]  ? ext4_file_getattr+0x116/0x1b0
> >>> [  153.961978]  ? __put_user_ns+0x40/0x40
> >>> [  153.962714]  ? kasan_poison+0x40/0x90
> >>> [  153.963384]  ? set_alloc_info+0x46/0x70
> >>> [  153.964102]  ? __kasan_check_write+0x20/0x30
> >>> [  153.964856]  ? __fget_files+0x106/0x180
> >>> [  153.965571]  ? io_submit_one+0xaa7/0x1480
> >>> [  153.966325]  ? aio_poll_complete_work+0x590/0x590
> >>> [  153.967713]  ? ioctl_file_clone+0x110/0x110
> >>> [  153.969008]  ? vfs_getattr_nosec+0x14a/0x190
> >>> [  153.970539]  ? __do_sys_newfstat+0xd6/0xf0
> >>> [  153.971713]  ? __ia32_compat_sys_newfstat+0x40/0x40
> >>> [  153.973005]  ? __x64_sys_io_submit+0x125/0x3b0
> >>> [  153.974282]  ? __ia32_sys_io_submit+0x390/0x390
> >>> [  153.975575]  ? __kasan_check_read+0x1d/0x30
> >>> [  153.976749]  ? do_syscall_64+0x35/0x80
> >>> [  153.978034]  ? entry_SYSCALL_64_after_hwframe+0x44/0xae
> >>> [  153.979436]
> >>> [  153.979738] Allocated by task 726:
> >>> [  153.980352]  kasan_save_stack+0x23/0x60
> >>> [  153.981054]  set_alloc_info+0x46/0x70
> >>> [  153.981745]  __kasan_slab_alloc+0x4c/0x90
> >>> [  153.982492]  kmem_cache_alloc+0x153/0x750
> >>> [  153.983953]  ovl_read_iter+0x13b/0x270
> >>> [  153.984689]  aio_read+0x190/0x2d0
> >>> [  153.985332]  io_submit_one+0xaa7/0x1480
> >>> [  153.986060]  __x64_sys_io_submit+0x125/0x3b0
> >>> [  153.986878]  do_syscall_64+0x35/0x80
> >>> [  153.987590]  entry_SYSCALL_64_after_hwframe+0x44/0xae
> >>> [  153.988516]
> >>> [  153.988824] Freed by task 750:
> >>> [  153.989417]  kasan_save_stack+0x23/0x60
> >>> [  153.990140]  kasan_set_track+0x24/0x40
> >>> [  153.990871]  kasan_set_free_info+0x30/0x60
> >>> [  153.991639]  __kasan_slab_free+0x137/0x210
> >>> [  153.992390]  kmem_cache_free+0xf8/0x590
> >>> [  153.993303]  ovl_aio_cleanup_handler+0x1ae/0x2a0
> >>> [  153.994205]  ovl_aio_rw_complete+0x31/0x60
> >>> [  153.995043]  iomap_dio_complete_work+0x4b/0x60
> >>> [  153.995898]  iomap_dio_bio_end_io+0x23d/0x270
> >>> [  153.996742]  bio_endio+0x40d/0x440
> >>> [  153.997376]  blk_update_request+0x38f/0x820
> >>> [  153.998160]  scsi_end_request+0x56/0x320
> >>> [  153.998872]  scsi_io_completion+0x10a/0xb60
> >>> [  153.999655]  scsi_finish_command+0x194/0x2b0
> >>> [  154.000464]  scsi_complete+0xd7/0x1f0
> >>> [  154.001184]  blk_complete_reqs+0x92/0xb0
> >>> [  154.001930]  blk_done_softirq+0x29/0x40
> >>> [  154.002696]  __do_softirq+0x133/0x57f
> >>>
> >>> ext4_dio_read_iter
> >>>    ret =3D iomap_dio_rw(iocb, to, &ext4_iomap_ops, NULL, 0)
> >>>    file_accessed(iocb->ki_filp) <=3D=3D this trigger UAF
> >>>
> >>> Ret can be -EIOCBQUEUED which means we will not wait for io
> >>> completion in
> >>> iomap_dio_rw. So the release for ovl_aio_req will be done when io
> >>> completion routine call ovl_aio_rw_complete(or ovl_aio_cleanup_handle=
r
> >>> in ovl_read_iter will do this). But once io finish soon, we may alrea=
dy
> >>> release ovl_aio_req before we call file_access in ext4_dio_read_iter.
> >>> This can trigger the upper UAF.
> >>>
> >>> Fix it by introduce refcount in ovl_aio_req like what aio_kiocb has d=
id.
> >>
> >> Looks good at a glance.   Will review more fully.
> >
> > Hi,
> >
> > Any comments for this patch? :)
>
> Ping...

Now looking...

Thanks,
Miklos
