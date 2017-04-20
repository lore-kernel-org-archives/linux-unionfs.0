From: Amir Goldstein <amir73il@gmail.com>
Subject: Re: [RFC][PATCH 00/13] overlayfs stable inodes
Date: Thu, 20 Apr 2017 08:43:28 +0300
Message-ID: <CAOQ4uxhN2J+T-WZD=GMc8t51Dnp1q+kW+nJaRLV=Kxj+nON-6A@mail.gmail.com>
References: <1492387183-18847-1-git-send-email-amir73il@gmail.com>
 <CAOQ4uxgtiDr9GEgjAsRHLeOo=HTobf-qwZ0bZLyjrhLyNiTt4A@mail.gmail.com>
 <CAJfpegsQTd8SgHRFcuEJMgjLjNW45vyuUiPPKZLC4bv_OJOmGA@mail.gmail.com>
 <CAOQ4uxh1VmeB1WGuP4sXyzR0oeQ_ux2hd+9vXM=UbsL+cxTwXQ@mail.gmail.com>
 <CAJfpegumzAZbvyWgfYaLtG1L7LF_Ob2zgA55Hz5H5Ctv7DoJ=Q@mail.gmail.com>
 <CAOQ4uxi0vRsyY2jrS_baaZ3n+d0Fx+6fDWj2Wm=4ZEGAZGHzDQ@mail.gmail.com>
 <CAJfpegsDMfM066PvoQup5SwS3exmfM23+2EWiUsuGROZvN3H_g@mail.gmail.com>
 <CAOQ4uxjWvgKr02-D-HwnGwrpoq165W++aOxddRUHhDFvv8bB7w@mail.gmail.com>
 <20170419225837.GE5205@birch.djwong.org> <940D64D5-55A8-45D1-844F-41872B2FEBB6@dilger.ca>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-unionfs-owner@vger.kernel.org>
Received: from mail-oi0-f42.google.com ([209.85.218.42]:34006 "EHLO
        mail-oi0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S941502AbdDTFn3 (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Thu, 20 Apr 2017 01:43:29 -0400
In-Reply-To: <940D64D5-55A8-45D1-844F-41872B2FEBB6@dilger.ca>
Sender: linux-unionfs-owner@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: "Darrick J. Wong" <darrick.wong@oracle.com>, Al Viro <viro@zeniv.linux.org.uk>, "linux-unionfs@vger.kernel.org" <linux-unionfs@vger.kernel.org>, linux-fsdevel <linux-fsdevel@vger.kernel.org>, Vivek Goyal <vgoyal@redhat.com>, Andreas Dilger <adilger@dilger.ca>

On Thu, Apr 20, 2017 at 2:15 AM, Andreas Dilger <adilger@dilger.ca> wrote:
> On Apr 19, 2017, at 4:58 PM, Darrick J. Wong <darrick.wong@oracle.com> wrote:
>>
>> On Wed, Apr 19, 2017 at 06:17:15PM +0300, Amir Goldstein wrote:
>>> On Wed, Apr 19, 2017 at 6:01 PM, Miklos Szeredi <miklos@szeredi.hu> wrote:
>>>> On Wed, Apr 19, 2017 at 4:46 PM, Amir Goldstein <amir73il@gmail.com> wrote:
>>>>> Well, if you are lucky you can run into a filesystem that exports
>>>>> a file handle of type FILEID_INO32_GEN, then you *know* you're
>>>>> good to go. ext* will do that and xfs that was forever mounted with
>>>>> -o inode32.
>>>>> Even with xfs -o inode64, it will not use the MSB ino bits unless
>>>>> you are in the exabytes fs sizes.
>>
>> I think it only takes really big AGs for it to start using the >32 bit parts.
>>
>>>>
>>>> Could filesystems export a max-ino property in their sb?  That would
>>>> help with doing this properly.
>>>>
>>>
>>> Sounds reasonable, but as max-ino usually derived from filesystem size
>>> and filesystems can grow size online, you will need to query both the
>>> 'soft' ino limit (without growing fs) and the 'hard' ino limit.
>>>
>>> Darrick,
>>>
>>> Are there bits in GETFSMAP to provide this info?
>>
>> Nope.  I suppose there could be a way to find out the theoretical
>> maximum inode number for a filesystem (statvfsx, etc.) but on the other
>> hand I can also see the other fs developers not wanting to expose that
>> information for fear that someone will start using the upper bits (inode
>> numbers should just be a 64-bit cookie we hand to users, right?) and
>> then they'll have to resort to all sorts of trickery to avoid breaking
>> things if they ever /do/ want to use those high bits that have been
>> claimed by someone else.
>
> I recall there was a similar issue with GlusterFS assuming only 32-bit
> readdir cookies on ext4, and stashing some information in the high bits,
> but that broke when ext4 moved to 64-bit readdir cookies to avoid hash
> collisions on "normal sized" directories (above ~32k entries).
>
> I'd agree that it is the filesystem's prerogative to use any/all of the
> 64-bit inode number when it wants, and stacking filesystems shouldn't
> try to usurp those bits for something else, only to suffer later on.
>
> There is already some interest to add 64-bit inode numbers for ext4, and
> it may allocate inode numbers sparsely, so just because the filesystem has
> 2^33 inodes in it doesn't imply that the highest possible inum is 2^33,
> but could instead be 2^48 or something else entirely.
>

Miklos,

As you can see, fs developers are quite possessive of their reserved bits ;-)
and probably for good reasons too.

I think our best value solution would be to go with virtual dev ids
for lowers layers in the non-same-fs case.

Then we can add an opt-in mount/config option 'masqino' that will use
as few MSB as needed to masquerade 64bit overlay inode numbers
and return EOVERFLOW for stat() if those bits turn up used by
underlying fs, as you proposed.

For the special case of handle file type FILEID_INO32_GEN, we
can automatically turn on 'masqino'. This special case is still quite
common (i.e. ext4). Even if and when ext4 adds 64bit inode support,
like with the case of xfs, legacy on-disk formatted fs, would still
return  handle type FILEID_INO32_GEN.

Amir.
