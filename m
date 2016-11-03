From: Amir Goldstein <amir73il@gmail.com>
Subject: Re: [PATCH] vfs: fix vfs_clone_file_range() for overlayfs files
Date: Thu, 3 Nov 2016 21:02:05 +0200
Message-ID: <CAOQ4uxgu=6gzno3u6r2_CSRnGGwsRMWnvt_n4JwGbCre=g8hNA@mail.gmail.com>
References: <1477510441-24861-1-git-send-email-amir73il@gmail.com>
 <CAJfpegtfa5fBozu7GFFtB+eEHKxdmsg6byysVcLGiWuXHtfL2w@mail.gmail.com> <CAOQ4uxixNBOM3jmJKpp6q33kO3hbG1wYTPCj6Pp7ghJ0B-zvtw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-unionfs-owner@vger.kernel.org>
Received: from mail-wm0-f67.google.com ([74.125.82.67]:34456 "EHLO
        mail-wm0-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751648AbcKCTCI (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Thu, 3 Nov 2016 15:02:08 -0400
In-Reply-To: <CAOQ4uxixNBOM3jmJKpp6q33kO3hbG1wYTPCj6Pp7ghJ0B-zvtw@mail.gmail.com>
Sender: linux-unionfs-owner@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: Al Viro <viro@zeniv.linux.org.uk>, Christoph Hellwig <hch@lst.de>, "linux-unionfs@vger.kernel.org" <linux-unionfs@vger.kernel.org>, linux-fsdevel <linux-fsdevel@vger.kernel.org>

On Fri, Oct 28, 2016 at 6:25 PM, Amir Goldstein <amir73il@gmail.com> wrote:
> On Fri, Oct 28, 2016 at 5:25 PM, Miklos Szeredi <miklos@szeredi.hu> wrote:
>> On Wed, Oct 26, 2016 at 9:34 PM, Amir Goldstein <amir73il@gmail.com> wrote:
>>> With overlayfs, it is wrong to compare file_inode(inode)->i_sb
>>> of regular files with those of non-regular files, because the
>>> former reference the real (upper/lower) sb and the latter reference
>>> the overlayfs sb.
>>>
>>> Move the test for same super block after the sanity tests for
>>> clone range of directory and non-regular file.
>>
>> Better:  compare ->f_path.dentry->d_sb instead of file_inode()->i_sb.
>> We don't want to be mixing files that come from overlayfs and ones
>> that come from the underlying layers.
>
> That's not a good option.
> When source file is in lower and dest file is in upper, then clone range
> should go forward iff both lower and upper inodes are on the same sb.
> The test as it is checks for this properly.
>

Ping.

Do you have any more question about this change?
Do you mind queuing this up for next along with the rest of the
clone_file_range() changes?

It'd be nice to have all xfstests pass for overlayfs on 4.10...

>>
>> BTW, would it be worthwhile adding clone_file_range() support to overlayfs?
>>
>
> There is nothing to add. It works quite well because clone_file_range works
> on inode level. In fact, the entire 'clone' group of xfstests passes
> with overlayfs
> of lower and upper on the same XFS filesystem (with reflink support).
>
> Amir.
