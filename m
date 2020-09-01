Return-Path: <SRS0=Ys2z=CK=vger.kernel.org=linux-unionfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BB958C433E7
	for <linux-unionfs@archiver.kernel.org>; Tue,  1 Sep 2020 07:45:11 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 770B0208DB
	for <linux-unionfs@archiver.kernel.org>; Tue,  1 Sep 2020 07:45:11 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=szeredi.hu header.i=@szeredi.hu header.b="B29SfsAQ"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726140AbgIAHpL (ORCPT
        <rfc822;linux-unionfs@archiver.kernel.org>);
        Tue, 1 Sep 2020 03:45:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38802 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726050AbgIAHpK (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Tue, 1 Sep 2020 03:45:10 -0400
Received: from mail-ua1-x941.google.com (mail-ua1-x941.google.com [IPv6:2607:f8b0:4864:20::941])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 49756C061244
        for <linux-unionfs@vger.kernel.org>; Tue,  1 Sep 2020 00:45:09 -0700 (PDT)
Received: by mail-ua1-x941.google.com with SMTP id g11so138798ual.2
        for <linux-unionfs@vger.kernel.org>; Tue, 01 Sep 2020 00:45:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=szeredi.hu; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=3qQWrPjd+3tD5k74/h4nn6JbgY+asqimo3r0Ngu+psg=;
        b=B29SfsAQZZtD1+O9ml+4HmyYDPIUxcQ20/gonjENigHsMvM14mDH356np4XtIEg+o/
         KqY0Wexzya3EP+VCf+VszUx+g8lxV+qC4wAvPUxxnQ8KlGtcfZ3iRe02vd8fpC9lmoov
         IWDiNxOASUhmkzHOVPyaZtaCwTnBFRschNkkI=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=3qQWrPjd+3tD5k74/h4nn6JbgY+asqimo3r0Ngu+psg=;
        b=e/Lr/R4095Wr++fE1tb9BaxiFD28P/7HH5nd0bQev79XoZDggCOjlvktcaJQGuQUEc
         MYhi/mBxh7qOtA8MTCLlZy12E139x9iu8iA26aO/1UyjzYQmAMxF6Yl+czeGf9ga6q53
         wdljJiN/L/dONETiFwEgCUSLNxZ/aQUzJ9MJ74smV3TXXNVtxBMuwhEZ3/HTgd2nLnA7
         w+8vPu8lw95HoOFO5PaMOZhjqt+aBlQkEDWwcCIlqHwWrVQX259XhFGywtxyLdxkLyKl
         cc7fd7onSpEDnwuIJmzbIjuomTyDlLhmDMmSDn9xXURSgOHZJ5uRjplzxgMHH4l8WYm/
         zu9g==
X-Gm-Message-State: AOAM5337OPA+7/m0cPnr9iP/kYplUyUKWUtKl1IJDR6fS7ZSq0y3evmm
        PHTG4z8tVjczU6tYcWItegYzCNre+YDgFIRteqie9DXjpLKwFtse
X-Google-Smtp-Source: ABdhPJy+TdGpYqYf9MgROG/FQwWb9tyDw2oStkVxZTn7KESL0/FTPF1RWJcNaI1FlNO0iKCPaJAXhEZw+S8/8ZeOCCk=
X-Received: by 2002:ab0:4d54:: with SMTP id k20mr243579uag.142.1598946308191;
 Tue, 01 Sep 2020 00:45:08 -0700 (PDT)
MIME-Version: 1.0
References: <20200829095101.25350-1-cgxu519@mykernel.net> <20200829095101.25350-4-cgxu519@mykernel.net>
 <CAOQ4uxisdtoccDoQe_fYUA-jXTfy0yk=gNcMSrmbkCYaeOEPuQ@mail.gmail.com>
 <e1e2c8f0-a3b8-0a3d-3093-6188b1a829f0@mykernel.net> <CAOQ4uxgn5gKXdwjYjuUrt29uHi3cNVApTnODiW-kp-DkzKLVMw@mail.gmail.com>
In-Reply-To: <CAOQ4uxgn5gKXdwjYjuUrt29uHi3cNVApTnODiW-kp-DkzKLVMw@mail.gmail.com>
From:   Miklos Szeredi <miklos@szeredi.hu>
Date:   Tue, 1 Sep 2020 09:44:57 +0200
Message-ID: <CAJfpegtdQutkdaycd-s1ZAi5h9f9HgdVru44qJkL75_wnk+3Fg@mail.gmail.com>
Subject: Re: [RFC PATCH 3/3] ovl: implement stacked mmap for shared map
To:     Amir Goldstein <amir73il@gmail.com>
Cc:     cgxu <cgxu519@mykernel.net>,
        overlayfs <linux-unionfs@vger.kernel.org>,
        Linux MM <linux-mm@kvack.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Ritesh Harjani <riteshh@linux.ibm.com>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-unionfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-unionfs.vger.kernel.org>
X-Mailing-List: linux-unionfs@vger.kernel.org

On Mon, Aug 31, 2020 at 5:52 PM Amir Goldstein <amir73il@gmail.com> wrote:
>
> On Mon, Aug 31, 2020 at 4:47 PM cgxu <cgxu519@mykernel.net> wrote:
> >
> > On 8/30/20 7:33 PM, Amir Goldstein wrote:

> > > Interesting direction, not sure if this is workable.
> > > I don't know enough about mm to say.
> > >
> > > But what about the rest of the operations?
> > > Did you go over them and decide that overlay doesn't need to implement them?
> > > I doubt it, but if you did, please document that.
> >
> > I did some check for rest of them, IIUC ->fault will be enough for this
> > special case (shared read-only mmap with no upper), I will remove
> > ->page_mkwrite in v2.

Hmm, so this is just for that specific corner case?  Not a generic
shared mmap implementation?

>
> Ok I suppose you checked that ->map_pages is not relevant?
>
> >
> > # I do not consider support ->huge_fault in current stage due to many fs
> > cannot support DAX properly.
> >
> > BTW, do you know who should I add to CC list for further deep review of
> > this code? fadevel-list?
> >
>
> fsdevel would be good, but I would wait for initial feedback from Miklos
> before you post v2...

I could dig into the details of page fault handling, but that's not an
area that I'm intimately familiar with.    So yeah, a high level
description of what happens on mmap, page fault, write fault, etc...
would be really appreciated.

Thanks,
Miklos
