Return-Path: <SRS0=WKmv=74=vger.kernel.org=linux-unionfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.6 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 35AD9C433E3
	for <linux-unionfs@archiver.kernel.org>; Mon, 15 Jun 2020 07:53:52 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 0DD3E2067B
	for <linux-unionfs@archiver.kernel.org>; Mon, 15 Jun 2020 07:53:52 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=szeredi.hu header.i=@szeredi.hu header.b="HhueOiVc"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728694AbgFOHxs (ORCPT
        <rfc822;linux-unionfs@archiver.kernel.org>);
        Mon, 15 Jun 2020 03:53:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33204 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728689AbgFOHxr (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Mon, 15 Jun 2020 03:53:47 -0400
Received: from mail-ej1-x643.google.com (mail-ej1-x643.google.com [IPv6:2a00:1450:4864:20::643])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6CA4DC05BD1E
        for <linux-unionfs@vger.kernel.org>; Mon, 15 Jun 2020 00:53:47 -0700 (PDT)
Received: by mail-ej1-x643.google.com with SMTP id q19so16345148eja.7
        for <linux-unionfs@vger.kernel.org>; Mon, 15 Jun 2020 00:53:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=szeredi.hu; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=qply8dKLeFaH4C6xkbOwjlmAeElLYwIxkvYjz4HgFmM=;
        b=HhueOiVcGkaWE4SAMi1on9IbXgdNyb2uhfyf8/Aj9U8ZGUCv/Mi3CZ/HwGvqViJDVf
         S0+D+lmd8efd1yaOoHKUvW0UZqI+mw6hMBbi9slDfrwYO1/c79JN+b4hAlmxLpSpC7Os
         J0aIRDN/JdU3/EuHpQ2pAinRIvOP6ifWBQG0I=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=qply8dKLeFaH4C6xkbOwjlmAeElLYwIxkvYjz4HgFmM=;
        b=mkKkudO56XexFmnz806YO8H4cZzQV2zaifxQc/Y6W6F+k+fxWIsIzeVISFoMKBUgo1
         0z2a8H8/chl3cM4Ckcm/ptMnr2UKYsojWI4bT5vPaj8cZolo7SItMuXq3qHrWFBoh+OM
         QGrX1DNWuAmqXxMBSHbmX+AFrz//UXL2/mHOd27iDOubbJIXnR7wuuCx2NY835Eir5BS
         wIqAZFQkaWWFwf4uR9Rag41+Z9u6W4zLhTOy0tIg0JzABdKNuZYo89hb5FS4ken73CCJ
         YlGOKLqgX6UffzgafHpstrzy3BxJYbMPkLF7QXqnJW5VheYEa8gIWWjSpuy9EMjp+Bfo
         1LKg==
X-Gm-Message-State: AOAM531ZoQuUjfSpPRygxfNoBTNKFDPUJN3U+k+5ZkED5pFj6ab+UX1w
        0xloTu4ZHDlzILndFihMf/uL7FUlVwlp2LtyDUFH3w==
X-Google-Smtp-Source: ABdhPJzeY6pLBqIqCEq52de509qkwa6bP+P+AW5dk2d1DDvZM/diV9S57KakTHTc8rIWoXqTu9x8Au1BPpStS70hhNI=
X-Received: by 2002:a17:906:31d2:: with SMTP id f18mr23974716ejf.110.1592207625916;
 Mon, 15 Jun 2020 00:53:45 -0700 (PDT)
MIME-Version: 1.0
References: <20200612004644.255692-1-mike.kravetz@oracle.com>
 <20200612015842.GC23230@ZenIV.linux.org.uk> <b1756da5-4e91-298f-32f1-e5642a680cbf@oracle.com>
 <CAOQ4uxg=o2SVbfUiz0nOg-XHG8irvAsnXzFWjExjubk2v_6c_A@mail.gmail.com> <6e8924b0-bfc4-eaf5-1775-54f506cdf623@oracle.com>
In-Reply-To: <6e8924b0-bfc4-eaf5-1775-54f506cdf623@oracle.com>
From:   Miklos Szeredi <miklos@szeredi.hu>
Date:   Mon, 15 Jun 2020 09:53:35 +0200
Message-ID: <CAJfpegsugobr8LnJ7e3D1+QFHCdYkW1swtSZ_hKouf_uhZreMg@mail.gmail.com>
Subject: Re: [PATCH v4 1/2] hugetlb: use f_mode & FMODE_HUGETLBFS to identify
 hugetlbfs files
To:     Mike Kravetz <mike.kravetz@oracle.com>
Cc:     Amir Goldstein <amir73il@gmail.com>,
        Al Viro <viro@zeniv.linux.org.uk>,
        Linux MM <linux-mm@kvack.org>,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>,
        overlayfs <linux-unionfs@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Matthew Wilcox <willy@infradead.org>,
        Colin Walters <walters@verbum.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        syzbot <syzbot+d6ec23007e951dadf3de@syzkaller.appspotmail.com>,
        syzkaller-bugs <syzkaller-bugs@googlegroups.com>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-unionfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-unionfs.vger.kernel.org>
X-Mailing-List: linux-unionfs@vger.kernel.org

On Sat, Jun 13, 2020 at 9:12 PM Mike Kravetz <mike.kravetz@oracle.com> wrote:
>
> On 6/12/20 11:53 PM, Amir Goldstein wrote:

> As a hugetlbfs developer, I do not know of a use case for interoperability
> with overlayfs.  So yes, I am not too interested in making them work well
> together.  However, if there was an actual use case I would be more than
> happy to consider doing the work.  Just hate to put effort into fixing up
> two 'special' filesystems for functionality that may not be used.
>
> I can't speak for overlayfs developers.

As I said, I only know of tmpfs being upper layer as a valid use case.
   Does that work with hugepages?  How would I go about testing that?

> > I agree with Colin's remark about adding limitations, but it would be a shame
> > if overlay had to special case hugetlbfs. It would have been better if we could
> > find a property of hugetlbfs that makes it inapplicable for overlayfs
> > upper/lower
> > or stacking fs in general.
> >
> > The simplest thing for you to do in order to shush syzbot is what procfs does:
> >         /*
> >          * procfs isn't actually a stacking filesystem; however, there is
> >          * too much magic going on inside it to permit stacking things on
> >          * top of it
> >          */
> >         s->s_stack_depth = FILESYSTEM_MAX_STACK_DEPTH;
> >
> > Currently, the only in-tree stacking fs are overlayfs and ecryptfs, but there
> > are some out of tree implementations as well (shiftfs).
> > So you may only take that option if you do not care about the combination
> > of hugetlbfs with any of the above.
> >
> > overlayfs support of mmap is not as good as one might hope.
> > overlayfs.rst says:
> > "If a file residing on a lower layer is opened for read-only and then
> >  memory mapped with MAP_SHARED, then subsequent changes to
> >  the file are not reflected in the memory mapping."
> >
> > So if I were you, I wouldn't go trying to fix overlayfs-huguetlb interop...
>
> Thanks again,
>
> I'll look at something as simple as s_stack_depth.

Agree.

Thanks,
Miklos
