From: Amir Goldstein <amir73il@gmail.com>
Subject: Re: [PATCH v2 00/11] overlayfs constant inode numbers
Date: Tue, 25 Apr 2017 15:41:56 +0300
Message-ID: <CAOQ4uxhvx1OqYgDb9g4G4_YTA_e-coSAyg2H09+zpDOkBzJYag@mail.gmail.com>
References: <1493025256-27188-1-git-send-email-amir73il@gmail.com> <20170425121620.GB11500@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-unionfs-owner@vger.kernel.org>
Received: from mail-oi0-f66.google.com ([209.85.218.66]:34554 "EHLO
        mail-oi0-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S945362AbdDYMl5 (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Tue, 25 Apr 2017 08:41:57 -0400
In-Reply-To: <20170425121620.GB11500@redhat.com>
Sender: linux-unionfs-owner@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org
To: Vivek Goyal <vgoyal@redhat.com>
Cc: Miklos Szeredi <miklos@szeredi.hu>, Al Viro <viro@zeniv.linux.org.uk>, linux-unionfs@vger.kernel.org, linux-fsdevel <linux-fsdevel@vger.kernel.org>

On Tue, Apr 25, 2017 at 3:16 PM, Vivek Goyal <vgoyal@redhat.com> wrote:
> On Mon, Apr 24, 2017 at 12:14:05PM +0300, Amir Goldstein wrote:
>> Miklos,
>>
>> Following your comments on the 'stable inodes' series from last week,
>> this series fixes constant inode numbers for stat(2) with any layer
>> configuration.
>>
>> For the case of all *lower* layers on same fs that supports NFS export,
>> redirect by file handle will be used to optimize the lookup of the copy
>> up origin of non-dir inode.
>
> I was trying to run unionmount-testsuite (original from dhowells) and I
> disabled layer check. Looks like empty directory rename test fails.
>
> ***
> *** ./run --ov --ts=0 rename-empty-dir
> ***
> TEST rename-empty-dir.py:10: Rename empty dir and rename back
>  ./run --rename /mnt/a/empty100 /mnt/a/no_dir100
>  /mnt/a/empty100: Unexpected error: Invalid cross-device link
>

Strange... I can't find code in recent times when this used to work
It certainly doesn't look like it should work with kernel v4.10
and redirect_dir=off.
I couldn't the point of regression by looking at the change log.
You'd need to bisect to find the regression patch.

Are you not compiling kernel with redirect_dir?
CONFIG_OVERLAY_FS_REDIRECT_DIR=y

I guess not. If you do compile or mount with -o redirect_dir=on,
you will need some minimal patches to unionmount-testsuite
that set the expectations correctly for directory rename.

The last stable branch I have from testing v4.10 is this:
https://github.com/amir73il/unionmount-testsuite/commits/ovl_rename_dir

But you may as well take my most recent branch for testing const ino:
https://github.com/amir73il/unionmount-testsuite/commits/overlayfs-devel

Amir.
