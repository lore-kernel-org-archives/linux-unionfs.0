From: Amir Goldstein <amir73il@gmail.com>
Subject: Re: [RFC][PATCH 00/13] overlayfs stable inodes
Date: Wed, 19 Apr 2017 18:17:15 +0300
Message-ID: <CAOQ4uxjWvgKr02-D-HwnGwrpoq165W++aOxddRUHhDFvv8bB7w@mail.gmail.com>
References: <1492387183-18847-1-git-send-email-amir73il@gmail.com>
 <CAOQ4uxgtiDr9GEgjAsRHLeOo=HTobf-qwZ0bZLyjrhLyNiTt4A@mail.gmail.com>
 <CAJfpegsQTd8SgHRFcuEJMgjLjNW45vyuUiPPKZLC4bv_OJOmGA@mail.gmail.com>
 <CAOQ4uxh1VmeB1WGuP4sXyzR0oeQ_ux2hd+9vXM=UbsL+cxTwXQ@mail.gmail.com>
 <CAJfpegumzAZbvyWgfYaLtG1L7LF_Ob2zgA55Hz5H5Ctv7DoJ=Q@mail.gmail.com>
 <CAOQ4uxi0vRsyY2jrS_baaZ3n+d0Fx+6fDWj2Wm=4ZEGAZGHzDQ@mail.gmail.com> <CAJfpegsDMfM066PvoQup5SwS3exmfM23+2EWiUsuGROZvN3H_g@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-unionfs-owner@vger.kernel.org>
Received: from mail-yb0-f193.google.com ([209.85.213.193]:33621 "EHLO
        mail-yb0-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S937001AbdDSPRW (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Wed, 19 Apr 2017 11:17:22 -0400
In-Reply-To: <CAJfpegsDMfM066PvoQup5SwS3exmfM23+2EWiUsuGROZvN3H_g@mail.gmail.com>
Sender: linux-unionfs-owner@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: Al Viro <viro@zeniv.linux.org.uk>, "linux-unionfs@vger.kernel.org" <linux-unionfs@vger.kernel.org>, linux-fsdevel <linux-fsdevel@vger.kernel.org>, Vivek Goyal <vgoyal@redhat.com>, "Darrick J. Wong" <darrick.wong@oracle.com>

On Wed, Apr 19, 2017 at 6:01 PM, Miklos Szeredi <miklos@szeredi.hu> wrote:
> On Wed, Apr 19, 2017 at 4:46 PM, Amir Goldstein <amir73il@gmail.com> wrote:
>> Well, if you are lucky you can run into a filesystem that exports
>> a file handle of type FILEID_INO32_GEN, then you *know* you're
>> good to go. ext* will do that and xfs that was forever mounted with
>> -o inode32.
>> Even with xfs -o inode64, it will not use the MSB ino bits unless
>> you are in the exabytes fs sizes.
>
> Could filesystems export a max-ino property in their sb?  That would
> help with doing this properly.
>

Sounds reasonable, but as max-ino usually derived from filesystem size
and filesystems can grow size online, you will need to query both the
'soft' ino limit (without growing fs) and the 'hard' ino limit.

Darrick,

Are there bits in GETFSMAP to provide this info?
