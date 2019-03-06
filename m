Return-Path: <guaneryu@gmail.com>
Return-Path: <guaneryu@gmail.com>
Date: Wed, 6 Mar 2019 20:28:26 +0800
From: Eryu Guan <guaneryu@gmail.com>
Subject: Re: [PATCH v2 1/2] fstests: Add more sanity to seek_sanity_test
Message-ID: <20190306122826.GH2824@desktop>
References: <20190303150940.12734-1-amir73il@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190303150940.12734-1-amir73il@gmail.com>
To: Amir Goldstein <amir73il@gmail.com>
Cc: Miklos Szeredi <miklos@szeredi.hu>, Eddie Horng <eddiehorng.tw@gmail.com>, linux-unionfs@vger.kernel.org, fstests@vger.kernel.org
List-ID: <linux-unionfs@vger.kernel.org>

On Sun, Mar 03, 2019 at 05:09:39PM +0200, Amir Goldstein wrote:
> seek_sanity_test checks for one of several SEEK_DATA/HOLE
> behaviors and allows for the default behavior of filesystems,
> where SEEK_HOLE always returns EOF.
> 
> This means that if filesystem has a regression in finding
> holes, the sanity test won't catch it. And indeed this regression
> happened in overlayfs on kernel v4.19 and went unnoticed.
> 
> To improve test coverage, add a flag -f to seek_sanity_test to
> indicate that the default behavior is not acceptable.
> Whitelist all filesystem types that are expected to detect holes
> and use wrapper when invoking seek_sanity_test to add the -f flag
> to those filesystems.
> 
> Overlayfs inherits expected behavior from base fs type.
> 
> Signed-off-by: Amir Goldstein <amir73il@gmail.com>
> ---
> 
> Eryu,
> 
> After this change, the generic/seek group tests will start
> failing with overlayfs over base fs with true SEEK_HOLE support
> on upstream kernel.
> 
> We had missing coverage of SEEK_HOLE, so we missed a regression
> in kernel v4.19 when overlayfs SEEK_HOLE stopped finding holes
> in sparse files.
> 
> Thanks,
> Amir.
> 
> Changes since v1:
> - Use whitelist of filesystems types that support true SEEK_HOLE
>   instead of inferring SEEK_HOLE support from PUNCH_HOLE support
> - Split from patch of new PUNCH_HOLE+SEEK_HOLE test
> 
>  common/rc              | 46 ++++++++++++++++++++++++++++++++++++++++++
>  src/seek_sanity_test.c | 14 +++++++++++--
>  tests/generic/285      |  2 +-
>  tests/generic/436      |  2 +-
>  tests/generic/445      |  2 +-
>  tests/generic/448      |  2 +-
>  tests/generic/490      |  2 +-
>  7 files changed, 63 insertions(+), 7 deletions(-)
> 
> diff --git a/common/rc b/common/rc
> index c88c304c..d2482c20 100644
> --- a/common/rc
> +++ b/common/rc
> @@ -2298,6 +2298,52 @@ _ext4_disable_extent_zeroout()
>  		echo 0 >/sys/fs/ext4/$sdev/extent_max_zeroout_kb
>  }
>  
> +# Is this filesystem type expected to support seeking and finding holes?
> +# filesystems without SEEK_HOLE support, accept the SEEK_HOLE argument,
> +# but always return EOF offset for SEEK_HOLE.
> +# We use this whitelist FSTYP, to set expectation and avoid silent
> +# regression of filesystem seek hole behavior.

I don't think this description is that accurate, we're not checking if
the fs supports SEEK_HOLE or not, but checking if it supports
non-default behavior of SEEK_HOLE, where SEEK_HOLE always returns EOF.

> +#
> +# Return 0 for true
> +_fstyp_support_seek_data_hole()

So I think the function should be renamed too, but I couldn't come up
with a better name.. _fstyp_has_non_default_seek_data_hole ?

> +{
> +	if [ -z $1 ]; then
> +		local fstyp=$FSTYP
> +	else
> +		local fstyp=$1
> +	fi
> +
> +	case "$fstyp" in
> +	btrfs|ext4|xfs|ceph|cifs|f2fs|gfs2|nfs*|ocfs2|tmpfs)
> +		return 0
> +		;;
> +	overlay)
> +		if [ ! -z $OVL_BASE_FSTYP -a $OVL_BASE_FSTYP != "overlay" ]; then
> +			_fstyp_support_seek_data_hole $OVL_BASE_FSTYP
> +			return $?
> +		else
> +			# Do not assume that base fs supports SEEK_HOLE
> +			return 1
> +		fi
> +		;;
> +	*)
> +		# by default fstyp does not support SEEK_HOLE;
> +		# if your fs does support SEEK_HOLE, add it to whitelist above!
> +		return 1
> +		;;
> +	esac
> +}
> +
> +# Run seek sanity test with predefined expectation for SEEK_DATA/HOLE behavior
> +_run_seek_sanity_test()
> +{
> +	local testseekargs
> +	if _fstyp_support_seek_data_hole; then
> +		testseekargs+="-f"
> +	fi
> +	$here/src/seek_sanity_test $testseekargs $*
> +}
> +
>  # Check if the file system supports seek_data/hole
>  _require_seek_data_hole()
>  {
> diff --git a/src/seek_sanity_test.c b/src/seek_sanity_test.c
> index e9938d1b..1eefc74d 100644
> --- a/src/seek_sanity_test.c
> +++ b/src/seek_sanity_test.c
> @@ -23,6 +23,7 @@
>  #endif
>  
>  static blksize_t alloc_size;
> +int allow_default_behavior = 1;
>  int default_behavior = 0;
>  int unwritten_extents = 0;
>  char *base_file_path;
> @@ -1115,6 +1116,12 @@ static int test_basic_support(void)
>  	}
>  
>  	if (pos == filsz) {
> +		if (!allow_default_behavior) {
> +			fprintf(stderr, "File syste does not support llseek(2) extension "
                                              ^^^^^ system
> +				"SEEK_HOLE. Aborting.\n");
> +			ret = -1;
> +			goto out;
> +		}

I'd prefer putting this check after the checking 'default_behavior'
block.

>  		default_behavior = 1;
>  		fprintf(stderr, "File system supports the default behavior.\n");
>  	}

