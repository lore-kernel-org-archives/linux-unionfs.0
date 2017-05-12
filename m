From: Eryu Guan <eguan@redhat.com>
Subject: Re: [PATCH 4/4] overlay: tag tests 016-018 as experimental
Date: Fri, 12 May 2017 12:01:45 +0800
Message-ID: <20170512040145.GJ7250@eguan.usersys.redhat.com>
References: <1494485710-2400-1-git-send-email-amir73il@gmail.com>
 <1494485710-2400-5-git-send-email-amir73il@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-unionfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:60376 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1756749AbdELEBr (ORCPT <rfc822;linux-unionfs@vger.kernel.org>);
        Fri, 12 May 2017 00:01:47 -0400
Content-Disposition: inline
In-Reply-To: <1494485710-2400-5-git-send-email-amir73il@gmail.com>
Sender: linux-unionfs-owner@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org
To: Amir Goldstein <amir73il@gmail.com>
Cc: Miklos Szeredi <miklos@szeredi.hu>, Xiong Zhou <xzhou@redhat.com>, linux-unionfs@vger.kernel.org, fstests@vger.kernel.org

On Thu, May 11, 2017 at 09:55:10AM +0300, Amir Goldstein wrote:
> The tests 016-018 were added to track overlayfs 'Non-standard behavior'
> as are documented in Documentation/filesystems/overlayfs.txt, with the
> intention of fixing those behaviors 'some day'.
> 
> While that day seems to be seen in the horizon, at least for test 017,
> it may take a while longer for all those tests to pass.
> Add those tests to group 'experimental' so at least this special status
> is published somehow.
> 
> Signed-off-by: Amir Goldstein <amir73il@gmail.com>

The first three patches look good to me, but I'm a bit reluctant on
merging this one.

To me, this new 'experimental' group serves as an indication of "this
test is known to fail". But this info already can be found in commit
logs and comments of these tests. Also fstests had been pushing back
attempts to add "known issue" support in the past. So I'd rather drop
this patch.

Thanks,
Eryu

> ---
>  tests/overlay/group | 6 +++---
>  1 file changed, 3 insertions(+), 3 deletions(-)
> 
> diff --git a/tests/overlay/group b/tests/overlay/group
> index c5048c4..39169d3 100644
> --- a/tests/overlay/group
> +++ b/tests/overlay/group
> @@ -18,9 +18,9 @@
>  013 auto quick copyup
>  014 auto quick copyup
>  015 auto quick whiteout
> -016 auto quick copyup
> -017 auto quick copyup
> -018 auto quick copyup
> +016 auto quick copyup experimental
> +017 auto quick copyup experimental
> +018 auto quick copyup experimental
>  019 auto stress
>  020 auto quick copyup perms
>  021 auto quick copyup
> -- 
> 2.7.4
> 
