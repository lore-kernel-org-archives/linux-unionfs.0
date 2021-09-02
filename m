Return-Path: <linux-unionfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7D9E8C83028
	for <linux-unionfs@archiver.kernel.org>; Thu,  2 Sep 2021 16:35:50 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 574A560FC0
	for <linux-unionfs@archiver.kernel.org>; Thu,  2 Sep 2021 16:35:50 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346284AbhIBQgr (ORCPT
        <rfc822;linux-unionfs@archiver.kernel.org>);
        Thu, 2 Sep 2021 12:36:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49782 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234558AbhIBQgn (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Thu, 2 Sep 2021 12:36:43 -0400
Received: from mail-lf1-x133.google.com (mail-lf1-x133.google.com [IPv6:2a00:1450:4864:20::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A0050C061575
        for <linux-unionfs@vger.kernel.org>; Thu,  2 Sep 2021 09:35:44 -0700 (PDT)
Received: by mail-lf1-x133.google.com with SMTP id t12so5445749lfg.9
        for <linux-unionfs@vger.kernel.org>; Thu, 02 Sep 2021 09:35:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linux-foundation.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=vPrsMqCFWN5ib/jexjJbOwaX0GY7GM4LAYtcBkjQs5Q=;
        b=b3xI1nUr2/Mn5lXTe8nymD6u/TZbVZW+KxgxiDD6kyYY168iu2pTlL23fELvbHgCpN
         4Fj+7xzFU3A8C58jpF8+C+JtLfgp1XCOGuw0IiJgEozDRP+l/GRHkybpYixOynp9lv2/
         Y952+XTnIiHmfQ+eXPBncvGvwPdqXLKde1dnU=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=vPrsMqCFWN5ib/jexjJbOwaX0GY7GM4LAYtcBkjQs5Q=;
        b=oTtNelcoVhldrSPvPUVzh5PUIAiCcJWJ5WfAGBzokgq9RFb+fbtO/kM9lhfkUFapn8
         NJ0UJLdAON+FhKbEgeDknWtR+RX5Qz30g1wRy+NXVmdBp959Th3jvHbDtnB1o3QlH2uc
         IqIbU6UFwT40fwlZXFyGxpqmLqYCiNLOsA0OBdhzB5wdABhppkzCCQ51SFarX9UyUsGG
         2+ycsNmrJeKfA6Yio02lzBAwQhqkkDgSbrV5jRLZ9YANIzoreosR05KzQszOmfqbJFQ8
         YKKkPGVrosAFZkf2RrpKWi5TMf8Coj//0ZFsT13+LFsA5qHp06jrzGstnIVOOIC4ab7R
         0Mfw==
X-Gm-Message-State: AOAM532+Uyz/O5lGpXv2DMXchDOFwlhWiWByXnBFpBJB3qUo7lUs7HGq
        fXYLeVzKqQArFIi0P7+sf0TrwW4ruV9RQX7hzcI=
X-Google-Smtp-Source: ABdhPJwODgh8BGEcjM0CESimI06dWoBCUQAaqiwyJkAGQF4Ww6r5d2gjhdwtXvDKJePnrW3ICRU5Jg==
X-Received: by 2002:a05:6512:a84:: with SMTP id m4mr3153812lfu.574.1630600542486;
        Thu, 02 Sep 2021 09:35:42 -0700 (PDT)
Received: from mail-lf1-f42.google.com (mail-lf1-f42.google.com. [209.85.167.42])
        by smtp.gmail.com with ESMTPSA id z13sm278915ljj.43.2021.09.02.09.35.40
        for <linux-unionfs@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 02 Sep 2021 09:35:40 -0700 (PDT)
Received: by mail-lf1-f42.google.com with SMTP id x27so5621871lfu.5
        for <linux-unionfs@vger.kernel.org>; Thu, 02 Sep 2021 09:35:40 -0700 (PDT)
X-Received: by 2002:a05:6512:3b7:: with SMTP id v23mr3194130lfp.41.1630600540703;
 Thu, 02 Sep 2021 09:35:40 -0700 (PDT)
MIME-Version: 1.0
References: <YTDW+b3x+5yMYVK0@miu.piliscsaba.redhat.com>
In-Reply-To: <YTDW+b3x+5yMYVK0@miu.piliscsaba.redhat.com>
From:   Linus Torvalds <torvalds@linux-foundation.org>
Date:   Thu, 2 Sep 2021 09:35:24 -0700
X-Gmail-Original-Message-ID: <CAHk-=wiiYSSpmgLRaq+AXg5NjCh_02ShSXRxsa8CfoKa0OooEQ@mail.gmail.com>
Message-ID: <CAHk-=wiiYSSpmgLRaq+AXg5NjCh_02ShSXRxsa8CfoKa0OooEQ@mail.gmail.com>
Subject: Re: [GIT PULL] overlayfs update for 5.15
To:     Miklos Szeredi <miklos@szeredi.hu>,
        Al Viro <viro@zeniv.linux.org.uk>
Cc:     Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>,
        linux-unionfs@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-unionfs.vger.kernel.org>
X-Mailing-List: linux-unionfs@vger.kernel.org

On Thu, Sep 2, 2021 at 6:51 AM Miklos Szeredi <miklos@szeredi.hu> wrote:
>
> The reason this touches so many files is that the ->get_acl() method now
> gets a "bool rcu" argument.  The ->get_acl() API was updated based on
> comments from Al and Linus:
>
>   https://lore.kernel.org/linux-fsdevel/CAJfpeguQxpd6Wgc0Jd3ks77zcsAv_bn0q17L3VNnnmPKu11t8A@mail.gmail.com/

That link might have been good in the individual commit message too,
but I did it in the merge commit instead.

I did notice that we now have a stale comment about ->get_acl() in fs/namei.c:

                acl = get_cached_acl_rcu(inode, ACL_TYPE_ACCESS);
                if (!acl)
                        return -EAGAIN;
                /* no ->get_acl() calls in RCU mode... */
                if (is_uncached_acl(acl))
                        return -ECHILD;

but we actually did the RCU-mode ->get_acl() call already in
get_cached_acl_rcu().

Of course, get_cached_acl_rcu() only does it for ACL_DONT_CACHE, not
for ACL_NOT_CACHED, so RCU mode is still a bit special.

At some point we probably should make get_cached_acl_rcu() do the
right thing for a successful lookup with ACL_NOT_CACHED set too, and
actually install the newly looked-up ACL. But I haven't thought much
about locking (but I think it would be ok, we use "cmpxchg" to update
the cached entry).

This is just a "maybe fixme for the future" note about that comment
and about get_cached_acl_rcu() behavior. I've pulled this, and I think
we're ok, it's just a small oddity.

                  Linus
