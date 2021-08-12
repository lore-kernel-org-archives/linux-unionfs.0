Return-Path: <linux-unionfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.0 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 90DEAC432BE
	for <linux-unionfs@archiver.kernel.org>; Thu, 12 Aug 2021 07:12:59 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 8F6FB60EE2
	for <linux-unionfs@archiver.kernel.org>; Thu, 12 Aug 2021 07:12:58 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234581AbhHLHNW (ORCPT
        <rfc822;linux-unionfs@archiver.kernel.org>);
        Thu, 12 Aug 2021 03:13:22 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:26449 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230316AbhHLHNW (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Thu, 12 Aug 2021 03:13:22 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1628752377;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=r1z8oCJ5otLeJGBN/vU9nWn4UXFrvOTRJOJmiwu3d0Y=;
        b=ipTCpo3BCM2RXa/8XEyKvoKpyZUUv+AcYw3gSv6h8jIT8a0fYPVl//fUWAAOJASiMQ7EYY
        WpEd3sKqjZAqJY2VTL42iAwYSeAf8qVndaLKKjL6/TWus6+Ci2RrGAsyYd2DsknoWfNj8Q
        zR+tMQwngXtD/mcTFnlZdmwoZo5lA38=
Received: from mail-wm1-f72.google.com (mail-wm1-f72.google.com
 [209.85.128.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-245-jZH5fmugPO-MO_kj17lLvw-1; Thu, 12 Aug 2021 03:12:55 -0400
X-MC-Unique: jZH5fmugPO-MO_kj17lLvw-1
Received: by mail-wm1-f72.google.com with SMTP id k4-20020a05600c1c84b0290210c73f067aso1538669wms.6
        for <linux-unionfs@vger.kernel.org>; Thu, 12 Aug 2021 00:12:55 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:organization
         :message-id:date:user-agent:mime-version:in-reply-to
         :content-language:content-transfer-encoding;
        bh=r1z8oCJ5otLeJGBN/vU9nWn4UXFrvOTRJOJmiwu3d0Y=;
        b=h2nE5MiIKjcOb+faXXOXmrnFeYLrRe4TQ+ZgkfQbGq1+z8VhzgXlbDp4u7m+A05peY
         NffmuWghJGGnD9QPYBr+EXHQV3Nz7FDQCRbTuELW+1BLw3BdxEq/MIbj0fbmxHFLwaRx
         H57kGzCkeVzPjeCx8rs10Jcf/nyD5X0UE9XY2hXL7SdenYx1KAz72K93OV5iTqysGbUn
         dWffkiDRPYXQci3nr1ybxyJq0SIuw53JkAuX4zCps2sc4SELSzxRUGH3OlVV8Oyr2UBY
         suQB0wRUb1z3cEZdcZsfkzenu3KU28zVsJWrIpRMNgc6Gw8nFuMObInUGmRMEV3WpYfM
         RlzA==
X-Gm-Message-State: AOAM533akCGfq+/8cztcJxLghS34Hnka6kf3ULzvTqni27trNEtq/HiW
        ZflX8yoYgo2uAmlgiZ7sdmrBCnUvPhyBtUUfl4+2unRSyeswHpbC9WCdcKr2glGPd1M4snynohw
        sS+VklH6Obpr/g2t3pS6ksTjKBWvY1MMcoZIAs47CBiC2G/kuAq+tjlqX7W2h0MWF6A0YOh8rZA
        ==
X-Received: by 2002:a05:600c:2159:: with SMTP id v25mr14011565wml.187.1628752374781;
        Thu, 12 Aug 2021 00:12:54 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJwN8jmtH/cqMqGBW6lyfCsmyqhk628hKW3fRFyYAuqGvYPYW2AgLBL/d4G6Tz1Np7sZb4928g==
X-Received: by 2002:a05:600c:2159:: with SMTP id v25mr14011529wml.187.1628752374538;
        Thu, 12 Aug 2021 00:12:54 -0700 (PDT)
Received: from [192.168.3.132] (p4ff23d8b.dip0.t-ipconnect.de. [79.242.61.139])
        by smtp.gmail.com with ESMTPSA id m39sm7731910wms.28.2021.08.12.00.12.53
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 12 Aug 2021 00:12:54 -0700 (PDT)
Subject: Re: mmap denywrite mess (Was: [GIT PULL] overlayfs fixes for
 5.14-rc6)
To:     Linus Torvalds <torvalds@linux-foundation.org>
Cc:     Miklos Szeredi <miklos@szeredi.hu>,
        =?UTF-8?Q?Christian_K=c3=b6nig?= <christian.koenig@amd.com>,
        Matthew Wilcox <willy@infradead.org>,
        linux-mm <linux-mm@kvack.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>,
        linux-unionfs@vger.kernel.org
References: <YRPaodsBm3ambw8z@miu.piliscsaba.redhat.com>
 <c13de127-a7f0-c2c3-cb21-24fce2c90c11@redhat.com>
 <CAHk-=wg6AAX-uXHZnh_Fy=3dMTQYm_j6PKT3m=7xu-FdJOCxng@mail.gmail.com>
From:   David Hildenbrand <david@redhat.com>
Organization: Red Hat
Message-ID: <a540ba9f-6d3b-4d49-0424-b100bcdf38bf@redhat.com>
Date:   Thu, 12 Aug 2021 09:12:53 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.11.0
MIME-Version: 1.0
In-Reply-To: <CAHk-=wg6AAX-uXHZnh_Fy=3dMTQYm_j6PKT3m=7xu-FdJOCxng@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-unionfs.vger.kernel.org>
X-Mailing-List: linux-unionfs@vger.kernel.org

On 11.08.21 18:20, Linus Torvalds wrote:
> On Wed, Aug 11, 2021 at 4:45 AM David Hildenbrand <david@redhat.com> wrote:
>>
>> I proposed a while ago to get rid of VM_DENYWRITE completely:
>>
>> https://lkml.kernel.org/r/20210423131640.20080-1-david@redhat.com
>>
>> I haven't looked how much it still applies to current upstream, but
>> maybe that might help cleaning up that code.
> 
> I like it.
> 
> I agree that we could - and probably should - just do it this way.
> 
> We don't expose MAP_DENYWRITE to user space any more - and the old
> legacy library loading code certainly isn't worth it - and so
> effectively the only way to set it is with execve().
> 
> And yes, it gets rid of all the silly games with the per-mapping flags.

I'll rebase, retest and resend, putting you on cc. Then we can discuss 
if/how/when we might want to go that path.

-- 
Thanks,

David / dhildenb

