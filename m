From: Amir Goldstein <amir73il@gmail.com>
Subject: Re: [PATCH v3 0/7] overlay: add fsck.overlay basic tests
Date: Fri, 12 Jan 2018 21:19:53 +0200
Message-ID: <CAOQ4uxij64P9zOmkDR+XfEY2BC3GrMm3mihkoaM_bq41cFEqHw@mail.gmail.com>
References: <20180112120533.6099-1-yi.zhang@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-unionfs-owner@vger.kernel.org>
Received: from mail-yb0-f196.google.com ([209.85.213.196]:41839 "EHLO
        mail-yb0-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S964998AbeALTTy (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Fri, 12 Jan 2018 14:19:54 -0500
In-Reply-To: <20180112120533.6099-1-yi.zhang@huawei.com>
Sender: linux-unionfs-owner@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org
To: "zhangyi (F)" <yi.zhang@huawei.com>
Cc: overlayfs <linux-unionfs@vger.kernel.org>, fstests <fstests@vger.kernel.org>, Miklos Szeredi <miklos@szeredi.hu>, Eryu Guan <eguan@redhat.com>, Miao Xie <miaoxie@huawei.com>, yangerkun@huawei.com

On Fri, Jan 12, 2018 at 2:05 PM, zhangyi (F) <yi.zhang@huawei.com> wrote:
> Hi all:
>
> Here is the third version of test cases for the upcoming fsck.overlay,
> corresponding to fsck.overlay v4 (will post to github repository soon).
> Test fsck.overlay check and fix inconsistency of whiteout and redirect/impure
> xattr.
>
> Changes since v2:
> - Modify some minor suggestions from Amir and Vivek, and simplify code
>   in all three test cases.
> - Fix duplicate redirect xattr test in 202.
> - Add impure xattr test case of general merge directory in 'no impure'
>   parent directory.
> - Fix fs check failure in other overlay fs test cases. PS: The
>   multi-lowers problem in overlay/010 also appears in many other tests,
>   _require_scratch() will mis-check the pre-defined underlying dirs
>   (not the real test dirs). I think they also need to be modified as this
>   patch(06/07) does to check the correct dirs, and I can fix them if you
>   think necessary.

Yes, please do.
Thinking out loud, we could use a helper _require_overlay_scratch_dirs
for tests that use _overlay_scratch_mount_dirs and not _scratch_mount.
That helper will actually be a wrapper to _require_scratch_nocheck, but
with a comment that explains why, because usually,
_require_scratch_nocheck means that test leaves filesystem corrupt
and that is not the case here.

Thanks,
Amir.

>
> ------
>
> Changes since v1:
>
> - Fix _check_scratch_fs hook.
> - Remove valid/invalid opaque xattr test.
> - Add whiteout test cases of valid/invalid whiteouts in opaque/redirect
>   parent directory.
> - Add impure xattr test.
>
> zhangyi (F) (7):
>   overlay: add filesystem check helper
>   overlay: add fsck.overlay whiteout test
>   overlay: add fsck.overlay redirect directory test
>   overlay: add fsck.overlay impure xattr test
>   overlay/003: fix fs check failure
>   overlay/010: fix fs check failure
>   overlay/019: fix fs check failure
>
>  common/config         |   1 +
>  common/overlay        |  80 +++++++++++++++++
>  common/rc             |   4 +-
>  tests/overlay/003     |   1 -
>  tests/overlay/010     |  11 +--
>  tests/overlay/019     |   2 +-
>  tests/overlay/201     | 232 ++++++++++++++++++++++++++++++++++++++++++++++++
>  tests/overlay/201.out |  10 +++
>  tests/overlay/202     | 240 ++++++++++++++++++++++++++++++++++++++++++++++++++
>  tests/overlay/202.out |  10 +++
>  tests/overlay/203     | 143 ++++++++++++++++++++++++++++++
>  tests/overlay/203.out |   4 +
>  tests/overlay/group   |   3 +
>  13 files changed, 732 insertions(+), 9 deletions(-)
>  create mode 100755 tests/overlay/201
>  create mode 100644 tests/overlay/201.out
>  create mode 100755 tests/overlay/202
>  create mode 100644 tests/overlay/202.out
>  create mode 100755 tests/overlay/203
>  create mode 100644 tests/overlay/203.out
>
> --
> 2.5.0
>
