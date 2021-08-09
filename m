Return-Path: <linux-unionfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5CD56C4338F
	for <linux-unionfs@archiver.kernel.org>; Mon,  9 Aug 2021 22:34:28 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 3E98660E76
	for <linux-unionfs@archiver.kernel.org>; Mon,  9 Aug 2021 22:34:28 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232861AbhHIWer (ORCPT
        <rfc822;linux-unionfs@archiver.kernel.org>);
        Mon, 9 Aug 2021 18:34:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43522 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230085AbhHIWer (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Mon, 9 Aug 2021 18:34:47 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7A4A6C0613D3;
        Mon,  9 Aug 2021 15:34:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=KTtc/cvMulc1INMc4c7GIJVcioXgpCwan62UGzeNg8c=; b=twaqeqLpMxeAacqIw1RkFNHjDm
        u55azO4PdS9+2SjvVIrX3P4pICyXE3DOK0AAkWRi2NvD07EJljVIWFtKQUzfgLFR552eBCBTfXjRb
        b/SJ6DDwpzXO8+kQ3WCB6AulAVN/iIJCyIY1tFA6xW611CLm5yXLr5OdXYhUd7iTwfMUp2TrR0WgH
        er6HoX2cvJ57ANc9QUHkc3WsPRVsoSsGI/mOBExuz72ev2TyCKTKflORqzkUE3CONDkHIxpYeEKmo
        j/1hRbVBXpOfns1k19RRzQCwqS3PZgtbVE5sXB0BmaxIKIA9hFBNRNJ09EGT6xNC8VClLm40ePWJX
        hWE8dYww==;
Received: from willy by casper.infradead.org with local (Exim 4.94.2 #2 (Red Hat Linux))
        id 1mDDpH-00BUGA-F9; Mon, 09 Aug 2021 22:33:13 +0000
Date:   Mon, 9 Aug 2021 23:32:55 +0100
From:   Matthew Wilcox <willy@infradead.org>
To:     Linus Torvalds <torvalds@linux-foundation.org>
Cc:     Miklos Szeredi <miklos@szeredi.hu>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>,
        linux-unionfs@vger.kernel.org
Subject: Re: [GIT PULL] overlayfs fixes for 5.14-rc6
Message-ID: <YRGtF69Z8kjsaSkb@casper.infradead.org>
References: <YRFfGk5lHL0W27oU@miu.piliscsaba.redhat.com>
 <CAHk-=wigKQqEqt9ev_1k5b_DwFGp7JmCdCR1xFSJjOyisEJ61A@mail.gmail.com>
 <CAHk-=wjhm9CV+sLiA9wWUJS2mQ1ZUcbr1B_jm7Wv8fJdGJbVYA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAHk-=wjhm9CV+sLiA9wWUJS2mQ1ZUcbr1B_jm7Wv8fJdGJbVYA@mail.gmail.com>
Precedence: bulk
List-ID: <linux-unionfs.vger.kernel.org>
X-Mailing-List: linux-unionfs@vger.kernel.org

On Mon, Aug 09, 2021 at 02:26:55PM -0700, Linus Torvalds wrote:
> On Mon, Aug 9, 2021 at 2:25 PM Linus Torvalds
> <torvalds@linux-foundation.org> wrote:
> >
> > I've pulled this,
> 
> Actually, I take that back.
> 
> None of those things have been in linux-next either, and considering
> my worries about it, I want to see more actual testing of this.

Not only that, the changes to fs/namespace.c and mm/util.c haven't been
posted to linux-mm or linux-fsdevel, as far as I can tell.
