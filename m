Return-Path: <linux-unionfs-owner@vger.kernel.org>
Received: from mail-yw0-f176.google.com ([209.85.161.176]:35519 "EHLO
        mail-yw0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753543AbeEJErn (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Thu, 10 May 2018 00:47:43 -0400
MIME-Version: 1.0
In-Reply-To: <20180510015820.17700-1-rgoldwyn@suse.de>
References: <20180510015820.17700-1-rgoldwyn@suse.de>
From: Amir Goldstein <amir73il@gmail.com>
Date: Thu, 10 May 2018 07:47:42 +0300
Message-ID: <CAOQ4uxiDi9fFGhXxWH-pvDDP-8rk9cmwedLcsid3L51KyP8fbA@mail.gmail.com>
Subject: Re: [PATCH v2 0/4] Enable holes in copy_file_range()
Content-Type: text/plain; charset="UTF-8"
Sender: linux-unionfs-owner@vger.kernel.org
To: Goldwyn Rodrigues <rgoldwyn@suse.de>
Cc: linux-fsdevel <linux-fsdevel@vger.kernel.org>, Christoph Hellwig <hch@lst.de>, overlayfs <linux-unionfs@vger.kernel.org>, Dave Chinner <david@fromorbit.com>, Al Viro <viro@zeniv.linux.org.uk>, Anna Schumaker <Anna.Schumaker@netapp.com>
List-ID: <linux-unionfs@vger.kernel.org>

On Thu, May 10, 2018 at 4:58 AM, Goldwyn Rodrigues <rgoldwyn@suse.de> wrote:
> If copy_file_range performs a copy using splice, it converts holes
> to zeros. This effort primarily changes this behavior to create
> holes when it is possible.
>
> Even if copy_file_range() or clone_file_range() does not work for different
> mounted filesystems, We should be able to splice files if they do not
> belong the same super_block.
>
> Changes since v1:
> - Fixed bug when hole/data offset is farther than len

Please specify how you tested this work.
Did you run the xfstests generic/copy tests that Anna wrote?
If the tests caught your bugs - good, if they didn't, please
write more tests to cover the issues you found.
One thing I do not see in the existing tests is coverage for the
trivial case of "only holes" (i.e. touch x; truncate -s 10 x).

Thanks,
Amir.
