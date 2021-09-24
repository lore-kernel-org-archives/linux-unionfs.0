Return-Path: <linux-unionfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7EC3CC433EF
	for <linux-unionfs@archiver.kernel.org>; Fri, 24 Sep 2021 19:01:24 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 602E160D07
	for <linux-unionfs@archiver.kernel.org>; Fri, 24 Sep 2021 19:01:24 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345869AbhIXTC5 (ORCPT
        <rfc822;linux-unionfs@archiver.kernel.org>);
        Fri, 24 Sep 2021 15:02:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45328 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1343938AbhIXTC4 (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Fri, 24 Sep 2021 15:02:56 -0400
Received: from mail-vs1-xe2a.google.com (mail-vs1-xe2a.google.com [IPv6:2607:f8b0:4864:20::e2a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 51EF6C061571
        for <linux-unionfs@vger.kernel.org>; Fri, 24 Sep 2021 12:01:23 -0700 (PDT)
Received: by mail-vs1-xe2a.google.com with SMTP id x74so11032931vsx.13
        for <linux-unionfs@vger.kernel.org>; Fri, 24 Sep 2021 12:01:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=szeredi.hu; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=r890+1Gcb3CTP0JCuwebHjL3At6b+an//SQJve5YXfc=;
        b=pspQEJt4bTup9rnwYHZ44sIWkJO4J7PGmuWKXtTVXu+1qqRKMjlGOwcbvPE/yVOD0n
         LyZc36MvQ5rUiYoyyV9lxttnmIchrsKi9eSJghitqqTXUTfwfgMVhfinZe2WnINnmp8/
         h5qrwudKVBx60JKU5B6x/WV3TcFLjP/KHpzyo=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=r890+1Gcb3CTP0JCuwebHjL3At6b+an//SQJve5YXfc=;
        b=K5x8dOUstl9lNZotrjn3HczwS45oKLkVzsr8mzi+hG3CIvBPlFBl0k3M+8n7J70V29
         R807ZRgEgX5ZqWJxLlefqiAC2dS6vU+wa5LEUXJ1rb7vuqlemZgVblLO69kkC9WmE3vk
         U15pov71eRzAclgD+bkWm1QGxG5Ni9AQMkAKG9838GF/5GGOcRgfHNasd+9Nz4C0pDjB
         PQi7rFxhvH8H2nJQEq0dOvnmuUOcFuZiO4/Poyq8/58CFCFvf4cQWja36FxEXUIzdjBr
         ux15ENoUa+CD+LyIOT30WTJuBMzdgTEOK9ibMSX6YdVgZB1YTx/dPM6SQH3cdWT4wOCP
         qjXA==
X-Gm-Message-State: AOAM531QDrZ574Vop/TiVViailoAQFzG53ZM1c8wZFQp2m9C3BoUTqep
        w7S70RQKlcxs8r5PJlWn5ufCL92rFTayi0o92uiEig==
X-Google-Smtp-Source: ABdhPJwwvE2Ys2BWH9Li367/n4Uv9vuwlYkMEhC+RBxYNb4Sf6fCDglulARn15Vb0uiSTY3KyYxDlKqtZQHxFMKM5ek=
X-Received: by 2002:a05:6102:3c3:: with SMTP id n3mr11508841vsq.19.1632510082446;
 Fri, 24 Sep 2021 12:01:22 -0700 (PDT)
MIME-Version: 1.0
References: <20210924011628.2069334-1-zhengliang6@huawei.com>
In-Reply-To: <20210924011628.2069334-1-zhengliang6@huawei.com>
From:   Miklos Szeredi <miklos@szeredi.hu>
Date:   Fri, 24 Sep 2021 21:01:11 +0200
Message-ID: <CAJfpegsOzWOryij91aRpJnXGVXnKf8jK90j-HEMWh8-hVShvxg@mail.gmail.com>
Subject: Re: [PATCH] ovl: fix oops in ovl_rename
To:     Zheng Liang <zhengliang6@huawei.com>
Cc:     overlayfs <linux-unionfs@vger.kernel.org>,
        "zhangyi (F)" <yi.zhang@huawei.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <linux-unionfs.vger.kernel.org>
X-Mailing-List: linux-unionfs@vger.kernel.org

On Fri, 24 Sept 2021 at 03:09, Zheng Liang <zhengliang6@huawei.com> wrote:
>
> We find a kernel NULL pointer dereference problem in overlayfs.
> The problem can appear in the following scene:
>
> mkdir lower upper work merge
> touch lower/old
> touch lower/new
> mount -t overlay overlay -olowerdir=3Dlower,upperdir=3Dupper,workdir=3Dwo=
rk merge
> rm merge/new
> -------------------------------------------------------------------------=
-----------------
> process A(rename file in merge)                                process B(=
delete file in upper)
> renameat2(AT_FDCWD, "old", AT_FDCWD, "new", 0)
> (new is whiteout file in upper)
>   do_renameat2
>     vfs_rename
>       ovl_rename
>       (overwrite=3Dtrue,ovl_lower_positive(old)=3Dtrue,
>       ovl_dentry_is_whiteout(new)=3Dtrue)
>       (we can add some delay after "flags|=3DRENAME_EXCHANGE",
>       it can make the problem appear more easy)
>       =E2=80=A6=E2=80=A6                                                 =
      unlink(new)
>       =E2=80=A6=E2=80=A6                                                 =
      (delete whiteout in upper)
>       (newdentry is negative)
>         ovl_do_rename
>
> So,before commencing with ovl_do_rename that the flags maybe attach RENAM=
E_EXCHANGE
> and the newdentry is negative in ovl_rename.If we enabled selinux,it
> will lead to kernel panic.such as the following log:
> PID: 2552045  TASK: ffff8880302faf00  CPU: 2   COMMAND: "fsstress"
>  #0 [ffff888080e772a0] machine_kexec at ffffffff856adedc
>  #1 [ffff888080e773a8] __crash_kexec at ffffffff8585cd20
>  #2 [ffff888080e774c0] panic at ffffffff8572b288
>  #3 [ffff888080e77590] oops_end at ffffffff85641f6e
>  #4 [ffff888080e775f0] __do_page_fault at ffffffff856cd55b
>  #5 [ffff888080e77668] do_page_fault at ffffffff856cd834
>  #6 [ffff888080e776a0] async_page_fault at ffffffff8660125e
>     [exception RIP: __inode_security_revalidate+34]
>     RIP: ffffffff85c43452  RSP: ffff888080e77758  RFLAGS: 00010202
>     RAX: 0000000000000000  RBX: 0000000000000000  RCX: ffffffff8593ae7e
>     RDX: 0000000000000000  RSI: 0000000000000297  RDI: 0000000000000297
>     RBP: ffff8881984e6628   R8: ffffed10115e3f39   R9: ffffed10115e3f39
>     R10: 0000000000000001  R11: ffffed10115e3f38  R12: 0000000000000001
>     R13: 0000000000000000  R14: ffff88808350a000  R15: 1ffff110101ceef5
>     ORIG_RAX: ffffffffffffffff  CS: 0010  SS: 0018
>  #7 [ffff888080e77780] selinux_inode_rename at ffffffff85c4418d
>  #8 [ffff888080e77858] security_inode_rename at ffffffff85c35f24
>  #9 [ffff888080e77890] vfs_rename at ffffffff85b01209
>  #10 [ffff888080e779a8] ovl_do_rename at ffffffffc0a44c22 [overlay]
>  #11 [ffff888080e779d8] ovl_rename at ffffffffc0a46575 [overlay]
>  #12 [ffff888080e77b48] vfs_rename at ffffffff85b0155a
>  #13 [ffff888080e77c60] do_renameat2 at ffffffff85b06e65
>  #14 [ffff888080e77f00] __x64_sys_renameat2 at ffffffff85b06fb2
>  #15 [ffff888080e77f30] do_syscall_64 at ffffffff85606243
>  #16 [ffff888080e77f50] entry_SYSCALL_64_after_hwframe at ffffffff866000a=
d
>
> We can add some check in ovl_rename for this scene and return error to av=
oid kernel panic.

Thanks.  Patch looks good; pushed to vfs.git#overlayfs-next (with a
cleaned up commit message).

Miklos
