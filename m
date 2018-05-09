Return-Path: <linux-unionfs-owner@vger.kernel.org>
Received: from mail-yw0-f170.google.com ([209.85.161.170]:40287 "EHLO
        mail-yw0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751922AbeEIFuJ (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Wed, 9 May 2018 01:50:09 -0400
MIME-Version: 1.0
In-Reply-To: <20180508212405.15297-5-rgoldwyn@suse.de>
References: <20180508212405.15297-1-rgoldwyn@suse.de> <20180508212405.15297-5-rgoldwyn@suse.de>
From: Amir Goldstein <amir73il@gmail.com>
Date: Wed, 9 May 2018 08:50:08 +0300
Message-ID: <CAOQ4uxhsjHjRy1hKwFyH7nkEE0Y_tv9sSh2dMLLwrVoM6fBeJw@mail.gmail.com>
Subject: Re: [PATCH 4/4] ovl: Use do_copy_file_range() in copy_up_data()
Content-Type: text/plain; charset="UTF-8"
Sender: linux-unionfs-owner@vger.kernel.org
To: Goldwyn Rodrigues <rgoldwyn@suse.de>
Cc: linux-fsdevel <linux-fsdevel@vger.kernel.org>, Christoph Hellwig <hch@lst.de>, Steve French <smfrench@gmail.com>, overlayfs <linux-unionfs@vger.kernel.org>, Dave Chinner <david@fromorbit.com>, Goldwyn Rodrigues <rgoldwyn@suse.com>
List-ID: <linux-unionfs@vger.kernel.org>

On Wed, May 9, 2018 at 12:24 AM, Goldwyn Rodrigues <rgoldwyn@suse.de> wrote:
> From: Goldwyn Rodrigues <rgoldwyn@suse.com>
>
> This will preserve the holes and will clone(), if available.
>
> Signed-off-by: Goldwyn Rodrigues <rgoldwyn@suse.com>
Reviewed-by: Amir Goldstein <amir73il@gmail.com>

Only please mention in commit message that it changes behavoir
slightly for a very large file (clone in chunks).
I see no problem with this change.

And please test with xfstest overlay/001 with copies up a large
sparse file. test time should drop from ~30s to 0s.
If you like I can test that one for you.
I believe there are also generic copy_file_range tests in xfstests.

Thanks,
Amir.
