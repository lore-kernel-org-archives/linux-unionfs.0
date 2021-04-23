Return-Path: <linux-unionfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-4.2 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,
	SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1CBE2C43460
	for <linux-unionfs@archiver.kernel.org>; Fri, 23 Apr 2021 08:10:32 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id E5FF861350
	for <linux-unionfs@archiver.kernel.org>; Fri, 23 Apr 2021 08:10:31 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241346AbhDWILH (ORCPT
        <rfc822;linux-unionfs@archiver.kernel.org>);
        Fri, 23 Apr 2021 04:11:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43412 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241336AbhDWILG (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Fri, 23 Apr 2021 04:11:06 -0400
Received: from mail-ej1-x62c.google.com (mail-ej1-x62c.google.com [IPv6:2a00:1450:4864:20::62c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 50AC3C061574;
        Fri, 23 Apr 2021 01:10:29 -0700 (PDT)
Received: by mail-ej1-x62c.google.com with SMTP id r12so72642315ejr.5;
        Fri, 23 Apr 2021 01:10:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-transfer-encoding:content-language;
        bh=9ehiXslja300i2vGj1/93A1eFwKfaTwfsPk1xeLX9g0=;
        b=mTvEpz2zpeZnMPAsi5WCXFZWP6lDmuYfIHb8spsDH+ZFdAw5955Jn4QCxuCahCwVhu
         2HfEZB6dg1r5ZFiYL9cFtr+Eg+uOdzzf10gwJshgk6Dk0/jn8oqeZ6Rqc3JHhUSCByZT
         eIqiD3BzxpNBtswgL1dPuvnJhlbvdIXqHw2F0hoP9T1nVa+685UqEsz5JoW4QpU4UulT
         bVnm/9Y+I6Z+7t0sDQ1YFdF9SQP7EVB/JVHanABcn7GMxf/teGdINxjrY+Gj0JyrTAOr
         1hauBrNq0ZirSeDDRTC+zCEK9hVLSWBSnmJ5d8NW+h2uj+kh7RoQqlzS0Xmt4zYOOKhW
         3X5Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-transfer-encoding
         :content-language;
        bh=9ehiXslja300i2vGj1/93A1eFwKfaTwfsPk1xeLX9g0=;
        b=HYLHj8Lo7Ju3DOpcmkfFR4SwdZkQG6C+KfLfu7hHVExQFdulT0rl9PN9jVtkPIBjsV
         +ajA5iPowPHfX/BXN8fPypcUUwYftw4fiZsXaou8swbygzFkm64jFufq5u/65TCX6YWC
         n5ZixKHHO4vRs9GKUtTI68E1HKK56oAQYTKHEjdIAV+lu6I82xqQo8DBkd7Wmb+cDECD
         oap0Psx9XBy/97gMDhMNzMbUanimCuYR5ysbfFUbF+QqUHYBk0L5SsixpoxsbpfZsI21
         +MGddxlA+Sjh6rqUCBiDrxIvP0hnq1TjjFapH7uDL/Q3+68oZn9YARMFXOtQi2ojGUGD
         1BOg==
X-Gm-Message-State: AOAM533Y/Lu8/ANUmv3Vlut7xOErhF/ZAjVFBl2IOeISc+T/8uspZNaV
        HNkPxUBYWOLG59f1ETi1WpM=
X-Google-Smtp-Source: ABdhPJxVQP52a6KQPI83FRSHoKvz2CE8KYNXcsOBDRk9jrxzfsx25SaDMYXg1BKJAWCldqO9IVHctA==
X-Received: by 2002:a17:906:cc46:: with SMTP id mm6mr3007567ejb.138.1619165428070;
        Fri, 23 Apr 2021 01:10:28 -0700 (PDT)
Received: from ?IPv6:2a02:908:1252:fb60:509f:9ae8:ad1c:20a4? ([2a02:908:1252:fb60:509f:9ae8:ad1c:20a4])
        by smtp.gmail.com with ESMTPSA id t14sm3461827ejj.77.2021.04.23.01.10.27
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 23 Apr 2021 01:10:27 -0700 (PDT)
Subject: Re: [PATCH 1/2] coda: fix reference counting in coda_file_mmap error
 path
To:     Jan Harkes <jaharkes@cs.cmu.edu>
Cc:     linux-kernel@vger.kernel.org, linux-unionfs@vger.kernel.org,
        dri-devel@lists.freedesktop.org, coda@cs.cmu.edu,
        miklos@szeredi.hu, akpm@linux-foundation.org, jgg@ziepe.ca
References: <20210421132012.82354-1-christian.koenig@amd.com>
 <91292A4A-5F97-4FF8-ABAD-42392A0756B5@cs.cmu.edu>
 <f603f59b-ec52-7ad7-475a-fcf95902e145@gmail.com>
 <20210422135103.hif4a5znhzt4pc6f@cs.cmu.edu>
From:   =?UTF-8?Q?Christian_K=c3=b6nig?= <ckoenig.leichtzumerken@gmail.com>
Message-ID: <1dce6311-c708-19a8-a9cb-489602d6e930@gmail.com>
Date:   Fri, 23 Apr 2021 10:10:26 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.7.1
MIME-Version: 1.0
In-Reply-To: <20210422135103.hif4a5znhzt4pc6f@cs.cmu.edu>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
Precedence: bulk
List-ID: <linux-unionfs.vger.kernel.org>
X-Mailing-List: linux-unionfs@vger.kernel.org

Am 22.04.21 um 15:51 schrieb Jan Harkes:
> On Thu, Apr 22, 2021 at 02:39:41PM +0200, Christian König wrote:
>> Am 22.04.21 um 14:27 schrieb Jan Harkes:
>>> Looks good to me.
>>>
>>> I'm also maintaining an out of tree coda module build that people sometimes use, which has workarounds for differences between the various kernel versions.
>>>
>>> Do you have a reference to the corresponding mmap_region change? If it is merged already I'll probably be able to find it. Is this mmap_region change expected to be backported to any lts kernels?
>> That is the following upstream commit in Linus tree:
>>
>> commit 1527f926fd04490f648c42f42b45218a04754f87
>> Author: Christian König <christian.koenig@amd.com>
>> Date:   Fri Oct 9 15:08:55 2020 +0200
>>
>>      mm: mmap: fix fput in error path v2
>>
>> But I don't think we should backport that.
>>
>> And sorry for the noise. We had so many places which expected different
>> behavior that I didn't noticed that two occasions in the fs code actually
>> rely on the current behavior.
>>
>> For your out of tree module you could make the code version independent by
>> setting the vma back to the original file in case of an error. That should
>> work with both behaviors in mmap_region.
> Awesome, I'll give that a try, it may very well be a cleaner solution
> either way.
>
> And thank you for following up after your original patch and finding
> the filesystems that mess around with those mappings. I'm sure it would
> have taken me a while to figure out why file refcounts would go weird
> for some people, especially because this only happens in the error path.

Kudos goes to Miklos for figured out why the refcount for overlayfs was 
suddenly wrong.

And please also see the follow up commit:

commit 295992fb815e791d14b18ef7cdbbaf1a76211a31 (able/vma_file)
Author: Christian König <christian.koenig@amd.com>
Date:   Mon Sep 14 15:09:33 2020 +0200

     mm: introduce vma_set_file function v5

It adds a new vma_set_file() function which implements the necessary 
refcount dance for changing the vma file in a clean manner.

Thanks,
Christian.

>
> Jan
>

