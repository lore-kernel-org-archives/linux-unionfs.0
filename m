From: Jan Kara <jack@suse.cz>
Subject: Re: [PATCH v8] ovl: Improving syncfs efficiency
Date: Mon, 5 Feb 2018 14:09:05 +0100
Message-ID: <20180205130905.a6wbpmjlgc4w5nij@quack2.suse.cz>
References: <1517195483-79549-1-git-send-email-cgxu519@icloud.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-unionfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:60477 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752582AbeBENJH (ORCPT <rfc822;linux-unionfs@vger.kernel.org>);
        Mon, 5 Feb 2018 08:09:07 -0500
Content-Disposition: inline
In-Reply-To: <1517195483-79549-1-git-send-email-cgxu519@icloud.com>
Sender: linux-unionfs-owner@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org
To: Chengguang Xu <cgxu519@icloud.com>
Cc: miklos@szeredi.hu, jack@suse.cz, amir73il@gmail.com, linux-unionfs@vger.kernel.org

On Mon 29-01-18 11:11:23, Chengguang Xu wrote:
> Currently syncfs(2) call on overlayfs just simply call sync_filesystem()
> on upper_sb to synchronize whole dirty inodes in upper filesystem
> regardless of the overlay ownership of the inode. In the use case of
> container, when multiple containers using the same underlying upper
> filesystem, it has some shortcomings as below.
> 
> (1) Performance
> Synchronization is probably heavy because it actually syncs unnecessary
> inodes for target overlayfs.
> 
> (2) Interference
> Unplanned synchronization will probably impact IO performance of
> unrelated container processes on the other overlayfs.
> 
> This patch iterates upper inode list in overlayfs to only sync target
> dirty inodes and wait for completion. By doing this, It is able to reduce
> cost of synchronization and will not seriously impact IO performance of
> unrelated processes. In special case, when having very few dirty inodes
> and a lot of clean upper inodes in overlayfs, then iteration may waste
> time so that synchronization is slower than before, but we think the
> potential for performance improvement far surpass the potential for
> performance regression in most cases.
> 
> Signed-off-by: Chengguang Xu <cgxu519@icloud.com>
> Reviewed-by: Amir Goldstein <amir73il@gmail.com>

Just one nit below. With that fixed you can add:

Reviewed-by: Jan Kara <jack@suse.cz>

> +
> +next:
> +		if (cond_resched())
> +			blk_start_plug(&plug);

This is wrong. You cannot start plug for a second time. Plugs are
completely seemless wrt scheduling points (places where process can sleep).
And cond_resched() is just an explicit scheduling point but e.g. taking a
lock is an implicit scheduling point as well. So just do cond_resched()
here and remove the blk_start_plug() call.

								Honza
-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR
