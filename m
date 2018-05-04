Return-Path: <linux-unionfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:37845 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751268AbeEDB3k (ORCPT <rfc822;linux-unionfs@vger.kernel.org>);
        Thu, 3 May 2018 21:29:40 -0400
Subject: Re: [PATCH 3/3] ovl: Use splice_with_holes in copy_up
References: <20180503152635.14974-1-rgoldwyn@suse.de>
 <20180503152635.14974-4-rgoldwyn@suse.de>
 <CAOQ4uxhjhds4avkGBTHsqLp72nWjP=mAFPtxmUarcF1-jp89ng@mail.gmail.com>
From: Goldwyn Rodrigues <rgoldwyn@suse.de>
Message-ID: <5f1d44bc-58aa-2860-144e-06590e56427d@suse.de>
Date: Thu, 3 May 2018 20:29:34 -0500
MIME-Version: 1.0
In-Reply-To: <CAOQ4uxhjhds4avkGBTHsqLp72nWjP=mAFPtxmUarcF1-jp89ng@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: linux-unionfs-owner@vger.kernel.org
To: Amir Goldstein <amir73il@gmail.com>
Cc: linux-fsdevel <linux-fsdevel@vger.kernel.org>, Christoph Hellwig <hch@lst.de>, Steve French <smfrench@gmail.com>, overlayfs <linux-unionfs@vger.kernel.org>, Anna Schumaker <Anna.Schumaker@netapp.com>, "Darrick J. Wong" <darrick.wong@oracle.com>, Goldwyn Rodrigues <rgoldwyn@suse.com>, Dave Chinner <david@fromorbit.com>
List-ID: <linux-unionfs@vger.kernel.org>



On 05/03/2018 02:57 PM, Amir Goldstein wrote:
> On Thu, May 3, 2018 at 6:26 PM, Goldwyn Rodrigues <rgoldwyn@suse.de> wrote:
>> From: Goldwyn Rodrigues <rgoldwyn@suse.com>
>>
>> Signed-off-by: Goldwyn Rodrigues <rgoldwyn@suse.com>
>> ---
>>  fs/overlayfs/copy_up.c |  2 +-
>>  fs/read_write.c        | 10 ++++++----
>>  include/linux/fs.h     |  2 ++
>>  3 files changed, 9 insertions(+), 5 deletions(-)
>>
>> diff --git a/fs/overlayfs/copy_up.c b/fs/overlayfs/copy_up.c
>> index 8bede0742619..6634a85255ae 100644
>> --- a/fs/overlayfs/copy_up.c
>> +++ b/fs/overlayfs/copy_up.c
>> @@ -175,7 +175,7 @@ static int ovl_copy_up_data(struct path *old, struct path *new, loff_t len)
>>                         break;
>>                 }
>>
>> -               bytes = do_splice_direct(old_file, &old_pos,
>> +               bytes = splice_with_holes(old_file, &old_pos,
>>                                          new_file, &new_pos,
>>                                          this_len, SPLICE_F_MOVE);
> 
> 
> Add.. you can remove this comment above :)
>         /* FIXME: copy up sparse files efficiently */
> 
> For the record, when I added vfs_clone_file_range() above,
> Dave Chinner has suggested to replace the entire block with
> vfs_copy_file_range(), which would do all the fallbacks.
> Since then, vfs_copy_file_range() gained "try to clone first".
> 
> There are still differences between the loop in this function and
> the loop in vfs_copy_file_range(). Perhaps the differences could
> be smoothed away, I did not check recently.

There is a difference. copy_file_range(2) or do_splice_direct() can
return short writes. I think this loop is performed to cover short writes.

I suppose we could remove the clone_file_range() before the loop and
replace the do_splice_direct() with vfs_copy_file_range().

-- 
Goldwyn
