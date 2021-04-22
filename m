Return-Path: <linux-unionfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.3 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1E3F0C433B4
	for <linux-unionfs@archiver.kernel.org>; Thu, 22 Apr 2021 13:51:09 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id D04E66145C
	for <linux-unionfs@archiver.kernel.org>; Thu, 22 Apr 2021 13:51:08 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236254AbhDVNvm (ORCPT
        <rfc822;linux-unionfs@archiver.kernel.org>);
        Thu, 22 Apr 2021 09:51:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56388 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236226AbhDVNvl (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Thu, 22 Apr 2021 09:51:41 -0400
Received: from mail-qk1-x729.google.com (mail-qk1-x729.google.com [IPv6:2607:f8b0:4864:20::729])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 249B6C06174A
        for <linux-unionfs@vger.kernel.org>; Thu, 22 Apr 2021 06:51:07 -0700 (PDT)
Received: by mail-qk1-x729.google.com with SMTP id 66so6729003qkf.2
        for <linux-unionfs@vger.kernel.org>; Thu, 22 Apr 2021 06:51:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cs-cmu-edu.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:content-transfer-encoding:in-reply-to
         :user-agent;
        bh=sc812S/XH0xi1daedR2N2rrASOXlL4IU8Kqiol/mJyg=;
        b=ilf7MiKPmuLDCJimMx6HY09IjE0RtI8ZvwvdH6B6zfOQjt3XpT5zeEzYvZWEpLAdYN
         HgsytpNQ77VJrUr18k2RiREzJkRdWu0QpLA0tkuRNsG9RJNB3q1uAdrnsyEo+VtE/bkz
         B2jsPuMqREtLJPtddAk+Uo17G2/m8PXB2rUUgxU0rvhBi59tk2mXxC2MGCjH0Pjpp+VT
         mX7+laaPBOMCRKCQqV4hxZwgrlInehA3Gism8b/RZbMqm7co4BAjldanO0P5uXETbut4
         mzMIosKNAMoPho12DmysXBBsk5jjrFMiiqQDcmOd/Ypwjfkh2IjEZ9SeT0+ozvuXOA6A
         QC1g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:content-transfer-encoding
         :in-reply-to:user-agent;
        bh=sc812S/XH0xi1daedR2N2rrASOXlL4IU8Kqiol/mJyg=;
        b=DYA3+rAhwaVaxQ6SSARAEHM0TFuq5OcvZpYVi779ydi2aOd0CJ7Qx2h8MqZA03S0vy
         Cwg88Supmq1REyjYZF+AS6BTueaxMuHlzVudxtuzZwgwTLsYY04nAQjeLyJlNFEx4450
         faPCcjCNssEOySjdp3G+2or8LnUvNF+4NfVouxNeXp5rgak98NI+bICi4ZGgnWAPCb5f
         HBnEcSui0BSt0hFkMXCIWPrSxHF7rA1ZPiQsynTQ7bHtl7Lj9THImRO/TV5xwKpb3R8B
         G29quL1Jd7cjLBGUPwwfaZqjyNSSox6o39/WhI3p/YKWqzaPNsQmhoNDjDMF9rGzqG6Y
         /SfQ==
X-Gm-Message-State: AOAM5302X+sjkokR4Axd3m5t7nohqSrinKFqbParfp4eXAO9HPEONO6g
        irx8bw6L6OGTeVmvO6Q1oT8ZgQ==
X-Google-Smtp-Source: ABdhPJzopgVvvshO8HCJDMmm2d3/Wi7iBmogcMm1rcCSeWXZCE8qQJSe7zD8nyMnJxcAF1H8ro/U3g==
X-Received: by 2002:a37:c202:: with SMTP id i2mr3647788qkm.296.1619099466408;
        Thu, 22 Apr 2021 06:51:06 -0700 (PDT)
Received: from cs.cmu.edu (tunnel29655-pt.tunnel.tserv13.ash1.ipv6.he.net. [2001:470:7:582::2])
        by smtp.gmail.com with ESMTPSA id g1sm2207278qth.69.2021.04.22.06.51.05
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 22 Apr 2021 06:51:05 -0700 (PDT)
Date:   Thu, 22 Apr 2021 09:51:03 -0400
From:   Jan Harkes <jaharkes@cs.cmu.edu>
To:     Christian =?utf-8?B?S8O2bmln?= <ckoenig.leichtzumerken@gmail.com>
Cc:     linux-kernel@vger.kernel.org, linux-unionfs@vger.kernel.org,
        dri-devel@lists.freedesktop.org, coda@cs.cmu.edu,
        miklos@szeredi.hu, akpm@linux-foundation.org, jgg@ziepe.ca
Subject: Re: [PATCH 1/2] coda: fix reference counting in coda_file_mmap error
 path
Message-ID: <20210422135103.hif4a5znhzt4pc6f@cs.cmu.edu>
References: <20210421132012.82354-1-christian.koenig@amd.com>
 <91292A4A-5F97-4FF8-ABAD-42392A0756B5@cs.cmu.edu>
 <f603f59b-ec52-7ad7-475a-fcf95902e145@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <f603f59b-ec52-7ad7-475a-fcf95902e145@gmail.com>
User-Agent: NeoMutt/20180716
Precedence: bulk
List-ID: <linux-unionfs.vger.kernel.org>
X-Mailing-List: linux-unionfs@vger.kernel.org

On Thu, Apr 22, 2021 at 02:39:41PM +0200, Christian König wrote:
> Am 22.04.21 um 14:27 schrieb Jan Harkes:
> > Looks good to me.
> > 
> > I'm also maintaining an out of tree coda module build that people sometimes use, which has workarounds for differences between the various kernel versions.
> > 
> > Do you have a reference to the corresponding mmap_region change? If it is merged already I'll probably be able to find it. Is this mmap_region change expected to be backported to any lts kernels?
> 
> That is the following upstream commit in Linus tree:
> 
> commit 1527f926fd04490f648c42f42b45218a04754f87
> Author: Christian König <christian.koenig@amd.com>
> Date:   Fri Oct 9 15:08:55 2020 +0200
> 
>     mm: mmap: fix fput in error path v2
> 
> But I don't think we should backport that.
> 
> And sorry for the noise. We had so many places which expected different
> behavior that I didn't noticed that two occasions in the fs code actually
> rely on the current behavior.
> 
> For your out of tree module you could make the code version independent by
> setting the vma back to the original file in case of an error. That should
> work with both behaviors in mmap_region.

Awesome, I'll give that a try, it may very well be a cleaner solution
either way.

And thank you for following up after your original patch and finding
the filesystems that mess around with those mappings. I'm sure it would
have taken me a while to figure out why file refcounts would go weird
for some people, especially because this only happens in the error path.

Jan

