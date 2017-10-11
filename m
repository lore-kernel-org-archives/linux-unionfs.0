From: Eryu Guan <eguan@redhat.com>
Subject: Re: [PATCH 4/4] overlay: fix _overlay_config_override of
 MOUNT_OPTIONS
Date: Wed, 11 Oct 2017 19:50:20 +0800
Message-ID: <20171011115020.GW10593@eguan.usersys.redhat.com>
References: <1506495852-7295-1-git-send-email-amir73il@gmail.com>
 <1506495852-7295-5-git-send-email-amir73il@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-unionfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:46772 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751910AbdJKLuX (ORCPT <rfc822;linux-unionfs@vger.kernel.org>);
        Wed, 11 Oct 2017 07:50:23 -0400
Content-Disposition: inline
In-Reply-To: <1506495852-7295-5-git-send-email-amir73il@gmail.com>
Sender: linux-unionfs-owner@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org
To: Amir Goldstein <amir73il@gmail.com>
Cc: Miklos Szeredi <miklos@szeredi.hu>, linux-unionfs@vger.kernel.org, fstests@vger.kernel.org

On Wed, Sep 27, 2017 at 10:04:12AM +0300, Amir Goldstein wrote:
> The config variable OVERLAY_MOUNT_OPTIONS is used to configure
> the overlay mount options when running ./check -overlay.
> The config variable MOUNT_OPTIONS is used to configure the
> mount options for base fs.
> 
> If config sets value of OVERLAY_MOUNT_OPTIONS and
> does not set MOUNT_OPTIONS, the value of MOUNT_OPTIONS
> may be leftover from previous _overlay_config_override, so
> don't use that value for base fs mount.
> 
> Signed-off-by: Amir Goldstein <amir73il@gmail.com>
> ---
>  common/config | 4 ++++
>  1 file changed, 4 insertions(+)
> 
> diff --git a/common/config b/common/config
> index 71798f0..8844173 100644
> --- a/common/config
> +++ b/common/config
> @@ -532,6 +532,10 @@ _overlay_config_override()
>  	# Store original base fs vars
>  	export OVL_BASE_TEST_DEV="$TEST_DEV"
>  	export OVL_BASE_TEST_DIR="$TEST_DIR"
> +	# If config does not set MOUNT_OPTIONS, its value may be
> +	# leftover from previous _overlay_config_override, so
> +	# don't use that value for base fs mount
> +	[ "$MOUNT_OPTIONS" != "$OVERLAY_MOUNT_OPTIONS" ] || unset MOUNT_OPTIONS
>  	export OVL_BASE_MOUNT_OPTIONS="$MOUNT_OPTIONS"

Hmm, I don't like the idea that specify mount options for base fs
through MOUNT_OPTIONS. With this, we can only specify overlay mount
options via OVERLAY_MOUNT_OPTIONS but not MOUNT_OPTIONS. Ideally, I'd
like both of them work, and OVERLAY_MOUNT_OPTIONS is assigned to
MOUNT_OPTIONS when the latter is empty.

I think MOUNT_OPTIONS and TEST_FS_MOUNT_OPTS should always be the mount
options for filesystem we're currently testing (overlay in this case)
not something else.

OTOH, We can always specify OVL_BASE_MOUNT_OPTIONS directly for base fs
mount options if we want.

But this problem has nothing to do with this patchset, it goes back to
the time when overlay supports base test/scratch dev, so I'm fine with
this patch going in right now.

Thanks,
Eryu

>  
>  	# Set TEST vars to overlay base and mount dirs inside base fs
> -- 
> 2.7.4
> 
