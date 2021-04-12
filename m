Return-Path: <linux-unionfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.6 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3F00EC43140
	for <linux-unionfs@archiver.kernel.org>; Mon, 12 Apr 2021 09:31:41 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 18AA061221
	for <linux-unionfs@archiver.kernel.org>; Mon, 12 Apr 2021 09:31:41 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238263AbhDLJbn (ORCPT
        <rfc822;linux-unionfs@archiver.kernel.org>);
        Mon, 12 Apr 2021 05:31:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44736 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242240AbhDLJ2F (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Mon, 12 Apr 2021 05:28:05 -0400
Received: from mail-vs1-xe35.google.com (mail-vs1-xe35.google.com [IPv6:2607:f8b0:4864:20::e35])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 57B48C06138F
        for <linux-unionfs@vger.kernel.org>; Mon, 12 Apr 2021 02:27:47 -0700 (PDT)
Received: by mail-vs1-xe35.google.com with SMTP id h20so6311125vsu.1
        for <linux-unionfs@vger.kernel.org>; Mon, 12 Apr 2021 02:27:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=szeredi.hu; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=6hKUVtRAYKksa4g4Z/SOXZ+I+SLzgB72dysIQbYZhlk=;
        b=CitFYvjqQpJous7ooVmqfhnFsbgLlnpEDxsDp/0RahdDGBuwdMycdneGcKTEi88ZzZ
         icSfVdFS15Oe9zZx8G7npVnJ3yX5/NnRtCizxLwUgVHWsSjMKS/xvGkHJqooZ72EEjTl
         XCQwB/3XWLH1ObPZxWsIpNdO64fsA4CPgZjc8=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=6hKUVtRAYKksa4g4Z/SOXZ+I+SLzgB72dysIQbYZhlk=;
        b=n/ExCyT8rmJKVhcAXS3qOHQ7JD1N4GWpvFUF/KA1SnhO6/+27/AyJLXDKUEz2elT+4
         UykF/LJ6m45ZAUKeUuPlTme4rGSISKb6Hf/Jq6pSUx1t/b/xXCd4Etsd5n3GLiFhxRdh
         fEMtAgPVWLk7dyZ5d+LBCGO6ZzWBtOvzuLTdWqRKDzaFxFtrXwWHeYbIIoaZ/tb+u06y
         OAoEdXzKhjWiMPmT7gUVh4h97IRaG13SurtzXBJIzCJdWAoKClIfiM0LIUStTo0Yh+0F
         DfFX2hXoem0bV1kEUoHcdQ+1Nu0XdDWam2s41FTXZt//Lm3irp1tmuBk2Ep062OYp+a1
         Xk9g==
X-Gm-Message-State: AOAM531hRSRZFN3W8CPgOdiVHkoAJHyMucr4NpBVZnSM2h8QbQffNc4N
        TWzgI+kJO9D7nSf4sBRvfAbHNbWPuY3B0xz28BLaZw==
X-Google-Smtp-Source: ABdhPJygb7TprYuqHMJbs7kZzi/RZ6+3XCz0tKtXIbFxyF52PMynCUJXHei8d09eoHLmkJRmeM3KYqSm+zCP8mXN81k=
X-Received: by 2002:a67:f487:: with SMTP id o7mr19224439vsn.7.1618219664676;
 Mon, 12 Apr 2021 02:27:44 -0700 (PDT)
MIME-Version: 1.0
References: <20210323160629.228597-1-mszeredi@redhat.com>
In-Reply-To: <20210323160629.228597-1-mszeredi@redhat.com>
From:   Miklos Szeredi <miklos@szeredi.hu>
Date:   Mon, 12 Apr 2021 11:27:33 +0200
Message-ID: <CAJfpegv4ttfCZY0DPm+SSc85eL5m3jqhdOS_avu1+WMZhdg7iA@mail.gmail.com>
Subject: Re: [PATCH] vfs: allow stacked ->get_acl() in RCU lookup
To:     Miklos Szeredi <mszeredi@redhat.com>
Cc:     Al Viro <viro@zeniv.linux.org.uk>,
        overlayfs <linux-unionfs@vger.kernel.org>,
        linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        garyhuang <zjh.20052005@163.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-unionfs.vger.kernel.org>
X-Mailing-List: linux-unionfs@vger.kernel.org

On Tue, Mar 23, 2021 at 5:07 PM Miklos Szeredi <mszeredi@redhat.com> wrote:
>
> Overlayfs does not cache ACL's to avoid double caching with all its
> problems.  Instead it just calls the underlying filesystem's
> i_op->get_acl(), which will return the cached value, if possible.
>
> In rcu path walk, however, get_cached_acl_rcu() is employed to get the
> value from the cache, which will fail on overlayfs resulting in dropping
> out of rcu walk mode.  This can result in a big performance hit in certain
> situations.
>
> Add a flags argument to the ->get_acl() callback, and allow
> get_cached_acl_rcu() to call the ->get_acl() method with LOOKUP_RCU.
>
> Don't do this for the generic case of a cache miss, only in case of
> ACL_DONT_CACHE.
>
> Reported-by: garyhuang <zjh.20052005@163.com>
> Signed-off-by: Miklos Szeredi <mszeredi@redhat.com>

Hi Al,

Could you please apply this patch?

It's fairly trivial, but unfortunately adds a fair bit of API churn.

Thanks,
Miklos
