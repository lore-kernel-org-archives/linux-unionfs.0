From: "zhangyi (F)" <yi.zhang@huawei.com>
Subject: Re: [PATCH for xfstests 4/4] overlay: add fsck.overlay redirect
 directory test
Date: Fri, 15 Dec 2017 16:57:15 +0800
Message-ID: <5218c6cd-b0cd-844a-5050-256a72e1753c@huawei.com>
References: <20171214064846.21587-1-yi.zhang@huawei.com>
 <20171214064846.21587-5-yi.zhang@huawei.com>
 <CAOQ4uxgx223rHqo=f+T-RDBk6jvbLuHE1Tm_wj+FT3XXJHvy8w@mail.gmail.com>
 <1cafcd12-6a4c-5c45-65ff-aa859463ad14@huawei.com>
 <CAOQ4uxhvjVowVwje1VB4jaf1SFh-a8YFadzqsck7F6ERcsTtHA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-unionfs-owner@vger.kernel.org>
Received: from szxga04-in.huawei.com ([45.249.212.190]:11943 "EHLO
        szxga04-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753656AbdLOI54 (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Fri, 15 Dec 2017 03:57:56 -0500
In-Reply-To: <CAOQ4uxhvjVowVwje1VB4jaf1SFh-a8YFadzqsck7F6ERcsTtHA@mail.gmail.com>
Sender: linux-unionfs-owner@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org
To: Amir Goldstein <amir73il@gmail.com>
Cc: overlayfs <linux-unionfs@vger.kernel.org>, fstests <fstests@vger.kernel.org>, Miklos Szeredi <miklos@szeredi.hu>, Eryu Guan <eguan@redhat.com>, "Darrick J. Wong" <darrick.wong@oracle.com>, Miao Xie <miaoxie@huawei.com>

On 2017/12/15 15:23, Amir Goldstein Wrote:
> On Fri, Dec 15, 2017 at 8:42 AM, zhangyi (F) <yi.zhang@huawei.com> wrote:
>> On 2017/12/14 21:44, Amir Goldstein Wrote:
>>> On Thu, Dec 14, 2017 at 8:48 AM, zhangyi (F) <yi.zhang@huawei.com> wrote:
> [...]
>>> Please test the Valid "rename exchange redirect" case:
>>> set_redirect $upperdir/testdir1 "testdir2"
>>> set_redirect $upperdir/testdir2 "testdir1"
>>> fsck should not remove those redirects.
>>>
>> I can add this case. I was wondering why add this special one? If I understand right,
>> these two xattrs will not remove after fsck if $lowerdir/testdir1 and $lowerdir/testdir2
>> exists, just like the second test case "Test valid redirect xattr point to a directory
>> origin in the same directory".
>>
> 
> IIUC, the first version of fsck you posted wanted to make sure that
> origin is covered with either a whiteout or opaque dir and I commented
> that it is also legal to be covered by a redirected dir.
> So the test of exchanged redirect dirs checks that this condition is handled
> correctly by fsck.
> 
Understand, will add.

[..]
> That is one way of getting to that inconsistency which suggests that the correct
> and automatic fix is to set opaque on uper/testdir, but what about:
> 
> 1) extract pre-defined image to lower/testdir upper/testdir
> 2) mount overlay
> 3) mv merge/testdir merge/dir2   (will create an whiteout 'testdir' in upper)
> 4) mkdir merge/testdir   (create opaque dir)
> 5) umount overlay
> 6) re-extract pre-defined image to lower/testdir upper/testdir (*)
> 
> (*) Anything that *can* happen *will* happen...
> 
> Note that prior to redirect_dir feature, use could even get a way with this
> partial restore/undo of testdir changes.
> 
> My point is that if you have 2 dirs pointing at the same lower, either
> because they are both redirect or because one is not opaque, it is
> not possible to automatically determine which should be the merge dir
> and need to ask user to resolve the conflict.
> 
I think I follow you now, this does verly likly to happen. Will handle this
case to ask user in default mode, do nothing in auto and yes mode.

[..]
>> Let me see, now, fsck will remove the *later redirect xattr in 'yes' mode,
>> which means that we guess user want to copy the tree in upperdir if they
>> call cp -a when overlayfs is offline, not the whole tree expose in merge
>> layer. I think if we need to copy whole tree include lower dirs maybe too
>> complicated.
>>
>> *) fsck just remove the later one when scaning, I understand it maybe cannot guaranty
>> fsck will clears testdir1 and not testdir2 for some base filesystem, so need to find
>> better way, thoughts?
>>
> 
> quite simple I think. Instead of verifying that redirect was removed
> from testdir1
> and remained on testdir2, verify that redirect from removed from either and
> left on exactly one of them. Less trivial scripting, but not impossible.
> 
Yes, will do.

Thanks a lot,
Yi
