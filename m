Return-Path: <SRS0=ksQV=7Q=vger.kernel.org=linux-unionfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 598AFC433E0
	for <linux-unionfs@archiver.kernel.org>; Wed,  3 Jun 2020 20:35:13 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 31B542074B
	for <linux-unionfs@archiver.kernel.org>; Wed,  3 Jun 2020 20:35:13 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=chromium.org header.i=@chromium.org header.b="H8lAAd7t"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726088AbgFCUfN (ORCPT
        <rfc822;linux-unionfs@archiver.kernel.org>);
        Wed, 3 Jun 2020 16:35:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56586 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725821AbgFCUfM (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Wed, 3 Jun 2020 16:35:12 -0400
Received: from mail-pl1-x644.google.com (mail-pl1-x644.google.com [IPv6:2607:f8b0:4864:20::644])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6BD12C08C5C0
        for <linux-unionfs@vger.kernel.org>; Wed,  3 Jun 2020 13:35:12 -0700 (PDT)
Received: by mail-pl1-x644.google.com with SMTP id t7so1231628plr.0
        for <linux-unionfs@vger.kernel.org>; Wed, 03 Jun 2020 13:35:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=W5rG5azrfwU1SE5+6VF2CaiUSY0EB63jPHlaOLOAids=;
        b=H8lAAd7t8MN6jYw5eMcIVe9rAHxpKI1yFv/LZqIHzVdqTGi0osItXRbEC3imxxp5fw
         XiTsvqNcg9jDA5i7CRdaI5PyhRfdYFu1/Haxwk1herusBfde/0Rxv2M8k7zdqcBZ5vO2
         uAqTfTk4PSLas1IJTdwiVj7qe87PLWc/DJroM=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=W5rG5azrfwU1SE5+6VF2CaiUSY0EB63jPHlaOLOAids=;
        b=lZKxf04g6CdRi7qL2/9EBf/O8/1vnt4cf67T7SSqKb4Q6qOmpgtv8aFAFm4uFgd4Ca
         S6+2M2Q7Jt0/9/jiyp4jkqWoCbS5s+0+81EysU6N2fv9HQ0WoyR5NXgPjmPuU8eekxjM
         xRGtnEHL3H+MUVSEO1oqcDmbu7ufk8++84Vrysnkoqw5N0Fn1YBPTZ6Z8ktislZ1YI9R
         eTxfRZxjQ6I3iizALETfe4qV2gxoUuvb4T9u3RvYme8n6WTBPZqNZ8APbkF7lvieHU6L
         el61tl9lFFjmQUphWtHmt6lzNNUEnh3NbU25TTo2U+3/piyC1mXOQwya0u9UcaQIxwgp
         YVDQ==
X-Gm-Message-State: AOAM531vugG90MNBqn80KsXS50tCMuTl+Qy0xgjjZuQCu7BmtW5EX9qs
        ANXRABeoCAZ1TESoP/Tc/hFeLA==
X-Google-Smtp-Source: ABdhPJxh+aatEAcsfm7x2O7pF9u4HQEykZUt/5RuZbEPGXrhPVdcNGxmsklSppL48UqLLLYO/xjupQ==
X-Received: by 2002:a17:902:714e:: with SMTP id u14mr1478127plm.175.1591216512009;
        Wed, 03 Jun 2020 13:35:12 -0700 (PDT)
Received: from www.outflux.net (smtp.outflux.net. [198.145.64.163])
        by smtp.gmail.com with ESMTPSA id i10sm2573857pfa.166.2020.06.03.13.35.10
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 03 Jun 2020 13:35:10 -0700 (PDT)
Date:   Wed, 3 Jun 2020 13:35:09 -0700
From:   Kees Cook <keescook@chromium.org>
To:     glider@google.com
Cc:     miklos@szeredi.hu, linux-unionfs@vger.kernel.org,
        linux-kernel@vger.kernel.org, royyang@google.com,
        stable@vger.kernel.org
Subject: Re: [PATCH] ovl: explicitly initialize error in ovl_copy_xattr()
Message-ID: <202006031219.36197D0729@keescook>
References: <20200603174714.192027-1-glider@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200603174714.192027-1-glider@google.com>
Sender: linux-unionfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-unionfs.vger.kernel.org>
X-Mailing-List: linux-unionfs@vger.kernel.org

On Wed, Jun 03, 2020 at 07:47:14PM +0200, glider@google.com wrote:
> Under certain circumstances (we found this out running Docker on a
> Clang-built kernel with CONFIG_INIT_STACK_ALL) ovl_copy_xattr() may
> return uninitialized value of |error| from ovl_copy_xattr().
> It is then returned by ovl_create() to lookup_open(), which casts it to
> an invalid dentry pointer, that can be further read or written by the
> lookup_open() callers.
> 
> Signed-off-by: Alexander Potapenko <glider@google.com>

Link: https://bugs.chromium.org/p/chromium/issues/detail?id=1050405
Fixes: e4ad29fa0d22 ("ovl: use a minimal buffer in ovl_copy_xattr")
Cc: stable@vger.kernel.org
Reviewed-by: Kees Cook <keescook@chromium.org>

It seems the error isn't reported anywhere, so the value likely isn't
too important. -EINVAL seems sane to me.

Thought: should CONFIG_INIT_STACK_ALL=y disable uninitialized_var()?

$ git grep uninitialized_var | wc -l
300

We have evidence this is being used inappropriately and is masking bugs.
I would actually think it should should be removed globally, but it
seems especially important for CONFIG_INIT_STACK_ALL=y.

I've opened:
https://github.com/KSPP/linux/issues/81

-- 
Kees Cook
