Return-Path: <linux-unionfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9FBABE784AC
	for <linux-unionfs@archiver.kernel.org>; Mon,  2 Oct 2023 14:06:37 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237476AbjJBOGi (ORCPT
        <rfc822;linux-unionfs@archiver.kernel.org>);
        Mon, 2 Oct 2023 10:06:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45942 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237452AbjJBOGh (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Mon, 2 Oct 2023 10:06:37 -0400
Received: from mail-ej1-x62a.google.com (mail-ej1-x62a.google.com [IPv6:2a00:1450:4864:20::62a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1F325B4
        for <linux-unionfs@vger.kernel.org>; Mon,  2 Oct 2023 07:06:34 -0700 (PDT)
Received: by mail-ej1-x62a.google.com with SMTP id a640c23a62f3a-9b2f73e3af3so289740066b.3
        for <linux-unionfs@vger.kernel.org>; Mon, 02 Oct 2023 07:06:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=szeredi.hu; s=google; t=1696255592; x=1696860392; darn=vger.kernel.org;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=VAUW2Ptp5fi9nS33M4QVhTdomfny1tX/0T0B0Bv24+E=;
        b=Le+f2bi555UHdJiUaczzOTiAPdr9bcw/o1CQEv7VuyRN+s8DOrtRhQxuOE9r9aHSuq
         GKv607hN5G1Kj9MmaMVxYGzRwCU8NXG5hg1r4wPnbUl0kqzWbNi5k0qqIlyjTssUg1h9
         Z2X0q/DUAkCXQMWMZNny7N/jgQ2mX3BRyDrLA=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1696255592; x=1696860392;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=VAUW2Ptp5fi9nS33M4QVhTdomfny1tX/0T0B0Bv24+E=;
        b=PxsTZLWD7oEJ4KrVJyU49NkJ7G9fxIbbEHPHOC2WueJqVPGOgSVv2Obs+oZJj6IEj1
         hJg8T748bjnLhtm5grWgHNxGsy9pKvNP10QuA+SW2YSbx5Kj2KP7mwa/0njeUf8v4bcA
         zIM7dJ3w15gTZ+L28CpdgK7REN3AmpF65ijAoFV4fpBXrAan0MuDDq6sL+4xDgPNJZsy
         oZ8HRVUeYifjI8Tqp+wcXLGEgQ8Qfm1M/8DcAp0FpfeD5HuJigAvl81MfOfqHzsQ+rAt
         2rVPrBrUnMUHt2BxxvmGwQ7Jcca549fqyIy3nQvv/6rq02Zl4/keOGWVNE1BFV7PEGVw
         FORw==
X-Gm-Message-State: AOJu0Yz/2fGqX7T4yJLpHU+1sjEmD02Vopt6xQ853nKjqWIg8sik+BB7
        DCZ1KupFhxRH/Foo6GDLLQgBJCFZDHg1rFmx6Flojg==
X-Google-Smtp-Source: AGHT+IE/k6ZogsbwM1Fd76z6VuVtEfqC9nMU+wHRR5+ZViTk/+6X0EY9eyACzk4fTvCyTSK/2vgUBXR1qINsRuP6V3Q=
X-Received: by 2002:a17:906:31da:b0:9b2:ba66:bbb0 with SMTP id
 f26-20020a17090631da00b009b2ba66bbb0mr10451279ejf.28.1696255592421; Mon, 02
 Oct 2023 07:06:32 -0700 (PDT)
MIME-Version: 1.0
References: <20231002120413.880734-1-amir73il@gmail.com>
In-Reply-To: <20231002120413.880734-1-amir73il@gmail.com>
From:   Miklos Szeredi <miklos@szeredi.hu>
Date:   Mon, 2 Oct 2023 16:06:21 +0200
Message-ID: <CAJfpeguNPHW8x3uwqzB_kKt_NxyPdMNNJUkMOsfvtxoAtAa1Ug@mail.gmail.com>
Subject: Re: [PATCH] overlayfs: make use of ->layers safe in rcu pathwalk
To:     Amir Goldstein <amir73il@gmail.com>
Cc:     Al Viro <viro@zeniv.linux.org.uk>,
        Christian Brauner <brauner@kernel.org>,
        linux-unionfs@vger.kernel.org, linux-fsdevel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-unionfs.vger.kernel.org>
X-Mailing-List: linux-unionfs@vger.kernel.org

On Mon, 2 Oct 2023 at 14:04, Amir Goldstein <amir73il@gmail.com> wrote:
>
> ovl_permission() accesses ->layers[...].mnt; we can't have ->layers
> freed without an RCU delay on fs shutdown.
>
> Fortunately, kern_unmount_array() that is used to drop those mounts
> does include an RCU delay, so freeing is delayed; unfortunately, the
> array passed to kern_unmount_array() is formed by mangling ->layers
> contents and that happens without any delays.
>
> The ->layers[...].name string entries are used to store the strings to
> display in "lowerdir=..." by ovl_show_options().  Those entries are not
> accessed in RCU walk.
>
> Move the name strings into a separate array ofs->config.lowerdirs and
> reuse the ofs->config.lowerdirs array as the temporary mount array to
> pass to kern_unmount_array().
>
> Reported-by: Al Viro <viro@zeniv.linux.org.uk>
> Link: https://lore.kernel.org/r/20231002023711.GP3389589@ZenIV/
> Signed-off-by: Amir Goldstein <amir73il@gmail.com>
> ---
>
> Miklos,
>
> Please review my proposal to fix the RCU walk race pointed out by Al.
> I have already tested it with xfstests and I will queue it in ovl-fixes
> to get more exposure in linux-next.

Looks good.

Acked-by: Miklos Szeredi <mszeredi@redhat.com>

Thanks,
Miklos
