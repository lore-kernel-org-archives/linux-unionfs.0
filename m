Return-Path: <linux-unionfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.5 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D2F2CC4338F
	for <linux-unionfs@archiver.kernel.org>; Wed, 18 Aug 2021 18:53:22 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id A5075610FA
	for <linux-unionfs@archiver.kernel.org>; Wed, 18 Aug 2021 18:53:22 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232676AbhHRSx4 (ORCPT
        <rfc822;linux-unionfs@archiver.kernel.org>);
        Wed, 18 Aug 2021 14:53:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55674 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229965AbhHRSxz (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Wed, 18 Aug 2021 14:53:55 -0400
Received: from mail-ua1-x933.google.com (mail-ua1-x933.google.com [IPv6:2607:f8b0:4864:20::933])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9FB44C061764
        for <linux-unionfs@vger.kernel.org>; Wed, 18 Aug 2021 11:53:20 -0700 (PDT)
Received: by mail-ua1-x933.google.com with SMTP id a4so1408867uae.6
        for <linux-unionfs@vger.kernel.org>; Wed, 18 Aug 2021 11:53:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=szeredi.hu; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=VVLIclKpwLs/EllaJbXfDnAEhIbk0tUG6YwA3fwwsCM=;
        b=VjlI5vzQcP68jcedrwYoawmC/G17u6wAsVnk2VtuJccgIigT3lKCeDhz2qPLg4HV8i
         sFM1WZNVUbOUTdV9g/SYBPp6518FCH7aaj4RxhvJs0KRHb8kRR8F952Ls1EKsBhMOR7r
         vjO308Z+rRostL8ZJjuA23xq8hm4Oi5M9W6uo=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=VVLIclKpwLs/EllaJbXfDnAEhIbk0tUG6YwA3fwwsCM=;
        b=py7n2s4Cy6cTr5vaiMf9zoKEg/naR0/Ak+PW6RFelMf/pUG63UQehvIxWAd+GoKsuo
         eUBqnXuNluVfgRbwgtZMxVw1IgRDQwesKArAa6GLdsy+aHsmQTM0Ejz+91mEvuxRhju4
         txWiOBwd8mv3uXxgzzBYuI5lYe5ib+6PoneG7Be++/2v6InbQQXP/l/MCX+dHUMYjv2h
         7zP0LCN91oT/9GPsvET8tvZK/PT6qLOcGV+hK3x4SJGLsmjbn9jnUOkfjLjumI0zNddk
         hh8wmTBCheSoKK+Qe5MbDvbnFhIgeuuMq/NvFe6rml5BU0l8X6vLWs0hZPLH8+Yg4QWE
         yZqA==
X-Gm-Message-State: AOAM531e4fldslL7Z51rxU1ms2lkgB7vbxAJhaRxt8S2KaPGZ1eDhzR4
        K7ACXdz2kFMB0JG4zqA+veP/f5eOCKNLlpbtaIM3hQ==
X-Google-Smtp-Source: ABdhPJw9qBXplks3neJYHjam2XpKpKF9oCj3I1kKEha/Gcfljy/ZP8Wqa52TxoXoGqXRYSN+XnIRi+y/yNKBN2gEN5A=
X-Received: by 2002:ab0:3a8f:: with SMTP id r15mr8238862uaw.13.1629312799709;
 Wed, 18 Aug 2021 11:53:19 -0700 (PDT)
MIME-Version: 1.0
References: <20210818133400.830078-1-mszeredi@redhat.com> <20210818133400.830078-3-mszeredi@redhat.com>
 <CAHk-=wga+3G+mR-UyQ=pwqN2iS04k-O61bssvzyVk+vkdZkd1Q@mail.gmail.com>
In-Reply-To: <CAHk-=wga+3G+mR-UyQ=pwqN2iS04k-O61bssvzyVk+vkdZkd1Q@mail.gmail.com>
From:   Miklos Szeredi <miklos@szeredi.hu>
Date:   Wed, 18 Aug 2021 20:53:08 +0200
Message-ID: <CAJfpeguQxpd6Wgc0Jd3ks77zcsAv_bn0q17L3VNnnmPKu11t8A@mail.gmail.com>
Subject: Re: [PATCH v2 2/2] ovl: enable RCU'd ->get_acl()
To:     Linus Torvalds <torvalds@linux-foundation.org>
Cc:     Miklos Szeredi <mszeredi@redhat.com>,
        Al Viro <viro@zeniv.linux.org.uk>,
        overlayfs <linux-unionfs@vger.kernel.org>,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Andreas Gruenbacher <agruenba@redhat.com>,
        garyhuang <zjh.20052005@163.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-unionfs.vger.kernel.org>
X-Mailing-List: linux-unionfs@vger.kernel.org

On Wed, 18 Aug 2021 at 20:34, Linus Torvalds
<torvalds@linux-foundation.org> wrote:
>
> On Wed, Aug 18, 2021 at 6:34 AM Miklos Szeredi <mszeredi@redhat.com> wrote:
> >
> >  struct posix_acl *get_cached_acl_rcu(struct inode *inode, int type)
> >  {
> > -       return rcu_dereference(*acl_by_type(inode, type));
> > +       struct posix_acl *acl = rcu_dereference(*acl_by_type(inode, type));
> > +
> > +       if (acl == ACL_DONT_CACHE)
> > +               acl = inode->i_op->get_acl(inode, type, LOOKUP_RCU);
> > +
> > +       return acl;
> >  }
>
> What? No.
>
> You just made get_cached_acl_rcu() return ERR_PTR(-EINVAL) for most filesystems.
>
> So now you've changed the behavior of get_cached_acl_rcu() ENTIRELY.
>
> It used to return either
>  (a) the ACL
>  (b) NULL
>  (c) ACL_DONT_CACHE/ACL_NOT_CACHED
>
> but now you've changed that (c) case to "ACL_NOT_CACHED or random error value".
>
> You can't just mix these kinds of entirely different return values like that.
>
> So no, this is not at all acceptable.
>
> I would suggest:
>
>  (a) make the first patch actually test explicitly for LOOKUP_RCU, so
> that it's clear to the filesystems what is going on.
>
>      So instead of that pattern of
>
>         if (flags)
>                 return ERR_PTR(-EINVAL);
>
>      I'd suggest using
>
>         if (flags & LOOKUP_RCU)
>                 return ERR_PTR(-ECHILD);

Okay.

>
>    so that it actually matches what lookup does for the "I can't do
> this under RCU", and so that any reader of the code understands what
> "flags" is all about.
>
> And then
>
>  (b) make the get_cached_acl_rcu() case handle errors _properly_
> instead of mixing the special ACL cache markers with error returns.
>
>      So instead of
>
>         if (acl == ACL_DONT_CACHE)
>                 acl = inode->i_op->get_acl(inode, type, LOOKUP_RCU);
>
>      maybe something more along the lines of
>
>         if (acl == ACL_DONT_CACHE) {
>                 struct posix_acl *lookup_acl;
>                 lookup_acl = inode->i_op->get_acl(inode, type, LOOKUP_RCU);
>                 if (!IS_ERR(lookup_acl))
>                         acl = lookup_acl;
>         }
>
>      or whatever.

Yes, that's better.   Just to explain why my version was not actually
buggy:  ACL_DONT_CACHE is only used in overlayfs and not in any other
filesystem, so ->get_acl(... LOOKUP_RCU) not returning an error was
implicit in the implementation.   But your version makes that error
handling explicit, which is definitely an improvement.

>
> I disagree with Al that a "bool" would be better. I think LOOKUP_RCU
> is good documentation, and consistent with lookup, but it really needs
> to be *consistent*.  Thus that
>
>         if (flags & LOOKUP_RCU)
>                 return ERR_PTR(-ECHILD);
>
> pattern, not some "test underscibed flags, return -EINVAL" pattern
> that looks entirely nonsensical.

Al suggested:

 if (rcu)
   return ERR_PTR(-ECHILD);

which is also good documentation.  It also makes sure that "flags" is
not overloaded with other functionality (which was the reason for the
defensive "if any flag set return error" pattern).

Thanks,
Miklos
