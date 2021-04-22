Return-Path: <linux-unionfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0CF39C433ED
	for <linux-unionfs@archiver.kernel.org>; Thu, 22 Apr 2021 08:13:40 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id C2C5B613C0
	for <linux-unionfs@archiver.kernel.org>; Thu, 22 Apr 2021 08:13:39 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235248AbhDVION (ORCPT
        <rfc822;linux-unionfs@archiver.kernel.org>);
        Thu, 22 Apr 2021 04:14:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37850 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235199AbhDVION (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Thu, 22 Apr 2021 04:14:13 -0400
Received: from mail-wm1-x32b.google.com (mail-wm1-x32b.google.com [IPv6:2a00:1450:4864:20::32b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AF259C06138B
        for <linux-unionfs@vger.kernel.org>; Thu, 22 Apr 2021 01:13:38 -0700 (PDT)
Received: by mail-wm1-x32b.google.com with SMTP id w7-20020a1cdf070000b0290125f388fb34so2732936wmg.0
        for <linux-unionfs@vger.kernel.org>; Thu, 22 Apr 2021 01:13:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ffwll.ch; s=google;
        h=date:from:to:cc:subject:message-id:mail-followup-to:references
         :mime-version:content-disposition:content-transfer-encoding
         :in-reply-to;
        bh=y+2orF1pTAhlEapNdeXUHEPMIxuWbRepsrCfwxwKqPQ=;
        b=gHnwqNUV9ImgCFezmiVa76pK8wVFkRrxerF84m3fGkLrmxRPS22ANeM2+wardiWMau
         TIACxgmBON1oew/9mDWdVzRInBo7wiaCjCKjux8OlAWeeO77boWwGStL+p6m1yNjeC3R
         wCI3YUFG5nSBBAvTADfTufzcNHi3gNchFusrA=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id
         :mail-followup-to:references:mime-version:content-disposition
         :content-transfer-encoding:in-reply-to;
        bh=y+2orF1pTAhlEapNdeXUHEPMIxuWbRepsrCfwxwKqPQ=;
        b=qbAab/SrOFF5A0LIkPHbZMQDVJLMN7MozP7kn6nJgcqg9dDLfKCTXP/ZNvAzuqWzBJ
         MgfC48g3XaHu/TgmQG3oLLyxcd2IeiNbxR8Ry0OaZRjWrjwZtlN6lhelBvOjfuzSAxIU
         uTyu7h6NxYSLsu04RETCGAV2tyQ9OK7QuDBaPfGE5wiMKSsowrelj75WnbHjboMft83U
         smwo9Fg9s1v4L2uMDp/enD5zwUI/P6RZdN/NxYxgGtWWdhcIuiXF3T4kNx1zlsa4JsYX
         Z5aoelB9ilDTzf4YS2GoUZKrCvi7sqaLuVHjMMMSLWh1fRlbrdyBvR6iNbTbjM6c7TxE
         I1eg==
X-Gm-Message-State: AOAM531xvxxkwgdjIQuTXW3CbXsafB+xlCLDPVR+iV+jW8w0LY4qtU6f
        FiQOXIRklhyu8V0g86IWLe11Fg==
X-Google-Smtp-Source: ABdhPJxj8Wjmw9peJ0Dkkr6S5qwG/1RIJTJQvvdMp6AsnTRfP/VbwnRDvQEbFil5LrRoQEP2bPFE4A==
X-Received: by 2002:a1c:4b11:: with SMTP id y17mr2401274wma.72.1619079217522;
        Thu, 22 Apr 2021 01:13:37 -0700 (PDT)
Received: from phenom.ffwll.local ([2a02:168:57f4:0:efd0:b9e5:5ae6:c2fa])
        by smtp.gmail.com with ESMTPSA id b12sm20494903wmj.1.2021.04.22.01.13.36
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 22 Apr 2021 01:13:37 -0700 (PDT)
Date:   Thu, 22 Apr 2021 10:13:35 +0200
From:   Daniel Vetter <daniel@ffwll.ch>
To:     Christian =?iso-8859-1?Q?K=F6nig?= 
        <ckoenig.leichtzumerken@gmail.com>
Cc:     linux-kernel@vger.kernel.org, linux-unionfs@vger.kernel.org,
        codalist@coda.cs.cmu.edu, dri-devel@lists.freedesktop.org,
        jgg@ziepe.ca, jaharkes@cs.cmu.edu, akpm@linux-foundation.org,
        miklos@szeredi.hu, coda@cs.cmu.edu
Subject: Re: [PATCH 2/2] ovl: fix reference counting in ovl_mmap error path
Message-ID: <YIEwL09isbCIM82+@phenom.ffwll.local>
Mail-Followup-To: Christian =?iso-8859-1?Q?K=F6nig?= <ckoenig.leichtzumerken@gmail.com>,
        linux-kernel@vger.kernel.org, linux-unionfs@vger.kernel.org,
        codalist@coda.cs.cmu.edu, dri-devel@lists.freedesktop.org,
        jgg@ziepe.ca, jaharkes@cs.cmu.edu, akpm@linux-foundation.org,
        miklos@szeredi.hu, coda@cs.cmu.edu
References: <20210421132012.82354-1-christian.koenig@amd.com>
 <20210421132012.82354-2-christian.koenig@amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20210421132012.82354-2-christian.koenig@amd.com>
X-Operating-System: Linux phenom 5.7.0-1-amd64 
Precedence: bulk
List-ID: <linux-unionfs.vger.kernel.org>
X-Mailing-List: linux-unionfs@vger.kernel.org

On Wed, Apr 21, 2021 at 03:20:12PM +0200, Christian König wrote:
> mmap_region() now calls fput() on the vma->vm_file.
> 
> Fix this by using vma_set_file() so it doesn't need to be
> handled manually here any more.
> 
> Signed-off-by: Christian König <christian.koenig@amd.com>
> Fixes: 1527f926fd04 ("mm: mmap: fix fput in error path v2")
> CC: stable@vger.kernel.org # 5.11+
> ---
>  fs/overlayfs/file.c | 11 +----------
>  1 file changed, 1 insertion(+), 10 deletions(-)
> 
> diff --git a/fs/overlayfs/file.c b/fs/overlayfs/file.c
> index dbfb35fb0ff7..3847cdc069b5 100644
> --- a/fs/overlayfs/file.c
> +++ b/fs/overlayfs/file.c
> @@ -430,20 +430,11 @@ static int ovl_mmap(struct file *file, struct vm_area_struct *vma)
>  	if (WARN_ON(file != vma->vm_file))
>  		return -EIO;
>  
> -	vma->vm_file = get_file(realfile);
> +	vma_set_file(vma, realfile);

Reviewed-by: Daniel Vetter <daniel.vetter@ffwll.ch>

>  
>  	old_cred = ovl_override_creds(file_inode(file)->i_sb);
>  	ret = call_mmap(vma->vm_file, vma);
>  	revert_creds(old_cred);
> -
> -	if (ret) {
> -		/* Drop reference count from new vm_file value */
> -		fput(realfile);
> -	} else {
> -		/* Drop reference count from previous vm_file value */
> -		fput(file);
> -	}
> -
>  	ovl_file_accessed(file);
>  
>  	return ret;
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
