From: Amir Goldstein <amir73il@gmail.com>
Subject: Re: [xfstests PATCH v6 1/8] common/rc: modify mounted check helper
Date: Wed, 24 Jan 2018 11:23:00 +0200
Message-ID: <CAOQ4uxj4GwioO3OiKra17kDRW=h_y=O3+h=zt0=DNBsLDKvd7A@mail.gmail.com>
References: <20180124073344.31970-1-yi.zhang@huawei.com> <20180124073344.31970-2-yi.zhang@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-unionfs-owner@vger.kernel.org>
Received: from mail-yw0-f195.google.com ([209.85.161.195]:44688 "EHLO
        mail-yw0-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932389AbeAXJXB (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Wed, 24 Jan 2018 04:23:01 -0500
In-Reply-To: <20180124073344.31970-2-yi.zhang@huawei.com>
Sender: linux-unionfs-owner@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org
To: "zhangyi (F)" <yi.zhang@huawei.com>
Cc: overlayfs <linux-unionfs@vger.kernel.org>, fstests <fstests@vger.kernel.org>, Miklos Szeredi <miklos@szeredi.hu>, Eryu Guan <eguan@redhat.com>, Miao Xie <miaoxie@huawei.com>, yangerkun@huawei.com

On Wed, Jan 24, 2018 at 9:33 AM, zhangyi (F) <yi.zhang@huawei.com> wrote:
> Modify _is_mounted() to accept a dir and fstype as input, and check
> whether this dir is a mount point of specified fstype. This patch also
> fix the problem of invalid fstype check and remove invalid error
> message.
>
> Signed-off-by: zhangyi (F) <yi.zhang@huawei.com>
> ---
>  common/rc | 30 +++++++++++++++---------------
>  1 file changed, 15 insertions(+), 15 deletions(-)
>
> diff --git a/common/rc b/common/rc
> index 77a4eb4..2e7aee5 100644
> --- a/common/rc
> +++ b/common/rc
> @@ -2372,27 +2372,27 @@ _scratch_mkfs_richacl()
>         esac
>  }
>
> -# check that a FS on a device is mounted
> +# check that a FS on a device is mounted or a dir is a mount point
>  # if so, return mount point
>  #
>  _is_mounted()
>  {
> -    if [ $# -ne 1 ]
> -    then
> -       echo "Usage: _is_mounted device" 1>&2
> -       exit 1
> -    fi
> +       local name
> +       local fstype
>
> -    device=$1
> +       if [ $# -eq 2 ]; then
> +               name=$1
> +               fstype=$2
> +       elif [ $# -eq 1 ]; then
> +               name=$1

missing fstype=$FSTYP here?
probably need to check better that this change did not break _is_mounted users

suggesting:

    if [ $# -lt 1 ]
...
       local name=$1
       local fstype=${2-$FSTYP}
