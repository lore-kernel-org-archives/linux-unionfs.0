Return-Path: <linux-unionfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CD4B4C433EF
	for <linux-unionfs@archiver.kernel.org>; Thu,  7 Oct 2021 09:23:19 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id B2588611AE
	for <linux-unionfs@archiver.kernel.org>; Thu,  7 Oct 2021 09:23:19 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240600AbhJGJZM (ORCPT
        <rfc822;linux-unionfs@archiver.kernel.org>);
        Thu, 7 Oct 2021 05:25:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41158 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240598AbhJGJZM (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Thu, 7 Oct 2021 05:25:12 -0400
Received: from mail-vs1-xe33.google.com (mail-vs1-xe33.google.com [IPv6:2607:f8b0:4864:20::e33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 85A4BC061760
        for <linux-unionfs@vger.kernel.org>; Thu,  7 Oct 2021 02:23:18 -0700 (PDT)
Received: by mail-vs1-xe33.google.com with SMTP id o15so1203679vsr.13
        for <linux-unionfs@vger.kernel.org>; Thu, 07 Oct 2021 02:23:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=szeredi.hu; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=rUWh8/nzui59AslYBGE2UZsOtVDOFLafNPVpXzsA5k0=;
        b=LdQoTfuILlI4bUYn34I0nglU9SK7YTIYJZ8ovMH6IzZzlwbsBelfcMO6mz/t0TnDgD
         9NPHc4AyQZxZvAwaiUbbANwYwj3v8nKg6Vwt4cJ/16oOLdhsHBKolnYGkem7Lnhbop1S
         u5EvLLkgZIayXwvPzfuUYzNF+SENB3fb1JF74=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=rUWh8/nzui59AslYBGE2UZsOtVDOFLafNPVpXzsA5k0=;
        b=tYi7/7za+BOzMmcIgG1B4a/MrB9bn9sVl9+L0Gy8x6VbubF7MukGIoBrml4YCYczgb
         yyQznOCwSI6Nb/T7izaU91P7RZQJO3AgRjzidq7BRPMz8dnebZOPJxdcEocJBQAWNmBe
         OClCaYLmMBTqJoVqvIp6a+PgSHPs7K1q8KprFeUPXYMK1FaDqiJr/Doi6wvVjHKWjYpy
         Yh2talFgzYKYRr5duZzR8xlbpiu2qUflr5ZEWkbanQQBUAAHIUIqdKMIA01e8BO/VmxZ
         Q3ILQ6poqtbhc3uwuoxWH8fpyuVkoQxyfs6OP9vfk4rAiYK1GGlQN9VhUUkgEpjaKueG
         oO4g==
X-Gm-Message-State: AOAM531e/SxyZxiDa9wOTSMvgRdONhBPTt7y2+hkr3g8obzjsZP0+FUF
        lNnoJMzwFMmrTPBs5Jz+IA6EfCUJOjUTHYgzHMZtqw==
X-Google-Smtp-Source: ABdhPJwKmuyoUN96r/uOpk7uvGkP1btKzYR/lUkNsBES9CO8VlwM7PF9JuCilztl58w8Qi5nUUZHjepATMqzufo12s0=
X-Received: by 2002:a67:ec94:: with SMTP id h20mr2591162vsp.59.1633598597621;
 Thu, 07 Oct 2021 02:23:17 -0700 (PDT)
MIME-Version: 1.0
References: <20210923130814.140814-1-cgxu519@mykernel.net> <20210923130814.140814-7-cgxu519@mykernel.net>
In-Reply-To: <20210923130814.140814-7-cgxu519@mykernel.net>
From:   Miklos Szeredi <miklos@szeredi.hu>
Date:   Thu, 7 Oct 2021 11:23:06 +0200
Message-ID: <CAJfpeguqj2vst4Zj5EovSktJkXiDSCSWY=X12X0Yrz4M8gPRmQ@mail.gmail.com>
Subject: Re: [RFC PATCH v5 06/10] ovl: implement overlayfs' ->write_inode operation
To:     Chengguang Xu <cgxu519@mykernel.net>
Cc:     Jan Kara <jack@suse.cz>, Amir Goldstein <amir73il@gmail.com>,
        linux-fsdevel@vger.kernel.org,
        overlayfs <linux-unionfs@vger.kernel.org>,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-unionfs.vger.kernel.org>
X-Mailing-List: linux-unionfs@vger.kernel.org

On Thu, 23 Sept 2021 at 15:08, Chengguang Xu <cgxu519@mykernel.net> wrote:
>
> Implement overlayfs' ->write_inode to sync dirty data
> and redirty overlayfs' inode if necessary.
>
> Signed-off-by: Chengguang Xu <cgxu519@mykernel.net>
> ---
>  fs/overlayfs/super.c | 30 ++++++++++++++++++++++++++++++
>  1 file changed, 30 insertions(+)
>
> diff --git a/fs/overlayfs/super.c b/fs/overlayfs/super.c
> index 2ab77adf7256..cddae3ca2fa5 100644
> --- a/fs/overlayfs/super.c
> +++ b/fs/overlayfs/super.c
> @@ -412,12 +412,42 @@ static void ovl_evict_inode(struct inode *inode)
>         clear_inode(inode);
>  }
>
> +static int ovl_write_inode(struct inode *inode,
> +                          struct writeback_control *wbc)
> +{
> +       struct ovl_fs *ofs = inode->i_sb->s_fs_info;
> +       struct inode *upper = ovl_inode_upper(inode);
> +       unsigned long iflag = 0;
> +       int ret = 0;
> +
> +       if (!upper)
> +               return 0;
> +
> +       if (!ovl_should_sync(ofs))
> +               return 0;
> +
> +       if (upper->i_sb->s_op->write_inode)
> +               ret = upper->i_sb->s_op->write_inode(inode, wbc);

Where is page writeback on upper inode triggered?

Thanks,
Miklos
