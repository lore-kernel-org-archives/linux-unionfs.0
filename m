Return-Path: <SRS0=s+il=7R=vger.kernel.org=linux-unionfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5B002C433E1
	for <linux-unionfs@archiver.kernel.org>; Thu,  4 Jun 2020 15:57:42 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 3A04C206A2
	for <linux-unionfs@archiver.kernel.org>; Thu,  4 Jun 2020 15:57:42 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=chromium.org header.i=@chromium.org header.b="UiJYyiPH"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729216AbgFDP5l (ORCPT
        <rfc822;linux-unionfs@archiver.kernel.org>);
        Thu, 4 Jun 2020 11:57:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38898 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729635AbgFDP5j (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Thu, 4 Jun 2020 11:57:39 -0400
Received: from mail-pl1-x642.google.com (mail-pl1-x642.google.com [IPv6:2607:f8b0:4864:20::642])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C49F4C08C5C2
        for <linux-unionfs@vger.kernel.org>; Thu,  4 Jun 2020 08:57:37 -0700 (PDT)
Received: by mail-pl1-x642.google.com with SMTP id y17so2338352plb.8
        for <linux-unionfs@vger.kernel.org>; Thu, 04 Jun 2020 08:57:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=z02HjpdIyC/f+FSei9jV/KYu36NFQ5uAYMvx88TokgE=;
        b=UiJYyiPHhL+5GtrxMVXWjvcLL6Qb6ycW1HR0pNl6xx96Ji5PVF2xsK4yG7NhyB73sH
         JfdV1+OVGIkRnNEt/Ilns2vglxHs5OARDplc1i8yf5PN/5MSVwspv90DlARICMpyJ3Ja
         NHisdCZ2Ihcjm/GmIb4s+HKitVRc9IbkqL5mc=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=z02HjpdIyC/f+FSei9jV/KYu36NFQ5uAYMvx88TokgE=;
        b=cgfzjKbZZ/3p70RYDd4w+zLtq1jqUupHcI3u7AAMLd9NS7oVPxHQFHmeeuYq3jVqqR
         l5gAe1TtudXW/YD44xiri0wcIe+sFluK7zY84PVwDZMctlQ9RlpR3vtanWsNCcgtswjV
         JBU37aGGWVn4Pa1lMR8Z71h7TOPYckBiBcIFTLhNE+xYqGTMh092+wk6z4c+T8RTv3ZX
         G5RXZRuVs8Mn8jDsneENJ7s8fAH6oxTA8yL8ahBHfMaAyvdhhW1K2xu1GU+pslTeRBOj
         UmziXMA3hVN1yTUK+k/mLi2+mpjq/DqDe5h2LFa52xgTba+bll+mJM6UQCAs4fw0Yku5
         UhjA==
X-Gm-Message-State: AOAM533d+Z+ANC6cjLoCqBqWD1zhwVzZ7+Av3AQmQ8sTDqdYZ1jpC/ki
        jqxJryf2X5KBeu66Uum8peBXKA==
X-Google-Smtp-Source: ABdhPJzAbcerGsniFWkInonNtK9waPikGTV4wg1tDPqm0XOFXk03xxeKyPpoHNFsKBzYlQyzuic08w==
X-Received: by 2002:a17:90b:252:: with SMTP id fz18mr6292145pjb.96.1591286257215;
        Thu, 04 Jun 2020 08:57:37 -0700 (PDT)
Received: from www.outflux.net (smtp.outflux.net. [198.145.64.163])
        by smtp.gmail.com with ESMTPSA id j12sm5106491pfd.21.2020.06.04.08.57.36
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 04 Jun 2020 08:57:36 -0700 (PDT)
Date:   Thu, 4 Jun 2020 08:57:35 -0700
From:   Kees Cook <keescook@chromium.org>
To:     glider@google.com
Cc:     miklos@szeredi.hu, vgoyal@redhat.com,
        linux-unionfs@vger.kernel.org, linux-kernel@vger.kernel.org,
        royyang@google.com, stable@vger.kernel.org
Subject: Re: [PATCH] ovl: explicitly initialize error in ovl_copy_xattr()
Message-ID: <202006040844.C50B47699@keescook>
References: <20200604084245.161480-1-glider@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200604084245.161480-1-glider@google.com>
Sender: linux-unionfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-unionfs.vger.kernel.org>
X-Mailing-List: linux-unionfs@vger.kernel.org

On Thu, Jun 04, 2020 at 10:42:45AM +0200, glider@google.com wrote:
> Under certain circumstances (we found this out running Docker on a
> Clang-built kernel with CONFIG_INIT_STACK_ALL) ovl_copy_xattr() may
> return uninitialized value of |error| from ovl_copy_xattr().
> It is then returned by ovl_create() to lookup_open(), which casts it to
> an invalid dentry pointer, that can be further read or written by the
> lookup_open() callers.
> 
> The uninitialized value is returned when all the xattr on the file
> are ovl_is_private_xattr(), which is actually a successful case,
> therefore we initialize |error| with 0.
> 
> Signed-off-by: Alexander Potapenko <glider@google.com>
> Cc: Kees Cook <keescook@chromium.org>
> Cc: Roy Yang <royyang@google.com>
> Cc: <stable@vger.kernel.org> # 4.1

Please include a Fixes (more below) and Link tags for details to help
guide backporting, then you don't need to bother with with "# 4.1",
the -stable tools will figure it out with a "Fixes" tag.

Thanks for the v2!

Link: https://bugs.chromium.org/p/chromium/issues/detail?id=1050405
Reviewed-by: Kees Cook <keescook@chromium.org>

> The bug seem to date back to at least v4.1 where the annotation has been
> introduced (i.e. the compilers started noticing error could be used
> before being initialized). I hovever didn't try to prove that the
> problem is actually reproducible on such ancient kernels. We've seen it
> on a real machine running v4.4 as well.

It seems like it came from this, but that's v4.5:

Fixes: e4ad29fa0d22 ("ovl: use a minimal buffer in ovl_copy_xattr")

What did you find in v4.1? It looks like error isn't uninitialized in
v4.1:

int ovl_copy_xattr(struct dentry *old, struct dentry *new)
{
        ssize_t list_size, size;
        char *buf, *name, *value;
        int error;

        if (!old->d_inode->i_op->getxattr ||
            !new->d_inode->i_op->getxattr)
                return 0;

        list_size = vfs_listxattr(old, NULL, 0);
        if (list_size <= 0) {
                if (list_size == -EOPNOTSUPP)
                        return 0;
                return list_size;
        }

        buf = kzalloc(list_size, GFP_KERNEL);
        if (!buf)
                return -ENOMEM;

        error = -ENOMEM;
...

But v4.1.52 backported the above patch (e4ad29fa0d22), which is why I
don't try to figure these things out manually. Once we find the commit,
the tools will figure it out. I think you just need:

Fixes: e4ad29fa0d22 ("ovl: use a minimal buffer in ovl_copy_xattr")
Cc: stable@vger.kernel.org

and things like v4.1.52 will get fixed (if anyone is actually doing
updates for v4.1.z any more...)

-- 
Kees Cook
