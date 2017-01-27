From: Amir Goldstein <amir73il@gmail.com>
Subject: Re: [RFC][PATCH v2 4/4] vfs: wrap write f_ops with file_{start,end}_write()
Date: Fri, 27 Jan 2017 19:29:00 +0200
Message-ID: <CAOQ4uxgiNMt_2yoh4w92GGoHZ1T9dnoCVDhoqe8dX0sKCkpd7w@mail.gmail.com>
References: <1485174742-15866-2-git-send-email-amir73il@gmail.com>
 <1485200596-14057-1-git-send-email-amir73il@gmail.com> <CAJfpegsL3P-2k=dSWP9XiWKZA3Ywbo0a8TSQ_uS9RkJjqRywRQ@mail.gmail.com>
 <CAOQ4uxhKFgp3Qhm_TnLrkzSzGkxa4iiOzZ+sejVXLXcCqGPEYg@mail.gmail.com> <CAOQ4uxiVvhkqg5dUjRvvXr1d9K46Wp8yoXg4+abShdH0ae71NA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-unionfs-owner@vger.kernel.org>
Received: from mail-ot0-f194.google.com ([74.125.82.194]:35601 "EHLO
        mail-ot0-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S934062AbdA0R3L (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Fri, 27 Jan 2017 12:29:11 -0500
In-Reply-To: <CAOQ4uxiVvhkqg5dUjRvvXr1d9K46Wp8yoXg4+abShdH0ae71NA@mail.gmail.com>
Sender: linux-unionfs-owner@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org
To: Miklos Szeredi <miklos@szeredi.hu>, "Michael Kerrisk (man-pages)" <mtk.manpages@gmail.com>
Cc: Jan Kara <jack@suse.com>, Al Viro <viro@zeniv.linux.org.uk>, "linux-unionfs@vger.kernel.org" <linux-unionfs@vger.kernel.org>, linux-fsdevel <linux-fsdevel@vger.kernel.org>, Christoph Hellwig <hch@lst.de>, "Darrick J. Wong" <darrick.wong@oracle.com>

On Fri, Jan 27, 2017 at 6:20 PM, Amir Goldstein <amir73il@gmail.com> wrote:
> On Fri, Jan 27, 2017 at 1:50 PM, Amir Goldstein <amir73il@gmail.com> wrote:
>> On Fri, Jan 27, 2017 at 1:09 PM, Miklos Szeredi <miklos@szeredi.hu> wrote:
>>> On Mon, Jan 23, 2017 at 8:43 PM, Amir Goldstein <amir73il@gmail.com> wrote:
>>>> Before calling write f_ops, call file_start_write() instead
>>>> of sb_start_write().
>>>>
>>>> This ensures freeze protection for both overlay and upper fs
>>>> when file is open from an overlayfs mount.
>>>>
>>>> Replace {sb,file}_start_write() for {copy,clone}_file_range() and
>>>> for fallocate().
>>>>


Oh boy! there is more.

IIUC, file_start_write() is in order were write to regular file should get
freeze protection and write to special file should not.

So after eliminating dedup_range from this patch, from the 3 remaining ops:
fallocate(), clone_file_range() and copy_file_range() all have nice stories.

fallocate() can operate or regular file directory and blockdev.
blockdev does not call for freeze protection, if we use file_start_write()
fs that supports fallocate on directory (anybody?) will not get freeze
protection.

clone_file_range() operates only on regular file, so file_start_write() seems
in order. especially if clone_range() is ever extended to operate on blockdev,
which does not sound such a far fetched idea.

copy_file_range() looks like it was meant to operate only on regular files,
but neither syscall nor vfs helper actually check that.

Jan,
Would it make sense to add directory to file types for which file_start_write()
gets freeze protection to cover the fallocate() case correctly?

Christoph,
To your understanding, is it correct to add the IS_REG check in
vfs_copy_file_range()?

Michael,
man page for copy_file_range(2) does not explicitly mention regular files
but it seems implied and also EINVAL does not mention the case of
fd is not a regular file, which is how xfs (and probably other fs too) respond.
