From: Miklos Szeredi <miklos@szeredi.hu>
Subject: Re: persistent overlay inode nlink
Date: Mon, 19 Jun 2017 11:06:26 +0200
Message-ID: <CAJfpegv0UJ4H=064nc5Gy_ii_NF_ymxVHRwNdRbWQSik+dD3qw@mail.gmail.com>
References: <CAOQ4uxivUZ=SNXNgdVRxCmfrjkEu-1qVB1owxtwzsbqPnTA_3A@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-unionfs-owner@vger.kernel.org>
Received: from mail-oi0-f53.google.com ([209.85.218.53]:33100 "EHLO
        mail-oi0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752386AbdFSJG1 (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Mon, 19 Jun 2017 05:06:27 -0400
Received: by mail-oi0-f53.google.com with SMTP id p66so17963763oia.0
        for <linux-unionfs@vger.kernel.org>; Mon, 19 Jun 2017 02:06:27 -0700 (PDT)
In-Reply-To: <CAOQ4uxivUZ=SNXNgdVRxCmfrjkEu-1qVB1owxtwzsbqPnTA_3A@mail.gmail.com>
Sender: linux-unionfs-owner@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org
To: Amir Goldstein <amir73il@gmail.com>
Cc: Al Viro <viro@zeniv.linux.org.uk>, "linux-unionfs@vger.kernel.org" <linux-unionfs@vger.kernel.org>, linux-fsdevel <linux-fsdevel@vger.kernel.org>

On Mon, Jun 19, 2017 at 10:45 AM, Amir Goldstein <amir73il@gmail.com> wrote:
> On Sat, Jun 10, 2017 at 1:56 AM, Amir Goldstein <amir73il@gmail.com> wrote:
>> On Fri, Jun 9, 2017 at 4:14 PM, Miklos Szeredi <miklos@szeredi.hu> wrote:
>>> On Fri, Jun 9, 2017 at 1:49 PM, Miklos Szeredi <miklos@szeredi.hu> wrote:
>>>> On Fri, Jun 9, 2017 at 11:38 AM, Amir Goldstein <amir73il@gmail.com> wrote:
>>>
>>>> The challenge is in accounting the number of link-ups atomically with
>>>> the link-up itself.  No ideas off-hand.
>>>
>>> Following would work I think:
>>>
>>> - copy up to indexdir (it now has st_nlink == 1)
>>> - set overlay.nlinkup to "1-2"
>>>   + the first number indicates the target number of linkups
>>>   + the second indicates the target st_nlink on the file
>>> - fsync the file (hopefully this writes the xattrs as well as the data)
>>> - link the file from indexdir to upper
>>> - set overlay.nlinkup to "1"
>>>    + this indicates that the linkup was finished and number of linkups is 1.
>>>
>>
>> Or like this:
>>
>> struct ovl_nlink_adjust {
>>   int nlink_diff;
>>   bool from_lower;
>> }
>>
>> Init overlay inode:
>> overlay_nlink := (from_lower ? lower_nlink : upper_nlink) + nlink_diff
>>
>> Copy/link up:
>> - take ovl_inode lock
>> - set overlay.nlink { (overlay_nlink - lower_link), true }
>> - link index (won't change diff from lower inode nlink on fail/success)
>>
>> Unlink/link/rename:
>> - take ovl_inode lock
>> - set overlay.nlink { (overlay_nlink - upper_nlink), false }
>> - unlink/link/rename (won't change diff from upper nlink on fail/success)

What I don't like about this is how it ends up in different states
depending on the last operation.  How about moving "set overlay.nlink
{ (overlay_nlink - upper_nlink), false }" into the link-up region as
well?

>> I don't think fsync matters to this game.
>> I'd be surprised if the nlink changing operations (link/unlink/rename) can be
>> reordered with the setxattr operations on a power fail safe fs.

Why not?  I know data changes can be reordered around rename without
an fsync, for example.

Thanks,
Miklos
