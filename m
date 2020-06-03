Return-Path: <SRS0=ksQV=7Q=vger.kernel.org=linux-unionfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.6 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0DDDCC433E0
	for <linux-unionfs@archiver.kernel.org>; Wed,  3 Jun 2020 08:06:50 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id CF2B42067B
	for <linux-unionfs@archiver.kernel.org>; Wed,  3 Jun 2020 08:06:49 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=szeredi.hu header.i=@szeredi.hu header.b="O6FL79P0"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726099AbgFCIGt (ORCPT
        <rfc822;linux-unionfs@archiver.kernel.org>);
        Wed, 3 Jun 2020 04:06:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53206 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726083AbgFCIGt (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Wed, 3 Jun 2020 04:06:49 -0400
Received: from mail-ej1-x642.google.com (mail-ej1-x642.google.com [IPv6:2a00:1450:4864:20::642])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1FD72C05BD43
        for <linux-unionfs@vger.kernel.org>; Wed,  3 Jun 2020 01:06:49 -0700 (PDT)
Received: by mail-ej1-x642.google.com with SMTP id a2so1149662ejb.10
        for <linux-unionfs@vger.kernel.org>; Wed, 03 Jun 2020 01:06:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=szeredi.hu; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=Xj3EoPtDiRqI+Y48kRjGkX4jJF0Z7hbG4cQQxjLyj+s=;
        b=O6FL79P0pl37y02cm8oJ+lYyTtjzExLcwedsPPImNRPFOD80dPCldGgLqzoti294Q3
         Piq7K6A9Ke410G9Mmexq3YcxzzKkhBKlduYO0Gy8JYXeCZX0ZRmSDxltbdoo5LqHsEIE
         6DPg5xuD7pcrLMaORwyc5wi37IGLX9VbC5uso=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=Xj3EoPtDiRqI+Y48kRjGkX4jJF0Z7hbG4cQQxjLyj+s=;
        b=LolMJYS9dm6GoE89dLHOFHMkxQr7ClUEZ3ohLry32j1+jTn4NuURyv/qZyEhkMu4kD
         Cl9dYdeWobQ7aHHgCjLj/e+aps1Y0H3j2mqFr9m2wZsHFAbJ0kDttb01NUKOcwOtynXS
         HD6yXpHkXNU/Eh5RxaiJklON3KpMubw0iuYJFLz6P9ByuYXu8S/t/iYi8H0qksNVhMIZ
         Y9mKYX+6BLrlT07smeRzQ2G8MQbQe9yD2NEzt2JbHZdZxGKQWIBSJ6AT2J7xb7Uk2Ush
         CkY3PLJmb37Ti28f3sOsqqepCdrdiDNsYzVngLFVhx/1EM6ecnR+wnNtqLon9CmDO087
         UX8A==
X-Gm-Message-State: AOAM531uGinvWDSoXGc/HyfhNvkME3mdI7yv5DDdAmQrYY9n9X019GzY
        J0DvLw1E7yEz0otIz+xQclStEHLl1TNNHXbQC9gYvg==
X-Google-Smtp-Source: ABdhPJy0S6ltgsKCVvIgeaiUEMmOpsf09tB7qhu4Z9Tdz00IIOUDn4RV6KSWIjNMEl06fSKFrbq1MU6fGEN4sWjfIrY=
X-Received: by 2002:a17:906:31d2:: with SMTP id f18mr16271281ejf.110.1591171607893;
 Wed, 03 Jun 2020 01:06:47 -0700 (PDT)
MIME-Version: 1.0
References: <20200602152338.GA3311@redhat.com> <20200602183920.GC3311@redhat.com>
In-Reply-To: <20200602183920.GC3311@redhat.com>
From:   Miklos Szeredi <miklos@szeredi.hu>
Date:   Wed, 3 Jun 2020 10:06:36 +0200
Message-ID: <CAJfpegvr+Ltbo+1Pw4NK4T=5dxLZSFYh1ULqo1nysHCdbZ4cGw@mail.gmail.com>
Subject: Re: [PATCH] overlayfs: Fix redirect traversal on metacopy dentries
To:     Vivek Goyal <vgoyal@redhat.com>
Cc:     Amir Goldstein <amir73il@gmail.com>,
        overlayfs <linux-unionfs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-unionfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-unionfs.vger.kernel.org>
X-Mailing-List: linux-unionfs@vger.kernel.org

On Tue, Jun 2, 2020 at 8:39 PM Vivek Goyal <vgoyal@redhat.com> wrote:
>
> On Tue, Jun 02, 2020 at 11:23:38AM -0400, Vivek Goyal wrote:
> > Amir pointed me to metacopy test cases in unionmount-testsuite and
> > I decided to run "./run --ov=10 --meta" and it failed while running
> > test "rename-mass-5.py".

Thanks, applied.

Miklos
