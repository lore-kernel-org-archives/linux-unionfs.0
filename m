From: Eryu Guan <eguan@redhat.com>
Subject: Re: [PATCH] overlay: check visible whiteouts in pure-upper directory
Date: Tue, 2 Feb 2016 12:12:00 +0800
Message-ID: <20160202041200.GC11419@eguan.usersys.redhat.com>
References: <145427549775.28346.2363708034750122757.stgit@zurg>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <fstests-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <145427549775.28346.2363708034750122757.stgit@zurg>
Sender: fstests-owner@vger.kernel.org
To: Konstantin Khlebnikov <koct9i@gmail.com>
Cc: fstests@vger.kernel.org, Miklos Szeredi <miklos@szeredi.hu>, linux-unionfs@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org

On Mon, Feb 01, 2016 at 12:24:57AM +0300, Konstantin Khlebnikov wrote:
> Moving non-pure file into pure-upper directory and removing it here
> leaves visible whiteout.
> 
> Signed-off-by: Konstantin Khlebnikov <koct9i@gmail.com>
> ---
>  tests/overlay/002     |   71 +++++++++++++++++++++++++++++++++++++++++++++++++
>  tests/overlay/002.out |    2 +
>  tests/overlay/group   |    1 +
>  3 files changed, 74 insertions(+)
>  create mode 100755 tests/overlay/002
>  create mode 100644 tests/overlay/002.out
> 
> diff --git a/tests/overlay/002 b/tests/overlay/002
> new file mode 100755
> index 000000000000..30b2b5561fce
> --- /dev/null
> +++ b/tests/overlay/002
> @@ -0,0 +1,71 @@
> +#! /bin/bash
> +# FS QA Test 002
> +#
> +# Visible whiteouts in pure-upper directory
> +#
> +# https://bugzilla.kernel.org/show_bug.cgi?id=109611
> +# https://github.com/docker/docker/issues/9572
> +#
> +#-----------------------------------------------------------------------
> +# Copyright (c) 2016 Konstantin Khlebnikov.  All Rights Reserved.
> +#
> +# This program is free software; you can redistribute it and/or
> +# modify it under the terms of the GNU General Public License as
> +# published by the Free Software Foundation.
> +#
> +# This program is distributed in the hope that it would be useful,
> +# but WITHOUT ANY WARRANTY; without even the implied warranty of
> +# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
> +# GNU General Public License for more details.
> +#
> +# You should have received a copy of the GNU General Public License
> +# along with this program; if not, write the Free Software Foundation,
> +# Inc.,  51 Franklin St, Fifth Floor, Boston, MA  02110-1301  USA
> +#-----------------------------------------------------------------------
> +#
> +
> +seq=`basename $0`
> +seqres=$RESULT_DIR/$seq
> +echo "QA output created by $seq"
> +
> +here=`pwd`
> +tmp=/tmp/$$
> +status=1	# failure is the default!
> +trap "_cleanup; exit \$status" 0 1 2 3 15
> +
> +_cleanup()
> +{
> +	cd /
> +	rm -f $tmp.*
> +	rm -fr $TEST_DEV/upper/$seq.pure
> +	rm -fr $TEST_DEV/upper/$seq.file
> +	rm -fr $TEST_DEV/lower/$seq.file
> +}
> +
> +# get standard environment, filters and checks
> +. ./common/rc
> +. ./common/filter
> +
> +# remove previous $seqres.full before test
> +rm -f $seqres.full
> +
> +# real QA test starts here
> +
> +# Modify as appropriate.
> +_supported_fs overlay
> +_supported_os Linux
> +_require_test
> +
> +echo "Silence is golden."
> +
> +touch $TEST_DEV/lower/$seq.file

Pretty much the same comments as in previous patch, test on SCRATCH_DEV
and change underlying fs while overlay is not mounted and use exported
variables not hard-coded "upper" "lower".

> +
> +cd $TEST_DIR
> +mkdir $seq.pure
> +mv $seq.file $seq.pure
> +rm $seq.pure/$seq.file
> +ls $seq.pure

I think "ls -l" could show the failure more obvious, by "ls -l" I see

+ls: cannot access 002.pure/002.file: No such file or directory
+total 0
+?????????? ? ? ? ?            ? 002.file

and a simple ls only shows

+002.file

Thanks,
Eryu

> +
> +# success, all done
> +status=0
> +exit
> diff --git a/tests/overlay/002.out b/tests/overlay/002.out
> new file mode 100644
> index 000000000000..c1642bfddbae
> --- /dev/null
> +++ b/tests/overlay/002.out
> @@ -0,0 +1,2 @@
> +QA output created by 002
> +Silence is golden.
> diff --git a/tests/overlay/group b/tests/overlay/group
> index 51a62cf64b89..877b5d2d6add 100644
> --- a/tests/overlay/group
> +++ b/tests/overlay/group
> @@ -4,3 +4,4 @@
>  # do not start group name with a digit
>  #
>  001 perms auto quick
> +002 auto quick metadata
> 
