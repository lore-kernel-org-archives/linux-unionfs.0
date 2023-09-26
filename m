Return-Path: <linux-unionfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F112FE7E644
	for <linux-unionfs@archiver.kernel.org>; Tue, 26 Sep 2023 15:31:59 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235121AbjIZPcE (ORCPT
        <rfc822;linux-unionfs@archiver.kernel.org>);
        Tue, 26 Sep 2023 11:32:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55140 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232450AbjIZPcE (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Tue, 26 Sep 2023 11:32:04 -0400
Received: from mail-wr1-x42a.google.com (mail-wr1-x42a.google.com [IPv6:2a00:1450:4864:20::42a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AD82810E
        for <linux-unionfs@vger.kernel.org>; Tue, 26 Sep 2023 08:31:56 -0700 (PDT)
Received: by mail-wr1-x42a.google.com with SMTP id ffacd0b85a97d-3233799e7b8so288791f8f.0
        for <linux-unionfs@vger.kernel.org>; Tue, 26 Sep 2023 08:31:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1695742315; x=1696347115; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=QHUK3XA6t9FeNGqjzSk0NOt0bUlcoLE8r8/iWf7zF1k=;
        b=iRGK6I0hJmY8qLOZZsD1zPv5DxvWJ5MX3fmHRJ3E6nLcngNDuQ+KPkUU8Dvw2ht1nY
         6cSeN9D5KUS+MARISoMZlYY8xJ6KyXpJldixkI1233xQItN6GdyEANDwNSlaI0nZBcLc
         FWZWKk5NVDoNvwMmH07ImlRbh2kbTT+AvY4jxuK3nZMc3fgvihmCA6Ohfi+SwPe+pS3m
         R5aLuffGfTFkUipi1KubDcPDaDRi6aUHIjeWyJlo9wQH0kNFzsbtNPTK/eKwmUH4JBNf
         kht8n1T2zkhcj1xNPSA8TQnIs6l1OSU9PBypRRIf+g8Ptwz7mAh8D1Tqh52qked6xma1
         BiEQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1695742315; x=1696347115;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=QHUK3XA6t9FeNGqjzSk0NOt0bUlcoLE8r8/iWf7zF1k=;
        b=R4MNQfXemJb0ATKVGXCdMN80d38lRjads0OuZMV+hKUB/IYV7Ayfa5IGInsweg25tJ
         2Lnk9o5Cw+4UNt+Mu38flT65wTYpiiHyfOFdJ0XN6Kr37BKyGyD0GGu11PJgF+C+J6eY
         0yxre3QeVIb2pdXyHSRt3rIIM6G+2pTVgYlTN3TchBgzKFHlNuthhxJRA6pKJ3L5kYuw
         w4Yne0zRk/k5OhgEe/nYmpMXsNl/YnTZI95T71RUbO/54czAj+82QZMlbNDEnZx1IxXe
         icqRyPK3SerMZViqsZ5v+mJA3mShPQ5tQUeXKz7r/869K3IG+oejyjG3RwcpghjAJK/C
         nA+A==
X-Gm-Message-State: AOJu0YyKojJDXXBSM3UVMSfFpXL7xBf/HZEwtXN9DfOh3ImLv09/zH2F
        gdcPF3U2lqNoIxafyLTTUumPVg==
X-Google-Smtp-Source: AGHT+IEYxwZt76V+Rpr0TTGD8511T16Jag67bHnNDROZK1YLufS59ZvgG4iSbks5HcHwhbOeRdaQAA==
X-Received: by 2002:a05:6000:10e:b0:317:73e3:cf41 with SMTP id o14-20020a056000010e00b0031773e3cf41mr9003476wrx.1.1695742315030;
        Tue, 26 Sep 2023 08:31:55 -0700 (PDT)
Received: from [172.20.13.88] ([45.147.210.162])
        by smtp.gmail.com with ESMTPSA id l16-20020a5d4bd0000000b003216a068d2csm14957596wrt.24.2023.09.26.08.31.54
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 26 Sep 2023 08:31:54 -0700 (PDT)
Message-ID: <ef88fe8e-633d-4335-9cfd-2055857727db@kernel.dk>
Date:   Tue, 26 Sep 2023 09:31:53 -0600
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] ovl: disable IOCB_DIO_CALLER_COMP
Content-Language: en-US
To:     Zorro Lang <zlang@redhat.com>
Cc:     Amir Goldstein <amir73il@gmail.com>,
        LKML <linux-kernel@vger.kernel.org>,
        linux-unionfs@vger.kernel.org
References: <71897125-e570-46ce-946a-d4729725e28f@kernel.dk>
 <20230926152328.5vpz7yddmsjahkxt@dell-per750-06-vm-08.rhts.eng.pek2.redhat.com>
From:   Jens Axboe <axboe@kernel.dk>
In-Reply-To: <20230926152328.5vpz7yddmsjahkxt@dell-per750-06-vm-08.rhts.eng.pek2.redhat.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-unionfs.vger.kernel.org>
X-Mailing-List: linux-unionfs@vger.kernel.org

On 9/26/23 9:23 AM, Zorro Lang wrote:
> On Mon, Sep 25, 2023 at 12:21:35AM -0600, Jens Axboe wrote:
>> overlayfs copies the kiocb flags when it sets up a new kiocb to handle
>> a write, but it doesn't properly support dealing with the deferred
>> caller completions of the kiocb. This means it doesn't get the final
>> write completion value, and hence will complete the write with '0' as
>> the result.
>>
>> We could support the caller completions in overlayfs, but for now let's
>> just disable them in the generated write kiocb.
>>
>> Reported-by: Zorro Lang <zlang@redhat.com>
>> Link: https://lore.kernel.org/io-uring/20230924142754.ejwsjen5pvyc32l4@dell-per750-06-vm-08.rhts.eng.pek2.redhat.com/
>> Fixes: 8c052fb3002e ("iomap: support IOCB_DIO_CALLER_COMP")
>> Signed-off-by: Jens Axboe <axboe@kernel.dk>
>>
>> ---
> 
> Thanks Jens, the fstests generic/617 works on latest linux kernel with
> this patch now.

Excellent, thanks for re-testing.

-- 
Jens Axboe

