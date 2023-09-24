Return-Path: <linux-unionfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 757C4CE7A8A
	for <linux-unionfs@archiver.kernel.org>; Sun, 24 Sep 2023 17:52:18 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230180AbjIXRwX (ORCPT
        <rfc822;linux-unionfs@archiver.kernel.org>);
        Sun, 24 Sep 2023 13:52:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50488 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230093AbjIXRwW (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Sun, 24 Sep 2023 13:52:22 -0400
Received: from mail-wm1-x32b.google.com (mail-wm1-x32b.google.com [IPv6:2a00:1450:4864:20::32b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 06407FA
        for <linux-unionfs@vger.kernel.org>; Sun, 24 Sep 2023 10:52:16 -0700 (PDT)
Received: by mail-wm1-x32b.google.com with SMTP id 5b1f17b1804b1-4056ce55e6fso5811725e9.1
        for <linux-unionfs@vger.kernel.org>; Sun, 24 Sep 2023 10:52:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1695577934; x=1696182734; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=Ir9mk0UHDAvKa6kq66OLfr4z0SbfwAqY3rgeSgJS3kM=;
        b=h7QXEv17pgr3O0S1MDEEm7gli6JeBT5IWlUzfR6vO6V+X3pGl3cQXlw2mtndGqQz8G
         vrzmfG3ielYC8uT6GlmJJp+ggPyyGZtIa/enJNPffBbrvPrFniujbcQQ40ngRCNVyxWL
         uyCSPdt7WXptCo6irpyP7HgUNek/2M410W7ndmsb6BmU4zvfn+807+CwQ0po+NWJT8Ud
         1qvY6UTRKJnrSdN4kWJrPJvvLd4QJ3I55fzpnj6p4hUwuhd77M2PPf+nGkdb+pvkIFXa
         EhA9HxKUfcDtQcILdSYGNCpDPMzIBut3B2yaGoRHCWRO9h92lXcA+iGwNZpGExpNglul
         9oBw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1695577934; x=1696182734;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=Ir9mk0UHDAvKa6kq66OLfr4z0SbfwAqY3rgeSgJS3kM=;
        b=Aj5IFqETLTTO3PbF4faY/LXRE5Mt5FL4IRmmlXVoAN1vrsPb4Td5uoCUOnpZ1zXIlt
         yFIiYRq848F1+x//C5awbehXnDMD4QIDBOv3VMj9d3UWX7FcOGsRyo4aX+X1cRIw6TDI
         PU6IVJp97bdKL5GDzNFhYRxoQir1asmwFe/voeg9jJ5bG+nx+FVqZ3ck/VpJi89/pBlJ
         ZYS5Oyb2IrZRiJbOI6MJ63LgNKFt0fTZ06xuavEMWVY0Kp9GEhYcsccB49L9ZHT5be9O
         ige689JVXh6JkpI8BiifZUS09+FPkSBDULZbLVSvlZxK/CQHBajsmTa4a4HFZZwL5mXo
         Hftg==
X-Gm-Message-State: AOJu0YxAE9nO+MBqysxySJ5oJ7JeWMZkNqHG+lxsL48xKdwD7sJ5jvDn
        FsbOIrTVW2t8IOF0n4IQ5Jx8Xw==
X-Google-Smtp-Source: AGHT+IHn21Av2sg+tUQIfBUzW5btOP0/3Bt2ItWlpzj+MAgnm0QAyo2//jovOg6ljuRqOxXkYtgO3Q==
X-Received: by 2002:a05:600c:4d1f:b0:404:74bf:fb3e with SMTP id u31-20020a05600c4d1f00b0040474bffb3emr4132222wmp.2.1695577934095;
        Sun, 24 Sep 2023 10:52:14 -0700 (PDT)
Received: from [172.20.13.88] ([45.147.210.162])
        by smtp.gmail.com with ESMTPSA id e20-20020a05600c219400b003fe1c332810sm12934152wme.33.2023.09.24.10.52.12
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 24 Sep 2023 10:52:12 -0700 (PDT)
Message-ID: <02c1c68c-61a0-4d93-8619-971c0416b0e6@kernel.dk>
Date:   Sun, 24 Sep 2023 11:52:12 -0600
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [xfstests generic/617] fsx io_uring dio starts to fail on
 overlayfs since v6.6-rc1
Content-Language: en-US
To:     Zorro Lang <zlang@redhat.com>, linux-unionfs@vger.kernel.org
Cc:     io-uring@vger.kernel.org, fstests@vger.kernel.org
References: <20230924142754.ejwsjen5pvyc32l4@dell-per750-06-vm-08.rhts.eng.pek2.redhat.com>
From:   Jens Axboe <axboe@kernel.dk>
In-Reply-To: <20230924142754.ejwsjen5pvyc32l4@dell-per750-06-vm-08.rhts.eng.pek2.redhat.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-unionfs.vger.kernel.org>
X-Mailing-List: linux-unionfs@vger.kernel.org

On 9/24/23 8:29 AM, Zorro Lang wrote:
> Hi,
> 
> The generic/617 of fstests is a test case does IO_URING soak direct-IO
> fsx test, but recently (about from v6.6-rc1 to now) it always fails on
> overlayfs as [1], no matter the underlying fs is ext4 or xfs. But it
> never failed on overlay before, likes [2].
> 
> So I thought it might be a regression of overlay or io-uring on current v6.6.
> Please help to review, it's easy to reproduce. My system is Fedora-rawhide/RHEL-9,
> with upstream mainline linux HEAD=dc912ba91b7e2fa74650a0fc22cccf0e0d50f371.
> The generic/617.full output as [3].

It works without overlayfs - would be great if you could include how to
reproduce this with overlayfs.

-- 
Jens Axboe

