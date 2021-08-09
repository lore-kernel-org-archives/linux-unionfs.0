Return-Path: <linux-unionfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A8AFBC4338F
	for <linux-unionfs@archiver.kernel.org>; Mon,  9 Aug 2021 21:25:37 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 821BB60EB9
	for <linux-unionfs@archiver.kernel.org>; Mon,  9 Aug 2021 21:25:37 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234572AbhHIVZ5 (ORCPT
        <rfc822;linux-unionfs@archiver.kernel.org>);
        Mon, 9 Aug 2021 17:25:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56292 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232793AbhHIVZ5 (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Mon, 9 Aug 2021 17:25:57 -0400
Received: from mail-lj1-x229.google.com (mail-lj1-x229.google.com [IPv6:2a00:1450:4864:20::229])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 34F70C061796
        for <linux-unionfs@vger.kernel.org>; Mon,  9 Aug 2021 14:25:36 -0700 (PDT)
Received: by mail-lj1-x229.google.com with SMTP id u13so25677813lje.5
        for <linux-unionfs@vger.kernel.org>; Mon, 09 Aug 2021 14:25:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linux-foundation.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=GciiGnwukZUcZuMgRkuX2+Oq98OfQGEGL0PbIUMdbwY=;
        b=DkW8bjkdCbaSSZSwXUD4dP7zGs+heKPA+Oy5FoJ3PhXwaSYav89OxOAcJNbCZqAFmL
         0h1nLAi6SdzNhvMaS1Nzft4JS4BHDBbOx4s0vutZIhoGZgzoNkz1aA+MU8kA1xMDmbqc
         PFME9G1HDX5AzRGqzhBS/Ml77jddOYE1oapDY=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=GciiGnwukZUcZuMgRkuX2+Oq98OfQGEGL0PbIUMdbwY=;
        b=fCp60PO1RDp+ug6wKkXry6CfP3KPWYWsWFH1aRCL2nD40SF64St1EtQMH/u4MKagmp
         2vSjJOEsUj8+6+kwUqnX2XQKnpyap3rQiZnlaD+IlH848I+2VWcO3bOQVdr8cpXEvoXI
         CGexKL3yCVIGy/yT4E8H4aN4Vap66VWtj8xtscRd4OR98PAISu+OHDv11pu4qpnIVYw5
         ZHSNZyLBVBeTdovKEY+fDihDn6dC9v170JKvecpmp5MZD8lgKOK2QhiZhxMJB+Xi+cxg
         Xq06epl+fpOYuQ8rWmylQMkCtMi4QLh9NBj68fp+Dh+r5GRzw0cP7V8FGe7LjdbU7FUK
         m0lQ==
X-Gm-Message-State: AOAM531AnBGwVlzQ4nzcIMxL8B86HHEGLLthASo+U4h7ckECR1ZXx1fg
        rFVfHQ9lXtrBhtgw2n9L3Q7e3/lF9bs8wbzp
X-Google-Smtp-Source: ABdhPJzjbLBBf2myn+0j9niaTRuYcH0vQCBdNy09gy4uRGjwzDIeuQLXFZRE2RDBkiAf/daiIGjeZQ==
X-Received: by 2002:a05:651c:b10:: with SMTP id b16mr17405638ljr.35.1628544334371;
        Mon, 09 Aug 2021 14:25:34 -0700 (PDT)
Received: from mail-lj1-f169.google.com (mail-lj1-f169.google.com. [209.85.208.169])
        by smtp.gmail.com with ESMTPSA id h35sm1522936lfv.24.2021.08.09.14.25.33
        for <linux-unionfs@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 09 Aug 2021 14:25:34 -0700 (PDT)
Received: by mail-lj1-f169.google.com with SMTP id x9so23721755ljj.2
        for <linux-unionfs@vger.kernel.org>; Mon, 09 Aug 2021 14:25:33 -0700 (PDT)
X-Received: by 2002:a2e:b703:: with SMTP id j3mr7222089ljo.220.1628544333584;
 Mon, 09 Aug 2021 14:25:33 -0700 (PDT)
MIME-Version: 1.0
References: <YRFfGk5lHL0W27oU@miu.piliscsaba.redhat.com>
In-Reply-To: <YRFfGk5lHL0W27oU@miu.piliscsaba.redhat.com>
From:   Linus Torvalds <torvalds@linux-foundation.org>
Date:   Mon, 9 Aug 2021 14:25:17 -0700
X-Gmail-Original-Message-ID: <CAHk-=wigKQqEqt9ev_1k5b_DwFGp7JmCdCR1xFSJjOyisEJ61A@mail.gmail.com>
Message-ID: <CAHk-=wigKQqEqt9ev_1k5b_DwFGp7JmCdCR1xFSJjOyisEJ61A@mail.gmail.com>
Subject: Re: [GIT PULL] overlayfs fixes for 5.14-rc6
To:     Miklos Szeredi <miklos@szeredi.hu>
Cc:     Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>,
        linux-unionfs@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-unionfs.vger.kernel.org>
X-Mailing-List: linux-unionfs@vger.kernel.org

On Mon, Aug 9, 2021 at 10:00 AM Miklos Szeredi <miklos@szeredi.hu> wrote:
>
>       ovl: fix mmap denywrite

Ugh. Th edances with denywrite and mapping_unmap_writable are really
really annoying.

I've pulled this, but I really get the feeling that there's duplicated
code for these things, and that all the "if error goto" cases  (some
old, some new) are really really uglky.

I get the feeling that the whole thing with deny_write_access and
mapping_map_writable could possibly be done after-the-fact somehow as
part of actually inserting the vma in the vma tree, rather than done
as the vma is prepared.

And most users of vma_set_file() probably really don't want that whole
thing at all (ie the DRM stuff that just switches out a local thing.
They also don't check for the new error cases you've added.

So I really think this is quite questionable, and those cases should
probably have been done entirely inside ovlfs rather than polluting
the cases that don't care and don't check.

                 Linus
