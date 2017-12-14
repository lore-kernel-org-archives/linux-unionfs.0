From: "zhangyi (F)" <yi.zhang@huawei.com>
Subject: Re: [PATCH v2 00/18] overlay: implement fsck.overlay utility
Date: Thu, 14 Dec 2017 18:43:05 +0800
Message-ID: <6cf4cb72-832f-c23e-d5fa-d9a48df96a87@huawei.com>
References: <20171214064747.20999-1-yi.zhang@huawei.com>
 <CAOQ4uxjLk1HGm1LAK0agy+vFAfUyheL4CqSg_mW8dW5crLq6nA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-unionfs-owner@vger.kernel.org>
Received: from szxga06-in.huawei.com ([45.249.212.32]:38889 "EHLO huawei.com"
        rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org with ESMTP
        id S1751508AbdLNKn5 (ORCPT <rfc822;linux-unionfs@vger.kernel.org>);
        Thu, 14 Dec 2017 05:43:57 -0500
In-Reply-To: <CAOQ4uxjLk1HGm1LAK0agy+vFAfUyheL4CqSg_mW8dW5crLq6nA@mail.gmail.com>
Sender: linux-unionfs-owner@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org
To: Amir Goldstein <amir73il@gmail.com>
Cc: overlayfs <linux-unionfs@vger.kernel.org>, fstests <fstests@vger.kernel.org>, Miklos Szeredi <miklos@szeredi.hu>, Eryu Guan <eguan@redhat.com>, "Darrick J. Wong" <darrick.wong@oracle.com>, Miao Xie <miaoxie@huawei.com>

On 2017/12/14 17:27, Amir Goldstein Wrote:
> On Thu, Dec 14, 2017 at 8:47 AM, zhangyi (F) <yi.zhang@huawei.com> wrote:
>> Hi all,
>>
>> Here is the second version of original fsck.overlay. Changes split to
>> each patch from first version "overlay: implement fsck utility" for
>> readability.
> 
> It fine that you left original commit for readability and ease of re-review
> I don't mind that functional review comments, (like -n, -p -a) are
> addressed by an incremental commit, but there are too many patches
> that fix spelling mistakes and build warnings.
> Please squash those fix patches into the relevant commit instead of
> posting them for review.
> 
> I will review the entire series when is it re posted as a clean series.
> 
Oh, sorry about that, I will squash patches and repost it again,
please skip these version, thanks!

>>
>> I have already handled most of comments from the first iteration and
>> add/fix some infrastructure, no big features, move tests to xfstests
>> (already tested).
>>
>> I will push this "incubator" version to github after review and fix.
>> Any comments is helpful, thanks!
>>
>> Changes since v1:
>>
>> - Add "-n -p -y" options. (Comment from Amir and Darrick)
>> - Move test cases to xfstests. (Amir, Eryu and Ted)
>> - * Check lowers use base fd + relative path to speed up iterations. (Amir)
>> - Handle missing case of redirect xattr check. (Amir)
>> - Correct copyright and License. (Amir)
>> - Remove duplicate redirect xattr in 'yes' mode.
>> - Add objects counter.
>> - Not enforce fs offline in 'no' mode.
>> - Fix some code mistakes.
>>
>> *) This change will cost a lot of 'fd' (up to 500) and will not work
>> if sysctl_nr_open is lower than lowerdir number (special case, default
>> is 1024*1024). I think expand sysctl_nr_open temporary may have some side
>> effect, so just return failure.
>>
> 
> I don't think I follow.
> Perhaps you misunderstood me or I don't remember what I commented on.
> What I meant was that you can keep fd of lowerdirs,upperdir,workdir and
> use those as dir_fd for various syscalls that require overlay relative path,
> instead of composing the upper/lower paths as strings.
> How did we get to 500 fds?
> 
Yes, I keep fd of lowerdirs now, and I notice that if user specify mutli-lowers
up to 500(the upper limit), we have to keep all these fds when checking lower dirs
to find an existing target, like this:

	for (i = start; i < lower_num; i++) {
		if (fstatat(lowerfd[i], pathname, &st,
			    AT_EMPTY_PATH | AT_SYMLINK_NOFOLLOW) != 0)
	...

So I am worry about the problem of sysctl_nr_open is lower than lower_num here.

Thanks,
Yi.
