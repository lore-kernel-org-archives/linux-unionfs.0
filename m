Return-Path: <SRS0=WKmv=74=vger.kernel.org=linux-unionfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.6 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B4CDDC433E0
	for <linux-unionfs@archiver.kernel.org>; Mon, 15 Jun 2020 08:24:56 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 914442053B
	for <linux-unionfs@archiver.kernel.org>; Mon, 15 Jun 2020 08:24:56 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=szeredi.hu header.i=@szeredi.hu header.b="Uy4iXrsd"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728428AbgFOIY4 (ORCPT
        <rfc822;linux-unionfs@archiver.kernel.org>);
        Mon, 15 Jun 2020 04:24:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38002 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728180AbgFOIY4 (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Mon, 15 Jun 2020 04:24:56 -0400
Received: from mail-ed1-x544.google.com (mail-ed1-x544.google.com [IPv6:2a00:1450:4864:20::544])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5244BC061A0E
        for <linux-unionfs@vger.kernel.org>; Mon, 15 Jun 2020 01:24:55 -0700 (PDT)
Received: by mail-ed1-x544.google.com with SMTP id t21so10818861edr.12
        for <linux-unionfs@vger.kernel.org>; Mon, 15 Jun 2020 01:24:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=szeredi.hu; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=ZhrHsoF+IuuCWsNYTt36CnOUPKOXLNanHzXXw538ijY=;
        b=Uy4iXrsdKb9Jk+JDiX/Chl9qMKx9QpugSWS5NkriaPMVcmD97vURwhir28xYpfpmqh
         SPDMoEWcuI4fT1IewSfOaVTFRjIgC0ZgI+aTtHVa8Bt1v7S6TEeRQHOUatH5LzhwpGJ+
         6YojzNXVz6UCsvtK15ZaCT6yZnZ3E7q4SDk9Y=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=ZhrHsoF+IuuCWsNYTt36CnOUPKOXLNanHzXXw538ijY=;
        b=ESkMxv/AYKxt3ng0l89Wde29vlZJCkxoPzpf6zClVSP46rzRJsaidc4FbucYeCZ6JQ
         427Fzykrshvahd29KzlVE3XpugGi7gETqTROgCjM3B2lJTa6l6TWxxG8PnGzzsONPXEp
         fVXa0pMvMcQOZTTSnTwoZgJr1zanL7sqbb71dHlLWYkvFTy4D075ypcgC2+tpz4IBqhk
         ZtYnU6gmRPd9qba0R7Q9CRoLkG5cGCfDP9LbHa35WgWzN71RL+62bnAcNaheHuNm7JzO
         7JZnyUD/P3AV7rMQXqnYVJ5CFw/GIW1KMgUuNbRC5L3b1DlTd0g7S5JLwLBAfiXi7GeO
         Dpzg==
X-Gm-Message-State: AOAM532pyrK60sVycOijn9h+Czd708lmS/J0dbgCqQcmlf+KyT02nFVK
        orDKPN/NjJ9ISe0gBgDd+2/TJJLJpFzWNHrpI4mIYA==
X-Google-Smtp-Source: ABdhPJyTYfl7L17Ro5jQwnBv2wTKOxjN4zvQSKG7SGBI4x6Y1v+nhySmXXUUI9zXVpw1KDpsuc+QcQbm++UqGImgmT8=
X-Received: by 2002:a50:d785:: with SMTP id w5mr22156433edi.212.1592209493931;
 Mon, 15 Jun 2020 01:24:53 -0700 (PDT)
MIME-Version: 1.0
References: <20200612004644.255692-1-mike.kravetz@oracle.com>
 <20200612015842.GC23230@ZenIV.linux.org.uk> <b1756da5-4e91-298f-32f1-e5642a680cbf@oracle.com>
 <CAOQ4uxg=o2SVbfUiz0nOg-XHG8irvAsnXzFWjExjubk2v_6c_A@mail.gmail.com>
In-Reply-To: <CAOQ4uxg=o2SVbfUiz0nOg-XHG8irvAsnXzFWjExjubk2v_6c_A@mail.gmail.com>
From:   Miklos Szeredi <miklos@szeredi.hu>
Date:   Mon, 15 Jun 2020 10:24:42 +0200
Message-ID: <CAJfpegv28Z2aECcb+Yfqum54zfwV=k1G1n_o3o6O-QTWOy3T4Q@mail.gmail.com>
Subject: Re: [PATCH v4 1/2] hugetlb: use f_mode & FMODE_HUGETLBFS to identify
 hugetlbfs files
To:     Amir Goldstein <amir73il@gmail.com>
Cc:     Mike Kravetz <mike.kravetz@oracle.com>,
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

On Sat, Jun 13, 2020 at 8:53 AM Amir Goldstein <amir73il@gmail.com> wrote:

> > I also looked at normal filesystem lower and hugetlbfs upper.  Yes, overlayfs
> > allows this.  This is somewhat 'interesting' as write() is not supported in
> > hugetlbfs.  Writing to files in the overlay actually ended up writing to
> > files in the lower filesystem.  That seems wrong, but overlayfs is new to me.

Yes, this very definitely should not happen.

> I am not sure how that happened, but I think that ovl_open_realfile()
> needs to fixup f_mode flags FMODE_CAN_WRITE | FMODE_CAN_READ
> after open_with_fake_path().

Okay, but how did the write actually get to the lower layer?

I failed to reproduce this.  Mike, how did you trigger this?

Thanks,
Miklos
