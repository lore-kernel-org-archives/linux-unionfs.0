From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH] overlay: test permission checks within upper layer
Date: Tue, 2 Feb 2016 15:06:35 +1100
Message-ID: <20160202040635.GB31407@dastard>
References: <145427548927.28315.7391257381640174593.stgit@zurg>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <fstests-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <145427548927.28315.7391257381640174593.stgit@zurg>
Sender: fstests-owner@vger.kernel.org
To: Konstantin Khlebnikov <koct9i@gmail.com>
Cc: fstests@vger.kernel.org, Miklos Szeredi <miklos@szeredi.hu>, Eryu Guan <eguan@redhat.com>, linux-unionfs@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org

On Mon, Feb 01, 2016 at 12:24:49AM +0300, Konstantin Khlebnikov wrote:
> Verify that unpriveleged user cannot copy-up and change file mode.
> 
> Signed-off-by: Konstantin Khlebnikov <koct9i@gmail.com>
> ---
>  tests/overlay/001     |   87 +++++++++++++++++++++++++++++++++++++++++++++++++
>  tests/overlay/001.out |    2 +
>  tests/overlay/group   |    6 +++

Needs a makefile in tests/overlay. Copying one from the other test
directories will probably be fine.

> +_cleanup()
> +{
> +	cd /
> +	rm -f $tmp.*
> +	rm -fr $TEST_DEV/lower/$seq.dir
> +	rm -fr $TEST_DEV/upper/$seq.dir
> +}

Don't we have global variables for upper/lower/working directories
now?

> +echo "Silence is golden."
> +
> +[ -x $runas ] || _notrun "$runas executable not found"
> +
> +cd $TEST_DEV/lower
> +mkdir $seq.dir
> +touch $seq.dir/file
> +chmod 444 $seq.dir/file
> +
> +cd $TEST_DEV/upper
> +mkdir $seq.dir
> +chmod 555 $seq.dir
> +
> +cd $TEST_DIR
> +$runas -u 99 -g 99 chmod 777 $seq.dir/file >/dev/null 2>&1
> +
> +cd $TEST_DEV/upper
> +if [ -e $seq.dir/file ] ; then
> +	echo "FAIL: unpriveleged user copied-up file into upper"
> +	if [ `stat -c '%a' $seq.dir/file` != 444 ] ; then
> +		echo "FAIL: unpriveleged user changed file attributes"
> +	fi
> +fi

Just running stat -c '%a' $seq.dir/file and having the output dump
into the output file is sufficient here. One would expect to see
a "stat: cannot stat 'foo': No such file or directory" error
as the correct output.

i.e. silence is not the expected output - an error is the expected
output...

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
