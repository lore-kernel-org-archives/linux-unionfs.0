Return-Path: <guaneryu@gmail.com>
Return-Path: <guaneryu@gmail.com>
Date: Fri, 27 Apr 2018 10:31:50 +0800
From: Eryu Guan <guaneryu@gmail.com>
Subject: Re: [PATCH v2 0/4] Fix failing overlay nonsamefs fstests
Message-ID: <20180427023150.GK11384@desktop>
References: <1524722007-30891-1-git-send-email-amir73il@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1524722007-30891-1-git-send-email-amir73il@gmail.com>
To: Amir Goldstein <amir73il@gmail.com>
Cc: Miklos Szeredi <miklos@szeredi.hu>, linux-unionfs@vger.kernel.org, fstests@vger.kernel.org
List-ID: <linux-unionfs@vger.kernel.org>

On Wed, Apr 25, 2018 at 11:53:23PM -0600, Amir Goldstein wrote:
> Eryu,
> 
> xino feature was introduced in kernel v4.17-rc1 to fix constant inode
> numbers on non samefs setup. This patch set converts the relevant tests
> to notrun instead of failing on old kernels and opts-in for xino with
> new kernels.

overlay/04{1,3,4} all passed for me on v4.17-rc2 now, thanks! Looking
forward to passing all the overlay tests :)

> 
> The first patch is a re-factoring of helpers from v1 patches I ended
> not using in v2 patches, but seems useful, so you may take it or leave
> it out as you wish.

I'd drop it for now, and fix the corresponding comments in patch 4/4.

Thanks,
Eryu

P.S.
I'm not using eguan@redhat.com anymore, please use guaneryu@gmail.com :)

> 
> Thanks,
> Amir.
> 
> Changes since v1:
> - Fix fsck run failure in 041
> - Fix missing redirect_dir requirement in 043
> - Fix check for xino enabled
> 
> Amir Goldstein (4):
>   common/rc: factor out _require_scratch_fs_option
>   overlay/041: fix call to _overlay_check_scratch_dirs
>   overlay/043: require and enable redirect_dir
>   overlay/04{1,3,4}: enable xino feature
> 
>  common/rc         | 29 ++++++++++++++++++++++-------
>  tests/overlay/041 | 21 +++++++++++++--------
>  tests/overlay/043 | 17 ++++++++++++++---
>  tests/overlay/044 | 16 ++++++++++++----
>  4 files changed, 61 insertions(+), 22 deletions(-)
> 
> -- 
> 2.7.4
> 
> --
> To unsubscribe from this list: send the line "unsubscribe fstests" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
