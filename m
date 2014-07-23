From: Miklos Szeredi <miklos@szeredi.hu>
Subject: Re: overlayfs v22 on kernel 3.15.5
Date: Wed, 23 Jul 2014 15:33:39 +0200
Message-ID: <CAJfpeguZssnTxfp62VQNHOMdxDB3EC9ZOef7Qx_CVcJ9AuJG3g@mail.gmail.com>
References: <CAJfpeguH=BmevY+SM8HKBATS7B+htcX7_WLRiMFmypW_D-424Q@mail.gmail.com>
	<3a4b4cc25d1a8325934ba439d4777c35.squirrel@webmail.univie.ac.at>
	<CAJfpegs1_iTJJGvLddyF=-L9YreVCzbDL-Pum70FTO6W+MvozQ@mail.gmail.com>
	<CAJfpegubZyar3JxYg7OxFVa1O3xWoMqaHiRUS_eME_OCzv6QFA@mail.gmail.com>
	<207df75d465c4b3fe95b6a90f3531905.squirrel@webmail.univie.ac.at>
	<CAJfpegsc4swQ2e7LfKbzHYCoa3thvetLhydzqr1My2PJr=Myag@mail.gmail.com>
	<cea39652198f0108e2a026450bd74c7b.squirrel@webmail.univie.ac.at>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-unionfs-owner@vger.kernel.org>
Received: from mail-qa0-f43.google.com ([209.85.216.43]:59357 "EHLO
	mail-qa0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751774AbaGWNdk (ORCPT
	<rfc822;linux-unionfs@vger.kernel.org>);
	Wed, 23 Jul 2014 09:33:40 -0400
Received: by mail-qa0-f43.google.com with SMTP id w8so1222898qac.2
        for <linux-unionfs@vger.kernel.org>; Wed, 23 Jul 2014 06:33:40 -0700 (PDT)
In-Reply-To: <cea39652198f0108e2a026450bd74c7b.squirrel@webmail.univie.ac.at>
Sender: linux-unionfs-owner@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org
To: Klaus Kreil <klaus.kreil@univie.ac.at>
Cc: linux-unionfs@vger.kernel.org

On Wed, Jul 23, 2014 at 2:15 PM, Klaus Kreil <klaus.kreil@univie.ac.at> wrote:
> On Mi, 23.07.2014, 14:02, Miklos Szeredi wrote:
>> On Wed, Jul 23, 2014 at 1:57 PM, Klaus Kreil <klaus.kreil@univie.ac.at>
>> wrote:
>>
>>>> You need to give absolute paths:
>>>>
>>>> mount -t overlayfs overlayfs -o
>>>> lowerdir=/mnt/root_ro,upperdir=/mnt/root_rw/upper,workdir=/mnt/root_rw/work
>>>> /mnt/root
>>>>
>>> Thanks Miklos,
>>> I had tried that before, but that did not/does not work as well. The new
>>> command (adjusted to my environment and from within the rescue-shell and
>>> all within a single line) was:
>>> # mount -t overlayfs overlayfs -o
>>> lowerdir=/mnt/root_ro,upperdir=/mnt/root_rw,workdir=/mnt/root_rw/.work
>>> /mnt/root
>>>
>>> The new error message from dmesg now reads:
>>> [ 1369.069178] overlayfs: workdir and upperdir must be separate subtrees
>>
>> Exactly. Observe that I used upperdir=/mnt/root_rw/upper.
> I see what you mean and I have to admit, that slipped my eye.
>
> This however triggers an additional question: Would this now require me to
> create an new "virtual" root directory (in your case named "upper") on my
> upperdir filesystem and move everything that was in the real root of the
> existing upperdir filesystem to the new virtual root directory?

Yes.  And in adition you need to run the following script (upperdir
given as a single argument) to convert whiteouts from the old format
to the new:

--- overlayfs-fixup.sh ---
#! /bin/bash

upper=$1
tmpdir=`mktemp -d`
tmp=$tmpdir/wh
find "$upper" -type l -print0 | while IFS= read -r -d $'\0' name; do
        iswh=`getfattr -h -ntrusted.overlay.whiteout --only-values
"$name" 2> /dev/null`
        if test "$iswh" = y; then
                echo "changing whiteout <$name> from symlink to chardev"
                mknod -m0 $tmp c 0 0
                mv -f $tmp "$name"
        fi
done
rmdir $tmpdir
--- cut here ---

> In other words now - and contrary to the old behaviour - overlaying one
> root directory of a filesystem onto another root directory of another
> filesystem is no longer possible.

Not at this time.

> If that's the case, I guess lost+found should nevertheless stay in the
> real root directory of the upperdir?

Yes.

>
> Furthermore that would als mean that the workdir is never visible from
> within the combined tree and therefore I could go away with the .work and
> rename the workdir to work.

Yes.

Thanks,
Miklos
