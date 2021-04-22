Return-Path: <linux-unionfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-14.3 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A436EC43460
	for <linux-unionfs@archiver.kernel.org>; Thu, 22 Apr 2021 12:40:04 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 6F29A613FB
	for <linux-unionfs@archiver.kernel.org>; Thu, 22 Apr 2021 12:40:04 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236853AbhDVMkh (ORCPT
        <rfc822;linux-unionfs@archiver.kernel.org>);
        Thu, 22 Apr 2021 08:40:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40584 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237399AbhDVMkT (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Thu, 22 Apr 2021 08:40:19 -0400
Received: from mail-ed1-x534.google.com (mail-ed1-x534.google.com [IPv6:2a00:1450:4864:20::534])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7002EC061342;
        Thu, 22 Apr 2021 05:39:44 -0700 (PDT)
Received: by mail-ed1-x534.google.com with SMTP id h8so13116266edb.2;
        Thu, 22 Apr 2021 05:39:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-transfer-encoding:content-language;
        bh=/XBYAjJLx1qVHA3b0najgPrFujghsrg3OuSpsfyHHP4=;
        b=ub6UevUX5WIjnc5xfmQaq6vLdQiQM/jYy6A76PwpHy8hflFs+jpEW34SwnK5IPGjEl
         GT6Zxqdo5wVr3wdBkbIqyUqOwXW0tbBkz/usFLV4dWHp70M2MK9drZAaZhCQp2jmNZso
         UKHhTJQ4ikTKayOMK58FXliLx9GjvX4MNsesAVYsZDoXkSR3Co2pSvrD6kaoo616v5CI
         dX0rNxvf0SC6eKZMk+XncgG1k+e5mTwF2sWuD+VXlWxEvVyscxOYdQLoRK7IhZz7cxik
         VzsBt8wLVezeNkwXAErl276mdIh0mxxSJSFIoXnC0sVmHJFwy6mjEkhpYLmxxL2Ua4Ig
         JMqw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-transfer-encoding
         :content-language;
        bh=/XBYAjJLx1qVHA3b0najgPrFujghsrg3OuSpsfyHHP4=;
        b=FHvSE/ErNKWVYQcp31ywHx9Z5qyCWyEo8XlYZiKOawnpUGfdwlFhVh+gcAox3QioPc
         5XfC6i87ksvYVZdjCAGowlGGJlNHZKRR0hqdsry8+G+yKUCJa9osahJN4S1eJVrjWcLU
         RSJbqArG4X5yhxFzBWwyldOvzc619a0e45nsmaFj7NaFQRMmv9NkplAcQzUKK34q2tPa
         bIsX8xIaSpjdZ9GI/3GfRhOMj3ljNlEAOvoLq7WVEmk5ZJjFlXAuh9zy1KkBW4NhEbK6
         0XNDxYMoSGuA0TgDWXyYSfhTy0Uo4Z/3WECeDpGM3uu6cLs3C4lABA26+OQgQFHg3/xS
         aEnw==
X-Gm-Message-State: AOAM531nLI8kJ71RFxK+ZZLw/wso8tSwB+/Ty1ViCqSiQIvC814mfbTU
        1xGAQOTXKyDHGh7RLln064w=
X-Google-Smtp-Source: ABdhPJy0h2vBDFNtlTtJgHLJi2WJNAffXH4MoyYF2CIWypEpyOry+ISfMoFLwQeXV2HEScdFraYybQ==
X-Received: by 2002:aa7:db9a:: with SMTP id u26mr3546514edt.292.1619095183258;
        Thu, 22 Apr 2021 05:39:43 -0700 (PDT)
Received: from ?IPv6:2a02:908:1252:fb60:2fbd:d2a4:da7e:4526? ([2a02:908:1252:fb60:2fbd:d2a4:da7e:4526])
        by smtp.gmail.com with ESMTPSA id bw26sm1757735ejb.119.2021.04.22.05.39.42
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 22 Apr 2021 05:39:42 -0700 (PDT)
Subject: Re: [PATCH 1/2] coda: fix reference counting in coda_file_mmap error
 path
To:     Jan Harkes <jaharkes@cs.cmu.edu>, linux-kernel@vger.kernel.org,
        linux-unionfs@vger.kernel.org, dri-devel@lists.freedesktop.org
Cc:     coda@cs.cmu.edu, miklos@szeredi.hu, akpm@linux-foundation.org,
        jgg@ziepe.ca
References: <20210421132012.82354-1-christian.koenig@amd.com>
 <91292A4A-5F97-4FF8-ABAD-42392A0756B5@cs.cmu.edu>
From:   =?UTF-8?Q?Christian_K=c3=b6nig?= <ckoenig.leichtzumerken@gmail.com>
Message-ID: <f603f59b-ec52-7ad7-475a-fcf95902e145@gmail.com>
Date:   Thu, 22 Apr 2021 14:39:41 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.7.1
MIME-Version: 1.0
In-Reply-To: <91292A4A-5F97-4FF8-ABAD-42392A0756B5@cs.cmu.edu>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
Precedence: bulk
List-ID: <linux-unionfs.vger.kernel.org>
X-Mailing-List: linux-unionfs@vger.kernel.org

Hi Jan,

Am 22.04.21 um 14:27 schrieb Jan Harkes:
> Looks good to me.
>
> I'm also maintaining an out of tree coda module build that people sometimes use, which has workarounds for differences between the various kernel versions.
>
> Do you have a reference to the corresponding mmap_region change? If it is merged already I'll probably be able to find it. Is this mmap_region change expected to be backported to any lts kernels?

That is the following upstream commit in Linus tree:

commit 1527f926fd04490f648c42f42b45218a04754f87
Author: Christian König <christian.koenig@amd.com>
Date:   Fri Oct 9 15:08:55 2020 +0200

     mm: mmap: fix fput in error path v2

But I don't think we should backport that.

And sorry for the noise. We had so many places which expected different 
behavior that I didn't noticed that two occasions in the fs code 
actually rely on the current behavior.

For your out of tree module you could make the code version independent 
by setting the vma back to the original file in case of an error. That 
should work with both behaviors in mmap_region.

Thanks,
Christian.

>
> Jan
>
> On April 21, 2021 9:20:11 AM EDT, "Christian König" <ckoenig.leichtzumerken@gmail.com> wrote:
>> mmap_region() now calls fput() on the vma->vm_file.
>>
>> So we need to drop the extra reference on the coda file instead of the
>> host file.
>>
>> Signed-off-by: Christian König <christian.koenig@amd.com>
>> Fixes: 1527f926fd04 ("mm: mmap: fix fput in error path v2")
>> CC: stable@vger.kernel.org # 5.11+
>> ---
>> fs/coda/file.c | 6 +++---
>> 1 file changed, 3 insertions(+), 3 deletions(-)
>>
>> diff --git a/fs/coda/file.c b/fs/coda/file.c
>> index 128d63df5bfb..ef5ca22bfb3e 100644
>> --- a/fs/coda/file.c
>> +++ b/fs/coda/file.c
>> @@ -175,10 +175,10 @@ coda_file_mmap(struct file *coda_file, struct
>> vm_area_struct *vma)
>> 	ret = call_mmap(vma->vm_file, vma);
>>
>> 	if (ret) {
>> -		/* if call_mmap fails, our caller will put coda_file so we
>> -		 * should drop the reference to the host_file that we got.
>> +		/* if call_mmap fails, our caller will put host_file so we
>> +		 * should drop the reference to the coda_file that we got.
>> 		 */
>> -		fput(host_file);
>> +		fput(coda_file);
>> 		kfree(cvm_ops);
>> 	} else {
>> 		/* here we add redirects for the open/close vm_operations */

