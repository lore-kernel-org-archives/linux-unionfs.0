From: Amir Goldstein <amir73il@gmail.com>
Subject: Re: [PATCH v2 00/20] Overlayfs inodes index
Date: Wed, 7 Jun 2017 21:36:46 +0300
Message-ID: <CAOQ4uxgL5U_bH4BbRdaneCxXs7EPa7==Dcmn4zj+Ahi7=FQdKA@mail.gmail.com>
References: <1496821884-5178-1-git-send-email-amir73il@gmail.com> <20170607171744.GE26995@fieldses.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-unionfs-owner@vger.kernel.org>
Received: from mail-ot0-f196.google.com ([74.125.82.196]:33062 "EHLO
        mail-ot0-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752327AbdFGSgs (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Wed, 7 Jun 2017 14:36:48 -0400
In-Reply-To: <20170607171744.GE26995@fieldses.org>
Sender: linux-unionfs-owner@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org
To: "J. Bruce Fields" <bfields@fieldses.org>
Cc: Miklos Szeredi <miklos@szeredi.hu>, Al Viro <viro@zeniv.linux.org.uk>, overlayfs <linux-unionfs@vger.kernel.org>, linux-fsdevel <linux-fsdevel@vger.kernel.org>

On Wed, Jun 7, 2017 at 8:17 PM, J. Bruce Fields <bfields@fieldses.org> wrote:
> On Wed, Jun 07, 2017 at 10:51:04AM +0300, Amir Goldstein wrote:
>> Miklos,
>>
>> This set is an independent series a top of current overlayfs-next.
>> I yanked all the dependencies from previous postings (consistent d_ino,
>> dir_lock, verify_lower) and included everything needed in this posting.
>>
>> This work introcuding the inodes index opt-in feature, which provides:
>> - Hardlinks are not broken on copy up
>> - Infrastructure for overlayfs NFS export
>
> Minor suggestion: for the lazy readers among us, a quick summary of the
> implementation might be helpful.  (Could take most of it from just
> 05/20?)
>

Heh, for the *very* lazy reader, I'll paste the referred snip from 05/20:
"The index dir will contain hardlinks to upper inodes, named after the
hex representation of their origin lower inodes.
The index dir is going to be used to prevent breaking lower hardlinks
on copy up and to implement overlayfs NFS export."

That's me being very very brief about the what and the why, but nothing
about the how, so here goes:

The challenge with exporting overlayfs handled is that an object can start
its life as a lower inode and transition into an upper inode (copy up).
When the object is lower, the only way to encode it is by encoding the
underlying fs lower inode, say encode(/lower/foo)=0x0001.
The gist of the inodes index concept is that when decoding the handle,
we need to check if the object was copied up.
When an object is copied up, it creates an index entry at:
workdir/index/0001, which is a hardlink to /upper/foo,
so we have a way to get from the lower handle to the upper inode if it
exists.

The same lower -> upper mapping also helps herding a lower hardlinks
bundle with their upper hardlinks bundle and refer to all as a single inode
object. Most of the gritty details are in patches {08,11,18}/20.

With this series, which is aiming for v4.13, NFS export is not there yet,
because lower directories are not yet indexed (and more).
I do, however, have a POC of non-persistent overlay NFS export [1]
with a detailed documentation patch about the missing bits for persistent
handles. I tested this POC with xfstest generic/426.

Hope this summary was quick enough ;-)

Cheers,
Amir.

[1] https://github.com/amir73il/linux/commits/ovl-nfs-export-wip
