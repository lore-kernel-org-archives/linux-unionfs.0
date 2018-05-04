Return-Path: <amir73il@gmail.com>
MIME-Version: 1.0
In-Reply-To: <0915ac15-4f34-951e-0651-0888cf5c81ac@suse.de>
References: <20180503152635.14974-1-rgoldwyn@suse.de> <20180503152635.14974-4-rgoldwyn@suse.de>
 <CAOQ4uxhjhds4avkGBTHsqLp72nWjP=mAFPtxmUarcF1-jp89ng@mail.gmail.com> <0915ac15-4f34-951e-0651-0888cf5c81ac@suse.de>
From: Amir Goldstein <amir73il@gmail.com>
Date: Fri, 4 May 2018 09:18:31 +0300
Message-ID: <CAOQ4uxhok4PRNxkmMWKO0QHY1tB7WS=acAZQgJNoFG0dVEQyXg@mail.gmail.com>
Subject: Re: [PATCH 3/3] ovl: Use splice_with_holes in copy_up
Content-Type: text/plain; charset="UTF-8"
To: Goldwyn Rodrigues <rgoldwyn@suse.de>
Cc: linux-fsdevel <linux-fsdevel@vger.kernel.org>, Christoph Hellwig <hch@lst.de>, Steve French <smfrench@gmail.com>, overlayfs <linux-unionfs@vger.kernel.org>, Anna Schumaker <Anna.Schumaker@netapp.com>, "Darrick J. Wong" <darrick.wong@oracle.com>, Goldwyn Rodrigues <rgoldwyn@suse.com>, Dave Chinner <david@fromorbit.com>, Miklos Szeredi <miklos@szeredi.hu>
List-ID: <linux-unionfs@vger.kernel.org>

On Fri, May 4, 2018 at 4:31 AM, Goldwyn Rodrigues <rgoldwyn@suse.de> wrote:
>
>
> On 05/03/2018 02:57 PM, Amir Goldstein wrote:
>> On Thu, May 3, 2018 at 6:26 PM, Goldwyn Rodrigues <rgoldwyn@suse.de> wrote:
>>> From: Goldwyn Rodrigues <rgoldwyn@suse.com>
>>>
>>> Signed-off-by: Goldwyn Rodrigues <rgoldwyn@suse.com>
>>> ---
>>>  fs/overlayfs/copy_up.c |  2 +-
>>>  fs/read_write.c        | 10 ++++++----
>>>  include/linux/fs.h     |  2 ++
>>>  3 files changed, 9 insertions(+), 5 deletions(-)
>>>
>>> diff --git a/fs/overlayfs/copy_up.c b/fs/overlayfs/copy_up.c
>>> index 8bede0742619..6634a85255ae 100644
>>> --- a/fs/overlayfs/copy_up.c
>>> +++ b/fs/overlayfs/copy_up.c
>>> @@ -175,7 +175,7 @@ static int ovl_copy_up_data(struct path *old, struct path *new, loff_t len)
>>>                         break;
>>>                 }
>>>
>>> -               bytes = do_splice_direct(old_file, &old_pos,
>>> +               bytes = splice_with_holes(old_file, &old_pos,
>>>                                          new_file, &new_pos,
>>>                                          this_len, SPLICE_F_MOVE);
>>
>>
>> Add.. you can remove this comment above :)
>>         /* FIXME: copy up sparse files efficiently */
>>
>> For the record, when I added vfs_clone_file_range() above,
>> Dave Chinner has suggested to replace the entire block with
>> vfs_copy_file_range(), which would do all the fallbacks.
>> Since then, vfs_copy_file_range() gained "try to clone first".
>>
>> There are still differences between the loop in this function and
>> the loop in vfs_copy_file_range(). Perhaps the differences could
>> be smoothed away, I did not check recently.
>>
>
> There is a difference. copy_file_range(2) or do_splice_direct() can
> return short writes. I think this loop is performed to cover short writes.
>
> I suppose we could remove the clone_file_range() before the loop and
> replace the do_splice_direct() with vfs_copy_file_range().
>

There are other differences, like file_start_write().
To resolve them would probably require factoring out do_copy_file_range()
with an argument to determine whether or not the function will try to
copy as much as possible by looping.

BTW, It's a bit odd that at the moment SPLICE_F_MOVE is only tested by
fuse and fuse cannot be an overlayfs upper fs. Maybe I am missing something.

Thanks,
Amir.
