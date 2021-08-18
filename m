Return-Path: <linux-unionfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 471AEC4338F
	for <linux-unionfs@archiver.kernel.org>; Wed, 18 Aug 2021 18:34:51 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 2CB27610D2
	for <linux-unionfs@archiver.kernel.org>; Wed, 18 Aug 2021 18:34:51 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231838AbhHRSfZ (ORCPT
        <rfc822;linux-unionfs@archiver.kernel.org>);
        Wed, 18 Aug 2021 14:35:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51300 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229468AbhHRSfY (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Wed, 18 Aug 2021 14:35:24 -0400
Received: from mail-lj1-x232.google.com (mail-lj1-x232.google.com [IPv6:2a00:1450:4864:20::232])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BF47AC061764
        for <linux-unionfs@vger.kernel.org>; Wed, 18 Aug 2021 11:34:49 -0700 (PDT)
Received: by mail-lj1-x232.google.com with SMTP id x7so6746776ljn.10
        for <linux-unionfs@vger.kernel.org>; Wed, 18 Aug 2021 11:34:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linux-foundation.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=9FPUr4CdEhH6rDlKsFJKVG6weGYB4goKDrrriPqlf4c=;
        b=UsJzOywq2ROkYLqA5CcdCp3s5r6bZjUJracBOkcBXm8YR8CmgShinAl0dyjPNTwbbT
         pLDb2UCOiSdPY/cvSTX1YknA8EFSxroQjJnPWKbt2h+fImZ4nOwlqkbqm72M2M6EuU9i
         yzeg9mXqlr6a1MUg4Os42/IodELJ+RDIOnnH8=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=9FPUr4CdEhH6rDlKsFJKVG6weGYB4goKDrrriPqlf4c=;
        b=QoMIERCdKgpHPt1u2giC9GKF3DGs6fHrsXuYmdClrZ1pmkfA52Au8y0/onh9nbcz0e
         kxpNZhyFVlcNMkTe/uk5ot+V69cgwz6FPRXmVL2iFTq5sXYJPEMSQD/cuPZHh+v7W43k
         +MWoVBZLJQnLnyG5Tu1ZSvIfkA5p3anuqm7xrsmGQbP0D0nQW91mn7QKCdn6A++YZ4wq
         eDmnVj5HKRMmJA84wRhlWZ+kyO3OGoyET/C1fiV8r9USxQJApc7HyDLzucs9SEyU+3Es
         Cbjsl3HYP409BQGVzXhU/gN2n5O8I9ibW7AyQENSqSLrGtmeT+MwbfSgsNyPW/C6DT4u
         iD/A==
X-Gm-Message-State: AOAM530CwRGWlywPy7XHjBoXJ0UxwsbQSrsRjLT0nGJ74b1dmFoca6F/
        9KeOPfwnFLdFvZd2R2NGJy6mRFO5GTyMRP6X
X-Google-Smtp-Source: ABdhPJz2lCNPeTGvGQbKXTlFxq6XlvSFfdCWk810KcIi5KNn/bTreAfrBgEcoZUozwVnb5fjalsw6A==
X-Received: by 2002:a2e:bd09:: with SMTP id n9mr9193938ljq.76.1629311688028;
        Wed, 18 Aug 2021 11:34:48 -0700 (PDT)
Received: from mail-lj1-f179.google.com (mail-lj1-f179.google.com. [209.85.208.179])
        by smtp.gmail.com with ESMTPSA id a22sm41245lfl.259.2021.08.18.11.34.47
        for <linux-unionfs@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 18 Aug 2021 11:34:47 -0700 (PDT)
Received: by mail-lj1-f179.google.com with SMTP id i28so6803664ljm.7
        for <linux-unionfs@vger.kernel.org>; Wed, 18 Aug 2021 11:34:47 -0700 (PDT)
X-Received: by 2002:a2e:944c:: with SMTP id o12mr8897833ljh.411.1629311686896;
 Wed, 18 Aug 2021 11:34:46 -0700 (PDT)
MIME-Version: 1.0
References: <20210818133400.830078-1-mszeredi@redhat.com> <20210818133400.830078-3-mszeredi@redhat.com>
In-Reply-To: <20210818133400.830078-3-mszeredi@redhat.com>
From:   Linus Torvalds <torvalds@linux-foundation.org>
Date:   Wed, 18 Aug 2021 11:34:31 -0700
X-Gmail-Original-Message-ID: <CAHk-=wga+3G+mR-UyQ=pwqN2iS04k-O61bssvzyVk+vkdZkd1Q@mail.gmail.com>
Message-ID: <CAHk-=wga+3G+mR-UyQ=pwqN2iS04k-O61bssvzyVk+vkdZkd1Q@mail.gmail.com>
Subject: Re: [PATCH v2 2/2] ovl: enable RCU'd ->get_acl()
To:     Miklos Szeredi <mszeredi@redhat.com>
Cc:     Al Viro <viro@zeniv.linux.org.uk>, linux-unionfs@vger.kernel.org,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Andreas Gruenbacher <agruenba@redhat.com>,
        garyhuang <zjh.20052005@163.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-unionfs.vger.kernel.org>
X-Mailing-List: linux-unionfs@vger.kernel.org

On Wed, Aug 18, 2021 at 6:34 AM Miklos Szeredi <mszeredi@redhat.com> wrote:
>
>  struct posix_acl *get_cached_acl_rcu(struct inode *inode, int type)
>  {
> -       return rcu_dereference(*acl_by_type(inode, type));
> +       struct posix_acl *acl = rcu_dereference(*acl_by_type(inode, type));
> +
> +       if (acl == ACL_DONT_CACHE)
> +               acl = inode->i_op->get_acl(inode, type, LOOKUP_RCU);
> +
> +       return acl;
>  }

What? No.

You just made get_cached_acl_rcu() return ERR_PTR(-EINVAL) for most filesystems.

So now you've changed the behavior of get_cached_acl_rcu() ENTIRELY.

It used to return either
 (a) the ACL
 (b) NULL
 (c) ACL_DONT_CACHE/ACL_NOT_CACHED

but now you've changed that (c) case to "ACL_NOT_CACHED or random error value".

You can't just mix these kinds of entirely different return values like that.

So no, this is not at all acceptable.

I would suggest:

 (a) make the first patch actually test explicitly for LOOKUP_RCU, so
that it's clear to the filesystems what is going on.

     So instead of that pattern of

        if (flags)
                return ERR_PTR(-EINVAL);

     I'd suggest using

        if (flags & LOOKUP_RCU)
                return ERR_PTR(-ECHILD);

   so that it actually matches what lookup does for the "I can't do
this under RCU", and so that any reader of the code understands what
"flags" is all about.

And then

 (b) make the get_cached_acl_rcu() case handle errors _properly_
instead of mixing the special ACL cache markers with error returns.

     So instead of

        if (acl == ACL_DONT_CACHE)
                acl = inode->i_op->get_acl(inode, type, LOOKUP_RCU);

     maybe something more along the lines of

        if (acl == ACL_DONT_CACHE) {
                struct posix_acl *lookup_acl;
                lookup_acl = inode->i_op->get_acl(inode, type, LOOKUP_RCU);
                if (!IS_ERR(lookup_acl))
                        acl = lookup_acl;
        }

     or whatever.

I disagree with Al that a "bool" would be better. I think LOOKUP_RCU
is good documentation, and consistent with lookup, but it really needs
to be *consistent*.  Thus that

        if (flags & LOOKUP_RCU)
                return ERR_PTR(-ECHILD);

pattern, not some "test underscibed flags, return -EINVAL" pattern
that looks entirely nonsensical.

               Linus
