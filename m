Return-Path: <linux-unionfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.5 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3C4C8C07E95
	for <linux-unionfs@archiver.kernel.org>; Mon, 19 Jul 2021 15:47:29 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 2553B60FD7
	for <linux-unionfs@archiver.kernel.org>; Mon, 19 Jul 2021 15:47:29 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344744AbhGSPGl (ORCPT
        <rfc822;linux-unionfs@archiver.kernel.org>);
        Mon, 19 Jul 2021 11:06:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42590 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345842AbhGSPFD (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Mon, 19 Jul 2021 11:05:03 -0400
Received: from mail-vs1-xe2a.google.com (mail-vs1-xe2a.google.com [IPv6:2607:f8b0:4864:20::e2a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 38E4FC09F5ED
        for <linux-unionfs@vger.kernel.org>; Mon, 19 Jul 2021 07:55:48 -0700 (PDT)
Received: by mail-vs1-xe2a.google.com with SMTP id o19so7340748vsn.3
        for <linux-unionfs@vger.kernel.org>; Mon, 19 Jul 2021 08:24:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=szeredi.hu; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=DenfD+SKnJA+ydQMdOL9Wv/heHrx8ZAX5F32hlgrs9M=;
        b=bS/OU+GJ5DpZbp1LZZE/dlswofiwRdy1u7e/Vj6tlw0ylQ+AIwfaYR5+R3aFhVbMDi
         SE52bGqj+/Dtrqd3IDtEnaLt0lY0jU6tuAgajCdYJoMPPEUlxmekRKdh/UrsxNPGeB1T
         LZ7WDYrmJ+8JiF2gh32a0U2L74VsCIC/TfZjs=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=DenfD+SKnJA+ydQMdOL9Wv/heHrx8ZAX5F32hlgrs9M=;
        b=II6Sh5btNKH+myxo+xRH7ABS75YqqmpeIfgjwjz2XcDBESZdbacSe15VzvbBuJfele
         /1RCAQx7LESXjSjCjDRbzgq/jbwfAcUDPz0y1vGTsXZMcd3O0JPDWoUGcjYKKj1i/ZcA
         65YP4/YyEnnXPYwQPd+f2PNDZDUgh0/4vCtkB1dU0RJujhdW1BvLT6YKh1Qiuv4PNULT
         FYobUdNgwqQ6Nzod9NJzVvFtX2tVgD3zyw+AhNmOID28+TyT5bCY5zYF31+7zPEkoM8/
         81P/fTBCtXHThYsdC41WoHoZPCrSsqgLG6zZc6My8Rcpwohbe1aD2FM3al6ptouVGFnN
         55JA==
X-Gm-Message-State: AOAM531GG/WK2EuNJKWfymt/zCsJr/I9ckWEVHbjuOozhYe2r4At8W0+
        nMoqByvNa4QHcOMWknUGH5snXfpBwgjwKaWhVDSTuk0gvjDzzRa9
X-Google-Smtp-Source: ABdhPJwP7TdgCX8V5LIgO7Jgvu8vMZv6QjtSq7ogt4FaIjqYQb1XSy/3LzTy6YfRnR79aVcsFMYcXmqKMJn14nSaqsM=
X-Received: by 2002:a67:c009:: with SMTP id v9mr1829955vsi.47.1626708287751;
 Mon, 19 Jul 2021 08:24:47 -0700 (PDT)
MIME-Version: 1.0
References: <20210426152021.1145298-1-amir73il@gmail.com> <CAOQ4uxg3CJGstSGsihibXvUtivOhRimnQKqrh=5mSqZa1hA8fQ@mail.gmail.com>
In-Reply-To: <CAOQ4uxg3CJGstSGsihibXvUtivOhRimnQKqrh=5mSqZa1hA8fQ@mail.gmail.com>
From:   Miklos Szeredi <miklos@szeredi.hu>
Date:   Mon, 19 Jul 2021 17:24:37 +0200
Message-ID: <CAJfpegtZq=EPuoU_wxr4yEJtime4vW6oPFBnX5whrXS3ZSA6oQ@mail.gmail.com>
Subject: Re: [PATCH] ovl: skip stale entries in merge dir cache iteration
To:     Amir Goldstein <amir73il@gmail.com>
Cc:     overlayfs <linux-unionfs@vger.kernel.org>,
        Eryu Guan <guaneryu@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-unionfs.vger.kernel.org>
X-Mailing-List: linux-unionfs@vger.kernel.org

On Fri, 4 Jun 2021 at 12:43, Amir Goldstein <amir73il@gmail.com> wrote:
>
> On Mon, Apr 26, 2021 at 6:20 PM Amir Goldstein <amir73il@gmail.com> wrote:
> >
> > On the first getdents call, ovl_iterate() populates the readdir cache
> > with a list of entries, but for upper entries with origin lower inode,
> > p->ino remains zero.
> >
> > Following getdents calls traverse the readdir cache list and call
> > ovl_cache_update_ino() for entries with zero p->ino to lookup the entry
> > in the overlay and return d_ino that is consistent with st_ino.
> >
> > If the upper file was unlinked between the first getdents call and the
> > getdents call that lists the file entry, ovl_cache_update_ino() will not
> > find the entry and fall back to setting d_ino to the upper real st_ino,
> > which is inconsistent with how this object was presented to users.
> >
> > Instead of listing a stale entry with inconsistent d_ino, simply skip
> > the stale entry, which is better for users.
> >
>
> Miklos,
>
> I forgot to follow up on this patch.
> Upstream xfstest overlay/077 is failing without this patch.

Can't reproduce (on ext4/xfs and "-oxino=on").

Is there some trick?

Thanks,
Miklos
