Return-Path: <linux-unionfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 317F8C433F5
	for <linux-unionfs@archiver.kernel.org>; Thu,  7 Oct 2021 13:34:33 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 06B4B611C1
	for <linux-unionfs@archiver.kernel.org>; Thu,  7 Oct 2021 13:34:33 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241585AbhJGNgZ (ORCPT
        <rfc822;linux-unionfs@archiver.kernel.org>);
        Thu, 7 Oct 2021 09:36:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42816 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241529AbhJGNgZ (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Thu, 7 Oct 2021 09:36:25 -0400
Received: from mail-ua1-x931.google.com (mail-ua1-x931.google.com [IPv6:2607:f8b0:4864:20::931])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9FE05C061746
        for <linux-unionfs@vger.kernel.org>; Thu,  7 Oct 2021 06:34:31 -0700 (PDT)
Received: by mail-ua1-x931.google.com with SMTP id a2so178972uaq.10
        for <linux-unionfs@vger.kernel.org>; Thu, 07 Oct 2021 06:34:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=szeredi.hu; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=jag9C+ogrZcxnbvlzXCV96tv+CXNE9JJxs7UZNJcVuY=;
        b=YPEEqVqncgDZE3eOkA9QLiJA/i4iA0W9YwPaz99zO6kRow3kMf036K9y4L5ulmXREu
         ZJ+XMgqDtE8jQNFq4SiulrFzWphUX+a4zhH3stha9Lt4cLuaXNJfpnwDN0TSCrbHNC4l
         5eukq3L/u0pJrD9i1pnR4NBIR94tVFkZ3ItWA=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=jag9C+ogrZcxnbvlzXCV96tv+CXNE9JJxs7UZNJcVuY=;
        b=G3ZUbXonkYGkIpj0KX2EifF6RPIJLkj9UWmIMDOMPQfK7q3tTvCWNmUVPFs6rVyczv
         l2pzry4DSOsq5dsMaBEVYUe8OlgB2rqI1SULcWPJFsZjfbDIX2Ih+217FP3SDDgDVNPJ
         1GZnZSMhq82l+m/UMvfUWsNg9mEOmzR9QER2peTxdi5zUDmwq41C+xJfu13XDGnR5Xlo
         NBHlobcTudW+Skvx5xdZIvpxuYeSCosxJenZjZe/pGGXUgO/i8mpPotcxY0dSb/K3OP6
         EjZURpNT6tB79m3iESYw18OHrzqscQsG38gp3R9P0sEahcRnrXD6sima8lmGr41wbzKL
         4Rag==
X-Gm-Message-State: AOAM533lhEh6/Ef82L3NzJU7cIoL8IQGhh34H+q3S5mnCyH1+WqJE4Tq
        Mibx6rsGDmOsWUgpCFQwe3x2wRn7n7d/7gqJ01p9pw==
X-Google-Smtp-Source: ABdhPJxmjP2DfCokChnQhrBqbnGAJg1mMD8fkSMMPRTM5OVXNmkABjNp26NlAezgaEUPb0poHEyD+5BZK060ZLWuQPQ=
X-Received: by 2002:a9f:234a:: with SMTP id 68mr4384005uae.13.1633613670429;
 Thu, 07 Oct 2021 06:34:30 -0700 (PDT)
MIME-Version: 1.0
References: <20210923130814.140814-1-cgxu519@mykernel.net> <20210923130814.140814-7-cgxu519@mykernel.net>
 <CAJfpeguqj2vst4Zj5EovSktJkXiDSCSWY=X12X0Yrz4M8gPRmQ@mail.gmail.com>
 <17c5aba1fef.c5c03d5825886.6577730832510234905@mykernel.net>
 <CAJfpegtr1NkOiY9YWd1meU1yiD-LFX-aB55UVJs94FrX0VNEJQ@mail.gmail.com> <17c5adfe5ea.12f1be94625921.4478415437452327206@mykernel.net>
In-Reply-To: <17c5adfe5ea.12f1be94625921.4478415437452327206@mykernel.net>
From:   Miklos Szeredi <miklos@szeredi.hu>
Date:   Thu, 7 Oct 2021 15:34:19 +0200
Message-ID: <CAJfpegt4jZpSCXGFk2ieqUXVm3m=ng7QtSzZp2bXVs07bfrbXg@mail.gmail.com>
Subject: Re: [RFC PATCH v5 06/10] ovl: implement overlayfs' ->write_inode operation
To:     Chengguang Xu <cgxu519@mykernel.net>
Cc:     Jan Kara <jack@suse.cz>, Amir Goldstein <amir73il@gmail.com>,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>,
        overlayfs <linux-unionfs@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-unionfs.vger.kernel.org>
X-Mailing-List: linux-unionfs@vger.kernel.org

On Thu, 7 Oct 2021 at 15:10, Chengguang Xu <cgxu519@mykernel.net> wrote:
>  > However that wasn't what I was asking about.  AFAICS ->write_inode()
>  > won't start write back for dirty pages.   Maybe I'm missing something,
>  > but there it looks as if nothing will actually trigger writeback for
>  > dirty pages in upper inode.
>  >
>
> Actually, page writeback on upper inode will be triggered by overlayfs ->writepages and
> overlayfs' ->writepages will be called by vfs writeback function (i.e writeback_sb_inodes).

Right.

But wouldn't it be simpler to do this from ->write_inode()?

I.e. call write_inode_now() as suggested by Jan.

Also could just call mark_inode_dirty() on the overlay inode
regardless of the dirty flags on the upper inode since it shouldn't
matter and results in simpler logic.

Thanks,
Miklos


>
> Thanks,
> Chengguang
>
>
>
