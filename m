Return-Path: <linux-unionfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.5 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5A960C2D0E4
	for <linux-unionfs@archiver.kernel.org>; Tue, 17 Nov 2020 08:58:54 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id DFF0F2463B
	for <linux-unionfs@archiver.kernel.org>; Tue, 17 Nov 2020 08:58:53 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=szeredi.hu header.i=@szeredi.hu header.b="OKvVi+Jx"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727028AbgKQI6d (ORCPT
        <rfc822;linux-unionfs@archiver.kernel.org>);
        Tue, 17 Nov 2020 03:58:33 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47132 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725947AbgKQI6c (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Tue, 17 Nov 2020 03:58:32 -0500
Received: from mail-vk1-xa29.google.com (mail-vk1-xa29.google.com [IPv6:2607:f8b0:4864:20::a29])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8905AC0613CF
        for <linux-unionfs@vger.kernel.org>; Tue, 17 Nov 2020 00:58:30 -0800 (PST)
Received: by mail-vk1-xa29.google.com with SMTP id m184so4351535vkb.9
        for <linux-unionfs@vger.kernel.org>; Tue, 17 Nov 2020 00:58:30 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=szeredi.hu; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=SHJFy/YZF0XB4eGF/ZvX/fiRUi3iszemfHnSFZkXlNY=;
        b=OKvVi+JxEmD2+psGAbyGXPeOLv8+JqivKOwIzQqu9FwRbF2CQ2PZwUdD5Tft7pB+lT
         p0JxjayOKIw8H8BuU2JElK5cvAG8OV9oyoqSuVZ6I01ttV1k4shF2uDgH+MdO5OHYCCT
         VV/YaOdH6/9NSMKdD9Hc4zyFFdynJbAh9Nqjg=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=SHJFy/YZF0XB4eGF/ZvX/fiRUi3iszemfHnSFZkXlNY=;
        b=QnfEng+czCsMwX4QSReKQvttT4GAiJpj/lUTC8gtPkZhgo12p8xd/LSCR0Yf1jdXBF
         pHZiJiiXScxEZ2jcgIFDCkQfl6te4U3bQX2nPXtX9YgwelJxNG3e0cmKHptruP7Wt7b9
         8DMC4FR/BoaFVSHqAIqs0ILAudR/gTX3gZfq20RBLSRU2nq2Y4W+CoLxHDFxLvQL6Vbv
         cRaE7z4qPlacj8k/kFbRMND+C7vyyxSQURYiwBlxGYwRgPisaryK0liILuuwiuZcpwKU
         /ijvv3sKOgDb4HuBEUJLO5VbebsMSahLQljYHFOWsBJYHKxKtgUUGMHT045idqoRwFYA
         LYQQ==
X-Gm-Message-State: AOAM530ruEsZXy3obOVRhADh8xfCueW1fHRDQfSR/fIVcGtUWb+zilpF
        Xy3D8qsaSDFp85paFjGYgexLMfTNzTJRDBgNkb2eMw==
X-Google-Smtp-Source: ABdhPJz7dVX7V4S5GX6p4Ws3QxlbSEWOxHA3mPIMcC/KgbBbY9HgY84i5+VQCIC021fFmrRGvEDpzrxSeQbjXOwwFD8=
X-Received: by 2002:ac5:c96c:: with SMTP id t12mr10487686vkm.19.1605603509197;
 Tue, 17 Nov 2020 00:58:29 -0800 (PST)
MIME-Version: 1.0
References: <CACT4Y+bUfavwMVv2SEMve5pabE_AwsDO0YsRBGZtYqX59a77vA@mail.gmail.com>
In-Reply-To: <CACT4Y+bUfavwMVv2SEMve5pabE_AwsDO0YsRBGZtYqX59a77vA@mail.gmail.com>
From:   Miklos Szeredi <miklos@szeredi.hu>
Date:   Tue, 17 Nov 2020 09:58:18 +0100
Message-ID: <CAJfpegvoiGb5R1Y2a+_rNgTXgfJD=kFrkXBn7zSZDHKxwe992Q@mail.gmail.com>
Subject: Re: suspicious capability check in ovl_ioctl_set_flags
To:     Dmitry Vyukov <dvyukov@google.com>
Cc:     overlayfs <linux-unionfs@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Alexander Potapenko <glider@google.com>,
        Merna Zakaria <mernazakaria@google.com>,
        kasan-dev <kasan-dev@googlegroups.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-unionfs.vger.kernel.org>
X-Mailing-List: linux-unionfs@vger.kernel.org

On Tue, Nov 17, 2020 at 8:56 AM Dmitry Vyukov <dvyukov@google.com> wrote:
>
> Hi Miklos,
>
> We've detected a suspicious double-fetch of user-space data in
> ovl_ioctl_set_flags using a prototype tool (see report below [1]).
>
> It points to ovl_ioctl_set_flags that does a capability check using
> flags, but then the real ioctl double-fetches flags and uses
> potentially different value:
>
> static long ovl_ioctl_set_flags(struct file *file, unsigned int cmd,
>                 unsigned long arg, unsigned int flags)
> {
> ...
>     /* Check the capability before cred override */
>     oldflags = ovl_iflags_to_fsflags(READ_ONCE(inode->i_flags));
>     ret = vfs_ioc_setflags_prepare(inode, oldflags, flags);
>     if (ret)
>         goto unlock;
> ...
>     ret = ovl_real_ioctl(file, cmd, arg);
>
> All fs impls call vfs_ioc_setflags_prepare again, so the capability is
> checked again.
>
> But I think this makes the vfs_ioc_setflags_prepare check in overlayfs
> pointless (?) and the "Check the capability before cred override"
> comment misleading, user can skip this check by presenting benign
> flags first and then overwriting them to non-benign flags. Or, if this
> check is still needed... it is wrong (?). The code would need to
> arrange for both ioctl's to operate on the same data then.
> Does it make any sense?

Yes, looks like an oversight.

The only way to fix this properly, AFAICS is to add i_op->setflags.

Will look into this.

Thanks,
Miklos



> Thanks
>
> [1] BUG: multi-read in __x64_sys_ioctl  between ovl_ioctl and ext4_ioctl
> ======= First Address Range Stack =======
>  df_save_stack+0x33/0x70 lib/df-detection.c:208
>  add_address+0x2ac/0x352 lib/df-detection.c:47
>  ovl_ioctl_set_fsflags fs/overlayfs/file.c:607 [inline]
>  ovl_ioctl+0x7d/0x290 fs/overlayfs/file.c:654
>  vfs_ioctl fs/ioctl.c:48 [inline]
>  __do_sys_ioctl fs/ioctl.c:753 [inline]
>  __se_sys_ioctl fs/ioctl.c:739 [inline]
>  __x64_sys_ioctl+0xfc/0x140 fs/ioctl.c:739
>  do_syscall_64+0x2d/0x70 arch/x86/entry/common.c:46
>  entry_SYSCALL_64_after_hwframe+0x44/0xa9
> ======= Second Address Range Stack =======
>  df_save_stack+0x33/0x70 lib/df-detection.c:208
>  add_address+0x2ac/0x352 lib/df-detection.c:47
>  ext4_ioctl+0x13b1/0x27f0 fs/ext4/ioctl.c:833
>  vfs_ioctl+0x30/0x80 fs/ioctl.c:48
>  ovl_real_ioctl+0xed/0x100 fs/overlayfs/file.c:539
>  ovl_ioctl_set_flags+0x11d/0x180 fs/overlayfs/file.c:574
>  ovl_ioctl_set_fsflags fs/overlayfs/file.c:610 [inline]
>  ovl_ioctl+0x11e/0x290 fs/overlayfs/file.c:654
>  vfs_ioctl fs/ioctl.c:48 [inline]
>  __do_sys_ioctl fs/ioctl.c:753 [inline]
>  __se_sys_ioctl fs/ioctl.c:739 [inline]
>  __x64_sys_ioctl+0xfc/0x140 fs/ioctl.c:739
>  do_syscall_64+0x2d/0x70 arch/x86/entry/common.c:46
>  entry_SYSCALL_64_after_hwframe+0x44/0xa9
> syscall number 16  System Call: __x64_sys_ioctl+0x0/0x140 fs/ioctl.c:800
> First 0000000020000000 len 4 Caller vfs_ioctl fs/ioctl.c:48 [inline]
> First 0000000020000000 len 4 Caller __do_sys_ioctl fs/ioctl.c:753 [inline]
> First 0000000020000000 len 4 Caller __se_sys_ioctl fs/ioctl.c:739 [inline]
> First 0000000020000000 len 4 Caller __x64_sys_ioctl+0xfc/0x140 fs/ioctl.c:739
> Second 0000000020000000 len 4 Caller vfs_ioctl+0x30/0x80 fs/ioctl.c:48
> ==================================================================
