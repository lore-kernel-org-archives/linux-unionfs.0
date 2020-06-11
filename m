Return-Path: <SRS0=MwNC=7Y=vger.kernel.org=linux-unionfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E838EC433E0
	for <linux-unionfs@archiver.kernel.org>; Thu, 11 Jun 2020 02:17:36 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id C93EF206A4
	for <linux-unionfs@archiver.kernel.org>; Thu, 11 Jun 2020 02:17:36 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726290AbgFKCRc (ORCPT
        <rfc822;linux-unionfs@archiver.kernel.org>);
        Wed, 10 Jun 2020 22:17:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60042 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726265AbgFKCRc (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Wed, 10 Jun 2020 22:17:32 -0400
Received: from ZenIV.linux.org.uk (zeniv.linux.org.uk [IPv6:2002:c35c:fd02::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EA272C08C5C1;
        Wed, 10 Jun 2020 19:17:31 -0700 (PDT)
Received: from viro by ZenIV.linux.org.uk with local (Exim 4.93 #3 (Red Hat Linux))
        id 1jjCmE-006lY6-E3; Thu, 11 Jun 2020 02:17:10 +0000
Date:   Thu, 11 Jun 2020 03:17:10 +0100
From:   Al Viro <viro@zeniv.linux.org.uk>
To:     Matthew Wilcox <willy@infradead.org>
Cc:     Mike Kravetz <mike.kravetz@oracle.com>,
        Miklos Szeredi <miklos@szeredi.hu>,
        kbuild test robot <lkp@intel.com>, kbuild-all@lists.01.org,
        Colin Walters <walters@verbum.org>,
        syzbot <syzbot+d6ec23007e951dadf3de@syzkaller.appspotmail.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linux Memory Management List <linux-mm@kvack.org>,
        linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        syzkaller-bugs <syzkaller-bugs@googlegroups.com>,
        overlayfs <linux-unionfs@vger.kernel.org>
Subject: Re: [PATCH v2] ovl: provide real_file() and overlayfs
 get_unmapped_area()
Message-ID: <20200611021710.GA23230@ZenIV.linux.org.uk>
References: <4ebd0429-f715-d523-4c09-43fa2c3bc338@oracle.com>
 <202005281652.QNakLkW3%lkp@intel.com>
 <365d83b8-3af7-2113-3a20-2aed51d9de91@oracle.com>
 <CAJfpegtz=tzndsF=_1tYHewGwEgvqEOA_4zj8HCAqyFdKe6mag@mail.gmail.com>
 <ffc00a9e-5c2f-0c3e-aa1e-9836b98f7b54@oracle.com>
 <20200611003726.GY23230@ZenIV.linux.org.uk>
 <20200611013616.GM19604@bombadil.infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200611013616.GM19604@bombadil.infradead.org>
Sender: linux-unionfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-unionfs.vger.kernel.org>
X-Mailing-List: linux-unionfs@vger.kernel.org

On Wed, Jun 10, 2020 at 06:36:16PM -0700, Matthew Wilcox wrote:

> 	while (file->f_mode & FMODE_OVL_UPPER)
> 		file = file->private_data;
> 	return file;
> 
> Or are you proposing that overlayfs copy FMODE_HUGEPAGES from the
> underlying fs to the overlaying fs?

The latter - that way nobody outside of overlayfs needs to know what
its ->private_data points to, for one thing.  And it's cheaper that
way, obviously.
