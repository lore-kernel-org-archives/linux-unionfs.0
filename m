Return-Path: <linux-unionfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-11.4 required=3.0 tests=BAYES_00,DKIMWL_WL_MED,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_IN_DEF_DKIM_WL autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7D4E1C63798
	for <linux-unionfs@archiver.kernel.org>; Tue, 17 Nov 2020 07:57:11 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 2A4562083E
	for <linux-unionfs@archiver.kernel.org>; Tue, 17 Nov 2020 07:57:11 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="vr6WiLEj"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726851AbgKQH43 (ORCPT
        <rfc822;linux-unionfs@archiver.kernel.org>);
        Tue, 17 Nov 2020 02:56:29 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37516 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726249AbgKQH43 (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Tue, 17 Nov 2020 02:56:29 -0500
Received: from mail-qk1-x72b.google.com (mail-qk1-x72b.google.com [IPv6:2607:f8b0:4864:20::72b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B8B46C0617A6
        for <linux-unionfs@vger.kernel.org>; Mon, 16 Nov 2020 23:56:27 -0800 (PST)
Received: by mail-qk1-x72b.google.com with SMTP id q5so19575205qkc.12
        for <linux-unionfs@vger.kernel.org>; Mon, 16 Nov 2020 23:56:27 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:from:date:message-id:subject:to:cc;
        bh=H3l9soqm+SREQlc2IEV9Idb1VORHh3SoM0Ng1Iin3Dc=;
        b=vr6WiLEj6tAgdFqp8DIxItu5ALuLwg5H3eYuzD7j+uatZ4C4eKiUbT+iEZ9/EpFUWK
         4TR9TKVUhgAMbbNw7dtsPQy8IgImKzjGAYDzXIzcR97WWfJ643GCQzKaPRRZYyQ4mKxp
         8+oJCAhIYn0eKUFpUQakgVHsrmP42OW/15444w8IQDgBv0RJyi79iwYyHMG97SFYT/JT
         ZWFdO527yh16ZkaRMhEcDJsYA4O7WzCiPlScZhc+PiN+UiphivffRfHeLpZ8V3rRKY4o
         eEilw/r3h6MoPZatEz5gUwDVmtWfKnehx5CtjJkPwbPsHUeYibXKRx0pDo1bYyqvn0ti
         Ym5w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:from:date:message-id:subject:to:cc;
        bh=H3l9soqm+SREQlc2IEV9Idb1VORHh3SoM0Ng1Iin3Dc=;
        b=fEOjbyHzWeNOo2hSDA0a2N1bV9tWAiEMHVUe04W5rxu7FtXGE2EK/D9hzI8By1pQoO
         nltCNgL7Z1oaNOJluVifVkFtltMh4GoJjCJTl6KHNkh+4AE+L0WijFh6+HePlcK2kaBi
         PFtLnAsiYli7pwcO5SVKEfN9aaKRRQ3+NVJiKm27PxVH4zh1sGN9nG0ZMHo1kFWDO3w6
         BjMlC7+RKHHE0NF/lf/LwWTNdyl4hlYQKVULB7iZhT7gH6/eNogiHXDEgf1aduyj6krs
         3NTu1CWVBSxmRBDMBBJs46ZjsA+eM0aFGAUbojofIwoY0YGyPZIaO45O9N0thXFGXXWr
         2L/w==
X-Gm-Message-State: AOAM530Fnkaxd4OPHfP6sJX+kOy9PQQ8APb8PblLoFI6b3+7KF6wkts+
        I6Ce/N+Us/FG6yvsLimBOynDzUFDdRWqfpZMo5aJ7Q==
X-Google-Smtp-Source: ABdhPJwL37DcZAHwPAwGzv7dlhmnzGGHY07oktBGxXahSXeeXy9RHAITbjODhOe6w9v8GDK8fQ7Ue4Xm4a8RfzsD0aE=
X-Received: by 2002:a37:9747:: with SMTP id z68mr17899362qkd.424.1605599786651;
 Mon, 16 Nov 2020 23:56:26 -0800 (PST)
MIME-Version: 1.0
From:   Dmitry Vyukov <dvyukov@google.com>
Date:   Tue, 17 Nov 2020 08:56:15 +0100
Message-ID: <CACT4Y+bUfavwMVv2SEMve5pabE_AwsDO0YsRBGZtYqX59a77vA@mail.gmail.com>
Subject: suspicious capability check in ovl_ioctl_set_flags
To:     Miklos Szeredi <miklos@szeredi.hu>,
        overlayfs <linux-unionfs@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
Cc:     Alexander Potapenko <glider@google.com>,
        Merna Zakaria <mernazakaria@google.com>,
        kasan-dev <kasan-dev@googlegroups.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-unionfs.vger.kernel.org>
X-Mailing-List: linux-unionfs@vger.kernel.org

Hi Miklos,

We've detected a suspicious double-fetch of user-space data in
ovl_ioctl_set_flags using a prototype tool (see report below [1]).

It points to ovl_ioctl_set_flags that does a capability check using
flags, but then the real ioctl double-fetches flags and uses
potentially different value:

static long ovl_ioctl_set_flags(struct file *file, unsigned int cmd,
                unsigned long arg, unsigned int flags)
{
...
    /* Check the capability before cred override */
    oldflags = ovl_iflags_to_fsflags(READ_ONCE(inode->i_flags));
    ret = vfs_ioc_setflags_prepare(inode, oldflags, flags);
    if (ret)
        goto unlock;
...
    ret = ovl_real_ioctl(file, cmd, arg);

All fs impls call vfs_ioc_setflags_prepare again, so the capability is
checked again.

But I think this makes the vfs_ioc_setflags_prepare check in overlayfs
pointless (?) and the "Check the capability before cred override"
comment misleading, user can skip this check by presenting benign
flags first and then overwriting them to non-benign flags. Or, if this
check is still needed... it is wrong (?). The code would need to
arrange for both ioctl's to operate on the same data then.
Does it make any sense?
Thanks

[1] BUG: multi-read in __x64_sys_ioctl  between ovl_ioctl and ext4_ioctl
======= First Address Range Stack =======
 df_save_stack+0x33/0x70 lib/df-detection.c:208
 add_address+0x2ac/0x352 lib/df-detection.c:47
 ovl_ioctl_set_fsflags fs/overlayfs/file.c:607 [inline]
 ovl_ioctl+0x7d/0x290 fs/overlayfs/file.c:654
 vfs_ioctl fs/ioctl.c:48 [inline]
 __do_sys_ioctl fs/ioctl.c:753 [inline]
 __se_sys_ioctl fs/ioctl.c:739 [inline]
 __x64_sys_ioctl+0xfc/0x140 fs/ioctl.c:739
 do_syscall_64+0x2d/0x70 arch/x86/entry/common.c:46
 entry_SYSCALL_64_after_hwframe+0x44/0xa9
======= Second Address Range Stack =======
 df_save_stack+0x33/0x70 lib/df-detection.c:208
 add_address+0x2ac/0x352 lib/df-detection.c:47
 ext4_ioctl+0x13b1/0x27f0 fs/ext4/ioctl.c:833
 vfs_ioctl+0x30/0x80 fs/ioctl.c:48
 ovl_real_ioctl+0xed/0x100 fs/overlayfs/file.c:539
 ovl_ioctl_set_flags+0x11d/0x180 fs/overlayfs/file.c:574
 ovl_ioctl_set_fsflags fs/overlayfs/file.c:610 [inline]
 ovl_ioctl+0x11e/0x290 fs/overlayfs/file.c:654
 vfs_ioctl fs/ioctl.c:48 [inline]
 __do_sys_ioctl fs/ioctl.c:753 [inline]
 __se_sys_ioctl fs/ioctl.c:739 [inline]
 __x64_sys_ioctl+0xfc/0x140 fs/ioctl.c:739
 do_syscall_64+0x2d/0x70 arch/x86/entry/common.c:46
 entry_SYSCALL_64_after_hwframe+0x44/0xa9
syscall number 16  System Call: __x64_sys_ioctl+0x0/0x140 fs/ioctl.c:800
First 0000000020000000 len 4 Caller vfs_ioctl fs/ioctl.c:48 [inline]
First 0000000020000000 len 4 Caller __do_sys_ioctl fs/ioctl.c:753 [inline]
First 0000000020000000 len 4 Caller __se_sys_ioctl fs/ioctl.c:739 [inline]
First 0000000020000000 len 4 Caller __x64_sys_ioctl+0xfc/0x140 fs/ioctl.c:739
Second 0000000020000000 len 4 Caller vfs_ioctl+0x30/0x80 fs/ioctl.c:48
==================================================================
