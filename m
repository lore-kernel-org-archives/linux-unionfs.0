From: Eryu Guan <eguan@redhat.com>
Subject: Re: [PATCH 4/5] overlay/017: verify constant inode number after
 rename
Date: Fri, 28 Apr 2017 13:47:20 +0800
Message-ID: <20170428054720.GM26397@eguan.usersys.redhat.com>
References: <1493305775-12559-1-git-send-email-amir73il@gmail.com>
 <1493305775-12559-5-git-send-email-amir73il@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-unionfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:43572 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1754983AbdD1FrW (ORCPT <rfc822;linux-unionfs@vger.kernel.org>);
        Fri, 28 Apr 2017 01:47:22 -0400
Content-Disposition: inline
In-Reply-To: <1493305775-12559-5-git-send-email-amir73il@gmail.com>
Sender: linux-unionfs-owner@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org
To: Amir Goldstein <amir73il@gmail.com>
Cc: Miklos Szeredi <miklos@szeredi.hu>, Xiong Zhou <xzhou@redhat.com>, linux-unionfs@vger.kernel.org, fstests@vger.kernel.org

On Thu, Apr 27, 2017 at 06:09:34PM +0300, Amir Goldstein wrote:
> The test verifies constant inode number after copy up.
> Verify that inode number remains constant also after rename
> and drop caches (when overlayfs needs to find the lower
> inodes in another location).
> 
> Signed-off-by: Amir Goldstein <amir73il@gmail.com>
> ---
>  tests/overlay/017 | 22 ++++++++++++++++++----
>  1 file changed, 18 insertions(+), 4 deletions(-)
> 
> diff --git a/tests/overlay/017 b/tests/overlay/017
> index f3bf454..1cf684d 100755
> --- a/tests/overlay/017
> +++ b/tests/overlay/017
> @@ -8,7 +8,8 @@
>  # - modify A to trigger copy up
>  # - stat file A shows inode number Y != X
>  #
> -# Also test if d_ino of readdir entries changes after copy up.
> +# Also test if d_ino of readdir entries changes after copy up
> +# and if inode numbers persist after rename and drop caches.
>  #
>  #-----------------------------------------------------------------------
>  #
> @@ -94,6 +95,8 @@ _scratch_mount
>  
>  
>  rm -f $tmp.*
> +testdir=$SCRATCH_MNT/test
> +mkdir -p $testdir
>  
>  # Test stable stat(2) st_ino
>  
> @@ -106,18 +109,29 @@ for f in $FILES; do
>  done
>  
>  # Record inode numbers after copy up
> -record_inode_numbers $SCRATCH_MNT $tmp.after
> +record_inode_numbers $SCRATCH_MNT $tmp.after_copyup

inode numbers are saved after copyup and will be tested by diff with
$tmp.before, but find (d_ino) is not tested after a pure copyup...

> +
> +for f in $FILES; do
> +	# move to another dir
> +	mv $SCRATCH_MNT/$f $testdir/
> +done
> +
> +echo 3 > /proc/sys/vm/drop_caches
> +
> +# Record inode numbers after rename and drop caches
> +record_inode_numbers $testdir $tmp.after_move
>  
>  # Test stable readdir(3)/getdents(2) d_ino
>  
>  # find by inode number - expect to find file by inode number
>  cat $tmp.before | while read ino f; do
> -	find $SCRATCH_MNT/ -inum $ino -maxdepth 1 | grep -q $f || \
> +	find $testdir/ -inum $ino -maxdepth 1 | grep -q $f || \
>  		echo "$f not found by ino $ino"
>  done

it's only tested here, after a rename and a drop_caches.

IMO, it's better to test both find and stat after each operation that
would cause inode number change. So how about factoring out a helper
that does this inode number check (find and diff), and calling it after
each operation?

e.g. a new helper called check_inode_number(), then

<create files>
<copyup>
check_inode_number [with necessary args]
<rename>
check_inode_number
<drop_caches>
check_inode_number
<cycle mount>
check_inode_number

Thanks,
Eryu

>  
>  # Compare before..after - expect silence
> -diff $tmp.before $tmp.after
> +diff -u $tmp.before $tmp.after_copyup
> +diff -u $tmp.after_copyup $tmp.after_move
>  
>  echo "Silence is golden"
>  status=0
> -- 
> 2.7.4
> 
