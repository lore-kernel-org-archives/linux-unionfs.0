Return-Path: <SRS0=dsgN=7S=vger.kernel.org=linux-unionfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-11.4 required=3.0 tests=DKIMWL_WL_MED,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_IN_DEF_DKIM_WL
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3A7E3C433DF
	for <linux-unionfs@archiver.kernel.org>; Fri,  5 Jun 2020 09:46:48 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 0E78D206A2
	for <linux-unionfs@archiver.kernel.org>; Fri,  5 Jun 2020 09:46:48 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="iL9qGE+E"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726302AbgFEJqr (ORCPT
        <rfc822;linux-unionfs@archiver.kernel.org>);
        Fri, 5 Jun 2020 05:46:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34272 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726287AbgFEJqr (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Fri, 5 Jun 2020 05:46:47 -0400
Received: from mail-wm1-x342.google.com (mail-wm1-x342.google.com [IPv6:2a00:1450:4864:20::342])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 08DCCC08C5C3
        for <linux-unionfs@vger.kernel.org>; Fri,  5 Jun 2020 02:46:47 -0700 (PDT)
Received: by mail-wm1-x342.google.com with SMTP id k26so8457553wmi.4
        for <linux-unionfs@vger.kernel.org>; Fri, 05 Jun 2020 02:46:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=mbmJ3LGfRiCwEeU4P9Eu8WSdnCz4EbKhItYlMOGXu1A=;
        b=iL9qGE+E9zBWaNqdk8hDmBlMprQUairHW4PfVNjYcYGoaafczwzw9pIGtR1C8sQFTE
         tvtjvMIA7yevSjlNLmU70R4KAJIBT169XelUrMV1mu7EZscPE620aeO1gmajhcRCla5v
         oNn8Z7NIG2ldEbTq6q60ApoSLsbw/YjMlk1nCnzpG3yEILOdbd1S5eiVULW6bMGXYCQL
         Ecf8AtZCnzWtn+n3tHACfowa95G40epMD0AqAR/eynPrfj52cCxH+0tPuAxiaeJWx+T9
         VA0Kt+jw7TFw10lNElcTJX1B9QYCT8zOYBkgiXMD/k0r3goAiMGbM87IKvsSI1BMhyxE
         BDCA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=mbmJ3LGfRiCwEeU4P9Eu8WSdnCz4EbKhItYlMOGXu1A=;
        b=ttFMaVq6LKv3l92Ri1HaZyt9I5vXftly2Y3APQRDfDxbpaEayf9zBWTWfh0o6XKmAN
         q65H6U9z00u71ZwMZRmmpl8ciGMBEU7gJ5ZIftW2TASbX8fkwr0ro5StqdQ1/VWXp4iZ
         pLLlmdL/9EAZRYwapxmXmuPbbKxfGzIhIf7thdouWV4GQL1pIYQx+28QUcPD91P129w1
         nhJLtup8zzsawhL5Sdc3rgv4QfTeOLoNafOqfCX3a8iJ3xOXGgYK01VM4vF0CyBp3OQf
         SVDblXaNzKvH6vA2ZUwc3yyEfOZx7pLGMdcpm7IqBrdRPPKvq9VCoD1LSoBU7bqx3tti
         unGQ==
X-Gm-Message-State: AOAM531thWVr6Rgvd9HQcPwKrgtpSb8HEdOr8Ut3wgJBYY4uQvz1dpc7
        SqyTNcFaiCWdwnFY1f5hE7x6/yxQxP9oSScpobeY6A==
X-Google-Smtp-Source: ABdhPJz6paBIsszLKlumm4Z3GVnmnLd9zlrplUT1OaXrXB7uJgeytGX12BCwGe9vd8Vc/7j/UcCyZb0mpJOnD+AX4PM=
X-Received: by 2002:a1c:19c1:: with SMTP id 184mr1746984wmz.29.1591350405584;
 Fri, 05 Jun 2020 02:46:45 -0700 (PDT)
MIME-Version: 1.0
References: <20200604084245.161480-1-glider@google.com> <202006040844.C50B47699@keescook>
In-Reply-To: <202006040844.C50B47699@keescook>
From:   Alexander Potapenko <glider@google.com>
Date:   Fri, 5 Jun 2020 11:46:34 +0200
Message-ID: <CAG_fn=UMye_Qq3XZCVQP150iYeV3BrF_mPVLh83+H4mUy_cmnA@mail.gmail.com>
Subject: Re: [PATCH] ovl: explicitly initialize error in ovl_copy_xattr()
To:     Kees Cook <keescook@chromium.org>
Cc:     miklos@szeredi.hu, Vivek Goyal <vgoyal@redhat.com>,
        linux-unionfs@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
        Roy Yang <royyang@google.com>, stable@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Sender: linux-unionfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-unionfs.vger.kernel.org>
X-Mailing-List: linux-unionfs@vger.kernel.org

On Thu, Jun 4, 2020 at 5:57 PM Kees Cook <keescook@chromium.org> wrote:
>
> On Thu, Jun 04, 2020 at 10:42:45AM +0200, glider@google.com wrote:
> > Under certain circumstances (we found this out running Docker on a
> > Clang-built kernel with CONFIG_INIT_STACK_ALL) ovl_copy_xattr() may
> > return uninitialized value of |error| from ovl_copy_xattr().
> > It is then returned by ovl_create() to lookup_open(), which casts it to
> > an invalid dentry pointer, that can be further read or written by the
> > lookup_open() callers.
> >
> > The uninitialized value is returned when all the xattr on the file
> > are ovl_is_private_xattr(), which is actually a successful case,
> > therefore we initialize |error| with 0.
> >
> > Signed-off-by: Alexander Potapenko <glider@google.com>
> > Cc: Kees Cook <keescook@chromium.org>
> > Cc: Roy Yang <royyang@google.com>
> > Cc: <stable@vger.kernel.org> # 4.1
>
> Please include a Fixes (more below) and Link tags for details to help
> guide backporting, then you don't need to bother with with "# 4.1",
> the -stable tools will figure it out with a "Fixes" tag.
>
> Thanks for the v2!
>
> Link: https://bugs.chromium.org/p/chromium/issues/detail?id=1050405
> Reviewed-by: Kees Cook <keescook@chromium.org>
>
> > The bug seem to date back to at least v4.1 where the annotation has been
> > introduced (i.e. the compilers started noticing error could be used
> > before being initialized). I hovever didn't try to prove that the
> > problem is actually reproducible on such ancient kernels. We've seen it
> > on a real machine running v4.4 as well.
>
> It seems like it came from this, but that's v4.5:
>
> Fixes: e4ad29fa0d22 ("ovl: use a minimal buffer in ovl_copy_xattr")

https://bugs.chromium.org/p/chromium/issues/detail?id=1050405 mentions v4.4.212.
Your patch could've been slipped into that kernel as well.

> What did you find in v4.1? It looks like error isn't uninitialized in
> v4.1:

The annotation appeared first in
https://elixir.bootlin.com/linux/v4.1.18/source/fs/overlayfs/copy_up.c#L27,
does that count as 4.1 or 4.2?

> But v4.1.52 backported the above patch (e4ad29fa0d22), which is why I
> don't try to figure these things out manually. Once we find the commit,
> the tools will figure it out. I think you just need:
>
> Fixes: e4ad29fa0d22 ("ovl: use a minimal buffer in ovl_copy_xattr")
> Cc: stable@vger.kernel.org

Sounds good!
