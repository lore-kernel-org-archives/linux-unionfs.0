Return-Path: <SRS0=WbPP=7Z=vger.kernel.org=linux-unionfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C5CA0C433DF
	for <linux-unionfs@archiver.kernel.org>; Fri, 12 Jun 2020 01:58:53 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id A5549206DC
	for <linux-unionfs@archiver.kernel.org>; Fri, 12 Jun 2020 01:58:53 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726306AbgFLB6x (ORCPT
        <rfc822;linux-unionfs@archiver.kernel.org>);
        Thu, 11 Jun 2020 21:58:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53306 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725796AbgFLB6x (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Thu, 11 Jun 2020 21:58:53 -0400
Received: from ZenIV.linux.org.uk (zeniv.linux.org.uk [IPv6:2002:c35c:fd02::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 03143C03E96F;
        Thu, 11 Jun 2020 18:58:52 -0700 (PDT)
Received: from viro by ZenIV.linux.org.uk with local (Exim 4.93 #3 (Red Hat Linux))
        id 1jjYxu-007MwO-TA; Fri, 12 Jun 2020 01:58:42 +0000
Date:   Fri, 12 Jun 2020 02:58:42 +0100
From:   Al Viro <viro@zeniv.linux.org.uk>
To:     Mike Kravetz <mike.kravetz@oracle.com>
Cc:     linux-mm@kvack.org, linux-fsdevel@vger.kernel.org,
        overlayfs <linux-unionfs@vger.kernel.org>,
        linux-kernel@vger.kernel.org, Miklos Szeredi <miklos@szeredi.hu>,
        Matthew Wilcox <willy@infradead.org>,
        Colin Walters <walters@verbum.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        syzbot <syzbot+d6ec23007e951dadf3de@syzkaller.appspotmail.com>,
        syzkaller-bugs <syzkaller-bugs@googlegroups.com>
Subject: Re: [PATCH v4 1/2] hugetlb: use f_mode & FMODE_HUGETLBFS to identify
 hugetlbfs files
Message-ID: <20200612015842.GC23230@ZenIV.linux.org.uk>
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

s/HUGETLBFS/HUGEPAGES/, please.

> While cleaning things up, change the name of is_file_hugepages() to
> is_file_hugetlbfs().  The term hugepages is a bit ambiguous.

Don't, especially since the very next patch adds such on overlayfs...

Incidentally, can a hugetlbfs be a lower layer, while the upper one
is a normal filesystem?  What should happen on copyup?
