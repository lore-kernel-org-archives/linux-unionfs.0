Return-Path: <linux-unionfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.6 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A7B53C43460
	for <linux-unionfs@archiver.kernel.org>; Thu,  1 Apr 2021 17:56:06 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 81BBA60FF3
	for <linux-unionfs@archiver.kernel.org>; Thu,  1 Apr 2021 17:56:06 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236929AbhDAR4F (ORCPT
        <rfc822;linux-unionfs@archiver.kernel.org>);
        Thu, 1 Apr 2021 13:56:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58380 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236482AbhDARpK (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Thu, 1 Apr 2021 13:45:10 -0400
Received: from mail-vs1-xe29.google.com (mail-vs1-xe29.google.com [IPv6:2607:f8b0:4864:20::e29])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DDDDEC08EADF
        for <linux-unionfs@vger.kernel.org>; Thu,  1 Apr 2021 06:37:12 -0700 (PDT)
Received: by mail-vs1-xe29.google.com with SMTP id a23so1241168vsd.1
        for <linux-unionfs@vger.kernel.org>; Thu, 01 Apr 2021 06:37:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=szeredi.hu; s=google;
        h=mime-version:from:date:message-id:subject:to:cc;
        bh=3RICVK9N6jKbelHnVhbtTzO/l3t9YgrOgzyc42q1sJ0=;
        b=k2pYug0td7o0nQuQ2bUhFIdscUQq6n0joLcaMYwuY6y3wtRYrzuUAtPHVy3B5TRlHy
         sqDBvlZeP8RJrWfR4LYaaG2KrGOb2SV3inWNSZpxxf2Q0VQREF98zrj2Ss/i1Aa7iiIE
         KZCZ58UdmIJBGBUKh8ybxlTzoy09T1PMnagTE=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:from:date:message-id:subject:to:cc;
        bh=3RICVK9N6jKbelHnVhbtTzO/l3t9YgrOgzyc42q1sJ0=;
        b=XJBeEPtQJtXDaijLoysEBBsTOjVLJF2SZJOCBJNaKYO64KEbd3/PhVYuE3TKq3hP1P
         wdkHwIEc5mlbPpjrgbNQfAeOrJEbvKjhWqfMzaUls2is1uBP50cJhsv6Axpgm9+lBPby
         pt1/RJjz++vyDxjXyNfd3P97GIAbjXFuGluT4tZSR42s6tNxJhQQlvVbE22p6MoiPm5M
         koc5aykPvbSEtI5r4vHO4KyeHKvcsV/NTzg6LJhzeGsAJHJTGW2QjnUXDvYFSg5ZzyJo
         bSuHh2g3luOHLfkAPSpMj/xEWlllasJlXFL1+0RWSeGdUND8fqJIZchY6o0BlosnfRlQ
         6foQ==
X-Gm-Message-State: AOAM530zhPlD0VGp6ry6y7AIcbLBl/JrCIpjVTDRHxp/mS+W9JqpMEHb
        8vBsJKBphbnm3hC2yXgkfbFWXS6h5wZJTmwwcPZH6Q==
X-Google-Smtp-Source: ABdhPJyuqNjNWR2Rbuv/sEwvP8rSoTNNxpH5aQr/KX1UN60llLGGV2f3cwvL4u6Tu+hM04IJVKnzOgq+zxB//km6IvQ=
X-Received: by 2002:a67:b005:: with SMTP id z5mr4863878vse.47.1617284232031;
 Thu, 01 Apr 2021 06:37:12 -0700 (PDT)
MIME-Version: 1.0
From:   Miklos Szeredi <miklos@szeredi.hu>
Date:   Thu, 1 Apr 2021 15:37:00 +0200
Message-ID: <CAJfpegtUOVF-_GWk8Z-zUHUss0=GAd7HOY_qPSNroUx9og_deA@mail.gmail.com>
Subject: overlayfs: overlapping upperdir path
To:     Amir Goldstein <amir73il@gmail.com>
Cc:     linux-fsdevel@vger.kernel.org,
        overlayfs <linux-unionfs@vger.kernel.org>,
        Vivek Goyal <vgoyal@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-unionfs.vger.kernel.org>
X-Mailing-List: linux-unionfs@vger.kernel.org

Commit 146d62e5a586 ("ovl: detect overlapping layers") made sure we
don't have overapping layers, but it also broke the arguably valid use
case of

 mount -olowerdir=/,upperdir=/subdir,..

where subdir also resides on the root fs.

I also see that we check for a trap at lookup time, so the question is
what does the up-front layer check buy us?

Thanks,
Miklos
