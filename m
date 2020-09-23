Return-Path: <SRS0=0kBH=DA=vger.kernel.org=linux-unionfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.6 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A75B7C4363D
	for <linux-unionfs@archiver.kernel.org>; Wed, 23 Sep 2020 07:44:19 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 3BC1921924
	for <linux-unionfs@archiver.kernel.org>; Wed, 23 Sep 2020 07:44:19 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=szeredi.hu header.i=@szeredi.hu header.b="EDFoI7Pi"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726156AbgIWHoT (ORCPT
        <rfc822;linux-unionfs@archiver.kernel.org>);
        Wed, 23 Sep 2020 03:44:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55770 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726149AbgIWHoS (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Wed, 23 Sep 2020 03:44:18 -0400
Received: from mail-ua1-x942.google.com (mail-ua1-x942.google.com [IPv6:2607:f8b0:4864:20::942])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8CAE3C061755
        for <linux-unionfs@vger.kernel.org>; Wed, 23 Sep 2020 00:44:18 -0700 (PDT)
Received: by mail-ua1-x942.google.com with SMTP id h15so6344165uab.3
        for <linux-unionfs@vger.kernel.org>; Wed, 23 Sep 2020 00:44:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=szeredi.hu; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=rl19lI+kzmvLV+RTaRC2uHmkNHy2s32s2TlrNNmSXiI=;
        b=EDFoI7PiyIzC8lWlUiL1PpQxuozqM9FpybG0HWP7YEbQj8TOWbMzvV7mNyiz4I44kY
         V0a3gByPJEx+VHK9ovn7jeb2B6qKvNFlpva2wWMCVQK39wQ8SajNBxmUvCC5oxcN+a7K
         96/dG58Y2X5+z6Bl+UC7Pt11ameOiROtv5wZg=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=rl19lI+kzmvLV+RTaRC2uHmkNHy2s32s2TlrNNmSXiI=;
        b=Rw38Gb/mRktNU0K5d3Y4rH9s5IHgPuajWOAdpwosOaaZI6shVa0w0U/uLCKt5AghX/
         sDiSw1jSQIydd23qZ8xZ59/DhC8ZiusMs/ME1q+r8iqPpRH0T6xnCR31TEHmAjezUJk6
         CAZCXw4f+L0cREd1MrvTcgP8NHmZxniWGmDKuUgqeDlOHt2LvOlNDbltB/Skq9f8kx63
         uxO5IQYTrQDx5FU0iGttgXmgmAinCebIEdcO/Z6kASOh6g+Lj2ORey+QC5eUY4j5Vi6E
         +t/0ktk8HyD9IldO9GzTcSy3omcnnolLeOKxo1/rCsxWYpsOatnBuUv9ZjVEc8p5Lt7N
         kUyw==
X-Gm-Message-State: AOAM532R7JPADeRmAzlTNUONPacMSIXnrHNAWWtEBfVjVRY+O8gTg6Yz
        w88QeYB9oyV2iPn86WcdVBF/gk/uX9KlQvIjgwWjpw==
X-Google-Smtp-Source: ABdhPJxfmBPlZ+telSSrlZN0qAwufcsB4ufZxJNuUCefdCwzZZ5LDOhEUknY1T4dPkEPWXD4hRf2kao3fkIKF9qMcm4=
X-Received: by 2002:ab0:6298:: with SMTP id z24mr6015411uao.105.1600847057500;
 Wed, 23 Sep 2020 00:44:17 -0700 (PDT)
MIME-Version: 1.0
References: <a8828676-210a-99e8-30d7-6076f334ed71@virtuozzo.com>
 <CAOQ4uxgZ08ePA5WFOYFoLZaq_-Kjr-haNzBN5Aj3MfF=f9pjdg@mail.gmail.com>
 <1bb71cbf-0a10-34c7-409d-914058e102f6@virtuozzo.com> <CAOQ4uxieqnKENV_kJYwfcnPjNdVuqH3BnKVx_zLz=N_PdAguNg@mail.gmail.com>
 <dc696835-bbb5-ed4e-8708-bc828d415a2b@virtuozzo.com> <CAOQ4uxg0XVEEzc+HyyC63WWZuA2AsRjJmbZBuNimtj=t+quVyg@mail.gmail.com>
 <20200922210445.GG57620@redhat.com> <CAOQ4uxg_FV8U833qVkgPaAWJ4MNcnGoy9Gci41bmak4_ROSc3g@mail.gmail.com>
In-Reply-To: <CAOQ4uxg_FV8U833qVkgPaAWJ4MNcnGoy9Gci41bmak4_ROSc3g@mail.gmail.com>
From:   Miklos Szeredi <miklos@szeredi.hu>
Date:   Wed, 23 Sep 2020 09:44:06 +0200
Message-ID: <CAJfpegvNZ6Z7uhuTdQ6quBaTOYNkAP8W_4yUY4L2JRAEKxEwOQ@mail.gmail.com>
Subject: Re: virtiofs uuid and file handles
To:     Amir Goldstein <amir73il@gmail.com>
Cc:     Vivek Goyal <vgoyal@redhat.com>,
        overlayfs <linux-unionfs@vger.kernel.org>,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>,
        Max Reitz <mreitz@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-unionfs.vger.kernel.org>
X-Mailing-List: linux-unionfs@vger.kernel.org

On Wed, Sep 23, 2020 at 4:49 AM Amir Goldstein <amir73il@gmail.com> wrote:

> I think that the proper was to implement reliable persistent file
> handles in fuse/virtiofs would be to add ENCODE/DECODE to
> FUSE protocol and allow the server to handle this.

Max Reitz (Cc-d) is currently looking into this.

One proposal was to add  LOOKUP_HANDLE operation that is similar to
LOOKUP except it takes a {variable length handle, name} as input and
returns a variable length handle *and* a u64 node_id that can be used
normally for all other operations.

The advantage of such a scheme for virtio-fs (and possibly other fuse
based fs) would be that userspace need not keep a refcounted object
around until the kernel sends a FORGET, but can prune its node ID
based cache at any time.   If that happens and a request from the
client (kernel) comes in with a stale node ID, the server will return
-ESTALE and the client can ask for a new node ID with a special
lookup_handle(fh, NULL).

Disadvantages being:

 - cost of generating a file handle on all lookups
 - cost of storing file handle in kernel icache

I don't think either of those are problematic in the virtiofs case.
The cost of having to keep fds open while the client has them in its
cache is much higher.

Thanks,
Miklos
