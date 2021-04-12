Return-Path: <linux-unionfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.5 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0AF69C433B4
	for <linux-unionfs@archiver.kernel.org>; Mon, 12 Apr 2021 08:10:50 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id BD1AF6120B
	for <linux-unionfs@archiver.kernel.org>; Mon, 12 Apr 2021 08:10:49 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237125AbhDLILG (ORCPT
        <rfc822;linux-unionfs@archiver.kernel.org>);
        Mon, 12 Apr 2021 04:11:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55898 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237081AbhDLILF (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Mon, 12 Apr 2021 04:11:05 -0400
Received: from mail-vs1-xe32.google.com (mail-vs1-xe32.google.com [IPv6:2607:f8b0:4864:20::e32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3996AC061574
        for <linux-unionfs@vger.kernel.org>; Mon, 12 Apr 2021 01:10:48 -0700 (PDT)
Received: by mail-vs1-xe32.google.com with SMTP id g4so6200164vsq.8
        for <linux-unionfs@vger.kernel.org>; Mon, 12 Apr 2021 01:10:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=szeredi.hu; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=jQky1m6uu1GW602WD8GhQsQqvwVwu83hHa4LmvMepgM=;
        b=S/Q+RhbWY9dpNjYe1MsLD4SOqSlHFf1ThNZVpn874Wc/o8170f1Ci7tiLPSt21GRQY
         FxQM0Op3IXWIG914hPZKytgpUvU41EBy9nSzaBEyYKlu40CzY8Jchj7vkLNtMJ5IW2Jr
         44N1JMy8GrH1mQcrnBzdEa2X2SJSfcLQipCrk=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=jQky1m6uu1GW602WD8GhQsQqvwVwu83hHa4LmvMepgM=;
        b=gUjbfuGvW/RnVQ9RLOyZz6qZjF5yYJ1YzLtoft1XN+TmyoW3k/tCkfzjclFboUOBFX
         eSTNkjESyJQLVqJncB2vxqSIrA1pMttfVhcMnjxNI2FuCRTnKMjAzxgHApP8k7Gk4hmE
         +t0pHAbL2DW5PJj+Z36AA+pjl632VVcUsqq3KasoctKEWYRE4OT6+IzVCIigDWluMfEa
         w1koko0FhGWfCMLMbWr10ht7kCpjPwylCBfnttuLxgREVwe1FyBKOTrpjhL5EepnJoe6
         7JBtoziIu5ymffpGWKVt0bdTCOhP5rv7f73bRcm7TZqv9acQ9VzUFKmkjagvZqgjQ1bK
         OX1g==
X-Gm-Message-State: AOAM533faVMO+2KA8R5ySJ59Ul1JG6oQS1sxF9tm4HMFG5Iqqjoo+n43
        pxd5fOH1RQW2FD7WkHs+zlYu3FSSBSPM3Nxa1apsOQ==
X-Google-Smtp-Source: ABdhPJyCDZU6X0rCBV+HfLijsT0bYDVZSOvqWIlZyAeruBXeXLefWA42hjOWir983YRWwobbbbOzgE8oOG/3nCQy++I=
X-Received: by 2002:a67:6a85:: with SMTP id f127mr18362271vsc.9.1618215047420;
 Mon, 12 Apr 2021 01:10:47 -0700 (PDT)
MIME-Version: 1.0
References: <20210411092223.1914782-1-amir73il@gmail.com>
In-Reply-To: <20210411092223.1914782-1-amir73il@gmail.com>
From:   Miklos Szeredi <miklos@szeredi.hu>
Date:   Mon, 12 Apr 2021 10:10:36 +0200
Message-ID: <CAJfpeguY0znQOqcwyTe-Md8hDBtktwA=XWcGSymFU6me7=Dp+Q@mail.gmail.com>
Subject: Re: [PATCH] ovl: invalidate readdir cache on changes to dir with origin
To:     Amir Goldstein <amir73il@gmail.com>
Cc:     Chris Murphy <lists@colorremedies.com>,
        overlayfs <linux-unionfs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-unionfs.vger.kernel.org>
X-Mailing-List: linux-unionfs@vger.kernel.org

On Sun, Apr 11, 2021 at 11:22 AM Amir Goldstein <amir73il@gmail.com> wrote:
>
> The test in ovl_dentry_version_inc() was out-dated and did not include
> the case where readdir cache is used on a non-merge dir that has origin
> xattr, indicating that it may contain leftover whiteouts.
>
> To make the code more robust, use the same helper ovl_dir_is_real()
> to determine if readdir cache should be used and if readdir cache should
> be invalidated.

Makes sense, applied.

Thanks,
Miklos