i.e. here:

	if (default_behavior && !allow_default_behavior) {
		fprintf(stderr, "Default behavior is not allowed. Aborting.\n");
		ret = -1;
		got out;
	}

Thanks,
Eryu

> @@ -1148,7 +1155,7 @@ out:
>  
>  void usage(char *cmd)
>  {
> -	fprintf(stdout, "Usage: %s [-t] [-s <starttest>] [-e <endtest>] base_file_path\n", cmd);
> +	fprintf(stdout, "Usage: %s [-tf] [-s <starttest>] [-e <endtest>] base_file_path\n", cmd);
>  	exit(1);
>  }
>  
> @@ -1169,11 +1176,14 @@ int main(int argc, char **argv)
>  	teststart = 1;
>  	testend = 12;
>  
> -	while ((opt = getopt(argc, argv, "ts:e:")) != -1) {
> +	while ((opt = getopt(argc, argv, "tfs:e:")) != -1) {
>  		switch (opt) {
>  		case 't':
>  			check_support++;
>  			break;
> +		case 'f':
> +			allow_default_behavior = 0;
> +			break;
>  		case 's':
>  			teststart = strtol(optarg, NULL, 10);
>  			if (teststart <= 0 || teststart > numtests) {
> diff --git a/tests/generic/285 b/tests/generic/285
> index b53b3acc..20e89e5b 100755
> --- a/tests/generic/285
> +++ b/tests/generic/285
> @@ -37,7 +37,7 @@ _cleanup()
>  	eval "rm -f $BASE_TEST_FILE.*"
>  }
>  
> -$here/src/seek_sanity_test $BASE_TEST_FILE > $seqres.full 2>&1 ||
> +_run_seek_sanity_test $BASE_TEST_FILE > $seqres.full 2>&1 ||
>  	_fail "seek sanity check failed!"
>  
>  # success, all done
> diff --git a/tests/generic/436 b/tests/generic/436
> index a3ef70e5..ada60b2e 100755
> --- a/tests/generic/436
> +++ b/tests/generic/436
> @@ -36,7 +36,7 @@ _cleanup()
>  	rm -f $tmp.* $BASE_TEST_FILE.*
>  }
>  
> -$here/src/seek_sanity_test -s 13 -e 16 $BASE_TEST_FILE > $seqres.full 2>&1 ||
> +_run_seek_sanity_test -s 13 -e 16 $BASE_TEST_FILE > $seqres.full 2>&1 ||
>  	_fail "seek sanity check failed!"
>  
>  # success, all done
> diff --git a/tests/generic/445 b/tests/generic/445
> index 694913ae..248f321b 100755
> --- a/tests/generic/445
> +++ b/tests/generic/445
> @@ -36,7 +36,7 @@ _cleanup()
>  	rm -f $tmp.* $BASE_TEST_FILE.*
>  }
>  
> -$here/src/seek_sanity_test -s 17 -e 17 $BASE_TEST_FILE > $seqres.full 2>&1 ||
> +_run_seek_sanity_test -s 17 -e 17 $BASE_TEST_FILE > $seqres.full 2>&1 ||
>  	_fail "seek sanity check failed!"
>  
>  # success, all done
> diff --git a/tests/generic/448 b/tests/generic/448
> index d3ec5528..dada499b 100755
> --- a/tests/generic/448
> +++ b/tests/generic/448
> @@ -34,7 +34,7 @@ BASE_TEST_FILE=$TEST_DIR/seek_sanity_testfile_$seq
>  
>  _require_test_program "seek_sanity_test"
>  
> -$here/src/seek_sanity_test -s 18 -e 18 $BASE_TEST_FILE > $seqres.full 2>&1 ||
> +_run_seek_sanity_test -s 18 -e 18 $BASE_TEST_FILE > $seqres.full 2>&1 ||
>  	_fail "seek sanity check failed!"
>  
>  _check_dmesg
> diff --git a/tests/generic/490 b/tests/generic/490
> index 330c2b60..07b08939 100755
> --- a/tests/generic/490
> +++ b/tests/generic/490
> @@ -39,7 +39,7 @@ _cleanup()
>  	rm -f $base_test_file*
>  }
>  
> -$here/src/seek_sanity_test -s 19 -e 20 $base_test_file > $seqres.full 2>&1 ||
> +_run_seek_sanity_test -s 19 -e 20 $base_test_file > $seqres.full 2>&1 ||
>  	_fail "seek sanity check failed!"
>  
>  # success, all done
> -- 
> 2.17.1
> 
