Return-Path: <linux-unionfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.6 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 790EEC433E6
	for <linux-unionfs@archiver.kernel.org>; Thu, 21 Jan 2021 07:47:21 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 2B9832313E
	for <linux-unionfs@archiver.kernel.org>; Thu, 21 Jan 2021 07:47:21 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726889AbhAUHrS (ORCPT
        <rfc822;linux-unionfs@archiver.kernel.org>);
        Thu, 21 Jan 2021 02:47:18 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50086 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727758AbhAUHrM (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Thu, 21 Jan 2021 02:47:12 -0500
Received: from mail-vk1-xa2d.google.com (mail-vk1-xa2d.google.com [IPv6:2607:f8b0:4864:20::a2d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D4333C06179F
        for <linux-unionfs@vger.kernel.org>; Wed, 20 Jan 2021 23:45:44 -0800 (PST)
Received: by mail-vk1-xa2d.google.com with SMTP id m145so306625vke.7
        for <linux-unionfs@vger.kernel.org>; Wed, 20 Jan 2021 23:45:44 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=szeredi.hu; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=Y7sF7+FLPmM9PAgGpkpD1+COzo7o3K2I8S1GYKfosm0=;
        b=ktfdhTk/xcZy19twUr7c6sAFuVBH+UpG9xuAj7y8oM4GnbUi4uzCUaDLfPKmGLP2Ao
         cGjb4HNTMWjKmM/y6Gfn8WpuDatYSl7mO/wW7JbbsVw5WxpRo3K8CBXMOB6+syTIvKEy
         jFZryjeKEgg6sCrsS4I4qLOcxhlEVy06vzgK0=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=Y7sF7+FLPmM9PAgGpkpD1+COzo7o3K2I8S1GYKfosm0=;
        b=W07LvfoopDMaVr9ESB8FjK1dCdtrqW82bk1H/4bJJ5TmXuvfFYQkhDS8pZhsosjL0A
         VxR5bjaYWJbekj1mITG1MUrNSDMY8xVMED7Tl0A+UAg5NZkegH4ug84gT2jRJqrljRHB
         mo3Kyp8o6WSeERO8aFFs1UqYGanznmFz14Papf21Yn3UIZfzVw3ctG3wdF3oGRFRdbCE
         uDIjlLKl7IJ6BeKGAZjOixrc7AV9bRAhk8ZXYClkcF8h1oTdYEXbPxLqs3ftW4mqyVgV
         SJSh5/dkFBke0sMFyM4YqY9jRNLdviw6OUxCMxAs6wVBJgOzhjR7I/RoCE5uX+uYrtlJ
         HpfA==
X-Gm-Message-State: AOAM5336qG46xKRWZtHO7gVOkhNT0GMv5iwDWing+Wuc6e98aKtfbtb4
        5U6ufHE3vtgMJuFIX1sTwTzfvdeDkf7yTxZuMt+wrQ==
X-Google-Smtp-Source: ABdhPJzgirrZmK8JGxXX+GmJLjRHNmP0mp4z8wqcccwIM+eJPJkRgRjscScM45TTbg0VIK4Jj14uA/lxf9m6umoQwKk=
X-Received: by 2002:ac5:c284:: with SMTP id h4mr9488685vkk.14.1611215143881;
 Wed, 20 Jan 2021 23:45:43 -0800 (PST)
MIME-Version: 1.0
References: <2701751f.acd1.1772201657e.Coremail.zjh.20052005@163.com>
In-Reply-To: <2701751f.acd1.1772201657e.Coremail.zjh.20052005@163.com>
From:   Miklos Szeredi <miklos@szeredi.hu>
Date:   Thu, 21 Jan 2021 08:45:33 +0100
Message-ID: <CAJfpeguF=v6WBRRgC+MGvQJ4Bni-Qp2Eb-0tUKqEUEz9sh4dbQ@mail.gmail.com>
Subject: Re: Overlayfs performance issue
To:     garyhuang <zjh.20052005@163.com>
Cc:     "linux-unionfs@vger.kernel.org" <linux-unionfs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-unionfs.vger.kernel.org>
X-Mailing-List: linux-unionfs@vger.kernel.org

On Wed, Jan 20, 2021 at 11:54 PM garyhuang <zjh.20052005@163.com> wrote:
>
> Hi Miklos,
>
> Have you ever come into this?
>
> 1. dockerd with overlay2
>    a. Running nginx in container mounting the host directory which contains the file to be accessed (docker -v xxx:xxx)
>    b. Running nginx in container mounting the host file directly
>    The RPS varies too much (RPS(a) < RPS(b)), the more the workers are, the bigger the discount is
>
> 2. dockerd with devicemapper
>    Running nginx in container with both the same mounting scenarios, the RPS is not discounted
>
> 3. nginx on host, no performance discounted too. The RPS equals to container with devicemapper.
>
> It is kernel related with big extra spinlock consumption observed by perf when running dockerd with overlayfs even the file is mounted from outside host path.

It's not clear where the contention is coming from.  Can you get some
detail from the perf trace where we can see which overlayfs functions
are involved?

Thanks,
Miklos
