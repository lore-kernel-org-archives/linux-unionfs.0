From: Miklos Szeredi <miklos@szeredi.hu>
Subject: Re: [PATCH] vfs: fix vfs_clone_file_range() for overlayfs files
Date: Thu, 3 Nov 2016 21:57:14 +0100
Message-ID: <CAJfpegue2=jjFMdkVw0njcn=wDLnwzABikQ03s_vdKZb=ZtEcg@mail.gmail.com>
References: <1477510441-24861-1-git-send-email-amir73il@gmail.com>
 <CAJfpegtfa5fBozu7GFFtB+eEHKxdmsg6byysVcLGiWuXHtfL2w@mail.gmail.com>
 <CAOQ4uxixNBOM3jmJKpp6q33kO3hbG1wYTPCj6Pp7ghJ0B-zvtw@mail.gmail.com> <CAOQ4uxgu=6gzno3u6r2_CSRnGGwsRMWnvt_n4JwGbCre=g8hNA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-unionfs-owner@vger.kernel.org>
Received: from mail-oi0-f68.google.com ([209.85.218.68]:32885 "EHLO
        mail-oi0-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1758308AbcKCU5Q (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Thu, 3 Nov 2016 16:57:16 -0400
Received: by mail-oi0-f68.google.com with SMTP id x4so8859660oix.0
        for <linux-unionfs@vger.kernel.org>; Thu, 03 Nov 2016 13:57:16 -0700 (PDT)
In-Reply-To: <CAOQ4uxgu=6gzno3u6r2_CSRnGGwsRMWnvt_n4JwGbCre=g8hNA@mail.gmail.com>
Sender: linux-unionfs-owner@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org
To: Amir Goldstein <amir73il@gmail.com>
Cc: Al Viro <viro@zeniv.linux.org.uk>, Christoph Hellwig <hch@lst.de>, "linux-unionfs@vger.kernel.org" <linux-unionfs@vger.kernel.org>, linux-fsdevel <linux-fsdevel@vger.kernel.org>

On Thu, Nov 3, 2016 at 8:02 PM, Amir Goldstein <amir73il@gmail.com> wrote:
> On Fri, Oct 28, 2016 at 6:25 PM, Amir Goldstein <amir73il@gmail.com> wrote:
>> On Fri, Oct 28, 2016 at 5:25 PM, Miklos Szeredi <miklos@szeredi.hu> wrote:
>>> On Wed, Oct 26, 2016 at 9:34 PM, Amir Goldstein <amir73il@gmail.com> wrote:
>>>> With overlayfs, it is wrong to compare file_inode(inode)->i_sb
>>>> of regular files with those of non-regular files, because the
>>>> former reference the real (upper/lower) sb and the latter reference
>>>> the overlayfs sb.
>>>>
>>>> Move the test for same super block after the sanity tests for
>>>> clone range of directory and non-regular file.
>>>
>>> Better:  compare ->f_path.dentry->d_sb instead of file_inode()->i_sb.
>>> We don't want to be mixing files that come from overlayfs and ones
>>> that come from the underlying layers.
>>
>> That's not a good option.
>> When source file is in lower and dest file is in upper, then clone range
>> should go forward iff both lower and upper inodes are on the same sb.
>> The test as it is checks for this properly.
>>
>
> Ping.
>
> Do you have any more question about this change?
> Do you mind queuing this up for next along with the rest of the
> clone_file_range() changes?

Applied and pushed to #overlayfs-next.

Thanks,
Miklos
