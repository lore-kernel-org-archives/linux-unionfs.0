Return-Path: <SRS0=WbPP=7Z=vger.kernel.org=linux-unionfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.5 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,
	SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id ACB3BC433E0
	for <linux-unionfs@archiver.kernel.org>; Fri, 12 Jun 2020 01:53:39 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 81B36206A4
	for <linux-unionfs@archiver.kernel.org>; Fri, 12 Jun 2020 01:53:39 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="PDm/mf4V"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726581AbgFLBxf (ORCPT
        <rfc822;linux-unionfs@archiver.kernel.org>);
        Thu, 11 Jun 2020 21:53:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52498 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726364AbgFLBxe (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Thu, 11 Jun 2020 21:53:34 -0400
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:e::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 778FFC03E96F;
        Thu, 11 Jun 2020 18:53:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=In-Reply-To:Content-Type:MIME-Version
        :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=cStLTJ8R6X6N3Wfmxkjdz1h2n4pTx9jO+4oGXH0Nk+U=; b=PDm/mf4V+mea+4FjDe9dRrySZm
        1PQV3PkeeQydNP0pEbEeydYpOY6TBnb2aN5XtKW36ybqCahPFDrhLIL5/oWZUkM5bRvsJ1Ifi/or5
        tRjIh2i9o8LjPat8GBLJCVjy+ZXRuXuVRQEApCSttRtSOkb4vn/HPp4qvsqxRlR/F3ecIywg7kqyF
        txNyAEzHkHeRDNdn8Cawq2zCu7aKl1akzpcC4Na5Hb1vFMhd8KYT2q3VT2KgEMFvntgbwR9njMPya
        6k4fa/2vy1OZL+dcZR1YbRQ3rh1E1XN5Kk8SCNfSQXHbHkyYsjANp/wFk115nRsi2VRZE7HG7iUEW
        bssQishg==;
Received: from willy by bombadil.infradead.org with local (Exim 4.92.3 #3 (Red Hat Linux))
        id 1jjYso-0006WI-Ve; Fri, 12 Jun 2020 01:53:26 +0000
Date:   Thu, 11 Jun 2020 18:53:26 -0700
From:   Matthew Wilcox <willy@infradead.org>
To:     Mike Kravetz <mike.kravetz@oracle.com>
Cc:     linux-mm@kvack.org, linux-fsdevel@vger.kernel.org,
        overlayfs <linux-unionfs@vger.kernel.org>,
        linux-kernel@vger.kernel.org, Al Viro <viro@zeniv.linux.org.uk>,
        Miklos Szeredi <miklos@szeredi.hu>,
        Colin Walters <walters@verbum.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        syzbot <syzbot+d6ec23007e951dadf3de@syzkaller.appspotmail.com>,
        syzkaller-bugs <syzkaller-bugs@googlegroups.com>
Subject: Re: [PATCH v4 1/2] hugetlb: use f_mode & FMODE_HUGETLBFS to identify
 hugetlbfs files
Message-ID: <20200612015326.GD8681@bombadil.infradead.org>
References: <20200612004644.255692-1-mike.kravetz@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200612004644.255692-1-mike.kravetz@oracle.com>
Sender: linux-unionfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-unionfs.vger.kernel.org>
X-Mailing-List: linux-unionfs@vger.kernel.org

On Thu, Jun 11, 2020 at 05:46:43PM -0700, Mike Kravetz wrote:
> The routine is_file_hugepages() checks f_op == hugetlbfs_file_operations
> to determine if the file resides in hugetlbfs.  This is problematic when
> the file is on a union or overlay.  Instead, define a new file mode
> FMODE_HUGETLBFS which is set when a hugetlbfs file is opened.  The mode
> can easily be copied to other 'files' derived from the original hugetlbfs
> file.
> 
> With this change hugetlbfs_file_operations can be static as it should be.
> 
> There is also a (duplicate) set of shm file operations used for the routine
> is_file_shm_hugepages().  Instead of setting/using special f_op's, just
> propagate the FMODE_HUGETLBFS mode.  This means is_file_shm_hugepages() and
> the duplicate f_ops can be removed.
> 
> While cleaning things up, change the name of is_file_hugepages() to
> is_file_hugetlbfs().  The term hugepages is a bit ambiguous.

I was going to have objections to this before I read it more carefully
and realised that the "shm" here is sysvipc and doesn't have anything
to do with the huge page support in shmfs.

> A subsequent patch will propagate FMODE_HUGETLBFS in overlayfs.
> 
> Suggested-by: Al Viro <viro@zeniv.linux.org.uk>
> Signed-off-by: Mike Kravetz <mike.kravetz@oracle.com>

Reviewed-by: Matthew Wilcox (Oracle) <willy@infradead.org>

I might have suggested splitting the rename of is_file_hugetlbfs() from
the rest of this patch, but I wouldn't resend to change that.
