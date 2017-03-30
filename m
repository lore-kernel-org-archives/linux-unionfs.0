From: Amir Goldstein <amir73il@gmail.com>
Subject: Re: Question about ovl_dentry_weird
Date: Thu, 30 Mar 2017 10:03:14 +0300
Message-ID: <CAOQ4uxhvrAefbxcYXv5JfBmKN==8Yo7QKiaFAa6YS8VSfpvf=A@mail.gmail.com>
References: <f3a67b6a-b8fb-78ab-fadd-504fa5d76a10@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-unionfs-owner@vger.kernel.org>
Received: from mail-oi0-f47.google.com ([209.85.218.47]:33403 "EHLO
        mail-oi0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932181AbdC3HDQ (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Thu, 30 Mar 2017 03:03:16 -0400
Received: by mail-oi0-f47.google.com with SMTP id b187so21853372oif.0
        for <linux-unionfs@vger.kernel.org>; Thu, 30 Mar 2017 00:03:15 -0700 (PDT)
In-Reply-To: <f3a67b6a-b8fb-78ab-fadd-504fa5d76a10@huawei.com>
Sender: linux-unionfs-owner@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org
To: "zhangyi (F)" <yi.zhang@huawei.com>
Cc: linux-unionfs@vger.kernel.org, miaoxie@huawei.com, laiyuanyuan.lai@huawei.com, Miklos Szeredi <miklos@szeredi.hu>

On Thu, Mar 30, 2017 at 9:48 AM, zhangyi (F) <yi.zhang@huawei.com> wrote:
> Hi:
> Current overlayfs does not support underlying filesystem which have "weir=
d" d_flags (like DCACHE_OP_HASH=EF=BC=8C
> DCACHE_OP_COMPARE, DCACHE_OP_REVALIDATE, etc). So we cannot support fs ha=
ve it's own d_hash, d_compare and
> d_revalidate functions.

Not accurate. d_revalidate() is allowed for lower, but not for upper
(ovl_dentry_remote()).

I can't say I understand why upper is not allowed to be remote, so this mig=
ht
be fixed if there is a need and there is a tester.

>
> Do you have a TODO plan to support it in a future version ?
>

Which of the constrains is relevant to your use case? (which of the flags)
Do you need it for lower / upper or both?
Is it a proprietary file system of a known one you need to support?

Thanks,
Amir.
