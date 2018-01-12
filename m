From: Amir Goldstein <amir73il@gmail.com>
Subject: Re: [PATCH v3 7/7] overlay/019: fix fs check failure
Date: Fri, 12 Jan 2018 21:10:30 +0200
Message-ID: <CAOQ4uxirV5426f+Rqo-W_Q3Fiyfi8ubBS9LweqWPs3PqG1T91w@mail.gmail.com>
References: <20180112120533.6099-1-yi.zhang@huawei.com> <20180112120533.6099-8-yi.zhang@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <fstests-owner@vger.kernel.org>
In-Reply-To: <20180112120533.6099-8-yi.zhang@huawei.com>
Sender: fstests-owner@vger.kernel.org
To: "zhangyi (F)" <yi.zhang@huawei.com>
Cc: overlayfs <linux-unionfs@vger.kernel.org>, fstests <fstests@vger.kernel.org>, Miklos Szeredi <miklos@szeredi.hu>, Eryu Guan <eguan@redhat.com>, Miao Xie <miaoxie@huawei.com>, yangerkun@huawei.com
List-Id: linux-unionfs@vger.kernel.org

On Fri, Jan 12, 2018 at 2:05 PM, zhangyi (F) <yi.zhang@huawei.com> wrote:
> This is a stability test, fsstress will create a lot of orphan
> whiteouts in lowerdir, which will lead to inconsistency of overlay
> image and fs check failure. No need to check this manual craft
> file system, so just skip fs check.
>
> Signed-off-by: zhangyi (F) <yi.zhang@huawei.com>

Looks correct

> ---
>  tests/overlay/019 | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/tests/overlay/019 b/tests/overlay/019
> index 3e2bc4e..575aaf7 100755
> --- a/tests/overlay/019
> +++ b/tests/overlay/019
> @@ -46,7 +46,7 @@ rm -f $seqres.full
>  # real QA test starts here
>  _supported_fs overlay
>  _supported_os Linux
> -_require_scratch
> +_require_scratch_nocheck
>
>  # Remove all files from previous tests
>  _scratch_mkfs
> --
> 2.9.5
>
