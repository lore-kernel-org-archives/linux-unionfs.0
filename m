From: Eryu Guan <eguan@redhat.com>
Subject: Re: [PATCH 1/5] overlay/017: silence test output
Date: Fri, 28 Apr 2017 13:36:33 +0800
Message-ID: <20170428053633.GL26397@eguan.usersys.redhat.com>
References: <1493305775-12559-1-git-send-email-amir73il@gmail.com>
 <1493305775-12559-2-git-send-email-amir73il@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-unionfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:43136 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S938323AbdD1Fgg (ORCPT <rfc822;linux-unionfs@vger.kernel.org>);
        Fri, 28 Apr 2017 01:36:36 -0400
Content-Disposition: inline
In-Reply-To: <1493305775-12559-2-git-send-email-amir73il@gmail.com>
Sender: linux-unionfs-owner@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org
To: Amir Goldstein <amir73il@gmail.com>
Cc: Miklos Szeredi <miklos@szeredi.hu>, Xiong Zhou <xzhou@redhat.com>, linux-unionfs@vger.kernel.org, fstests@vger.kernel.org

On Thu, Apr 27, 2017 at 06:09:31PM +0300, Amir Goldstein wrote:
> Change test to output golden silence on success.

Some words on why this change is needed would be good.

> 
> Signed-off-by: Amir Goldstein <amir73il@gmail.com>
> ---
>  tests/overlay/017     | 4 +++-
>  tests/overlay/017.out | 7 +------
>  2 files changed, 4 insertions(+), 7 deletions(-)
> 
> diff --git a/tests/overlay/017 b/tests/overlay/017
> index 5ca3040..d6ba2ae 100755
> --- a/tests/overlay/017
> +++ b/tests/overlay/017
> @@ -89,11 +89,13 @@ done
>  
>  # find by inode number - expect to find file by inode number
>  cat $tmp.before | while read ino f; do
> -	find $f -inum $ino -maxdepth 0 | _filter_scratch
> +	find $SCRATCH_MNT/ -inum $ino -maxdepth 1 | grep -q $f || \
> +		echo "$f not found by ino $ino"

Hmm, if I run this find command manually, I got warning about -maxdepth
position.

# find `pwd` -inum 3932421 -maxdepth 1
find: warning: you have specified the -maxdepth option after a non-option argument -inum, but options are not positional (-maxdepth affects tests specified before it as well as those specified after it).  Please specify options before other arguments.

/root/xfstests/check

Move -maxdepth option just after find path works fine

# find `pwd` -maxdepth 1 -inum 3932421 
/root/xfstests/check

But I'm not sure why I didn't see this warning by running overlay/017..
Anyway, moving -maxdepth around seems better to me.

Thanks,
Eryu

>  done
>  
>  # Compare before..after - expect silence
>  diff $tmp.before $tmp.after
>  
> +echo "Silence is golden"
>  status=0
>  exit
> diff --git a/tests/overlay/017.out b/tests/overlay/017.out
> index 1f277c5..8222844 100644
> --- a/tests/overlay/017.out
> +++ b/tests/overlay/017.out
> @@ -1,7 +1,2 @@
>  QA output created by 017
> -SCRATCH_MNT/dir
> -SCRATCH_MNT/file
> -SCRATCH_MNT/symlink
> -SCRATCH_MNT/chrdev
> -SCRATCH_MNT/blkdev
> -SCRATCH_MNT/fifo
> +Silence is golden
> -- 
> 2.7.4
> 
