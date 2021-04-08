Return-Path: <linux-unionfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.6 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 345D8C433B4
	for <linux-unionfs@archiver.kernel.org>; Thu,  8 Apr 2021 09:58:24 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id F065361104
	for <linux-unionfs@archiver.kernel.org>; Thu,  8 Apr 2021 09:58:23 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231305AbhDHJ6e (ORCPT
        <rfc822;linux-unionfs@archiver.kernel.org>);
        Thu, 8 Apr 2021 05:58:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48790 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230351AbhDHJ6c (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Thu, 8 Apr 2021 05:58:32 -0400
Received: from mail-vs1-xe2d.google.com (mail-vs1-xe2d.google.com [IPv6:2607:f8b0:4864:20::e2d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F06EFC061760
        for <linux-unionfs@vger.kernel.org>; Thu,  8 Apr 2021 02:58:21 -0700 (PDT)
Received: by mail-vs1-xe2d.google.com with SMTP id t25so804410vsq.10
        for <linux-unionfs@vger.kernel.org>; Thu, 08 Apr 2021 02:58:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=szeredi.hu; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=vqkcfcLmWPSwGQ7DXIyIlAdTx4eIhz1g0fE/uj8Jq5Q=;
        b=ak4tVPm2ajctg+hnsjp8GHDd5d8rnO+htwb7t/lo2NiatS+hRAXSYXtJ2BFjM6x48U
         pnA3KNNoIxXJdN3FUU5ajyCgsw02XIyHzdNzHBN+7meSGNIFDBPp1Wn0sT3/G/RLW0Wd
         MKbnV+cT/6M5eRpLsuP/tywNIa+EUWls2KYUk=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=vqkcfcLmWPSwGQ7DXIyIlAdTx4eIhz1g0fE/uj8Jq5Q=;
        b=CyI5Oq1j+tRoPztzmzVG+IC3O3AcPkkAzzE2j3jwvJ+HpuNryqEgS0Oo1KxhGfn7S8
         NRDr6DpNriz1bHq3273E615fEP5mzbs/DPkWxnsO7bGVWPhBodqPtBgh5J0x8grDYjnJ
         3mFSXd6s6hwP9D/zalS4i1FhkFxqRhw1pevnoWxX3eHERwvHdTzA12fe0RZ4xoewzPbo
         G9yT1D0145vjH2kUvZREkr1q/cME+f0LuvTJeAbPptV3upWOUkLa26kwHuGGlHSBSbmk
         5VwoXGvlWTSqN70hVwKoEBoylJL+UlCbdsWA/zvAxxLZaCZxuY7f56ltqjCQ4dfXRc5l
         WCRw==
X-Gm-Message-State: AOAM532qnWbCMfFFfxHIv+YHP3ah/5ojq11x4geQbOyFeEe7VaI2MYRD
        SIG7aHGsamAHiDy1V6m/LZoRSQZC6RRD+BKg32B7JA==
X-Google-Smtp-Source: ABdhPJyjZoMXzPL6CXTNPSH+BhhMdLuVrO7eLmf1th5EWTHfKQwxBWgSOV4WX90df7ZbQ6ru8A72X72+OSsEU0sNU2I=
X-Received: by 2002:a67:b005:: with SMTP id z5mr4869666vse.47.1617875901207;
 Thu, 08 Apr 2021 02:58:21 -0700 (PDT)
MIME-Version: 1.0
References: <20210329164907.2133175-1-mic@digikod.net>
In-Reply-To: <20210329164907.2133175-1-mic@digikod.net>
From:   Miklos Szeredi <miklos@szeredi.hu>
Date:   Thu, 8 Apr 2021 11:58:10 +0200
Message-ID: <CAJfpegu=8L7Fd_qYK0cJRQ18NqyVeSvTp-vcC4KmqZEcw28naw@mail.gmail.com>
Subject: Re: [PATCH v1] ovl: Fix leaked dentry
To:     =?UTF-8?B?TWlja2HDq2wgU2FsYcO8bg==?= <mic@digikod.net>
Cc:     linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        overlayfs <linux-unionfs@vger.kernel.org>,
        Amir Goldstein <amir73il@gmail.com>,
        Vivek Goyal <vgoyal@redhat.com>,
        stable <stable@vger.kernel.org>,
        syzbot <syzkaller@googlegroups.com>,
        =?UTF-8?B?TWlja2HDq2wgU2FsYcO8bg==?= <mic@linux.microsoft.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <linux-unionfs.vger.kernel.org>
X-Mailing-List: linux-unionfs@vger.kernel.org

On Mon, Mar 29, 2021 at 6:48 PM Micka=C3=ABl Sala=C3=BCn <mic@digikod.net> =
wrote:
>
> From: Micka=C3=ABl Sala=C3=BCn <mic@linux.microsoft.com>
>
> Since commit 6815f479ca90 ("ovl: use only uppermetacopy state in
> ovl_lookup()"), overlayfs doesn't put temporary dentry when there is a
> metacopy error, which leads to dentry leaks when shutting down the
> related superblock:
>
>   overlayfs: refusing to follow metacopy origin for (/file0)
>   ...
>   BUG: Dentry (____ptrval____){i=3D3f33,n=3Dfile3}  still in use (1) [unm=
ount of overlay overlay]
>   ...
>   WARNING: CPU: 1 PID: 432 at umount_check.cold+0x107/0x14d
>   CPU: 1 PID: 432 Comm: unmount-overlay Not tainted 5.12.0-rc5 #1
>   ...
>   RIP: 0010:umount_check.cold+0x107/0x14d
>   ...
>   Call Trace:
>    d_walk+0x28c/0x950
>    ? dentry_lru_isolate+0x2b0/0x2b0
>    ? __kasan_slab_free+0x12/0x20
>    do_one_tree+0x33/0x60
>    shrink_dcache_for_umount+0x78/0x1d0
>    generic_shutdown_super+0x70/0x440
>    kill_anon_super+0x3e/0x70
>    deactivate_locked_super+0xc4/0x160
>    deactivate_super+0xfa/0x140
>    cleanup_mnt+0x22e/0x370
>    __cleanup_mnt+0x1a/0x30
>    task_work_run+0x139/0x210
>    do_exit+0xb0c/0x2820
>    ? __kasan_check_read+0x1d/0x30
>    ? find_held_lock+0x35/0x160
>    ? lock_release+0x1b6/0x660
>    ? mm_update_next_owner+0xa20/0xa20
>    ? reacquire_held_locks+0x3f0/0x3f0
>    ? __sanitizer_cov_trace_const_cmp4+0x22/0x30
>    do_group_exit+0x135/0x380
>    __do_sys_exit_group.isra.0+0x20/0x20
>    __x64_sys_exit_group+0x3c/0x50
>    do_syscall_64+0x45/0x70
>    entry_SYSCALL_64_after_hwframe+0x44/0xae
>   ...
>   VFS: Busy inodes after unmount of overlay. Self-destruct in 5 seconds. =
 Have a nice day...
>
> This fix has been tested with a syzkaller reproducer.
>
> Cc: Amir Goldstein <amir73il@gmail.com>
> Cc: Miklos Szeredi <miklos@szeredi.hu>
> Cc: Vivek Goyal <vgoyal@redhat.com>
> Cc: <stable@vger.kernel.org> # v5.7+
> Reported-by: syzbot <syzkaller@googlegroups.com>
> Fixes: 6815f479ca90 ("ovl: use only uppermetacopy state in ovl_lookup()")
> Signed-off-by: Micka=C3=ABl Sala=C3=BCn <mic@linux.microsoft.com>
> Link: https://lore.kernel.org/r/20210329164907.2133175-1-mic@digikod.net

Thanks, applied.

Miklos
