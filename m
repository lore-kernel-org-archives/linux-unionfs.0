From: hujianyang <hujianyang@huawei.com>
Subject: Re: Xattr issues with overlayfs
Date: Wed, 26 Nov 2014 16:09:13 +0800
Message-ID: <54758AA9.9020906@huawei.com>
References: <54730565.4040308@huawei.com> <CAJfpegtvTZYk2V7a94g_CDKhw4Fn8_bS-cSJKHWHqvvU4abygg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-unionfs-owner@vger.kernel.org>
Received: from szxga03-in.huawei.com ([119.145.14.66]:40163 "EHLO
	szxga03-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752113AbaKZINx (ORCPT
	<rfc822;linux-unionfs@vger.kernel.org>);
	Wed, 26 Nov 2014 03:13:53 -0500
In-Reply-To: <CAJfpegtvTZYk2V7a94g_CDKhw4Fn8_bS-cSJKHWHqvvU4abygg@mail.gmail.com>
Sender: linux-unionfs-owner@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>, linux-unionfs@vger.kernel.org

On 2014/11/25 22:41, Miklos Szeredi wrote:
> 
> No, I don't think this makes any sense.  Maintenance can be done by
> unmounting the overlay and doing modification directly on the upper
> layer.  After this is done (adding/removing opaque flag, adding
> removing whiteouts, etc) the overlay can be mounted again and the
> modifications will be applied.

Yes, we can remove overlayfs_xattr directly on upper files.

> 
> I don't think online modification of the internal attributes of the
> overlay makes much sense.
> 
> Except maybe, maybe a privileged undelete, but even that one is
> tricky: the whiteout was either from deletion of the lower layer or
> the upper layer file, the later not being undeleteable.  But the two
> cases are currently indistinguishable, so the undelete would always
> recover the lower layer file, which is probably not what the user
> wants and might cause more harm than good.
>

Agree.

Thanks for your explanation. Now I know "trusted.overlay.opaque" can
be set in userspace, but this xattr is set on files in upper filesystem,
not directly on files in overlayfs.


Thanks~!

Hu

