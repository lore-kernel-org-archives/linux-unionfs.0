Return-Path: <linux-unionfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 92C11CE7A89
	for <linux-unionfs@archiver.kernel.org>; Mon, 25 Sep 2023 09:35:52 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233226AbjIYJf4 (ORCPT
        <rfc822;linux-unionfs@archiver.kernel.org>);
        Mon, 25 Sep 2023 05:35:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57924 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233255AbjIYJfz (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Mon, 25 Sep 2023 05:35:55 -0400
Received: from mail-pl1-x62e.google.com (mail-pl1-x62e.google.com [IPv6:2607:f8b0:4864:20::62e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 891D0C0
        for <linux-unionfs@vger.kernel.org>; Mon, 25 Sep 2023 02:35:48 -0700 (PDT)
Received: by mail-pl1-x62e.google.com with SMTP id d9443c01a7336-1c60c10db16so1624375ad.1
        for <linux-unionfs@vger.kernel.org>; Mon, 25 Sep 2023 02:35:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1695634548; x=1696239348; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=STG1spkKtEwmkFDyZa0Ua8RkG1cJT3VMnqvblFegD+Q=;
        b=kqP07ECHnb2QRyPfjc/eAfyqCCB+JKyr/l+ka4VVKK6+HmlGcoNqsPwILZBOHJqvrz
         pwpa8Slfu5I/JgKL8iYyexpqo+PoIJRHahfE64KKylpGM8veIbYQwhRX7epoctFpWWpl
         RtxT2PLjdrUTz/lWgdDEUbrn8NIcRNgmxrDI+4ILOBf4ZDQXC2vqsPNSnDsFjUq7Gdf8
         kym4i1ucD441jDtoQF4Xrsj48cdKeAyFkKiw7NksfMZ0MM1oFR9FMci1e7yq63wUvYqe
         cbr53q0sOMckc8DjCZPu1Tbx+MDEcI2TRAJ8t2OI6ZeN/ZYgEiVQVWgr5ZcPxrXVffMN
         V7hA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1695634548; x=1696239348;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=STG1spkKtEwmkFDyZa0Ua8RkG1cJT3VMnqvblFegD+Q=;
        b=nvKLUY3Jy5vR/GVFM8CPzRe1qapfGrQK39d1SqDcn/yuNdr1TEVSb5T6s3XDs6tEhJ
         6eYzZmDxxUkn6r8A0jtQhAwwLIdLUBP79NqEWSD1cIJhHnxN/fUk2jLw3eI2dJcwEKyv
         tqVfQdLOuoFW95NB6+pr1Pi4HxSOyTMFofPFIW9Hq6jZQTiSWHbsuQTwNUYAiTTnv69f
         OZlB9a2EOIVfFQIiahzwNCjQW68GTEf4lUnu8rS692X3UIyodtbgy/eNO5j7bEo4zXFj
         fVon0dWlvMsYoayCD4VUkw4WZpSfP54egrzgy+x9bST2Xfna4u55BPTIEForFintE0vI
         JZmg==
X-Gm-Message-State: AOJu0YyWwW9DnmIXrZ7l9thjzyTZVtAFGzrLGV4ONZ01xUdH9wsKjx+B
        me0/XZsVJYEgJlJs9pZrXwbEWQ==
X-Google-Smtp-Source: AGHT+IEZ2TzmS/eCgY48WMiwkTWVHYHrf7jB6+nEKVkaXOv0Fc6GOyUQFpPg2RTXO+9EzjOeLck60g==
X-Received: by 2002:a17:902:e887:b0:1bb:9e6e:a9f3 with SMTP id w7-20020a170902e88700b001bb9e6ea9f3mr8357611plg.4.1695634547883;
        Mon, 25 Sep 2023 02:35:47 -0700 (PDT)
Received: from ?IPV6:2600:380:4643:51cf:4cb8:ebc4:1388:2833? ([2600:380:4643:51cf:4cb8:ebc4:1388:2833])
        by smtp.gmail.com with ESMTPSA id y13-20020a170902ed4d00b001c61512f2a6sm2324695plb.220.2023.09.25.02.35.45
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 25 Sep 2023 02:35:47 -0700 (PDT)
Message-ID: <6d513d21-127c-447d-bc08-3f21c94b4132@kernel.dk>
Date:   Mon, 25 Sep 2023 03:35:43 -0600
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] ovl: disable IOCB_DIO_CALLER_COMP
Content-Language: en-US
To:     Amir Goldstein <amir73il@gmail.com>
Cc:     LKML <linux-kernel@vger.kernel.org>, linux-unionfs@vger.kernel.org,
        Zorro Lang <zlang@redhat.com>,
        Miklos Szeredi <miklos@szeredi.hu>,
        Christian Brauner <brauner@kernel.org>
References: <71897125-e570-46ce-946a-d4729725e28f@kernel.dk>
 <CAOQ4uxj7hC5iGfJSD35xAGC97x32y9nnKk8qJa8ux6owpgT1wQ@mail.gmail.com>
From:   Jens Axboe <axboe@kernel.dk>
In-Reply-To: <CAOQ4uxj7hC5iGfJSD35xAGC97x32y9nnKk8qJa8ux6owpgT1wQ@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-unionfs.vger.kernel.org>
X-Mailing-List: linux-unionfs@vger.kernel.org

On 9/25/23 3:18 AM, Amir Goldstein wrote:
> On Mon, Sep 25, 2023 at 9:21?AM Jens Axboe <axboe@kernel.dk> wrote:
>>
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
> 
> Thanks for fixing this Jens!
> If you or Christian want to send this fix to Linus, you have my ACK.

No problem - and thanks, maybe Christian can pick this one up? I
tentatively queued it up here just so I don't forget it:

https://git.kernel.dk/cgit/linux/log/?h=ovl-kiocb

> On the bright side, I am glad that you are aware of the overlayfs
> "kiocb_clone" use case, which delegates/forwards the io request to
> another file in another fs.
> 
> I have already posted an RFC [1] for moving this functionality to
> common vfs code. My main goal was to expose it to other filesystem
> (fuse), but a very desired side effect is that this functionality gets
> more vfs reviewer eyes and then the chances of catching a regression
> like this one during review of vfs changes hopefully increases.

Ah that's great! Yeah it's a bit hidden in there if you don't know about
it, and I did grep today when writing this patch to ensure we didn't
have any others like it. So I think we're good for now, at least.

> As for test coverage, I need to check why my tests did not catch
> this - I suspect fsx may not have been rebuilt with io_uring support,
> but not sure (not near workstation atm).

I'm guessing it's because you don't have liburing installed on the test
box, then fsx etc don't get built with io_uring support in xfstests.

> If you would like to add overlayfs to your test coverage, as Zorro
> explained, it is as simple as running ./check -overlay with your
> existing fstests config.
> ./check -overlay is a relatively faster test run because many of the
> tests do _notrun on overlayfs.
> I don't have to tell you that io_uring code will end up running on
> overlayfs in many container workloads, so it is not a niche setup.

Will add it to the mix! Thanks for the details.

-- 
Jens Axboe

