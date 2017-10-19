From: Amir Goldstein <amir73il@gmail.com>
Subject: Re: [PATCH] overlay/038: Remove usage of _overlay_scratch_unmount
Date: Thu, 19 Oct 2017 17:52:22 +0300
Message-ID: <CAOQ4uxiJ7x9CkEsvfbFJLmEhbdv6fNePB4poRPHnns=e8KmMBg@mail.gmail.com>
References: <20171019134907.9987-1-chandan@linux.vnet.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-unionfs-owner@vger.kernel.org>
Received: from mail-yw0-f178.google.com ([209.85.161.178]:55203 "EHLO
        mail-yw0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752995AbdJSOwY (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Thu, 19 Oct 2017 10:52:24 -0400
In-Reply-To: <20171019134907.9987-1-chandan@linux.vnet.ibm.com>
Sender: linux-unionfs-owner@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org
To: Chandan Rajendra <chandan@linux.vnet.ibm.com>
Cc: fstests <fstests@vger.kernel.org>, overlayfs <linux-unionfs@vger.kernel.org>, Eryu Guan <eguan@redhat.com>

On Thu, Oct 19, 2017 at 4:49 PM, Chandan Rajendra
<chandan@linux.vnet.ibm.com> wrote:
> _overlay_scratch_unmount is not supposed to be invoked directly by
> tests. Also, since unmounting scratch fs is optional, this commit
> removes invocation of _overlay_scratch_unmount.

Looks good.
Thanks
>
> Signed-off-by: Chandan Rajendra <chandan@linux.vnet.ibm.com>
> ---
>  tests/overlay/038 | 2 --
>  1 file changed, 2 deletions(-)
>
> diff --git a/tests/overlay/038 b/tests/overlay/038
> index 148995b..28c9c4e 100755
> --- a/tests/overlay/038
> +++ b/tests/overlay/038
> @@ -185,8 +185,6 @@ parent_d=$($here/src/t_dir_type $SCRATCH_MNT/test_dir/pure_lower_dir $test_dir_s
>  [[ $parent_d == ".. d" ]] || \
>         echo "Pure lower in dir which has another lower layer: Invalid d_ino reported for .."
>
> -_overlay_scratch_unmount
> -
>  echo "Silence is golden"
>  status=0
>  exit
> --
> 2.9.5
>
