From: Eryu Guan <eguan@redhat.com>
Subject: Re: [xfstests PATCH v2 0/5] overlay: add overlay filesystem dirs
 check
Date: Wed, 7 Feb 2018 00:14:51 +0800
Message-ID: <20180206161451.GU18267@eguan.usersys.redhat.com>
References: <20180131102759.40997-1-yi.zhang@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <fstests-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20180131102759.40997-1-yi.zhang@huawei.com>
Sender: fstests-owner@vger.kernel.org
To: "zhangyi (F)" <yi.zhang@huawei.com>
Cc: fstests@vger.kernel.org, linux-unionfs@vger.kernel.org, miklos@szeredi.hu, amir73il@gmail.com, miaoxie@huawei.com, yangerkun@huawei.com
List-Id: linux-unionfs@vger.kernel.org

On Wed, Jan 31, 2018 at 06:27:54PM +0800, zhangyi (F) wrote:
> Hi, All:
> 
> This patchset implement filesystem check for overlay filesystem, base on
> my "overlay: add fsck.overlay basic tests" patchset and works only if
> fsck.overlay[1] exists (otherwise not run).
> 
> Patch 1 improve and fix _is_mounted helper in common/rc.
> Patch 2 hook fsck helper to _check_test_fs & _check_scratch_fs, and
> introduce helpers for optionally scratch dirs.
> Patch 3~5 modify overlay test cases to do fs check correctly.

Thanks a lot for all the patches and revisions! I just went through this
patchset and had additional comments. I'm sorry again for being late on
review..

> 
> Hi, Eryu:
> 
> The patch 5/5 conflict with Amir's patchset, let me know if you want me
> to rebase it.

Yes, please, rebasing against current master would be great, thanks!

Eryu

> 
> Thanks,
> Yi.
> 
> [1] https://github.com/hisilicon/overlayfs-progs
> 
> Changes since v1:
> - Details comments in patch 1/5.
> - Improve _overlay_check_scratch_dirs to accept extra options.
> - Fix basic filesystem mounted check in _overlay_check_fs.
> - Improve overlay/044 in patch 5/5 to add index=on option.
> 
> 
> zhangyi (F) (5):
>   common/rc: improve mounted check helper
>   overlay: hook filesystem check helper
>   overlay/003: fix fs check failure
>   overlay: skip check for tests finished with corrupt filesystem
>   overlay: correct scratch dirs check
> 
>  common/overlay    | 128 ++++++++++++++++++++++++++++++++++++++++++++++++++++++
>  common/rc         |  29 +++++--------
>  tests/overlay/003 |   1 -
>  tests/overlay/005 |   6 ++-
>  tests/overlay/010 |   6 ++-
>  tests/overlay/014 |  10 ++++-
>  tests/overlay/019 |   2 +-
>  tests/overlay/031 |   2 +-
>  tests/overlay/035 |   6 ++-
>  tests/overlay/036 |   5 ++-
>  tests/overlay/037 |   6 ++-
>  tests/overlay/038 |  10 ++++-
>  tests/overlay/041 |  10 ++++-
>  tests/overlay/043 |   6 ++-
>  tests/overlay/044 |  13 +++++-
>  15 files changed, 209 insertions(+), 31 deletions(-)
> 
> -- 
> 2.5.0
> 
