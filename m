From: Amir Goldstein <amir73il@gmail.com>
Subject: Re: [RFC][PATCH v2 4/4] vfs: wrap write f_ops with file_{start,end}_write()
Date: Fri, 27 Jan 2017 22:09:37 +0200
Message-ID: <CAOQ4uxhY+YOKLi0CvmAtjoB_6gJ8_5_=bCE_xdYsFwN1y7=hdg@mail.gmail.com>
References: <1485174742-15866-2-git-send-email-amir73il@gmail.com>
 <1485200596-14057-1-git-send-email-amir73il@gmail.com> <CAJfpegsL3P-2k=dSWP9XiWKZA3Ywbo0a8TSQ_uS9RkJjqRywRQ@mail.gmail.com>
 <CAOQ4uxhKFgp3Qhm_TnLrkzSzGkxa4iiOzZ+sejVXLXcCqGPEYg@mail.gmail.com>
 <CAOQ4uxiVvhkqg5dUjRvvXr1d9K46Wp8yoXg4+abShdH0ae71NA@mail.gmail.com> <eefd8b0f-1e5e-1d86-a57b-03b873a68069@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-unionfs-owner@vger.kernel.org>
Received: from mail-oi0-f65.google.com ([209.85.218.65]:34149 "EHLO
        mail-oi0-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751049AbdA0UJs (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Fri, 27 Jan 2017 15:09:48 -0500
In-Reply-To: <eefd8b0f-1e5e-1d86-a57b-03b873a68069@gmail.com>
Sender: linux-unionfs-owner@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org
To: "Michael Kerrisk (man-pages)" <mtk.manpages@gmail.com>
Cc: Miklos Szeredi <miklos@szeredi.hu>, Jan Kara <jack@suse.com>, Al Viro <viro@zeniv.linux.org.uk>, "linux-unionfs@vger.kernel.org" <linux-unionfs@vger.kernel.org>, linux-fsdevel <linux-fsdevel@vger.kernel.org>, Christoph Hellwig <hch@lst.de>, "Darrick J. Wong" <darrick.wong@oracle.com>

On Fri, Jan 27, 2017 at 9:30 PM, Michael Kerrisk (man-pages)
<mtk.manpages@gmail.com> wrote:
> On 01/28/2017 05:20 AM, Amir Goldstein wrote:
>> On Fri, Jan 27, 2017 at 1:50 PM, Amir Goldstein <amir73il@gmail.com> wrote:
>>> On Fri, Jan 27, 2017 at 1:09 PM, Miklos Szeredi <miklos@szeredi.hu> wrote:
>>>> On Mon, Jan 23, 2017 at 8:43 PM, Amir Goldstein <amir73il@gmail.com> wrote:
>>>>> Before calling write f_ops, call file_start_write() instead
>>>>> of sb_start_write().
>>>>>
>>>>> This ensures freeze protection for both overlay and upper fs
>>>>> when file is open from an overlayfs mount.
>>>>>
>>>>> Replace {sb,file}_start_write() for {copy,clone}_file_range() and
>>>>> for fallocate().
>>>>>
>>>>> For dedup_file_range() there is no need for mnt_want_write_file().
>>>>> File is already open for write, so we already have mnt_want_write()
>>>>> and we only need file_start_write().
>>>>
>>>> Being opened for write is not verified if capable(CAP_SYS_ADMIN).
>>>> Ugly special case, don't ask me why it's done...
>>>>
>>>
>>> Christoph, Darrick, is that by design?
>>
>> Anyway, whether is makes sense or not, that's a legacy from
>> BTRFS_IOC_FILE_EXTENT_SAME, we probably have to live with.
>>
>> Michael, I recon man page needs updating.
>
> Sorry--can you elaborate on what changes are required?
>

1. IOCTL-FIDEDUPERANGE(2)

"During the call, src_fd must be open for reading and dest_fd must be
open for writing"

Apparently, with CAP_SYS_ADMIN dest_fd is allowed to be open for read-only
<eyebrows raised>. It makes some sense, because the data of dest_fd is not being
modified. Its not really clear to me why admin would need this capability in the
first place, but that's the way it is.

2. copy_file_range(2)

It doesn't say anywhere that fd_in and fd_out are supposed to be regular files
and that EINVAL/EISDIR can be returns if they are not, but that is
probably the behavior
of all file systems.
Per Christoph's suggestion, I am going to enforce IS_REG in the vfs helper,
which is consistent with behavior of clone_file_range and dedupe_file_range

3. fallocate(2)

The entire man page says nothing about what to expect from fallocate
of directory,
but the error codes document:
"ENODEV fd does not refer to a regular file or a directory"

In reality, file systems return EBADF for directory fd and the vfs
helper code says:
        /*
         * Let individual file system decide if it supports preallocation
         * for directories or not.
         */
        if (!S_ISREG(inode->i_mode) && !S_ISDIR(inode->i_mode) &&
            !S_ISBLK(inode->i_mode))
                return -ENODEV;

IS_BLK was added quite recently so man page is out of date is that regard.

And I really wonder if there is any file system that "decides to support
preallocation for directories"?
Because it would make life easier for me to fix correctness for freeze
protection of fallocate if vfs helper would deny falloacte a directory.

fallocate() seems to be the only operation, theoretically allowed on
a directory file descriptor, but only if open for write.
Is there any other beast of this sort?
If not, and no fs ever implemented this bizar functionality, then
perhaps it is best to get rid of that corner case.
