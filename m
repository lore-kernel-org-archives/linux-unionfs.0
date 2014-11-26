From: hujianyang <hujianyang@huawei.com>
Subject: Re: [PATCH] ovl: Cleanup redundant blank lines
Date: Wed, 26 Nov 2014 17:07:12 +0800
Message-ID: <54759840.3050101@huawei.com>
References: <54758C7B.6040402@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Return-path: <linux-unionfs-owner@vger.kernel.org>
Received: from szxga03-in.huawei.com ([119.145.14.66]:40473 "EHLO
	szxga03-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751088AbaKZJIP (ORCPT
	<rfc822;linux-unionfs@vger.kernel.org>);
	Wed, 26 Nov 2014 04:08:15 -0500
In-Reply-To: <54758C7B.6040402@huawei.com>
Sender: linux-unionfs-owner@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: linux-unionfs@vger.kernel.org

Hi Miklos,

Will you apply my previous patch "ovl: Use macros to present
ovl_xattr"? These two patches(previous one and this one) are
based on branch *overlayfs-current* and conflict with each
other.

I don't know which branch I should use, overlayfs-current or
overlayfs-next. How could I join the development?


By the way, do you think we can make use of "kmem_cache" to
manage "struct ovl_entry"? I think it will speedup operations
like *ls*. I saw your work about multi-layer support. The size
of "struct ovl_entry" will be variable. In addition, some free
paths of ovl_entry rely on RCU. So maybe it's not easy.


Thanks~!

Hu

