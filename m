Return-Path: <SRS0=w8z3=EF=vger.kernel.org=linux-unionfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.5 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 92680C55178
	for <linux-unionfs@archiver.kernel.org>; Fri, 30 Oct 2020 15:46:14 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id F41E922242
	for <linux-unionfs@archiver.kernel.org>; Fri, 30 Oct 2020 15:46:13 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=szeredi.hu header.i=@szeredi.hu header.b="FgyeQX4a"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726674AbgJ3PqN (ORCPT
        <rfc822;linux-unionfs@archiver.kernel.org>);
        Fri, 30 Oct 2020 11:46:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46678 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726319AbgJ3PqN (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Fri, 30 Oct 2020 11:46:13 -0400
Received: from mail-vs1-xe44.google.com (mail-vs1-xe44.google.com [IPv6:2607:f8b0:4864:20::e44])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 59930C0613CF
        for <linux-unionfs@vger.kernel.org>; Fri, 30 Oct 2020 08:46:13 -0700 (PDT)
Received: by mail-vs1-xe44.google.com with SMTP id h5so3648741vsp.3
        for <linux-unionfs@vger.kernel.org>; Fri, 30 Oct 2020 08:46:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=szeredi.hu; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=CFcH78Yw0pfxvt3AwM9fYeXCITwB39A7gKKajxur5/0=;
        b=FgyeQX4aoiBbFM79EBFleLczgQbrNa2HsouqPxpbgexC5/AI1Hhd5zzIZYFgf8IXUq
         pAarAosw+OfibouTp7RrVPFobobEau7rYvSuJ1vXunTL1MR/t8IAzrEKkDFq+0vTNGYT
         9B6R2nxmqxrZqXn2SfZi2FTHBFfQwSWjiqKOQ=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=CFcH78Yw0pfxvt3AwM9fYeXCITwB39A7gKKajxur5/0=;
        b=G/5PhtIn6Esm9fK1lpS3rSBu0NSNabcMuVzsTea2zC8Uio3ew/OD2TxzmgTmf2+zPi
         PuXJANSqZ3hF38J2aSSLnYJ7AM6vweFQYxMi9R0ynZhH6FWBhf+sPswtYtja1288bNKt
         JxUvI/QAqcgxCPZxO75wDsLjxWLYJEa2X7sO8NtyLAYiiQqF9pSKWhXmUqCgvc/M6Fcp
         5RAY8NFA+0sPFL/wKPpZUKrKsWFAK+8dptWFF1fcibqczhwWDCxEfgO3JyUs5sMz26Ik
         ecjXtchK7QoNnkeYevfzT7/v0HnBDT3ECtFy7dUhHm+qx5kCeSl31bgD9UFNaXllCk2P
         KZBw==
X-Gm-Message-State: AOAM533L19GjNFVNbd7qO6egQ7qna5/aP6OtLi4F8TFtC7QqKOKnWYEx
        ME+683XRYQPY9RdfgsYfu2fzUKFBl4dnsatz5mAJPw==
X-Google-Smtp-Source: ABdhPJzgkbkcDlD/QWNYdVwGIN85FgPiKqcrWoajHn+aHB4z4aaAgVMPRcxnlcxrnWFoVc15DrfrayMXQxD31PHZfT8=
X-Received: by 2002:a05:6102:2ec:: with SMTP id j12mr7559124vsj.21.1604072772593;
 Fri, 30 Oct 2020 08:46:12 -0700 (PDT)
MIME-Version: 1.0
References: <20201025034117.4918-1-cgxu519@mykernel.net>
In-Reply-To: <20201025034117.4918-1-cgxu519@mykernel.net>
From:   Miklos Szeredi <miklos@szeredi.hu>
Date:   Fri, 30 Oct 2020 16:46:00 +0100
Message-ID: <CAJfpegu-bn2BjkLaykk-gZLRv71n=PgrsrwBnuAav1GHzWO5iQ@mail.gmail.com>
Subject: Re: [RFC PATCH v2 0/8] implement containerized syncfs for overlayfs
To:     Chengguang Xu <cgxu519@mykernel.net>
Cc:     Amir Goldstein <amir73il@gmail.com>, Jan Kara <jack@suse.cz>,
        overlayfs <linux-unionfs@vger.kernel.org>,
        linux-fsdevel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-unionfs.vger.kernel.org>
X-Mailing-List: linux-unionfs@vger.kernel.org

On Sun, Oct 25, 2020 at 4:42 AM Chengguang Xu <cgxu519@mykernel.net> wrote:
>
> Current syncfs(2) syscall on overlayfs just calls sync_filesystem()
> on upper_sb to synchronize whole dirty inodes in upper filesystem
> regardless of the overlay ownership of the inode. In the use case of
> container, when multiple containers using the same underlying upper
> filesystem, it has some shortcomings as below.
>
> (1) Performance
> Synchronization is probably heavy because it actually syncs unnecessary
> inodes for target overlayfs.
>
> (2) Interference
> Unplanned synchronization will probably impact IO performance of
> unrelated container processes on the other overlayfs.
>
> This series try to implement containerized syncfs for overlayfs so that
> only sync target dirty upper inodes which are belong to specific overlayfs
> instance. By doing this, it is able to reduce cost of synchronization and
> will not seriously impact IO performance of unrelated processes.

Series looks good at first glance.  Still need to do an in-depth review.

In the meantime can you post some numbers showing the performance improvements?

Thanks,
Miklos
