From: Eryu Guan <eguan@redhat.com>
Subject: Re: [xfstests PATCH v3 0/6] overlay: add overlay filesystem dirs
 check
Date: Thu, 15 Feb 2018 16:39:22 +0800
Message-ID: <20180215083922.GR18267@eguan.usersys.redhat.com>
References: <20180213070832.43159-1-yi.zhang@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-unionfs-owner@vger.kernel.org>
Received: from mx3-rdu2.redhat.com ([66.187.233.73]:58512 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1755386AbeBOIj0 (ORCPT <rfc822;linux-unionfs@vger.kernel.org>);
        Thu, 15 Feb 2018 03:39:26 -0500
Content-Disposition: inline
In-Reply-To: <20180213070832.43159-1-yi.zhang@huawei.com>
Sender: linux-unionfs-owner@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org
To: "zhangyi (F)" <yi.zhang@huawei.com>
Cc: fstests@vger.kernel.org, linux-unionfs@vger.kernel.org, miklos@szeredi.hu, amir73il@gmail.com, miaoxie@huawei.com, yangerkun@huawei.com

On Tue, Feb 13, 2018 at 03:08:26PM +0800, zhangyi (F) wrote:
> Hi, Eryu:
> 
> I have handle all comments from last iterations and fix some mistakes, please
> review.
> 
> Patch 1-5: hook overlay filesystem check and correct current test cases.
> Patch 6: handle the test mount options issue, it add the counterpart of the
>          scratch mount options.

Thanks for the new revision! It looks good overall, I tested with both
legacy and new overlay configurations and both results look fine.

We only need a new version of patch 5 to address Amir's comments. Patch
6 needs some work too, but I think that can be done separately if
necessary.

Thanks,
Eryu

> 
> Thanks,
> Yi.
> 
> Changes since v2:
> - Rename _is_mounted to _is_dev_mounted and use findmnt instead of mount.
> - Fix mistakes in patch 2/6 and introduce _is_dir_mountpoint helper, also
>   introduce fsck options use for overlayfs.
> - Add overlay/049 into patch 4/6 to skip fs check.
> - Add nfs export cases into patch 5/6 to do correct dirs check.
> - Add the "missing feature" of test mount options.
> 
> Changes since v1:
> - Details comments in patch 1/5.
> - Improve _overlay_check_scratch_dirs to accept extra options.
> - Fix basic filesystem mounted check in _overlay_check_fs.
> - Improve overlay/044 in patch 5/5 to add index=on option.
> 
> ----------
> 
> Background:
> 
> This patchset implement filesystem check for overlay filesystem, base on
> my "overlay: add fsck.overlay basic tests" patchset and works only if
> fsck.overlay[1] exists (otherwise not run).
> 
> [1] https://github.com/hisilicon/overlayfs-progs
> 
> zhangyi (F) (6):
>   common/rc: improve dev mounted check helper
>   overlay: hook filesystem check helper
>   overlay/003: fix fs check failure
>   overlay: skip check for tests finished with corrupt filesystem
>   overlay: correct scratch dirs check
>   overlay: correct test mount options
> 
>  README.overlay    |  10 +++-
>  common/config     |  21 ++++++--
>  common/overlay    | 152 +++++++++++++++++++++++++++++++++++++++++++++++++++---
>  common/rc         |  47 +++++++++--------
>  common/xfs        |   2 +-
>  tests/overlay/003 |   1 -
>  tests/overlay/005 |   7 ++-
>  tests/overlay/010 |   7 ++-
>  tests/overlay/014 |  10 +++-
>  tests/overlay/019 |   2 +-
>  tests/overlay/022 |   2 +-
>  tests/overlay/025 |   2 +-
>  tests/overlay/029 |   6 +--
>  tests/overlay/031 |   2 +-
>  tests/overlay/035 |   7 ++-
>  tests/overlay/036 |  26 ++++++----
>  tests/overlay/037 |   7 ++-
>  tests/overlay/038 |  10 +++-
>  tests/overlay/041 |  10 +++-
>  tests/overlay/043 |   7 ++-
>  tests/overlay/044 |   8 ++-
>  tests/overlay/049 |   2 +-
>  tests/overlay/051 |  19 ++++++-
>  tests/overlay/053 |  15 +++++-
>  tests/overlay/055 |  12 ++++-
>  25 files changed, 328 insertions(+), 66 deletions(-)
> 
> -- 
> 2.5.0
> 
> --
> To unsubscribe from this list: send the line "unsubscribe fstests" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
