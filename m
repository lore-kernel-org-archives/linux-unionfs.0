From: Amir Goldstein <amir73il@gmail.com>
Subject: Re: [RFC][PATCH 11/11] xfs: use common file type conversion
Date: Tue, 20 Dec 2016 08:17:51 +0200
Message-ID: <CAOQ4uxhsTqGd7Q18NG8nAGQFrbYRzZJd_A9My8AyjJGbyPvh4Q@mail.gmail.com>
References: <1482178268-22883-1-git-send-email-amir73il@gmail.com>
 <1482178268-22883-12-git-send-email-amir73il@gmail.com> <20161219215539.GD7311@birch.djwong.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-unionfs-owner@vger.kernel.org>
Received: from mail-oi0-f68.google.com ([209.85.218.68]:36116 "EHLO
        mail-oi0-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1757364AbcLTGRx (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Tue, 20 Dec 2016 01:17:53 -0500
In-Reply-To: <20161219215539.GD7311@birch.djwong.org>
Sender: linux-unionfs-owner@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: Jan Kara <jack@suse.com>, Theodore Ts'o <tytso@mit.edu>, Dave Chinner <david@fromorbit.com>, Chris Mason <clm@fb.com>, Boaz Harrosh <boaz@plexistor.com>, Jaegeuk Kim <jaegeuk@kernel.org>, Ryusuke Konishi <konishi.ryusuke@lab.ntt.co.jp>, Mark Fasheh <mfasheh@versity.com>, Evgeniy Dushistov <dushistov@mail.ru>, Al Viro <viro@zeniv.linux.org.uk>, linux-fsdevel <linux-fsdevel@vger.kernel.org>, Miklos Szeredi <miklos@szeredi.hu>, linux-unionfs@vger.kernel.org

[adding linux-unionfs]

On Mon, Dec 19, 2016 at 11:55 PM, Darrick J. Wong
<darrick.wong@oracle.com> wrote:
> On Mon, Dec 19, 2016 at 10:11:08PM +0200, Amir Goldstein wrote:
>> deduplicate the xfs file type conversion implementation.
>>
>> xfs readdir code may expose DT_WHT type to user if that
>> type was set on disk, but xfs code never set a file type
>> of WHT on disk.
>>
>> If it is acceptable to expose to user DT_UNKNOWN in case
>> WHT type somehow got to disk, then xfs_dir3_filetype_table
>> could also be replaced with the common fs_dtype() helper.
>
> AFAIK XFS has never actually written XFS_DIR3_FT_WHT to disk.
> I see that overlayfs whiteouts are now some sort of weird
> chardev with rdev == 0, so I guess overlayfs doesn't either...?
>

Nope. overlayfs calls vfs_whiteout() which calls i_op->mknod(.. S_IFCHR, 0)
So AFAIK, there is no evidence of DT_WHT even being use in Linux.

>From overlayfs perspective, it could have been nice if conversion functions
took mode+rdev instead of just mode and produced the DT_WHT value,
but it is not all that easy to know how applications would react to this change.

I suppose there shouldn't be a problem to expose DT_WHT d_type in
iterate_dir() and convert it to DT_CHR in getdents' filldir().
It will be beneficial to overlayfs in case of a directory with tons of
whiteouts,
not having to stat all those inodes is a big win.
Not sure how common this use case is, but it is quite easy for users to
get to this sort of state when using inefficient container layouts.

How about xfs_repair? will it complain if it sees DT_WHT and a chardev
inode? does it check at all that the type and mode match?

Being able to play with these sort of mode+rdev+? generic conversions
is one of the reasons I proposed the common DT_ implementation.

Since XFS already has that WHT bit reserved on-disk I may as well
post some POC to use it correctly, so overlayfs can benefit from DT_WHT
in the best case scenario.

Amir.
