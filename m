From: "zhangyi (F)" <yi.zhang@huawei.com>
Subject: Re: [PATCH xfstest v2 3/4] overlay: add fsck.overlay redirect
 directory test
Date: Fri, 29 Dec 2017 09:49:30 +0800
Message-ID: <b31b47ee-4edc-88ea-b7df-e308f396318d@huawei.com>
References: <20171228114933.47759-1-yi.zhang@huawei.com>
 <20171228114933.47759-4-yi.zhang@huawei.com>
 <CAOQ4uxiyAj7+UmFMW7eP+HeeZuH6pWxCLKd5WKtc53b77ZihoQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <fstests-owner@vger.kernel.org>
In-Reply-To: <CAOQ4uxiyAj7+UmFMW7eP+HeeZuH6pWxCLKd5WKtc53b77ZihoQ@mail.gmail.com>
Sender: fstests-owner@vger.kernel.org
To: Amir Goldstein <amir73il@gmail.com>
Cc: overlayfs <linux-unionfs@vger.kernel.org>, fstests <fstests@vger.kernel.org>, Miklos Szeredi <miklos@szeredi.hu>, Eryu Guan <eguan@redhat.com>, Miao Xie <miaoxie@huawei.com>, yangerkun@huawei.com
List-Id: linux-unionfs@vger.kernel.org

On 2017/12/28 20:37, Amir Goldstein Wrote:
> On Thu, Dec 28, 2017 at 1:49 PM, zhangyi (F) <yi.zhang@huawei.com> wrote:
>> Add fsck.overlay test case to test it how to deal with invalid/valid/
>> duplicate redirect xattr in underlying directories of overlayfs.
>>
>> Signed-off-by: zhangyi (F) <yi.zhang@huawei.com>
> 
> Nice. See suggestions to improve.

Thanks for your suggestions!

[..]
>> +# Check redirect xattr
>> +check_redirect()
>> +{
>> +       local expect=$1
>> +       local target=$2
> 
> Suggest to flip target/expect order to match target/value order in
> make_redirect_dir
> Then for the tests that expect empty redirect call check_redirect with
> empty expect,
> e.g. check_redirect $upperdir/testdir ""
> of course "" is not strictly needed, but may be more readable
> Even better use helper check_not_redirect() to do that

I prefer check_not_redirect(), will change it.

>> +
>> +       value=$($GETFATTR_PROG --absolute-names --only-values \
>> +               -n $OVL_REDIRECT_XATTR $target)
>> +
>> +       [[ $value == $expect ]] || echo "Redirect xattr incorrect"
>> +}
>> +
>> +# Check opaque xattr
>> +check_opaque()
>> +{
>> +       local target=$1
> 
> Here too, I suggest:
>        local expect=${2-$OVL_OPAQUE_XATTR_VAL}
> 
> And then tests can either call check_opaque $target "" or add a helper
> check_not_opaque() to do that
> 

[..]
>> +# Create test directories
>> +lowerdir=$OVL_BASE_SCRATCH_MNT/lower
>> +lowerdir2=$OVL_BASE_SCRATCH_MNT/lower2
>> +upperdir=$OVL_BASE_SCRATCH_MNT/upper
>> +workdir=$OVL_BASE_SCRATCH_MNT/workdir
>> +
>> +mkdir -p $lowerdir $lowerdir2 $upperdir $workdir $workdir
> 
> Again, suggest make_dirs helper with rm -rf before and drop
> all individual rm -rf after tests.
> 
Will change.

[..]
>> +# Test valid redirect xattr with general directory cover lower origin
>> +# target, should ask user this directory is merged or not by default
>> +# and do nothing in auto mode
>> +echo "+ Valid redirect(4)"
>> +mkdir $lowerdir/origin
>> +mkdir $upperdir/origin
>> +make_redirect_dir $upperdir/testdir "origin"
>> +
>> +_overlay_fsck_dirs $lowerdir $upperdir $workdir -p >> $seqres.full 2>&1 || \
>> +       _fail "fsck should not fail"
>> +check_redirect "origin" $upperdir/testdir
>> +$GETFATTR_PROG --absolute-names -d -m $OVL_OPAQUE_XATTR $upperdir/testdir
>> +
>> +echo "n" > $tmp.input
> 
> This approach seems a bit fragile to me.
> Maybe you will want to add some questions in the future.
> To me it makes better sense to check behavior of fsck -y is automated test,
> because some user who does not understand the questions is surely going
> to run fsck -y to fix problems.
> 
Yes, for ordinary users, they are more likely to use -p or -y, this input
will also increase workload in future, is not really necessary, will remove.

>> +_overlay_fsck_dirs $lowerdir $upperdir $workdir <$tmp.input >> $seqres.full 2>&1 || \
>> +       _fail "fsck should not fail"
>> +check_redirect "origin" $upperdir/testdir
>> +check_opaque $upperdir/origin
>> +rm -rf $lowerdir/* $upperdir/*
>> +
>> +# Test invalid redirect xattr with lower same name directory exists,
>> +# should remove invalid xattr, and ask user directory merge or not
>> +# by default
>> +echo "+ Invalid redirect(3)"
>> +mkdir $lowerdir/testdir
>> +make_redirect_dir $upperdir/testdir "origin"
>> +
>> +echo "y" > $tmp.input
>> +echo "n" >> $tmp.input
> 
> Same here. suggest to validate results of fsck -y.
> fsck -y to user means: I don't care how fix it, just fix it!
> If user does not care, fsck can have its own arbitrary selections,
> but they should be consistent, so we can test them.
> 
Will remove, too.

Thanks,
Yi.
