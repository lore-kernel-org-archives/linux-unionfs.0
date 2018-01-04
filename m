From: "zhangyi (F)" <yi.zhang@huawei.com>
Subject: Re: [PATCH xfstest v2 2/4] overlay: add fsck.overlay whiteout test
Date: Thu, 4 Jan 2018 09:15:53 +0800
Message-ID: <7cca592c-3e27-d2b8-6c3c-a4ce15f6489a@huawei.com>
References: <20171228114933.47759-1-yi.zhang@huawei.com>
 <20171228114933.47759-3-yi.zhang@huawei.com>
 <20180103150435.GA3595@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="windows-1252"
Content-Transfer-Encoding: 7bit
Return-path: <linux-unionfs-owner@vger.kernel.org>
Received: from szxga04-in.huawei.com ([45.249.212.190]:3669 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1751593AbeADBRO (ORCPT <rfc822;linux-unionfs@vger.kernel.org>);
        Wed, 3 Jan 2018 20:17:14 -0500
In-Reply-To: <20180103150435.GA3595@redhat.com>
Sender: linux-unionfs-owner@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org
To: Vivek Goyal <vgoyal@redhat.com>
Cc: linux-unionfs@vger.kernel.org, fstests@vger.kernel.org, miklos@szeredi.hu, amir73il@gmail.com, eguan@redhat.com, miaoxie@huawei.com, yangerkun@huawei.com

On 2018/1/3 23:04, Vivek Goyal Wrote:
> On Thu, Dec 28, 2017 at 07:49:31PM +0800, zhangyi (F) wrote:
> 
> [..]
>> +# Test orphan whiteout in lower and upper layer, should remove
>> +echo "+ Orphan whiteout"
>> +make_whiteout $lowerdir/foo
>> +make_whiteout $upperdir/foo
>> +make_whiteout $upperdir/bar
>> +
>> +_overlay_fsck_dirs $lowerdir $upperdir $workdir -p >> $seqres.full 2>&1 || \
>> +	_fail "fsck should not fail"
> 
> I ran fsck.overlay manually (V3 patches) with one orphan whiteout in
> upper. I get following output.
> 
> fsck.overlay -o lowerdir=lower,upperdir=upper,workdir=work 
> Orphan whiteout: /root/fsck-overlay-testing/upper/foo Remove ? [y]: 
> y
> fsck.overlay:[Error]: Cannot getxattr /root/fsck-overlay-testing/upper/foo trusted.overlay.origin: No such file or directory
> Filesystem clean
> 
> This message about "overlay.origin"  not being there, should not be an
> error. You have already figured out, its an orphan whiteout, and user
> already asked you to remove it. So checking or origin after that can
> calling it Error might not make much sense. Also on top, later I get
> "Filesystem clean".
> 
> I think in this case, user should not see any message until and unless a
> error actually has happened which prevents from cleaning orphan whiteout.
> 

Oh, this is a bug introduced by "fsck.overlay: add impure xattr check", thanks
for testing and pointing this out. I will fix in nest version.

Thanks,
zhangyi.
