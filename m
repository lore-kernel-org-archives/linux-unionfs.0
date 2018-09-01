Return-Path: <linux-unionfs-owner@vger.kernel.org>
Received: from mail-pl1-f196.google.com ([209.85.214.196]:41375 "EHLO
        mail-pl1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726953AbeIAVZY (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Sat, 1 Sep 2018 17:25:24 -0400
Date: Sun, 2 Sep 2018 01:12:39 +0800
From: Eryu Guan <guaneryu@gmail.com>
Subject: Re: [PATCH 2/2] generic/009: fix test failure with overlay over ext4
Message-ID: <20180901171239.GG3651@desktop>
References: <1535394566-18837-1-git-send-email-amir73il@gmail.com>
 <1535394566-18837-3-git-send-email-amir73il@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1535394566-18837-3-git-send-email-amir73il@gmail.com>
Sender: linux-unionfs-owner@vger.kernel.org
To: Amir Goldstein <amir73il@gmail.com>
Cc: Theodore Ts'o <tytso@mit.edu>, fstests@vger.kernel.org, linux-ext4@vger.kernel.org, linux-unionfs@vger.kernel.org
List-ID: <linux-unionfs@vger.kernel.org>

On Mon, Aug 27, 2018 at 09:29:26PM +0300, Amir Goldstein wrote:
> When running test with overlayfs and ext4 as base fs, we need to
> disable extent zeroout on the underlying base fs.
> 
> Signed-off-by: Amir Goldstein <amir73il@gmail.com>
> ---
> 
> Eryu,
> 
> Suggestions for a cleaner approach are welcome.

I thought about it too but came out with no better ideas, I think I'll
just take your patches as-is.


Thanks,
Eryu

> 
> Thanks,
> Amir.
> 
>  tests/generic/009 | 3 +++
>  1 file changed, 3 insertions(+)
> 
> diff --git a/tests/generic/009 b/tests/generic/009
> index fa6ef46..a4f56d0 100755
> --- a/tests/generic/009
> +++ b/tests/generic/009
> @@ -39,6 +39,9 @@ testfile=$TEST_DIR/009.$$
>  if [ "$FSTYP" = "ext4" ]; then
>  	_ext4_disable_extent_zeroout
>  fi
> +if [ "$FSTYP" = "overlay" -a "$OVL_BASE_FSTYP" = "ext4" ]; then
> +	_ext4_disable_extent_zeroout "$OVL_BASE_TEST_DEV"
> +fi
>  
>  # When PAGE_SIZE > 4096 some filesystems extent layout is different so
>  # it would not match the output.
> -- 
> 2.7.4
> 
