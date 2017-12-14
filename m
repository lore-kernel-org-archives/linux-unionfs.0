From: Amir Goldstein <amir73il@gmail.com>
Subject: Re: [PATCH v2 00/18] overlay: implement fsck.overlay utility
Date: Thu, 14 Dec 2017 11:27:26 +0200
Message-ID: <CAOQ4uxjLk1HGm1LAK0agy+vFAfUyheL4CqSg_mW8dW5crLq6nA@mail.gmail.com>
References: <20171214064747.20999-1-yi.zhang@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-unionfs-owner@vger.kernel.org>
Received: from mail-yb0-f170.google.com ([209.85.213.170]:33830 "EHLO
        mail-yb0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750737AbdLNJ12 (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Thu, 14 Dec 2017 04:27:28 -0500
In-Reply-To: <20171214064747.20999-1-yi.zhang@huawei.com>
Sender: linux-unionfs-owner@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org
To: "zhangyi (F)" <yi.zhang@huawei.com>
Cc: overlayfs <linux-unionfs@vger.kernel.org>, fstests <fstests@vger.kernel.org>, Miklos Szeredi <miklos@szeredi.hu>, Eryu Guan <eguan@redhat.com>, "Darrick J. Wong" <darrick.wong@oracle.com>, Miao Xie <miaoxie@huawei.com>

On Thu, Dec 14, 2017 at 8:47 AM, zhangyi (F) <yi.zhang@huawei.com> wrote:
> Hi all,
>
> Here is the second version of original fsck.overlay. Changes split to
> each patch from first version "overlay: implement fsck utility" for
> readability.

It fine that you left original commit for readability and ease of re-review
I don't mind that functional review comments, (like -n, -p -a) are
addressed by an incremental commit, but there are too many patches
that fix spelling mistakes and build warnings.
Please squash those fix patches into the relevant commit instead of
posting them for review.

I will review the entire series when is it re posted as a clean series.

>
> I have already handled most of comments from the first iteration and
> add/fix some infrastructure, no big features, move tests to xfstests
> (already tested).
>
> I will push this "incubator" version to github after review and fix.
> Any comments is helpful, thanks!
>
> Changes since v1:
>
> - Add "-n -p -y" options. (Comment from Amir and Darrick)
> - Move test cases to xfstests. (Amir, Eryu and Ted)
> - * Check lowers use base fd + relative path to speed up iterations. (Amir)
> - Handle missing case of redirect xattr check. (Amir)
> - Correct copyright and License. (Amir)
> - Remove duplicate redirect xattr in 'yes' mode.
> - Add objects counter.
> - Not enforce fs offline in 'no' mode.
> - Fix some code mistakes.
>
> *) This change will cost a lot of 'fd' (up to 500) and will not work
> if sysctl_nr_open is lower than lowerdir number (special case, default
> is 1024*1024). I think expand sysctl_nr_open temporary may have some side
> effect, so just return failure.
>

I don't think I follow.
Perhaps you misunderstood me or I don't remember what I commented on.
What I meant was that you can keep fd of lowerdirs,upperdir,workdir and
use those as dir_fd for various syscalls that require overlay relative path,
instead of composing the upper/lower paths as strings.
How did we get to 500 fds?

Amir.
