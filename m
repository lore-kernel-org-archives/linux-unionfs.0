Return-Path: <linux-unionfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.6 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0C3D0C433B4
	for <linux-unionfs@archiver.kernel.org>; Fri,  9 Apr 2021 08:03:04 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id BBF6460FF1
	for <linux-unionfs@archiver.kernel.org>; Fri,  9 Apr 2021 08:03:03 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231496AbhDIIDP (ORCPT
        <rfc822;linux-unionfs@archiver.kernel.org>);
        Fri, 9 Apr 2021 04:03:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55820 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232483AbhDIICk (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Fri, 9 Apr 2021 04:02:40 -0400
Received: from mail-vk1-xa32.google.com (mail-vk1-xa32.google.com [IPv6:2607:f8b0:4864:20::a32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6D4C1C061760
        for <linux-unionfs@vger.kernel.org>; Fri,  9 Apr 2021 01:02:23 -0700 (PDT)
Received: by mail-vk1-xa32.google.com with SMTP id h136so1082696vka.7
        for <linux-unionfs@vger.kernel.org>; Fri, 09 Apr 2021 01:02:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=szeredi.hu; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=cjOXjmo4iN6dz2nQhDIuukh8J8qDhWNmt5Lt/a2EvU0=;
        b=eEBWQxbvbF0XsN4lkmc91kx0AX/Zk3yHhgiCUGzNh61mZcd5QORnueB9zQydLSZo9A
         W/XJz4IGEg9YHfVNWZC4keJ16LwBd93wbii/DZ7P417loBeZhgqeEeFpoIsQVeU6uNwR
         PKa88llxBHdCtuY5XwaLXTaB3Y2z3b0eeG7/w=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=cjOXjmo4iN6dz2nQhDIuukh8J8qDhWNmt5Lt/a2EvU0=;
        b=AW/p901JQlEC0zeVA9VpNI2TBNt74NXn15q9aY4L3J31+68P7fA8Q142me2LqgQIZX
         8ow+GJ/e8wd5qLPY+mCbIicoFk0kHxbQvZOSPs+07dtvGCGPy2a4CJnERSfONyk7YA3l
         0Bjf8VdEmL4KRPhNCdTNATnj9NrkTAT8bmhRLRE2Y0gPCC1+LuHOimrt8fEfemBrvlSK
         pkU1ajQFwqbKZPVEtnruzZgM/CdyaGA4Fx65rzvlYPNtdnbJw0l+jUKRQCGvkrV9jJT3
         lBtSO0Hkd2ObnTWtzZlqXnG9hqFr0B5QpV35s7CfAYiSr8wCwFi+rZiLW0wd7NEcFmwk
         w0Pg==
X-Gm-Message-State: AOAM531Bhosc4nQnRXffwOWLbFJT/1aBallFlmmZHINU6Lz3t8Pmlj50
        TEe7iuEHJs95RetdZZbabB6yPMkXPx9AwJdn+3qDKg==
X-Google-Smtp-Source: ABdhPJwlVi+5htpxtDLuATNNaC76M6HaFycNVdrdW63wEWnRuE/cRM029XeB9uDNsAUpTJI0jgBS+THV3kHU6RAK2sA=
X-Received: by 2002:a05:6122:54:: with SMTP id q20mr9898986vkn.3.1617955342330;
 Fri, 09 Apr 2021 01:02:22 -0700 (PDT)
MIME-Version: 1.0
References: <20210406120245.1338326-1-cgxu519@mykernel.net>
 <20210406120245.1338326-3-cgxu519@mykernel.net> <CAOQ4uxg2Rydq1kx-rqguvC=bp4m80o7Yzy5r+HK7sqxXAVtcdA@mail.gmail.com>
 <178b1a73e24.d39bf86c18637.6167819870142236772@mykernel.net>
 <CAOQ4uxg592CQWgm=9RQ5sPbOECYnPRrv7A_H-xhjD5TrPM9LaQ@mail.gmail.com>
 <178b4932399.f88d0a1719390.547968204570738952@mykernel.net> <CAOQ4uxhj3F_KQLyxEz3u7L-se-zWj40XiEsUKcuFurvYK_5S0w@mail.gmail.com>
In-Reply-To: <CAOQ4uxhj3F_KQLyxEz3u7L-se-zWj40XiEsUKcuFurvYK_5S0w@mail.gmail.com>
From:   Miklos Szeredi <miklos@szeredi.hu>
Date:   Fri, 9 Apr 2021 10:02:11 +0200
Message-ID: <CAJfpegu4+eSKkgugicZECKpSOSEuGJudGH-=0aNP5-f3uY9KUw@mail.gmail.com>
Subject: Re: [PATCH v2 3/3] ovl: copy-up optimization for truncate
To:     Amir Goldstein <amir73il@gmail.com>
Cc:     Chengguang Xu <cgxu519@mykernel.net>,
        overlayfs <linux-unionfs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-unionfs.vger.kernel.org>
X-Mailing-List: linux-unionfs@vger.kernel.org

On Fri, Apr 9, 2021 at 7:50 AM Amir Goldstein <amir73il@gmail.com> wrote:

> Anyway, I hold my opinion that the optimization of skipping notify_change()
> has little benefit and is a potential for bugs, even if the specific
> bug I pointed
> out is not real.

I can agree with that.

At this point the only sane way I can see this optimization be
implemented is to split the copy-up into a preparation and a commit
phase:

1) copy to tmpfile (can optimize to truncated size)
2) call notify_change() on the tmpfile to truncate
3) if successful, link the tmpfile into upper

With that the truncate still remains a single atomic operation.
Only slight difference is that now ctime will not match mtime after a
copy-up/truncate operation, but I guess that's not something anybody
should be dependent on.

Thanks,
Miklos
