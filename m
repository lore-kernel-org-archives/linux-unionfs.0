From: Amir Goldstein <amir73il@gmail.com>
Subject: Re: persistent overlay inode nlink
Date: Mon, 19 Jun 2017 13:12:14 +0300
Message-ID: <CAOQ4uxiEAXL=ZC=SP7U64my2JUije3MncxJ5uq6JVyUsN9QdnQ@mail.gmail.com>
References: <CAOQ4uxivUZ=SNXNgdVRxCmfrjkEu-1qVB1owxtwzsbqPnTA_3A@mail.gmail.com>
 <CAJfpegv0UJ4H=064nc5Gy_ii_NF_ymxVHRwNdRbWQSik+dD3qw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-unionfs-owner@vger.kernel.org>
Received: from mail-oi0-f54.google.com ([209.85.218.54]:34735 "EHLO
        mail-oi0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753966AbdFSKMP (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Mon, 19 Jun 2017 06:12:15 -0400
In-Reply-To: <CAJfpegv0UJ4H=064nc5Gy_ii_NF_ymxVHRwNdRbWQSik+dD3qw@mail.gmail.com>
Sender: linux-unionfs-owner@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: Al Viro <viro@zeniv.linux.org.uk>, "linux-unionfs@vger.kernel.org" <linux-unionfs@vger.kernel.org>, linux-fsdevel <linux-fsdevel@vger.kernel.org>

On Mon, Jun 19, 2017 at 12:06 PM, Miklos Szeredi <miklos@szeredi.hu> wrote:
> On Mon, Jun 19, 2017 at 10:45 AM, Amir Goldstein <amir73il@gmail.com> wrote:
>> On Sat, Jun 10, 2017 at 1:56 AM, Amir Goldstein <amir73il@gmail.com> wrote:
>>> On Fri, Jun 9, 2017 at 4:14 PM, Miklos Szeredi <miklos@szeredi.hu> wrote:
>>>> On Fri, Jun 9, 2017 at 1:49 PM, Miklos Szeredi <miklos@szeredi.hu> wrote:
>>>>> On Fri, Jun 9, 2017 at 11:38 AM, Amir Goldstein <amir73il@gmail.com> wrote:
>>>>
>>>>> The challenge is in accounting the number of link-ups atomically with
>>>>> the link-up itself.  No ideas off-hand.
>>>>
>>>> Following would work I think:
>>>>
>>>> - copy up to indexdir (it now has st_nlink == 1)
>>>> - set overlay.nlinkup to "1-2"
>>>>   + the first number indicates the target number of linkups
>>>>   + the second indicates the target st_nlink on the file
>>>> - fsync the file (hopefully this writes the xattrs as well as the data)
>>>> - link the file from indexdir to upper
>>>> - set overlay.nlinkup to "1"
>>>>    + this indicates that the linkup was finished and number of linkups is 1.
>>>>
>>>
>>> Or like this:
>>>
>>> struct ovl_nlink_adjust {
>>>   int nlink_diff;
>>>   bool from_lower;
>>> }
>>>
>>> Init overlay inode:
>>> overlay_nlink := (from_lower ? lower_nlink : upper_nlink) + nlink_diff
>>>
>>> Copy/link up:
>>> - take ovl_inode lock
>>> - set overlay.nlink { (overlay_nlink - lower_link), true }
>>> - link index (won't change diff from lower inode nlink on fail/success)
>>>
>>> Unlink/link/rename:
>>> - take ovl_inode lock
>>> - set overlay.nlink { (overlay_nlink - upper_nlink), false }
>>> - unlink/link/rename (won't change diff from upper nlink on fail/success)
>
> What I don't like about this is how it ends up in different states
> depending on the last operation.  How about moving "set overlay.nlink
> { (overlay_nlink - upper_nlink), false }" into the link-up region as
> well?
>

Sure. that's not a problem.
But then I have 2 options in case get_inode finds diff from lower:
- either set it right a way to diff from upper
- or let the next copyup/nlink operation store the consistent state

I guess you prefer the former?

Note that I do have to change the unlink/rename/link operations
to grab the ovl_inode lock anyway, so at least w.r.t. code complexity
it is simple to add those ovl_set_nlink() calls. to unlink/rename/link.

>>> I don't think fsync matters to this game.
>>> I'd be surprised if the nlink changing operations (link/unlink/rename) can be
>>> reordered with the setxattr operations on a power fail safe fs.
>
> Why not?  I know data changes can be reordered around rename without
> an fsync, for example.
>

Certainly, data changes are not journalled in common ext4/xfs configurations
and the data=ordered of ext4 guaranties only that data is flushed
before *related*
metadata is journalled and does not guaranty at all that data/metadata
are flushed
in order that they were changed.

The thing with rename vs. data change is that rename doesn't necessarily
change the renamed inode, so journalling the rename operation doesn't
need to journal the inode itself and therefore, there are no *related* metadata
changes that require flushing the inode data.

But unlike rename(taget, foo), the operations unlink(target),
link(target, foo) and
rename(foo, target) all change nlink of target inode and therefore must journal
the target inode, the same target inode whose xattr are being written before and
after the nlink change, and which also implies ctime change.

So I'm pretty sure that reordering xattr writes with nlink change of
the target inode
are not possible with the traditional journalling file system, but I
don't know of any
written rules about this.

Do you suggest that we call vfs_fsync() at the end of ovl_copy_up_inode()
after ovl_set_origin() instead of only at the end of ovl_copy_up_data()?
I am not at ease with the performance overhead this could generate, but
perhaps there is no reason for concern.

Amir.
