Return-Path: <linux-unionfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5A62DC433ED
	for <linux-unionfs@archiver.kernel.org>; Thu, 22 Apr 2021 08:11:42 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 1E7BE6144A
	for <linux-unionfs@archiver.kernel.org>; Thu, 22 Apr 2021 08:11:42 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235345AbhDVIMP (ORCPT
        <rfc822;linux-unionfs@archiver.kernel.org>);
        Thu, 22 Apr 2021 04:12:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37414 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235331AbhDVIMO (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Thu, 22 Apr 2021 04:12:14 -0400
Received: from mail-wm1-x32b.google.com (mail-wm1-x32b.google.com [IPv6:2a00:1450:4864:20::32b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 772A3C06174A
        for <linux-unionfs@vger.kernel.org>; Thu, 22 Apr 2021 01:11:39 -0700 (PDT)
Received: by mail-wm1-x32b.google.com with SMTP id z6so5781274wmg.1
        for <linux-unionfs@vger.kernel.org>; Thu, 22 Apr 2021 01:11:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ffwll.ch; s=google;
        h=date:from:to:cc:subject:message-id:mail-followup-to:references
         :mime-version:content-disposition:content-transfer-encoding
         :in-reply-to;
        bh=YzUSYaOgN9hxojeW0mU7pzbBG2m7ss1xHFD86VpZnFw=;
        b=SQBU2KUkg8eg+N+tMN7haZLLtl7EyaXi5aA3ujHphx/jCYBCM14EfIxYNwUyfBHKb4
         snU8IimoDnaoZJp5mAhiDqj430JufITSFQ4+HLTMZ3NXHi3TPOIkxL3m6gWEwikhLUrz
         t3K6p6XAEM+uZ19sV6Ln7bgwAmV/FiGMvgtls=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id
         :mail-followup-to:references:mime-version:content-disposition
         :content-transfer-encoding:in-reply-to;
        bh=YzUSYaOgN9hxojeW0mU7pzbBG2m7ss1xHFD86VpZnFw=;
        b=byjN34gvvaYCKRvTuTX2W9XS7LHidAosQvKLh6Ogtwkv0eccXBP+3ai6tkG9NJYnUC
         wa9pw9KqbMrIeV9A3eZKnn+NuOz4rjbXd5rUaX+2mYoHRtWy3im+4/ElQdcPAlUX7IBS
         3MtrReNTsniIytfYftQVXgIXftj4FxnQaEPf2qDpBqojbVOqD44uztlcl2Rew1iH6TVO
         Dem29LvEUq9Ww98Z3qgB4rpF8aavuoJ2pVUfxKzT+fzb2ubgl73W5S3QMHnJEXYDonep
         yAt4KjV9Sk50ZFdYXT0WPC22y/JqS4swEc9WD9VtBI711EU2DZsP9E7HxGDRyqyofpxd
         13rA==
X-Gm-Message-State: AOAM531AEn/6pRgAy/qEcEUNUnEwgMmht9wDqHKfNJevyJ0VxwU4ofOu
        O8/8ede+dZLS/eC2LuYEWTx6kA==
X-Google-Smtp-Source: ABdhPJzQpl8oyp8JKOUGIeroE+P/ggioIzwSyjJLJwYdLC/3EQSRErDjzwQT8eDoqpZqalDMXfPETw==
X-Received: by 2002:a1c:1dd0:: with SMTP id d199mr2436011wmd.54.1619079098208;
        Thu, 22 Apr 2021 01:11:38 -0700 (PDT)
Received: from phenom.ffwll.local ([2a02:168:57f4:0:efd0:b9e5:5ae6:c2fa])
        by smtp.gmail.com with ESMTPSA id l20sm2249188wmg.33.2021.04.22.01.11.37
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 22 Apr 2021 01:11:37 -0700 (PDT)
Date:   Thu, 22 Apr 2021 10:11:35 +0200
From:   Daniel Vetter <daniel@ffwll.ch>
To:     Christian =?iso-8859-1?Q?K=F6nig?= 
        <ckoenig.leichtzumerken@gmail.com>
Cc:     linux-kernel@vger.kernel.org, linux-unionfs@vger.kernel.org,
        codalist@coda.cs.cmu.edu, dri-devel@lists.freedesktop.org,
        jgg@ziepe.ca, jaharkes@cs.cmu.edu, akpm@linux-foundation.org,
        miklos@szeredi.hu, coda@cs.cmu.edu
Subject: Re: [PATCH 1/2] coda: fix reference counting in coda_file_mmap error
 path
Message-ID: <YIEvt01bQkKhxDSJ@phenom.ffwll.local>
Mail-Followup-To: Christian =?iso-8859-1?Q?K=F6nig?= <ckoenig.leichtzumerken@gmail.com>,
        linux-kernel@vger.kernel.org, linux-unionfs@vger.kernel.org,
        codalist@coda.cs.cmu.edu, dri-devel@lists.freedesktop.org,
        jgg@ziepe.ca, jaharkes@cs.cmu.edu, akpm@linux-foundation.org,
        miklos@szeredi.hu, coda@cs.cmu.edu
References: <20210421132012.82354-1-christian.koenig@amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20210421132012.82354-1-christian.koenig@amd.com>
X-Operating-System: Linux phenom 5.7.0-1-amd64 
Precedence: bulk
List-ID: <linux-unionfs.vger.kernel.org>
X-Mailing-List: linux-unionfs@vger.kernel.org

On Wed, Apr 21, 2021 at 03:20:11PM +0200, Christian König wrote:
> mmap_region() now calls fput() on the vma->vm_file.
> 
> So we need to drop the extra reference on the coda file instead of the
> host file.
> 
> Signed-off-by: Christian König <christian.koenig@amd.com>
> Fixes: 1527f926fd04 ("mm: mmap: fix fput in error path v2")
> CC: stable@vger.kernel.org # 5.11+

Reviewed-by: Daniel Vetter <daniel.vetter@ffwll.ch>

> ---
>  fs/coda/file.c | 6 +++---
>  1 file changed, 3 insertions(+), 3 deletions(-)
> 
> diff --git a/fs/coda/file.c b/fs/coda/file.c
> index 128d63df5bfb..ef5ca22bfb3e 100644
> --- a/fs/coda/file.c
> +++ b/fs/coda/file.c
> @@ -175,10 +175,10 @@ coda_file_mmap(struct file *coda_file, struct vm_area_struct *vma)
>  	ret = call_mmap(vma->vm_file, vma);
>  
>  	if (ret) {
> -		/* if call_mmap fails, our caller will put coda_file so we
> -		 * should drop the reference to the host_file that we got.
> +		/* if call_mmap fails, our caller will put host_file so we
> +		 * should drop the reference to the coda_file that we got.
>  		 */
> -		fput(host_file);
> +		fput(coda_file);
>  		kfree(cvm_ops);
>  	} else {
>  		/* here we add redirects for the open/close vm_operations */
> -- 
> 2.25.1
> 
> _______________________________________________
> dri-devel mailing list
> dri-devel@lists.freedesktop.org
> https://lists.freedesktop.org/mailman/listinfo/dri-devel

-- 
Daniel Vetter
Software Engineer, Intel Corporation
http://blog.ffwll.ch
