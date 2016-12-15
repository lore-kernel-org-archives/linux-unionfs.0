From: Amir Goldstein <amir73il@gmail.com>
Subject: Re: [PATCH] common/rc: fix detection of already mounted test device
Date: Thu, 15 Dec 2016 09:54:07 +0200
Message-ID: <CAOQ4uxhQkFy+bN4naEQVw2Hcgr-ehzSrmk7p0UG1N3kmQL5b3Q@mail.gmail.com>
References: <20161215071931.31651-1-eguan@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-unionfs-owner@vger.kernel.org>
Received: from mail-wm0-f67.google.com ([74.125.82.67]:33388 "EHLO
        mail-wm0-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1757409AbcLOHy0 (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Thu, 15 Dec 2016 02:54:26 -0500
In-Reply-To: <20161215071931.31651-1-eguan@redhat.com>
Sender: linux-unionfs-owner@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org
To: Eryu Guan <eguan@redhat.com>
Cc: fstests <fstests@vger.kernel.org>, linux-unionfs@vger.kernel.org

On Thu, Dec 15, 2016 at 9:19 AM, Eryu Guan <eguan@redhat.com> wrote:
> I saw this failure in overlayfs testing:
>
> +$SCRATCH_DEV=/mnt/ovl/scratch is mounted but not on $SCRATCH_MNT=/mnt/xfstests/mnt2 - aborting
> +Already mounted result:
> +/dev/sda5 on /mnt/ovl/scratch type xfs (rw,relatime,seclabel,attr2,inode64,logbsize=256k,sunit=512,swidth=1536,noquota)
>
> Because we grep for TEST_DEV and SCRATCH_DEV in mount output to see
> if test device is already mounted, and report failure if device is
> not mounted at desired mount point, but in the case of overlayfs
> testing these "test device"s are directories and may have other real
> devices mounted there.
>
> Fix it by checking TEST_DEV and SCRATCH_DEV at the beginning of
> mount entries.
>
> Signed-off-by: Eryu Guan <eguan@redhat.com>
> ---
>  common/rc | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
>
> diff --git a/common/rc b/common/rc
> index 26d715d..6fcab17 100644
> --- a/common/rc
> +++ b/common/rc
> @@ -1363,7 +1363,7 @@ _require_scratch_nocheck()
>      # mounted?
>      # Note that we use -F here so grep doesn't try to interpret an NFS over
>      # IPv6 server as a regular expression.
> -    mount_rec=`_mount | grep -F $SCRATCH_DEV`
> +    mount_rec=`_mount | grep -F "^$SCRATCH_DEV"`

Are you sure?
A manual test I did -F treats ^ as regular char in string and fails to
grep the entry

How about grep -F "$SCRATCH_DEV on "` ?


>      if [ "$mount_rec" ]
>      then
>          # if it's mounted, make sure its on $SCRATCH_MNT
> @@ -1448,7 +1448,7 @@ _require_test()
>      # mounted?
>      # Note that we use -F here so grep doesn't try to interpret an NFS over
>      # IPv6 server as a regular expression.
> -    mount_rec=`_mount | grep -F $TEST_DEV`
> +    mount_rec=`_mount | grep -F "^$TEST_DEV"`
>      if [ "$mount_rec" ]
>      then
>          # if it's mounted, make sure its on $TEST_DIR
> --
> 2.9.3
>
> --
> To unsubscribe from this list: send the line "unsubscribe fstests" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
