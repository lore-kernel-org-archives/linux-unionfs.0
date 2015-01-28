From: hujianyang <hujianyang@huawei.com>
Subject: Re: overlayfs lazy unmounts?
Date: Wed, 28 Jan 2015 11:59:49 +0800
Message-ID: <54C85EB5.8040306@huawei.com>
References: <20150123180309.GN32617@cray.com> <CAJfpegtAL7dGhhRW3x8kEygXAQrW-_mdzEt3NiOo6ETaXkYOCg@mail.gmail.com> <20150127204136.GY32617@cray.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Return-path: <linux-unionfs-owner@vger.kernel.org>
Received: from szxga01-in.huawei.com ([119.145.14.64]:53403 "EHLO
	szxga01-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751307AbbA1ED6 (ORCPT
	<rfc822;linux-unionfs@vger.kernel.org>);
	Tue, 27 Jan 2015 23:03:58 -0500
In-Reply-To: <20150127204136.GY32617@cray.com>
Sender: linux-unionfs-owner@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org
To: Eric Jones <ejones@cray.com>
Cc: Miklos Szeredi <miklos@szeredi.hu>, linux-unionfs@vger.kernel.org, raven@themaw.net

On 2015/1/28 4:41, Eric Jones wrote:
> 
> 1. Will creating new verions of /var/images/opt_XXXX on the NFS server affect existing overlayfs mounts? The docs say modifying the lower filesystem is not allowed, but will anything "bad" happen if we are just adding a sibling directory tree that is not yet overlay mounted? 

Overlayfs doesn't affect lowerfs but may cache some filesystem
data of lowerfs in memory. I think if the sibling directory is
entirely independent with the lowerdir of overlayfs, modifying
is OK.

But there are many using case in filesystem, e.g. link, may affect
the lowerdir even if the operations is performed on sibling dir.

Keep lowerfs stable is safe.

> 
> 2. We switch to a new /var/images/opt_XXXX by doing a lazy unmount of the old and mounting the new. Will processes with outstanding references see broken pwd/cwd? Corruption? 

New mount will create new metadata in my considering. They are
different mount for OS. You are worry about that new mount and
old mount may modify upperdir in the same time, Am I right? So
I think it is similar with the case that mounting two different
overlayfs with same upperdir, I think you could handle it in
userspace.

What's your use case? You can try something first and see what
will happen, then send out the result.

BR,
Hu


