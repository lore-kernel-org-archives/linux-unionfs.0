Return-Path: <linux-unionfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,
	FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 81D8AC433F5
	for <linux-unionfs@archiver.kernel.org>; Fri, 24 Sep 2021 07:21:28 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 69AFC60F21
	for <linux-unionfs@archiver.kernel.org>; Fri, 24 Sep 2021 07:21:28 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244320AbhIXHXA convert rfc822-to-8bit (ORCPT
        <rfc822;linux-unionfs@archiver.kernel.org>);
        Fri, 24 Sep 2021 03:23:00 -0400
Received: from n169-111.mail.139.com ([120.232.169.111]:46537 "EHLO
        n169-111.mail.139.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244191AbhIXHW7 (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Fri, 24 Sep 2021 03:22:59 -0400
X-Greylist: delayed 560 seconds by postgrey-1.27 at vger.kernel.org; Fri, 24 Sep 2021 03:22:59 EDT
X-RM-TagInfo: emlType=0                                       
X-RM-SPAM:                                                                                        
X-RM-SPAM-FLAG: 00000000
Received: from smtpclient.apple (unknown[59.37.125.124])
        by rmsmtp-lg-appmail-16-12015 (RichMail) with SMTP id 2eef614d7a43db7-aacda;
        Fri, 24 Sep 2021 15:12:04 +0800 (CST)
X-RM-TRANSID: 2eef614d7a43db7-aacda
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
Mime-Version: 1.0 (1.0)
Subject: Re: [PATCH] ovl: fix oops in ovl_rename
From:   139 <cgxu519@139.com>
In-Reply-To: <20210924011628.2069334-1-zhengliang6@huawei.com>
Date:   Fri, 24 Sep 2021 15:12:03 +0800
Cc:     miklos@szeredi.hu, linux-unionfs@vger.kernel.org,
        yi.zhang@huawei.com
Message-Id: <E376E38A-ABB0-4E20-B7C8-980F8CFC2047@139.com>
References: <20210924011628.2069334-1-zhengliang6@huawei.com>
To:     Zheng Liang <zhengliang6@huawei.com>
X-Mailer: iPhone Mail (18G82)
Precedence: bulk
List-ID: <linux-unionfs.vger.kernel.org>
X-Mailing-List: linux-unionfs@vger.kernel.org

在 2021年9月24日，09:09，Zheng Liang <zhengliang6@huawei.com> 写道：
> 
> ﻿We find a kernel NULL pointer dereference problem in overlayfs.
> The problem can appear in the following scene:
> 
> mkdir lower upper work merge
> touch lower/old
> touch lower/new
> mount -t overlay overlay -olowerdir=lower,upperdir=upper,workdir=work merge
> rm merge/new
> ------------------------------------------------------------------------------------------
> process A(rename file in merge)                                process B(delete file in upper)
> renameat2(AT_FDCWD, "old", AT_FDCWD, "new", 0)
> (new is whiteout file in upper)
>  do_renameat2
>    vfs_rename
>      ovl_rename
>      (overwrite=true,ovl_lower_positive(old)=true,
>      ovl_dentry_is_whiteout(new)=true)
>      (we can add some delay after "flags|=RENAME_EXCHANGE",
>      it can make the problem appear more easy)
>      ……                                                       unlink(new)
>      ……                                                       (delete whiteout in upper)
>      (newdentry is negative)
>        ovl_do_rename

Is it a real use case? I believe there will be many unexpected behaviors if you delete the files in upper layer deliberately.

Thanks,
Chengguang



> 
> So,before commencing with ovl_do_rename that the flags maybe attach RENAME_EXCHANGE
> and the newdentry is negative in ovl_rename.If we enabled selinux,it
> will lead to kernel panic.such as the following log:
> PID: 2552045  TASK: ffff8880302faf00  CPU: 2   COMMAND: "fsstress"
> #0 [ffff888080e772a0] machine_kexec at ffffffff856adedc
> #1 [ffff888080e773a8] __crash_kexec at ffffffff8585cd20
> #2 [ffff888080e774c0] panic at ffffffff8572b288
> #3 [ffff888080e77590] oops_end at ffffffff85641f6e
> #4 [ffff888080e775f0] __do_page_fault at ffffffff856cd55b
> #5 [ffff888080e77668] do_page_fault at ffffffff856cd834
> #6 [ffff888080e776a0] async_page_fault at ffffffff8660125e
>    [exception RIP: __inode_security_revalidate+34]
>    RIP: ffffffff85c43452  RSP: ffff888080e77758  RFLAGS: 00010202
>    RAX: 0000000000000000  RBX: 0000000000000000  RCX: ffffffff8593ae7e
>    RDX: 0000000000000000  RSI: 0000000000000297  RDI: 0000000000000297
>    RBP: ffff8881984e6628   R8: ffffed10115e3f39   R9: ffffed10115e3f39
>    R10: 0000000000000001  R11: ffffed10115e3f38  R12: 0000000000000001
>    R13: 0000000000000000  R14: ffff88808350a000  R15: 1ffff110101ceef5
>    ORIG_RAX: ffffffffffffffff  CS: 0010  SS: 0018
> #7 [ffff888080e77780] selinux_inode_rename at ffffffff85c4418d
> #8 [ffff888080e77858] security_inode_rename at ffffffff85c35f24
> #9 [ffff888080e77890] vfs_rename at ffffffff85b01209
> #10 [ffff888080e779a8] ovl_do_rename at ffffffffc0a44c22 [overlay]
> #11 [ffff888080e779d8] ovl_rename at ffffffffc0a46575 [overlay]
> #12 [ffff888080e77b48] vfs_rename at ffffffff85b0155a
> #13 [ffff888080e77c60] do_renameat2 at ffffffff85b06e65
> #14 [ffff888080e77f00] __x64_sys_renameat2 at ffffffff85b06fb2
> #15 [ffff888080e77f30] do_syscall_64 at ffffffff85606243
> #16 [ffff888080e77f50] entry_SYSCALL_64_after_hwframe at ffffffff866000ad
> 
> We can add some check in ovl_rename for this scene and return error to avoid kernel panic.
> 
> Signed-off-by: Zheng Liang <zhengliang6@huawei.com>
> ---
> fs/overlayfs/dir.c | 10 +++++++---
> 1 file changed, 7 insertions(+), 3 deletions(-)
> 
> diff --git a/fs/overlayfs/dir.c b/fs/overlayfs/dir.c
> index 1fefb2b8960e..93c7c267de93 100644
> --- a/fs/overlayfs/dir.c
> +++ b/fs/overlayfs/dir.c
> @@ -1219,9 +1219,13 @@ static int ovl_rename(struct user_namespace *mnt_userns, struct inode *olddir,
>                goto out_dput;
>        }
>    } else {
> -        if (!d_is_negative(newdentry) &&
> -            (!new_opaque || !ovl_is_whiteout(newdentry)))
> -            goto out_dput;
> +        if (!d_is_negative(newdentry)) {
> +            if (!new_opaque || !ovl_is_whiteout(newdentry))
> +                goto out_dput;
> +        } else {
> +            if (flags & RENAME_EXCHANGE)
> +                goto out_dput;
> +        }
>    }
> 
>    if (olddentry == trap)
> -- 
> 2.25.4
> 


