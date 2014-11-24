From: hujianyang <hujianyang@huawei.com>
Subject: Xattr issues with overlayfs
Date: Mon, 24 Nov 2014 18:16:05 +0800
Message-ID: <54730565.4040308@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Return-path: <linux-unionfs-owner@vger.kernel.org>
Received: from szxga02-in.huawei.com ([119.145.14.65]:14840 "EHLO
	szxga02-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752115AbaKXKQR (ORCPT
	<rfc822;linux-unionfs@vger.kernel.org>);
	Mon, 24 Nov 2014 05:16:17 -0500
Sender: linux-unionfs-owner@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org
To: miklos@szeredi.hu
Cc: "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>, linux-unionfs@vger.kernel.org

Hi Miklos,

I'm learning overlayfs and finding some issues in xattr support. I
don't know if they are real problems or misunderstandings. I wish you
could take some time to help.

As is said in Documentation/filesystems/overlayfs.txt:

"""
A directory is made opaque by setting the xattr "trusted.overlay.opaque"
to "y".  Where the upper filesystem contains an opaque directory, any
directory in the lower filesystem with the same name is ignored.
"""

I think users could set *ovl_opaque_xattr* to hide the files in lower
directory in userspace like this:

	setxattr(path, "trusted.overlay.opaque", &value, 1, XATTR_CREATE);

But It seems not true because we forbid this operation in userspace:

ovl_setxattr():

        if (ovl_is_private_xattr(name))
                goto out_drop_write;


I think current xattr operations in overlayfs including setxattr,
getxattr, listxattr, removexattr are used for upper/lower xattrs and
overlayfs private xattrs also.

Is ovl_set/remove_opauqe() related to this?

I'd like to introduce some of my work.

1) Use macros to indicate overlayfs_private_xattr.
2) Enable overlayfs_private_xattr setting an removing in userspace.
   * I'm not clear with this one

Thanks~!

Hu

