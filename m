Return-Path: <linux-unionfs-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:49730 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726191AbeKHIwf (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Thu, 8 Nov 2018 03:52:35 -0500
Date: Wed, 7 Nov 2018 15:19:55 -0800
From: Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH] tmpfs: let lseek return ENXIO with a negative offset
Message-Id: <20181107151955.777fcbcf9a5932677e245287@linux-foundation.org>
In-Reply-To: <1540434176-14349-1-git-send-email-yuyufen@huawei.com>
References: <1540434176-14349-1-git-send-email-yuyufen@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-unionfs-owner@vger.kernel.org
To: Yufen Yu <yuyufen@huawei.com>
Cc: viro@zeniv.linux.org.uk, hughd@google.com, linux-mm@kvack.org, linux-fsdevel@vger.kernel.org, linux-unionfs@vger.kernel.org
List-ID: <linux-unionfs@vger.kernel.org>

On Thu, 25 Oct 2018 10:22:56 +0800 Yufen Yu <yuyufen@huawei.com> wrote:

> For now, the others filesystems, such as ext4, f2fs, ubifs,
> all of them return ENXIO when lseek with a negative offset.

When using SEEK_DATA and/or SEEK_HOLE, yes?

> It is better to let tmpfs return ENXIO too. After that, tmpfs
> can also pass generic/448.

generic/448 is, I assume, part of xfstests?

So I'll rewrite the changelog as follows.  Please review carefully.



Subject: tmpfs: make lseek(SEEK_DATA/SEK_HOLE) return ENXIO with a negative offset

Other filesystems such as ext4, f2fs and ubifs all return ENXIO when
lseek (SEEK_DATA or SEEK_HOLE) requests a negative offset.

man 2 lseek says

:      EINVAL whence  is  not  valid.   Or: the resulting file offset would be
:             negative, or beyond the end of a seekable device.
:
:      ENXIO  whence is SEEK_DATA or SEEK_HOLE, and the file offset is  beyond
:             the end of the file.


Make tmpfs return ENXIO under these circumstances as well.  After this,
tmpfs also passes xfstests's generic/448.
