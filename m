Return-Path: <SRS0=dIwb=EI=vger.kernel.org=linux-unionfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-11.2 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0738EC00A89
	for <linux-unionfs@archiver.kernel.org>; Mon,  2 Nov 2020 17:30:56 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 9C86721D91
	for <linux-unionfs@archiver.kernel.org>; Mon,  2 Nov 2020 17:30:55 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727524AbgKBRaz (ORCPT
        <rfc822;linux-unionfs@archiver.kernel.org>);
        Mon, 2 Nov 2020 12:30:55 -0500
Received: from mx2.suse.de ([195.135.220.15]:52116 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726587AbgKBRaz (ORCPT <rfc822;linux-unionfs@vger.kernel.org>);
        Mon, 2 Nov 2020 12:30:55 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.221.27])
        by mx2.suse.de (Postfix) with ESMTP id 5F8ACAC2E;
        Mon,  2 Nov 2020 17:30:53 +0000 (UTC)
Received: by quack2.suse.cz (Postfix, from userid 1000)
        id DE7541E12FB; Mon,  2 Nov 2020 18:30:52 +0100 (CET)
Date:   Mon, 2 Nov 2020 18:30:52 +0100
From:   Jan Kara <jack@suse.cz>
To:     Chengguang Xu <cgxu519@mykernel.net>
Cc:     miklos@szeredi.hu, amir73il@gmail.com, jack@suse.cz,
        linux-unionfs@vger.kernel.org, linux-fsdevel@vger.kernel.org
Subject: Re: [RFC PATCH v2 5/8] ovl: mark overlayfs' inode dirty on shared
 writable mmap
Message-ID: <20201102173052.GF23988@quack2.suse.cz>
References: <20201025034117.4918-1-cgxu519@mykernel.net>
 <20201025034117.4918-6-cgxu519@mykernel.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201025034117.4918-6-cgxu519@mykernel.net>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <linux-unionfs.vger.kernel.org>
X-Mailing-List: linux-unionfs@vger.kernel.org

On Sun 25-10-20 11:41:14, Chengguang Xu wrote:
> Overlayfs cannot be notified when mmapped area gets dirty,
> so we need to proactively mark inode dirty in ->mmap operation.
> 
> Signed-off-by: Chengguang Xu <cgxu519@mykernel.net>
> ---
>  fs/overlayfs/file.c | 4 ++++
>  1 file changed, 4 insertions(+)
> 
> diff --git a/fs/overlayfs/file.c b/fs/overlayfs/file.c
> index efccb7c1f9bc..cd6fcdfd81a9 100644
> --- a/fs/overlayfs/file.c
> +++ b/fs/overlayfs/file.c
> @@ -486,6 +486,10 @@ static int ovl_mmap(struct file *file, struct vm_area_struct *vma)
>  		/* Drop reference count from new vm_file value */
>  		fput(realfile);
>  	} else {
> +		if (vma->vm_flags & (VM_SHARED|VM_MAYSHARE) &&
> +		    vma->vm_flags & (VM_WRITE|VM_MAYWRITE))
> +			ovl_mark_inode_dirty(file_inode(file));
> +

But does this work reliably? I mean once writeback runs, your inode (as
well as upper inode) is cleaned. Then a page fault comes so file has dirty
pages again and would need flushing but overlayfs inode stays clean? Am I
missing something?

								Honza
-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR
