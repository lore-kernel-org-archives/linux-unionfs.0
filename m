Return-Path: <SRS0=w8z3=EF=vger.kernel.org=linux-unionfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.5 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3092BC4363A
	for <linux-unionfs@archiver.kernel.org>; Fri, 30 Oct 2020 10:17:12 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 902B92071A
	for <linux-unionfs@archiver.kernel.org>; Fri, 30 Oct 2020 10:17:11 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=szeredi.hu header.i=@szeredi.hu header.b="eHjnw8Xx"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725808AbgJ3KRL (ORCPT
        <rfc822;linux-unionfs@archiver.kernel.org>);
        Fri, 30 Oct 2020 06:17:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51804 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725801AbgJ3KRL (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Fri, 30 Oct 2020 06:17:11 -0400
Received: from mail-ua1-x944.google.com (mail-ua1-x944.google.com [IPv6:2607:f8b0:4864:20::944])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DEF62C0613D7
        for <linux-unionfs@vger.kernel.org>; Fri, 30 Oct 2020 03:17:10 -0700 (PDT)
Received: by mail-ua1-x944.google.com with SMTP id t15so1577715ual.6
        for <linux-unionfs@vger.kernel.org>; Fri, 30 Oct 2020 03:17:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=szeredi.hu; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=KpcDuybzX/9LOwoW6LsWPbubvRIkCUTbl/p8yLeIKto=;
        b=eHjnw8XxjCJfyypCBxZIxCOszUQPZG/toN2oTycB2uVkz3qTh2eS/QLz5sSpeIeegS
         DvAVv+c5FjR+wiUj3WQkqdzUL1oJfUsfiufyzlE4cfPQlEZlVYYCw40IGwYDxr9Ljv8L
         9hZMu8YMgyPuybCtOcdr9dG6pOZcifz2YRAjk=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=KpcDuybzX/9LOwoW6LsWPbubvRIkCUTbl/p8yLeIKto=;
        b=RvH8YrPRvnrG27rXks4Msp3p0+ulF+J6GpGJDkNJg+RA9LaCf+uUOAG0RjqqSrHZ8r
         3dPq8LV4S24kIn1AYc8mLAIn+GWEk7CdJtuwMudnO+1qIVakMlNpNDzxdcOFB+3zy4t2
         OVUd7IZCPDVidQgBaJbRJ/XMJBZuzFXijWnR01Mg37zoV3WdiFGJCvRRjkWBUYpszkBQ
         zE5DKCk0GIX4R21klwpzBP7CsJJWZzpuBY6RBswu0Fzim+3fF79kEFL0c6/xbCvFnVTB
         NvJ/XjzSa8oqEVrVNcIUFuAuDppLE3Rd9zMMjYTRRBb6aWHm+wKdHToAe7NF1spuyt2H
         fBbg==
X-Gm-Message-State: AOAM533/rrvoxd8+F/EGee0ZP1aZo2Uo19bFDLBM5qu8UsMPzgZUsx8w
        gQNlqxQjo8psGDcpoOL6HW3McZXLI95P8z35ZCtIttjXOK0=
X-Google-Smtp-Source: ABdhPJxCooV8jd/eY1shr343h3KYHhSZGko8up0EBGazq237Vv5St7ITkN3jATMEU3VUBDLZ2sG0lLtTFkZeREbqyzw=
X-Received: by 2002:ab0:3312:: with SMTP id r18mr687931uao.13.1604053030105;
 Fri, 30 Oct 2020 03:17:10 -0700 (PDT)
MIME-Version: 1.0
References: <20200624102011.4861-1-cgxu519@mykernel.net> <c9faf864-c515-2657-fa7c-6ba24a9ea89f@mykernel.net>
In-Reply-To: <c9faf864-c515-2657-fa7c-6ba24a9ea89f@mykernel.net>
From:   Miklos Szeredi <miklos@szeredi.hu>
Date:   Fri, 30 Oct 2020 11:16:59 +0100
Message-ID: <CAJfpegu+vGpB1r13HSiyhv1JPXjcf2ee+NYXzev2HeKwxew9MQ@mail.gmail.com>
Subject: Re: [PATCH] ovl: fix incorrect extent info in metacopy case
To:     cgxu <cgxu519@mykernel.net>
Cc:     overlayfs <linux-unionfs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-unionfs.vger.kernel.org>
X-Mailing-List: linux-unionfs@vger.kernel.org

On Fri, Aug 14, 2020 at 11:23 AM cgxu <cgxu519@mykernel.net> wrote:
>
> On 6/24/20 6:20 PM, Chengguang Xu wrote:
> > In metacopy case, we should use ovl_inode_realdata() instead of
> > ovl_inode_real() to get real inode which has data, so that
> > we can get correct information of extentes in ->fiemap operation.
> >
> > Signed-off-by: Chengguang Xu <cgxu519@mykernel.net>
>
> ping

Sorry, I missed this patch.  Applied now.

Thanks,
Miklos
