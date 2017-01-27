From: Amir Goldstein <amir73il@gmail.com>
Subject: Re: [RFC][PATCH v2 4/4] vfs: wrap write f_ops with file_{start,end}_write()
Date: Fri, 27 Jan 2017 18:20:12 +0200
Message-ID: <CAOQ4uxiVvhkqg5dUjRvvXr1d9K46Wp8yoXg4+abShdH0ae71NA@mail.gmail.com>
References: <1485174742-15866-2-git-send-email-amir73il@gmail.com>
 <1485200596-14057-1-git-send-email-amir73il@gmail.com> <CAJfpegsL3P-2k=dSWP9XiWKZA3Ywbo0a8TSQ_uS9RkJjqRywRQ@mail.gmail.com>
 <CAOQ4uxhKFgp3Qhm_TnLrkzSzGkxa4iiOzZ+sejVXLXcCqGPEYg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-unionfs-owner@vger.kernel.org>
Received: from mail-ot0-f195.google.com ([74.125.82.195]:35404 "EHLO
        mail-ot0-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932902AbdA0QUN (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Fri, 27 Jan 2017 11:20:13 -0500
In-Reply-To: <CAOQ4uxhKFgp3Qhm_TnLrkzSzGkxa4iiOzZ+sejVXLXcCqGPEYg@mail.gmail.com>
Sender: linux-unionfs-owner@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org
To: Miklos Szeredi <miklos@szeredi.hu>, "Michael Kerrisk (man-pages)" <mtk.manpages@gmail.com>
Cc: Jan Kara <jack@suse.com>, Al Viro <viro@zeniv.linux.org.uk>, "linux-unionfs@vger.kernel.org" <linux-unionfs@vger.kernel.org>, linux-fsdevel <linux-fsdevel@vger.kernel.org>, Christoph Hellwig <hch@lst.de>, "Darrick J. Wong" <darrick.wong@oracle.com>

On Fri, Jan 27, 2017 at 1:50 PM, Amir Goldstein <amir73il@gmail.com> wrote:
> On Fri, Jan 27, 2017 at 1:09 PM, Miklos Szeredi <miklos@szeredi.hu> wrote:
>> On Mon, Jan 23, 2017 at 8:43 PM, Amir Goldstein <amir73il@gmail.com> wrote:
>>> Before calling write f_ops, call file_start_write() instead
>>> of sb_start_write().
>>>
>>> This ensures freeze protection for both overlay and upper fs
>>> when file is open from an overlayfs mount.
>>>
>>> Replace {sb,file}_start_write() for {copy,clone}_file_range() and
>>> for fallocate().
>>>
>>> For dedup_file_range() there is no need for mnt_want_write_file().
>>> File is already open for write, so we already have mnt_want_write()
>>> and we only need file_start_write().
>>
>> Being opened for write is not verified if capable(CAP_SYS_ADMIN).
>> Ugly special case, don't ask me why it's done...
>>
>
> Christoph, Darrick, is that by design?

Anyway, whether is makes sense or not, that's a legacy from
BTRFS_IOC_FILE_EXTENT_SAME, we probably have to live with.

Michael, I recon man page needs updating.

I'll remove this hunk from the patch.
