From: Amir Goldstein <amir73il@gmail.com>
Subject: Re: persistent overlay inode nlink
Date: Mon, 19 Jun 2017 11:45:01 +0300
Message-ID: <CAOQ4uxivUZ=SNXNgdVRxCmfrjkEu-1qVB1owxtwzsbqPnTA_3A@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-unionfs-owner@vger.kernel.org>
Received: from mail-oi0-f68.google.com ([209.85.218.68]:34531 "EHLO
        mail-oi0-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750952AbdFSIpC (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Mon, 19 Jun 2017 04:45:02 -0400
Sender: linux-unionfs-owner@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: Al Viro <viro@zeniv.linux.org.uk>, "linux-unionfs@vger.kernel.org" <linux-unionfs@vger.kernel.org>, linux-fsdevel <linux-fsdevel@vger.kernel.org>

On Sat, Jun 10, 2017 at 1:56 AM, Amir Goldstein <amir73il@gmail.com> wrote:
> On Fri, Jun 9, 2017 at 4:14 PM, Miklos Szeredi <miklos@szeredi.hu> wrote:
>> On Fri, Jun 9, 2017 at 1:49 PM, Miklos Szeredi <miklos@szeredi.hu> wrote:
>>> On Fri, Jun 9, 2017 at 11:38 AM, Amir Goldstein <amir73il@gmail.com> wrote:
>>
>>> The challenge is in accounting the number of link-ups atomically with
>>> the link-up itself.  No ideas off-hand.
>>
>> Following would work I think:
>>
>> - copy up to indexdir (it now has st_nlink == 1)
>> - set overlay.nlinkup to "1-2"
>>   + the first number indicates the target number of linkups
>>   + the second indicates the target st_nlink on the file
>> - fsync the file (hopefully this writes the xattrs as well as the data)
>> - link the file from indexdir to upper
>> - set overlay.nlinkup to "1"
>>    + this indicates that the linkup was finished and number of linkups is 1.
>>
>
> Or like this:
>
> struct ovl_nlink_adjust {
>   int nlink_diff;
>   bool from_lower;
> }
>
> Init overlay inode:
> overlay_nlink := (from_lower ? lower_nlink : upper_nlink) + nlink_diff
>
> Copy/link up:
> - take ovl_inode lock
> - set overlay.nlink { (overlay_nlink - lower_link), true }
> - link index (won't change diff from lower inode nlink on fail/success)
>
> Unlink/link/rename:
> - take ovl_inode lock
> - set overlay.nlink { (overlay_nlink - upper_nlink), false }
> - unlink/link/rename (won't change diff from upper nlink on fail/success)
>
> I don't think fsync matters to this game.
> I'd be surprised if the nlink changing operations (link/unlink/rename) can be
> reordered with the setxattr operations on a power fail safe fs.
>

Miklos,

FYI, I've implemented the scheme above and it seems to work fine:
https://github.com/amir73il/linux/commits/ovl-nlink

Also wrote an xfstest to exercise persistent nlink:
https://github.com/amir73il/xfstests/commits/overlayfs-devel

I'll post persistent nlink along with ovl-hardlink v4 when I am done with
index evict/cleanup.

Amir.
