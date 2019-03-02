Return-Path: <guaneryu@gmail.com>
Return-Path: <guaneryu@gmail.com>
Date: Sat, 2 Mar 2019 23:26:43 +0800
From: Eryu Guan <guaneryu@gmail.com>
Subject: Re: [PATCH 1/2] generic/{436,445}: check falloc support
Message-ID: <20190302152643.GE2824@desktop>
References: <20190226140902.32219-1-amir73il@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190226140902.32219-1-amir73il@gmail.com>
To: Amir Goldstein <amir73il@gmail.com>
Cc: Miklos Szeredi <miklos@szeredi.hu>, Eddie Horng <eddiehorng.tw@gmail.com>, linux-unionfs@vger.kernel.org, fstests@vger.kernel.org
List-ID: <linux-unionfs@vger.kernel.org>

On Tue, Feb 26, 2019 at 04:09:01PM +0200, Amir Goldstein wrote:
> The sanity test case in those tests (i.e. 13..17)
> are all skipped in fs with no falloc support, but the tests
> are reported to pass.
> 
> For example, from 445.full:
> 
>  File system supports the default behavior.
>  File system does not support fallocate.
>  Allocation size: 4096
>  17. Test file with unwritten extents, data-hole-data inside page
>  Test skipped as fs doesn't support unwritten extents.
> 
> Explicitly check for falloc support before running those tests
> so they would be properly reported as skipped.
> 
> Signed-off-by: Amir Goldstein <amir73il@gmail.com>

This patch looks fine, I'm taking it for this week's update.

Thanks,
Eryu
