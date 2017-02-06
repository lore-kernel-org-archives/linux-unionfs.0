From: "zhangyi (F)" <yi.zhang@huawei.com>
Subject: ovlfs: cannot read latest data from read only fd
Date: Mon, 6 Feb 2017 20:32:36 +0800
Message-ID: <f2adbe41-8896-ce9c-32e1-219c43e3f85a@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="gbk"
Content-Transfer-Encoding: 7bit
Return-path: <linux-unionfs-owner@vger.kernel.org>
Received: from szxga03-in.huawei.com ([119.145.14.66]:17456 "EHLO
        szxga03-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751468AbdBFMc4 (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Mon, 6 Feb 2017 07:32:56 -0500
Sender: linux-unionfs-owner@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org
To: linux-unionfs@vger.kernel.org, miklos@szeredi.hu
Cc: yi.zhang@huawei.com, miaoxie@huawei.com, yuchangchun1@huawei.com

Hi:
We found that we cannot read the latest data from an opened file(eg: "testfile") in overlayfs
which was opened in read-only mode(this file was originally located in the lowerdir and
mapped in the mergedir, and then was copied to upperdir when someone added some data later).

	For example:

	lower: testfile(empty)
	upper: empty
	work: empty
	merge: empty
	
	mount -t overlay -o lowerdir=lower,upperdir=upper,workdir=work overlayfs merge

	1) fd1 = open("merge/testfile", O_RDONLY);
	2) fd2 = open("merge/testfile", O_WRONLY | O_APPEND);
           then we write some new data to fd2.
	3) read data form fd1.

	expect results: we read data which was written used by fd2.
	reality results: nothing.

We cannot read data from the copied file in the upperdir use fd1, so do we need to fix it?

Thanks,
zhangyi
