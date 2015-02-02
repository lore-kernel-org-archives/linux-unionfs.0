From: hujianyang <hujianyang@huawei.com>
Subject: Small code issue
Date: Mon, 2 Feb 2015 14:53:53 +0800
Message-ID: <54CF1F01.5000204@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Return-path: <linux-unionfs-owner@vger.kernel.org>
Received: from szxga01-in.huawei.com ([119.145.14.64]:42572 "EHLO
	szxga01-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932513AbbBBGyJ (ORCPT
	<rfc822;linux-unionfs@vger.kernel.org>);
	Mon, 2 Feb 2015 01:54:09 -0500
Sender: linux-unionfs-owner@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: linux-unionfs@vger.kernel.org

Hi Miklos,

I was backporting overlayfs for linux 3.16 last week and
found a small issue in the patch:

commit c771d683: vfs: introduce clone_private_mount()

this patch adds *struct path* to include/linux/mount.h,
but actually *struct path* is already added to this file
by

commit 3064c356: death to mnt_pinned


It's bother to send a patch for fixing an issue like this,
so if you've got other same problems, you could merge
them with this together.

Thanks,
Hu

