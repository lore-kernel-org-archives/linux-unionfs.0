From: Amir Goldstein <amir73il@gmail.com>
Subject: Re: [PATCH v2 00/11] overlayfs constant inode numbers
Date: Tue, 25 Apr 2017 15:05:08 +0300
Message-ID: <CAOQ4uxj5xSFVPx4iXJ-aO3kVrLFz60c+X8BJtyNRophSUEfoGA@mail.gmail.com>
References: <1493025256-27188-1-git-send-email-amir73il@gmail.com> <20170425115257.GA11500@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-unionfs-owner@vger.kernel.org>
Received: from mail-oi0-f68.google.com ([209.85.218.68]:36341 "EHLO
        mail-oi0-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1171621AbdDYMFJ (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Tue, 25 Apr 2017 08:05:09 -0400
In-Reply-To: <20170425115257.GA11500@redhat.com>
Sender: linux-unionfs-owner@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org
To: Vivek Goyal <vgoyal@redhat.com>
Cc: Miklos Szeredi <miklos@szeredi.hu>, Al Viro <viro@zeniv.linux.org.uk>, linux-unionfs@vger.kernel.org, linux-fsdevel <linux-fsdevel@vger.kernel.org>

On Tue, Apr 25, 2017 at 2:52 PM, Vivek Goyal <vgoyal@redhat.com> wrote:
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
>>
>> For the case of *all* layers on same fs, overlayfs also gains:
>> - Persistent inode numbers for directories
>> - Correct results for du -x
>>
>> Consistcy of stat(2) st_ino with readdir(3) d_ino is NOT addressed by
>> this series. It will be addressed for the 'samefs' configuration by the
>> follow up 'stable inode' work, which is also going to address preserving
>> hardlinks on copy up.
>
> Hi Amir,
>
> We need to update Documentation/filesystems/overlayfs.txt as well to
> reflect new semantics of reporting st_dev and st_ino?
>

Of course need to! I'll do that.
Thanks!
