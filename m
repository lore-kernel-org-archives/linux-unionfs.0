Return-Path: <guaneryu@gmail.com>
Return-Path: <guaneryu@gmail.com>
Date: Sun, 2 Jun 2019 15:26:38 +0800
From: Eryu Guan <guaneryu@gmail.com>
Subject: Re: [PATCH v3 3/4] overlay: correct fsck.overlay exit code
Message-ID: <20190602070949.GS15846@desktop>
References: <20190528151723.12525-1-amir73il@gmail.com>
 <20190528151723.12525-4-amir73il@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190528151723.12525-4-amir73il@gmail.com>
To: Amir Goldstein <amir73il@gmail.com>
Cc: zhangyi <yi.zhang@huawei.com>, Miklos Szeredi <miklos@szeredi.hu>, linux-unionfs@vger.kernel.org, fstests@vger.kernel.org
List-ID: <linux-unionfs@vger.kernel.org>

On Tue, May 28, 2019 at 06:17:22PM +0300, Amir Goldstein wrote:
> From: "zhangyi (F)" <yi.zhang@huawei.com>
> 
> fsck.overlay should return correct exit code to show the file system
> status after fsck, instead of return 0 means consistency and !0 means
> inconsistency or something bad happened.
> 
> Fix the following three exit code after running fsck.overlay:
> 
> - Return FSCK_OK if the input file system is consistent,
> - Return FSCK_NONDESTRUCT if the file system inconsistent errors
>   corrected,
> - Return FSCK_UNCORRECTED if the file system still have inconsistent
>   errors.
> 
> This patch also add a helper function to run fsck.overlay and check
> the return value is expected or not.
> 
> [amir] rename helper to _overlay_fsck_expect, split define of FSCK_*
> to a seprate path.
> 
> Signed-off-by: zhangyi (F) <yi.zhang@huawei.com>
> Signed-off-by: Amir Goldstein <amir73il@gmail.com>
> ---
>  common/overlay    | 19 +++++++++++++++++++
>  tests/overlay/045 | 27 +++++++++------------------
>  tests/overlay/046 | 36 ++++++++++++------------------------
>  tests/overlay/056 |  9 +++------
>  4 files changed, 43 insertions(+), 48 deletions(-)
> 
> diff --git a/common/overlay b/common/overlay
> index a71c2035..53e35caf 100644
> --- a/common/overlay
> +++ b/common/overlay
> @@ -193,6 +193,25 @@ _overlay_fsck_dirs()
>  			   -o workdir=$workdir $*
>  }
>  
> +# Run fsck and check for expected return value
> +_overlay_fsck_expect()
> +{
> +	# The first arguments is the expected fsck program exit code, the
> +	# remaining arguments are the input parameters of the fsck program.
> +	local expect_ret=$1
> +	local lowerdir=$2
> +	local upperdir=$3
> +	local workdir=$4
> +	shift 4
> +
> +	_overlay_fsck_dirs $lowerdir $upperdir $workdir $* >> \
> +			$seqres.full 2>&1
> +	fsck_ret=$?
> +
> +	[[ "$fsck_ret" == "$expect_ret" ]] || \
> +		echo "fsck return unexpected value:$expect_ret,$fsck_ret"

This statement looks ambiguous, it's not that clear which return value
is expected and which is unexpected. I'd like to change it to something
like:

"expect fsck.overlay to return $expect_ret, but got $fsck_ret"

I can fix it on commit if you're OK with this change.

Thanks,
Eryu

> +}
> +
>  _overlay_check_dirs()
>  {
>  	local lowerdir=$1
> diff --git a/tests/overlay/045 b/tests/overlay/045
> index acc70871..6b5e8ae4 100755
> --- a/tests/overlay/045
> +++ b/tests/overlay/045
> @@ -96,8 +96,7 @@ echo "+ Orphan whiteout"
>  make_test_dirs
>  make_whiteout $lowerdir/foo $upperdir/{foo,bar}
>  
> -_overlay_fsck_dirs $lowerdir $upperdir $workdir -p >> $seqres.full 2>&1 || \
> -	echo "fsck should not fail"
> +_overlay_fsck_expect $FSCK_NONDESTRUCT $lowerdir $upperdir $workdir -p
>  ls $lowerdir
>  ls $upperdir
>  
> @@ -107,8 +106,7 @@ make_test_dirs
>  touch $lowerdir2/{foo,bar}
>  make_whiteout $upperdir/foo $lowerdir/bar
>  
> -_overlay_fsck_dirs "$lowerdir:$lowerdir2" $upperdir $workdir -p >> \
> -	 $seqres.full 2>&1 || echo "fsck should not fail"
> +_overlay_fsck_expect $FSCK_OK "$lowerdir:$lowerdir2" $upperdir $workdir -p
>  check_whiteout $upperdir/foo $lowerdir/bar
>  
>  # Test orphan whiteout in opaque directory, should remove
> @@ -119,8 +117,7 @@ touch $lowerdir/testdir/foo
>  make_opaque_dir $upperdir/testdir
>  make_whiteout $upperdir/testdir/foo
>  
> -_overlay_fsck_dirs $lowerdir $upperdir $workdir -p >> $seqres.full 2>&1 || \
> -	echo "fsck should not fail"
> +_overlay_fsck_expect $FSCK_NONDESTRUCT $lowerdir $upperdir $workdir -p
>  ls $upperdir/testdir
>  
>  # Test orphan whiteout whose parent path is not an merged directory,
> @@ -135,8 +132,7 @@ make_whiteout $lowerdir/testdir2
>  make_opaque_dir $lowerdir/testdir3
>  make_whiteout $upperdir/{testdir1/foo,/testdir2/foo,testdir3/foo,testdir4/foo}
>  
> -_overlay_fsck_dirs "$lowerdir:$lowerdir2" $upperdir $workdir -p >> \
> -	$seqres.full 2>&1 || echo "fsck should not fail"
> +_overlay_fsck_expect $FSCK_NONDESTRUCT "$lowerdir:$lowerdir2" $upperdir $workdir -p
>  ls $upperdir/testdir1
>  ls $upperdir/testdir2
>  ls $upperdir/testdir3
> @@ -150,8 +146,7 @@ touch $lowerdir/testdir/foo
>  make_redirect_dir $upperdir/testdir "origin"
>  make_whiteout $upperdir/testdir/foo
>  
> -_overlay_fsck_dirs $lowerdir $upperdir $workdir -p >> $seqres.full 2>&1 || \
> -	echo "fsck should not fail"
> +_overlay_fsck_expect $FSCK_NONDESTRUCT $lowerdir $upperdir $workdir -p
>  ls $upperdir/testdir
>  
>  # Test valid whiteout in redirect directory cover file in lower
> @@ -163,8 +158,7 @@ touch $lowerdir/origin/foo
>  make_redirect_dir $upperdir/testdir "origin"
>  make_whiteout $upperdir/testdir/foo
>  
> -_overlay_fsck_dirs $lowerdir $upperdir $workdir -p >> $seqres.full 2>&1 || \
> -	echo "fsck should not fail"
> +_overlay_fsck_expect $FSCK_OK $lowerdir $upperdir $workdir -p
>  check_whiteout $upperdir/testdir/foo
>  
>  # Test valid whiteout covering lower target whose parent directory
> @@ -177,8 +171,7 @@ make_redirect_dir $lowerdir/testdir "origin"
>  mkdir -p $upperdir/testdir/subdir
>  make_whiteout $upperdir/testdir/subdir/foo
>  
> -_overlay_fsck_dirs "$lowerdir:$lowerdir2" $upperdir $workdir -p \
> -	>> $seqres.full 2>&1 || echo "fsck should not fail"
> +_overlay_fsck_expect $FSCK_OK "$lowerdir:$lowerdir2" $upperdir $workdir -p
>  check_whiteout $upperdir/testdir/subdir/foo
>  
>  # Test invalid whiteout in opaque subdirectory in a redirect directory,
> @@ -191,8 +184,7 @@ make_redirect_dir $upperdir/testdir "origin"
>  make_opaque_dir $upperdir/testdir/subdir
>  make_whiteout $upperdir/testdir/subdir/foo
>  
> -_overlay_fsck_dirs $lowerdir $upperdir $workdir -p >> $seqres.full 2>&1 || \
> -	echo "fsck should not fail"
> +_overlay_fsck_expect $FSCK_NONDESTRUCT $lowerdir $upperdir $workdir -p
>  ls $upperdir/testdir/subdir
>  
>  # Test valid whiteout in reidrect subdirectory in a opaque directory
> @@ -205,8 +197,7 @@ make_opaque_dir $upperdir/testdir
>  make_redirect_dir $upperdir/testdir/subdir "/origin"
>  make_whiteout $upperdir/testdir/subdir/foo
>  
> -_overlay_fsck_dirs $lowerdir $upperdir $workdir -p >> $seqres.full 2>&1 || \
> -        echo "fsck should not fail"
> +_overlay_fsck_expect $FSCK_OK $lowerdir $upperdir $workdir -p
>  check_whiteout $upperdir/testdir/subdir/foo
>  
>  # success, all done
> diff --git a/tests/overlay/046 b/tests/overlay/046
> index 6338a383..4a9ee68f 100755
> --- a/tests/overlay/046
> +++ b/tests/overlay/046
> @@ -121,8 +121,7 @@ echo "+ Invalid redirect"
>  make_test_dirs
>  make_redirect_dir $upperdir/testdir "invalid"
>  
> -_overlay_fsck_dirs $lowerdir $upperdir $workdir -p >> $seqres.full 2>&1 || \
> -	echo "fsck should not fail"
> +_overlay_fsck_expect $FSCK_NONDESTRUCT $lowerdir $upperdir $workdir -p
>  check_no_redirect $upperdir/testdir
>  
>  # Test invalid redirect xattr point to a file origin, should remove
> @@ -131,8 +130,7 @@ make_test_dirs
>  touch $lowerdir/origin
>  make_redirect_dir $upperdir/testdir "origin"
>  
> -_overlay_fsck_dirs $lowerdir $upperdir $workdir -p >> $seqres.full 2>&1 || \
> -	echo "fsck should not fail"
> +_overlay_fsck_expect $FSCK_NONDESTRUCT $lowerdir $upperdir $workdir -p
>  check_no_redirect $upperdir/testdir
>  
>  # Test valid redirect xattr point to a directory origin in the same directory,
> @@ -143,8 +141,7 @@ mkdir $lowerdir/origin
>  make_whiteout $upperdir/origin
>  make_redirect_dir $upperdir/testdir "origin"
>  
> -_overlay_fsck_dirs $lowerdir $upperdir $workdir -p >> $seqres.full 2>&1 || \
> -	echo "fsck should not fail"
> +_overlay_fsck_expect $FSCK_OK $lowerdir $upperdir $workdir -p
>  check_redirect $upperdir/testdir "origin"
>  
>  # Test valid redirect xattr point to a directory origin in different directories
> @@ -155,8 +152,7 @@ mkdir $lowerdir/origin
>  make_whiteout $upperdir/origin
>  make_redirect_dir $upperdir/testdir1/testdir2 "/origin"
>  
> -_overlay_fsck_dirs $lowerdir $upperdir $workdir -p >> $seqres.full 2>&1 || \
> -	echo "fsck should not fail"
> +_overlay_fsck_expect $FSCK_OK $lowerdir $upperdir $workdir -p
>  check_redirect $upperdir/testdir1/testdir2 "/origin"
>  
>  # Test valid redirect xattr but missing whiteout to cover lower target,
> @@ -166,8 +162,7 @@ make_test_dirs
>  mkdir $lowerdir/origin
>  make_redirect_dir $upperdir/testdir "origin"
>  
> -_overlay_fsck_dirs $lowerdir $upperdir $workdir -p >> $seqres.full 2>&1 || \
> -	echo "fsck should not fail"
> +_overlay_fsck_expect $FSCK_NONDESTRUCT $lowerdir $upperdir $workdir -p
>  check_redirect $upperdir/testdir "origin"
>  check_whiteout $upperdir/origin
>  
> @@ -178,8 +173,7 @@ mkdir $lowerdir/{testdir1,testdir2}
>  make_redirect_dir $upperdir/testdir1 "testdir2"
>  make_redirect_dir $upperdir/testdir2 "testdir1"
>  
> -_overlay_fsck_dirs $lowerdir $upperdir $workdir -p >> $seqres.full 2>&1 || \
> -	echo "fsck should not fail"
> +_overlay_fsck_expect $FSCK_OK $lowerdir $upperdir $workdir -p
>  check_redirect $upperdir/testdir1 "testdir2"
>  check_redirect $upperdir/testdir2 "testdir1"
>  
> @@ -191,8 +185,7 @@ mkdir $lowerdir/testdir
>  make_redirect_dir $upperdir/testdir "invalid"
>  
>  # Question get yes answer: Should set opaque dir ?
> -_overlay_fsck_dirs $lowerdir $upperdir $workdir -y >> $seqres.full 2>&1 || \
> -	echo "fsck should not fail"
> +_overlay_fsck_expect $FSCK_NONDESTRUCT $lowerdir $upperdir $workdir -y
>  check_no_redirect $upperdir/testdir
>  check_opaque $upperdir/testdir
>  
> @@ -205,12 +198,10 @@ make_redirect_dir $lowerdir/testdir1 "origin"
>  make_redirect_dir $lowerdir/testdir2 "origin"
>  make_redirect_dir $upperdir/testdir3 "origin"
>  
> -_overlay_fsck_dirs "$lowerdir:$lowerdir2" $upperdir $workdir -p >> \
> -	$seqres.full 2>&1 && echo "fsck should fail"
> +_overlay_fsck_expect $FSCK_UNCORRECTED "$lowerdir:$lowerdir2" $upperdir $workdir -p
>  
>  # Question get yes answer: Duplicate redirect directory, remove xattr ?
> -_overlay_fsck_dirs "$lowerdir:$lowerdir2" $upperdir $workdir -y >> \
> -	$seqres.full 2>&1 || echo "fsck should not fail"
> +_overlay_fsck_expect $FSCK_NONDESTRUCT "$lowerdir:$lowerdir2" $upperdir $workdir -y
>  redirect_1=`check_redirect $lowerdir/testdir1 "origin" 2>/dev/null`
>  redirect_2=`check_redirect $lowerdir/testdir2 "origin" 2>/dev/null`
>  [[ $redirect_1 == $redirect_2 ]] && echo "Redirect xattr incorrect"
> @@ -223,12 +214,10 @@ make_test_dirs
>  mkdir $lowerdir/origin $upperdir/origin
>  make_redirect_dir $upperdir/testdir "origin"
>  
> -_overlay_fsck_dirs $lowerdir $upperdir $workdir -p >> $seqres.full 2>&1 && \
> -	echo "fsck should fail"
> +_overlay_fsck_expect $FSCK_UNCORRECTED $lowerdir $upperdir $workdir -p
>  
>  # Question get yes answer: Duplicate redirect directory, remove xattr ?
> -_overlay_fsck_dirs $lowerdir $upperdir $workdir -y >> $seqres.full 2>&1 || \
> -	echo "fsck should not fail"
> +_overlay_fsck_expect $FSCK_NONDESTRUCT $lowerdir $upperdir $workdir -y
>  check_no_redirect $upperdir/testdir
>  
>  # Test duplicate redirect xattr with lower same name directory exists,
> @@ -240,8 +229,7 @@ make_redirect_dir $upperdir/testdir "invalid"
>  
>  # Question one get yes answer: Duplicate redirect directory, remove xattr?
>  # Question two get yes answer: Should set opaque dir ?
> -_overlay_fsck_dirs $lowerdir $upperdir $workdir -y >> $seqres.full 2>&1 || \
> -	echo "fsck should not fail"
> +_overlay_fsck_expect $FSCK_NONDESTRUCT $lowerdir $upperdir $workdir -y
>  check_no_redirect $upperdir/testdir
>  check_opaque $upperdir/testdir
>  
> diff --git a/tests/overlay/056 b/tests/overlay/056
> index 44ffb54a..dc7b98cb 100755
> --- a/tests/overlay/056
> +++ b/tests/overlay/056
> @@ -96,8 +96,7 @@ $UMOUNT_PROG $SCRATCH_MNT
>  remove_impure $upperdir/testdir1
>  remove_impure $upperdir/testdir2
>  
> -_overlay_fsck_dirs $lowerdir $upperdir $workdir -p >> $seqres.full 2>&1 || \
> -	echo "fsck should not fail"
> +_overlay_fsck_expect $FSCK_NONDESTRUCT $lowerdir $upperdir $workdir -p
>  check_impure $upperdir/testdir1
>  check_impure $upperdir/testdir2
>  
> @@ -108,8 +107,7 @@ make_test_dirs
>  mkdir $lowerdir/origin
>  make_redirect_dir $upperdir/testdir/subdir "/origin"
>  
> -_overlay_fsck_dirs $lowerdir $upperdir $workdir -p >> $seqres.full 2>&1 || \
> -	echo "fsck should not fail"
> +_overlay_fsck_expect $FSCK_NONDESTRUCT $lowerdir $upperdir $workdir -p
>  check_impure $upperdir/testdir
>  
>  # Test missing impure xattr in directory which has merge directories,
> @@ -118,8 +116,7 @@ echo "+ Missing impure(3)"
>  make_test_dirs
>  mkdir $lowerdir/testdir $upperdir/testdir
>  
> -_overlay_fsck_dirs $lowerdir $upperdir $workdir -p >> $seqres.full 2>&1 || \
> -	echo "fsck should not fail"
> +_overlay_fsck_expect $FSCK_NONDESTRUCT $lowerdir $upperdir $workdir -p
>  check_impure $upperdir
>  
>  # success, all done
> -- 
> 2.17.1
> 
